#!/usr/bin/env bash
# =============================================================================
# Claude Code - Automated Setup Script
# =============================================================================
# This script installs Claude Code and configures common MCP servers.
# Run with: bash setup-claude-code.sh
# =============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

info()    { echo -e "${CYAN}[INFO]${RESET}  $1"; }
success() { echo -e "${GREEN}[OK]${RESET}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $1"; }
error()   { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }
header()  { echo -e "\n${BOLD}$1${RESET}"; echo "$(printf '─%.0s' {1..60})"; }

# =============================================================================
# 1. CHECK PREREQUISITES
# =============================================================================
header "🔍 Checking Prerequisites"

# Check Node.js
if ! command -v node &>/dev/null; then
  error "Node.js is not installed. Please install Node.js 18+ from https://nodejs.org and re-run this script."
fi

NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
  error "Node.js 18+ is required. You have $(node -v). Please upgrade from https://nodejs.org"
fi
success "Node.js $(node -v) detected"

# Check npm
if ! command -v npm &>/dev/null; then
  error "npm is not installed. It should come with Node.js."
fi
success "npm $(npm -v) detected"

# =============================================================================
# 2. INSTALL CLAUDE CODE
# =============================================================================
header "📦 Installing Claude Code"

if command -v claude &>/dev/null; then
  CURRENT_VERSION=$(claude --version 2>/dev/null || echo "unknown")
  info "Claude Code already installed (version: $CURRENT_VERSION). Updating..."
fi

npm install -g @anthropic-ai/claude-code
success "Claude Code installed successfully"
info "Version: $(claude --version 2>/dev/null || echo 'run `claude --version` to check')"

# =============================================================================
# 3. VERIFY INSTALLATION
# =============================================================================
header "✅ Verifying Installation"

if ! command -v claude &>/dev/null; then
  error "Claude Code installation failed. 'claude' command not found in PATH."
fi
success "Claude Code is available at: $(which claude)"

# =============================================================================
# 4. MCP SERVER SETUP
# =============================================================================
header "🔌 MCP Server Configuration"

echo ""
echo "This script can set up the following MCP integrations:"
echo "  [1] GitHub       - Search repos, manage PRs, create issues"
echo "  [2] Atlassian    - Jira tickets, Confluence pages"
echo "  [3] Slack        - Send messages, search channels"
echo "  [4] Filesystem   - Read/write files on your machine"
echo "  [5] Skip MCPs    - Set them up manually later"
echo ""
read -rp "Which MCPs would you like to configure? (e.g. 1 2 3, or 5 to skip): " MCP_CHOICES

# ── GitHub MCP ────────────────────────────────────────────────────────────────
if echo "$MCP_CHOICES" | grep -q "1"; then
  header "🐙 Configuring GitHub MCP"
  echo ""
  echo "You need a GitHub Personal Access Token (PAT)."
  echo "Create one at: https://github.com/settings/tokens"
  echo "Required scopes: repo, read:org, read:user"
  echo ""
  read -rp "Paste your GitHub PAT (input hidden): " -s GITHUB_TOKEN
  echo ""

  if [ -n "$GITHUB_TOKEN" ]; then
    claude mcp add github \
      -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" \
      -- npx -y @modelcontextprotocol/server-github
    success "GitHub MCP configured"
  else
    warn "No token provided. Skipping GitHub MCP."
  fi
fi

# ── Atlassian MCP ─────────────────────────────────────────────────────────────
if echo "$MCP_CHOICES" | grep -q "2"; then
  header "📋 Configuring Atlassian MCP (Jira + Confluence)"
  echo ""
  echo "You need:"
  echo "  - Your Atlassian Cloud URL  (e.g. https://yourcompany.atlassian.net)"
  echo "  - Your Atlassian email address"
  echo "  - An Atlassian API Token — create one at: https://id.atlassian.com/manage-profile/security/api-tokens"
  echo ""
  read -rp "Atlassian Cloud URL: " ATLASSIAN_URL
  read -rp "Atlassian email:     " ATLASSIAN_EMAIL
  read -rp "Atlassian API token (input hidden): " -s ATLASSIAN_TOKEN
  echo ""

  if [ -n "$ATLASSIAN_TOKEN" ] && [ -n "$ATLASSIAN_URL" ] && [ -n "$ATLASSIAN_EMAIL" ]; then
    claude mcp add atlassian \
      -e ATLASSIAN_URL="$ATLASSIAN_URL" \
      -e ATLASSIAN_EMAIL="$ATLASSIAN_EMAIL" \
      -e ATLASSIAN_API_TOKEN="$ATLASSIAN_TOKEN" \
      -- npx -y mcp-atlassian
    success "Atlassian MCP configured"
  else
    warn "Missing Atlassian credentials. Skipping."
  fi
fi

# ── Slack MCP ─────────────────────────────────────────────────────────────────
if echo "$MCP_CHOICES" | grep -q "3"; then
  header "💬 Configuring Slack MCP"
  echo ""
  echo "You need a Slack Bot Token (starts with xoxb-)."
  echo "Create a Slack app at: https://api.slack.com/apps"
  echo "Required OAuth scopes: channels:read, channels:history, chat:write, users:read"
  echo ""
  read -rp "Slack Bot Token (input hidden): " -s SLACK_TOKEN
  echo ""

  if [ -n "$SLACK_TOKEN" ]; then
    claude mcp add slack \
      -e SLACK_BOT_TOKEN="$SLACK_TOKEN" \
      -- npx -y @modelcontextprotocol/server-slack
    success "Slack MCP configured"
  else
    warn "No token provided. Skipping Slack MCP."
  fi
fi

# ── Filesystem MCP ────────────────────────────────────────────────────────────
if echo "$MCP_CHOICES" | grep -q "4"; then
  header "📁 Configuring Filesystem MCP"
  echo ""
  echo "This allows Claude Code to read/write files in specified directories."
  echo ""
  read -rp "Which directory should Claude have access to? [default: $HOME]: " FS_PATH
  FS_PATH="${FS_PATH:-$HOME}"

  claude mcp add filesystem \
    -- npx -y @modelcontextprotocol/server-filesystem "$FS_PATH"
  success "Filesystem MCP configured for: $FS_PATH"
fi

# =============================================================================
# 5. CONFIRM CONFIGURED MCPs
# =============================================================================
header "📋 Configured MCP Servers"
claude mcp list 2>/dev/null || info "Run 'claude mcp list' to view configured servers."

# =============================================================================
# 6. DONE
# =============================================================================
header "🎉 Setup Complete!"

echo ""
echo -e "  ${GREEN}Claude Code is ready to use.${RESET}"
echo ""
echo "  Quick start commands:"
echo -e "    ${CYAN}claude${RESET}               — Start an interactive session"
echo -e "    ${CYAN}claude \"<task>\"${RESET}       — Run a one-shot task"
echo -e "    ${CYAN}claude mcp list${RESET}      — View connected MCP servers"
echo -e "    ${CYAN}claude mcp add${RESET}       — Add another MCP server"
echo ""
echo "  Docs: https://docs.anthropic.com/en/docs/claude-code/overview"
echo ""