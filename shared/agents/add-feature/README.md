# Add Feature Workflow

A chained agent workflow for adding a feature to any project — web, mobile, backend, CLI, or library. Phases run in sequence via the orchestrator, each receiving only the previous phase's structured handoff.

---

## Phases

| Phase | Agent | Optional | Does |
|---|---|---|---|
| 0 | `step-00-scope` | No | Clarifies requirements, defines acceptance criteria, identifies edge cases |
| 1 | `step-01-explore` | No | Reads the codebase, detects the stack, finds existing patterns |
| 1.5 | `step-plan` | Yes (`--plan`) | Produces a concrete implementation plan with a human review gate |
| 2 | `step-02-implement` | No | Writes feature code and tests |
| 3 | `step-03-document` | No | Updates CHANGELOG, README, and CLAUDE.md |

---

## Usage

### Full workflow (recommended)

```
@add-feature Add a dark mode toggle to this Next.js app.
```

### With the optional plan phase

Use `--plan` when the feature is complex or touches multiple layers. The workflow pauses after planning and waits for your confirmation before writing any code.

```
@add-feature --plan: Add a dark mode toggle to this Next.js app.
```

---

## How chaining works

```
User → add-feature orchestrator
         │
         ├─ step-00-scope        → SCOPE_HANDOFF     (interactive: asks clarifying questions)
         │
         ├─ step-01-explore      → EXPLORE_HANDOFF   (autonomous)
         │
         ├─ step-plan (optional) → PLAN_HANDOFF      (interactive: shows plan, waits for confirm)
         │
         ├─ step-02-implement    → IMPLEMENT_HANDOFF (autonomous)
         │
         └─ step-03-document     → docs updated      (autonomous)
```

Each sub-agent receives only the previous phase's handoff block — not the full conversation. This keeps context short and each agent focused.

**Interactive phases** (scope, plan) pause and wait for your input before the chain continues. All other phases run unattended.

---

## Handoff reference

### SCOPE_HANDOFF (scope → explore)

```
## SCOPE_HANDOFF
- feature: <refined one-sentence description>
- acceptance_criteria: <bullet list of testable criteria>
- out_of_scope: <what is explicitly excluded>
- constraints: <technical, UX, security, or business constraints>
- edge_cases: <known edge cases to handle, or "none identified">
```

### EXPLORE_HANDOFF (explore → plan or implement)

```
## EXPLORE_HANDOFF
- stack: <language | framework | test-tool | package-manager>
- target_path: <absolute folder path where the feature code goes>
- reuse: <comma-separated absolute file paths to extend or reuse, or "none">
- naming: <key conventions e.g. PascalCase components, camelCase hooks>
- gaps: <what must be created from scratch>
- ext_docs: <key API detail fetched, or "none">
```

### PLAN_HANDOFF (plan → implement, only with --plan)

```
## PLAN_HANDOFF
- steps: <ordered list — each step is "action: file path — what changes">
- test_strategy: <per-behavior test approach>
- risks: <flagged decisions with recommended option, or "none">
- scope_delta: <any scope change discovered during planning, or "none">
```

### IMPLEMENT_HANDOFF (implement → document)

```
## IMPLEMENT_HANDOFF
- created: <comma-separated absolute file paths of new files>
- modified: <comma-separated absolute file paths of changed files>
- tests: <N tests added, pass | fail>
- new_pattern: <yes: one-line description | no>
- feature_summary: <one sentence describing what was built>
```

---

## Using agents individually

Each agent can be invoked standalone. Pass the previous handoff as part of your prompt.

**Phase 0 — Scope:**
```
@step-00-scope
Feature: Add a dark mode toggle
Working directory: /path/to/project
```

**Phase 1 — Explore:**
```
@step-01-explore
Working directory: /path/to/project

## SCOPE_HANDOFF
- feature: Add a dark mode toggle with localStorage persistence
- acceptance_criteria:
  - Toggle switches between light and dark theme
  - Preference persists across page reloads
  - Defaults to system preference on first visit
- out_of_scope: Per-page theme overrides
- constraints: Must use existing design system tokens
- edge_cases: System preference changes while app is open
```

**Phase 1.5 — Plan (optional):**
```
@step-plan
Working directory: /path/to/project

## EXPLORE_HANDOFF
...
```

**Phase 2 — Implement:**
```
@step-02-implement
Working directory: /path/to/project

## EXPLORE_HANDOFF
...

## PLAN_HANDOFF   ← include only if you ran step-plan
...
```

**Phase 3 — Document:**
```
@step-03-document
Working directory: /path/to/project

## IMPLEMENT_HANDOFF
...
```

---

## Tips

- **Use `--plan` for complex features** — anything touching more than two layers (e.g. API + DB + UI) benefits from a plan review before code is written.
- **Phase 0 is your spec** — the scope conversation is the most valuable part. A vague request produces vague code; push back during scope.
- **One feature at a time** — if Phase 0 reveals multiple independent features, finish scoping one before starting the workflow.
- **Run and verify after Phase 2** — tests passing is not the same as the feature working. Check the golden path manually before moving to Phase 3.
- **Commit after Phase 3** — all phases together produce one coherent, documented change.

---

## Files touched by each agent

| Agent | Reads | Writes |
|---|---|---|
| `step-00-scope` | Entry points, a few representative files | Nothing |
| `step-01-explore` | Source files, config files, optional external docs | Nothing |
| `step-plan` | Files listed in EXPLORE_HANDOFF | Nothing |
| `step-02-implement` | Files listed in EXPLORE_HANDOFF (and PLAN_HANDOFF if present) | `src/`, `tests/`, or equivalent |
| `step-03-document` | Files listed in IMPLEMENT_HANDOFF | CHANGELOG.md, README.md, CLAUDE.md (when needed) |
