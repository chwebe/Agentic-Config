# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo is a versioned store of shared Claude Code configuration — agents, rules, and global CLAUDE.md — intended to be synced across machines. Nothing here is executed directly; files are referenced or symlinked into `~/.claude/`.

## Architecture

```
shared/
├── claude/
│   └── CLAUDE.md              # Global CLAUDE.md, symlinked to ~/.claude/CLAUDE.md
├── agents/
│   ├── *.md                   # Custom agent definitions loaded by Claude Code
│   └── <group>/               # Subdirectory for related agents (README.md excluded)
│       └── *.md
├── rules/
│   ├── *.md                   # Rule files imported via @rules/<name>.md in CLAUDE.md
│   └── <group>/               # Subdirectory for related rules
│       └── *.md
└── skills/
    └── <name>/
        └── SKILL.md           # Skill definition, symlinked into ~/.claude/skills/ and ~/.claude/commands/
```

`shared/claude/CLAUDE.md` is the active global config. It uses `@rules/<name>.md` imports to pull in rule files from `shared/rules/`. New rules go in `shared/rules/` and are wired in via an `@` import in `shared/claude/CLAUDE.md`.

Agents and rules support one level of subdirectories for organization. Files are always linked flat into `~/.claude/agents/` and `~/.claude/rules/` — subdirectory names are not preserved in the destination.

## Setup

Run `setup.sh` once after cloning (or after adding new files) to create all symlinks:

```bash
bash ~/.config/Agentic-Config/setup.sh
```

It symlinks each file individually:
- `shared/agents/*.md` and `shared/agents/*/*.md` → `~/.claude/agents/`
- `shared/rules/*.md` and `shared/rules/*/*.md` → `~/.claude/rules/`
- `shared/skills/<name>/` → `~/.claude/skills/<name>`
- `shared/skills/<name>/SKILL.md` → `~/.claude/commands/<name>.md`

The script is idempotent — safe to re-run after adding new files. It logs `[added]`, `[updated]`, or `[skip]` for each entry, and `[removed]` when a stale symlink pointing into `shared/` is cleaned up.

## Topics

Topic-dedicated rules and skills (e.g. Ansible) live in `topics/<name>/`, separate from `shared/`. They apply only to a specific technology, not to every Claude Code session, so they are deployed on demand rather than always symlinked into `~/.claude/`:

```
topics/
└── <name>/                    # e.g. ansible
    ├── rules/
    │   └── *.md                # Path-scoped: frontmatter `paths:` glob, not @imported
    └── skills/
        └── <name>/SKILL.md
```

Deploy a topic into any destination with:
```bash
bash deploy-topic.sh <name> <destination-dir>
```
It verifies `topics/<name>` exists, then symlinks its `rules/` and `skills/` into `<destination-dir>`, the same way `setup.sh` does for `shared/`.

## Conventions

- Agent files follow the Claude Code agent frontmatter schema: `name`, `description`, `tools`. `README.md` inside agent subdirectories is ignored by `setup.sh`.
- `shared/rules/*.md` files are plain markdown — no frontmatter needed. `topics/<name>/rules/*.md` files use `paths:` frontmatter to scope when they load.
- Skills live in `shared/skills/<name>/SKILL.md`. Shell logic goes in `shared/skills/<name>/scripts/<name>.sh`; SKILL.md only calls that script.

## Plugin management

When you add, update, or modify a tmux plugin, always update `@shared/skills/install-tmux/` to include the plugin installation in the automated setup. This ensures new machines can bootstrap the complete environment with a single skill run.

## Tmux documentation

Whenever you change tmux configuration, keybindings, or plugins, update `docs/tmux-setup.md` to reflect the changes. Keep the documentation in sync so users have an accurate reference of what's available and how to use it.