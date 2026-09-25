---
name: dispatching-parallel-agents
description: Two or more independent slices with no shared state, or a plan to execute by dispatching a fresh subagent per task - build the context, fan the work out, review what comes back.
---

# Dispatching parallel agents

One agent per independent problem domain, working concurrently. The delegate never inherits your session: you construct exactly the context its slice needs. That keeps it focused and keeps your own context for coordination.

## Use when

- 2+ independent slices: unrelated failures, separate subsystems, slices with no shared state.
- A plan with mostly independent tasks, executed from this session (no context switch), with a review after each task.

## Do not use when

- The slices are related - one fix may change the others; investigate together first.
- Understanding requires the whole system state.
- Agents would touch the same files or resources.
- You do not yet know what is broken - that is `systematic-debugging`.

## A dispatch brief

- Context is built, never inherited: what to change, where, the exact error or requirement, the constraints ("tests only, do not touch production code"), and the shape of the expected output ("root cause and the diff summary").
- Too broad loses the agent ("fix all the tests"); too vague returns nothing usable ("fix it").
- Hand artifacts over as files, not pasted blobs: everything pasted into a prompt, and everything printed back, stays resident in your context for the rest of the session.
- Independent slices go out in one batch. Sequence only real dependencies.

## Executing a plan this way

One task, one dispatch - never fold several plan tasks into one brief because they look small and alike. Record `git rev-parse HEAD` (BASE) before dispatching. After the implementer reports: review the task against the spec and the diff, then either land it or run one fix round with a scoped re-review. Ledger line per task, then dispatch the next one yourself: no check-in between tasks.

- Every round ends in a review: unreviewed fixes are how regressions land.
- Fix rounds have a cap; past it the failure is structural - adjudicate and route, do not loop.
- The final whole-branch review gets one fix subagent carrying the complete findings list, not one fixer per finding.
- The ledger is what survives compaction; rulings, parked findings and deferred minor items all live there.

## Waiting on children

Never poll a wait interface with short timeouts, and never sit in one open-ended silent wait. While you have local work - ledger, packaging the next review - keep going; results arrive on their own. When genuinely idle, wait in bounded stretches and post one line of status between them, reconciling the live children so a stuck one is noticed in minutes, not at the end.

## Integrating

Review each summary, check whether two agents edited the same code, run the full suite, and spot-check one result: agents make systematic errors too.

## Per-platform tool mapping

`references/pi-tools.md`, `references/hermes-tools.md`, `references/codex-tools.md`, `references/gemini-tools.md`, `references/antigravity-tools.md`. Prompt templates: `references/implementer-prompt.md`, `references/task-reviewer-prompt.md`, `references/re-review-prompt.md`. Full texts: `references/dispatching-parallel-agents-full.md`, `references/subagent-driven-development-full.md`.
