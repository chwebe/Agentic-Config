---
name: install-gh
description: Install the GitHub CLI (gh) on any Linux distribution. Detects the distro and uses the appropriate package manager or official GitHub CLI repository. Supports Arch, Debian/Ubuntu, Fedora, RHEL/CentOS, openSUSE, Alpine, Void, Gentoo, and NixOS.
---

# /install-gh

Installs the GitHub CLI (`gh`) using the correct method for the detected Linux distribution.

Usage: `/install-gh`

---

## Steps

1. Run the install script:
   ```bash
   bash ~/.claude/skills/install-gh/scripts/install-gh.sh
   ```

2. Interpret the result:

   **Exit 0 — success:**
   The script will:
   - Detect the Linux distribution from `/etc/os-release`
   - Install `gh` using the appropriate package manager or the official GitHub CLI apt/dnf/zypper repo
   - Print the installed version

   **Exit 2 — interactive sudo required:**
   The script cannot prompt for a password in a non-interactive context.
   Tell the user:
   > sudo requires an interactive terminal. Type the following in your prompt — the `!` prefix runs it in your shell so sudo can prompt for your password:
   > ```
   > ! bash ~/.claude/skills/install-gh/scripts/install-gh.sh
   > ```
   Wait for the user to run it and paste or forward the output back.
   Once they do, verify gh is installed:
   ```bash
   gh --version
   ```

   **Any other non-zero exit — installation error:**
   Show the full error output and suggest the manual fallback:
   > Visit https://cli.github.com/manual/installation for platform-specific instructions.
