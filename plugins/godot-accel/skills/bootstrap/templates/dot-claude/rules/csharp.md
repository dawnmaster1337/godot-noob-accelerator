---
paths:
  - "**/*.cs"
---

# C# rules (Godot {{GODOT_VERSION}} .NET)

- Every Godot class is `partial`; one public class per file, named as the file.
- Signals as `[Signal] public delegate void XEventHandler(...)`; emit with
  `EmitSignal(SignalName.X, ...)`. Signals up, calls down.
- Avoid allocations in `_Process` / `_PhysicsProcess` (strings, LINQ, boxing to `Variant`).
- Data lives in `Resource` subclasses with `[Export]`; `Duplicate()` any you change per instance.
- Build before running: a C# change needs `dotnet build` (or the editor's Build) or the old code runs.
- Before implementing a new engine system, load the matching `godot-prompter:*` skill if
  GodotPrompter is installed (`csharp-godot`, `csharp-signals`).
