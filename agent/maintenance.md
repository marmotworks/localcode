# Maintenance

## Periodic Tasks

Three periodic tasks are available as launchd plists in `agent/scripts/`:

| Task | Schedule | Plist | Script |
|------|----------|-------|--------|
| Research digest | Daily 8:00 AM | `launchd-research-digest.plist` | `periodic-research-digest.sh` |
| Dependency check | Monday 9:00 AM | `launchd-dep-check.plist` | `periodic-dep-check.sh` |
| AWS inspection | Monday 10:00 AM | `launchd-aws-inspect.plist` | `periodic-aws-inspect.sh` |

### Enable a periodic task:
```bash
cp agent/scripts/launchd-<task>.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.localcode.agent.<task>.plist
```

### Disable all periodic tasks:
```bash
for task in periodic depcheck awsinspect; do
  launchctl bootout gui/$(id -u)/com.localcode.agent.$task 2>/dev/null || true
done
```

### Quick disable all:
```bash
launchctl bootout gui/$(id -u)/com.localcode.agent.periodic 2>/dev/null || true
launchctl bootout gui/$(id -u)/com.localcode.agent.depcheck 2>/dev/null || true
launchctl bootout gui/$(id -u)/com.localcode.agent.awsinspect 2>/dev/null || true
```

## Weekly

- `sbx version` - check for updates
- `sbx policy ls` - review network policy
- `sbx policy log` - review allowed/blocked destinations
- Confirm wildcard egress `**` is still intentional
- Update sbx, OpenCode, llama.cpp intentionally after checking release notes
- Prune stale sandboxes: `sbx ls`, `sbx stop`, `sbx rm`
- Review `.sbx/` worktrees and remove old branches
- Refresh AWS SSO sessions
- Review AWS CloudTrail for MCP-originated actions

## Monthly

- Rotate remote model API keys if used
- Review AWS IAM permissions and tune down from CloudTrail
- Remove wildcard egress if no longer needed
- Review websearch provider keys and external exposure
- Rerun verification prompt

## Incident Response

1. Stop active sandbox: `sbx stop <name>`
2. Preserve logs if needed
3. Remove sandbox if containment is critical: `sbx rm <name>`
4. Revoke exposed tokens
5. Rotate model keys, AWS credentials
6. Inspect `git diff`, hooks, CI configs, Makefiles, package scripts, lockfiles
7. Rebuild from clean branch/worktree
8. Tighten policies before rerun
