# claude-rc

**Pay little money, do big things.**
*(With a Claude Pro/Max/Team subscription, use any third-party model for inference — claude-rc is free.)*

Route Claude Code inference to any Anthropic-compatible provider while keeping Remote Control. Auto-adapts to your system language.

[中文文档](./README_ZH.md)

---

## Install

```bash
curl -fsSL https://github.com/runrix/claude-rc/releases/latest/download/install.sh | bash
```

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and logged in (`claude login`, requires Pro/Max/Team)
- Network access to `api.anthropic.com`

## Configure Provider

Create `.claude/settings.local.json` in your project (or any parent directory):

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-api-key",
    "ANTHROPIC_BASE_URL": "https://your-provider.example.com/api/anthropic",
    "ANTHROPIC_MODEL": "model-name"
  }
}
```

Or use [CC Switch](https://github.com/farion1231/cc-switch) — `claude-rc` auto-detects it.

## Quick Start

```bash
claude-rc                           # start with auto-generated name
claude-rc --name "my-project"       # custom name
claude-rc -x                        # skip permission prompts (optional)
claude-rc -x --name "my-project"    # both
```

After launch, open `claude.ai/code` to remote control your session.

## Reconnect

Resume a past bridge session (e.g. after terminal crash):

```bash
claude-rc reconnect                 # pick from history
claude-rc reconnect -x              # skip permissions
```

## Pass Flags to Claude

Arguments after `--` are forwarded directly to the `claude` command:

```bash
claude-rc -- --model claude-sonnet-4-6           # override model
claude-rc -x -- --permission-mode acceptEdits     # explicit permission mode
claude-rc -- --tmux --worktree                    # tmux session
```

## Other Commands

```bash
claude-rc status                    # OAuth / proxy / active sessions
claude-rc test                      # test Bridge API connectivity
```

## All Flags

| Flag | Description |
|------|-------------|
| `-x, --bypass` | Pass `--permission-mode bypassPermissions` to claude *(optional)* |
| `--name` | Session name (auto-generated if omitted) |
| `--dir` | Working directory (default: cwd) |
| `--proxy` | Outbound proxy URL |
| `--token` | OAuth token override (skip Keychain) |
| `--` | Forward remaining args to `claude` verbatim |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `Remote Control failed` | `claude login` |
| Banner shows wrong model | Check `ANTHROPIC_BASE_URL` in settings |
| Inference returns 401 | Update provider key |

Proxy logs: `/tmp/claude-rc/proxy-18080.log`
