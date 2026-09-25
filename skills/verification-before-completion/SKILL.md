---
name: verification-before-completion
description: Prove the change works before claiming it does - run the real thing, reproduce before and confirm after, and never report success you have not observed.
---

# Verification before completion

A claim of "done", "fixed" or "passing" is a claim about observed behaviour. Unobserved success is a guess.

## Before saying it is done

- Run the specific thing that changed - the command, the endpoint, the UI, the script. Tests alone are not proof.
- Bug: reproduce before the fix, confirm after. Keep the failing-before/passing-after test where feasible.
- Investigation: run it and show the output.
- Throwaway script beats a fabricated claim whenever no runtime exists for the change.
- Report only the checks you actually ran; name the ones you did not.
- If verification is impossible, say what is missing and why - never quietly shrink the claim.

## Forbidden claims

- "Should work", "should be fine", "that will fix it" with no run behind it.
- "Tests pass" when the suite does not cover the changed path.
- Screenshots or output pasted from an earlier run as if they were current.

## Report shape

```
Change: <what changed>
Check: <exact command or action>
Result: <what was observed>
Not checked: <what remains unverified, or "nothing">
```

Long form: `references/verification-process.md`.
