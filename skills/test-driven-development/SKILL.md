---
name: test-driven-development
description: The RED-GREEN-REFACTOR cycle for every feature, bugfix, refactor or behaviour change, before writing implementation code - no exception unless the user names one. Also carries the BDD scenarios agreed at Design Gate.
---

# TDD

Applies always: new features, bug fixes, refactors, behaviour changes. Exceptions only when the user names one (throwaway prototype, generated code, config).

Cycle - every step ends with a run:

```
RED      - write the test from the scenario, run it, watch it FAIL
GREEN    - minimal code to pass, run it, watch it PASS
REFACTOR - clean the code, run again
```

## Rules

- No production code before a failing test.
- Test behaviour, not implementation: the test must fail for the right reason.
- A bug fix ships with a regression test that fails without the fix.
- The agent runs the tests; the user never runs them for you.
- Before commit, the full suite - see `commit-gate`.
- If the cycle feels slow, shrink the step. Skipping the test is not the shortcut.

## Scenarios (BDD)

Behaviour is written as scenarios at Design Gate: at least one happy path and one negative. English in code, test names and scenarios.

## Report

```
TDD: PASS
- scenarios: ...
- tests: ...
- command: ... -> green
```

Long-form methodology: `references/tdd-cycle.md`.
