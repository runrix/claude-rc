#!/usr/bin/env bash
set -eo pipefail

REPO="runrix/claude-rc"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="claude-rc"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Detect language
_is_zh() {
    local lang="${LANG:-${LC_ALL:-${LC_MESSAGES:-}}}"
    [[ "${lang,,}" == *zh* ]]
}

_msg() {
    local en="$1" zh="$2"
    if _is_zh; then echo -e "${zh}"; else echo -e "${en}"; fi
}

echo -e "${CYAN}[install]${NC} $(_msg "Installing claude-rc..." "正在安装 claude-rc...")"

# Detect platform
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "$OS" in
    darwin) OS="darwin" ;;
    linux)  OS="linux" ;;
    mingw*|msys*|cygwin*) OS="windows" ;;
    *) echo -e "${RED}[install] Unsupported OS: $OS${NC}"; exit 1 ;;
esac
case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *) echo -e "${RED}[install] Unsupported architecture: $ARCH${NC}"; exit 1 ;;
esac

FILENAME="claude-rc-${OS}-${ARCH}"
[[ "$OS" == "windows" ]] && FILENAME="${FILENAME}.exe" && BINARY_NAME="${BINARY_NAME}.exe"

# Get latest version
VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | head -1 | sed -E 's/.*"v([^"]+)".*/\1/')
if [[ -z "$VERSION" ]]; then
    echo -e "${RED}[install] $(_msg "Failed to fetch latest version" "获取最新版本失败")${NC}"
    exit 1
fi

echo -e "${CYAN}[install]${NC} $(_msg "Downloading v${VERSION} (${OS}-${ARCH})..." "下载 v${VERSION} (${OS}-${ARCH})...")"
mkdir -p "$INSTALL_DIR"
curl -fsSL "https://github.com/${REPO}/releases/download/v${VERSION}/${FILENAME}" -o "${INSTALL_DIR}/${BINARY_NAME}"
chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

# Ensure INSTALL_DIR is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    SHELL_RC="$HOME/.zshrc"
    [[ "$(basename "${SHELL:-zsh}")" == "bash" && -f "$HOME/.bashrc" ]] && SHELL_RC="$HOME/.bashrc"
    echo "" >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo -e "${CYAN}[install]${NC} $(_msg "Added ${INSTALL_DIR} to PATH (restart terminal to apply)" "已将 ${INSTALL_DIR} 加入 PATH (重启终端生效)")"
fi

echo ""
echo -e "${GREEN}[install]${NC} $(_msg "Done! claude-rc v${VERSION} installed" "安装完成! claude-rc v${VERSION}")"
echo ""
echo "$(_msg "Usage:" "用法:")"
echo "  claude-rc -x --name \"my-project\""
echo "  claude-rc reconnect"
echo "  claude-rc status"
echo "  claude-rc test"
