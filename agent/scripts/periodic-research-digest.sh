#!/usr/bin/env bash
set -euo pipefail

# Daily research digest periodic task
# Scheduled via launchd, runs inside sbx sandbox

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/sbx-agent.sh" "Create a brief research digest of recent developments in AI coding tools, local LLM inference, and sandbox security. Write output to agent/research/digest-$(date +%Y%m%d).md with sources and dates."
