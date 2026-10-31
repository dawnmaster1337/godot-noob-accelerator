# Changelog

All notable changes. Versions follow the plugin's `version` in
`plugins/godot-accel/.claude-plugin/plugin.json`.

## Unreleased

## 0.1.0 — first release

- `bootstrap`: writes CLAUDE.md, AGENTS.md, `.claude/rules/`, `.claude/memory/`, the docs skeleton
  (STATUS, decisions, plans, systems, reviews, guides), `inbox/`, `tools/dev.sh`, an example
  check, git ignores; optional canon docs, standards page, asset manifest, pre-commit check,
  paid-tools rule and playtester agent. Never overwrites a file.
- Skills: `resume`, `plan-feature`, `ship-check`, `save-work` (task, session and quick saves; the
  "safe to /clear" line), `trim-context`, `workflow-audit`, `canon-check`, `harvest-learnings`.
- Agents: `adversarial-reviewer`, `design-reviewer`, `canon-reviewer`.
- Hooks: session-start card, path guard, GDScript format + lint.
- Docs: beginner's guide, how it works, structure, customising.
