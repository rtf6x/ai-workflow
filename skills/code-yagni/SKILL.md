---
name: code-yagni
description: Cut what should not exist. Use before adding a helper, abstraction, dependency, config value, generic, file, or any new code path - and when asked to implement something that may already exist in this codebase.
---

# YAGNI filter

Applies to any line you are about to add.

## The ladder - stop at the first rung that holds

1. Does this need to exist at all? A speculative need is not a need.
2. Does it already exist in this codebase? Reuse the helper, util, type or pattern that is already here. Look before you write: re-implementing what lives a few files over is the most common waste.
3. Does the standard library do it? Use it.
4. Does a platform feature cover it? Prefer the platform over code.
5. Does an installed dependency solve it? Use it; never add a new dependency for what a few lines can do.
6. Can it be one line? One line.
7. Only then: the minimum code that works.

The ladder runs after you understand the problem, not instead of it: read the task, trace the flow end to end, then climb.

## Cut on sight

- An interface with one implementation, a factory with one product, a config for a value that never changes.
- Hooks, generics, options and extension points added "for later" - later can add them.
- A wrapper that only forwards: call the underlying function directly.

## Not YAGNI

Validation at trust boundaries, error handling that prevents data loss, security, accessibility, anything asked for by name.

## Deletion over addition

Removing a path is a smaller diff than adding a guard to keep it alive. When a change makes code unreachable, delete it in the same change.

Bug fix means root cause, not symptom: grep every caller of the function you touch and fix the shared function once - one guard there beats one per caller.

Deliberate corner cut with a known ceiling (global lock, O(n^2) scan, naive heuristic) stays, but marked in the code with the ceiling and the upgrade path.
