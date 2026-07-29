---
name: install-tmux
description: Install tmux with essential plugins (resurrect, continuum) and optimized keybindings. Detects Linux distribution and uses the appropriate package manager. Supports Arch, Debian/Ubuntu, Fedora, RHEL/CentOS, openSUSE, Alpine, Void, Gentoo, and NixOS.
---

# /install-tmux

Installs tmux and sets up plugins and keybindings:
- **tmux-resurrect**: Persist and restore tmux sessions
- **tmux-continuum**: Automatic session backup and restoration
- **dracula/tmux**: Dracula color theme with powerline status bar
- **Optimized keybindings**: Alt+h/v for splits, Alt+arrow for navigation, mouse support

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
   - Create `~/.tmux.conf` with plugin configuration and keybindings
   - Install TPM (Tmux Plugin Manager) and the following plugins:
     - **tmux-resurrect**: Save/restore tmux sessions
     - **tmux-continuum**: Auto-save sessions every 15 minutes and restore on startup
     - **dracula/tmux**: Dracula color theme with powerline status bar (cpu, ram, time)
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
   Report the installed version and confirm plugins are installed under `~/.tmux/plugins/`.

   **Any other non-zero exit — installation error:**
   Show the full error output and suggest a manual fallback based on the detected distro.
