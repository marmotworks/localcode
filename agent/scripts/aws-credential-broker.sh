#!/usr/bin/env bash
set -euo pipefail

# AWS credential broker
# Reads credentials from secure storage and exports them as environment variables
# Usage: source agent/scripts/aws-credential-broker.sh

CREDENTIALS_FILE="$HOME/.local/share/agent-secrets/aws-credentials"

if [ ! -f "$CREDENTIALS_FILE" ]; then
  echo "WARNING: AWS credentials file not found at $CREDENTIALS_FILE" >&2
  echo "AWS MCP tools will not be available." >&2
  return 0 2>/dev/null || exit 0
fi

# Parse credentials without printing them
export AWS_ACCESS_KEY_ID="$(awk -F'= ' '/aws_access_key_id/ {print $2}' "$CREDENTIALS_FILE")"
export AWS_SECRET_ACCESS_KEY="$(awk -F'= ' '/aws_secret_access_key/ {print $2}' "$CREDENTIALS_FILE")"
export AWS_DEFAULT_REGION="$(awk -F'= ' '/^region/ {print $2}' "$CREDENTIALS_FILE")"

# Verify credentials are set (without printing values)
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "ERROR: Failed to parse AWS credentials" >&2
  return 1 2>/dev/null || exit 1
fi
