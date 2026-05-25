#!/usr/bin/env bash
set -euo pipefail

# Convenience wrapper for coding tasks
# Usage: agent-coding-task.sh "coding task prompt"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/sbx-agent.sh" "$@"
