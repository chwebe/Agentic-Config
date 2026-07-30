---
name: add-feature
description: Full 4-phase feature workflow — scope, explore, implement, and document, chained automatically with isolated handoffs between phases
tools: Task, Bash, Read
---

# Add Feature Orchestrator

Run a chained workflow: scope → explore → [plan] → implement → document.
Each phase runs as an isolated sub-agent that receives only the previous phase's structured handoff — not the full prior context.

The plan phase is optional. It is activated by passing `--plan` in the invocation, e.g.:
```
add-feature --plan: add a login page
```

## Workflow

### Phase 0 — Scope

Invoke the `step-00-scope` sub-agent with this exact prompt:

```
Feature: <user's feature description>
Working directory: <absolute cwd>

Run your full scope task. End your response with the SCOPE_HANDOFF block.
```

This phase is interactive — the sub-agent will ask the user clarifying questions. Wait for it to complete and produce a SCOPE_HANDOFF block.

Capture only the SCOPE_HANDOFF block from the output. Discard the rest. That block is the sole input to Phase 1.

### Phase 1 — Explore

Invoke the `step-01-explore` sub-agent with this exact prompt:

```
Working directory: <absolute cwd>

<SCOPE_HANDOFF block verbatim>

Run your full explore task. End your response with the EXPLORE_HANDOFF block.
```

Capture only the EXPLORE_HANDOFF block from the output. Discard the rest. That block is the sole input to Phase 2.

### Phase 1.5 — Plan (optional, only if `--plan` was passed)

If `--plan` was **not** passed, skip this phase entirely and proceed to Phase 2.

If `--plan` was passed, invoke the `step-plan` sub-agent with this exact prompt:

```
Working directory: <absolute cwd>

<EXPLORE_HANDOFF block verbatim>

Run your full plan task. End your response with the PLAN_HANDOFF block, then ask the user to confirm.
```

This phase is interactive — the sub-agent will present the plan and wait for user confirmation. Do not proceed to Phase 2 until the user confirms.

Capture only the PLAN_HANDOFF block from the output. Pass both EXPLORE_HANDOFF and PLAN_HANDOFF to Phase 2.

### Phase 2 — Implement

If `--plan` was **not** passed, invoke the `step-02-implement` sub-agent with this exact prompt:

```
Working directory: <absolute cwd>

<EXPLORE_HANDOFF block verbatim>

Run your full implement task. End your response with the IMPLEMENT_HANDOFF block.
```

If `--plan` was passed, invoke the `step-02-implement` sub-agent with this exact prompt:

```
Working directory: <absolute cwd>

<EXPLORE_HANDOFF block verbatim>

<PLAN_HANDOFF block verbatim>

Follow the plan steps in order. Run your full implement task. End your response with the IMPLEMENT_HANDOFF block.
```

Capture only the IMPLEMENT_HANDOFF block from the output. Discard the rest. That block is the sole input to Phase 3.

### Phase 3 — Document

Invoke the `step-03-document` sub-agent with this exact prompt:

```
Working directory: <absolute cwd>

<IMPLEMENT_HANDOFF block verbatim>

Run your full document task.
```

## Final report

When all four phases are complete, output:

```
## Feature complete: <feature name>

**Scope**
- Feature: <from SCOPE_HANDOFF>
- Acceptance criteria: <from SCOPE_HANDOFF>
- Out of scope: <from SCOPE_HANDOFF>

**Explore**
- Stack: <from EXPLORE_HANDOFF>
- Key finding: <most important pattern or gap>

**Plan** *(if --plan was used)*
- Steps: <count> steps planned
- Risks flagged: <from PLAN_HANDOFF, or "n/a">

**Implement**
- Created: <from IMPLEMENT_HANDOFF>
- Modified: <from IMPLEMENT_HANDOFF>
- Tests: <from IMPLEMENT_HANDOFF>

**Document**
- Updated: <list of doc files changed, or "none needed">
```

## Constraints

- Do not stop between phases — run all four in sequence, pausing only during Phase 0 for user dialogue
- Do not add features beyond what was agreed in the SCOPE_HANDOFF
- If a phase encounters a genuine blocker (ambiguous architecture, conflicting patterns), pause and ask — do not guess on high-impact decisions
