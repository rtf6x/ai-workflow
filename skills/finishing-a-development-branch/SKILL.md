---
name: finishing-a-development-branch
description: Implementation is done and the checks pass - verify the tree, then present the integration options (merge, PR, keep) and execute the user's choice.
---

# Finishing a development branch

Verify → detect the environment → present the options → execute the choice → clean up. Integration is the user's decision, not the agent's inference.

## 1. Verify the tree you are about to integrate

Run the project's own full suite on that tree. Green runs only prove the tree they ran on, so an earlier pass this session counts for nothing. Failing tests stop here - report them; the menu comes after a green suite.

## 2. Detect the environment

```
GIT_DIR=$(cd "$(git rev-parse --git-dir)" && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" && pwd -P)
```

Normal repo: standard menu, no worktree cleanup. Linked worktree on a named branch: standard menu, provenance-based cleanup. Detached HEAD: reduced menu - no merge, the workspace is externally managed, leave it in place.

## 3. Base branch

Whatever this work forked from - the plan, the conversation, the upstream. Unknown means ask and confirm before merging: merging into the wrong base is expensive to undo.

## 4. Present the options

```
1. Merge back to <base-branch> locally
2. Push and open a PR
3. Keep the branch as-is
```

Then stop and wait. Discarding exists only as a response to an explicit request to throw the work away, confirmed before anything is deleted.

## 5. Execute, in this order

- Merge: switch to the base, pull, merge, re-run the suite on the merged result. Failure stops everything - branch and worktree stay put while you investigate. Only a green merged result earns cleanup, then `git branch -d`.
- PR: push with `-u`, create the request with the forge's own tooling and its template, report the URL. Keep the worktree - PR feedback gets fixed there.
- Keep: report the branch and worktree path, touch nothing.

Clean up only worktrees you created under `.worktrees/` or `worktrees/`; everything else belongs to the host. A refused worktree removal means files exist only there - never `--force` past it without asking.

Full steps, the discard path and the rationalization table: `references/finishing-a-development-branch-full.md`.
