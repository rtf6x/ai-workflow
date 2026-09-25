---
name: brainstorming
description: Before any creative work - a new feature, component, behaviour change or project - classify the request, explore intent and present the design for approval, before touching code.
---

# Brainstorming

Turn an idea into an approved design. Nothing is implemented before the user approves your intent.

## Classify first, and say the classification out loud

- **Spike** - a feasibility question ("can we", "is it possible"), where the answer is what you keep, not the code. Present the question and the probe in 2-3 sentences, get a nod, investigate as cheaply as correctness allows, report a recommendation. Anything built stays labelled throwaway.
- **Bounded** - a well-scoped change to a flow that already exists in this repo. Ask the questions that matter, present a short design in chat (the Design Brief), stop, and wait for an explicit yes. No spec file, no plan document.
- **Architectural** - a new project, a new subsystem, or a change that reshapes how components fit together or that others depend on. Full process: context, questions, 2-3 approaches with trade-offs and a recommendation, a sectioned design approved section by section, a written spec, then `writing-plans`.

Two paths plausible? Take the heavier one. Hidden complexity upgrades the path mid-task - stop and say so. Nothing downgrades.

## Never

- Start implementing because the design is "obvious" - the gate is the approval, not the length of the design.
- Call a task bounded to dodge a spec when the flow does not exist yet: bounded measures the repo, not your familiarity with that kind of app.
- Keep spike code without classifying it as a new request.

## Brief defaults

- One question at a time, only the ones that change the design.
- Name the files you will touch and how you will verify.
- After approval, implement through the normal workflow: `test-driven-development`, then `verification-before-completion`.

Per-path checklists, the flow diagram and the visual companion: `references/brainstorming-full.md`, `references/visual-companion.md`.
