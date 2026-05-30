# claude-rc

**Pay little money, do big things.**
*(With a Claude Pro/Max/Team subscription, use any third-party model for inference — claude-rc itself is free.)*

Route Claude Code inference to any Anthropic-compatible provider while keeping Remote Control — control your session from `claude.ai/code` or Claude App. Output auto-adapts to your system language (en / zh).

[中文文档](./README_ZH.md)

---

## Features

- Third-party model inference + Remote Control preserved
- `-x` shortcut: auto-passes `--permission-mode bypassPermissions` to claude
- `reconnect`: pick a past bridge session and resume it
- CC Switch compatible — auto-detected and transparently passed through
- Zero dependencies — single binary
- Cross-platform — macOS (Apple Silicon & Intel), Linux, Windows
- Auto i18n — adapts to system language

---

## Install

**macOS / Linux:**

```bash
curl -fsSL https://github.com/runrix/claude-rc/releases/latest/download/install.sh | bash
```

**Windows:**

Download `claude-rc-windows-amd64.exe` from [Releases](https://github.com/runrix/claude-rc/releases/latest) and add to PATH.

---

## Prerequisites

- Claude Code CLI installed and logged in (`claude login`, requires Pro/Max/Team)
- Access to `api.anthropic.com` (directly or via proxy)

---

## Configure Provider

Create `.claude/settings.local.json` in your project directory (or any parent):

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-api-key",
    "ANTHROPIC_BASE_URL": "https://your-provider.example.com/api/anthropic",
    "ANTHROPIC_MODEL": "model-name"
  }
}
```

Or use [CC Switch](https://github.com/farion1231/cc-switch) to manage providers — `claude-rc` auto-detects its config.

---

## Usage

### Quick start (most common)

```bash
claude-rc -x                     # start bridge + bypass all permissions
claude-rc -x --name "my-project" # with a custom name
```

### Reconnect to a past session

```bash
claude-rc reconnect              # pick from a list of past bridge sessions
claude-rc reconnect -x           # same, with bypass permissions
```

### Passing flags to claude

Any arguments after `--` are forwarded directly to the `claude` command:

```bash
claude-rc -x -- --model claude-sonnet-4-6        # override model
claude-rc -x -- --permission-mode acceptEdits     # explicit permission mode
claude-rc -x -- --tmux --worktree                 # isolated tmux session
claude-rc -x --name foo -- --continue             # resume last session in this dir
```

### Other commands

```bash
claude-rc status     # Show OAuth / proxy / active sessions
claude-rc test       # Test OAuth token & Bridge API connection
claude-rc --help     # Full help
```

After launch, open `claude.ai/code` or Claude App to remote control your session.

---

## All Flags

| Flag | Description |
|------|-------------|
| `-x, --bypass` | Shortcut: pass `--permission-mode bypassPermissions` to claude |
| `--name` | Remote Control session name (default: auto-generated) |
| `--dir` | Working directory (default: cwd) |
| `--proxy` | Outbound proxy URL |
| `--token` | OAuth token override (skip Keychain) |
| `--` | Everything after `--` is forwarded to `claude` verbatim |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `Remote Control failed` | OAuth expired — run `claude login` |
| Banner shows wrong model | Check `ANTHROPIC_BASE_URL` in settings |
| Inference returns 401 | Provider API key expired — update settings |
| CC Switch not working | Ensure CC Switch is active before launch |
| Launch fails after crash | Restart terminal and try again |

Proxy request logs are written to `/tmp/claude-rc/proxy-18080.log` (not mixed into the Claude CLI session).

---

## License

Personal tool. Use as needed.
