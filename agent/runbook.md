# Daily Operations Runbook

## Start a Sandbox Agent Task (Terminal)

```bash
# General task
./agent/scripts/sbx-agent.sh "your task description"

# Coding task
./agent/scripts/agent-coding-task.sh "implement feature X"

# Research task
./agent/scripts/agent-research-task.sh "research topic Y"

# AWS task
./agent/scripts/agent-aws-task.sh "describe EC2 instances"
```

## Approve an AWS Mutation

1. Launch task with explicit mutation intent:
   ```bash
   ./agent/scripts/agent-aws-task.sh "Create S3 bucket 'my-bucket' in us-east-1"
   ```
2. Review the account (309229301022), region, and intended action
3. Approve when prompted by OpenCode permissions
4. Mutation is logged in `.agent-logs/`

## Monitor Sandboxes

```bash
# List all sandboxes
sbx ls

# Check network policy
sbx policy ls

# Review network activity
sbx policy log

# Check active sandbox
./agent/scripts/verify-sandbox.sh
```

## Review Branch/Worktree Output

```bash
# From host, review changes made by agent
git diff
git status

# Review worktree branches
git branch -a
```

## Stop or Remove a Sandbox

```bash
# Stop a sandbox
sbx stop <sandbox-name>

# Remove a sandbox
sbx rm <sandbox-name>

# Stop and remove all stale sandboxes
sbx ls | awk 'NR>1 {print $1}' | xargs -I{} sbx stop {} 2>/dev/null
sbx ls | awk 'NR>1 {print $1}' | xargs -I{} sbx rm {} 2>/dev/null
```

## Rotate Credentials

```bash
# AWS credentials
# 1. Generate new access key for local-agent-dev user
# 2. Update ~/.local/share/agent-secrets/aws-credentials
# 3. Old key is automatically rotated on next sandbox launch

# Model provider keys (if using remote)
# 1. Generate new key from provider
# 2. Update via sbx secret or environment variable
```

## Update Components

```bash
# Update sbx
brew upgrade docker/tap/sbx

# Update OpenCode
brew upgrade opencode

# Update llama.cpp
# Rebuild from source or update binary

# Update uv
brew upgrade uv
```

## Recover After a Bad Agent Run

1. Stop the sandbox: `sbx stop <name>`
2. Review changes: `git diff`
3. Revert if needed: `git checkout -- .` or `git reset --hard`
4. Remove sandbox: `sbx rm <name>`
5. Inspect `.git/hooks/`, CI configs, Makefiles, package scripts, lockfiles
6. Rebuild from clean branch if needed

## What Never to Do

- Never run OpenCode directly on the host for real workspaces
- Never mount `~/.ssh`, `~/.aws`, or shell history into a sandbox
- Never store API keys, tokens, or credentials in the repository
- Never use `--tools all` with llama-server
- Never allow production AWS mutation without explicit approval
