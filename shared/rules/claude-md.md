# CLAUDE.md Creation Rules

Based on the official Anthropic documentation.

## File locations and scope

Claude loads CLAUDE.md files in this order (broadest → most specific), **concatenating** all levels:

| Level | Location | Scope |
|---|---|---|
| Managed policy | `/etc/claude-code/CLAUDE.md` (Linux/WSL) | Org-wide, cannot be excluded |
| User | `~/.claude/CLAUDE.md` | Global — all projects, personal preferences |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Project — shared with the team via git |
| Local | `./CLAUDE.local.md` | Personal overrides, git-ignored |

All levels are **concatenated** top-to-bottom — there is no true override. The lowest file wins because it appears last in context.

Files above the working directory load fully at session start. Files in subdirectories load on demand when Claude reads files in those directories.

## Recommended structure

Use this 6-section skeleton as a starting point:

- **Stack** — technologies and versions in use
- **Role** — one paragraph describing what the project does
- **Key directories** — annotated tree of important folders
- **Useful commands** — lint, test, local server, help flags
- **Conventions** — rules to follow (preferences)
- **Guardrails** — things Claude must NOT do without explicit approval

**Conventions vs guardrails**: conventions are preferences ("use named exports"); guardrails are hard prohibitions ("never drop a database table without explicit confirmation"). Force yourself to separate them — mixing the two weakens both.

## What to put in CLAUDE.md

Include only what Claude **cannot infer from the code itself**:

- Build / test / lint commands
- Architecture overview (monorepo structure, key packages)
- Code style decisions not enforced by a linter
- Workflow rules (branch naming, commit conventions, PR process)
- Project-specific constraints or gotchas
- Pointers to external resources (design docs, runbooks)

**Do NOT include:**
- Things already enforced by config files (ESLint, Prettier, tsconfig…)
- Step-by-step tutorials or verbose documentation
- Information that changes frequently (keep it stable)
- What the code already says (endpoint lists, function signatures)

## Structure and format

- **Ideal**: 60–120 lines — **Max**: 200 lines
- Use short bullet points, not prose paragraphs
- Group rules by topic with `#` headings
- Prefer actionable rules ("Use ES modules" not "We like ES modules")
- Block-level HTML comments (`<!-- note -->`) are stripped from context at load time — use them for maintainer notes that should not consume tokens

## Modular organisation with imports

Use `@path` syntax to split rules into separate files and keep CLAUDE.md short.
Imports are resolved relative to the file, or as absolute paths. Nesting up to **4 levels deep** is supported.

```markdown
# CLAUDE.md
@rules/code-style.md
@rules/testing.md
@rules/security.md
```

Use backtick paths to **reference** a file without importing it:

```markdown
See `docs/architecture.md` for the full design.
```

Recommended layout:

```
project/
├── CLAUDE.md              # imports only, stays short
└── .claude/
    └── rules/
        ├── code-style.md
        ├── testing.md
        └── security.md
```

## Path-scoped rules

**Subdirectory CLAUDE.md** — place a CLAUDE.md directly in a subdirectory to scope rules to that folder:

```
src/
├── api/
│   └── CLAUDE.md    # rules only for API files
└── frontend/
    └── CLAUDE.md    # rules only for frontend files
```

**`.claude/rules/` with path frontmatter** — conditional loading by file glob. Rules only load when Claude works with matching files:

```markdown
---
paths:
  - "src/api/**/*.ts"
  - "tests/**/*.test.ts"
---
# API rules
- Validate all inputs at the endpoint boundary
- Use the standard error response format
```

Rules without a `paths:` frontmatter load unconditionally. Prefer this approach for large projects to reduce context consumption.

## How to build a CLAUDE.md in 5 steps

1. **Audit** — stack, versions, dependencies, runtime prerequisites
2. **Config map** — first-level directory tree with one-line descriptions per folder
3. **Conventions** — existing patterns, file naming, error handling, imports — written as short rules
4. **Agent sections** — if using multiple agents, add focused sections per agent (QA → test zones; DevOps → pipelines)
5. **Assemble** — write the 6-section structure; extract heavy sections via `@path` imports

## Useful commands

- `/init` — generate a starter CLAUDE.md from the current codebase
- `/context` — see which CLAUDE.md and rule files loaded in the current session
- `/memory` — browse and edit all CLAUDE.md files live

## Anti-patterns

@rules/claude-md-antipatterns.md
