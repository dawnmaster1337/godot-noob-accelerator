# Changelog

All notable changes. Versions follow the plugin's `version` in
`plugins/godot-accel/.claude-plugin/plugin.json`.

## Unreleased

## 0.2.0 — tuning, bugs, budgets, one task per session

From a second project's handover (a game that reached the same process on its own):

- **Tuning and hand edits:** new rule `tuning.md` (feel values in `Tuning` Resources; change the
  `.tres` preset, not only the script default; the user's uncommitted edits are theirs), a hard
  rule in CLAUDE.md, and the session-start card lists uncommitted `.tres`/`.tscn` files. System
  pages say where each value lives (file, Inspector group, safe range).
- **Bug log:** `docs/known-bugs.md` (Open with repro; Fixed with cause → fix). `resume` sends
  inbox bugs there, `ship-check` updates it, `harvest-learnings` reads it.
- **Budgets enforced:** `tools/dev.sh budget` checks `.claude/budgets.md` and the 400-character
  line limit; `trim-context` and every save run it; the session-start card warns when STATUS is
  over. STATUS template: no session logs.
- **Cheaper checks:** `tools/dev.sh check` refreshes Godot's cache only when files changed
  (`--refresh` forces it); after each small step only the checks covering what changed run, every
  check still runs in `ship-check`.
- **One task per session:** roadmap tasks are sized S/M/L with a "Done when" line; task 0.0 is a
  green baseline that bootstrap ticks; `resume` proposes one task.
- **Playtests:** feel feedback becomes a tuning change first; bundled requests are built one piece
  at a time; `ship-check` ends with "To try:"; system pages carry a playtest checklist.
- **Layout styles:** `gdscript.md` names `features/<name>/` + an events autoload as the
  alternative for games with many mechanics, and a ~300-line script limit; the first plan picks.
- Four new evals, built from the real templates (`evals/lib/kit-project.sh`); run with
  `--scaffold`.
- Fixed: the `docs.md` rule's example path made `tools/dev.sh stale` report a dead path in every
  new project.

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
