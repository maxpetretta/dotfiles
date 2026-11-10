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
blacked_out=0

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*"; }

idle_seconds() {
  /usr/sbin/ioreg -c IOHIDSystem | /usr/bin/awk '/HIDIdleTime/ { print int($NF / 1000000000); exit }'
}

set_brightness() {
  "$cli" set --name="$display" --softwareBrightness="$1" >/dev/null 2>&1
}

# Leave the display lit when launchd stops the agent.
restore() {
  [ "$blacked_out" = 1 ] && set_brightness 1
  exit 0
}
trap restore INT TERM

log "watching $display, blackout after ${idle_after}s idle"
# Undo a blackout a killed run left behind. If the display can't be reached yet, retry on activity.
set_brightness 1 || blacked_out=1
while :; do
  idle=$(idle_seconds)
  if [ "$blacked_out" = 0 ] && [ "${idle:-0}" -ge "$idle_after" ]; then
    # Fails when the display isn't connected or BetterDisplay isn't running, so undocked does nothing.
    if set_brightness 0; then
      blacked_out=1
      log "blacked out after ${idle}s idle"
    fi
  elif [ "$blacked_out" = 1 ] && [ "${idle:-0}" -lt "$idle_after" ]; then
    # Keeps trying while undocked, because BetterDisplay remembers the dimming for the next dock.
    if set_brightness 1; then
      blacked_out=0
      log "restored"
    fi
  fi
  sleep "$interval"
done
