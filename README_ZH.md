# claude-rc

**花小钱，办大事。**
*（只需 Claude Pro/Max/Team 订阅，推理走第三方模型 —— claude-rc 本身免费。）*

让 Claude Code 用任意 Anthropic 兼容的第三方模型推理，同时保留 Remote Control —— 可从 `claude.ai/code` 或 Claude App 远程控制本地会话。输出自动适配系统语言。

[English](./README.md)

---

## 特性

- 第三方模型推理 + Remote Control 保留
- `-x` 快捷：自动传递 `--permission-mode bypassPermissions` 给 claude
- `reconnect`：选择历史 bridge session 重连
- 兼容 CC Switch —— 自动检测并透传
- 零依赖 —— 单文件二进制
- 跨平台 —— macOS (Apple Silicon & Intel)、Linux、Windows
- 自动国际化 —— 根据系统语言显示中文或英文

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

### 快速启动（最常用）

```bash
claude-rc -x                     # 启动 bridge + 跳过所有权限检查
claude-rc -x --name "我的项目"    # 自定义名称
```

### 重连历史 session

```bash
claude-rc reconnect              # 从列表中选择历史 bridge session 重连
claude-rc reconnect -x           # 同上，跳过权限检查
```

### 透传参数给 claude

`--` 后面的所有参数原样传递给 `claude` 命令：

```bash
claude-rc -x -- --model claude-sonnet-4-6        # 指定模型
claude-rc -x -- --permission-mode acceptEdits     # 指定权限模式（不用 -x 的替代）
claude-rc -x -- --tmux --worktree                 # tmux 隔离工作树
claude-rc -x --name foo -- --continue             # 恢复当前目录上次 session
```

### 其他命令

```bash
claude-rc status     # 查看 OAuth / 代理 / 活跃 session
claude-rc test       # 测试 OAuth token 与 Bridge API 连通性
claude-rc --help     # 完整帮助
```

启动后打开 `claude.ai/code` 或 Claude App，可远程接管会话。

---

## 全部参数

| 参数 | 说明 |
|------|------|
| `-x, --bypass` | 快捷：传递 `--permission-mode bypassPermissions` 给 claude（可选） |
| `--name` | Remote Control session 名称（默认自动生成） |
| `--dir` | 工作目录（默认当前目录） |
| `--proxy` | 手动指定出口代理 |
| `--token` | 手动指定 OAuth token（跳过 Keychain） |
| `--` | `--` 后面的所有参数原样透传给 `claude` |

---

## 故障排查

| 现象 | 解决 |
|------|------|
| `Remote Control failed` | OAuth 过期 — `claude login` |
| Banner 显示错误模型 | 检查 settings 里的 `ANTHROPIC_BASE_URL` |
| 推理报 401 | Provider key 过期 — 更新 settings |
| CC Switch 不生效 | 确保 CC Switch 已激活后再启动 |
| 崩溃后启动失败 | 重启终端重试 |

代理请求日志写入 `/tmp/claude-rc/proxy-18080.log`（不会混入 Claude CLI 会话界面）。

---

## 许可

个人工具，按需取用。
