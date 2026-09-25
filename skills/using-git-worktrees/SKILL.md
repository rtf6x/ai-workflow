---
name: using-git-worktrees
description: Starting feature work that needs isolation from the current workspace, or before executing a plan - set up an isolated workspace using native tools first, git worktree as the fallback.
---

# Using git worktrees

Isolation protects the branch you are on. Detect first, then use native tools, then fall back to git. Never fight the harness.

## 1. Detect existing isolation

```
GIT_DIR=$(cd "$(git rev-parse --git-dir)" && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" && pwd -P)
```

`GIT_DIR != GIT_COMMON` means you are already in a linked worktree - skip creation. Guard against the false positive: inside a submodule the same is true, so check `git rev-parse --show-superproject-working-tree` and treat a hit as a normal repo.

## 2. Create it

- Native worktree tool first (`EnterWorktree`, `/worktree`, a `--worktree` flag). Using `git worktree add` beside a native tool creates state the harness cannot see or clean up.
- Otherwise `git worktree add`, in the project's existing worktree directory (`.worktrees/`, else `worktrees/`, else the instruction file's choice, else `.worktrees/`), and verify it is gitignored - add it and commit if not.
- No consent for a worktree, or the directory cannot be created? Work in place and say so.

## 3. Set up and verify the baseline

Install dependencies the project needs, then run the project's own test command before touching anything. A failing baseline gets reported and a decision, never quietly worked around. Report:

```
Worktree ready at <path>
Tests passing (<N>, 0 failures)
Ready to implement <feature>
```

Full steps, edge cases and the rationalization table: `references/using-git-worktrees-full.md`.
