#!/usr/bin/env bash
# Renders a sibling <name>.html next to a markdown report, using the Tailwind/Mermaid
# scaffold from skills/engineering/improve-codebase-architecture/HTML-REPORT.md so
# review-pr and research findings are actually readable, not just diffable.
# Markdown->HTML conversion goes through `marked` (via npx, no persisted dependency)
# so headings/tables/code blocks render correctly for arbitrary report content.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: render-report-html.sh --input <report.md> --title <title> [--project <name>] [--date <date>]

Writes <report>.html next to <report.md>. Markdown stays the canonical file;
this only adds a generated sibling for humans to open in a browser.
EOF
}

input=""
title=""
project=""
date=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input) input="$2"; shift 2 ;;
    --title) title="$2"; shift 2 ;;
    --project) project="$2"; shift 2 ;;
    --date) date="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -z "$input" || -z "$title" ]]; then
  echo "Error: --input and --title are required" >&2
  usage >&2
  exit 1
fi

if [[ ! -f "$input" ]]; then
  echo "Error: input file not found: $input" >&2
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx not found; cannot convert markdown to HTML" >&2
  exit 1
fi

output="${input%.md}.html"

body_html=$(npx -y marked -i "$input")

html_escape() {
  local s="$1"
  s="${s//&/&amp;}"
  s="${s//</&lt;}"
  s="${s//>/&gt;}"
  printf '%s' "$s"
}

title_esc=$(html_escape "$title")
project_esc=$(html_escape "$project")
date_esc=$(html_escape "$date")

{
  cat <<EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>${title_esc}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      article :first-child { margin-top: 0; }
      article h1, article h2, article h3 { font-weight: 600; }
      article h1 { font-size: 1.5rem; margin: 1.5rem 0 0.75rem; }
      article h2 { font-size: 1.25rem; margin: 1.5rem 0 0.75rem; }
      article h3 { font-size: 1.1rem; margin: 1.25rem 0 0.5rem; }
      article p { margin: 0.75rem 0; }
      article ul, article ol { margin: 0.75rem 0; padding-left: 1.5rem; }
      article ul { list-style: disc; }
      article ol { list-style: decimal; }
      article code { background: #f1f5f9; padding: 0.1rem 0.3rem; border-radius: 0.25rem; font-size: 0.9em; }
      article pre { background: #0f172a; color: #e2e8f0; padding: 1rem; border-radius: 0.5rem; overflow-x: auto; margin: 0.75rem 0; }
      article pre code { background: none; padding: 0; color: inherit; }
      article table { border-collapse: collapse; width: 100%; margin: 0.75rem 0; }
      article th, article td { border: 1px solid #e2e8f0; padding: 0.4rem 0.6rem; text-align: left; }
      article th { background: #f8fafc; }
      article blockquote { border-left: 4px solid #cbd5e1; padding-left: 1rem; color: #475569; margin: 0.75rem 0; }
      article a { color: #4338ca; text-decoration: underline; }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-4xl mx-auto px-6 py-12 space-y-8">
      <header class="space-y-1">
        <h1 class="text-2xl font-serif font-semibold">${title_esc}</h1>
EOF
  if [[ -n "$project_esc" ]]; then
    printf '        <p class="text-sm text-slate-500">%s</p>\n' "$project_esc"
  fi
  if [[ -n "$date_esc" ]]; then
    printf '        <p class="text-sm text-slate-500">%s</p>\n' "$date_esc"
  fi
  cat <<EOF
      </header>
      <article class="bg-white rounded-lg border border-slate-200 p-8">
${body_html}
      </article>
    </main>
  </body>
</html>
EOF
} > "$output"

echo "$output"
