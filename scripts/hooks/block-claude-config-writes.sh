#!/usr/bin/env bash
# PreToolUse hook (matcher: Write|Edit|NotebookEdit)
# Blocks edits to ~/.claude/** to enforce the "edit repo source, then install.sh"
# workflow. Override per-session with: export CLAUDE_ALLOW_HOME_EDITS=1
set -euo pipefail

# Honor the bypass switch (so you can debug hooks themselves).
if [[ -n "${CLAUDE_ALLOW_HOME_EDITS:-}" ]]; then
  exit 0
fi

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
[[ -z "$file_path" ]] && exit 0

# Resolve relative paths to absolute. Avoid `realpath` (not on every macOS).
case "$file_path" in
  /*) abs="$file_path" ;;
  *)  abs="$(pwd)/$file_path" ;;
esac

case "$abs" in
  "$HOME/.claude/"*)
    cat >&2 <<EOF
block-claude-config-writes: refusing to edit '$file_path'.

Files under ~/.claude/ are managed by the ai-agents install script.
Edit the source in your ai-agents repo and re-run:

    bash scripts/install.sh --tool claude

To bypass for this session only:
    export CLAUDE_ALLOW_HOME_EDITS=1
EOF
    exit 2
    ;;
esac

exit 0
