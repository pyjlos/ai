---
name: i-have-adhd
description: >
  Use when the user wants direct, structured, ADHD-friendly responses instead
  of long prose — action first, numbered steps, no filler. Trigger on
  "/i-have-adhd", "adhd mode", "give me the short version", or a request to
  cut the preamble and lead with the next action.
---

<!--
Pointer skill for https://github.com/ayghri/i-have-adhd (MIT).
i-have-adhd is a standalone Claude Code plugin/skill, not something we vendor
here. This file only bootstraps it; the plugin's own marketplace listing owns
the real skill content and keeps it current — see "Updates" below.
-->

# i-have-adhd

`i-have-adhd` is a third-party Claude Code plugin that reformats responses to
lead with the answer or next action, use numbered steps, and suppress
tangents — 10 rules tuned for ADHD-friendly communication. We don't
reimplement its ruleset here; this skill only makes sure it's installed, then
gets out of the way.

## What to do when invoked

1. Check whether the plugin is already installed:
   ```bash
   claude plugin list 2>/dev/null | grep -q i-have-adhd
   ```
2. If missing, add the marketplace and install it:
   ```bash
   claude plugin marketplace add ayghri/i-have-adhd
   claude plugin install i-have-adhd@i-have-adhd
   ```
3. Re-invoke `/i-have-adhd` (or whatever the user originally asked for) now
   that the plugin is present, so its own instructions take over.

## Always-on option

If the user wants this active every session without re-invoking, they can
create the flag file the plugin checks for:
```bash
touch ~/.claude/.i-have-adhd-always
```

## Updates

Never hand-edit the plugin's behavior here. To update, re-run the marketplace
install commands above — that pulls the latest version. No diffing needed on
our side.

## Scope note

If the plugin is already installed, this file should rarely be the one that
fires — the plugin's own `/i-have-adhd` command takes over. This file exists
only to catch the "not installed yet" case and self-heal it in one step.
