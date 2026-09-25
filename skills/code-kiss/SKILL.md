---
name: code-kiss
description: Write flat, boring code. Use while writing any logic - a branch, a loop, a parser, a money path - and whenever a design tempts you into a factory, strategy, or reflection.
---

# KISS

Applies while writing logic.

- Top to bottom, no jumping: a reader gets it in one pass without holding a mental stack.
- Plain `if`/`switch` beats a pattern. A factory or a strategy earns its place only when a second real variant exists today.
- No reflection, no dynamic dispatch, no metaprogramming where a named function does it.
- Explicit beats compact when compact needs a pause to parse: nested ternaries, dense chained calls, clever one-liners with side effects.
- Guard clauses over nesting.
- Names describe content: no `data`, `result`, `tmp`, `val`, `item`.
- Comments carry *why*, not *what*. A comment explaining what the next line does means the code needs renaming instead.
- Same input, same output: no hidden state, no ordering that works only by accident.
- Deeply nested structure is a signal: extract the condition into a named predicate, flatten to guard clauses.
- Longer than a screen with several responsibilities: split into named steps.

Clever costs the next reader at 3am. Boring is the feature.
