#!/usr/bin/env bash
set -eo pipefail

REPO="runrix/claude-rc"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="claude-rc"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}[install]${NC} claude-rc 一键安装"

# 检测平台
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "$OS" in
    darwin) OS="darwin" ;;
    linux)  OS="linux" ;;
    mingw*|msys*|cygwin*) OS="windows" ;;
    *) echo -e "${RED}[install] 不支持的系统: $OS${NC}"; exit 1 ;;
esac
case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *) echo -e "${RED}[install] 不支持的架构: $ARCH${NC}"; exit 1 ;;
esac

FILENAME="claude-rc-${OS}-${ARCH}"
[[ "$OS" == "windows" ]] && FILENAME="${FILENAME}.exe" && BINARY_NAME="${BINARY_NAME}.exe"

# 获取最新版本
VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | head -1 | sed -E 's/.*"v([^"]+)".*/\1/')
if [[ -z "$VERSION" ]]; then
    echo -e "${RED}[install] 无法获取最新版本${NC}"
    exit 1
fi

echo -e "${CYAN}[install]${NC} 下载 v${VERSION} (${OS}-${ARCH})..."
mkdir -p "$INSTALL_DIR"
curl -fsSL "https://github.com/${REPO}/releases/download/v${VERSION}/${FILENAME}" -o "${INSTALL_DIR}/${BINARY_NAME}"
chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

# 确保 INSTALL_DIR 在 PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    SHELL_RC="$HOME/.zshrc"
    [[ "$(basename "${SHELL:-zsh}")" == "bash" && -f "$HOME/.bashrc" ]] && SHELL_RC="$HOME/.bashrc"
    echo "" >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo -e "${CYAN}[install]${NC} 已添加 ${INSTALL_DIR} 到 PATH（新终端窗口生效）"
fi

echo ""
echo -e "${GREEN}[install]${NC} 安装完成! claude-rc v${VERSION}"
echo ""
echo "用法:"
echo "  claude-rc launch --name \"my-project\""
echo "  claude-rc status"
echo "  claude-rc test"
