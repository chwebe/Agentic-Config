---
name: doc-gen
description: Transform raw notes into structured Markdown documentation for Obsidian (or any Markdown vault). Supports script references, cheatsheets, runbooks, and CLI references. Reads CLAUDE.md to resolve output path automatically.
---

# /doc-gen

Transforms raw, messy notes into structured, professional Markdown documentation.

Usage: `/doc-gen [type] <notes or /path/to/notes.txt>`

`type` is optional — one of `script-reference`, `cheatsheet`, `runbook`, `cli-reference`. If omitted, the analyzer will infer it from the notes.

Follow all 3 phases in order. Never skip ahead.

---

## Phase 1 — Resolve configuration

Spawn the `doc-gen-context` agent.

- It reads `CLAUDE.md` and any loaded rule files in the **current working directory**.
- It returns: `output_path` and `frontmatter_enabled`.
- If `output_path` is `NOT_SET`: ask the user where to write the documentation, then relay this warning:
  > You can avoid this prompt in the future by adding the following to your `CLAUDE.md`:
  > ```
  > # doc-gen
  > doc-gen output: ~/your/vault/docs/
  > doc-gen frontmatter: true
  > ```

Record `output_path` and `frontmatter_enabled` — they are passed to Phase 3.

---

## Phase 2 — Analyze notes and determine type

Spawn the `doc-gen-analyzer` agent with:
- The raw notes (inline text and/or file content).
- The optional type hint from the user argument (pass it even if absent — the agent handles it).

The analyzer will:
1. Read and fully understand the notes.
2. Classify the documentation type (`script-reference`, `cheatsheet`, `runbook`, `cli-reference`).
3. Ask the user targeted clarifying questions (max 3 per round) until ~90% context confidence is reached.
4. Return a `DOC_GEN_CONTEXT` object.

### Phase 2b — Unknown type

If the analyzer returns `type: UNKNOWN`:
1. Report to the user what was detected.
2. Ask them to describe the structure they want for this new documentation type.
3. Pass those instructions to `doc-gen-writer` in template-creation mode (before generation).
4. The writer will create a new template at `<templates_dir>/<new-type>.md` and confirm it with the user before proceeding.

Do not continue to Phase 3 until the context object is complete and the type is resolved.

---

## Phase 3 — Generate and write

Spawn the `doc-gen-writer` agent with:
- The `DOC_GEN_CONTEXT` object from Phase 2.
- `output_path` from Phase 1.
- `frontmatter_enabled` from Phase 1.
- The path to the templates directory: `~/.claude/skills/doc-gen/templates/` (or equivalent).

The writer will:
1. Select the matching template.
2. Propose a kebab-case filename derived from the document title.
3. Show the full output path and ask the user to confirm (or rename).
4. Fill the template with the analyzed content.
5. Write the file.
6. Confirm: *"Documentation written to `<full_path>`."*
