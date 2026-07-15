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
    └── <name>/            # Skill definitions (source of truth, symlinked into ~/.claude/)
```

`shared/claude/CLAUDE.md` is the active global config. It uses `@rules/<name>.md` imports to pull in rule files from `shared/rules/`. New rules go in `shared/rules/` and are wired in via an `@` import in `shared/claude/CLAUDE.md`.

## Conventions

- Agent files (`shared/agents/*.md`) follow the Claude Code agent frontmatter schema: `name`, `description`, `tools`.
- Rule files are plain markdown — no frontmatter needed.
- Skills must be authored in `~/.agents/skills/<name>/SKILL.md` and symlinked into `~/.claude/` — never written directly into `~/.claude/commands/`.
- Shell logic for skills lives in `~/.agents/skills/<name>/scripts/<name>.sh`; the SKILL.md file only calls that script.