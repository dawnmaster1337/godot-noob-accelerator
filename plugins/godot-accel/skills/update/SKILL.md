---
name: update
description: Bring a project set up with an older version of this kit up to date — when the user says "update the kit", "update the accelerator", "bring this project up to date" or "catch up with the kit", or the session-start card says the project's kit version is behind the plugin. Adds new template files, merges new kit lines into files the user has edited without replacing their wording, re-runs the checks and records the new version. A project never set up with the kit goes to realign instead.
argument-hint: "[optional: an area, e.g. rules, docs, tools]"
---

Area: $ARGUMENTS

Kit templates: `${CLAUDE_SKILL_DIR}/../bootstrap/templates/` (`dot-claude/` = `.claude/`,
`dot-githooks/` = `.githooks/`; their file map and placeholders: `../bootstrap/SKILL.md`). Kit
version: `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`. The project's version:
`.claude/godot-accel/kit-version` (missing = set up before 0.3.0).

1. **Is it a kit project?** No `.claude/budgets.md` and no `docs/STATUS.md` → offer
   `/godot-accel:realign` (bootstrap if it has no docs); stop. Uncommitted work (`git status`) → offer `save-work` first, so
   the update is its own reviewable commit.
2. **Work out the project's choices** from what exists, not by asking: language (`gdscript.md` /
   `csharp.md`), canon (`docs/canon/`), MCP (`godot-mcp.md`), extras (manifest, standards,
   paid-tools rule). Use bootstrap's file map with those choices.
3. **Compare** each template with the project's file:
   - **missing** → add it, placeholders filled as bootstrap would (from CLAUDE.md, `project.godot`);
   - **same** apart from filled placeholders → nothing;
   - **differs** → list the kit lines or sections the project lacks. Lines only the project has
     are the user's: always kept.
   Files the user fills in (STATUS, roadmap, decisions, system pages, known bugs, quirks, canon,
   memory) are never rewritten: only missing files are added, and a template's new section is
   offered as a heading; their form is `realign`'s job.
4. **Show** one table, under 15 lines: file · add / merge / nothing · what changes. Get a yes.
   Ask separately, one at a time, only where a kit line contradicts the user's own (recommend
   theirs).
5. **Merge:** put each new kit line where it belongs in the user's file. Never delete or reword
   their lines. Scripts (`tools/dev.sh`, `.githooks/*`): take the kit's version when the project
   added nothing of its own; otherwise add the new verbs or checks beside theirs. New entries in
   `settings.suggested.json` → show them and merge on yes.
6. **Prove it:** `tools/dev.sh check`, `lint all`, `stale`, `budget`, `conform`; quote the output.
   A failure the update caused → fix it now; a `conform` problem it didn't → offer `realign`.
7. **Record:** write the plugin's version to `.claude/godot-accel/kit-version`. Report in a few
   lines: added, merged, kept as the user's, still to decide. Then `save-work` (commit on yes).
