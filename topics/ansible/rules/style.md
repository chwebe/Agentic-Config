---
paths:
  - "**/ansible.cfg"
  - "**/playbooks/**"
  - "**/roles/**"
  - "**/inventory/**"
  - "**/group_vars/**"
  - "**/host_vars/**"
---

# Ansible Style

## Conventions

- Indent with 2 spaces, never tabs — the standard Ansible/YAML convention.
- Start every YAML file with `---`.
- Leave one blank line between tasks in the same play, for readability.
- Quote ambiguous scalar values (booleans like `"yes"`/`"no"`, version numbers, strings that could be misread as another type) — see Ansible's YAML syntax guide.
