#!/usr/bin/env bash
set -euo pipefail

# Convenience wrapper for research tasks
# Usage: agent-research-task.sh "research query"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/sbx-agent.sh" "$@"
