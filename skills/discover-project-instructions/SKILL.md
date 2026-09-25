---
name: discover-project-instructions
description: Discover and read project agent instructions before any work. Use when entering a project or when conventions are unclear.
---

# Discover Project Instructions

Run before Design Gate.

## Find (project root)

1. `AGENTS.md` / `agents.md`
2. `CLAUDE.md` / `.claude/CLAUDE.md` — follow `@` imports, don't read twice
3. `.rules/`, `RULES.md` — project-local rule files, if present
4. `.github/copilot-instructions.md`, `.claude/rules/` — if present

Skip: `node_modules/`, `vendor/`, dependency `AGENTS.md`.

## Report briefly in chat

```
## Project Context
Root: ...
Files: AGENTS.md, CLAUDE.md → @AGENTS.md, ...
Commands: ...
Constraints: 3–5 bullets
```

Do not paste full files. Project rules override global defaults; workflow phases still apply.

Re-run when switching repos or subprojects.
