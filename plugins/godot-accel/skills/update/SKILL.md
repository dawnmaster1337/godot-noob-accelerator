---
name: update
description: Bring a project up to date with the installed kit — "update the kit", "update the accelerator", or when the session-start card says the kit version is behind. Adds new files and merges new lines, keeping the user's wording.
argument-hint: "[optional: an area, e.g. rules, docs, tools]"
---

Area: $ARGUMENTS

Kit templates: `${CLAUDE_SKILL_DIR}/../bootstrap/templates/` (`dot-claude/` = `.claude/`,
`dot-githooks/` = `.githooks/`; their file map and placeholders: `../bootstrap/SKILL.md`). Kit
version: `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`. The project's version:
`.claude/godot-accel/kit-version` (missing = set up before 0.3.0).

!`cat "${CLAUDE_SKILL_DIR}/versions.md" 2>/dev/null; true`

1. **Is it a kit project?** No `.claude/budgets.md` and no `docs/STATUS.md` → offer
   `/godot-accel:realign` (bootstrap if it has no docs); stop. Uncommitted work → `save-work`
   first, so the update is its own commit.
2. **The project's choices,** from what exists, not by asking: language, canon, MCP, extras
   (manifest, standards, paid tools). Use bootstrap's file map with them.
3. **Compare** each template with the project's file:
   - **missing** → add it if the file map says *setup*, placeholders filled as bootstrap would; a
     *first use* file waits until the game needs it;
   - **same** apart from filled placeholders → nothing;
   - **differs** → list the kit lines the project lacks. Lines only the project has are theirs.
   Files the user fills in (STATUS, roadmap, decisions, systems, bugs, quirks, canon,
   memory) are never rewritten: only missing files are added, and a template's new section is
   offered as a heading; their form is `realign`'s job. `shape.md`: kit rows into the first
   table only, with the kit's Made column; "This project's own rows" are theirs.
   - **Version notes** (shown above, from `versions.md`): apply each one newer than the
     project's version. They name what moved, what was reworded and what a setting replaces.
   - **A project skill named like a kit skill** (`.claude/skills/<name>/`): show both skills' `!`
     commands and `allowed-tools` lines side by side. Recommend the kit's, with the project's
     own steps in `.claude/godot-accel/<name>.md` where the kit's skill reads one; the user
     decides.
4. **Show** one table, under 15 lines: file · add / merge / nothing · what changes. Get a yes.
   Ask one at a time only where a kit line contradicts theirs (recommend theirs).
5. **Merge:** each new kit line where it belongs in the user's file; never delete or reword theirs.
   `tools/dev.sh`: the kit's version if the project added nothing, else new verbs beside theirs.
   **Git hooks** that differ from the kit's or chain to `<hook>.project` are theirs: new checks go
   in `<hook>.project`; a rule against Claude editing hooks → give the user the block. New
   `settings.json` entries: auto mode can't write that file, so give the user the command.
   **Over budget** → name file and overage, ask (retire a duplicate, or raise its budget row);
   never cut their content to fit.
6. **Prove it:** `tools/dev.sh check`, `lint all`, `stale`, `budget`, `conform`; quote them. A
   failure the update caused → fix it; a `conform` problem it didn't → offer `realign`.
7. **Record:** the plugin's version into `.claude/godot-accel/kit-version`. Report: added,
   merged, kept as theirs, still open. `godot-sourcing:find-assets` not in your skill list → give
   `/plugin install godot-sourcing@godot-accel`; in it but no `.claude/rules/sourcing.md` → ask
   bootstrap's question 9 and do its step 4 line. Then `save-work` (commit on yes).
