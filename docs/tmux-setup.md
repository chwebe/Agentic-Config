# Tmux Setup Documentation

A terminal multiplexer environment optimized for development and remote work with Claude Code and other agent tools.

## What's Installed

**Core**
- **tmux**: Terminal multiplexer for session management

**Plugins**

| Plugin | Purpose | Keybinding |
|--------|---------|-----------|
| **tmux-resurrect** | Save/restore tmux sessions | `Ctrl-a Ctrl-s` (save), `Ctrl-a Ctrl-r` (restore) |
| **tmux-continuum** | Auto-saves sessions every 15 minutes; restores on startup | Automatic |
| **dracula/tmux** | Dracula color theme with powerline status bar (cpu, ram, time) | N/A |
| **tpm** | Tmux Plugin Manager (required for above plugins) | N/A |

### Window & Pane Configuration

#### Numbering
```
set -g base-index 1              # Windows start at 1 (not 0)
set -g pane-base-index 1         # Panes start at 1 (not 0)
set-option -g renumber-windows on # Auto-renumber when closing windows
```

**Effect:** More intuitive numbering that matches keyboard layout (1-9 on keypad)

#### Splitting Panes (Keep Current Directory)

**Quick split (no prefix):**
- `Alt+v` — split horizontally (side-by-side)
- `Alt+h` — split vertically (top-bottom)

**With prefix (`Ctrl-a`):**
- `Ctrl-a v` — split horizontally
- `Ctrl-a h` — split vertically

**Effect:** New panes open in the same directory as the current pane

#### Switching Panes (No Prefix)

- `Alt+Left` — move to left pane
- `Alt+Right` — move to right pane
- `Alt+Up` — move to upper pane
- `Alt+Down` — move to lower pane

**Effect:** Navigate between panes without hitting the prefix key first

#### Window Renaming

```
set-option -g allow-rename off
```

**Effect:** Windows keep their assigned names instead of auto-renaming to the running command

#### Mouse Support

```
set -g mouse on
```

**Effect:** Enable mouse control for:
- **Click** to select windows and panes
- **Click and drag** to resize panes
- **Scroll** within panes (with mouse wheel)
- **Select and copy** text with mouse (some terminals)

## Session Management

### Save a Session (Manual)
```bash
# Press Ctrl-a Ctrl-s
# or from shell:
tmux list-sessions
```

### Restore a Session
```bash
# Press Ctrl-a Ctrl-r
# or from shell:
tmux attach-session -t <session-name>
```

### Automatic Backup & Restore
- **Backup**: Continuum saves every 15 minutes automatically
- **Restore**: Sessions are restored automatically on tmux startup
- Files saved to: `~/.local/share/tmux/resurrect/`

## Working with Claude Code

### Recommended Layout

```
┌─────────────────────────────────────┐
│  Claude Code (left pane)           │
├──────────────┬──────────────────────┤
│ Terminal     │ Output/Debug         │
│ (bottom-left)│ (bottom-right)       │
└──────────────┴──────────────────────┘
```

**Create this layout:**
1. Start tmux: `tmux new-session -s work`
2. Alt+v — split main pane horizontally
3. Alt+Left — move to left pane
4. Alt+h — split left pane vertically

## Configuration Files

- **`~/.tmux.conf`** → Your tmux configuration with keybindings and plugins
- **`~/.tmux/plugins/`** → Installed plugins (tpm, resurrect, continuum)

## Useful Commands

| Command | Purpose |
|---------|---------|
| `tmux new-session -s <name>` | Create named session |
| `tmux attach -t <name>` | Attach to existing session |
| `tmux list-sessions` | List all sessions |
| `tmux kill-session -t <name>` | Delete session |
| `Ctrl-a d` | Detach from session (keep running) |
| `Ctrl-a c` | Create new window |
| `Ctrl-a n` / `Ctrl-a p` | Next/previous window |
| `Ctrl-a ,` | Rename current window |

## Remote Sessions

When connecting to another machine via SSH, your tmux sessions persist across disconnects:

```bash
ssh user@remote-host
# SSH disconnects
ssh user@remote-host
tmux attach -t <session-name>  # Reconnect to your session
```

Continuum will preserve and restore sessions on the remote host too.

## Troubleshooting

**Plugins not loading?**
```bash
tmux source ~/.tmux.conf
```

**Resurrect/continuum not saving?**
- Check `~/.local/share/tmux/resurrect/` exists
- Verify `set -g @continuum-save-interval '15'` is set

**Keybindings not working?**
- Verify `~/.tmux.conf` is sourced
- Reload config: `Ctrl-a :` then `source ~/.tmux.conf`

**Want to customize further?**
- Edit `~/.tmux.conf` directly
- Reload with `tmux source ~/.tmux.conf`
