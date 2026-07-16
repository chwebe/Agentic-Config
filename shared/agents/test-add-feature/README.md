# Feature Development Workflow — Agent Reference

Use these three agents in sequence when adding a new feature to the Dynatrace client.

---

## Phase 1: Explore

**Agent:** `@explore-feature`

**When to use:** At the start of any new feature; clarifies scope, reusability, and API contract before coding.

**What it does:**
- Searches the codebase for existing implementations or reusable patterns
- Fetches Dynatrace API documentation via Context7 MCP
- Reports: existing code to reuse, API schema, required token scopes, architecture fit, feature outline

**Invoke:**
```
@explore-feature Explore adding <feature description>.
```

**Example:**
```
@explore-feature Explore adding the ability to list synthetic monitors by tag with AND/OR logic (v1 API).
```

**What you get:**
- **Existing code**: "Found `HttpCheckTag` model in models/synthetic.py. `list_monitors` exists; can extend it."
- **API schema**: "GET /api/v1/synthetic/monitors with `tag` param (array), `type` param (HTTP/BROWSER). Response: `{monitors: [...]}`"
- **Architecture fit**: "Add method to `SyntheticMonitorRepository`, extend `models/synthetic.py` if needed"
- **Feature outline**: "New method `list_monitors_by_tags(*tags, match_all=False)` — v1 API with AND (single request) or OR (deduplicated) logic"

**Next step:** Review findings, agree on scope, then move to Phase 2.

---

## Phase 2: Implement

**Agent:** `@implement-feature`

**When to use:** After explore phase confirms the feature scope and API details.

**What it does:**
- Writes feature code following the 4-layer architecture (factory → facade → repository → HTTP)
- Writes unit tests (mocking `requests.Session`, no real network calls)
- Runs tests to verify they pass
- Reports: code complete, tests passing, any notable implementation details

**Invoke:**
```
@implement-feature Implement <feature description> based on explore findings.
```

**Example:**
```
@implement-feature Implement SyntheticMonitorRepository.list_monitors_by_tags(). 
Use v1 GET /api/v1/synthetic/monitors with tag and type parameters.
Support AND logic (match_all=True) and OR logic (match_all=False, deduplicated).
Reference: explore phase found existing HttpCheckTag model — reuse it.
```

**What you get:**
- Feature code in the correct repository/model files
- Unit tests in `tests/test_synthetic_monitors.py`
- Test output showing all tests pass
- Notes on any gotchas (e.g., "v1 API returns only BROWSER monitors if type is omitted")

**Constraints the agent follows:**
- Uses `self._http` methods only; never raw `requests`
- Follows PEP 8, max 88 chars per line
- Google-style docstrings with type hints
- All exceptions are specific (not generic `Exception`)
- Tests mock all network calls

**Next step:** Review code and tests. Run locally if you want to verify. Then move to Phase 3.

---

## Phase 3: Document

**Agent:** `@document-feature`

**When to use:** After implementation is complete and all tests pass.

**What it does:**
- Updates `CLAUDE.md` (domain repositories table)
- Updates `dynatrace-client/docs/API_TOKEN_AND_ENDPOINTS.md` (endpoint map + changelog)
- Updates `dynatrace-client/docs/PATTERNS_AND_CONFIGURATION.md` (non-obvious behavior)
- Verifies `dynatrace-client/pyproject.toml` (new dependencies, if any)
- Reports: all docs updated and in sync

**Invoke:**
```
@document-feature Document <feature> with endpoint <path>, HTTP method <method>, scopes <scope1>, <scope2>.
```

**Example:**
```
@document-feature Document list_monitors_by_tags. 
Endpoint: GET /api/v1/synthetic/monitors
HTTP: GET
Scopes: settings.read (to list monitors)
Dynatrace docs: https://docs.dynatrace.com/docs/discover-dynatrace/references/dynatrace-api/environment-api/synthetic/synthetic-monitors/get-all-monitors
Special notes: v1 API; type parameter required (HTTP or BROWSER); omitting type returns BROWSER only; tag parameter can be array for AND logic.
```

**What you get:**
- Updated CLAUDE.md with new row in Domain repositories table (if new domain) or updated row (if extending existing)
- New row in API_TOKEN_AND_ENDPOINTS.md with endpoint, method, scopes, link to official docs
- Changelog entry in API_TOKEN_AND_ENDPOINTS.md with today's date and one-line summary
- Optional note in PATTERNS_AND_CONFIGURATION.md if the feature has quirks
- Verification that pyproject.toml is up to date (new dependencies already added during Phase 2)

