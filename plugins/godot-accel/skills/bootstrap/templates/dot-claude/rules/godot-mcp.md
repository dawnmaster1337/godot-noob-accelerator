# Godot editor MCP ({{MCP_SERVER}})

- **Never work blind:** before any code, scene or gameplay step, the `{{MCP_SERVER}}` tools must
  answer (for example an editor-state call). If they don't: check the editor is running
  (`godot --path . -e`), then the plugin's panel. Still down → stop and fix it first; docs-only
  work may go on (say it is down).
- After each step: run the game through the MCP, read the game and editor logs, fix every error.
- Disk edits while the editor is open: run without autosave, so the editor doesn't overwrite them.
- Only one session drives the editor at a time.
- New quirks go into `docs/guides/quirks.md` "Editor and MCP".
