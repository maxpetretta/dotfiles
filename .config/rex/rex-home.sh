#!/bin/sh
# Create the "home" Rex session at login, replacing tmux-home.sh.
# Rex doesn't restore sessions after a reboot, so com.max.rex-home runs this
# once Rex Beta (a login item) has started its server.
REX="/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"

# Wait up to 2 minutes for the app's server; never start a second one
tries=0
until "$REX" --autostart=false ls >/dev/null 2>&1; do
  tries=$((tries + 1))
  if [ "$tries" -ge 60 ]; then
    echo "rex-home: Rex server not reachable, giving up" >&2
    exit 1
  fi
  sleep 2
done

if "$REX" --autostart=false ls | awk 'NR > 1 { print $1 }' | grep -qx home; then
  echo "rex-home: home session already exists"
  exit 0
fi

# Claude remote control runs in the first tab
"$REX" --autostart=false new home -c "$HOME/dev" --window claude-rc --shell=none -- \
  /bin/sh -c 'while true; do "$HOME/.local/bin/claude" remote-control --name "$(hostname -s)"; sleep 15; done' ||
  exit 1
# The fish shell follows in the second tab and is active
"$REX" --autostart=false window new -s home -c "$HOME" shell
