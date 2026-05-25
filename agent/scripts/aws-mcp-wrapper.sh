#!/usr/bin/env bash
set -euo pipefail

# AWS MCP proxy wrapper (GA release)
# Reads credentials from the workspace and launches the MCP proxy
# Connects to the managed AWS MCP Server via mcp-proxy-for-aws

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREDENTIALS_FILE="$SCRIPT_DIR/.aws-credentials.local"

# Default MCP endpoint (us-east-1)
# Alternative: https://aws-mcp.eu-central-1.api.aws/mcp
MCP_ENDPOINT="https://aws-mcp.us-east-1.api.aws/mcp"

# Read AWS credentials from workspace (synced by sbx-agent.sh)
if [ -f "$CREDENTIALS_FILE" ]; then
  export AWS_ACCESS_KEY_ID="$(awk -F'= ' '/aws_access_key_id/ {print $2}' "$CREDENTIALS_FILE")"
  export AWS_SECRET_ACCESS_KEY="$(awk -F'= ' '/aws_secret_access_key/ {print $2}' "$CREDENTIALS_FILE")"
  export AWS_DEFAULT_REGION="$(awk -F'= ' '/^region/ {print $2}' "$CREDENTIALS_FILE")"
fi

# Build command: endpoint is positional (no --url flag in GA release)
CMD=(uvx mcp-proxy-for-aws@latest "$MCP_ENDPOINT")

# Set default region for AWS operations via --metadata
# Without this, all operations default to us-east-1
if [ -n "${AWS_DEFAULT_REGION:-}" ]; then
  CMD+=(--metadata "AWS_REGION=${AWS_DEFAULT_REGION}")
fi

# Execute the MCP proxy, passing through any additional args
exec "${CMD[@]}" "$@"
