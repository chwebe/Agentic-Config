#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="."
VENV_DIR=".venv"
PYTHON_VERSION=""
ANSIBLE_VERSION=""

usage() {
  echo "Usage: $(basename "$0") [-t TARGET_PATH] [-p PYTHON_VERSION] [-a ANSIBLE_VERSION] [-d VENV_DIR]" >&2
  echo "  -t  Ansible project directory to set up the venv in. Defaults to ." >&2
  echo "  -p  Python version for the uv venv (e.g. 3.12). Defaults to uv's default." >&2
  echo "  -a  Ansible version to install (e.g. 9.5.1). Defaults to latest." >&2
  echo "  -d  Venv directory name, relative to TARGET_PATH. Defaults to .venv" >&2
  echo "" >&2
  echo "  e.g.: $(basename "$0") -t ~/projects/my-playbooks -p 3.12 -a 9.5.1" >&2
  exit 1
}

while getopts ":t:p:a:d:h" opt; do
  case "$opt" in
    t) TARGET_PATH="$OPTARG" ;;
    p) PYTHON_VERSION="$OPTARG" ;;
    a) ANSIBLE_VERSION="$OPTARG" ;;
    d) VENV_DIR="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
  esac
done

if ! command -v uv &>/dev/null; then
  echo "error: uv is not installed. See https://docs.astral.sh/uv/getting-started/installation/" >&2
  exit 1
fi

if [ ! -d "$TARGET_PATH" ]; then
  echo "error: target path '$TARGET_PATH' does not exist" >&2
  exit 1
fi

venv_path="$TARGET_PATH/$VENV_DIR"

venv_args=("$venv_path")
[ -n "$PYTHON_VERSION" ] && venv_args=(--python "$PYTHON_VERSION" "$venv_path")

echo "==> Creating uv venv in '$venv_path'${PYTHON_VERSION:+ (python $PYTHON_VERSION)}"
uv venv "${venv_args[@]}"

package="ansible"
[ -n "$ANSIBLE_VERSION" ] && package="ansible==$ANSIBLE_VERSION"

echo "==> Installing $package"
uv pip install --python "$venv_path/bin/python" "$package"

echo ""
echo "done. Activate with: source $venv_path/bin/activate"
"$venv_path/bin/ansible" --version 2>/dev/null | head -1 || true
