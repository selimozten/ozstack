#!/bin/sh
# Holds the rules in AGENTS.md. Exits 1 on any failure.
set -u
cd "$(dirname "$0")"
fail=0
bad() { echo "FAIL  $1"; fail=1; }

for dir in skills/*/; do
  name=$(basename "$dir"); f="$dir/SKILL.md"
  [ -f "$f" ] || { bad "$name: no SKILL.md"; continue; }
  head -1 "$f" | grep -qx -- '---' || bad "$name: no frontmatter"
  grep -qx "name: $name" "$f" || bad "$name: frontmatter name is not $name"
  grep -q '^description: .\{20,\}' "$f" || bad "$name: description missing or too short"
  grep -qx 'disable-model-invocation: true' "$f" || bad "$name: not user-invoked"
  lines=$(wc -l < "$f" | tr -d ' ')
  [ "$lines" -le 100 ] || bad "$name: SKILL.md has $lines lines (limit 100)"
  grep -q 'Done when' "$f" || bad "$name: no step ends on 'Done when'"
  grep -q "\`$name\`" README.md || bad "$name: not listed in README.md"
done

for f in standards/*.md; do
  grep -q "$f" README.md || bad "$f: not listed in README.md"
done

# relative links and ~/.ozstack references resolve
for f in $(find . -name '*.md' -not -path './.git/*'); do
  d=$(dirname "$f")
  for l in $(grep -o '\](\([^)#]*\)[^)]*)' "$f" | sed 's/^](//; s/[#)].*$//' | grep -v -e '^http' -e '^$' -e '^<'); do
    [ -e "$d/$l" ] || bad "$f: dead link $l"
  done
  for r in $(grep -o '~/\.ozstack/[A-Za-z0-9_./-]*' "$f" | sed 's|^~/\.ozstack/||; s/[.,]*$//' | grep -v '<'); do
    [ -e "$r" ] || bad "$f: ~/.ozstack/$r does not exist"
  done
done

# nothing private
words='/Users/|/home/[a-z]|[A-Za-z0-9._-]+@[A-Za-z0-9-]+\.[a-z]{2,}'
[ -f .private-words ] && words="$words|$(grep -v '^$' .private-words | paste -sd'|' -)"
hits=$(grep -rnEi "$words" --include='*' . 2>/dev/null | grep -v -e '^./.git/' -e '^./LICENSE:' -e '^./.private-words:' -e '^./check.sh:' -e '@AGENTS.md' -e '{[a-z ]*}@' || true)
[ -z "$hits" ] || { echo "$hits"; bad "private or machine-specific text found"; }

[ "$fail" -eq 0 ] && echo "check ok"
exit "$fail"
