# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo is a versioned store of shared Claude Code configuration — agents, rules, and global CLAUDE.md — intended to be synced across machines. Nothing here is executed directly; files are referenced or symlinked into `~/.claude/`.

## Architecture

```
shared/
├── claude/
│   └── CLAUDE.md          # Global CLAUDE.md, symlinked to ~/.claude/CLAUDE.md
├── agents/
│   └── *.md               # Custom agent definitions loaded by Claude Code
├── rules/
│   └── *.md               # Rule files imported via @rules/<name>.md in CLAUDE.md
└── skills/
    └── <name>/
        └── SKILL.md       # Skill definition, symlinked into ~/.claude/skills/ and ~/.claude/commands/
```

`shared/claude/CLAUDE.md` is the active global config. It uses `@rules/<name>.md` imports to pull in rule files from `shared/rules/`. New rules go in `shared/rules/` and are wired in via an `@` import in `shared/claude/CLAUDE.md`.

## Setup

Run `setup.sh` once after cloning (or after adding new files) to create all symlinks:

```bash
bash ~/.config/Agentic-Config/setup.sh
```

It symlinks each file individually:
- `shared/agents/*.md` → `~/.claude/agents/`
- `shared/rules/*.md` → `~/.claude/rules/`
- `shared/skills/<name>/` → `~/.claude/skills/<name>`
- `shared/skills/<name>/SKILL.md` → `~/.claude/commands/<name>.md`

The script is idempotent — safe to re-run after adding new agents, rules, or skills.

## Conventions

- Agent files (`shared/agents/*.md`) follow the Claude Code agent frontmatter schema: `name`, `description`, `tools`.
- Rule files are plain markdown — no frontmatter needed.
- Skills live in `shared/skills/<name>/SKILL.md`. Shell logic goes in `shared/skills/<name>/scripts/<name>.sh`; SKILL.md only calls that script.