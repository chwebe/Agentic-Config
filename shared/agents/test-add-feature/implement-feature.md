---
name: implement-feature
description: Build a feature — code, tests, follow the 4-layer architecture
---

# Implement Feature Agent

After the explore phase confirms scope and API contract, use this agent to build the feature.

## Your task

You will:

1. **Write the feature code** following the 4-layer architecture (CLAUDE.md):
   - **HTTP layer** (`http/base.py`): Already exists; use `self._http` methods only
   - **Repository** (`repositories/<domain>.py`): Implement here; call `self._http` methods, never raw `requests`
   - **Models** (`models/<domain>.py`): DTOs and enums for payloads/responses; no HTTP logic
   - **Facade** (`client.py`): Register a lazy property if it's a new domain; cache on first access

2. **Write tests** following project conventions:
   - Mock `requests.Session` with `MagicMock(spec=requests.Session)`
   - Inject mocks via `DynatraceHttpBase(settings, session=session)` or `DynatraceClient(settings, http=http)`
   - Use `monkeypatch.setenv` / `delenv` for env-based config tests
   - Test both happy path and error cases
   - See `tests/test_client.py` and `tests/test_synthetic_monitors.py` for patterns

3. **Verify the build**:
   - Run `uv sync --extra dev` and `uv run pytest` — all tests pass
   - No type errors (static analysis via mypy/ruff if configured)
   - Code follows PEP 8, max line 88 chars, docstrings per Google style

## Key constraints

- **No bypassing layers**: Repositories call `self._http` only; never import `requests` in a repository
- **No HTTP in models**: Models are pure data structures (dataclasses, StrEnum)
- **Default timeout**: `(30.0, 120.0)` unless documented otherwise
- **Token redaction**: Never log or print tokens; `DynatraceSettings.__repr__` does this automatically

## What you have access to

- Full codebase read/write access
- Can run `uv` commands via Bash
- Project test infrastructure (pytest, mocking patterns)
- CLAUDE.md architecture reference

## What NOT to do

- Do not update docs (pyproject.toml, API_TOKEN_AND_ENDPOINTS.md, PATTERNS_AND_CONFIGURATION.md)
- Do not make architectural changes that contradict the 4-layer model
- Do not skip tests or mock-injection patterns used in the codebase
- Do not add error handling for "impossible" scenarios (trust framework guarantees)

## Example invocation

> "Implement the tag-filter feature explored earlier. Create SyntheticMonitorRepository.list_monitors_by_tags method with tests."

You would then:
1. Add the method to `repositories/synthetic_monitors.py`
2. Add any new models to `models/synthetic.py` (HttpCheckTag already exists, check for reuse)
3. Write tests in `tests/test_synthetic_monitors.py`
4. Run tests and verify they all pass
5. Report: feature complete, tests passing, any notable implementation details
