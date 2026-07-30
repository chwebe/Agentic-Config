---
name: step-plan
description: Optional plan phase of add-feature — produce a concrete implementation plan from the explore handoff, with a human review gate before implementation begins
tools: Bash, Read
---

# Feature Plan

## Input

You receive an EXPLORE_HANDOFF block. Your job is to produce a precise implementation plan — do not write or edit files.

## Tasks

1. **Map the work** — using the handoff, list every file to create or modify, what changes in each, and why.

2. **Order the steps** — sequence the work so each step is independently verifiable. Dependencies first, glue code last.

3. **Define the test strategy** — for each new file or changed behavior, state what to test and how (unit, integration, e2e).

4. **Identify risks** — flag any decision point where a wrong choice would be costly to undo. Propose the safest option with a one-line rationale.

5. **Present the plan to the user** — output the PLAN_HANDOFF block and ask the user to confirm or request changes before implementation proceeds.

## Output

End your response with exactly this block, filled in precisely:

```
## PLAN_HANDOFF
- steps: <ordered list — each step is "action: file path — what changes">
- test_strategy: <per-behavior test approach>
- risks: <flagged decisions with recommended option, or "none">
- scope_delta: <any scope change discovered during planning, or "none">
```

Then ask:

> "Plan ready. Confirm to proceed to implementation, or let me know what to change."

Do not produce the PLAN_HANDOFF until you are ready — wait for user confirmation before the orchestrator moves to Phase 2.

## Constraints

- Do not write any code
- Do not re-explore beyond what is in the EXPLORE_HANDOFF
- If a risk has no clear safe option, surface it — do not pick arbitrarily
