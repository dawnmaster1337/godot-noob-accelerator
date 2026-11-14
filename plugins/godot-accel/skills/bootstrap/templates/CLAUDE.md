# {{GAME_NAME}}

{{PITCH}}

Built in **Godot {{GODOT_VERSION}} with {{LANGUAGE}}**. Current goal: {{CURRENT_GOAL}}.

## Pillars

What makes this game this game. Every design decision is checked against these.

1. {{PILLAR_1}}
2. …

## How this project is run

Each kind of fact has **one home**; everything else points at it. The full list, with each
home's form, is `.claude/godot-accel/shape.md` (`tools/dev.sh conform` checks it). A home marked
*first use* there is made the first time the game needs it, from the kit's template of the same
path (the session-start card names the templates folder).

| What | Where |
|---|---|
| Where work stopped, what's next, the only open-questions list | `docs/STATUS.md` (**read it first when resuming**) |
| The build order, and the log of what landed when | `docs/plans/roadmap.md`; a feature's own plan in `docs/plans/YYYY-MM-DD-<topic>.md` |
| What each system does now | `docs/systems/<system>.md` (first use: the first system built) |
| Why it is that way | `docs/decisions/` (first use: the first decision; an index and one record per topic) |
| Engine and tool quirks | `docs/guides/quirks.md` (read before debugging) |
| Bugs known and not yet fixed | `docs/known-bugs.md` (check it before fixing a bug; update it with the fix) |
| What good looks like; what the project holds | `docs/research/` (first use; once it exists, name it in every subagent brief and plan) |
| Rules for code, scenes, docs, git, working with the user | `.claude/rules/` |
| Working rules learned from the user | `.claude/memory/` (index below) |
| Another agent taking over | `AGENTS.md` (first use: when another agent joins) |
| The user's guide | `docs/guides/start-here.md`, `docs/guides/between-sessions.md` (keep them accurate) |
{{#CANON}}
| Story, setting, characters, names, tone | `docs/canon/bible.md` (rules: `docs/canon/README.md`) |
{{/CANON}}
{{#STANDARDS}}
| Locked standards | `docs/standards.md` (a locked row beats any plan or STATUS line) |
{{/STANDARDS}}
{{#MANIFEST}}
| Every asset and its status | `docs/production/manifest.md` |
{{/MANIFEST}}

Read the relevant decision record before designing or changing a system; never contradict it
silently. When a decision changes, grep `docs/` for the old claim and fix every copy in the same
change. **Then check `inbox/`** (the user's drop box) at the start of a session and process it per
`inbox/README.md`.

Working rules learned from the user (save new ones here, one file each, format in
`.claude/memory/README.md`; not in Claude's own auto memory):

@.claude/memory/MEMORY.md

## Hard rules

The rules that must never be missed. A rule the user makes binding gets one line here too.

- **Commit only on the user's yes**, staged by path (the project's settings also make each commit
  prompt); then {{PUSH_POLICY}}
- **Never claim something works without running it.** Checks before the user sees anything,
  output quoted; show work neutrally, never call it good (`.claude/rules/showing-work.md`).
- **One question at a time**, each with a recommendation (`.claude/rules/working-with-user.md`).
- **Never paste or write API keys or tokens**; key commands go in a normal terminal.
- **The user's hand edits are theirs:** an uncommitted `.tres`, `.tscn` or tuning change you
  didn't make is never reverted; build on it and ask before changing a value they set
  (`.claude/rules/tuning.md`).
{{#MCP}}
- **Never work blind:** the `{{MCP_SERVER}}` tools must answer before any code, scene or
  gameplay step; if they don't, stop and fix it first (`.claude/rules/godot-mcp.md`).
{{/MCP}}
{{#CANON}}
- **Canon:** run `canon-check` before any new text or name; build sessions never edit the
  bible, they send request files (`docs/canon/README.md`).
{{/CANON}}
{{#PAID}}
- **Spend gate:** never spend paid credit without the user's OK on what it makes, the
  estimate and the balance (`.claude/rules/paid-tools.md`).
{{/PAID}}

## Workflow

1. **New system → plan first** (`plan-feature`): scene tree, signals, data resources, and the
   user's OK before writing code. {{#GODOTPROMPTER}}Load the matching `godot-prompter:*` skill
   first and name the pattern picked and the one rejected.{{/GODOTPROMPTER}}
2. **Small steps.** After each: lint, `tools/dev.sh check <name>` for the checks covering what
   you touched (its system page §4 names them), {{RUN_STEP}}; fix every error. Every check runs
   in `ship-check`, before a commit.
3. **A check proves it is used**, not only that it is right: data nothing reads passes every test
   and does nothing in the game. Assert the consumer (the scene that loads it, the system that
   reads the field).
4. **Save constantly** (`save-work`): after every finished task, and at session end. Never end a
   session with uncommitted work unsaid.
5. Small commits with imperative messages.

What the user says, and the kit's skill for it (`godot-accel:<name>`). Run it even when your
skill list shows the name without a description: with many plugins installed, Claude Code
drops descriptions.

| The user says | Skill |
|---|---|
| "resume", "continue", "what's next" | `resume` |
| wants something new: "I want to add…", "let's add…", "how should X work" | `plan-feature` |
| "save", "save work", "commit" · "wrap up", "I'm done" · "running out of usage" | `save-work` |
| "is it ready to commit?", "ship check" | `ship-check` |
| "trim", "lessons", worried about tokens | `trim-context` |
| "audit the project", "the repo is a mess" | `project-audit` |
| "update the kit" | `update` |
| needs art, a model, a sound, a shader or an addon | `godot-sourcing:find-assets`, when installed |
{{#CANON}}
| new dialogue, names or item text | `canon-check` |
{{/CANON}}

## Commands

- `tools/dev.sh check [name…]` — refresh Godot's cache if files changed, then run the headless
  checks in `tests/`: all, or only those named (exit 1 = a failure, or none ran). The smoke
  check loads every script, scene, resource and shader and plays the main scene; each system adds
  its own check.
- `tools/dev.sh lint` — gdlint + gdformat on changed `.gd` files.
- `tools/dev.sh stale` — paths in the live docs that no longer exist.
- `tools/dev.sh conform` — does the project match `.claude/godot-accel/shape.md` (homes, headings,
  task, bug and decision formats, no stray docs).
- `tools/dev.sh budget` — files over their `.claude/budgets.md` budget, lines over 400 characters.
- `tools/dev.sh tidy` — what has drifted: unsaved files, docs and code out of place, unused files.
- {{TEST_COMMAND}}
- `tools/dev.sh run [scene]` — the game (or one scene) headless for about ten seconds, its errors.
- `godot --path . -e` opens the editor; `godot --path .` runs the game in a window (for you).
