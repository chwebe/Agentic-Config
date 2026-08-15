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
- **zsh tmux alias fix**: if oh-my-zsh's `tmux` plugin is active, patches `~/.zshrc` so `tmux` keeps working inside Claude Code's own Bash-tool shells (see below)

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
   - If `~/.zshrc` has oh-my-zsh's `tmux` plugin enabled, patch it and verify the patch (see **zsh tmux alias fix** below)
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

## zsh tmux alias fix

oh-my-zsh's `tmux` plugin defines `alias tmux=_zsh_tmux_plugin_run`. Claude Code's
shell snapshots (used to replay the user's shell env into Bash-tool shells) drop
underscore-prefixed functions, so that alias dangles outside a real interactive
terminal — every `tmux` command run by Claude Code fails with
`command not found: _zsh_tmux_plugin_run`, even though `tmux` works fine in the
user's actual terminal.

The script detects this (zsh + oh-my-zsh + `tmux` in the `plugins=(...)` line of
`~/.zshrc`) and, if not already patched, appends a block to `~/.zshrc` that
copies the plugin's function body to a non-underscore name (`tmux_run`) and
re-points the `tmux` alias at it — same behavior, but visible to the snapshot
filter. It then verifies the patch by checking `type tmux_run` in a real
interactive zsh (`zsh -ic`).

Interpreting script output for this step:
- `"zsh tmux alias fix already present in ~/.zshrc"` — already patched, nothing to do.
- `"Patched ~/.zshrc"` followed by `"Verified: tmux alias now resolves to tmux_run ..."` — fix applied and confirmed working.
- `"Warning: could not verify tmux_run in an interactive zsh ..."` — patch was written but verification failed; inspect `~/.zshrc` manually.
- No mention of this step at all — the user isn't on zsh, doesn't use oh-my-zsh, or doesn't have the `tmux` plugin enabled, so the fix doesn't apply.

Tell the user the fix only takes effect in **new** shells/sessions — Claude Code's
snapshot for the *current* session was already taken before the patch, so `tmux`
may still fail in this session's Bash-tool calls until a new session starts.
