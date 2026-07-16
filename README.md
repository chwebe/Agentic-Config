# Agentic-Config

Versioned store of shared Claude Code configuration — agents, rules, and skills — synced across machines via symlinks.

## Structure

```
shared/
├── claude/
│   └── CLAUDE.md          # Global CLAUDE.md (symlinked to ~/.claude/CLAUDE.md)
├── agents/
│   └── *.md               # Custom sub-agents
├── rules/
│   └── *.md               # Rule files imported in CLAUDE.md via @rules/<name>.md
└── skills/
    └── <name>/
        └── SKILL.md       # Slash-command skill
```

## Setup

```bash
git clone <this-repo> ~/.config/Agentic-Config
bash ~/.config/Agentic-Config/setup.sh
```

`setup.sh` creates individual symlinks for every agent, rule, and skill:

| Source | Symlink |
|---|---|
| `shared/agents/*.md` | `~/.claude/agents/*.md` |
| `shared/rules/*.md` | `~/.claude/rules/*.md` |
| `shared/skills/<name>/` | `~/.claude/skills/<name>` |
| `shared/skills/<name>/SKILL.md` | `~/.claude/commands/<name>.md` |

The script is idempotent — re-run it after adding new files to the repo.

## Adding new content

**Agent:** create `shared/agents/<name>.md`, run `setup.sh`.

**Rule:** create `shared/rules/<name>.md`, import it in `shared/claude/CLAUDE.md` with `@rules/<name>.md`, run `setup.sh`.

**Skill:** create `shared/skills/<name>/SKILL.md` (shell logic in `shared/skills/<name>/scripts/<name>.sh`), run `setup.sh`.
