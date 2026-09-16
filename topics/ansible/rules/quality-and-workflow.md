---
paths:
  - "**/ansible.cfg"
  - "**/playbooks/**"
  - "**/roles/**"
  - "**/inventory/**"
  - "**/group_vars/**"
  - "**/host_vars/**"
---

# Ansible Quality & Workflow

## Guardrails

- **Idempotency is mandatory.** Running a playbook a second time against an already-converged target must report `changed=0`. If the second run still shows changes, the task is broken — fix it before merging; a non-idempotent task will corrupt state on every later run.
- **Always use the fully-qualified collection name (FQCN) for modules.** Write `ansible.builtin.copy`, never the bare `copy`. Short names are ambiguous once more than one collection ships a module with the same name.
- **Run `ansible-lint` locally before creating a commit or pushing.** Linting is a pre-commit, local-only gate — never add `ansible-lint` to the CI pipeline.
