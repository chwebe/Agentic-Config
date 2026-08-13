#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: not inside a git repository" >&2
  exit 1
fi

default_branch=""

if remote_head="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)"; then
  default_branch="${remote_head#origin/}"
fi

if [ -z "$default_branch" ]; then
  for candidate in main master; do
    if git show-ref --verify --quiet "refs/heads/$candidate" || git show-ref --verify --quiet "refs/remotes/origin/$candidate"; then
      default_branch="$candidate"
      break
    fi
  done
fi

if [ -z "$default_branch" ]; then
  echo "Error: could not determine main/master branch" >&2
  exit 1
fi

echo "==> Checking out '$default_branch'"
git checkout "$default_branch"

echo "==> Pulling latest changes"
git pull
