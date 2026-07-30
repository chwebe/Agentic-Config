#!/usr/bin/env bash
set -euo pipefail

WORKFLOW="${1:?Usage: prompt-orchestrator.sh <workflow-name>}"
REPO="$HOME/.config/Agentic-Config"
TARGET="$REPO/shared/agents/$WORKFLOW"

mkdir -p "$TARGET/step"
echo "Scaffolded: shared/agents/$WORKFLOW/"
echo "Scaffolded: shared/agents/$WORKFLOW/step/"
