# CLAUDE.md Creation Rules

Based on the official Anthropic documentation.

## File locations and scope

Claude loads CLAUDE.md files in this order (broadest → most specific):

| Location | Scope |
|---|---|
| `~/.claude/CLAUDE.md` | Global — all projects, personal preferences |
| `./CLAUDE.md` or `./.claude/CLAUDE.md` | Project — shared with the team via git |
| `./CLAUDE.local.md` | Local — personal overrides, git-ignored |

Files above the working directory are loaded fully at launch. Files in subdirectories load on demand when Claude reads files in those directories.

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

## Structure and format

- Keep it under ~200 lines — treat it as a cheat sheet, not full documentation
- Use short bullet points, not prose paragraphs
- Group rules by topic with `#` headings
- Prefer actionable rules ("Use ES modules" not "We like ES modules")

```markdown
# Code style
- Use ES modules (import/export), not CommonJS (require)
- Destructure imports when possible

# Workflow
- Typecheck after every series of changes
- Run single tests, not the full suite, for performance
```

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

For rules that only apply to specific file types or subdirectories, place a CLAUDE.md directly in that subdirectory instead of polluting the root file.

```
src/
├── api/
│   └── CLAUDE.md    # rules only for API files
└── frontend/
    └── CLAUDE.md    # rules only for frontend files
```

## Initialisation

Run `/init` once per new repository — Claude reads the project structure and writes an initial CLAUDE.md automatically. Review and trim it before committing.
