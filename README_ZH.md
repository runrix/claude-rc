# claude-rc

**花小钱，办大事。**

让 Claude Code 用任意 Anthropic 兼容的第三方模型推理，同时保留 Remote Control —— 可从 `claude.ai/code` 或 Claude App 远程控制本地会话。

[English](./README.md)

---

## 特性

- 第三方模型推理 + Remote Control 保留
- 兼容 CC Switch —— 自动检测并透传
- 零依赖 —— 单文件二进制
- 跨平台 —— macOS (Apple Silicon & Intel)、Linux、Windows

---

## 安装

**macOS / Linux 一行安装：**

```bash
curl -fsSL https://github.com/runrix/claude-rc/releases/latest/download/install.sh | bash
```

**Windows：**

从 [Releases](https://github.com/runrix/claude-rc/releases/latest) 下载 `claude-rc-windows-amd64.exe`，放到 PATH 目录。

---

## 前置条件

- Claude Code CLI 已安装并登录（`claude login`，需 Pro/Max/Team 订阅）
- 能访问 `api.anthropic.com`（直连或代理）

---

## 配置第三方模型

在项目目录（或任意父目录）创建 `.claude/settings.local.json`：

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "你的API密钥",
    "ANTHROPIC_BASE_URL": "https://your-provider.example.com/api/anthropic",
    "ANTHROPIC_MODEL": "模型名"
  }
}
```

或使用 [CC Switch](https://github.com/farion1231/cc-switch) 管理 provider —— `claude-rc` 自动检测其配置。

---

## 用法

```bash
claude-rc launch --name "我的项目"
claude-rc launch --name "我的项目" --dir ~/code/myapp
claude-rc launch --name "我的项目" --proxy http://127.0.0.1:10808
LAUNCH_MODEL=deepseek-r1 claude-rc launch --name "test"
claude-rc status
claude-rc test
```

启动后打开 `claude.ai/code` 或 Claude App 的 Code tab，可远程接管会话。

---

## 故障排查

| 现象 | 解决 |
|------|------|
| banner 显示错误模型 | 检查 settings 里的 `ANTHROPIC_BASE_URL` |
| `Remote Control failed` | OAuth 过期 — `claude login` |
| 推理报 401 | Provider key 过期 — 更新 settings |
| CC Switch 不生效 | 确保 CC Switch 已激活后再启动 |
| 崩溃后启动失败 | 重启终端重试 |

---

## 许可

个人工具，按需取用。
