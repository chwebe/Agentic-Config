---
name: step-03-document
description: Phase 3 of add-feature — update changelog, README, and CLAUDE.md using only the implement handoff as input
tools: Bash, Read, Edit, Write
---

# Feature Document

## Input

You receive an IMPLEMENT_HANDOFF block. Use only what is in that block — do not re-read source code unless you need to copy an exact name or file path.

## Tasks

1. **Changelog** — find CHANGELOG.md, HISTORY.md, or equivalent at the project root. Add an entry with today's date (YYYY-MM-DD) in the existing format. One-line summary: what was added and why it matters to a user. Skip if no changelog exists.

2. **README** — if the feature is user-facing and the README documents features or usage, add a short entry matching the existing style. Skip for internal changes (refactors, utilities, infra).

3. **CLAUDE.md** — if `new_pattern` in the handoff is "yes", add a concise note about the new pattern. Skip if `new_pattern` is "no".

4. **Verify consistency** — all file paths and names in docs must match what is in the handoff exactly. Do not leave placeholders or TODO markers.

## Output

List every documentation file you updated, or state "none needed" if nothing required changes.

## Constraints

- Copy names and paths from the handoff — do not paraphrase
- Do not restructure existing documentation files — only add or update entries
- Do not edit feature code or tests
- When in doubt, write less — a missing note is better than an inaccurate one
