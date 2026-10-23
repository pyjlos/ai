# Design principles behind this skill

These principles come from Anthropic's engineering guidance on writing tools for agents and the Model Context Protocol docs; apply them when proposing a tool list in Step 2 of [SKILL.md](SKILL.md).

## Outcome-level tools, not endpoint mirrors

The most common failure mode is wrapping every REST endpoint as its own tool.
A curated set of tools that each complete a whole task beats a large assortment of thin API wrappers.
Collapse list/detail/pagination endpoints that are always used together into one tool; resolve secondary lookups (such as turning a name into an internal ID) inside the tool rather than exposing a separate lookup tool the model must chain itself.

## Descriptions are prompts, not documentation

The model selects and calls a tool based on its name and description alone.
A vague description ("get project data") causes wrong tool selection; a specific one naming exactly when to use it does not.
Write each tool description as if it were part of the system prompt, because it is.

## Namespace when a server spans systems

When one server covers multiple backend systems (several operators, several APIs), prefix tool names by system or resource (`kafka_health`, `temporal_health`) so the model can tell them apart without trial and error.
This matters more as the number of connected MCP servers grows, since the model may be choosing among tools from several servers at once.

## Return high-signal data, not raw payloads

Tool outputs cost context on every turn they appear in.
Trim responses to the fields that actually inform the next decision (semantic names over raw UUIDs, a status verdict plus the two or three supporting facts, a capped and filtered log tail) rather than passing through the backend's full JSON.
Offering a concise vs. detailed response mode is a cheap way to let the model ask for more only when needed.

## Treat tool arguments as untrusted input

Arguments a model passes to a tool originate from text the model was given, which may include content a user or an external document put there deliberately.
Validate and scope tool arguments the same way you would a web form; never let a tool argument compose a raw shell command, SQL query, or unscoped filesystem path.

## Separate read and mutate tiers

Diagnostic/read-only tools are safe to expose broadly.
Mutating tools need narrower scope, explicit confirmation patterns, and often a separate, more restricted server or auth tier - never blend a broad read tool set with unscoped write access in the same tool catalog.

## Auth maps to caller identity, not server identity

The MCP server should not hold one god-mode credential every caller's session rides on.
Map each caller's identity to backend-scoped permissions (per-user tokens, impersonation, or equivalent) so authorization boundaries that exist in the backend are preserved through the MCP layer, not flattened.

## Sources

- [Writing effective tools for agents](https://www.anthropic.com/engineering/writing-tools-for-agents) - Anthropic engineering
- [Code execution with MCP: building more efficient agents](https://www.anthropic.com/engineering/code-execution-with-mcp) - Anthropic engineering
- [Model Context Protocol docs](https://modelcontextprotocol.io/docs/2026-07-28/develop/build-server) - modelcontextprotocol.io
