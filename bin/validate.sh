#!/usr/bin/env bash
# Validate every skill in this repository.
#
# Checks:
#   1. Each skill directory has a SKILL.md.
#   2. Frontmatter name equals the parent directory name.
#   3. Frontmatter name matches ^[a-z0-9-]+$.
#   4. Frontmatter description exists and is under the length limit.
#   5. Relative markdown links inside a skill resolve on disk.
#
# Usage: bin/validate.sh

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$ROOT/skills"
DESC_MAX=1024

fail=0
item_fail=0
err()  { printf 'FAIL %s\n' "$1"; fail=1; item_fail=1; }
ok()   { printf 'ok   %s\n' "$1"; }

# Read one scalar from the frontmatter block. Handles plain and double quoted values.
frontmatter_get() {
  local file="$1" key="$2"
  awk -v key="$key" '
    NR == 1 && $0 == "---" { inblock = 1; next }
    inblock && $0 == "---" { exit }
    inblock {
      if (index($0, key ":") == 1) {
        v = substr($0, length(key) + 2)
        sub(/^[ \t]+/, "", v)
        if (substr(v, 1, 1) == "\"" ) { v = substr(v, 2, length(v) - 2) }
        print v
        exit
      }
    }
  ' "$file"
}

printf '== skills ==\n'
for dir in "$SKILLS_DIR"/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"
  skill="$dir/SKILL.md"
  item_fail=0

  if [ ! -f "$skill" ]; then
    err "$name: no SKILL.md"
    continue
  fi

  fm_name="$(frontmatter_get "$skill" name)"
  fm_desc="$(frontmatter_get "$skill" description)"

  [ "$fm_name" = "$name" ] || err "$name: frontmatter name is '$fm_name', directory is '$name'"
  printf '%s' "$fm_name" | grep -Eq '^[a-z0-9-]+$' || err "$name: name is not lowercase kebab case"
  [ -n "$fm_desc" ] || err "$name: description is empty"
  [ "${#fm_desc}" -le "$DESC_MAX" ] || err "$name: description is ${#fm_desc} characters, limit is $DESC_MAX"

  # Relative links, excluding fenced code blocks and URLs and anchors.
  for markdown in "$dir"/*.md "$dir"/*/*.md; do
    [ -f "$markdown" ] || continue
    while IFS= read -r link; do
      [ -n "$link" ] || continue
      case "$link" in http*|\#*|mailto:*) continue ;; esac
      target="${link%%#*}"
      [ -n "$target" ] || continue
      [ -e "$(dirname "$markdown")/$target" ] || err "$name: broken link to '$target'"
    done < <(awk '/^```/{f=!f; next} !f' "$markdown" \
             | grep -oE '\]\([^)]+\)' | sed 's/^](//; s/)$//')
  done

  [ "$item_fail" -eq 1 ] || ok "$name"
done

printf '== summary ==\n'
if [ "$fail" -eq 0 ]; then
  printf 'all checks passed\n'
else
  printf 'one or more checks failed\n'
fi
exit "$fail"
