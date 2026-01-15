---
description: Look up library documentation using the context7 subagent
argument-hint: <library or query>
model: inherit
---

# Context7 Documentation Lookup

Use the context7 subagent to find accurate, up-to-date documentation for: {{arg}}

## Instructions

1. Launch the context7 subagent via Task tool with `subagent_type: "context7"`
2. Pass the query: "{{arg}}"
3. The subagent will:
   - Resolve library IDs using Context7 MCP
   - Fetch relevant documentation
   - Return code examples, API signatures, and usage patterns
4. Present the documentation findings to the user

The context7 subagent handles all Context7 MCP interactions - never use `mcp__context7__*` tools directly.
