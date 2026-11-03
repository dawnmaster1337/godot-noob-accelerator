# Project shape

The one list of where each kind of fact lives in this project and the form it takes. Every kit
project has the same rows, so every project reads the same way. Checked by `tools/dev.sh conform`;
`tools/dev.sh stale` reads the **live** rows. Written by the {{KIT_NAME}} kit; `update` merges new
kit rows.

A home this project needs that the kit doesn't have gets its own row here: a declared home is part
of the shape, an undeclared doc is drift. Never a second file doing a row's job.

- **Kind:** `live` (true now: every backticked path in it must exist) · `plan` (names files not
  written yet) · `history` (frozen records: may name files since deleted).
- **Must have:** the `##` headings each file has, in this order (a heading may say more after
  these words). A folder row applies them to each page in it, except `README.md` and `_template.md`.
- **Entries:** the line format `conform` checks: `task` (roadmap), `bug` (known bugs),
  `decision` (records and their index).

| Home | Path | Kind | Must have | Entries |
|---|---|---|---|---|
| Instructions for Claude | `CLAUDE.md` | live | Pillars; How this project is run; Hard rules; Project layout; Engine settings; Workflow; Commands | |
| Instructions for other agents | `AGENTS.md` | live | | |
| Where work stopped, what's next | `docs/STATUS.md` | live | Resume here; Open questions | |
| The build order, and the build log | `docs/plans/roadmap.md` | live | | task |
| Feature plans | `docs/plans/` | plan | | |
| What each system does now | `docs/systems/` | live | 1. Overview; 2. Scenes and scripts; 3. Data; 4. Checks; 5. Open; 6. Sources; 7. Doc vs code mismatches | |
| Why it is that way | `docs/decisions/` | history | | decision |
| Bugs | `docs/known-bugs.md` | live | Open; Fixed | bug |
| Engine and tool quirks | `docs/guides/quirks.md` | live | Editor and MCP; Headless checks; GDScript and Godot; Shell, git, agents | |
| The user's guides | `docs/guides/` | live | | |
| Reference works, and what the project holds | `docs/research/` | live | | |
| Audit and review reports | `docs/reviews/` | history | | |
| Finished plans, old reviews, retired docs | `docs/archive/` | history | | |
{{#CANON}}| Story, setting, characters, names | `docs/canon/` | live | | |
{{/CANON}}{{#STANDARDS}}| Locked standards | `docs/standards.md` | live | | |
{{/STANDARDS}}{{#MANIFEST}}| Every asset and its status | `docs/production/manifest.md` | live | | |
{{/MANIFEST}}| Rules | `.claude/rules/` | live | | |
| Working rules learned from the user | `.claude/memory/` | live | | |
| Context budgets | `.claude/budgets.md` | live | | |
| Rules the user has had to repeat | `.claude/reminder.md` | live | | |
| Standing session-start reminder | `.claude/start-guard.md` | live | | |

## This project's own rows

Homes this project needs that the kit doesn't have. `update` merges kit rows into the table above
and never touches this one. A row here has the same five columns (for example: art references,
`docs/art/`, live).

| Home | Path | Kind | Must have | Entries |
|---|---|---|---|---|
