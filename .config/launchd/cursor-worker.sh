#!/bin/sh
# com.max.cursor-worker runs this at login. Cursor registers a machine's repos
# from the git remotes of its worker directories. --worker-dir is repeatable,
# up to 20, and goes before start. Pass one per immediate git checkout in ~/dev.
set -eu

dev=/Users/max/dev
agent=/opt/homebrew/bin/cursor-agent
limit=20

if [ ! -d "$dev" ]; then
  echo "cursor-worker: $dev does not exist" >&2
  exit 1
fi

# The first --worker-dir is the assignment identity, so the list stays sorted.
set --
n=0
while IFS= read -r dir; do
  [ -n "$dir" ] || continue
  [ -d "$dir" ] || continue
  # A file or a directory: worktrees use a .git file.
  [ -e "$dir/.git" ] || continue
  n=$((n + 1))
  if [ "$n" -gt "$limit" ]; then
    echo "cursor-worker: more than $limit git checkouts in $dev" >&2
    exit 1
  fi
  set -- "$@" --worker-dir "$dir"
done <<EOF
$(find "$dev" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -print | LC_ALL=C sort)
EOF

if [ "$n" -eq 0 ]; then
  echo "cursor-worker: no git checkouts in $dev" >&2
  exit 1
fi

exec "$agent" worker --computer-use "$@" start --name mba15
