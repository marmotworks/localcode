#!/usr/bin/env bash
set -euo pipefail

# Verify OpenCode is running inside an sbx sandbox
# Usage: verify-sandbox.sh [sandbox-name]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Checking for active sandboxes..."
sbx ls

# Check if any sandbox is running
ACTIVE_SANDBOXES=$(sbx ls 2>/dev/null | grep -v "^SANDBOX" | grep -v "^$" || true)

if [ -z "$ACTIVE_SANDBOXES" ]; then
  echo "No active sandboxes found."
  echo "Start one with: $SCRIPT_DIR/sbx-agent.sh 'your task'"
  exit 0
fi

echo ""
echo "Active sandboxes:"
echo "$ACTIVE_SANDBOXES"

# Verify workspace mount
echo ""
echo "Project directory: $PROJECT_DIR"
echo "Verify this matches the WORKSPACE column in sbx ls output."
