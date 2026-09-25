# executing-plans - full text

Adapted from the superpowers skill (MIT, Copyright (c) 2025 Jesse Vincent, https://github.com/obra/superpowers). Long-form reference; the short `SKILL.md` is what gets applied.


# Executing Plans

## Overview

Load the map, review it critically, then work through it **one task at a time**:
implement → check → one line in the ledger → take the next task yourself. The map
is the anchor; when reality contradicts it, fix the map first, then continue.
The test plan runs once at the end of the pass, not once per task.

**Announce at start:** "I'm using the executing-plans skill to implement this plan, one task at a time."

**Note:** Superpowers works much better with subagents (Claude Code, Codex CLI,
Codex App, Copilot CLI, Gemini CLI qualify; see the per-platform tool refs in
`../dispatching-parallel-agents/references/`). If subagents are available, use
dispatching-parallel-agents instead of this skill.

## The Process

### Step 1: Load and Review

1. Ensure an isolated workspace: use using-git-worktrees to create one or verify the existing one
2. Read the plan map
3. Review it critically — gaps, wrong order, scope creep, missing decisions
4. Raise concerns with your human partner before starting
5. Create todos, one per task
6. Write the detail for the **first task only** — the check, exact commands, expected output

### Step 2: Execute the Tasks

Work in the map's order. One task at a time:

1. Mark the task in progress
2. Implement the minimal code for the task
3. Check it with the cheapest thing that proves it works — a command, a run, a
   look at the result; the failing test first when the behavior is genuinely
   uncertain
4. Tick the task in the map
5. One line in the ledger: what changed, the evidence, which task is next
6. Take the next task yourself. No go-ahead between tasks, and no batching
   either: a task is finished before the next one starts.

Never carry "while I'm here" scope into the task. If the map needs to change, fix
it and say so. Stop only for the reasons in "When to Stop and Ask for Help".

### Step 3: Verify the Pass

When the pass's tasks are done, run the test plan once — the suite, the
scenarios, the checks the map named for the pass. Report it: tasks done, the
evidence, what is next.

### Step 4: Complete Development

After the pass is verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** use finishing-a-development-branch

## When to Stop and Ask for Help

**STOP immediately when:**
- A blocker appears (missing dependency, failing test, unclear instruction)
- The map has a gap that prevents starting or continuing
- Verification fails twice
- Reality contradicts the map (fix the map, show it, then continue)
- Anything irreversible, security-sensitive, or outside this worktree

**Ask for clarification rather than guessing.**

## Remember
- One task at a time: implement, check, one line, next — no check-in between tasks
- Tests once at the end of the pass, not per task
- Check before you move on; don't skip verifications
- Never commit unless the user asks; merge is not AI's job
- Never start implementation on main/master branch without explicit user consent
