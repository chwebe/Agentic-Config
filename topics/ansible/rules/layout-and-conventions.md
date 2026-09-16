---
paths:
  - "**/ansible.cfg"
  - "**/playbooks/**"
  - "**/roles/**"
  - "**/inventory/**"
  - "**/group_vars/**"
  - "**/host_vars/**"
---

# Ansible Layout & Conventions

## Directory layout

```
my-project/
│
├── ansible.cfg              # Ansible configuration (forks, become, callbacks…)
├── requirements.yml         # External collections and roles -> ansible-galaxy install -r requirements.yml
├── requirements.txt         # Python dependencies for modules -> pip install -r requirements.txt
├── .ansible-lint            # Custom ansible-lint rules
│
├── inventory/
│   ├── hosts.yml            # Main inventory (YAML)
│   ├── production.yml       # Production inventory (optional)
│   └── staging.yml          # Staging inventory (optional)
│
├── group_vars/
│   ├── all.yml              # Variables for all hosts
│   ├── webservers.yml       # Variables for the webservers group
│   └── dbservers.yml        # Variables for the dbservers group
│
├── host_vars/
│   ├── web1.lab.yml         # Variables specific to web1.lab
│   └── db1.lab.yml          # Variables specific to db1.lab
│
├── roles/
│   └── ...                  # Ansible roles
│
├── collections/
│   └── ...                  # Collections downloaded via ansible-galaxy
│
├── playbooks/
│   └── ...                  # Ansible playbooks
│
├── files/
│   └── ...                  # Static files (keys, configs, scripts…)
│
├── templates/
│   └── ...                  # Shared Jinja2 templates
│
├── library/
│   └── ...                  # Custom Python modules
│
├── filter_plugins/
│   └── ...                  # Custom Jinja2 filter plugins
│
└── lookup_plugins/
    └── ...                  # Custom lookup plugins
```

## Variable precedence

Ansible resolves variables from many sources with a strict precedence order — lowest to highest, later sources always win:

1. `roles/<role>/defaults/main.yml` — role defaults, the lowest precedence, meant to be overridden by callers
2. `group_vars/all.yml`, then `group_vars/<group>.yml` — inventory group variables, `all` first, more specific groups after
3. `host_vars/<host>.yml` — inventory variables for a single host
4. Facts gathered from the host, and previously cached `set_fact` results
5. `vars:`, `vars_prompt:`, `vars_files:` on the play — play-level variables
6. `roles/<role>/vars/main.yml` — role vars, no override
7. `vars:` on a block or a task — scoped to that block/task only
8. Variables loaded via `include_vars`
9. `set_fact` / registered variables (`register:`) created during the run
10. Role or `include_role` parameters (`vars:` passed when calling the role)
11. `--extra-vars` / `-e` on the CLI — always wins, overrides every other source

> Rule of thumb: use `defaults/` for anything a caller should be able to override, `vars/` for constants the role owns, and reserve `--extra-vars` for one-off runtime overrides, not as a permanent configuration mechanism.

## Naming conventions

- **Hostnames**: `<role><number>.<env>.<domain>` — e.g. `web1.prod.example.com`, `db2.staging.example.com`
- **Inventory groups**: kebab-case, plural — `webservers`, `dbservers`, `load-balancers`
- **Variables**: snake_case, prefixed with the owning role or component — `nginx_port`, `nginx_workers`, `pg_version`
- **Roles**: snake_case — `nginx_lab`, `pg_backup`
- **Playbooks**: action verb or target group, kebab-case — `deploy-webservers.yml`, `harden-baseline.yml`, `site.yml`
- **Tasks**: capitalized, imperative, describe the action — `Install nginx package`, `Restart nginx service`
- **Handlers**: mirror the task they respond to — `restart nginx`, `reload firewall`
- **Tags**: short, descriptive, lowercase — `nginx`, `firewall`, `monitoring`
- **Files & templates**: match the name of the resource they configure — `templates/nginx.conf.j2`, `files/ssh/authorized_keys`
