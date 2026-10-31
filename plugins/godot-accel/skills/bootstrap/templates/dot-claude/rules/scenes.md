---
paths:
  - "**/*.tscn"
  - "**/*.tres"
  - "project.godot"
---

# Scenes, resources and project files

- Prefer the editor (or the editor MCP) for scene changes; hand-edit `.tscn` / `.tres` only for
  small, clear text changes, and keep `load_steps`, ids and `uid://` references intact.
- Never edit `.godot/` (Godot's cache), `*.import` (import settings: change them in the editor) or
  `*.uid` files (Godot writes them). The kit's path guard blocks these.
- Never patch third-party plugins in `addons/` or unmodified asset packs: build on top of them
  elsewhere (`scenes/`, `resources/`). Exceptions are listed in `.claude/protected-paths.txt`.
- After a save with stale parse errors, Godot can drop `.tres` fields: `git diff` every `.tres`
  before committing.
- New `class_name` or new asset files: `tools/dev.sh refresh` before headless checks.
- Input: semantic actions in the Input Map (`move_left`, `interact`), never raw keys in code.
- Positions on whole pixels in pixel-art projects; keep texture filtering as the project sets it.
