#!/usr/bin/env bash
# =============================================================================
# Amazon Q Developer - Automated Setup Script
# =============================================================================
# Installs Amazon Q for VS Code, JetBrains, and/or the terminal CLI.
# Run with: bash setup-amazon-q.sh
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

header "🤖 Amazon Q Developer Setup"
echo ""
echo "This script sets up Amazon Q Developer for your preferred tools."
echo ""
echo "Which would you like to set up?"
echo "  [1] VS Code extension"
echo "  [2] JetBrains plugin (manual — IDE required)"
echo "  [3] Terminal / CLI (macOS via Homebrew)"
echo "  [4] All of the above"
echo ""
read -rp "Your choice (e.g. 1 3 or 4): " INSTALL_CHOICES

# =============================================================================
# VS CODE EXTENSION
# =============================================================================
if echo "$INSTALL_CHOICES" | grep -qE "1|4"; then
  header "🖥️  Installing Amazon Q for VS Code"

  if ! command -v code &>/dev/null; then
    warn "'code' CLI not found. Open VS Code and run:"
    warn "  Command Palette (Ctrl+Shift+P) → 'Shell Command: Install code command in PATH'"
    warn "Then re-run this script, or install manually:"
    warn "  Search 'Amazon Q' in the Extensions panel (Ctrl+Shift+X)"
  else
    code --install-extension AmazonWebServices.amazon-q-vscode
    success "Amazon Q extension installed in VS Code"
    info "Restart VS Code, then click the Amazon Q icon in the sidebar to sign in."
  fi
fi

# =============================================================================
# JETBRAINS (manual guidance)
# =============================================================================
if echo "$INSTALL_CHOICES" | grep -qE "2|4"; then
  header "🧠 Amazon Q for JetBrains IDEs"
  echo ""
  echo "JetBrains plugins must be installed from inside the IDE."
  echo "Follow these steps:"
  echo ""
  echo "  1. Open your JetBrains IDE (IntelliJ, PyCharm, WebStorm, etc.)"
  echo "  2. Go to: Settings → Plugins → Marketplace"
  echo "  3. Search: 'Amazon Q'"
  echo "  4. Click Install → Restart IDE"
  echo "  5. Open the Amazon Q panel: View → Tool Windows → Amazon Q"
  echo "  6. Sign in with IAM Identity Center or AWS Builder ID"
  echo ""
  echo "  Plugin link: https://plugins.jetbrains.com/plugin/24267-amazon-q"
  echo ""
  read -rp "Press Enter to continue..."
fi

# =============================================================================
# CLI / TERMINAL (macOS)
# =============================================================================
if echo "$INSTALL_CHOICES" | grep -qE "3|4"; then
  header "💻 Installing Amazon Q CLI"

  OS="$(uname -s)"

  if [ "$OS" = "Darwin" ]; then
    # macOS — use Homebrew
    if ! command -v brew &>/dev/null; then
      error "Homebrew is not installed. Install it first: https://brew.sh"
    fi

    info "Installing amazon-q via Homebrew..."
    brew install amazon-q
    success "Amazon Q CLI installed"

    info "Setting up shell integration..."
    q integrations install --all 2>/dev/null || {
      warn "Shell integration requires a restart. Run 'q integrations install' after restarting your terminal."
    }

    success "Amazon Q CLI ready!"
    info "  Try it: q chat"
    info "  In terminal: press Option+C for inline Q panel"

  elif [ "$OS" = "Linux" ]; then
    warn "Amazon Q CLI on Linux is in preview. Check the latest instructions at:"
    warn "  https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-getting-started-installing.html"

  else
    warn "Unsupported OS for CLI setup: $OS"
  fi
fi

# =============================================================================
# AUTHENTICATION GUIDANCE
# =============================================================================
header "🔑 Authentication"
echo ""
echo "Amazon Q supports two login methods:"
echo ""
echo "  ${BOLD}Option A — IAM Identity Center (recommended for company accounts)${RESET}"
echo "  ─────────────────────────────────────────────────────────────"
echo "  1. Open the Amazon Q panel in your IDE or run: q login"
echo "  2. Choose 'Sign in with IAM Identity Center'"
echo "  3. Enter your company SSO start URL:"
echo "     (e.g., https://yourcompany.awsapps.com/start)"
echo "  4. Log in via the browser window that opens"
echo ""
echo "  ${BOLD}Option B — AWS Builder ID (personal/free tier)${RESET}"
echo "  ─────────────────────────────────────────────────────────────"
echo "  1. Open the Amazon Q panel or run: q login"
echo "  2. Choose 'Sign in with AWS Builder ID'"
echo "  3. Create or log in at: https://profile.aws.amazon.com"
echo ""
echo "  ⚠️  Company users should use Option A to get Pro tier features."
echo ""

# =============================================================================
# DONE
# =============================================================================
header "🎉 Setup Complete!"
echo ""
echo "  Quick start:"
echo -e "    ${CYAN}In VS Code${RESET}        — Click the Amazon Q icon in the left sidebar"
echo -e "    ${CYAN}In JetBrains${RESET}      — View → Tool Windows → Amazon Q"
echo -e "    ${CYAN}In terminal${RESET}       — q chat"
echo -e "    ${CYAN}Inline chat${RESET}       — Select code → right-click → Amazon Q"
echo ""
echo "  Key slash commands in chat:"
echo -e "    ${CYAN}/dev <task>${RESET}        — Agent mode (multi-file changes)"
echo -e "    ${CYAN}/explain${RESET}           — Explain selected code"
echo -e "    ${CYAN}/tests${RESET}             — Generate unit tests"
echo -e "    ${CYAN}/fix${RESET}               — Fix issues in selected code"
echo ""
echo "  Docs: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/what-is.html"
echo ""