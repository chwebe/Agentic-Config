# Git Branch Naming Convention

All branch names must follow a consistent, descriptive convention that makes the branch's purpose immediately clear.

## Format

```
<type>/<description>
```

With an optional ticket/issue number:

```
<type>/<ticket-id>-<description>
```

## Types

| Type | When to use |
|------|-------------|
| `feature` | New feature or functionality |
| `bugfix` | Bug fix in a non-production branch |
| `hotfix` | Urgent fix for a production issue |
| `release` | Preparing a new release |
| `refactor` | Code restructuring with no behavior change |
| `docs` | Documentation changes only |
| `test` | Adding or updating tests |
| `chore` | Build process, dependencies, tooling |
| `ci` | CI/CD configuration changes |

## Rules

- **Lowercase only** — `feature/add-login`, never `Feature/Add-Login`
- **Hyphens as separators** — `bugfix/fix-null-pointer`, never underscores or spaces
- **No leading dots or trailing slashes** — git rejects them
- **Alphanumeric + hyphens only** — no special characters (`@`, `#`, `~`, `^`, `:`, `?`, `*`)
- **Keep it short and descriptive** — 3–5 words in the description is ideal
- **Include ticket number when applicable** — placed between the type and description: `feature/PROJ-123-add-user-auth`

## Examples

```
feature/add-oauth-login
feature/PROJ-42-user-dashboard
bugfix/fix-token-expiry
hotfix/patch-payment-gateway
release/v2.1.0
refactor/extract-auth-middleware
docs/update-api-reference
test/add-checkout-integration-tests
chore/upgrade-node-18
ci/add-coverage-report
```

## What to avoid

```
# Bad — no type prefix
add-login

# Bad — uppercase
Feature/AddLogin

# Bad — spaces
feature/add user login

# Bad — underscores
feature/add_user_login

# Bad — too vague
feature/changes

# Bad — special characters
feature/fix-issue#123
```
