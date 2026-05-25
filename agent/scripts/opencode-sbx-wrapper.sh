#!/usr/bin/env bash
set -euo pipefail

# OpenCode wrapper for sandboxed execution
# Creates sbx worktree, runs OpenCode on host with isolated filesystem

SYSTEM_OPENCODE="/opt/homebrew/bin/opencode"
AGENT_DIR="/Users/mhall/Workspaces/localcode/agent"

# Parse arguments
PORT=""
DIR=""
ARGS=("$@")
i=0
while [ $i -lt $# ]; do
  arg="${!i}"
  case "$arg" in
    --port)
      i=$((i + 1))
      PORT="${!i}"
      ;;
    --port=*)
      PORT="${arg#--port=}"
      ;;
    --dir)
      i=$((i + 1))
      DIR="${!i}"
      ;;
    --dir=*)
      DIR="${arg#--dir=}"
      ;;
  esac
  i=$((i + 1))
done

# Non-server mode: run directly
if [ -z "$PORT" ]; then
  exec "$SYSTEM_OPENCODE" "${ARGS[@]}"
fi

# Ensure directory exists
if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
  echo "ERROR: invalid directory: ${DIR:-<not set>}" >&2
  exit 1
fi

# Create sandbox name from directory
DIR_HASH=$(echo "$DIR" | tr '/' '-' | tr -cd '[:alnum:]-')
SANDBOX_NAME="agent-${DIR_HASH}"

# Create or reuse sandbox (creates git worktree for filesystem isolation)
if ! sbx ls --json 2>/dev/null | grep -q "\"name\":\"$SANDBOX_NAME\""; then
  sbx create --name "$SANDBOX_NAME" --branch auto opencode "$DIR" 2>&1
fi

# Find the worktree directory
WORKTREE_DIR="$DIR/.sbx/$SANDBOX_NAME-worktrees/sandbox-$SANDBOX_NAME"
if [ ! -d "$WORKTREE_DIR" ]; then
  echo "ERROR: worktree not found at $WORKTREE_DIR" >&2
  exit 1
fi

# Generate host-side OpenCode config (localhost instead of host.docker.internal)
cat > "$WORKTREE_DIR/opencode.jsonc" <<'CONFIGEOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "llama.cpp": {
      "options": {
        "baseURL": "http://localhost:1234/v1"
      }
    }
  },
  "model": "llama.cpp/Qwen3.6-35B-A3B",
  "small_model": "llama.cpp/Qwen3.6-35B-A3B",
  "permission": {
    "*": "allow",
    "read": {
      "*": "allow"
    },
    "grep": "allow",
    "glob": "allow",
    "skill": "allow",
    "todowrite": "allow",
    "question": "allow",
    "edit": "allow",
    "lsp": "allow",
    "webfetch": "allow",
    "websearch": "allow",
    "aws-mcp_*": "allow",
    "aws___*": "allow",
    "aws_*": "allow",
    "bash": {
      "*": "allow"
    },
    "external_directory": "allow",
    "doom_loop": "allow"
  }
}
CONFIGEOF

# Build arguments: replace --dir with worktree path
FINAL_ARGS=()
for arg in "${ARGS[@]}"; do
  case "$arg" in
    --dir|--port)
      # Skip these flags (we handle them)
      ;;
    *)
      FINAL_ARGS+=("$arg")
      ;;
  esac
done

# Run OpenCode on host with worktree directory and port
exec "$SYSTEM_OPENCODE" --port "$PORT" "${FINAL_ARGS[@]}" "$WORKTREE_DIR"
