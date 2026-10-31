# {{GAME_NAME}}

{{PITCH}}

Built in **Godot {{GODOT_VERSION}} with {{LANGUAGE}}**. Current goal: {{CURRENT_GOAL}}.

## Pillars

What makes this game this game. Every design decision is checked against these.

1. {{PILLAR_1}}
2. …

## How this project is run

Each kind of fact has **one home**; everything else points at it.

| What | Where |
|---|---|
| Where work stopped, what's next, the only open-questions list | `docs/STATUS.md` (**read it first when resuming**) |
| The build order | `docs/plans/roadmap.md`; a feature's own plan in `docs/plans/YYYY-MM-DD-<topic>.md` |
| What each system does now | `docs/systems/<system>.md` |
| Why it is that way | `docs/decisions/` (index `README.md`; one `YYYY-MM-DD-<topic>.md` per topic) |
| Engine and tool quirks | `docs/guides/quirks.md` (read before debugging) |
| Rules for code, scenes, docs, git, working with the user | `.claude/rules/` |
| Working rules learned from the user | `.claude/memory/` (index below) |
| Another agent taking over | `AGENTS.md`, `docs/guides/llm-handoff.md` |
| The user's guide | `docs/guides/start-here.md`, `docs/guides/between-sessions.md` (keep them accurate) |
{{#CANON}}| Story, setting, characters, names, tone | `docs/canon/bible.md` (rules: `docs/canon/README.md`) |
{{/CANON}}{{#STANDARDS}}| Locked standards | `docs/standards.md` (a locked row beats any plan or STATUS line) |
{{/STANDARDS}}{{#MANIFEST}}| Every asset and its status | `docs/production/manifest.md` |
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

- **Commit only on the user's yes**, staged by path; then {{PUSH_POLICY}}
- **Never claim something works without running it.** Checks before the user sees anything,
  output quoted; show work neutrally, never call it good (`.claude/rules/showing-work.md`).
- **One question at a time**, each with a recommendation (`.claude/rules/working-with-user.md`).
- **Never paste or write API keys or tokens**; key commands go in a normal terminal.
{{#MCP}}- **Never work blind:** the `{{MCP_SERVER}}` tools must answer before any code, scene or
  gameplay step; if they don't, stop and fix it first (`.claude/rules/godot-mcp.md`).
{{/MCP}}{{#CANON}}- **Canon:** run `canon-check` before any new text or name; build sessions never edit the
  bible, they send request files (`docs/canon/README.md`).
{{/CANON}}{{#PAID}}- **Spend gate:** never spend paid credit without the user's OK on what it makes, the
  estimate and the balance (`.claude/rules/paid-tools.md`).
{{/PAID}}

## Project layout

{{LAYOUT}}

`tests/*_check.tscn` (headless checks) · `tools/` (`dev.sh`) · `docs/` · `inbox/` (drop box).

## Engine settings

{{ENGINE_SETTINGS}}

Autoloads: {{AUTOLOADS}}.

## Workflow

1. **New system → plan first** (`plan-feature`): scene tree, signals, data resources, and the
   user's OK before writing code. {{#GODOTPROMPTER}}Load the matching `godot-prompter:*` skill
   first and name the pattern picked and the one rejected.{{/GODOTPROMPTER}}
2. **Small steps.** After each: lint, `tools/dev.sh check`, {{RUN_STEP}}; fix every error.
3. **Save constantly** (`save-work`): after every finished task a task save (checks, plan tick,
   commit on yes, push); at session end or when switching machines a session save (plus STATUS
   and lessons via `trim-context`). Never end a session with uncommitted work unsaid.
4. Small commits with imperative messages.

## Commands

- `tools/dev.sh check` — refresh Godot's cache, run every headless check (exit 1 = a failure).
- `tools/dev.sh lint` — gdlint + gdformat on changed `.gd` files.
- `tools/dev.sh stale` — paths in the always-read docs that no longer exist.
- {{TEST_COMMAND}}
- `godot --path . -e` opens the editor; `godot --path .` runs the game.
