---
name: install-tmux
description: Install tmux, Oh My Tmux, and essential plugins (resurrect, continuum). Detects Linux distribution and uses the appropriate package manager. Supports Arch, Debian/Ubuntu, Fedora, RHEL/CentOS, openSUSE, Alpine, Void, Gentoo, and NixOS.
---

# /install-tmux

Installs tmux and sets up a complete terminal multiplexer environment:
- **Oh My Tmux**: Configuration framework with clean UI and sensible defaults
- **tmux-resurrect**: Persist and restore tmux sessions
- **tmux-continuum**: Automatic session backup and restoration

Usage: `/install-tmux`

---

## Steps

1. Run the install script:
   ```bash
   bash ~/.claude/skills/install-tmux/scripts/install-tmux.sh
   ```

2. Interpret the result:

   **Exit 0 — success:**
   The script will:
   - Install tmux (if not already installed) and report its version
   - Install Oh My Tmux into `~/.tmux` and create the `~/.tmux.conf` symlink
   - Create `~/.tmux.conf.local` with plugin configuration
   - Install TPM (Tmux Plugin Manager) and the following plugins:
     - **tmux-resurrect**: Save/restore tmux sessions
     - **tmux-continuum**: Auto-save sessions every 15 minutes and restore on startup
   - Report completion

   **Exit 2 — interactive sudo required:**
   The script cannot prompt for a password in a non-interactive context.
   Tell the user:
   > sudo requires an interactive terminal. Type the following in your prompt — the `!` prefix runs it in your shell so sudo can prompt for your password:
   > ```
   > ! bash ~/.claude/skills/install-tmux/scripts/install-tmux.sh
   > ```
   Wait for the user to run it and paste or forward the output back.
   Once they do, verify tmux is installed by running:
   ```bash
   tmux -V
   ```
   Report the installed version and confirm Oh My Tmux is at `~/.tmux`.

   **Any other non-zero exit — installation error:**
   Show the full error output and suggest a manual fallback based on the detected distro.
