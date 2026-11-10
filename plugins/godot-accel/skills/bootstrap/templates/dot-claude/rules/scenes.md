---
paths:
  - "**/*.tscn"
  - "**/*.tres"
  - "**/project.godot"
---

# Scenes, resources and project files

- Prefer the editor (or the editor MCP) for scene changes; hand-edit `.tscn` / `.tres` only for
  small, clear text changes, and keep ids and `uid://` references intact (and `load_steps`, if
  an older file has one; Godot 4.7 no longer writes it).
- **Moving or renaming a script or scene** outside the editor: move its `.uid` file with it
  (`git mv a.gd b/a.gd` and `git mv a.gd.uid b/a.gd.uid`). Left behind, Godot gives the file a
  new uid and every scene that used it fails to load (verified on 4.7.2). In the editor's
  FileSystem dock, Godot moves both and fixes the references.
- **Moving a node** (its order or parent) is an editor job, not a small text change. By hand:
  count `[node ` headers before and after; a cut block eats the newline before the next header
  (`tools/dev.sh tidy` lists headers that no longer start a line).
- **A tool that writes a `.tscn`** proves the round trip before saving: `pack()` the tree,
  instantiate the result, compare its node paths with the originals and check the property
  stuck. Any difference → save nothing and say why (`pack()` drops nodes whose owner is wrong).
- **`ResourceSaver.save()` from a running game or tool** writes `[ext_resource]` lines without
  their `uid://`. Expect it in the diff; prefer the editor when references matter.
- Never edit `.godot/` (Godot's cache), `*.import` (import settings: change them in the editor) or
  `*.uid` files (Godot writes them). The kit's path guard and the project's deny rules guard these; neither stops a script.
- Never patch third-party plugins in `addons/` or unmodified asset packs: build on top of them
  elsewhere (`scenes/`, `resources/`). Exceptions are listed in `.claude/protected-paths.txt`.
- After a save with stale parse errors, Godot can drop `.tres` fields: `git diff` every `.tres`
  before committing.
- New `class_name` or new asset files: `tools/dev.sh refresh` before headless checks.
- Input: semantic actions in the Input Map (`move_left`, `interact`), never raw keys in code.
- Positions on whole pixels in pixel-art projects; keep texture filtering as the project sets it.
