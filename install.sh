#!/bin/sh
# Links every skill in this kit into ~/.claude/skills.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
dest="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
for dir in "$here"/skills/*/; do
  name=$(basename "$dir")
  target="$dest/$name"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "${dir%/}" ]; then
    echo "ok       $name"
  elif [ -e "$target" ] || [ -L "$target" ]; then
    echo "SKIPPED  $name: $target exists and is not this kit's link"
  else
    ln -s "${dir%/}" "$target"
    echo "linked   $name"
  fi
done
