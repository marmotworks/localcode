#!/usr/bin/env bash
set -euo pipefail

# AWS MCP proxy wrapper
# Reads credentials from the workspace and launches the MCP proxy
# This runs inside the sbx sandbox

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREDENTIALS_FILE="$SCRIPT_DIR/.aws-credentials.local"

# Check for credentials file in workspace
if [ -f "$CREDENTIALS_FILE" ]; then
  export AWS_ACCESS_KEY_ID="$(awk -F'= ' '/aws_access_key_id/ {print $2}' "$CREDENTIALS_FILE")"
  export AWS_SECRET_ACCESS_KEY="$(awk -F'= ' '/aws_secret_access_key/ {print $2}' "$CREDENTIALS_FILE")"
  export AWS_DEFAULT_REGION="$(awk -F'= ' '/^region/ {print $2}' "$CREDENTIALS_FILE")"
fi

# Execute the MCP proxy
exec uvx mcp-proxy-for-aws@latest "${@:----url https://aws-mcp.us-east-1.api.aws/mcp}"
