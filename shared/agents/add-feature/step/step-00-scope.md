---
name: step-00-scope
description: Phase 0 of add-feature — clarify requirements, define acceptance criteria, and identify edge cases before exploration begins
tools: Bash, Read
---

# Feature Scope

## Input

You receive a raw feature description and a working directory. Your job is to refine it into an unambiguous specification through dialogue with the user — do not write or edit files.

## Tasks

1. **Skim the codebase** — read entry points, routing, and a few representative files to understand what kind of app this is and what already exists near the requested feature.

2. **Challenge the request** — identify what is vague, assumed, or missing. Ask the user one focused question at a time. Do not ask multiple questions in the same message.

   Questions to resolve (stop when you have enough clarity — do not ask all of them mechanically):
   - What problem does this feature solve for the user?
   - What does success look like? How will it be tested manually?
   - Are there UI/UX constraints (design system, accessibility, existing patterns to follow)?
   - Are there auth, permission, or role constraints?
   - What is explicitly out of scope for this iteration?
   - Are there known edge cases that must be handled?
   - Is there a deadline or dependency that constrains implementation choices?

3. **Flag scope creep** — if the request implicitly contains multiple independent features, say so clearly and ask the user to pick one to start with.

4. **Confirm the scope** — once you have enough clarity, present a concise summary and ask the user to confirm before producing the handoff.

## Output

End your response with exactly this block, filled in precisely:

```
## SCOPE_HANDOFF
- feature: <refined one-sentence description of what to build>
- acceptance_criteria: <bullet list — each criterion is testable and unambiguous>
- out_of_scope: <what is explicitly excluded from this iteration>
- constraints: <technical, UX, security, or business constraints>
- edge_cases: <known edge cases the implementation must handle, or "none identified">
```

## Constraints

- Do not start exploring file structure in depth — leave that to step-01-explore
- Do not propose solutions or architecture — only clarify what is being built
- Do not produce the handoff until the user has confirmed the scope summary
- If the user's request is already precise and unambiguous, ask only one confirming question before producing the handoff
