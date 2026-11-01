# Structure: every file bootstrap writes, and why

Bootstrap never overwrites: for a file you already have it shows the difference and asks (keep
yours, append a delimited section, or replace on your word). "Optional" files are written only
when you pick them.

## Project root

| File | Why it exists |
|---|---|
| `CLAUDE.md` | Claude's instructions, loaded every session: pitch and pillars, where each kind of fact lives, the **Hard rules**, layout, engine settings, workflow, commands. Under 200 lines |
| `AGENTS.md` | The read order and per-task loop for any other AI agent or developer |
| `.gitignore`, `.gitattributes` | Appended in a `>>> godot-accel >>>` block: Godot's cache, exports, secrets, local Claude settings, the inbox; LF line endings, LFS lines commented out |

## `.claude/`

| File | Why |
|---|---|
| `rules/working-with-user.md` | One question at a time with recommendations, APR, echo requests back, mockups, recording answers, timeboxed polish, review cadence, trigger words |
| `rules/git.md` | Fetch and ask before pulling; commit on yes; stage by path; no blanket destructive commands; secrets never in chat |
| `rules/showing-work.md` | Checks before the user sees anything, quoted; show neutrally, never praise |
| `rules/docs.md` (`paths: docs/**` …) | One home per fact, naming, fixing every copy, budgets, one term per thing |
| `rules/scenes.md` (`paths: *.tscn, *.tres, project.godot`) | Engine-owned files, third-party plugins, `.tres` diffs, input actions |
| `rules/tuning.md` (`paths: *.tres, *.tscn, tuning scripts`) | Feel values in `Tuning` Resources; change the preset, not only the default; the user's hand edits are theirs |
| `rules/gdscript.md` / `csharp.md` (`paths: *.gd` / `*.cs`) | Language rules, loaded only when Claude touches those files |
| `rules/godot-mcp.md` *(optional)* | "Never work blind" when an editor MCP server is used |
| `rules/paid-tools.md` *(optional)* | Spend gate for any paid API |
| `memory/MEMORY.md`, `memory/README.md` | The project's memory index (imported by CLAUDE.md) and its format |
| `budgets.md` | Character budgets `trim-context` enforces |
| `protected-paths.txt` | Extra paths the guard hook blocks (`addons/*` …), with `!` exceptions |
| `start-guard.md` | A short standing reminder shown at every session start (empty by default) |
| `godot-accel/kit-version` | The kit version the project was set up or last updated with; `update` and the session-start card compare it with the plugin |
| `settings.json` | The suggested permissions (`settings.suggested.json`) merged in on your yes |
| `settings.local.json` | Per machine: `autoMemoryDirectory` pointing at `.claude/memory` (git-ignored) |
| `agents/playtester.md` *(optional)* | Drives the game through your editor MCP; never edits |

## `docs/`

| File | Why |
|---|---|
| `STATUS.md` | Where work stopped, **Next**, the only open-questions list. Read first on resume; under 5,000 characters; no session logs |
| `known-bugs.md` | Bugs known and not yet fixed (repro, expected, actual), and the last 20 fixed with their cause |
| `decisions/README.md`, `_template.md` | Index of decisions with status, and the record shape (Topic \| Decision \| Why, your answers, rejected options) |
| `plans/roadmap.md`, `_template.md` | The milestones; a plan's shape (Done =, design, ticked tasks) |
| `systems/_template.md` | "What is true now" page per system, with Sources, Open and doc-vs-code mismatches |
| `reviews/README.md`, `archive/README.md` | Where audit reports and finished plans go |
| `guides/start-here.md` | Your one-page daily routine |
| `guides/between-sessions.md` | What you can do while Claude isn't running: inbox drops, note shapes |
| `guides/setup-new-machine.md` | Install, clone, hooks path, the daily routine across machines |
| `guides/quirks.md` | Engine and tool gotchas, one line each |
| `canon/` *(optional)* | `bible.md`, `README.md` (who owns it), `requests/_template.md` |
| `standards.md` *(optional)* | Row-by-row standards with status (locked, proved, proposed, open, later) |
| `production/manifest.md` *(optional)* | Every asset the game needs and where it stands |

## Other folders

| File | Why |
|---|---|
| `inbox/README.md`, `inbox/.gdignore` | The drop box; Godot ignores it, git tracks only the README |
| `tools/dev.sh` | `check` (refresh when files changed + every or named headless checks), `refresh`, `lint`, `stale`, `budget`, `tidy` |
| `tests/example_check.gd`, `.tscn` | The check-scene pattern: exit code = failures. Copy it per system |
| `.githooks/` | Do nothing until `git config core.hooksPath .githooks` (per clone). `pre-commit`: lint, format, no `.godot/`, `.env` or key-shaped strings. `pre-push`: hands over to git-lfs. Identity checks only where `~/.config/identity-guard/` exists (`.githooks/README.md`) |

## In the plugin (not copied; updated with the plugin)

Skills (`resume`, `plan-feature`, `ship-check`, `save-work`, `trim-context`, `project-audit`,
`canon-check`, `harvest-learnings`, `bootstrap`, `update`), agents (`adversarial-reviewer`,
`design-reviewer`, `canon-reviewer`) and hooks (session start, path guard for edits and shell writes, format + lint). Project-specific
steps for a kit skill go in `.claude/godot-accel/<skill>.md` (`docs/customising.md`).
