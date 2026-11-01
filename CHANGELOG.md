# Changelog

All notable changes. Versions follow the plugin's `version` in
`plugins/godot-accel/.claude-plugin/plugin.json`.

## Unreleased

## 0.3.0 — catch-up for existing projects, safer hooks, a GitHub-ready README

- **New `update` skill** ("update the kit"): brings a project set up with an older kit up to
  date. Adds new template files, merges new kit lines into files the user edited without
  replacing their wording, re-runs the checks, records the version.
- **Version stamp and nudge:** bootstrap writes `.claude/godot-accel/kit-version`; the
  session-start card says when the project is behind the plugin (or the plugin behind the
  project), and `resume` passes it on.
- **`project-audit` replaces `workflow-audit`** ("audit the project", "is the repo tidy?"): one
  health check for the repo, the code, the docs and the rules. The new `tools/dev.sh tidy` lists
  the mechanical drift for it: files not in git, docs outside `docs/`, code outside the folders
  CLAUDE.md names, scripts and scenes nothing uses, scripts over 300 lines, finished plans,
  duplicate `class_name`s.
- **Leaner templates:** `docs/guides/llm-handoff.md` merged into `AGENTS.md`; rules no longer
  repeat what CLAUDE.md, a skill or another rule already says; STATUS lost two pointer sections.
- **Bootstrap adopts a project's own docs:** an existing status file, design notes or bug list is
  used in the kit's place instead of getting a parallel copy; an already set-up project is sent to
  `update`.

From three projects' harvested learnings:

- **Hooks cover shell edits.** A new `guard-bash.sh` blocks writes to Godot's cache, `*.import`,
  `*.uid`, `.env` and protected paths made through `>`, `tee` or `sed -i`/`perl -i`; the format +
  lint hook now also checks `.gd` files a shell command changed.
- **Wrong start folder is reported.** Started one folder above or below a kit project, the
  session-start card says where the project is, instead of every hook going quiet.
- **No more doubled hooks.** A kit hook stands down when the project registers its own script of
  the same name.
- **Customise a kit skill without forking it:** `.claude/godot-accel/<skill>.md` adds project
  steps to `resume`, `save-work`, `ship-check` and `trim-context`; `project-audit` reports forks.
- **Checks that can't run say so:** `trim-context` reports a missing `tools/dev.sh` instead of
  passing quietly.
- **Budgets never delete protected content:** over budget with only canon, decisions, open
  questions or live quirks left, `trim-context` stops and makes it a task.
- **Reviewer handles committed work:** `adversarial-reviewer` takes a branch or commit range, and
  `ship-check` passes the milestone's range.
- **Rules:** prove a new check by reverting its fix; a check failing before your change is logged,
  not hidden; cheapest preview first; steps for the user go in the last message; "Repository not
  found" on push means the wrong account, never switch accounts unasked; docs that mirror code are
  generated; a refactor plan proves its premise; a decision whose reason proved false is marked,
  not rewritten.
- **Quirks seeded:** `pgrep -f`/`pkill -f` matching their own shell; a one-off push as another
  `gh` account.
- **Docs:** README and beginner's guide rewritten (checks after each step, the right start
  folder, a session example, a flow diagram); `customising.md` covers project steps, keeping
  `tools/dev.sh` and your own hooks.

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
