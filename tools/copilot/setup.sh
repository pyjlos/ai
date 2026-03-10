#!/usr/bin/env bash
# =============================================================================
# GitHub Copilot - Automated Setup Script
# =============================================================================
# Installs GitHub Copilot for VS Code and/or the GitHub CLI extension.
# Run with: bash setup-github-copilot.sh
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

header "🤖 GitHub Copilot Setup"
echo ""
echo "This script sets up GitHub Copilot for your preferred tools."
echo ""
echo "What would you like to set up?"
echo "  [1] VS Code extensions (Copilot + Copilot Chat)"
echo "  [2] JetBrains plugin (manual — IDE required)"
echo "  [3] GitHub Copilot CLI"
echo "  [4] All of the above"
echo ""
read -rp "Your choice (e.g. 1 3 or 4): " INSTALL_CHOICES

# =============================================================================
# VS CODE
# =============================================================================
if echo "$INSTALL_CHOICES" | grep -qE "1|4"; then
  header "🖥️  Installing GitHub Copilot for VS Code"

  if ! command -v code &>/dev/null; then
    warn "'code' CLI not found. To enable it:"
    warn "  Open VS Code → Command Palette (Ctrl+Shift+P)"
    warn "  Run: 'Shell Command: Install code command in PATH'"
    warn "  Then re-run this script, or install manually via the Extensions panel."
  else
    info "Installing GitHub Copilot extension..."
    code --install-extension GitHub.copilot

    info "Installing GitHub Copilot Chat extension..."
    code --install-extension GitHub.copilot-chat

    success "GitHub Copilot and Copilot Chat installed in VS Code"
    info "Restart VS Code and sign in to GitHub when prompted."
  fi
fi

# =============================================================================
# JETBRAINS (manual guidance)
# =============================================================================
if echo "$INSTALL_CHOICES" | grep -qE "2|4"; then
  header "🧠 GitHub Copilot for JetBrains IDEs"
  echo ""
  echo "JetBrains plugins must be installed from inside the IDE."
  echo ""
  echo "  1. Open your JetBrains IDE"
  echo "  2. Go to: Settings → Plugins → Marketplace"
  echo "  3. Search: 'GitHub Copilot'"
  echo "  4. Click Install → Restart IDE"
  echo "  5. Sign in: Tools → GitHub Copilot → Login to GitHub"
  echo "  6. Copy the device code and enter it at: https://github.com/login/device"
  echo ""
  echo "  Supported IDEs: IntelliJ IDEA, PyCharm, WebStorm, GoLand, Rider, CLion"
  echo "  Minimum version: 2022.1+"
  echo ""
  read -rp "Press Enter to continue..."
fi

# =============================================================================
# COPILOT CLI
# =============================================================================
if echo "$INSTALL_CHOICES" | grep -qE "3|4"; then
  header "💻 Installing GitHub Copilot CLI"

  # Check for GitHub CLI
  if ! command -v gh &>/dev/null; then
    info "GitHub CLI (gh) not found. Installing..."

    OS="$(uname -s)"
    if [ "$OS" = "Darwin" ]; then
      if ! command -v brew &>/dev/null; then
        error "Homebrew not found. Install it from https://brew.sh then re-run."
      fi
      brew install gh
      success "GitHub CLI installed"

    elif [ "$OS" = "Linux" ]; then
      # Try apt (Debian/Ubuntu)
      if command -v apt-get &>/dev/null; then
        sudo mkdir -p -m 755 /etc/apt/keyrings
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
          | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
          | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh -y
        success "GitHub CLI installed via apt"
      else
        error "Could not install gh automatically. See: https://github.com/cli/cli#installation"
      fi

    else
      error "Unsupported OS: $OS. Install gh manually: https://github.com/cli/cli#installation"
    fi
  else
    success "GitHub CLI already installed: $(gh --version | head -1)"
  fi

  # Authenticate gh if needed
  if ! gh auth status &>/dev/null; then
    info "Authenticating GitHub CLI..."
    gh auth login
  else
    success "GitHub CLI already authenticated"
  fi

  # Install Copilot CLI extension
  info "Installing GitHub Copilot CLI extension..."
  gh extension install github/gh-copilot 2>/dev/null || \
    gh extension upgrade gh-copilot 2>/dev/null || true
  success "GitHub Copilot CLI extension installed"
fi

# =============================================================================
# AUTHENTICATION GUIDE
# =============================================================================
header "🔑 Authentication Guide"
echo ""
echo "  ${BOLD}For company-managed Copilot (Business / Enterprise):${RESET}"
echo "  ─────────────────────────────────────────────────────"
echo "  1. Accept your company's GitHub org invite (check your email)"
echo "  2. In VS Code: click the Copilot icon in the status bar → Sign in to GitHub"
echo "  3. Copilot will activate automatically once signed in with your work account"
echo ""
echo "  ${BOLD}For personal subscription:${RESET}"
echo "  ─────────────────────────────────────────────────────"
echo "  1. Go to: https://github.com/settings/copilot"
echo "  2. Start a free trial or subscribe"
echo "  3. Sign in to GitHub in your IDE when prompted"
echo ""
echo "  ${BOLD}For JetBrains:${RESET}"
echo "  ─────────────────────────────────────────────────────"
echo "  1. Tools → GitHub Copilot → Login to GitHub"
echo "  2. Copy the device code shown"
echo "  3. Visit: https://github.com/login/device"
echo "  4. Enter the code and authorize"
echo ""

# =============================================================================
# DONE
# =============================================================================
header "🎉 Setup Complete!"
echo ""
echo "  Quick start in VS Code:"
echo -e "    ${CYAN}Tab${RESET}              — Accept inline suggestion"
echo -e "    ${CYAN}Ctrl+I${RESET}           — Inline chat at cursor"
echo -e "    ${CYAN}Ctrl+Alt+I${RESET}       — Open Copilot Chat panel"
echo ""
echo "  Key chat commands:"
echo -e "    ${CYAN}@workspace /explain${RESET}   — Explain the codebase or a feature"
echo -e "    ${CYAN}/fix${RESET}                  — Fix selected code"
echo -e "    ${CYAN}/tests${RESET}                — Generate unit tests"
echo -e "    ${CYAN}/doc${RESET}                  — Add documentation"
echo ""
echo "  In Agent Mode (Chat panel → switch to 'Agent'):"
echo -e "    ${CYAN}Describe a multi-step task${RESET} — Copilot plans and executes it"
echo ""
if echo "$INSTALL_CHOICES" | grep -qE "3|4"; then
  echo "  In the terminal:"
  echo -e "    ${CYAN}gh copilot suggest \"<task>\"${RESET}   — Get a shell command"
  echo -e "    ${CYAN}gh copilot explain \"<cmd>\"${RESET}    — Explain a shell command"
  echo ""
fi
echo "  Docs: https://docs.github.com/en/copilot"
echo ""