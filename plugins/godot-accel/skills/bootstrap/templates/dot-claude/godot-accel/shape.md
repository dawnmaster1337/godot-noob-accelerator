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
- **Entries:** the line format `conform` checks: `task` (roadmap; `(old)` for a finished task
  from an old log), `bug` (known bugs), `decision` (records and their index).
- **Made:** `setup` (bootstrap writes it; `conform` needs it) · `first use` (made the first time
  the game needs it, from the kit's template of the same path; the session-start card names the
  templates folder. Until then `conform` doesn't ask for it, and a doc may name it.)

| Home | Path | Kind | Must have | Entries | Made |
|---|---|---|---|---|---|
| Instructions for Claude | `CLAUDE.md` | live | Pillars; How this project is run; Hard rules; Workflow; Commands | | setup |
| Instructions for other agents | `AGENTS.md` | live | | | first use |
| Where work stopped, what's next | `docs/STATUS.md` | live | Resume here; Open questions | | setup |
| The build order, and the build log | `docs/plans/roadmap.md` | live | | task | setup |
| Feature plans | `docs/plans/` | plan | | | setup |
| What each system does now | `docs/systems/` | live | 1. Overview; 2. Scenes and scripts; 3. Data; 4. Checks; 5. Open; 6. Sources; 7. Doc vs code mismatches | | first use |
| Why it is that way | `docs/decisions/` | history | | decision | first use |
| Bugs | `docs/known-bugs.md` | live | Open; Fixed | bug | setup |
| Engine and tool quirks | `docs/guides/quirks.md` | live | Editor and MCP; Headless checks; GDScript and Godot; Shell, git, agents | | setup |
| The user's guides | `docs/guides/` | live | | | setup |
| Reference works, and what the project holds | `docs/research/` | live | | | first use |
| Audit and review reports | `docs/reviews/` | history | | | first use |
| Finished plans, old reviews, retired docs | `docs/archive/` | history | | | first use |
{{#CANON}}
| Story, setting, characters, names | `docs/canon/` | live | | | setup |
{{/CANON}}
{{#STANDARDS}}
| Locked standards | `docs/standards.md` | live | | | setup |
{{/STANDARDS}}
{{#MANIFEST}}
| Every asset and its status | `docs/production/manifest.md` | live | | | setup |
{{/MANIFEST}}
| Rules | `.claude/rules/` | live | | | setup |
| Working rules learned from the user | `.claude/memory/` | live | | | setup |
| Context budgets | `.claude/budgets.md` | live | | | setup |
| Rules the user has had to repeat | `.claude/reminder.md` | live | | | first use |
| Standing session-start reminder | `.claude/start-guard.md` | live | | | first use |

## This project's own rows

Homes this project needs that the kit doesn't have. `update` merges kit rows into the table above
and never touches this one. A row here has the same columns (for example: art references,
`docs/art/`, live, setup); a row without the Made column counts as setup.

| Home | Path | Kind | Must have | Entries | Made |
|---|---|---|---|---|---|
