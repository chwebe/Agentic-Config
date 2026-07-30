---
name: create-subagent
description: Scaffold a new Claude Code subagent definition file. Use when the user wants to create, add, or generate a new subagent. Guides through field selection, previews the result, and writes the .md file to the correct location.
---

# /create-subagent

Guides the user through creating a Claude Code subagent `.md` definition file.

Usage: `/create-subagent [name or brief description]`

Follow all 3 phases in order.

---

## Phase 1 — Gather requirements

Ask the user for the following in a **single message** (never one question at a time):

| # | Field | Question |
|---|---|---|
| 1 | **Name** | Kebab-case identifier — e.g. `code-reviewer` |
| 2 | **Purpose** | What does this agent do? When should it be delegated to? What should it refuse? |
| 3 | **Tools** | Which tools does it need? (see reference below) — leave blank to inherit all |
| 4 | **Model** | `fable`, `opus`, `sonnet`, `haiku`, or blank to inherit from parent |
| 5 | **Background** | Should it run as a non-blocking background task? (yes/no — default: no) |
| 6 | **Scope** | Project-level (`.claude/agents/`) or global (`~/.claude/agents/`)? |

Only ask about advanced fields if the user's description implies a need:
- `maxTurns` — if the agent might loop indefinitely
- `effort` — if reasoning depth matters (`low`, `medium`, `high`, `xhigh`, `max`)
- `permissionMode` — if the agent needs to auto-approve edits (`acceptEdits`) or skip prompts (`bypassPermissions`)
- `memory` — if the agent needs persistent memory (`user`, `project`, `local`)
- `mcpServers` — if the agent needs specific MCP servers
- `skills` — if the agent should have preloaded skills
- `color` — if the user wants a UI color (`blue`, `cyan`, `green`, `yellow`, `magenta`, `red`)

---

## Phase 2 — Preview

Generate the full agent definition and show it as a fenced code block before writing anything.

Compose a high-quality **system prompt** from the user's purpose description. It should:
- Open with a one-sentence role statement
- List what the agent does in numbered steps or bullet points
- Include an explicit refusal boundary if the user mentioned one
- Be concise — avoid padding or boilerplate

Show the complete file:

```
╔══ SUBAGENT PREVIEW ══════════════════════════════════════╗
║  ~/.claude/agents/<name>.md                              ║
╚══════════════════════════════════════════════════════════╝
```

Then the file content as a fenced markdown block.

Ask the user to confirm or request changes before writing.

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
