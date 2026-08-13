#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$ROOT_DIR/shared"
CLAUDE_DIR="$HOME/.claude"
ZSHRC="$HOME/.zshrc"

link() {
  local src="$1" dest="$2"
  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      return
    fi
    rm "$dest"
    ln -s "$src" "$dest"
    echo "  [updated] $(basename "$dest")  (was: $current)"
    return
  fi
  if [ -e "$dest" ]; then
    echo "  [skip]    $(basename "$dest")  — not a symlink, remove manually to sync"
    return
  fi
  ln -s "$src" "$dest"
  echo "  [added]   $(basename "$dest")"
}

cleanup_stale() {
  local dir="$1" prefix="$2"
  [ -d "$dir" ] || return
  for entry in "$dir"/*; do
    [ -L "$entry" ] || continue
    local target
    target="$(readlink "$entry")"
    [[ "$target" == "$prefix"* ]] || continue
    if [ ! -e "$entry" ]; then
      rm "$entry"
      echo "  [removed] $(basename "$entry")  — target no longer exists"
    fi
  done
}

echo "==> agents"
mkdir -p "$CLAUDE_DIR/agents"
for f in "$REPO_DIR/agents/"*.md; do
  [ -f "$f" ] && link "$f" "$CLAUDE_DIR/agents/$(basename "$f")"
done
for subdir in "$REPO_DIR/agents"/*/; do
  [ -d "$subdir" ] || continue
  for f in "${subdir%/}"/*.md; do
    [ -f "$f" ] || continue
    base="$(basename "$f")"
    [ "$base" = "README.md" ] && continue
    link "$f" "$CLAUDE_DIR/agents/$base"
  done
done
cleanup_stale "$CLAUDE_DIR/agents" "$REPO_DIR/agents"

echo "==> rules"
mkdir -p "$CLAUDE_DIR/rules"
for f in "$REPO_DIR/rules/"*.md; do
  [ -f "$f" ] && link "$f" "$CLAUDE_DIR/rules/$(basename "$f")"
done
for subdir in "$REPO_DIR/rules"/*/; do
  [ -d "$subdir" ] || continue
  for f in "${subdir%/}"/*.md; do
    [ -f "$f" ] && link "$f" "$CLAUDE_DIR/rules/$(basename "$f")"
  done
done
cleanup_stale "$CLAUDE_DIR/rules" "$REPO_DIR/rules"

echo "==> skills"
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands"
for skill_dir in "$REPO_DIR/skills"/*/; do
  [ -d "$skill_dir" ] || continue
  name="$(basename "$skill_dir")"
  skill_file="${skill_dir%/}/SKILL.md"
  [ -f "$skill_file" ] || { echo "  [skip]    $name  — no SKILL.md found"; continue; }
  link "$skill_dir" "$CLAUDE_DIR/skills/$name"
  link "$skill_file" "$CLAUDE_DIR/commands/$name.md"
done
cleanup_stale "$CLAUDE_DIR/skills" "$REPO_DIR/skills"
cleanup_stale "$CLAUDE_DIR/commands" "$REPO_DIR/skills"

echo "==> aliases"
add_alias() {
  local name="$1"
  local cmd="$2"
  local line="alias $name=\"$cmd\""
  if [ ! -f "$ZSHRC" ]; then
    echo "  [skip]    $name  — $ZSHRC not found"
    return
  fi
  if grep -qF "$line" "$ZSHRC"; then
    return
  fi
  if grep -q "^alias $name=" "$ZSHRC"; then
    sed -i "s|^alias $name=.*|$line|" "$ZSHRC"
    echo "  [updated] $name"
    return
  fi
  printf '%s\n' "$line" >> "$ZSHRC"
  echo "  [added]   $name"
}
add_alias "sync-main" "$ROOT_DIR/bin/checkout-main.sh"

echo "done."
