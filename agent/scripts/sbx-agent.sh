#!/usr/bin/env bash
set -euo pipefail

# Unified agent launcher for Docker Sandboxes
# Usage: sbx-agent.sh "task prompt" [additional args...]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SANDBOX_NAME="agent-$(date +%Y%m%d-%H%M%S)"
AGENT_CONFIG="$SCRIPT_DIR/../opencode/opencode.example.jsonc"
PROJECT_CONFIG="$PROJECT_DIR/opencode.jsonc"

# Fail closed if required commands are missing
for cmd in sbx; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: required command '$cmd' not found" >&2
    exit 1
  fi
done

# Print sandbox name and project path
echo "Sandbox: $SANDBOX_NAME"
echo "Project: $PROJECT_DIR"

# Copy agent OpenCode config to project root if not present
if [ ! -f "$PROJECT_CONFIG" ] && [ -f "$AGENT_CONFIG" ]; then
  cp "$AGENT_CONFIG" "$PROJECT_CONFIG"
  echo "Created: $PROJECT_CONFIG (from agent template)"
fi

# Copy AWS credentials to workspace if broker has them
CREDENTIALS_FILE="$HOME/.local/share/agent-secrets/aws-credentials"
WORKSPACE_CREDS="$PROJECT_DIR/agent/.aws-credentials.local"
if [ -f "$CREDENTIALS_FILE" ]; then
  # Generate workspace credentials from secure store
  cat > "$WORKSPACE_CREDS" <<CREDEOF
# Auto-generated AWS credentials for sandbox agent
# DO NOT commit to git
[default]
aws_access_key_id = "$(awk -F'= ' '/aws_access_key_id/ {print $2}' "$CREDENTIALS_FILE")"
aws_secret_access_key = "$(awk -F'= ' '/aws_secret_access_key/ {print $2}' "$CREDENTIALS_FILE")"
region = "$(awk -F'= ' '/^region/ {print $2}' "$CREDENTIALS_FILE")"
CREDEOF
  chmod 600 "$WORKSPACE_CREDS"
fi

# Enable built-in hosted websearch if OpenCode requires it
export OPENCODE_ENABLE_EXA=1

# Check if prompt is provided
if [ $# -eq 0 ]; then
  echo "ERROR: no task prompt provided" >&2
  echo "Usage: $0 'task prompt'" >&2
  exit 1
fi

TASK_PROMPT="$*"

# Create sandbox (creates worktree and sandbox)
sbx create --name "$SANDBOX_NAME" --branch auto opencode "$PROJECT_DIR"

# Copy agent config to the worktree so OpenCode picks it up
WORKTREE_DIR="$PROJECT_DIR/.sbx/$SANDBOX_NAME-worktrees/sandbox-$SANDBOX_NAME"
if [ -d "$WORKTREE_DIR" ] && [ -f "$AGENT_CONFIG" ]; then
  cp "$AGENT_CONFIG" "$WORKTREE_DIR/opencode.jsonc"
  echo "Synced opencode.jsonc to worktree"
fi

# Run OpenCode non-interactively with the task prompt
sbx run "$SANDBOX_NAME" -- run --dangerously-skip-permissions "$TASK_PROMPT"
