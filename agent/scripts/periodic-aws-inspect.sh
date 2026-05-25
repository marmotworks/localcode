#!/usr/bin/env bash
set -euo pipefail

# Weekly AWS resource inspection (read-only)
# Runs inside sbx sandbox with AWS MCP

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/sbx-agent.sh" "Inspect AWS resources in the current account. List active EC2 instances, S3 buckets, Lambda functions, and estimated monthly cost. Write a read-only report to agent/research/aws-inspect-$(date +%Y%m%d).md. Do not perform any mutations."
