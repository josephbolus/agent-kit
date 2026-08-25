#!/usr/bin/env bash
# Install skills into personal scope (symlink) or project scope (copy).
#
# Usage:
#   bin/install-skills.sh --personal                    # symlink all into ~/.claude/skills
#   bin/install-skills.sh --personal architecture-decisions
#   bin/install-skills.sh --project ../db-platform-ops architecture-decisions
#   bin/install-skills.sh --personal --dry-run
#
# Personal scope uses symlinks. An edit in this repository takes effect at once.
# Project scope uses copies. An agent in CI cannot follow a symlink out of the repository.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$ROOT/skills"
PERSONAL_DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
PROJECT_SUBDIR=".agents/skills"

mode=""
target=""
dry_run=0

die() { printf 'error: %s\n' "$1" >&2; exit 1; }

case "${1:-}" in
  --personal) mode="personal"; shift ;;
  --project)  mode="project"; target="${2:-}"; shift 2 ;;
  -h|--help|"") sed -n '2,10p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
  *) die "first argument must be --personal or --project <path>" ;;
esac

if [ "${1:-}" = "--dry-run" ]; then dry_run=1; shift; fi

names=("$@")
if [ "${#names[@]}" -eq 0 ]; then
  mapfile -t names < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)
fi

if [ "$mode" = "personal" ]; then
  dest="$PERSONAL_DEST"
else
  [ -n "$target" ] || die "--project needs a target repository path"
  [ -d "$target" ] || die "no such directory: $target"
  dest="$target/$PROJECT_SUBDIR"
fi

[ "$dry_run" -eq 1 ] || mkdir -p "$dest"
printf 'destination: %s (%s)\n' "$dest" "$mode"

for name in "${names[@]}"; do
  src="$SKILLS_DIR/$name"
  [ -d "$src" ] || die "no such skill: $src"
  [ -f "$src/SKILL.md" ] || die "skill has no SKILL.md: $src"

  if [ "$dry_run" -eq 1 ]; then
    printf '  would install %s\n' "$name"
    continue
  fi

  if [ "$mode" = "personal" ]; then
    if [ -e "$dest/$name" ] && [ ! -L "$dest/$name" ]; then
      printf '  skip %s: a real directory exists at the destination\n' "$name" >&2
      continue
    fi
    ln -sfn "$src" "$dest/$name"
    printf '  linked %s\n' "$name"
  else
    rm -rf "${dest:?}/$name"
    cp -R "$src" "$dest/$name"
    printf '  copied %s\n' "$name"
  fi
done
