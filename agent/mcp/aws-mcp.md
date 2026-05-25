# AWS MCP Configuration

## Overview

AWS MCP is enabled for the unified `agent` role. Tools are accessible inside the sandbox via `uvx mcp-proxy-for-aws`.

## Credentials

- User: `local-agent-dev` (AdministratorAccess)
- Account: 309229301022 (personal/non-production)
- Budget: $100/month alert to mike@beef.tips
- Host credentials: `~/.local/share/agent-secrets/aws-credentials`
- Sandbox credentials: `agent/.aws-credentials.local` (auto-synced by launcher, gitignored)

## Credential Flow

1. Host stores credentials in `~/.local/share/agent-secrets/aws-credentials`
2. Launcher (`sbx-agent.sh`) syncs to `agent/.aws-credentials.local` in workspace
3. AWS MCP wrapper (`aws-mcp-wrapper.sh`) reads workspace credentials
4. MCP proxy runs with credentials as environment variables
5. Credentials are never committed to git

## IAM Tuning

After observing usage, tune down from AdministratorAccess:
1. Review CloudTrail for actions called through the agent
2. Group actions by service and purpose
3. Remove unused broad permissions
4. Add explicit denies for destructive operations
5. Use tags: `AgentManaged=true`, `Environment=dev`, `Owner=mhall`

## Context Keys

Use IAM context keys for future policy tuning:
- `aws:ViaAWSMCPService`
- `aws:CalledViaAWSMCP`

## Network Requirements

AWS MCP needs access to:
- `aws-mcp.us-east-1.api.aws` (MCP endpoint)
- AWS auth/SSO/OIDC/STS domains
- AWS service APIs (region-specific)
- `pypi.org` / `files.pythonhosted.org` (for uvx packages)
- `localhost:1234` (local llama-server)
