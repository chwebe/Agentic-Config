# Agentic-Config

Versioned store of shared Claude Code configuration — agents, rules, and skills — synced across machines via symlinks.

## Structure

```
shared/
├── claude/
│   └── CLAUDE.md              # Global CLAUDE.md (symlinked to ~/.claude/CLAUDE.md)
├── agents/
│   ├── *.md                   # Custom sub-agents
│   └── <group>/               # Subdirectory for related agents (README.md excluded)
│       └── *.md
├── rules/
│   ├── *.md                   # Rule files imported in CLAUDE.md via @rules/<name>.md
│   └── <group>/               # Subdirectory for related rules
│       └── *.md
└── skills/
    └── <name>/
        └── SKILL.md           # Slash-command skill
```

Agents and rules support one level of subdirectories for organization. Files are linked flat into `~/.claude/agents/` and `~/.claude/rules/` — subdirectory names are not preserved in the destination.

## Setup

```bash
git clone <this-repo> ~/.config/Agentic-Config
bash ~/.config/Agentic-Config/setup.sh
```

`setup.sh` creates individual symlinks for every agent, rule, and skill:

| Source | Symlink |
|---|---|
| `shared/agents/*.md` and `shared/agents/*/*.md` | `~/.claude/agents/*.md` |
| `shared/rules/*.md` and `shared/rules/*/*.md` | `~/.claude/rules/*.md` |
| `shared/skills/<name>/` | `~/.claude/skills/<name>` |
| `shared/skills/<name>/SKILL.md` | `~/.claude/commands/<name>.md` |

The script is idempotent — re-run it after adding new files to the repo. It logs `[added]`, `[updated]`, or `[skip]` for each entry, and `[removed]` when a stale symlink is cleaned up.

## Adding new content

**Agent:** create `shared/agents/<name>.md` or `shared/agents/<group>/<name>.md`, run `setup.sh`.

**Rule:** create `shared/rules/<name>.md` or `shared/rules/<group>/<name>.md`, import it in `shared/claude/CLAUDE.md` with `@rules/<name>.md`, run `setup.sh`.

**Skill:** create `shared/skills/<name>/SKILL.md` (shell logic in `shared/skills/<name>/scripts/<name>.sh`), run `setup.sh`.
