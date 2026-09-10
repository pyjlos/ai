---
name: graphify
description: >
  Use for any question about a codebase, its architecture, file relationships,
  or project content — especially when graphify-out/ exists, where the
  question should be treated as a graphify query first. Turns any input
  (code, docs, papers, images, videos) into a persistent knowledge graph with
  god nodes, community detection, and query/path/explain tools. Also trigger
  when the user says "/graphify", "graphify this", "build a knowledge graph
  of this repo", or asks to map/visualize how a codebase's parts connect.
---

<!--
Pointer skill for https://github.com/Graphify-Labs/graphify (Apache-2.0 / MIT).
graphify is a standalone Python CLI + MCP server, not something we vendor here.
This file only bootstraps it; graphify's own installer owns the real skill content
and keeps it current — see "Updates" below.
-->

# Graphify

`graphify` is a third-party CLI (package `graphifyy` on PyPI) that turns a folder
of code/docs/papers/images/video into a queryable knowledge graph — deterministic
AST parsing for code, no vector store, every edge tagged EXTRACTED or INFERRED.
We don't reimplement or vendor its logic here; this skill only makes sure it's
installed, then gets out of the way.

## What to do when invoked

1. Check whether `graphify` is already installed and registered as a skill:
   ```bash
   command -v graphify >/dev/null 2>&1 && graphify --version
   ```
2. If missing, install it and register its own (upstream-maintained) skill:
   ```bash
   uv tool install graphifyy -q || pip install graphifyy -q
   graphify install
   ```
   `graphify install` writes the full, current `/graphify` skill (usage, all
   flags, the detect → extract → cluster → export pipeline) to this tool's
   skills directory. That file — not this one — is the source of truth for
   how to actually run graphify once installed.
3. Re-invoke `/graphify` (or whatever the user originally asked for) now that
   the real skill is present, so the freshly-installed instructions take over.

## Updates

Never hand-edit graphify's behavior here. To update, re-run:
```bash
uv tool install --upgrade graphifyy -q && graphify install
```
This pulls the latest CLI and re-registers its latest skill file — no diffing
needed on our side.

## Scope note

If `graphify` is already installed and its own skill is already registered,
this file should rarely be the one that fires — the richer upstream skill
takes over usage. This file exists only to catch the "not installed yet" case
and self-heal it in one step.
