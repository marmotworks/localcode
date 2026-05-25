#!/usr/bin/env bash
set -euo pipefail

# Generic sbx adapter for sandboxed OpenCode
# Ensures OpenCode work launched by external frontends runs inside sbx

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Fail closed if required commands are missing
for cmd in sbx; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: required command '$cmd' not found" >&2
    exit 1
  fi
done

# Generate unique sandbox name
SANDBOX_NAME="agent-$(date +%Y%m%d-%H%M%S)"

echo "Sandbox: $SANDBOX_NAME"
echo "Project: $PROJECT_DIR"

# Enable built-in hosted websearch
export OPENCODE_ENABLE_EXA=1

# Read prompt from stdin or argument
if [ $# -gt 0 ]; then
  TASK_PROMPT="$1"
else
  TASK_PROMPT="$(cat)"
  if [ -z "$TASK_PROMPT" ]; then
    echo "ERROR: no prompt provided" >&2
    exit 1
  fi
fi

# Copy agent config if needed
AGENT_CONFIG="$SCRIPT_DIR/../opencode/opencode.example.jsonc"
PROJECT_CONFIG="$PROJECT_DIR/opencode.jsonc"
if [ ! -f "$PROJECT_CONFIG" ] && [ -f "$AGENT_CONFIG" ]; then
  cp "$AGENT_CONFIG" "$PROJECT_CONFIG"
fi

# Create sandbox with branch mode
sbx create --name "$SANDBOX_NAME" --branch auto opencode "$PROJECT_DIR"

# Run OpenCode inside the sandbox
sbx run "$SANDBOX_NAME" -- --prompt "$TASK_PROMPT"
