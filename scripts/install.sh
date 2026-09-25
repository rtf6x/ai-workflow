#!/usr/bin/env bash
# Install the skillset into a harness skills directory as per-skill symlinks.
#
# Usage: scripts/install.sh [<harness>] [--dest DIR]
#   harness: omp | claude | opencode | pi | zed | hermes | agents
#   --dest DIR without a harness links into that directory instead
#
# Existing symlinks are repointed. Real directories/files are never removed —
# they are reported as stale copies and installation continues.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SKILLS="$ROOT/skills"

usage() { sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

harness=""
if [[ $# -gt 0 && "$1" != --* ]]; then harness=$1; shift; fi

dest=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest) dest=${2:-}; shift 2 ;;
    *) usage ;;
  esac
done

if [[ -z "$dest" && -z "$harness" ]]; then
  echo "give a harness or --dest DIR" >&2
  usage
fi

if [[ -z "$dest" ]]; then
  case "$harness" in
    omp)      dest="$HOME/.omp/agent/skills" ;;
    claude)   dest="$HOME/.claude/skills" ;;
    opencode) dest="$HOME/.config/opencode/skills" ;;
    pi)       dest="$HOME/.pi/agent/skills" ;;
    zed)      dest="$HOME/.config/zed/skills" ;;
    hermes)   dest="$HOME/.hermes/skills" ;;
    agents)   dest="$HOME/.agents/skills" ;;
    *)        echo "unknown harness: $harness" >&2; usage ;;
  esac
fi

[[ -d "$SKILLS" ]] || { echo "no skills/ in $ROOT" >&2; exit 1; }
mkdir -p "$dest"

installed=0
conflicts=0
for dir in "$SKILLS"/*/; do
  [[ -f "$dir/SKILL.md" ]] || continue
  name=$(basename "$dir")
  target="$dest/$name"

  if [[ -L "$target" ]]; then
    rm "$target"
  elif [[ -e "$target" ]]; then
    printf 'STALE %s: real %s exists, left untouched\n' "$name" "$([[ -d "$target" ]] && echo directory || echo file)"
    conflicts=$((conflicts + 1))
    continue
  fi

  ln -s "${dir%/}" "$target"
  installed=$((installed + 1))
done

# Sweep symlinks that point into this repo but whose skill no longer exists there:
# a dropped skill must not survive in a target as a dangling link.
removed=0
for target in "$dest"/*; do
  [[ -L "$target" ]] || continue
  name=$(basename "$target")
  [[ -f "$SKILLS/$name/SKILL.md" ]] && continue
  link=$(readlink "$target")
  case "$link" in
    "$SKILLS"/*)
      rm "$target"; removed=$((removed + 1))
      printf 'ORPHAN %s: removed dangling link to a dropped skill\n' "$name"
      ;;
  esac
done

printf '%s -> %s: %d linked, %d stale, %d orphan removed\n' "${harness:-dest}" "$dest" "$installed" "$conflicts" "$removed"
