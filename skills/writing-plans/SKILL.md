---
name: writing-plans
description: When a spec or agreed requirements need a multi-step build - write the plan map before touching code, then execute it one task at a time.
---

# Writing and executing the plan

The plan is a **map**, not a second copy of the code: goal, scope, files, constraints, and one line per task (what changes → deliverable → acceptance check). Code, commands and step detail are written later, for the one task in work, at the moment it is taken.

**Where it lives:** the project's plan file (`PLAN.md`), or `docs/plans/YYYY-MM-DD-<feature>.md` when the project keeps none. A user preference for the location wins.

## Map rules

- No code, no pseudo-code, no commands, no "how to run the toolchain", no TBD, no filler. If a line needs a paragraph, the task is either not understood or too big.
- One task is the smallest unit that carries its own check and its own review. Fold setup, config and docs into the task whose deliverable needs them; split only where a reviewer could reject one task and approve its neighbour.
- Files first: what gets created or modified, and what each file is responsible for. That is where the decomposition is locked in.
- A multi-subsystem spec becomes separate maps, one per subsystem; each plan must produce working software on its own.
- Detail is written for the current task only, and lives in the ledger - never accumulating in the map. The finished map is the map it started as, plus ticks.

## Self-review before handing over

Coverage (every requirement points at a task) → scope creep (a task nobody asked for, or a second path beside an existing one) → order and dependencies → decisions the user has not given yet: ask now, not mid-execution.

## Executing the map

One task at a time: implement → check it with the cheapest thing that proves it → tick → one line in the ledger (what changed, evidence, next task) → take the next task yourself. No check-in between tasks, and no batching either: a task is finished before the next one starts. The test plan runs once at the end of the pass, not once per task.

Never carry "while I'm here" scope into a task. When reality contradicts the map, fix the map first and say so.

## Stop and ask

- A blocker: missing dependency, failing check, unclear instruction.
- A gap in the map that turns the next step into a guess.
- Verification failed twice.
- Anything irreversible, security-sensitive, or outside the workspace.
- Never commit unless the user asked; merging is not the agent's job.

## Finish

When the pass is verified, hand over to `finishing-a-development-branch`. Independent slices go to `dispatching-parallel-agents`, isolated work to `using-git-worktrees`.

Plan header template, right-sizing examples, and the full texts: `references/writing-plans-full.md`, `references/executing-plans-full.md`.
