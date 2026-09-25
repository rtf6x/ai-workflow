---
name: code-review
description: Requesting an independent review of finished work, and handling the review you get back - after a task, before a merge, or when feedback arrives - with technical rigour instead of performative agreement.
---

# Code review

Two halves of one thing: ask for review with the right context, and act on review on evidence.

## Requesting

- **When:** after each task in a dispatched-work plan, after a major feature, before merging to main. Also when stuck, before a refactor, after a complex bug fix.
- Give the reviewer the work product, never your session history: what you built, what it should do, the base and head commits. Template: `references/code-reviewer.md`.
- Dispatch it as a subagent: the diff and its reading live in its context, only findings come back to yours.
- Act on what comes back: blocking issues fixed now, before proceeding; simple fixes next; minor issues recorded, not silently dropped. Push back with technical reasoning when the reviewer is wrong.

## Receiving

```
READ      - the whole thing, without reacting
RESTATE   - the requirement in your own words, or ask
VERIFY    - check it against the code as it actually is
EVALUATE  - is it sound for THIS codebase
RESPOND   - a technical acknowledgement, or a reasoned pushback
IMPLEMENT - one item at a time, checking each
```

- Anything unclear: stop and ask before implementing anything. Items are often related, and partial understanding produces the wrong fix.
- Then implement in order: blocking issues, simple fixes, complex fixes; check each one individually and confirm no regressions.
- Push back when the suggestion breaks working behaviour, ignores context, fights YAGNI or an accepted architectural decision, or is wrong for the stack - with reasoning, tests and specific questions.
- No "you're absolutely right", no "great point", no thanks. State what changed, or just show the fix.

Full texts, the reviewer template and the worked examples: `references/requesting-code-review-full.md`, `references/receiving-code-review-full.md`, `references/code-reviewer.md`.
