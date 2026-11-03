# Engine and tool quirks

The one home for engine, tool and shell quirks; read before debugging. Budget: 5,500 characters.
A quirk that a script can own moves into the script (`tools/dev.sh`) and leaves this page.
User preferences go to `.claude/memory/`, not here.

One line per quirk: the symptom, then the fix. Tag each with where it was seen: *Godot 4.7,
verified 2026-11* (reproduced on that version) or *seen 2026-10* (reported, not reproduced). After
a Godot upgrade, re-check the quirks tagged with an older version, or retire them.

## Editor and MCP

## Headless checks

- *Godot 4.x:* a new `class_name` is "not found" in a headless run → `tools/dev.sh refresh`
  first (it rebuilds the class cache).
- *Seen 2026-10:* every frame-time measurement reads the monitor's refresh rate (about 60, 144,
  165 fps) → vsync caps it; measure with `--disable-vsync` (a driver can still force vsync).

## GDScript and Godot

- *Godot 4.7, verified 2026-11:* JSON numbers load as floats: for `JSON.parse_string("[3]")`,
  `arr.has(3)` and `3 in arr` are false (`arr[0] == 3` is true), and int dictionary keys miss
  too → convert with `int()` before lookups.
- *Godot 4.7, verified 2026-11:* `load(path)` returns the cached instance the game already holds,
  so a "file vs game" comparison compares a thing with itself → load with
  `ResourceLoader.CACHE_MODE_IGNORE_DEEP`.
- *Godot 4.7, verified 2026-11:* a `.tres` stores only values that differ from the script's
  default: a preset that looks nearly empty is normal, and a changed default reaches every preset
  that doesn't store that value.
- *Godot 4.7, verified 2026-11:* `ResourceSaver.save()` from a running game or script drops
  `uid="uid://…"` from `[ext_resource]` lines and can drop the file's own uid → expect it in the
  diff; save from the editor when references matter.
- *Godot 4.7, verified 2026-11:* a method named like an Object virtual (`_set`, `_get`, `_init`,
  `_notification`) overrides it: a helper `_set()` runs for every property set, `name` included
  → name helpers without the leading underscore pattern (`set_value`).
- *Godot 4.x:* with physics interpolation on, a node moved by code (respawn, teleport) smears
  across the screen for a frame → call `reset_physics_interpolation()` right after moving it.
- *Seen 2026-10:* shrinking the obvious control doesn't fix an overflowing layout → print
  `get_combined_minimum_size()` for each child of the container first: one child sets the size,
  and it is often not the one that looks biggest.

## Shell, git, agents

- *Seen 2026-10:* a background wait or kill with `pgrep -f`/`pkill -f '<pattern>'` hangs or kills
  its own shell (the pattern is in the shell's own command line) → wait on the PID
  (`while kill -0 $pid`), on an output file, or write the pattern so it can't match itself
  (`pgrep -f '[b]uild.py'`).
- *Seen 2026-10:* `git push` says "Repository not found" with several `gh` accounts logged in →
  the active account has no access. One push as the owner, without switching accounts:
  `git -c credential.helper= -c "credential.helper=!f() { echo username=<account>; echo password=\$(gh auth token -u <account>); }; f" push`
- *Seen 2026-10 (Linux):* window captures come out pure black → the desktop is locked; check
  first (`loginctl show-session <id> -p LockedHint`) and say so instead of sending black images.
- *Seen 2026-11:* a new git worktree in a project using Git LFS opens in Godot with broken art
  or sounds → it holds LFS pointer files: `git lfs pull` in the worktree before opening Godot.
