---
name: bootstrap
description: Set up a new Godot 4 project to be run with this kit — writes CLAUDE.md, .claude/rules, project memory, the docs skeleton (STATUS, decisions, plans, systems, guides), the inbox, a check runner and git ignores, after a few questions. Never overwrites an existing file; a project that already has its own docs goes to realign. Run it once per project, by typing it.
argument-hint: "[optional: the game's name and a one-line pitch]"
disable-model-invocation: true
allowed-tools: Read Glob Grep Bash(ls *) Bash(grep *) Bash(echo *) Bash(git status *) Bash(git rev-parse *) Bash(godot --version)
---

Request: $ARGUMENTS

## What is here

!`ls -A`

!`grep -E '^config/(name|features)=|^[A-Za-z_]+="\*?res://' project.godot 2>/dev/null || echo "NO project.godot in this folder"`

!`ls -A .claude docs addons 2>/dev/null; ls *.csproj .mcp.json CLAUDE.md AGENTS.md .gitignore 2>/dev/null; git rev-parse --is-inside-work-tree 2>/dev/null || echo "not a git repo"`

Templates: `${CLAUDE_SKILL_DIR}/templates/`. In there `dot-claude/` means `.claude/`,
`dot-githooks/` means `.githooks/`, and `*.snippet` files are appended, not copied.

## Rules for this skill

- **Never overwrite an existing file.** If a target exists: show the user a short diff (what the
  kit would add), then ask: **keep mine** (recommended for files they wrote), **append** the kit's
  version as a delimited section (`<!-- >>> godot-accel >>> -->` … `<!-- <<< … <<< -->`),
  or **replace** (only if they say so in words). `.gitignore` / `.gitattributes`: append the
  snippet only if its `>>> {{KIT_NAME}} >>>` marker is absent.
- The user may be new to all of this: plain words, one question at a time, each with a
  recommendation they can take with "APR" (as per recommendation).
- Write nothing until the user has said yes to the file list (step 3).

## Steps

0. **Is it a Godot project?** No `project.godot` → say so plainly and stop. Tell a beginner how
   to make one (open Godot → **Create** a new project in this folder → close Godot → run this
   again); the kit's beginner's guide walks through it: https://github.com/dawnmaster1337/godot-noob-accelerator/blob/main/docs/beginners-guide.md
   Already set up (`.claude/budgets.md` exists) → say so and use `update` instead; stop.
