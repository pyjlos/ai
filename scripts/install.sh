#!/usr/bin/env bash
# =============================================================================
# AI Agents & Skills Installer
# =============================================================================
# Installs agents and skills from this repo into the config directory of your
# chosen AI tool: Claude Code, GitHub Copilot, or Amazon Q / Kiro.
#
# Each tool has different conventions:
#   Claude Code  — agents: ~/.claude/agents/<name>.md (flat)
#                  skills: ~/.claude/skills/<name>/SKILL.md
#   Copilot      — agents: <home>/.copilot/agents/<name>.md (flat)
#                  skills: <home>/.copilot/skills/<name>/<name>.md
#   Kiro         — agents: <home>/.kiro/agents/<name>.md (flat) + <name>.json
#                  skills: <home>/.kiro/skills/<name>/SKILL.md
#
# Usage (interactive):
#   bash scripts/install.sh
#
# Usage (non-interactive):
#   bash scripts/install.sh --tool claude
#   bash scripts/install.sh --tool copilot --dir ~/my-workspace
#   bash scripts/install.sh --tool kiro    --dir ~/my-workspace
# =============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$REPO_DIR/agents"
SKILLS_DIR="$REPO_DIR/skills"

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

info()    { echo -e "${CYAN}[INFO]${RESET}  $1"; }
success() { echo -e "${GREEN}[OK]${RESET}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $1"; }
error()   { echo -e "${RED}[ERROR]${RESET} $1" >&2; exit 1; }
header()  { echo -e "\n${BOLD}$1${RESET}"; echo "$(printf '─%.0s' {1..60})"; }

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

# Extract a single-line YAML frontmatter field value.
# Returns empty string if field not found or no frontmatter.
frontmatter_field() {
  local file="$1" field="$2"
  awk -v field="$field" '
    /^---$/ { fence++; if (fence == 2) exit; next }
    fence == 1 && $0 ~ ("^" field ": ") {
      sub("^" field ": *", "")
      print
      exit
    }
  ' "$file"
}

# Get the agent name: frontmatter `name:` field, else the filename stem.
agent_name() {
  local file="$1"
  local name
  name=$(frontmatter_field "$file" "name")
  [[ -z "$name" ]] && name=$(basename "$file" .md)
  echo "$name"
}

# Get the agent description: frontmatter `description:` field, else first
# non-empty, non-YAML line of the file body (truncated to 200 chars).
agent_description() {
  local file="$1"
  local desc
  desc=$(frontmatter_field "$file" "description")
  if [[ -z "$desc" ]]; then
    desc=$(grep -m1 '^[A-Za-z]' "$file" | head -c 200)
  fi
  echo "$desc"
}

# Escape a string for use as a JSON value (handles backslash, double-quote,
# and the most common control characters).
json_escape() {
  printf '%s' "$1" \
    | sed 's/\\/\\\\/g; s/"/\\"/g; s/	/\\t/g' \
    | tr -d '\r'
}

# Find all agent source files (exclude README.md), sorted.
find_agents() {
  find "$AGENTS_DIR" -name "*.md" ! -name "README.md" -print0 | sort -z
}

# Find all skill SKILL.md files, sorted.
find_skills() {
  find "$SKILLS_DIR" -name "SKILL.md" -print0 | sort -z
}

# Copy an agent file to dest, injecting minimal frontmatter if the source
# has none (e.g. bare persona files with no --- block).
write_agent() {
  local src="$1" dest="$2" name="$3"
  if [[ -n "$(frontmatter_field "$src" "name")" ]]; then
    cp "$src" "$dest"
  else
    local desc
    desc=$(grep -m1 '^[A-Za-z]' "$src" | head -c 200)
    { printf -- '---\nname: %s\ndescription: %s\nmodel: claude-sonnet-4-6\n---\n\n' \
        "$name" "$desc"
      cat "$src"
    } > "$dest"
  fi
}

# Copy a skill SKILL.md to dest, injecting `user-invocable: true` into the
# frontmatter if it is not already present (required by Claude Code).
write_claude_skill() {
  local src="$1" dest="$2"
  if grep -q '^user-invocable:' "$src"; then
    cp "$src" "$dest"
  else
    # Insert `user-invocable: true` just before the closing --- of the frontmatter
    awk '/^---$/ && ++fence==2 { print "user-invocable: true" } { print }' \
      "$src" > "$dest"
  fi
}

# -----------------------------------------------------------------------------
# Claude Code
# -----------------------------------------------------------------------------
install_claude() {
  local home_dir="$1"
  local agents_out="$home_dir/agents"
  local skills_out="$home_dir/skills"

  header "Agents  →  $agents_out"
  mkdir -p "$agents_out"

  local count=0
  while IFS= read -r -d '' f; do
    local name
    name=$(agent_name "$f")
    write_agent "$f" "$agents_out/${name}.md" "$name"
    success "  $name"
    count=$(( count + 1 ))
  done < <(find_agents)
  info "$count agents installed"

  header "Skills  →  $skills_out"
  mkdir -p "$skills_out"

  local scount=0
  while IFS= read -r -d '' f; do
    local skill_name
    skill_name=$(basename "$(dirname "$f")")
    mkdir -p "$skills_out/$skill_name"
    write_claude_skill "$f" "$skills_out/$skill_name/SKILL.md"
    success "  $skill_name"
    scount=$(( scount + 1 ))
  done < <(find_skills)
  info "$scount skills installed"
}

