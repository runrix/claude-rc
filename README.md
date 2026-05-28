# claude-rc

**Pay little money, do big things.**

Route Claude Code inference to any Anthropic-compatible provider while keeping Remote Control — control your session from `claude.ai/code` or Claude App.

[中文文档](./README_ZH.md)

---

## Features

- Third-party model inference with Remote Control preserved
- CC Switch compatible — auto-detects and transparently passes through
- Zero dependencies — single binary
- Cross-platform — macOS (Apple Silicon & Intel), Linux, Windows

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

```bash
claude-rc launch --name "my-project"
claude-rc launch --name "my-project" --dir ~/code/myapp
claude-rc launch --name "my-project" --proxy http://127.0.0.1:10808
LAUNCH_MODEL=deepseek-r1 claude-rc launch --name "test"
claude-rc status
claude-rc test
```

After launch, open `claude.ai/code` or Claude App to remote control your session.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Banner shows wrong model | Check provider settings in `.claude/settings.local.json` |
| `Remote Control failed` | OAuth expired — run `claude login` |
| Inference returns 401 | Provider API key expired — update settings |
| CC Switch not working | Ensure CC Switch is active before launch |
| Launch fails after crash | Restart terminal and try again |

---

## License

Personal tool. Use as needed.
