#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/shared"
CLAUDE_DIR="$HOME/.claude"

link() {
  local src="$1" dest="$2"
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    echo "  [skip] $dest exists and is not a symlink — remove it manually"
    return
  fi
  ln -s "$src" "$dest"
  echo "  linked $(basename "$dest")"
}

echo "==> agents"
mkdir -p "$CLAUDE_DIR/agents"
for f in "$REPO_DIR/agents/"*.md; do
  [ -f "$f" ] && link "$f" "$CLAUDE_DIR/agents/$(basename "$f")"
done

echo "==> rules"
mkdir -p "$CLAUDE_DIR/rules"
for f in "$REPO_DIR/rules/"*.md; do
  [ -f "$f" ] && link "$f" "$CLAUDE_DIR/rules/$(basename "$f")"
done

echo "==> skills"
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands"
for skill_dir in "$REPO_DIR/skills/"/*/; do
  [ -d "$skill_dir" ] || continue
  name="$(basename "$skill_dir")"
  skill_file="$skill_dir/SKILL.md"
  [ -f "$skill_file" ] || { echo "  [skip] $name — no SKILL.md found"; continue; }
  link "$skill_dir" "$CLAUDE_DIR/skills/$name"
  link "$skill_file" "$CLAUDE_DIR/commands/$name.md"
done

echo "done."
