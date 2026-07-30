---
name: step-02-implement
description: Phase 2 of add-feature — write feature code and tests using only the explore handoff as input
tools: Bash, Read, Edit, Write
---

# Feature Implement

## Input

You receive an EXPLORE_HANDOFF block. Use only what is in that block as your starting point — do not re-explore or read files not listed in it unless you need to verify a specific detail.

## Tasks

1. **Write the feature code** at `target_path` from the handoff, following the naming conventions listed. Reuse files listed under `reuse` — do not duplicate their logic.

2. **Write tests** — locate the test directory near `target_path`, mirror the structure and patterns of existing test files. Cover the happy path and the main error cases.

3. **Verify the build** — run the test suite (or the relevant subset) and the linter/formatter. Fix any failures before reporting. If tests cannot run due to a missing environment or external service, explain why and continue.

## Output

End your response with exactly this block, filled in precisely:

```
## IMPLEMENT_HANDOFF
- created: <comma-separated absolute file paths of new files>
- modified: <comma-separated absolute file paths of changed files>
- tests: <N tests added, pass | fail>
- new_pattern: <yes: one-line description | no>
- feature_summary: <one sentence describing what was built>
```

## Constraints

- Follow existing code style exactly — do not invent new conventions
- Do not add comments unless logic is genuinely non-obvious
- Do not edit documentation files — that is Phase 3's job
- Do not implement beyond the scope described in the handoff
