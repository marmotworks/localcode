# AWS MCP Configuration

## Overview

AWS MCP Server is a managed remote MCP service that gives AI agents secure, authenticated access to all AWS services. It is part of the Agent Toolkit for AWS.

**Status**: Generally Available (GA since May 2026)

The agent connects via `mcp-proxy-for-aws`, an open-source local proxy that bridges MCP's OAuth protocol to AWS IAM SigV4 authentication.

## Available Tools

| Tool | Description | Auth Required |
|------|-------------|---------------|
| `call_aws` | Execute any of 15,000+ AWS API operations | Yes |
| `search_documentation` | Search current AWS documentation | No |
| `read_documentation` | Read specific AWS documentation pages | No |
| `run_script` | Run sandboxed Python scripts for multi-step AWS operations | Yes |
| Skills | Curated guidance from AWS service teams for common tasks | No |

## Endpoints

AWS MCP Server is available in two regions. The endpoint region determines the MCP server you connect to, while `AWS_REGION` metadata sets the default region for AWS operations:

| Region | Endpoint |
|--------|----------|
| US East (N. Virginia) | `https://aws-mcp.us-east-1.api.aws/mcp` |
| Europe (Frankfurt) | `https://aws-mcp.eu-central-1.api.aws/mcp` |

## Pricing

No additional charge for the AWS MCP Server. You pay only for AWS resources your agents use and applicable data transfer costs.

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
4. MCP proxy runs with credentials as environment variables, signing requests with SigV4
5. Credentials are never committed to git

## Region Configuration

The wrapper script injects `--metadata AWS_REGION=<region>` from the credentials file. Without this, all AWS operations default to `us-east-1`. You can also override the region in your agent queries (e.g., "list my EC2 instances in eu-west-1").

## IAM Permissions

The AWS MCP Server supports IAM context keys for fine-grained access control:
- `aws:ViaAWSMCPService`
- `aws:CalledViaAWSMCP`

Key IAM actions:
- `aws-mcp:CallReadOnlyTool` - Read-only tool access
- `aws-mcp:CallReadWriteTool` - Read-write tool access
- `aws-mcp:InvokeMcp` - General MCP invocation

### Observability

- **CloudWatch**: Metrics published under `AWS-MCP` namespace for monitoring agent activity
- **CloudTrail**: All API calls logged for complete audit trail

## IAM Tuning

After observing usage, tune down from AdministratorAccess:
1. Review CloudTrail for actions called through the agent
2. Group actions by service and purpose
3. Remove unused broad permissions
4. Add explicit denies for destructive operations
5. Use tags: `AgentManaged=true`, `Environment=dev`, `Owner=mhall`

## Network Requirements

AWS MCP needs access to:
- `aws-mcp.us-east-1.api.aws` (MCP endpoint)
- AWS auth/SSO/OIDC/STS domains
- AWS service APIs (region-specific)
- `pypi.org` / `files.pythonhosted.org` (for uvx packages)
- `localhost:1234` (local llama-server)

## Troubleshooting

| Error | Cause | Solution |
|-------|-------|----------|
| `401 Unauthorized` | Invalid or expired AWS credentials | Rotate access keys or run `aws sso login` |
| `403 Forbidden` / `AccessDenied` | IAM user lacks required permissions | Add `aws-mcp:CallReadOnlyTool` or service-specific actions |
| Proxy fails to start | `uvx` not installed or not on PATH | Install uv: `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Connection timeout | Proxy cannot reach MCP endpoint | Verify outbound HTTPS to `aws-mcp.*.api.aws` |
| Slow first connection | `uvx` downloads dependencies on first run | Wait up to 30 seconds for initial connection |
| Wrong region data | Proxy configured for different region | Update region in credentials file or specify in query |

## References

- [AWS MCP Server User Guide](https://docs.aws.amazon.com/agent-toolkit/latest/userguide/mcp-server.html)
- [MCP Proxy for AWS (GitHub)](https://github.com/aws/mcp-proxy-for-aws)
- [Agent Toolkit for AWS](https://aws.amazon.com/products/developer-tools/agent-toolkit-for-aws/)
- [GA Announcement](https://aws.amazon.com/blogs/aws/the-aws-mcp-server-is-now-generally-available/)
