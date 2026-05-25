#!/usr/bin/env bash
set -euo pipefail

# Convenience wrapper for AWS tasks
# Usage: agent-aws-task.sh "AWS task prompt"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/sbx-agent.sh" "$@"
