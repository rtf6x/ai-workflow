---
name: code-self-audit
description: Audit code you just wrote before the final answer. Use at the end of any turn that produced or edited code, even when the user did not ask for a review. Runs code-yagni, code-kiss and code-dry over your own diff and rewrites it in the same iteration.
---

# Code self-audit

Applies: you are about to emit code you just wrote or changed.

## Procedure

1. Write the solution as usual (phase 1).
2. Before the final answer, audit your own diff against `code-yagni`, then `code-kiss`, then `code-dry`. Read each rule against the actual lines you are about to print, not against the idea of them.
3. If the audit fails, rewrite inside this same iteration. Never ship code you would have rejected in review.
4. Refactoring existing code instead of writing new code: use `code-refactor-safely`, not this rewrite loop.

## Output

1. One short audit log: what was cut or simplified, and by which rule.
2. The final code.

Nothing to cut (a one-liner, a config tweak): say `self-audit: nothing to cut` and keep the answer short.
