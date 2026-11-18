#!/bin/sh
# Links the kit to ~/.ozstack and every skill into ~/.claude/skills.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
home="${OZSTACK_HOME:-$HOME/.ozstack}"

link() { # link <source> <target> <label>
  if [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]; then
    echo "ok       $3"
  elif [ -e "$2" ] || [ -L "$2" ]; then
    echo "SKIPPED  $3: $2 exists and is not this kit's link"
  else
    mkdir -p "$(dirname "$2")"
    ln -s "$1" "$2"
    echo "linked   $3"
  fi
}

link "$here" "$home" "kit at $home"
dest="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
for dir in "$here"/skills/*/; do
  dir=${dir%/}
  link "$dir" "$dest/$(basename "$dir")" "$(basename "$dir")"
done
