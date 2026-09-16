#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") <topic-folder> <destination-dir>" >&2
  echo "  e.g.: $(basename "$0") ansible ~/.claude" >&2
  exit 1
}

[ $# -eq 2 ] || usage

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/topics"
TOPIC="$1"
SRC_DIR="$ROOT_DIR/$TOPIC"
DEST_DIR="$2"

if [ ! -d "$SRC_DIR" ]; then
  echo "error: '$TOPIC' does not exist at $ROOT_DIR" >&2
  exit 1
fi

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

echo "==> $TOPIC/rules -> $DEST_DIR/rules"
if [ -d "$SRC_DIR/rules" ]; then
  mkdir -p "$DEST_DIR/rules"
  for f in "$SRC_DIR/rules/"*.md; do
    [ -f "$f" ] && link "$f" "$DEST_DIR/rules/$(basename "$f")"
  done
  for subdir in "$SRC_DIR/rules"/*/; do
    [ -d "$subdir" ] || continue
    for f in "${subdir%/}"/*.md; do
      [ -f "$f" ] && link "$f" "$DEST_DIR/rules/$(basename "$f")"
    done
  done
  cleanup_stale "$DEST_DIR/rules" "$SRC_DIR/rules"
else
  echo "  [skip]    no rules/ folder in $TOPIC"
fi

echo "==> $TOPIC/skills -> $DEST_DIR/skills"
if [ -d "$SRC_DIR/skills" ]; then
  mkdir -p "$DEST_DIR/skills" "$DEST_DIR/commands"
  for skill_dir in "$SRC_DIR/skills"/*/; do
    [ -d "$skill_dir" ] || continue
    name="$(basename "$skill_dir")"
    skill_file="${skill_dir%/}/SKILL.md"
    [ -f "$skill_file" ] || { echo "  [skip]    $name  — no SKILL.md found"; continue; }
    link "$skill_dir" "$DEST_DIR/skills/$name"
    link "$skill_file" "$DEST_DIR/commands/$name.md"
  done
  cleanup_stale "$DEST_DIR/skills" "$SRC_DIR/skills"
  cleanup_stale "$DEST_DIR/commands" "$SRC_DIR/skills"
else
  echo "  [skip]    no skills/ folder in $TOPIC"
fi

echo "done."