**Key details:**
- Endpoint link must point to official Dynatrace API docs (not this repo)
- Scopes must match Dynatrace UI exactly (e.g., `entities.read`, `settings.write`, `ExternalSyntheticIntegration`)
- Changelog date format: YYYY-MM-DD (e.g., 2026-07-15)

**Next step:** Verify the docs are correct, commit everything together.

---

## Full Workflow Example

### Scenario: Add a new feature to list monitors by tag

**Day 1 — Explore phase:**
```
User: "@explore-feature Explore adding monitor tag filtering with AND/OR logic."

Agent: Reports existing HttpCheckTag, v1 API contract, scopes needed.

User: "Looks good. The AND/OR logic matches our use case."
```

**Day 1 — Implement phase:**
```
User: "@implement-feature Implement list_monitors_by_tags() based on explore findings."

Agent: Writes code + tests, reports: SyntheticMonitorRepository.list_monitors_by_tags added, 
       5 new tests passing (OR logic, AND logic, empty tags error, etc.).

User: Reviews code locally, runs tests, approves.
```

**Day 1 — Document phase:**
```
User: "@document-feature Document list_monitors_by_tags. 
       Endpoint: GET /api/v1/synthetic/monitors, Scopes: settings.read, 
       Dynatrace docs: [link], Special: type param required (HTTP/BROWSER)."

Agent: Updates CLAUDE.md (SyntheticMonitorRepository row), 
       API_TOKEN_AND_ENDPOINTS.md (new row + changelog), 
       PATTERNS_AND_CONFIGURATION.md (note about AND vs OR semantics).

User: Verifies docs, commits all changes together.
```

---

## Common Patterns

### Agent Handoff

Each agent reads output from the previous one. When you invoke the next agent, include the key findings:

```
# Explore → Implement handoff
@implement-feature Implement based on explore findings:
  - Reusable: HttpCheckTag model exists
  - Endpoint: GET /api/v1/synthetic/monitors
  - Scope: settings.read
  - Feature outline: list_monitors_by_tags(*tags, match_all=False)
```

### Parallel Work (Implement + Document)

After explore phase, you *can* run implement and document in parallel if you're confident in the spec. But sequential is safer:
1. Implement → review locally
2. Document → verify docs match code
3. Commit together

### Reusing Existing Domains

If you're extending an existing domain (e.g., adding a method to `SyntheticMonitorRepository`):
- Explore phase: confirm the method doesn't exist
- Implement phase: add method to existing repository file
- Document phase: update CLAUDE.md "Key methods" cell (don't add a new row)

### New Domains

If you're adding a completely new API domain (e.g., a new `dynatrace_client.repositories.webhooks` module):
- Explore phase: verify no similar domain exists
- Implement phase: create new repository + facade property on `DynatraceClient`
- Document phase: add new row to CLAUDE.md Domain repositories table, new section in API_TOKEN_AND_ENDPOINTS.md

---

## Tips

1. **Save agent outputs**: Copy-paste findings from explore into implement and document invocations. This ensures consistency.
2. **API docs first**: Always fetch actual Dynatrace API docs via Context7 (not training data). Scope names and endpoints change.
3. **Tests are non-negotiable**: Implement phase always includes tests. Don't skip this.
4. **Docs are a checklist**: Use the agent's template to ensure nothing is missed. One missing scope name breaks the endpoint map.
5. **Commit after Phase 3**: Only commit after all three phases complete. Each phase depends on the previous one's output.

---

## Files Updated by Each Agent

| Agent | Reads | Writes |
| --- | --- | --- |
| **explore-feature** | All source + docs | None (reports only) |
| **implement-feature** | Source (reference patterns) | `src/`, `tests/` |
| **document-feature** | Feature code + CLAUDE.md | `CLAUDE.md`, `docs/API_TOKEN_AND_ENDPOINTS.md`, `docs/PATTERNS_AND_CONFIGURATION.md`, `pyproject.toml` |

---

## Troubleshooting

**"Explore phase says the feature already exists."**
- Use existing method if it meets your needs (DRY)
- If you need to extend it, note that in implement phase

**"Implement phase fails tests."**
- Mock injection patterns must match existing tests (see `tests/test_client.py`)
- Never call raw `requests`; always use `self._http`

**"Document phase says scopes don't match."**
- Verify scope names in Dynatrace UI (they're the source of truth)
- Common mistake: `entities.read` vs `entity.read` — use UI spelling

---

## Questions?

Refer to:
- **Architecture**: `CLAUDE.md` → "Architecture" section
- **API versioning notes**: `CLAUDE.md` → "Dynatrace API versioning"
- **Testing patterns**: `CLAUDE.md` → "Testing conventions"
- **Dependency policy**: `.claude/rules/python-uv.md`
- **Code style**: `.claude/rules/python-coding-standards.md`