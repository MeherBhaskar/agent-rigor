#!/usr/bin/env bash
# Agent Rigor Installation Script
# https://github.com/MeherBhaskar/agent-rigor
set -e

VERSION="v1.0.0"

# --- Colors & Styling ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
CHECK="[${GREEN}✓${NC}]"
INFO="[${BLUE}i${NC}]"
WARN="[${YELLOW}!${NC}]"
ERROR="[${RED}✗${NC}]"

# --- Help Menu ---
show_help() {
  echo -e "${BLUE}Agent Rigor Installer ${VERSION}${NC}"
  echo "Installs the Agent Rigor framework into your current project."
  echo ""
  echo "Usage: ./install.sh [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message and exit"
  echo "  -v, --version Show version and exit"
  echo ""
  echo "Example:"
  echo "  curl -sSL https://raw.githubusercontent.com/MeherBhaskar/agent-rigor/main/install.sh | bash"
}

# --- Parse Args ---
for arg in "$@"; do
  case $arg in
    -h|--help)
      show_help
      exit 0
      ;;
    -v|--version)
      echo "$VERSION"
      exit 0
      ;;
  esac
done

echo -e "${BLUE}Bootstrapping Agent Rigor (${VERSION})...${NC}"

# --- Idempotency Check ---
if [ -d ".agents" ]; then
    echo -e "${WARN} .agents/ directory already exists. Updating existing files..."
fi

# --- Create Target Directories ---
echo -e "${INFO} Creating project structure..."
mkdir -p .agents/skills
mkdir -p .agents/templates
mkdir -p .docs/{architecture,decisions,context,learned_rules}
echo -e "${CHECK} Project structure created"

# --- Clone & Copy ---
echo -e "${INFO} Fetching framework files from repository..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

git clone --quiet --depth 1 https://github.com/MeherBhaskar/agent-rigor.git "$TMP_DIR"

echo -e "${INFO} Installing files..."
cp "$TMP_DIR/core/SYSTEM_CORE.md" .agents/
cp -r "$TMP_DIR"/skills/* .agents/skills/
cp -r "$TMP_DIR"/templates/* .agents/templates/
cp "$TMP_DIR/core/CHEATSHEET.md" .agents/ 2>/dev/null || true
cp "$TMP_DIR/core/CONTEXT_MANAGEMENT.md" .agents/ 2>/dev/null || true
echo -e "${CHECK} Core files installed"

# --- Initialize Progress Log ---
if [ ! -f "progress_log.md" ]; then
    cp .agents/templates/PROGRESS_LOG_TEMPLATE.md progress_log.md
    echo -e "${CHECK} Initialized progress_log.md"
else
    echo -e "${INFO} progress_log.md already exists, skipping."
fi

echo -e "\n${GREEN}Installation Complete!${NC}"
echo -e "\nNext steps:"
echo -e "1. Point your agent/IDE to ${YELLOW}.agents/SYSTEM_CORE.md${NC}"
echo -e "2. Tell your agent: ${BLUE}\"Read .agents/SYSTEM_CORE.md and begin Phase 1.\"${NC}"
