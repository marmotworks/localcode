# Discord Integration

## Status: TODO

Discord integration is planned as a separate concern, distinct from sandboxing and persistent run capabilities.

## Design Principles

- Discord frontend is implemented separately from `sbx` sandboxing
- No coupling between Discord bot lifecycle and sandbox lifecycle
- Persistent run capabilities are independent of any chat frontend
- Integration will route through `agent/scripts/sbx-adapter.sh` for sandboxed execution

## Requirements (TBD)

- Personal private server
- Owner-only access by default
- No arbitrary host shell execution
- No tokens stored in repository

## Implementation Notes

When implementing, ensure:
- The frontend launches OpenCode through `agent/scripts/sbx-adapter.sh`
- Prompts are passed safely as files or argv, not shell-interpolated strings
- Logs are sanitized of secrets, tokens, and credentials
