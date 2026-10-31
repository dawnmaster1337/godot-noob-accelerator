---
paths:
  - "**/*.gd"
---

# GDScript rules (Godot {{GODOT_VERSION}})

- Static typing everywhere: typed vars, params and returns, `Array[T]`, typed signals.
- `class_name` for reusable types; `@export` or `%UniqueName` instead of long `get_node()` paths.
- Signals up, calls down. No global event bus until a truly cross-scene event needs one.
- Data (stats, items, abilities, levels) lives in `Resource` subclasses, not hard-coded.
  `duplicate()` any Resource you change per instance: resources are shared.
- Game-time logic in `_physics_process` or Timers; UI input in `_unhandled_input` / `_gui_input`,
  marked handled so it doesn't leak.
- Kill the previous `Tween` before starting a new one on the same property. Check
  `is_instance_valid()` after an `await` that can outlive its node.
- Code must pass `gdlint`; `gdformat` runs after every edit (the kit's hook) and before every
  commit (`.githooks/pre-commit`, if enabled).
- Before implementing a new engine system, load the matching `godot-prompter:*` skill if
  GodotPrompter is installed, and name the pattern you picked and the one you rejected.