1. **Read what exists:** Godot version (`config/features`), autoloads, top-level folders,
   `.csproj` (C#), test addons (`addons/gut`, `addons/gdUnit4`), `.mcp.json` servers, existing
   CLAUDE.md / `.claude/` / `docs/`, and the project's own docs that already do a kit file's job
   (a status or to-do file, design notes, a bug list, rules). Say in three lines what you found. Project hooks named like
   the kit's (`guard-paths.sh`, `gd-format-lint.sh`…): the kit's copies stand down; say so.
   **The project has its own docs** beyond a README or a short CLAUDE.md (any status, to-do,
   plan, log, hand-off, bug, quirk or rules file) → this is a job for `realign`, which moves their
   content into the kit's homes instead of writing a second copy beside them. Say so and stop.
2. **Ask, one at a time** (skip any the request or step 1 already answers; ≤ 8):
   1. The game's name (default: `config/name`).
   2. One line: what is the game? (genre, the hook).
   3. Language: GDScript (recommended unless a `.csproj` exists) / C# / both.
   4. Tests: **plain check scenes** (recommended: no addon; `tools/dev.sh check` runs them) /
      GUT / gdUnit4 (recommend whichever addon is already installed).
   5. Does the game have a story or world to keep consistent (characters, places, names)?
      Yes → the canon docs and `canon-check`. Recommend yes for story games, no otherwise.
   6. Do you use a Godot editor MCP server (lets Claude run and see the game)? Name it, or none.
      Recommend none for beginners unless `.mcp.json` already has one.
   7. How new are you to coding and git? **New** (recommended if unsure: extra plain-words
      explanations, `docs/guides/start-here.md` gets pointed at often) / experienced.
   8. Extras (multi-pick, recommendations marked): Claude pushes after each commit you approve
      (rec) · asset manifest (rec) · standards page · paid-tools
      spend gate (only if you'll use paid image/sound generators).
3. **Show the file list** (create / append / exists-ask) from the map below and get a yes.
4. **Write** each file: copy, fill the placeholders, keep or delete each `{{#X}}…{{/X}}` block
   (keep the inside when X is on; remove the markers either way). Leave no `{{…}}` behind except
   in `docs/` example rows. The filled CLAUDE.md must stay under 200 lines and 8,000 characters.
   Write the plugin's version (`${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`) into
   `.claude/godot-accel/kit-version`, so `update` and the session-start card know it.
5. **Finish the setup** (ask before each): `chmod +x tools/dev.sh .githooks/pre-commit
   .githooks/commit-msg .githooks/pre-push` (git ignores a hook that isn't executable);
   `git init` if not a repo; turn on the git checks with `git config core.hooksPath .githooks`
   (recommended; "Git hooks" below); merge
   `dot-claude/settings.suggested.json` into `.claude/settings.json` (show the diff; never drop
   their keys); write `autoMemoryDirectory` = the absolute path of `.claude/memory` into
   `.claude/settings.local.json` (per machine, git-ignored; makes Claude's own memory land in the
   repo folder too).
6. **Prove it:** `tools/dev.sh check` (plain checks: the example check passes), `tools/dev.sh
   lint all`, `stale` (no dead paths), `conform` (matches the shape) and `budget`. Quote the outputs. All pass → tick roadmap
   task 0.0 (green baseline). Godot not on PATH → say so and point
   at `docs/guides/setup-new-machine.md`.
7. **Summary** (short): what was created or appended, what was skipped and why, then next steps:
   read `docs/guides/start-here.md`; say **save work** to commit this setup; describe the first
   thing to build (it starts `plan-feature`). If GodotPrompter's skills aren't in your skill list,
   recommend installing it (kit README, "Companions").

## File map

| Template | Target | When |
|---|---|---|
| `CLAUDE.md`, `AGENTS.md` | same | always |
| `dot-claude/rules/working-with-user.md`, `git.md`, `showing-work.md`, `docs.md`, `scenes.md`, `tuning.md` | `.claude/rules/` | always |
| `dot-claude/rules/gdscript.md` / `csharp.md` | `.claude/rules/` | by language (both: both) |
| `dot-claude/rules/godot-mcp.md`, `dot-claude/agents/playtester.md` | `.claude/…` | MCP named |
| `dot-claude/rules/paid-tools.md` | `.claude/rules/` | spend gate picked |
| `dot-claude/memory/*`, `budgets.md`, `protected-paths.txt`, `start-guard.md`, `reminder.md` | `.claude/` | always (`start-guard.md` empty unless standards picked) |
| `dot-claude/godot-accel/shape.md` | `.claude/godot-accel/` | always (its canon, standards and manifest rows only if picked) |
| `docs/STATUS.md`, `known-bugs.md`, `decisions/*`, `plans/*`, `systems/_template.md`, `research/`, `reviews/`, `archive/`, `guides/*` | `docs/` | always |
| `docs/canon/**` | `docs/canon/` | canon yes |
| `docs/standards.md`, `docs/production/manifest.md` | `docs/` | if picked |
| `inbox/README.md`, `inbox/.gdignore` | `inbox/` | always |
| `tools/dev.sh` | `tools/` | always |
| `tests/example_check.gd`, `.tscn` | `tests/` | plain check scenes |
| `dot-githooks/pre-commit`, `commit-msg`, `pre-push`, `lib.sh`, `README.md` | `.githooks/` | always |
| `gitignore.snippet`, `gitattributes.snippet` | append to `.gitignore`, `.gitattributes` | always (C# lines only for C#) |

## Placeholders

| Placeholder | Value |
|---|---|
| `{{KIT_NAME}}` | `godot-accel` (plugin and marketplace name) |
| `{{KIT_REPO}}` | `godot-noob-accelerator` (the GitHub repo name) |
| `{{GAME_NAME}}`, `{{PITCH}}` | answers 1, 2 |
| `{{GODOT_VERSION}}` | from `config/features` (e.g. `4.4`) |
| `{{LANGUAGE}}` | GDScript / C# / GDScript and C# |
| `{{CURRENT_GOAL}}` | "a playable prototype" unless the user said otherwise |
| `{{PILLAR_1}}` | ask nothing: write "*to be agreed in the first planning session*" |
| `{{DATE}}` | today, `YYYY-MM-DD` |
| `{{PUSH_POLICY}}` | push on: "`git push`." · off: "the user pushes (`git push`) when they want." |
| `{{MCP_SERVER}}` | the server name (`#MCP` on) |
| `{{RUN_STEP}}` | MCP: "one live run through `{{MCP_SERVER}}` (run, then read the game and editor logs)"; else "one run of the game (`godot --path .`), reading its output" |
| `{{TEST_COMMAND}}` | checks: "`tools/dev.sh check <name>` runs one check"; GUT: "`godot --headless --path . -s addons/gut/gut_cmdln.gd -gexit` runs the GUT tests (`-gselect=<file>` only one file)"; gdUnit4: "`addons/gdUnit4/runtest.sh -a res://tests` runs the gdUnit4 tests" |
| `{{LAYOUT}}` | the real top-level folders, one line each (`scenes/` …); invent none |
| `{{ENGINE_SETTINGS}}` | viewport size, stretch mode, renderer from `project.godot`, one line each |
| `{{AUTOLOADS}}` | names from `[autoload]`, or "none yet" |
| `{{CANON_READ_LINE}}` | canon on: "7. Before any text or name: `docs/canon/bible.md` (`canon-check`)."; else delete the line |
| `{{BEGINNER_LINE}}` | new: "The user is new to coding and git: explain each step, point at `docs/guides/start-here.md`."; else delete the line |
| `{{MEMORY_LINK_STEP}}` | "Optional, per machine: set `autoMemoryDirectory` in `.claude/settings.local.json` to its absolute path." |
| `{{MCP_SETUP_STEP}}` | MCP on: "4. The `{{MCP_SERVER}}` MCP server: see its own install guide; check it with `/mcp`."; else delete |
| `{{#GODOTPROMPTER}}` | on when `godot-prompter:*` skills are available to you |

## Git hooks

`.githooks/` is always written and does nothing until step 5 turns it on. Every machine gets the
project checks (GDScript lint, `.godot/`, `.env`, key shapes; the git-lfs handover on push). The
identity checks (commit email, real-identity strings) run only where
`~/.config/identity-guard/` exists, so a beginner's normal email is never blocked. Tell the user
`core.hooksPath` is per clone (`docs/guides/setup-new-machine.md` repeats it); details in
`.githooks/README.md`.
