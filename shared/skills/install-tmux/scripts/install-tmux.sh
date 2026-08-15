#!/usr/bin/env bash
set -euo pipefail

# Detect Linux distribution and install tmux using the appropriate package manager.

detect_distro() {
    if [ -f /etc/os-release ]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        echo "${ID:-unknown}"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/fedora-release ]; then
        echo "fedora"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/alpine-release ]; then
        echo "alpine"
    else
        echo "unknown"
    fi
}

already_installed() {
    command -v tmux &>/dev/null
}

run_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif command -v sudo &>/dev/null; then
        if ! sudo -n true 2>/dev/null; then
            echo "NEEDS_INTERACTIVE_SUDO" >&2
            exit 2
        fi
        sudo "$@"
    else
        echo "Error: neither root nor sudo available." >&2
        exit 1
    fi
}

install_tmux() {
    local distro
    distro=$(detect_distro)

    echo "Detected distribution: ${distro}"

    case "${distro}" in
        arch | manjaro | endeavouros | garuda)
            run_as_root pacman -Sy --noconfirm tmux
            ;;
        debian | ubuntu | linuxmint | pop | kali | raspbian | elementary)
            run_as_root apt-get update -qq
            run_as_root apt-get install -y tmux
            ;;
        fedora)
            run_as_root dnf install -y tmux
            ;;
        rhel | centos | rocky | almalinux | ol)
            if command -v dnf &>/dev/null; then
                run_as_root dnf install -y tmux
            else
                run_as_root yum install -y tmux
            fi
            ;;
        opensuse* | sles)
            run_as_root zypper install -y tmux
            ;;
        alpine)
            run_as_root apk add --no-cache tmux
            ;;
        nixos)
            echo "NixOS detected — install tmux via nix-env or add it to your configuration.nix."
            echo "  nix-env -iA nixpkgs.tmux"
            exit 0
            ;;
        void)
            run_as_root xbps-install -Sy tmux
            ;;
        gentoo)
            run_as_root emerge --ask=n app-misc/tmux
            ;;
        *)
            echo "Unknown distribution '${distro}'. Trying common package managers..."
            if command -v apt-get &>/dev/null; then
                run_as_root apt-get update -qq && run_as_root apt-get install -y tmux
            elif command -v dnf &>/dev/null; then
                run_as_root dnf install -y tmux
            elif command -v pacman &>/dev/null; then
                run_as_root pacman -Sy --noconfirm tmux
            elif command -v zypper &>/dev/null; then
                run_as_root zypper install -y tmux
            elif command -v apk &>/dev/null; then
                run_as_root apk add --no-cache tmux
            else
                echo "No supported package manager found. Install tmux manually." >&2
                exit 1
            fi
            ;;
    esac
}


install_tmux_plugins() {
    echo "Installing tmux plugins..."

    mkdir -p ~/.tmux/plugins

    if [ ! -d ~/.tmux/plugins/tpm ]; then
        echo "  Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi

    if [ ! -d ~/.tmux/plugins/tmux-resurrect ]; then
        echo "  Installing tmux-resurrect..."
        git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
    fi

    if [ ! -d ~/.tmux/plugins/tmux-continuum ]; then
        echo "  Installing tmux-continuum..."
        git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum
    fi

    if [ ! -d ~/.tmux/plugins/tmux ]; then
        echo "  Installing Dracula theme..."
        git clone https://github.com/dracula/tmux ~/.tmux/plugins/tmux
    fi

    echo "Plugins installed successfully."
}

fix_zsh_tmux_alias() {
    # oh-my-zsh's tmux plugin defines `alias tmux=_zsh_tmux_plugin_run`.
    # Claude Code's shell snapshots (used to replay the user's shell env into
    # Bash-tool shells) drop underscore-prefixed functions, so that alias
    # dangles outside a real interactive terminal, breaking every `tmux`
    # invocation Claude Code runs. Only applies to zsh + oh-my-zsh + tmux plugin.
    [ -f ~/.zshrc ] || return 0
    [ -d ~/.oh-my-zsh ] || return 0
    grep -qE '^[[:space:]]*plugins=\(.*\btmux\b.*\)' ~/.zshrc || return 0

    if grep -q 'functions\[tmux_run\]' ~/.zshrc; then
        echo "zsh tmux alias fix already present in ~/.zshrc"
        return 0
    fi

    echo "Patching ~/.zshrc: oh-my-zsh tmux plugin's alias breaks in non-interactive tool shells"
    cat >> ~/.zshrc << 'EOF'

# Claude Code's shell snapshots (used to replay your env into tool-call
# shells) drop underscore-prefixed functions. Copy the oh-my-zsh tmux
# plugin's wrapper to a non-underscore name so `tmux` keeps working there.
if (( $+functions[_zsh_tmux_plugin_run] )); then
  functions[tmux_run]="${functions[_zsh_tmux_plugin_run]}"
  alias tmux=tmux_run
fi
EOF
    echo "Patched ~/.zshrc"
}

verify_zsh_tmux_alias() {
    # Confirms the patched alias resolves to a non-underscore function in a
    # real interactive zsh, i.e. it will survive the shell-snapshot filter.
    grep -q 'functions\[tmux_run\]' ~/.zshrc 2>/dev/null || return 0
    command -v zsh &>/dev/null || return 0

    if zsh -ic 'type tmux_run' &>/dev/null; then
        echo "Verified: tmux alias now resolves to tmux_run (no leading underscore)."
    else
        echo "Warning: could not verify tmux_run in an interactive zsh — check ~/.zshrc manually." >&2
    fi
}

create_tmux_config() {
    if [ -f ~/.tmux.conf ]; then
        return 0
    fi

    cat > ~/.tmux.conf << 'EOF'
# Renumber windows starting from 1 (instead of 0)
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# Split panes using Alt + h/v, keep current dir
bind -n M-v split-window -h -c "#{pane_current_path}"
bind -n M-h split-window -v -c "#{pane_current_path}"

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Split panes with prefix, keep current dir
bind h split-window -v -c "#{pane_current_path}"
bind v split-window -h -c "#{pane_current_path}"

# Don't rename windows automatically
set-option -g allow-rename off

# Enable mouse control (clickable windows, panes, resizable panes)
set -g mouse on

# tmux plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'dracula/tmux'

# Continuum options
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'

# Dracula theme options
set -g @dracula-show-powerline true
set -g @dracula-show-flags true
set -g @dracula-show-left-icon session
set -g @dracula-plugins "cpu-usage ram-usage time"

# Run TPM
run '~/.tmux/plugins/tpm/tpm'
EOF
    echo "Created ~/.tmux.conf with plugin configuration"
}

main() {
    if already_installed; then
        echo "tmux is already installed: $(tmux -V)"
    else
        install_tmux
        echo "tmux installed successfully: $(tmux -V)"
    fi

    create_tmux_config
    install_tmux_plugins
    fix_zsh_tmux_alias
    verify_zsh_tmux_alias
}

main "$@"
