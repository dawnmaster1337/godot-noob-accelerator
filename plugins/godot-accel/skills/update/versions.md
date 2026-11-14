**Version notes.** Step 3 applies each note newer than the project's version, oldest first.

- **Kit 0.5.0:** `tests/smoke_check.*` replaces the `2 + 2` example (delete `example_check.*` if
  unchanged); new ask and deny rules for `.claude/settings.json`; an `autoMemoryDirectory`
  pointing at `.claude/memory` loads memory twice: the user removes it.
- **Kit 0.6.0:** the hand-over lines of `working-with-user.md` (looks, review, "open X, try Y",
  steps last, final message) moved to `handing-over.md`: move the project's wording with them.
  `tools/dev.sh` from 0.5.0 on clears the stop check's list (older: the check is off).
- **Kit 0.6.2:**
  - `"autoMemoryEnabled": false` for `.claude/settings.json` (one memory: the repo's); offer to
    move what Claude's own memory holds into `.claude/memory/` first.
  - Three `showing-work.md` bullets changed. "Cheapest view first" moved to `handing-over.md`,
    unchanged. "Show neutrally" moved there as "Show neutrally, in both directions". "Judge
    against our own approved work" and "Fix defects; don't pre-reject on taste" became one
    bullet, "Sort every finding before showing". A project bullet still in the kit's old words
    (it starts `**Show neutrally:** describe what the output does`, `**Judge against our own
    approved work**, not other games` or `Fix defects; don't pre-reject on taste`) is replaced
    by the new one: that is the kit's wording, not the user's. A bullet the user reworded stays,
    and only what it lacks is added.
  - CLAUDE.md Hard rules: "never call it good" becomes "never rate it for the user, good or bad",
    pointing at both rule files. Offer it; the line is in a file the user owns.
  - `.claude/budgets.md`: the `MEMORY.md` row is 3,000 (was 2,000). A project that set its own
    number keeps it.
  - `tools/dev.sh conform` now fails on a project skill (`.claude/skills/*/SKILL.md`) whose `!`
    command can exit non-zero: such a skill stops loading when the command fails. End each one
    in `; true`.
