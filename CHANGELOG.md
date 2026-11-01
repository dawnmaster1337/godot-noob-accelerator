# Changelog

All notable changes. Versions follow the plugin's `version` in
`plugins/godot-accel/.claude-plugin/plugin.json`.

## Unreleased

## 0.1.1 — fixes

- Install instructions: the marketplace is named `godot-accel`, so the install line is
  `/plugin install godot-accel@godot-accel` (README, beginner's guide, plugin README).
- Git hooks no longer block beginners: the identity-guard checks run only on a machine that has
  `~/.config/identity-guard/` (or `IDENTITY_GUARD_DIR`). Lint, the secrets scan and the git-lfs
  handover run everywhere. `IDENTITY_GUARD_SKIP=1` no longer skips the project checks or the
  git-lfs handover. `commit-msg` now always chains to `commit-msg.project`.
- `pre-commit` honours `.identity-guard-allow`, as `pre-push` already did.
- Bootstrap makes all three hooks executable (git ignored `commit-msg` and `pre-push` before),
  asks to turn them on instead of offering "pre-commit check" as an extra, and its placeholders
  table is whole again. The docs now agree: `.githooks/` is always written, off until
  `core.hooksPath` is set. `.githooks/README.md` rewritten for any reader.
- `working-with-user.md` no longer lists trigger words that disagreed with `save-work`
  ("running out of usage" is a quick save); it points at the skills instead.
- The kit repo's `.githooks/` is now a copy of the template; CONTRIBUTING checks it.

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
