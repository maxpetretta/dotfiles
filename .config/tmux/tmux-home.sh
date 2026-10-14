#!/bin/sh
# Attach to the "home" tmux session, creating it on first launch.
# Ghostty runs this, so a fresh tmux server inherits Ghostty's macOS privacy
# permissions (Full Disk Access, Developer Tools) instead of being its own app.
TMUX_BIN=/opt/homebrew/bin/tmux

if ! "$TMUX_BIN" has-session -t home 2>/dev/null; then
  # Claude remote control runs in the first window.
  # Run the loop under /bin/sh explicitly: tmux's default-shell is fish, which rejects sh syntax.
  "$TMUX_BIN" new-session -d -s home -n claude-rc -c "$HOME/dev" \
    /bin/sh -c 'while true; do "$HOME/.local/bin/claude" remote-control --name "$(hostname -s)"; sleep 15; done'
  # The fish shell follows in the second window and is active on attach.
  "$TMUX_BIN" new-window -t home -c "$HOME"
fi

exec "$TMUX_BIN" attach-session -t home
