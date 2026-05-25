# System Verification Checklist

## Base Sandbox
- [x] `sbx version` works (v0.28.3 client + server)
- [x] `sbx policy ls` shows permissive allow-all (active for bootstrap)
- [x] Sandbox can be created and removed
- [ ] `sbx` dashboard opens or `sbx ls` shows running sandboxes

## Filesystem Isolation
- [ ] Sandbox can read/write only the project workspace
- [ ] Sandbox cannot read host `~/.ssh`
- [ ] Sandbox cannot read host `~/.aws`
- [ ] Sandbox cannot read host shell history
- [ ] Sandbox cannot access parent home files outside mounted workspace

## Network Isolation
- [x] Sandbox can reach llama-server via `host.docker.internal:1234`
- [x] Permissive egress (`**`) is enabled for functional bootstrap
- [ ] `sbx policy log` reviewed after verification

## llama-server
- [x] Host endpoint `http://127.0.0.1:1234/v1/models` works
- [x] Sandbox endpoint `http://host.docker.internal:1234/v1/models` works
- [x] Qwen3.6-35B-A3B is loaded and available
- [x] `--jinja` is active
- [x] `--tools all` is NOT enabled

## OpenCode Unified Agent
- [ ] OpenCode runs inside `sbx`
- [ ] OpenCode sees the local llama-server model
- [ ] Basic code edit task works on a branch/worktree
- [ ] Git diff review works from host
- [ ] Git push and git commit ask for approval
- [ ] Destructive shell patterns ask for approval
- [ ] `.env` inspection asks for approval
- [ ] No OpenCode permission is set to `deny`

## Research/Web
- [ ] Agent can use webfetch
- [ ] Agent can use websearch
- [ ] Fetched content is cited and treated as untrusted

## AWS MCP
- [ ] AWS MCP is enabled for the unified agent
- [ ] AWS identity is `local-agent-dev` (account 309229301022)
- [ ] Account and region printed before mutation
- [ ] AWS MCP documentation search works
- [ ] `aws___call_aws` tool is visible and usable
- [ ] No AWS MCP tool is disabled by OpenCode permissions

## Discord Integration
- [ ] TODO — Discord integration is planned separately from sandboxing

## Maintenance
- [x] Update commands documented in `agent/maintenance.md`
- [x] Token rotation documented
- [x] Incident response documented

## Risks Accepted
- Wildcard network egress (`**`) is enabled for bootstrap phase
- AWS `local-agent-dev` user has AdministratorAccess (tune down after observation)
- Account budget: ~$96 spent this month, $122 forecasted (within $100 alert)

## Fixes Required Before Use
- Run full end-to-end test: launch sandbox, run coding task, verify diff
- Verify AWS MCP tools are visible inside sandboxed OpenCode

## Next Command
```bash
./agent/scripts/sbx-agent.sh "Create a hello-world.md file in the project root"
```
