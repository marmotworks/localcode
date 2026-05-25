# OpenCode Configuration

Project-level OpenCode configuration for use inside Docker Sandboxes.

## Usage

Copy the example config before first use:
```bash
cp agent/opencode/opencode.example.jsonc agent/opencode/opencode.jsonc
```

## Key Settings

- **Provider**: llama.cpp-local (http://host.docker.internal:1234/v1)
- **Model**: Qwen3.6-35B-A3B
- **MCP**: AWS MCP enabled via uvx mcp-proxy-for-aws
- **Permissions**: Unified agent role with allow/ask posture

## Switching Models

To use a remote provider, add a new provider block and update the `model` field:
```jsonc
"provider": {
  "openai-remote": {
    "npm": "@ai-sdk/openai-compatible",
    "options": {
      "baseURL": "https://api.openai.com/v1",
      "apiKey": process.env.OPENAI_API_KEY
    }
  }
}
```
