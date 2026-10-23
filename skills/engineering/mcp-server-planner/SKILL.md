---
name: mcp-server-planner
description: Interview the user about an existing API (optional) and the real tasks their users want to accomplish, then propose a concrete MCP server design - tool list, auth model, response shaping, and a phased build plan. Use when the user wants to wrap a REST/gRPC API in MCP, asks how to expose a service to Claude, or says "build an MCP for X" / "plan an MCP server".
---

# MCP server planner

Produce a build plan for an MCP server, grounded in the real tasks its callers will perform rather than a mirror of the underlying API's endpoints.
See [REFERENCE.md](REFERENCE.md) for the design principles this plan applies and their sources.

## Step 1: Interview

Ask the user these questions, skipping any already answered in conversation.
Keep it to one message; do not drip questions one at a time.

1. **Source API** (optional) - do you have an existing API/spec (OpenAPI, proto, docs link)? If none yet, what will the backend be?
2. **Callers** - who issues requests through Claude: your own engineers, internal operators, or external end users? This drives the auth model.
3. **Top tasks** - list the 3-7 concrete questions or actions these callers actually need done, in their own words (e.g. "is Kafka down in dev", "assign this ticket to Sarah"). Concrete examples beat a feature list.
4. **Read vs write** - is this read-only/diagnostic, or does it need to mutate state? Mutating tools need tighter scoping and confirmation.
5. **Auth and multi-tenancy** - does each caller need their own scoped credentials/permissions, or is one service-level credential acceptable?
6. **Scale** - roughly how many underlying endpoints/resources, and is this one API or several systems to correlate (e.g. app + several cluster-level operators)?
7. **Sensitive data** - any fields, logs, or resources that must never reach the model (secrets, PII, raw stack traces)?
8. **Deployment target** - local stdio server, remote hosted server, or a Claude Desktop/Code extension?

## Step 2: Derive the tool design

From the answers, do **not** propose one tool per endpoint.
Group the top tasks from question 3 into outcome-level tools: each tool should complete a whole task a caller actually asks for, with orchestration (pagination, multi-endpoint correlation, ID lookups) handled inside the tool, not left for the model to chain.

For each proposed tool, specify:

- Name, namespaced if the server spans multiple systems (e.g. `kafka_health`, `issue_find`).
- One-paragraph description written as a prompt for the model, not internal documentation.
- Parameters, with sane defaults for anything like pagination or time windows.
- Response shape: the trimmed, high-signal fields returned, not the raw backend payload.
- Read or mutate, and if mutate, what confirmation or scoping it needs.

Split mutating tools into a separate, more tightly scoped tier or server if question 4 indicates any state changes, per [REFERENCE.md](REFERENCE.md).

## Step 3: Write the plan

Produce a short plan document (chat response, or a file if the user is in a repo and asks for one) with:

1. **Scope** - the tasks this MCP server serves, restated from question 3.
2. **Tool list** - the table from Step 2.
3. **Auth design** - how caller identity maps to backend permissions (per-user scoped credentials vs. shared service credential), based on question 5.
4. **Response shaping rules** - truncation/default windows for anything log- or list-like, to protect model context.
5. **Risks and exclusions** - what is deliberately NOT exposed as a tool (raw mutation endpoints, admin-only resources, anything from question 7), and why.
6. **Phased rollout** - ship read-only/diagnostic tools first; add mutating tools only once the read path is trusted in use.

End by asking whether the tool list matches the real tasks from Step 1, and whether any proposed tool is missing a backend capability the user hasn't built yet.
