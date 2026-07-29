#!/usr/bin/env bash
set -euo pipefail

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
    command -v gh &>/dev/null
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

install_gh_debian_ubuntu() {
    run_as_root apt-get update -qq
    run_as_root apt-get install -y wget

    run_as_root mkdir -p -m 755 /etc/apt/keyrings

    local keyring=/etc/apt/keyrings/githubcli-archive-keyring.gpg
    local tmpfile
    tmpfile=$(mktemp)
    wget -nv -O "$tmpfile" https://cli.github.com/packages/githubcli-archive-keyring.gpg
    run_as_root bash -c "cat '$tmpfile' > '$keyring'"
    rm -f "$tmpfile"
    run_as_root chmod go+r "$keyring"

    local arch
    arch=$(dpkg --print-architecture)
    run_as_root bash -c \
        "echo 'deb [arch=${arch} signed-by=${keyring}] https://cli.github.com/packages stable main' \
        > /etc/apt/sources.list.d/github-cli.list"

    run_as_root apt-get update -qq
    run_as_root apt-get install -y gh
}

install_gh_fedora() {
    run_as_root dnf install -y gh
}

install_gh_rhel() {
    if command -v dnf &>/dev/null; then
        run_as_root dnf install -y 'dnf-command(config-manager)'
        run_as_root dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
        run_as_root dnf install -y gh
    else
        run_as_root yum install -y yum-utils
        run_as_root yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
        run_as_root yum install -y gh
    fi
}

install_gh_opensuse() {
    run_as_root zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo
    run_as_root zypper --gpg-auto-import-keys refresh
    run_as_root zypper install -y gh
}

install_gh() {
    local distro
    distro=$(detect_distro)

    echo "Detected distribution: ${distro}"

    case "${distro}" in
        arch | manjaro | endeavouros | garuda)
            run_as_root pacman -Sy --noconfirm github-cli
            ;;
        debian | ubuntu | linuxmint | pop | kali | raspbian | elementary)
            install_gh_debian_ubuntu
            ;;
        fedora)
            install_gh_fedora
            ;;
        rhel | centos | rocky | almalinux | ol)
            install_gh_rhel
            ;;
        opensuse* | sles)
            install_gh_opensuse
            ;;
        alpine)
            run_as_root apk add --no-cache github-cli
            ;;
        nixos)
            echo "NixOS detected — install gh via nix-env or add it to your configuration.nix."
            echo "  nix-env -iA nixpkgs.gh"
            exit 0
            ;;
        void)
            run_as_root xbps-install -Sy gh
            ;;
        gentoo)
            run_as_root emerge --ask=n dev-vcs/github-cli
            ;;
        *)
            echo "Unknown distribution '${distro}'. Trying common package managers..."
            if command -v apt-get &>/dev/null; then
                install_gh_debian_ubuntu
            elif command -v dnf &>/dev/null; then
                install_gh_fedora
            elif command -v pacman &>/dev/null; then
                run_as_root pacman -Sy --noconfirm github-cli
            elif command -v zypper &>/dev/null; then
                install_gh_opensuse
            elif command -v apk &>/dev/null; then
                run_as_root apk add --no-cache github-cli
            else
                echo "No supported package manager found. Install gh manually from https://cli.github.com" >&2
                exit 1
            fi
            ;;
    esac
}

main() {
    if already_installed; then
        echo "gh is already installed: $(gh --version | head -1)"
    else
        install_gh
        echo "gh installed successfully: $(gh --version | head -1)"
    fi
}

main "$@"
