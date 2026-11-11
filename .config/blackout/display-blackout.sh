#!/bin/sh
# Black out the Studio Display after the Mac has sat idle, and bring it back on the next key press or
# mouse move. It turns the backlight down to its minimum and dims the pixels to black with BetterDisplay
# instead of turning the display off, because display sleep locks the Mac (iPhone Mirroring's
# auto-authentication forces an immediate password) and a locked Mac stops computer use. Screenshots
# don't capture either change, so agents still see the normal screen. Run by the
# com.max.display-blackout LaunchAgent.
set -u

display="Studio Display"
idle_after=${BLACKOUT_IDLE_SECONDS:-600}
interval=5
cli=/opt/homebrew/bin/betterdisplaycli
# The backlight level to restore on wake, kept on disk so a killed run's blackout can be undone.
saved_backlight="${XDG_STATE_HOME:-$HOME/.local/state}/display-blackout/backlight"
noted=0 beat=0 lid= # when the input and heartbeat lines were last logged, and the lid state then
applied= # last state that was set successfully (0 dark, 1 lit); empty until the first one works

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*"; }

# Seconds since the last real keyboard, mouse or trackpad input. The combined session state (0) with any
# input type (0xFFFFFFFF) ignores events that computer use synthesizes, so an agent typing or clicking
# doesn't light the screen. IOHIDSystem's HIDIdleTime and the HID system state (1) reset on those
# events. JXA doesn't define the constants, hence the raw values. A failure reads as active.
idle_seconds() {
  /usr/bin/osascript -l JavaScript -e \
    'ObjC.import("CoreGraphics"); Math.floor($.CGEventSourceSecondsSinceLastEventType(0, 0xFFFFFFFF))' 2>/dev/null
}

# Seconds since any input the HID system saw, synthetic included. Only logged, never used to decide: if
# the screen stays dark after real input, the log shows whether the HID system saw that input at all.
hid_idle_seconds() {
  /usr/sbin/ioreg -c IOHIDSystem -d 4 | awk '/HIDIdleTime/ { print int($NF / 1000000000); exit }'
}

lid_state() { /usr/sbin/ioreg -r -k AppleClamshellState -d 1 | awk '/AppleClamshellState/ { print $NF; exit }'; }

get() { "$cli" get --name="$display" --"$1" 2>/dev/null; }
set_value() { "$cli" set --name="$display" --"$1"="$2" >/dev/null 2>&1; }
is_number() { case $1 in '' | *[!0-9.]* | *.*.*) return 1 ;; esac; }
# Below 0.01 counts as off: after being set to 0, the backlight sometimes reads back as 0.001.
is_off() { is_number "$1" && awk -v v="$1" 'BEGIN { exit !(v < 0.01) }'; }

# Any change to the backlight resets BetterDisplay's software brightness to full, so the backlight is
# always set first and the pixels second, both when going dark and when coming back.
# The backlight is only turned down once its level is safely on disk, so there's always one to restore.
# A level saved earlier is kept, since the backlight may already be down from a killed run.
go_dark() {
  level=$(cat "$saved_backlight" 2>/dev/null)
  if ! is_number "$level"; then
    level=$(get hardwareBrightness)
    is_number "$level" || return 1
    mkdir -p "$(dirname "$saved_backlight")" &&
      echo "$level" > "$saved_backlight.tmp" &&
      mv "$saved_backlight.tmp" "$saved_backlight" || return 1
  fi
  set_value hardwareBrightness 0
  set_value softwareBrightness 0
}

# Fails if either value couldn't be set, so the loop tries again instead of leaving the backlight low.
go_lit() {
  restored=0
  if [ -e "$saved_backlight" ]; then
    level=$(cat "$saved_backlight")
    if ! is_number "$level"; then
      rm -f "$saved_backlight"
    elif set_value hardwareBrightness "$level"; then
      rm -f "$saved_backlight"
    else
      restored=1
    fi
  fi
  set_value softwareBrightness 1 && return "$restored"
}

# Leave the display lit when launchd stops the agent. If it can't be reached, the next start restores it.
trap 'go_lit; exit 0' INT TERM

log "watching $display, blackout after ${idle_after}s idle"
while :; do
  idle=$(idle_seconds)
  if [ "${idle:-0}" -ge "$idle_after" ]; then target=0; else target=1; fi
  # A failed set (display undocked, BetterDisplay not running) is retried every pass until it works.
  # The empty start value also undoes a blackout a killed run left behind, since BetterDisplay
  # remembers the dimming and the saved backlight level stays on disk until it's restored. A transition
  # that only half works leaves the state unknown, so either target is tried again next pass.
  if [ "$target" != "$applied" ]; then
    applied=
    if [ "$target" = 0 ]; then
      if go_dark; then
        applied=0 beat=$(date +%s) lid=$(lid_state)
        log "blacked out after ${idle}s idle (backlight was $(cat "$saved_backlight" 2>/dev/null || echo unknown))"
      fi
    elif go_lit; then
      applied=1
      log "lit (session idle ${idle}s, HID idle $(hid_idle_seconds)s)"
    fi
  else
    # While dark, read the real values and undo anything that lit the screen, such as automatic
    # brightness raising the backlight as the room changes.
    if [ "$target" = 0 ]; then
      backlight=$(get hardwareBrightness)
      pixels=$(get softwareBrightness)
      if is_number "$backlight" && ! is_off "$backlight"; then
        set_value hardwareBrightness 0 && set_value softwareBrightness 0 &&
          log "blacked out again (backlight was $backlight)"
      elif is_number "$pixels" && ! is_off "$pixels"; then
        set_value softwareBrightness 0 && log "blacked out again (software brightness was $pixels)"
      fi
      # Diagnostics for a screen that stays dark after real input. Input the HID system saw but the
      # session signal didn't is either computer use or real input going missing; logged once a minute
      # at most. A heartbeat every 10 minutes shows the loop is alive, and lid changes are logged since
      # opening the lid resets the dimming.
      hid=$(hid_idle_seconds) now=$(date +%s)
      if [ "${hid:-$idle}" -le "$interval" ] && [ $((now - noted)) -ge 60 ]; then
        log "HID input the session idle signal didn't count (HID idle ${hid}s, session idle ${idle}s)"
        noted=$now
      fi
      if [ $((now - beat)) -ge 600 ]; then
        log "still dark (session idle ${idle}s, HID idle ${hid:-unreadable}s)"
        beat=$now
      fi
      state=$(lid_state)
      if [ -n "$state" ] && [ "$state" != "$lid" ]; then
        if [ "$state" = Yes ]; then log "lid closed"; else log "lid opened"; fi
        lid=$state
      fi
    fi
  fi
  sleep "$interval"
done
