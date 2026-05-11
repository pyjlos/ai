#!/usr/bin/env bash
# PreToolUse hook (matcher: Write|Edit|NotebookEdit)
# Denies writes to files that look like secrets/credentials.
# Reads tool input JSON from stdin, exits 2 with stderr message to block.
set -euo pipefail

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
[[ -z "$file_path" ]] && exit 0

base=$(basename "$file_path")

deny=0
case "$base" in
  .env|.env.*|*.key|*.pem|*.p12|*.pfx|id_rsa|id_ed25519|id_ecdsa|credentials|secrets.yaml|secrets.yml)
    deny=1 ;;
esac

case "$file_path" in
  */.ssh/*|*/secrets/*|*/.aws/credentials|*/.gnupg/*|*/.kube/config)
    deny=1 ;;
esac

if [[ "$deny" -eq 1 ]]; then
  echo "block-secret-files: refusing to write to '$file_path' — looks like a secret/credential. Use environment variables or a secrets manager." >&2
  exit 2
fi

exit 0
