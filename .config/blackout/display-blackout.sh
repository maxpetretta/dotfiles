#!/bin/sh
# Black out the Studio Display after the Mac has sat idle, and bring it back on the next key press or
# mouse move. It dims with BetterDisplay's software brightness instead of turning the display off,
# because display sleep locks the Mac (iPhone Mirroring's auto-authentication forces an immediate
# password) and a locked Mac stops computer use. Screenshots don't capture the dimming, so agents still
# see the normal screen. Run by the com.max.display-blackout LaunchAgent.
set -u

display="Studio Display"
idle_after=${BLACKOUT_IDLE_SECONDS:-600}
interval=5
cli=/opt/homebrew/bin/betterdisplaycli
applied= # last brightness that was set successfully; empty until the first one works

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*"; }

# Seconds since the last real keyboard, mouse or trackpad input. The combined session state (0) with any
# input type (0xFFFFFFFF) ignores events that computer use synthesizes, so an agent typing or clicking
# doesn't light the screen. IOHIDSystem's HIDIdleTime and the HID system state (1) reset on those
# events. JXA doesn't define the constants, hence the raw values. A failure reads as active.
idle_seconds() {
  /usr/bin/osascript -l JavaScript -e \
    'ObjC.import("CoreGraphics"); Math.floor($.CGEventSourceSecondsSinceLastEventType(0, 0xFFFFFFFF))' 2>/dev/null
}

set_brightness() {
  "$cli" set --name="$display" --softwareBrightness="$1" >/dev/null 2>&1
}

# Leave the display lit when launchd stops the agent. If it can't be reached, the next start restores it.
trap 'set_brightness 1; exit 0' INT TERM

log "watching $display, blackout after ${idle_after}s idle"
while :; do
  idle=$(idle_seconds)
  if [ "${idle:-0}" -ge "$idle_after" ]; then target=0; else target=1; fi
  # A failed set (display undocked, BetterDisplay not running) is retried every pass until it works.
  # The empty start value also undoes a blackout a killed run left behind, since BetterDisplay
  # remembers the dimming.
  if [ "$target" != "$applied" ]; then
    if set_brightness "$target"; then
      applied=$target
      if [ "$target" = 0 ]; then log "blacked out after ${idle}s idle"; else log "lit"; fi
    fi
  elif [ "$target" = 0 ]; then
    # Any change to the display's backlight, such as automatic brightness reacting to the room getting
    # darker, resets BetterDisplay's software brightness to full. So while dark, read the real value
    # and black out again if something lit it.
    current=$("$cli" get --name="$display" --softwareBrightness 2>/dev/null)
    case $current in
      0 | 0.0) ;;
      *) set_brightness 0 && log "blacked out again (software brightness was ${current:-unreadable})" ;;
    esac
  fi
  sleep "$interval"
done
