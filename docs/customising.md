# Customising

Everything bootstrap writes is yours: edit it freely. The plugin's skills, agents and hooks update
with the plugin, so change their behaviour through your project files rather than editing the
plugin.

## Change a rule

Edit the file in `.claude/rules/`. To make a rule load only for some files, give it `paths:`:

```markdown
---
paths:
  - "scenes/levels/**/*.tscn"
---

# Level rules
- Every level has a `SpawnPoint` node.
```

A rule that must never be missed: add one line to CLAUDE.md "Hard rules" too.

## Protect more paths

Add globs to `.claude/protected-paths.txt` (one per line). `!` before a glob makes an exception,
for your own editor plugin for example:

```
addons/*
!addons/my_tools/*
assets/third_party/*
```

## Add a standing guard

Write two or three lines in `.claude/start-guard.md`: the one thing Claude must remember at the
start of every session (for example "read `docs/standards.md` before any visual work"). It is shown
after every start, `/clear` and compaction.

## Change budgets

Edit `.claude/budgets.md`. `trim-context` reads the table as written.

## Write a content recipe skill

Repeated content work (a level, an enemy, an NPC, a quest) is worth a project skill in
`.claude/skills/<name>/SKILL.md`. The shape that worked:

```markdown
---
name: new-enemy
description: Add an enemy end to end, from a short interview to a placed, tested enemy. Use for
  "add an enemy that…", "make a monster…".
argument-hint: "[the enemy and where it appears]"
---

Request: $ARGUMENTS

Read: `docs/systems/combat.md`, the enemy list in `docs/canon/bible.md`.

1. **Interview** (one question at a time, a recommendation each): concept, moves, where it appears.
   The user approves the concept before anything is built.
2. **canon-check** the name and lines.
3. **Data:** `resources/enemies/<id>.tres` (Resource, not code).
4. **Place** it in its level; record it in the system page.
5. **Art and sound:** a placeholder and a row in `docs/production/manifest.md`.
6. **Run** a fight to a win and a loss; logs clean. Then `save-work`.
```

*(This is an example. Your game's systems will differ.)*

The pattern: interview → canon/consistency check → data → place → asset row → run → save.

## A headless simulation against targets

For tuning-heavy systems (combat, economy), a headless scene that plays the system with bots on
fixed seeds and compares the numbers with targets recorded in a decision record pays off fast.
Rule: never tune just to make a number pass; a changed target needs a new decision.

## A "stamp" gate for things the user reviews

When some output (art, audio, a build) must pass a check before the user sees it, have the check
touch a stamp file (e.g. `.git/art-checked`) when it passes, and add a PreToolUse hook that refuses
to send any file changed after the stamp. That turns "always run the checks first" from a promise
into a rule.

## Desktop notification when Claude needs you

Add to `.claude/settings.json`:

```json
"hooks": {
  "Notification": [
    { "matcher": "permission_prompt|idle_prompt",
      "hooks": [{ "type": "command",
        "command": "notify-send 'Claude Code' 'Claude needs your input' 2>/dev/null || osascript -e 'display notification \"Claude needs your input\" with title \"Claude Code\"' 2>/dev/null || true" }] }
  ]
}
```

## A Godot editor MCP server

Run bootstrap with the server's name (or add later): it writes `.claude/rules/godot-mcp.md` and
`.claude/agents/playtester.md`, whose `tools:` line names the server. Pin the server's version in
`.mcp.json` so every machine runs the same one, and approve it per project with
`enabledMcpjsonServers` in `.claude/settings.json`.

## Turn something off

- A hook: disable the whole plugin for a project in `/plugin`, or copy what you want of it into
  your own settings and disable the plugin.
- A skill: it only runs when asked or matched; rules you don't want can be deleted from
  `.claude/rules/`.

## Testing changes

To try a modified copy of the kit:

```bash
claude --plugin-dir ./plugins/godot-accel
```

in a throwaway Godot project. After editing the plugin mid-session, run `/reload-plugins`.
