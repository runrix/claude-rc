#!/usr/bin/env bash
set -eo pipefail

REPO="runrix/claude-rc"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="claude-rc"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}[install]${NC} Installing claude-rc..."

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
    echo -e "${RED}[install] Failed to fetch latest version${NC}"
    exit 1
fi

echo -e "${CYAN}[install]${NC} Downloading v${VERSION} (${OS}-${ARCH})..."
mkdir -p "$INSTALL_DIR"
curl -fsSL "https://github.com/${REPO}/releases/download/v${VERSION}/${FILENAME}" -o "${INSTALL_DIR}/${BINARY_NAME}"
chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

# Ensure INSTALL_DIR is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    SHELL_RC="$HOME/.zshrc"
    [[ "$(basename "${SHELL:-zsh}")" == "bash" && -f "$HOME/.bashrc" ]] && SHELL_RC="$HOME/.bashrc"
    echo "" >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo -e "${CYAN}[install]${NC} Added ${INSTALL_DIR} to PATH (restart your terminal to apply)"
fi

echo ""
echo -e "${GREEN}[install]${NC} Done! claude-rc v${VERSION} installed"
echo ""
echo "Usage:"
echo "  claude-rc launch --name \"my-project\""
echo "  claude-rc status"
echo "  claude-rc test"
