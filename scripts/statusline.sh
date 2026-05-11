#!/usr/bin/env bash
# Claude Code statusline.
# Reads JSON from stdin, prints a single line:
#   <cwd-tail>  ⎇ <branch>[*]  <model>
set -euo pipefail

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "claude"')

# Tail of cwd: last 2 path components for context without taking up the whole line.
if [[ -n "$cwd" ]]; then
  cwd_tail=$(awk -F/ '{ if (NF>=2) print $(NF-1)"/"$NF; else print $NF }' <<< "$cwd")
else
  cwd_tail="?"
fi

# Git branch + dirty mark (cheap; no remote calls).
branch=""
if [[ -n "$cwd" ]] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  if [[ -n "$branch" ]]; then
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
      branch="${branch}*"
    fi
  fi
fi

if [[ -n "$branch" ]]; then
  printf '%s  ⎇ %s  %s' "$cwd_tail" "$branch" "$model"
else
  printf '%s  %s' "$cwd_tail" "$model"
fi
