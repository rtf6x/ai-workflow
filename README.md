# ai-workflow

Rules and skills for agent-assisted development: the agent does the work, you keep the
decisions. Plain markdown; the installer has no dependencies.

Visual guide: <https://rootfox.cc/interesting/ai-workflow/>

## Install

```bash
npx -y github:rtf6x/ai-workflow
```

That is the whole thing. It finds your harness, copies the eighteen skills into its
skills directory and merges the rules into its rules file between markers - so a second
run updates the block instead of appending another copy. Nothing else on your machine is
touched.

```bash
npx -y github:rtf6x/ai-workflow --dry-run          # show the plan, change nothing
npx -y github:rtf6x/ai-workflow --harness claude   # claude | omp | pi | opencode | zed | hermes | agents
npx -y github:rtf6x/ai-workflow --lang ru          # rules in Russian
npx -y github:rtf6x/ai-workflow --dest ~/skills --rules-file ~/AGENTS.md   # custom layout
npx -y github:rtf6x/ai-workflow --no-rules         # skills only
npx -y github:rtf6x/ai-workflow --link             # symlink instead of copy (from a clone)
```

Other ways, if you prefer them:

- **Hand it to an agent.** Give your agent this repository and ask it to set the process
  up: it reads `rules/`, writes them where your tool keeps its rules, and links the
  skills from `skills/`.
- **By hand.** `git clone https://github.com/rtf6x/ai-workflow && cd ai-workflow`, copy
  `rules/agent-rules.en.md` (or `.ru.md`) into your harness rules file, then
  `scripts/install.sh claude` (or `--dest DIR`) for the skills.

## What is inside

- `bin/ai-workflow.js` — the installer behind `npx` (Node 18+, no dependencies).
- `rules/agent-rules.en.md`, `rules/agent-rules.ru.md` — the ruleset, one section per rule.
- `skills/` — the workflow skills, listed below.
- `scripts/install.sh` — link the skills into a harness directory from a clone.
- `scripts/validate.sh` — check the set: frontmatter, duplicate or bare names, broken
  links, and rules that name a skill the set does not ship.

## Skills

| Skill | When it applies |
|---|---|
| `brainstorming` | Before any creative work - a new feature, component, behaviour change or project - classify the request, explore intent and present the design for… |
| `code-dry` | Remove duplication without paying for it with a bad abstraction. Use when the same logic appears in two or more places, and when tempted to… |
| `code-kiss` | Write flat, boring code. Use while writing any logic - a branch, a loop, a parser, a money path - and whenever a design tempts you into a factory,… |
| `code-refactor-safely` | Change existing code without changing its behaviour - refactoring, cleanup, dedup, simplification of code you did not write this turn. Use before… |
| `code-review` | Requesting an independent review of finished work, and handling the review you get back - after a task, before a merge, or when feedback arrives -… |
| `code-self-audit` | Audit code you just wrote before the final answer. Use at the end of any turn that produced or edited code, even when the user did not ask for a… |
| `code-yagni` | Cut what should not exist. Use before adding a helper, abstraction, dependency, config value, generic, file, or any new code path - and when asked… |
| `commit-gate` | Commit Gate before git commit. Full suite, scope, impact, guidelines, Safety First S4. |
| `design-gate` | Design Gate before coding. Output Design Brief, wait for user OK. |
| `discover-project-instructions` | Discover and read project agent instructions before any work. Use when entering a project or when conventions are unclear. |
| `dispatching-parallel-agents` | Two or more independent slices with no shared state, or a plan to execute by dispatching a fresh subagent per task - build the context, fan the… |
| `finishing-a-development-branch` | Implementation is done and the checks pass - verify the tree, then present the integration options (merge, PR, keep) and execute the user's choice. |
| `systematic-debugging` | Find the root cause before any fix - every bug, test failure, build break or unexpected behaviour, including the ones that look obvious and the… |
| `test-driven-development` | The RED-GREEN-REFACTOR cycle for every feature, bugfix, refactor or behaviour change, before writing implementation code - no exception unless the… |
| `using-git-worktrees` | Starting feature work that needs isolation from the current workspace, or before executing a plan - set up an isolated workspace using native… |
| `verification-before-completion` | Prove the change works before claiming it does - run the real thing, reproduce before and confirm after, and never report success you have not… |
| `writing-plans` | When a spec or agreed requirements need a multi-step build - write the plan map before touching code, then execute it one task at a time. |
| `writing-skills` | Creating a new skill or editing an existing one in this set - the format, the trigger discipline, the validation, and the TDD loop that proves the… |

## The idea in one paragraph

You decide the goal and approve the plan. The agent drafts scenarios, writes the test
before the code, runs everything, and reports what it observed — never what it expects.
Work moves one task at a time: implement, check, one line in the ledger, next task; the
test plan runs once at the end of the pass. Commits wait for your word, and merging is
never the agent's job.

## License

MIT. See `LICENSE`.
