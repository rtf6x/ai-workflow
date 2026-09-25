---
name: systematic-debugging
description: Find the root cause before any fix - every bug, test failure, build break or unexpected behaviour, including the ones that look obvious and the ones under time pressure.
---

# Systematic debugging

Iron law: no fix before the root cause is found. A symptom fix is a failure, not a shortcut.

Four phases, each finished before the next begins:

1. **Investigate the cause.** Read the error in full - message, stack, line, code. Reproduce it reliably and write down the exact steps. Read the failing path end to end, not just the last frame. Change one variable at a time.
2. **Form and test the hypothesis.** State what you believe is wrong and what would prove it. Cheapest test first. A hypothesis that survived one test is still a hypothesis.
3. **Fix the cause.** Smallest change at the real cause. Every other caller of the broken function goes through the same fix - patch the shared path, not the path the report names.
4. **Prove it.** Reproduce before, confirm after. Keep the failing-before/passing-after regression test where feasible; otherwise a smoke run plus a stated limit.

## Never

- Guess-and-check loops, "try this and see".
- Suppress the error, widen a catch, special-case the reported input.
- Fix forward on top of another unverified fix.

## Stop and re-plan when

- Two fixes failed, or the same failure returns.
- The fix would touch code you do not understand yet.
- Report the missing fact instead of guessing at it.

Under time pressure: systematic is faster than thrashing.

Anti-patterns and the long form: `references/debugging-process.md`.
