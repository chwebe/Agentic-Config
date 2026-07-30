---
name: create-subagent
description: Scaffold a new Claude Code subagent definition file. Use when the user wants to create, add, or generate a new subagent. Guides through field selection, previews the result, and writes the .md file to the correct location.
---

# /create-subagent

Guides the user through creating a Claude Code subagent `.md` definition file.

Usage: `/create-subagent [name or brief description]`

Follow all 3 phases in order.

---

## Phase 1 — Understand the need

Use the `AskUserQuestion` tool to understand what the user wants to build. Focus on **intent and context**, not parameters. Never ask about technical fields (model, tools, background…) — those are inferred in Phase 2.

**Call 1 — two questions max:**

- Q1 `Purpose` — "What should this agent do? Describe the task it handles, when you'd call on it, and anything it should refuse or avoid."
- Q2 `Scope` — single-select: `Global – available in all projects (~/.claude/agents/)`, `This project only (.claude/agents/)`

If the answer to Q1 is ambiguous or too short, make a **second call** with at most 2 targeted follow-up questions to fill the gaps. Stop when you have enough to infer all parameters confidently.

Never ask the user about model, tools, background, maxTurns, effort, permissionMode, memory, or any other technical field — derive them from context using the decision rules below.

---

## Phase 2 — Infer parameters and summarise

### Parameter decision rules

Derive every technical field from the user's description. Use these rules:

| Field | Rule |
|---|---|
| `name` | Kebab-case slug derived from the agent's purpose (e.g. `sql-reviewer`) |
| `description` | Precise delegation trigger: what to use it for + what NOT to use it for |
| `model` | `haiku` for fast lookups / single-step tasks; `sonnet` for multi-step reasoning; `opus` / `fable` only if deep reasoning is explicitly needed |
| `tools` | Restrict to the minimum set the task requires. Inherit all only if the agent genuinely needs everything |
| `background` | `true` if the task is fire-and-forget (research, analysis, search); `false` if the result is needed inline |
| `maxTurns` | Set only if the agent could loop — use a value 2–3× the expected number of steps |
| `effort` | `low` for retrieval/lookup; `medium` (default) for standard tasks; `high`+ only for complex analysis or planning |
| `permissionMode` | `acceptEdits` if the agent writes files as part of its core job; `default` otherwise |
| `memory` | `project` if the agent benefits from project context across turns; omit otherwise |
| `color` | Pick a color that reflects the agent's domain (e.g. `cyan` for research, `green` for testing, `red` for security) |

### Summary table

Before showing the file preview, present a summary table explaining every non-default choice:

```
┌─ Subagent Summary ───────────────────────────────────────┐
│  <name>                                                  │
└──────────────────────────────────────────────────────────┘
```

| Field | Value | Why |
|---|---|---|
| `model` | sonnet | Multi-step reasoning required |
| `background` | true | Fire-and-forget research task |
| `tools` | Read, Grep, Glob | Read-only codebase exploration — no writes needed |
| … | … | … |

Only include fields that differ from defaults. Then show the full file preview in a fenced markdown block.

Ask the user to confirm or request changes before writing.

### File preview format

```
╔══ SUBAGENT PREVIEW ══════════════════════════════════════╗
║  <path>/<name>.md                                        ║
╚══════════════════════════════════════════════════════════╝
```

Compose a high-quality **system prompt** from the user's description. It should:
- Open with a one-sentence role statement
- List what the agent does in numbered steps or bullet points
- Include an explicit refusal boundary if the user mentioned one
- Be concise — no padding or boilerplate

---

## Phase 3 — Write

Once confirmed, write the file to the resolved path:
- Global: `~/.claude/agents/<name>.md`
- Project: `.claude/agents/<name>.md` (create directory if needed)

If the project lives under `~/git/git_perso/Agentic-Config/` (the shared config repo), write to `shared/agents/<name>.md` instead — it will be symlinked by `setup.sh`.

Confirm: *"Subagent written to `<full_path>`."*

---

## Frontmatter Reference

### Required fields

| Field | Type | Description |
|---|---|---|
| `name` | string | Kebab-case identifier used for invocation |
| `description` | string | Trigger signal — natural language description of when to delegate to this agent. Be specific: include use-case keywords and optionally what it should NOT be used for |

### Optional fields

| Field | Type | Description |
|---|---|---|
| `tools` | string[] | Allowlist of tools. If omitted, inherits every tool available to subagents |
| `disallowedTools` | string[] | Tools to block. Accepts `mcp__server`, `mcp__server__*`, or `mcp__*` patterns |
| `model` | string | `fable`, `opus`, `sonnet`, `haiku`, `inherit`, or a full model ID |
| `background` | boolean | Run as non-blocking background task — result arrives as a task notification |
| `maxTurns` | number | Hard limit on agentic turns before the agent stops |
| `effort` | `low\|medium\|high\|xhigh\|max\|number` | Reasoning effort level |
| `permissionMode` | PermissionMode | `default`, `acceptEdits`, or `bypassPermissions` |
| `memory` | `user\|project\|local` | Memory scope for this agent |
| `mcpServers` | (string\|object)[] | MCP servers available to this agent, by name or inline config |
| `skills` | string[] | Skills preloaded into the agent's context at startup |
| `initialPrompt` | string | Auto-submitted as first user turn — ignored when run as a subagent |
| `color` | string | UI background color: `blue`, `cyan`, `green`, `yellow`, `magenta`, `red` |

### Frontmatter format example

```markdown
---
name: example-agent
description: >
  Multi-line description with trigger conditions and refusal boundaries.
tools: Read, Write, Glob, Grep
model: sonnet
background: true
memory: project
maxTurns: 20
effort: medium
permissionMode: acceptEdits
color: cyan
skills:
  - skill-name-one
  - skill-name-two
mcpServers:
  - mcp-server-name
---

System prompt content goes here, below the closing ---.
```
