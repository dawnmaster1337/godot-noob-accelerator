# Lily Hop

A one-screen arcade game: a frog hops across lily pads that sink a moment after it lands.

Built in **Godot 4.4 with GDScript**. Current goal: a playable prototype.

## Pillars

1. One button, real decisions: when to hop matters more than where.
2. Every sink is readable before it happens.

## How this project is run

Each kind of fact has **one home**; everything else points at it.

| What | Where |
|---|---|
| Where work stopped, what's next, the only open-questions list | `docs/STATUS.md` (**read it first when resuming**) |
| The build order | `docs/plans/roadmap.md`; a feature's own plan in `docs/plans/YYYY-MM-DD-<topic>.md` |
| What each system does now | `docs/systems/<system>.md` |
| Why it is that way | `docs/decisions/` (index `README.md`) |
| Engine and tool quirks | `docs/guides/quirks.md` |
| Rules | `.claude/rules/` |
| Working rules learned from the user | `.claude/memory/` (index below) |
| The user's guide | `docs/guides/start-here.md` |

Read the relevant decision record before changing a system; never contradict it silently. When a
decision changes, grep `docs/` for the old claim and fix every copy. Check `inbox/` at the start
of a session.

@.claude/memory/MEMORY.md

## Hard rules

- **Commit only on the user's yes**, staged by path; then `git push`.
- **Never claim something works without running it.** Checks first, output quoted; show work
  neutrally, never call it good.
- **One question at a time**, each with a recommendation.
- **Never paste or write API keys or tokens.**
- **Hop timing values live in `resources/hop_tuning.tres`**, never in code (user, session 2).

## Project layout

`scenes/` (main, frog, pad) · `scripts/` · `resources/` (tuning) · `tests/*_check.tscn` ·
`tools/` (`dev.sh`) · `docs/` · `inbox/`.

## Engine settings

320×180 viewport, `viewport` stretch, integer scale, Compatibility renderer. Autoloads: `Score`.

## Workflow

1. **New system → plan first** (`plan-feature`) and the user's OK before code.
2. **Small steps.** After each: lint, `tools/dev.sh check`, one run of the game; fix every error.
3. **Save constantly** (`save-work`): task save after each task, session save at the end.
4. Small commits with imperative messages.

## Commands

- `tools/dev.sh check` · `tools/dev.sh lint` · `tools/dev.sh stale`
- `godot --path . -e` opens the editor; `godot --path .` runs the game.
