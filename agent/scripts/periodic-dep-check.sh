#!/usr/bin/env bash
set -euo pipefail

# Weekly dependency update check
# Runs in branch/worktree mode inside sbx sandbox

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/sbx-agent.sh" "Check for outdated dependencies in this project. Create a branch with any safe updates. Do not push. Write a summary of findings to agent/research/dep-check-$(date +%Y%m%d).md"
