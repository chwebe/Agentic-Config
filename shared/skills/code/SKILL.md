---
name: code
description: Full feature implementation workflow — explore context, plan, execute, verify linters.
---

# /code

Feature implementation workflow. Follow all 4 phases in order. Never skip ahead.

---

## Phase 1 — Exploration

Gather full context before touching any code.

1. Always spawn the `codebase-explorer` agent with the feature description as input.
   - Goal: locate related files, existing patterns, entry points, and conventions.

2. If the feature involves a library, framework, or external API — spawn the `explore-docs` agent.
   - Always fetch live documentation. Never rely on training data for API signatures or config keys.

3. If additional context requires live web data (recent changelogs, issues, blog posts) — spawn `web-researcher`.

Run all relevant agents in parallel when independent. Summarise every finding before moving on.

---

## Phase 2 — Plan

1. Invoke the `writing-plans` skill to structure the implementation.
2. Enter plan mode with `EnterPlanMode`.
3. Based on exploration findings, draft a step-by-step plan:
   - Files to create or modify (with paths)
   - Libraries or imports to add
   - Key logic and architectural decisions
   - Order of execution
4. Present the plan clearly and wait for the user to approve it.

Do not write any code until the plan is explicitly approved.

---

## Phase 3 — Execute

Once the user approves:

1. Exit plan mode and implement each step in the approved order.
2. Use `TaskCreate` to track each step; mark tasks `completed` as you finish them.
3. Stay strictly within the approved plan scope — no extra refactoring, no bonus features.

---

## Phase 4 — Verify

After all steps are complete:

1. Detect the project's linter and type checker setup:
   - JavaScript/TypeScript: check `package.json` scripts for `lint`, `typecheck`, `tsc`
   - Python: check for `ruff`, `pylint`, `mypy`, `flake8` in `pyproject.toml` or `setup.cfg`
   - Other: check `Makefile`, `justfile`, or CI config for lint targets
2. Run every linter and type checker found.
3. Fix all errors reported. Re-run until all checks pass clean.
4. Report: what ran, what was fixed, final status.
