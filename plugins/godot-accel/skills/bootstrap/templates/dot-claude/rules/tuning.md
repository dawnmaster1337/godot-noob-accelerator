---
paths:
  - "**/*.tres"
  - "**/*.tscn"
  - "**/*tuning*.gd"
  - "**/*_tuning.cs"
  - "**/*Tuning.cs"
---

# Tuning values and the user's hand edits

- **Feel values live in data.** Every number the player feels (speeds, timings, jump height,
  damage, cooldowns) is an `@export` on a `<Feature>Tuning` Resource, saved as a `.tres`
  preset; never a constant in a script. Give each one `@export_range` and a `##` comment, so
  the Inspector shows its range and what it does.
- **Change the preset, not only the script default.** Godot saves only the values that differ
  from the script's default. A new default in the script is silently overridden by a value
  already saved in the `.tres`, and a preset that looks nearly empty is normal. Read the
  `.tres` before saying what a value is; change it there.
- **Hand edits are the user's.** An uncommitted change to a `.tres`, `.tscn` or tuning script
  that you didn't make is the user's editor or Inspector work. Re-read the file from disk before
  editing it, build on their values, and ask before changing one they set. Never revert it.
- **Say where it lives.** Each value's file, Inspector group and safe range go in its system
  page (`docs/systems/<system>.md` §3), so the user can change it without asking.
