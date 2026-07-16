# Git Commit Convention

All commits must follow the [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) specification.

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

| Type | When to use |
|------|-------------|
| `feat` | A new feature (MINOR in SemVer) |
| `fix` | A bug fix (PATCH in SemVer) |
| `build` | Changes to the build system or external dependencies |
| `chore` | Routine tasks, maintenance, no production code change |
| `ci` | Changes to CI configuration files and scripts |
| `docs` | Documentation changes only |
| `style` | Formatting, missing semicolons, etc. — no logic change |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or correcting tests |

## Rules

- The `<type>` and `<description>` are mandatory.
- The `<description>` immediately follows the `<type>[scope]: ` prefix — no capital letter, no period at the end.
- Scope is optional and must be a noun in parentheses: `feat(auth): ...`
- Breaking changes must be indicated with `!` before the colon (`feat!: ...`) or a `BREAKING CHANGE:` footer.
- `BREAKING CHANGE` must be uppercase; all other tokens are case-insensitive.
- Body and footers are separated from the description by a blank line.
- Add a body when the one-line description does not fully explain the *why*: a non-obvious motivation, a workaround for an external bug, a compliance or architectural constraint, or a breaking change that needs context.
- Skip the body when the title is self-explanatory or the diff speaks for itself.

## Examples

```
feat(lang): add Polish language

fix: prevent racing of requests

feat!: drop support for Node 6

docs: correct spelling in CHANGELOG

refactor(api): rename user endpoint to account

fix(auth): handle expired tokens correctly
```

## Co-authorship

Never add Claude (or any Anthropic AI model) as a `Co-Authored-By` trailer in commits.
