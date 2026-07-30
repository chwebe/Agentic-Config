---
name: prompt-orchestrator
description: Scaffold a prompt-chaining orchestrator with typed handoffs between phases
---

# Prompt Orchestrator

Guide the user through creating a prompt-chaining orchestrator: one coordinator agent and N step sub-agents, each with strict Input / Tasks / Output contracts and a typed handoff block between phases.

## Step 1 — Gather requirements

Ask the user for:

1. **Workflow name** — kebab-case (e.g. `review-pr`, `process-data`)
2. **Phases** — ordered list; for each phase: a short name and a one-line purpose

Wait for their answers before continuing.

## Step 2 — Design handoffs

For each phase transition (phase N → phase N+1), define a handoff block:

- Name it `<PHASE_NAME>_HANDOFF` in SCREAMING_SNAKE_CASE
- List only the fields the next phase strictly needs — max 8
- If more than 8 fields are needed, the phase scope is too wide — split it

Present the full handoff design to the user and confirm before generating files.

## Step 3 — Scaffold directories

Run:

```bash
bash ~/.claude/skills/prompt-orchestrator/scripts/prompt-orchestrator.sh <workflow-name>
```

## Step 4 — Generate files

Write the following files using the exact templates below.

### Orchestrator — `shared/agents/<workflow-name>/<workflow-name>.md`

```markdown
---
name: <workflow-name>
description: <one-line summary of what the workflow does>
tools: Task, Bash, Read
---

# <Workflow Name> Orchestrator

Run a chained <N>-phase workflow: <phase1> → <phase2> → ... automatically.
Each phase runs as an isolated sub-agent and receives only the previous phase's handoff block — not the full prior context.

## Workflow

### Phase 1 — <Phase Name>

Invoke `step-01-<name>` with:

```
<describe what initial input to pass — feature description, file path, etc.>

Run your full task. End your response with the <HANDOFF_1> block.
```

Capture only the <HANDOFF_1> block from the output. Discard the rest.

[repeat for each subsequent phase, incrementing the step number and handoff name]

## Final report

When all phases are complete, output:

```
## <Workflow name> complete

**Phase 1 — <name>**: <key finding from handoff>
**Phase 2 — <name>**: <key output from handoff>
...
```

## Constraints

- Do not stop between phases — run all in sequence
- Do not add scope beyond what was requested
- On genuine blockers, pause and ask — do not guess
```

### Step files — `shared/agents/<workflow-name>/step/step-0N-<name>.md`

One file per phase, following this template:

```markdown
---
name: step-0N-<name>
description: Phase N of <workflow-name> — <one-line purpose>
tools: <only the tools this phase actually needs>
---

# <Step Name>

## Input

<What this step receives: either user input (phase 1) or the handoff block from the previous phase.>

## Tasks

1. <task>
2. <task>
3. <task>

## Output

End your response with exactly this block, filled in precisely:

```
## <PHASE_NAME>_HANDOFF
- field1: <description>
- field2: <description>
```

## Constraints

- <constraint specific to this phase>
- Do not perform work that belongs to another phase
```

## Step 5 — Register

Run setup to symlink the new agents into `~/.claude/agents/`:

```bash
bash ~/.config/Agentic-Config/setup.sh
```

Confirm the orchestrator and all step agents are now available.
