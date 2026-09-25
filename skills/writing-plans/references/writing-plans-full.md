# writing-plans - full text

Adapted from the superpowers skill (MIT, Copyright (c) 2025 Jesse Vincent, https://github.com/obra/superpowers). Long-form reference; the short `SKILL.md` is what gets applied.


# Writing Plans

## Overview

The plan is a **map**, not a second copy of the code. It fixes the goal, the
boundaries, the files, the constraints, and the task list — one line per task.
Code, commands, and step-by-step detail are written later, for the one task in
work, at the moment it is taken.

**Announce at start:** "I'm using the writing-plans skill to create the plan map."

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

**Language:** plain and short. No restating the request back, no explaining
obvious steps, no "TBD", no filler, no code. One line per task. If a line needs
a paragraph, either the task is not understood yet or it is too big.

**Context:** If working in an isolated worktree, it should have been created via
the `using-git-worktrees` skill at execution time.

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken
into sub-project specs during brainstorming. If it wasn't, suggest breaking this
into separate plans — one per subsystem. Each plan should produce working,
testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what
each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file
  should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are
  more reliable when files are focused. Prefer smaller, focused files over large
  ones that do too much.
- Files that change together should live together. Split by responsibility, not
  by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large
  files, don't unilaterally restructure — but if a file you're modifying has
  grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce
self-contained changes that make sense independently.

## Task Right-Sizing

A task is the smallest unit that carries its own check, its own review, and its
own place in the map. When drawing task boundaries: fold setup, configuration,
scaffolding, and documentation steps into the task whose deliverable needs them;
split only where a reviewer could meaningfully reject one task while approving
its neighbor. Each task ends with a deliverable you can check on its own.

One task = one step in execution. If two tasks can only be understood together,
they are one task; if one task hides a second deliverable, they are two.

## Plan Document Header

**Every plan map MUST start with this header:**

````markdown
# [Feature Name] — plan map

> **For agentic workers:** execute one task at a time — implement, check it,
> one line in the ledger, then take the next task yourself; tests run once at
> the end of the pass. Use dispatching-parallel-agents
> (recommended) or writing-plans. Tick boxes (`- [x]`) as tasks land.

**Goal:** [1–3 sentences: what this builds and why]

**In scope:** [boundary of this job]
**Out of scope:** [what is deliberately not done here]

**Constraints:** [project-wide limits: version floors, dependency limits, naming
and copy rules, platform requirements — one line each, exact values]

**Files:** [create/modify, one line each, with what each file is responsible for]

**Spec:** [path to the spec/design doc this map implements, if one exists]

**Tasks:**
1. [what changes] → [deliverable] → [acceptance check]
2. ...

---
````

## Task Lines

A task line carries only: what changes, the deliverable, the acceptance check
(how we will know it works), and the files it touches when that is not obvious
from the Files list. Nothing else.

Do not write code, pseudo-code, or step sequences into the map. Do not describe
how to run the toolchain. The map is what the executor and the user agree on;
the detail lives one task deep.

## Current-Task Detail

When a task is taken into work — and only then — write its detail: the test to
write first, exact commands, expected output, the commit.

Put that detail in the execution log (ledger or chat), never accumulate it in
the plan file. When the task is done, the plan file holds the same map it
started with, plus a ticked box.

**No placeholders in that detail:** no "TBD", no "implement later", no "add
appropriate error handling", no "similar to Task N". If you cannot write the
detail, you do not understand the task yet — go read the code first.

## Self-Review

After writing the map, check it against the spec with fresh eyes. This is your
own checklist, not a subagent dispatch.

**1. Coverage:** skim each requirement in the spec — can you point to a task that
delivers it? List the gaps.

**2. Scope creep:** is any task delivering something nobody asked for, or a
second path beside an existing one? Cut it.

**3. Order and dependencies:** does any task rely on a later one? Does any task
need a decision the user has not given yet? Ask now, not mid-execution.

Fix inline. If a requirement has no task, add the task.

## Execution Handoff

After saving the map, offer the execution choice:

**"Plan map saved to `docs/superpowers/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (recommended)** — fresh subagent per task, review after each task

**2. Inline Execution** — same session, one task at a time

**Which approach?"**

**One task at a time either way:** implement → check → one line in the ledger →
take the next task yourself, no check-in between tasks. Never let several tasks
run as one blurred batch either; tests run once at the end of the pass.

**If Subagent-Driven chosen:** **REQUIRED SUB-SKILL:** use
dispatching-parallel-agents.

**If Inline chosen:** **REQUIRED SUB-SKILL:** use writing-plans.
