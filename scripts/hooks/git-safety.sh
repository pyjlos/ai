#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash)
# Denies destructive git operations that violate ~/.claude/rules/git.md.
# Catches: force-push to main/master, --no-verify, --no-gpg-sign,
#          git reset --hard against main/master, git clean -fdx.
set -euo pipefail

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
[[ -z "$command" ]] && exit 0

# Collapse whitespace for easier matching.
norm=$(printf '%s' "$command" | tr '\n' ' ' | tr -s '[:space:]' ' ')

reason=""

# Force push to main/master (covers --force, -f, --force-with-lease)
if [[ "$norm" =~ git[[:space:]]+push[[:space:]] ]] \
   && [[ "$norm" =~ (--force|--force-with-lease|[[:space:]]-f([[:space:]]|$)) ]] \
   && [[ "$norm" =~ (main|master)([[:space:]]|$) ]]; then
  reason="force-push to main/master is blocked by git.md"
fi

# Skipping git hooks
if [[ -z "$reason" ]] && [[ "$norm" =~ --no-verify ]]; then
  reason="--no-verify is blocked. Fix the hook failure instead of skipping it."
fi

# Bypassing GPG signing
if [[ -z "$reason" ]] && { [[ "$norm" =~ --no-gpg-sign ]] || [[ "$norm" =~ commit\.gpgsign=false ]]; }; then
  reason="bypassing GPG signing is blocked."
fi

# Destructive reset against published branches
if [[ -z "$reason" ]] && [[ "$norm" =~ git[[:space:]]+reset[[:space:]]+--hard[[:space:]]+(origin/)?(main|master) ]]; then
  reason="git reset --hard against main/master is destructive and blocked."
fi

# Forced clean
if [[ -z "$reason" ]] && [[ "$norm" =~ git[[:space:]]+clean[[:space:]]+-([a-z]*f[a-z]*x|[a-z]*x[a-z]*f) ]]; then
  reason="git clean -fdx wipes ignored files (incl. .env, build artefacts). Run targeted removals instead."
fi

if [[ -n "$reason" ]]; then
  echo "git-safety: $reason" >&2
  echo "To override (with care), run the command yourself in a separate shell." >&2
  exit 2
fi

exit 0
