#!/usr/bin/env bash
# Validate the skillset repo. Read-only.
#
# Checks:
#   1. every skill folder has SKILL.md with frontmatter `name` == folder name and a non-empty `description`
#   2. skill names are unique inside the set
#   3. no banned bare names (they collide with other harnesses' triggers): see BANNED
#   4. vendored skills (with upstream.yaml) carry `source`
#   5. install targets: broken symlinks are errors, real directories where a symlink is expected are warnings (stale copies)
#   6. rules name real skills: every skill named in rules/ exists in skills/ (the roster below
#      is this set's skill list - add a name here when you add a skill to the rules)
#
# Exit: 0 green, 1 red.
set -uo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SKILLS=${SKILLS_DIR:-$ROOT/skills}

BANNED="audit polish animate extract shape remember start brief tokens redesign"

if [[ "${1:-}" == "--selftest" ]]; then
  t=$(mktemp -d)
  mkdir -p "$t/skills/one"
  printf -- '---\nname: one\ndescription: %s\n---\n\nBody.\n' \
    "Self-test fixture with a long enough description string." > "$t/skills/one/SKILL.md"
  if ! SKILLS_DIR="$t/skills" SKIP_TARGETS=1 "$0" >/dev/null; then
    echo "selftest FAIL: valid single skill set reported red"; rm -rf "$t"; exit 1
  fi
  mkdir -p "$t/skills/two"
  printf -- '---\nname: one\ndescription: %s\n---\n\nBody.\n' \
    "Self-test fixture with a long enough description string." > "$t/skills/two/SKILL.md"
  if SKILLS_DIR="$t/skills" SKIP_TARGETS=1 "$0" >/dev/null 2>&1; then
    echo "selftest FAIL: duplicate skill name not detected"; rm -rf "$t"; exit 1
  fi
  rm -rf "$t"
  echo "selftest ok: green on clean set, red on duplicate name"
  exit 0
fi

TARGETS=(
  "omp:$HOME/.omp/agent/skills"
  "claude:$HOME/.claude/skills"
  "opencode:$HOME/.config/opencode/skills"
  "pi:$HOME/.pi/agent/skills"
  "zed:$HOME/.config/zed/skills"
  "hermes:$HOME/.hermes/skills"
  "agents:$HOME/.agents/skills"
)

fails=0
warns=0
err()  { printf 'FAIL  %s\n' "$*"; fails=$((fails + 1)); }
warn() { printf 'WARN  %s\n' "$*"; warns=$((warns + 1)); }

fm_value() { # fm_value <file> <key>
  awk -v key="$2" '
    /^---[[:space:]]*$/ { n++; next }
    n == 1 && index($0, key ":") == 1 {
      v = substr($0, length(key) + 2)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
      if (v == ">" || v == ">-" || v == "|" || v == "|-") {
        getline nxt
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", nxt)
        print nxt
      } else {
        gsub(/^["'"'"']|["'"'"']$/, "", v)
        print v
      }
      exit
    }
  ' "$1"
}

declare -a names=()
count=0

if [[ -d "$SKILLS" ]]; then
  while IFS= read -r -d '' dir; do
    base=$(basename "$dir")
    [[ "$base" == .* ]] && continue
    count=$((count + 1))
    skill="$dir/SKILL.md"

    if [[ ! -f "$skill" ]]; then
      err "$base: SKILL.md missing"
      continue
    fi

    name=$(fm_value "$skill" name)
    desc=$(fm_value "$skill" description)

    [[ -z "$name" ]] && err "$base: frontmatter has no name" && continue
    [[ "$name" != "$base" ]] && err "$base: frontmatter name '$name' != folder name"

    if [[ -z "$desc" ]]; then
      err "$base: frontmatter has no description"
    elif [[ ${#desc} -lt 40 ]]; then
      warn "$base: description shorter than 40 chars"
    fi

    for dup in "${names[@]:-}"; do
      [[ -n "$dup" && "$dup" == "$name" ]] && err "$base: duplicate skill name '$name'"
    done
    names+=("$name")

    for b in $BANNED; do
      [[ "$name" == "$b" ]] && err "$base: banned bare name '$name' — needs a qualifier (ui-, etc.)"
    done

    if [[ -f "$dir/upstream.yaml" ]]; then
      usrc=$(awk -F': *' '/^source:/ { print $2; exit }' "$dir/upstream.yaml")
      [[ -z "$usrc" ]] && err "$base: upstream.yaml has no source"
    fi
  done < <(find "$SKILLS" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
fi

printf 'skills: %d\n' "$count"

# Rules must not name a skill that does not exist: a rule pointing at a missing
# skill is how a set quietly rots.
for rfile in "$ROOT"/rules/*.md; do
  [[ -f "$rfile" ]] || continue
  while IFS= read -r name; do
    [[ -d "$SKILLS/$name" ]] || err "$(basename "$rfile"): names skill '$name' which is not in skills/"
  done < <(grep -o '`[a-z][a-z0-9-]*`' "$rfile" | tr -d '`' | sort -u | grep -E '^(design-gate|brainstorming|writing-plans|test-driven-development|systematic-debugging|verification-before-completion|code-review|commit-gate|code-yagni|code-kiss|code-dry|code-refactor-safely|code-self-audit|dispatching-parallel-agents|using-git-worktrees|finishing-a-development-branch|writing-skills|discover-project-instructions)$')
done

if ((count > 0)) && [[ -z "${SKIP_TARGETS:-}" ]]; then
  for entry in "${TARGETS[@]}"; do
    tn=${entry%%:*}
    tp=${entry#*:}
    [[ -d "$tp" ]] || continue
    linked=0
    for name in "${names[@]}"; do
      p="$tp/$name"
      if [[ -L "$p" ]]; then
        [[ -e "$p" ]] || err "target $tn: broken symlink $name"
        linked=$((linked + 1))
      elif [[ -e "$p" ]]; then
        warn "target $tn: $name is a real directory, not a symlink — stale copy"
      fi
    done
    printf 'target %s: %d/%d linked\n' "$tn" "$linked" "${#names[@]}"

    # Links that point into this repo but name no existing skill: dropped skills
    # must not survive in a target. Nothing else in the directory is touched.
    for p in "$tp"/*; do
      [[ -L "$p" ]] || continue
      link=$(readlink "$p")
      case "$link" in
        "$SKILLS"/*)
          pn=$(basename "$p")
          [[ -f "$SKILLS/$pn/SKILL.md" ]] || err "target $tn: orphan symlink $pn — no such skill in the set"
          ;;
      esac
    done
  done
fi

printf 'result: %d errors, %d warnings\n' "$fails" "$warns"
((fails == 0)) || exit 1