# -----------------------------------------------------------------------------
# GitHub Copilot
# Agents: <home>/.copilot/agents/<name>.md
# Skills: <home>/.copilot/skills/<name>/<name>.md  (filename = skill name)
# -----------------------------------------------------------------------------
install_copilot() {
  local home_dir="$1"
  local agents_out="$home_dir/.copilot/agents"
  local skills_out="$home_dir/.copilot/skills"

  header "Agents  →  $agents_out"
  mkdir -p "$agents_out"

  local count=0
  while IFS= read -r -d '' f; do
    local name
    name=$(agent_name "$f")
    write_agent "$f" "$agents_out/${name}.md" "$name"
    success "  $name"
    count=$(( count + 1 ))
  done < <(find_agents)
  info "$count agents installed"

  header "Skills  →  $skills_out"
  mkdir -p "$skills_out"

  local scount=0
  while IFS= read -r -d '' f; do
    local skill_name
    skill_name=$(basename "$(dirname "$f")")
    mkdir -p "$skills_out/$skill_name"
    # Copilot convention: filename matches the skill name, not SKILL.md
    cp "$f" "$skills_out/$skill_name/${skill_name}.md"
    success "  $skill_name"
    scount=$(( scount + 1 ))
  done < <(find_skills)
  info "$scount skills installed"
}

# -----------------------------------------------------------------------------
# Amazon Q / Kiro
# Agents: <home>/.kiro/agents/<name>.md  (plus a <name>.json sidecar)
# Skills: <home>/.kiro/skills/<name>/SKILL.md
# -----------------------------------------------------------------------------
install_kiro() {
  local home_dir="$1"
  local agents_out="$home_dir/.kiro/agents"
  local skills_out="$home_dir/.kiro/skills"

  header "Agents  →  $agents_out"
  mkdir -p "$agents_out"

  local count=0
  while IFS= read -r -d '' f; do
    local name desc model desc_escaped
    name=$(agent_name "$f")
    desc=$(agent_description "$f")
    model=$(frontmatter_field "$f" "model")
    [[ -z "$model" ]] && model="claude-sonnet-4-6"
    desc_escaped=$(json_escape "$desc")

    # Markdown body
    write_agent "$f" "$agents_out/${name}.md" "$name"

    # JSON sidecar required by Kiro
    cat > "$agents_out/${name}.json" <<JSON
{
  "name": "$name",
  "description": "$desc_escaped",
  "tools": ["fs_read", "fs_write", "execute_bash"],
  "allowedTools": ["fs_read", "fs_write", "execute_bash"],
  "model": "$model"
}
JSON

    success "  $name  (+.json)"
    count=$(( count + 1 ))
  done < <(find_agents)
  info "$count agents installed (with JSON sidecars)"

  header "Skills  →  $skills_out"
  mkdir -p "$skills_out"

  local scount=0
  while IFS= read -r -d '' f; do
    local skill_name
    skill_name=$(basename "$(dirname "$f")")
    mkdir -p "$skills_out/$skill_name"
    cp "$f" "$skills_out/$skill_name/SKILL.md"
    success "  $skill_name"
    scount=$(( scount + 1 ))
  done < <(find_skills)
  info "$scount skills installed"
}

# -----------------------------------------------------------------------------
# Argument parsing
# -----------------------------------------------------------------------------
TOOL=""
INSTALL_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)  TOOL="$2";        shift 2 ;;
    --dir)   INSTALL_DIR="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: $0 [--tool claude|copilot|kiro] [--dir <path>]"
      exit 0
      ;;
    *) error "Unknown argument: $1. Run with --help for usage." ;;
  esac
done

# -----------------------------------------------------------------------------
# Interactive prompts
# -----------------------------------------------------------------------------
header "AI Agents & Skills Installer"
echo ""
info "Source: $REPO_DIR"
echo ""

if [[ -z "$TOOL" ]]; then
  echo "Which tool would you like to install for?"
  echo "  [1] Claude Code"
  echo "  [2] GitHub Copilot"
  echo "  [3] Amazon Q / Kiro"
  echo ""
  read -rp "Your choice [1-3]: " TOOL_CHOICE
  case "$TOOL_CHOICE" in
    1) TOOL="claude"  ;;
    2) TOOL="copilot" ;;
    3) TOOL="kiro"    ;;
    *) error "Invalid choice. Enter 1, 2, or 3." ;;
  esac
fi

# Set default install dir per tool
case "$TOOL" in
  claude)  DEFAULT_DIR="$HOME/.claude" ;;
  copilot) DEFAULT_DIR="$HOME" ;;
  kiro)    DEFAULT_DIR="$HOME" ;;
  *)       error "Unknown tool '$TOOL'. Valid values: claude, copilot, kiro" ;;
esac

if [[ -z "$INSTALL_DIR" ]]; then
  read -rp "Install directory [default: $DEFAULT_DIR]: " INPUT_DIR
  INSTALL_DIR="${INPUT_DIR:-$DEFAULT_DIR}"
fi

# Expand leading ~ to $HOME
INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"

echo ""
info "Tool:       $TOOL"
info "Install →   $INSTALL_DIR"
echo ""
read -rp "Proceed? [y/N]: " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# -----------------------------------------------------------------------------
# Run
# -----------------------------------------------------------------------------
case "$TOOL" in
  claude)  install_claude  "$INSTALL_DIR" ;;
  copilot) install_copilot "$INSTALL_DIR" ;;
  kiro)    install_kiro    "$INSTALL_DIR" ;;
esac

header "Done!"
echo ""
echo -e "  ${GREEN}Agents and skills installed successfully for $TOOL.${RESET}"
echo ""
