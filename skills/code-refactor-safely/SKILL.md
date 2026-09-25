---
name: code-refactor-safely
description: Change existing code without changing its behaviour - refactoring, cleanup, dedup, simplification of code you did not write this turn. Use before touching working code for structure alone.
---

# Refactor safely

Applies when the task is changing shape, not behaviour.

1. **Understand before touching.** Why is this code here, what calls it, what does it call, which paths and errors exist, which tests pin it down, why it may have been written this way. No answer means you are not ready.
2. **Preserve behaviour exactly.** Same output for every input, same errors, same side effects and ordering. If unsure the change preserves behaviour, do not make it.
3. **One change at a time, check after each.** The test that covers it, or the smallest runnable proof. A failure means revert and re-think, not another edit on top.
4. **Scope to what you changed.** No drive-by refactors of unrelated code: that is diff noise plus regression risk.
5. **Follow existing conventions** instead of importing preferences. Read the project instructions and the neighbouring code first.
6. **Mind the over-simplification traps.** Inlining a helper that gave a concept a name, merging unrelated logic into one complex function, deleting an abstraction that exists for testability, optimising line count. Fewer lines is not the goal; easier comprehension is.
7. **Separate refactor commits from behaviour commits.** A diff that does both is two diffs.
8. **Large mechanical change** (hundreds of lines): script it rather than hand-editing.

After: is the result genuinely easier to read? If not, revert. Not every simplification attempt succeeds.
