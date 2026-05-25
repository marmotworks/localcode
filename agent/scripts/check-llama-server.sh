#!/usr/bin/env bash
set -euo pipefail

# Check llama-server connectivity
# Usage: check-llama-server.sh

echo "Checking host llama-server on port 1234..."
if curl -fsS http://127.0.0.1:1234/v1/models &>/dev/null; then
  echo "OK: llama-server is running on host"
  echo ""
  echo "Available models:"
  curl -fsS http://127.0.0.1:1234/v1/models | jq -r '.data[].id' 2>/dev/null || echo "(parse failed)"
else
  echo "ERROR: llama-server not reachable on port 1234"
  exit 1
fi

echo ""
echo "Checking sandbox connectivity to host.docker.internal:1234..."
echo "(This will create a temporary sandbox, test connectivity, then remove it)"

TEMP_SANDBOX="connectivity-check-$(date +%s)"

if sbx create --name "$TEMP_SANDBOX" shell . &>/dev/null; then
  if sbx exec "$TEMP_SANDBOX" curl -s http://host.docker.internal:1234/v1/models &>/dev/null; then
    echo "OK: Sandbox can reach llama-server via host.docker.internal:1234"
  else
    echo "ERROR: Sandbox cannot reach host.docker.internal:1234"
    echo "Try: sbx policy allow network localhost:1234"
  fi
  sbx stop "$TEMP_SANDBOX" &>/dev/null
  sbx rm "$TEMP_SANDBOX" &>/dev/null
else
  echo "WARNING: Could not create test sandbox (may need sbx login)"
fi
