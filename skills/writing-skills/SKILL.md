---
name: writing-skills
description: Creating a new skill or editing an existing one in this set - the format, the trigger discipline, the validation, and the TDD loop that proves the skill actually changes agent behaviour.
---

# Writing skills

A skill is a reference guide for a technique, pattern or tool that applies beyond one project. It is not a narrative about how a problem was solved once.

Writing a skill is TDD applied to documentation: run the behaviour without the skill, watch it fail, write the skill that fixes exactly that failure, then verify compliance.

## Layout in this set

```
skills/<name>/SKILL.md            frontmatter name + description, then the body
skills/<name>/references/...      long-form text, templates, assets
skills/<name>/upstream.yaml       vendored skills only: source, path, commit, license, fetched_at
```

- `SKILL.md` stays short (about 40 lines): when it applies, the rules that change behaviour, how to report, and pointers into `references/`.
- Long methodology goes to `references/`, not into `SKILL.md`. A vendored skill keeps its license beside it.
- Vendored skills are updated from their upstream, never hand-edited; `upstream.yaml` is what makes that possible.

## Description = the trigger

The description is what makes an agent reach for the skill. It answers "when", not "what it is about":

- Bad: "TDD best practices" - nothing tells the agent when it applies.
- Good: "The RED-GREEN-REFACTOR cycle for every feature, bugfix or behaviour change, before writing implementation code."

One skill per capability, one trigger per skill. Bare generic names (`audit`, `polish`, `shape`) are banned - qualify them (`ui-audit`). Two skills whose triggers overlap is a defect, not a nuance.

## Proving the skill works

1. Run the scenario without the skill and write down what the agent actually does wrong.
2. Write only what closes that gap.
3. Re-run: the agent must now comply.
4. Refactor by finding the next rationalization and closing it - the loopholes are the test cases.

If an agent never failed the scenario, the skill teaches nothing.

## Check before committing

`scripts/validate.sh` in the set repository is the mechanical gate: folder name matches frontmatter `name`, description present and long enough, no duplicate or banned names, live links, targets linked, no orphaned symlinks. Run it, then commit the skill and the install in the same change.

Full methodology, discovery optimization, flowchart and markdown conventions: `references/writing-skills-full.md`, `references/anthropic-best-practices.md`, `references/testing-skills-with-subagents.md`, `references/persuasion-principles.md`.
