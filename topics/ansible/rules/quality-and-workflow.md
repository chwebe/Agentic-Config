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
- **Prefer a dedicated module over `command`/`shell`.** They bypass Ansible's idempotency checks. Before reaching for either, confirm no dedicated module exists for the action; if you still need one, guard it with `creates:`/`removes:` (or `changed_when`) so a second run reports no change.

  Bad — reruns every time, never reports `changed=0`:
  ```yaml
  - name: Initialize PostgreSQL data directory
    ansible.builtin.shell: pg_ctl initdb -D /var/lib/pgsql/data
  ```

  Good — idempotent, skipped once the data directory exists:
  ```yaml
  - name: Initialize PostgreSQL data directory
    ansible.builtin.shell: pg_ctl initdb -D /var/lib/pgsql/data
    args:
      creates: /var/lib/pgsql/data/PG_VERSION
  ```
