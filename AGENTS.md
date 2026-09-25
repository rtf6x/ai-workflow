# AGENTS.md — working in ai-workflow

Public set of rules and workflow skills. Plain markdown, no build step, no dependencies.

## Invariants

- **One capability — one skill.** A duplicate inside the set is a bug; `scripts/validate.sh` catches duplicate and banned bare names.
- **A skill is a trigger, not an essay.** `SKILL.md` stays short and answers "when does this apply"; long-form material lives in `references/`.
- **Every rule carries an anchor.** Each rule in `rules/` is a section of its own, so a script can assert that every copy of the ruleset still has it.
- **Both languages stay in step.** A rule edited in `rules/agent-rules.en.md` is edited in `rules/agent-rules.ru.md` in the same change.
- **Commits in English**, meaningful message, push right after.

## Layout

```
rules/agent-rules.<lang>.md   the ruleset, one section per rule
skills/<name>/SKILL.md        short skill: frontmatter name + description, then the body
skills/<name>/references/…    long-form text and templates
scripts/install.sh            link the set into a harness directory
scripts/validate.sh           check the set (read-only); --selftest checks the validator
```

## Commands

```bash
scripts/validate.sh              # before every commit; red means do not commit
scripts/validate.sh --selftest   # the validator against fixtures
scripts/install.sh <harness>     # claude | omp | pi | opencode | zed | hermes | agents
```

## Done when

- `scripts/validate.sh` is green.
- The rules and skills are in step with each other: a rule that names a skill, names one that exists.
- `git status` is clean and the commit is pushed.
