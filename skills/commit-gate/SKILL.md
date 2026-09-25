---
name: commit-gate
description: Commit Gate before git commit. Full suite, scope, impact, guidelines, Safety First S4.
---

# Commit Gate

Run checks yourself. Report pass/fail. No commit until all pass.

## Scope & tests

- [ ] Diff matches task — no drive-by changes
- [ ] Full test suite green (command from AGENTS.md)
- [ ] New behavior / bugfix covered by tests
- [ ] API/consumers checked if public interface changed
- [ ] Matches project rules (AGENTS.md, RULES.md / `.rules/`)
- [ ] No over-engineering, dead code

## Safety First (S4) — every change

- [ ] **Security** — no secrets in diff; safe data handling (PII, auth, injection, exposure)
- [ ] **Scalability** — won't obviously break at growth
- [ ] **Stability** — errors handled; rollback possible
- [ ] **Simplicity** — simplest solution that passes the three above

**Data work:** security item is mandatory — flag FAIL if unchecked.

Goal: work that lasts years, not tomorrow's legacy. Applies to code, docs, process.

```
Commit Gate: PASS / FAIL
- scope / tests / impact / guidelines / S4
```

WIP commits — only when user asks; skip gate.
