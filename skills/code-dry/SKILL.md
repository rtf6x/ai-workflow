---
name: code-dry
description: Remove duplication without paying for it with a bad abstraction. Use when the same logic appears in two or more places, and when tempted to extract a shared helper.
---

# DRY, with limits

Applies when the same logic shows up again.

- Two copies of five lines or more: extract one named function.
- Two copies of one or two lines: leave them; the extraction costs more than it saves.
- Extract at the third repeat when the real shape is not visible yet.
- Copies that will diverge by domain stay separate: a flag on a shared helper is worse than two honest versions.
- Never extract across modules that own different decisions. Shared code is a dependency, and a dependency must be worth its price.
- After extraction the call site reads shorter than what it replaced. If it does not, revert.
- Dead duplicate: the same rule written twice with one copy unused - delete the unused one, do not keep it as reference.

Duplication is a cost; a wrong abstraction is a debt you never stop paying.
