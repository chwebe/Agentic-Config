---
paths:
  - "**/CLAUDE.md"
  - "**/.claude/rules/*.md"
  - "**/CLAUDE.local.md"
---

# CLAUDE.md Anti-patterns

Failing CLAUDE.md files share recognisable patterns. Avoid them.

## The 6 failure modes

**Encyclopedic file** — tells the project's history and past architecture decisions. Claude skims it. Keep only actionable rules.

**Code-duplicate file** — explains what the code already says (endpoint lists, function signatures, config values). Only include what the code cannot express.

**Contradictory file** — a project rule conflicts with a global rule without justification. Resolve it: pick one, delete the other.

**"Everything is important" file** — no hierarchy, no clear guardrails. Force yourself to separate conventions (preferences) from guardrails (hard prohibitions).

**Frozen file** — never reviewed after creation. Plan a periodic review; stale rules waste context and mislead Claude.

**Too vague to act on** — rules like "write clean code" have no effect. Every rule must be specific enough that Claude can either comply or refuse.

## Signs your CLAUDE.md is too large

- More than 120 lines
- Contains paragraphs explaining business *why* rather than actionable rules
- You cannot recall what is in it without re-reading it
- Claude ignores multiple points in the same session

When these appear: cut. Keep only rules with a visible effect. Move the rest to comments or external docs.
