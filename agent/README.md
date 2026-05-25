# Agent Sandbox Operations

## Overview

This project uses a unified `agent` role running inside Docker Sandboxes (`sbx`) with:
- Local inference: llama.cpp `llama-server` on port 1234
- Model: Qwen3.6-35B-A3B
- Tools: bash, edit, read, grep, glob, lsp, webfetch, websearch, AWS MCP (GA)
- AWS MCP tools: call_aws, search_documentation, read_documentation, run_script, Skills
- Discord frontend: TODO — separate integration planned

## Quick Start

```bash
# Start a sandboxed agent session
./agent/scripts/sbx-agent.sh "your task prompt"

# Verify OpenCode is inside sbx
./agent/scripts/verify-sandbox.sh

# Check llama-server connectivity
./agent/scripts/check-llama-server.sh
```

## Directory Structure

```
agent/
├── opencode/           # OpenCode configuration
├── prompts/            # Agent system prompts
├── scripts/            # Launcher and utility scripts
├── mcp/                # MCP server documentation
├── discord/            # Discord integration (TODO, separate from sandboxing)
└── research/           # Research output cache
```

## Safety

- OpenCode runs inside `sbx` microVM sandboxes, not on the host
- No host `~/.ssh`, `~/.aws`, or shell history accessible from sandbox
- Git changes require branch/worktree review before merge
- AWS mutations require explicit launch-time approval
- Network policy starts permissive, can be tightened from `sbx policy log`
