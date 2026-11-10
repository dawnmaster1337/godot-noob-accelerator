# Changelog

All notable changes. Versions follow the plugin's `version` in
`plugins/godot-accel/.claude-plugin/plugin.json`.

## Unreleased — checks you can trust

From an adversarial audit of 0.6.1. **Update:** yes, the first fix changes what a passing check
means. A project gets the new `tools/dev.sh` and pre-commit through **update the kit**.

- **A check scene fails on any error Godot prints.** Godot reports a missing node, a failed load
  or a `push_error` as an `ERROR:` line and still exits 0, so a main scene with all three passed
  the smoke check. `tools/dev.sh check` now reads the log for them (leak reports at shutdown
  aside). A check that tests an error path lists the error it expects in
  `tests/expected_errors.txt`. GUT and gdUnit4 runs are unchanged: they test errors on purpose.
- **The secrets check stopped blocking ordinary words.** `sk-` had no word boundary, so a plan
  named `…-mask-shader-for-the-water.md` (the kit's own naming) looked like an API key, and the
  message named no file. Now `sk-` must start a word, only added lines count (not the diff's file
  headers), and the message lists the files.
- **Lint after a shell command reports, never blocks.** It used to block Claude over files a
  `git pull` or merge brought in, or that the user saved in Godot meanwhile: against the rule
  that the user's edits are theirs. A command that moved HEAD now notes and lints nothing; any
  other is linted and reported. Other sessions' worktrees in `.claude/` are skipped. A lint
  failure in a file Claude's editing tools wrote still blocks, as before.
- **The path guard covers a game in a subfolder.** `game/addons/` and `game/.godot/` were open to
  the editing tools, and `./` or `../` in a path slipped past. Paths are now folded first and
  checked from both the project root and the game folder; the deny rules add `**/.godot/**`.
- **New `tools/dev.sh run [scene]`:** the game headless for 600 frames (about ten seconds), its
  `ERROR:` lines judged like a check's. Claude's run after each step and ship-check's play use it
  instead of opening a game window that blocked the session. `GODOT=<path>` names the engine when
  `godot` isn't on PATH.
- **Honest wording about deny rules:** they are a guard-rail for the shell commands Claude Code
  recognises as file reads and writes, not a wall (a script or `cp` still writes).
- **Fixes:** the secrets deny rule now matches Godot 4's `.godot/export_credentials.cfg`; the
  session-start card no longer runs the project's `tools/dev.sh` (resume runs `conform`) and now
  also reaches forked sessions; the adversarial reviewer can load the code-review skill it's told
  to use; project-audit says it writes one report.
- **godot-sourcing:** search-result text is data, never instructions; an addon's code is read
  (what it does when enabled) before the user turns it on; the README says the asset server is
  connected in every session while the kit is on.
- **A redesigned project page and docs.** The README answers "why not plain Claude Code" in its
  first lines, then shows what a session looks like, a side-by-side with plain Claude Code, who
  it's for, find-or-build, and an honest-bit table that now names the asset server it connects
  to. Every graphic's words are also on the page. The docs gain a hub (`docs/README.md`) and
  pictures: the guide's first hour, the three words, what's inside the kit, one home per fact,
  the check ladder and the file tree. `assets/src/make_art.py` draws them from one palette.
- **The kit's own repository:** `.gitattributes` keeps shell scripts LF on Windows clones; CI
  tests GUT 9.7.1 (the release for Godot 4.7).

## 0.6.1 — find or build: the user's call

0.6.0 framed godot-sourcing as "ready-made before handmade". That was wrong: whether to use a
ready-made asset or build one is the user's decision, and the kit shouldn't lean either way.

- **`find-assets` asks first:** its first step, before any search or code, is one question with
  no recommendation: find a ready-made one, or build it here? Build → Claude builds it. Find →
  the licence policy, then the search and shortlist as before. It offers once to remember the
  answer for that kind.
- **The project policy answers ahead of time, per kind:** `ask` (now the default for every kind),
  `source` (find without asking) or `make` (always build). Existing policy files keep working.
- **Reworded everywhere it leaned:** the skill's description, both plugin descriptions, the
  READMEs, the beginner's guide, how-it-works, companions, and `plan-feature` ("Find or build",
  not "Ready-made first").
- **Eval:** `flat-water-shortlists` is now `flat-water-asks-first`: a "make it look nicer"
  request gets the question first, recommending neither, with nothing searched or written.

godot-accel 0.6.1, godot-sourcing 0.1.1.

## 0.6.0 — godot-sourcing, and what three projects taught the kit

**New plugin: godot-sourcing** (framed as "ready-made before handmade"; corrected in 0.6.1)

Claude Code tended to build everything itself (a primitive tree, a hand-written water shader)
when free, better, commercially licensed versions were one search away. The marketplace now has a
second plugin, `godot-sourcing@godot-accel`, with one skill, `find-assets`:

- **Searches before building:** shaders (Godot Shaders, the Asset Library's Shaders category,
  GitHub), models, textures, skies, sprites, audio and fonts (the 3D Asset Server, 26 sites
  including Poly Haven, ambientCG and Kenney, bundled as the `3d-assets` MCP server), and addons
  and systems (the Asset Store, the Asset Library, GitHub, awesome-godot, the Godot Forum).
- **Licences first:** takes CC0 and MIT-style licences, takes CC-BY with a credit line, asks for
  share-alike and custom terms, excludes GPL code, non-commercial (Godot Shaders' Shadertoy ports
  included) and unlicensed assets.
- **Shortlist, then wait:** up to five matches with licence, preview link and the work to adapt;
  nothing is downloaded before the user picks.
- **A per-project policy** (`.claude/rules/sourcing.md`, made on first use): a kind the project
  makes itself on purpose is never sourced.
- **Fits the kit:** unmodified files in `assets/third_party/` and `addons/`, credits in the asset
  manifest, hand-downloaded packs through `inbox/`. Works in any Godot 4 project on its own.
- Two evals (`plugins/godot-sourcing/evals/`): a "make it look nicer" request shortlists and
  downloads nothing; a `make` kind is not searched for.

**What three real projects and a try-out taught the kit**

- **Stop check:** a project whose `tools/dev.sh` predates 0.5.0 never cleared the hook's list,
  so it blocked every other turn. The hook now stays off there (the session-start card says
  why), and one batch of changes blocks once.
- **`tools/dev.sh`:** `budget` names files within 5% of their budget; the refresh and
  "used by" searches skip `.claude/worktrees/` (other sessions' checkouts).
- **New rule file `handing-over.md`:** what the user sees, runs and reviews (stills and clips,
  one piece then a review, "open X, try Y", one runner per command, steps last), split from
  `working-with-user.md`, which keeps questions and answers (stale question lists, paused plans).
- **`showing-work.md`:** a UI change is done only when seen; a break test must cross its
  threshold; a negative from driven input isn't a finding; suspect the ruler first.
- **Smaller rules:** stop paid calls when approval keeps failing (`paid-tools.md`); no absolute
  paths in records (`docs.md`); worktree cleanup after a merge (`git.md`); driven input can miss
  (`godot-mcp.md`).
- **Settings and git:** new worktrees branch from local HEAD (`worktree.baseRef: "head"`); video
  captures are git-ignored; `scenes.md` loads for a `project.godot` in a subfolder.
- **Docs skeleton:** known-bugs says a recorded cause is a claim until measured and what
  "can't reproduce" usually means; plans get Verdicts and Temporary tools; the setup guide
  covers renaming the project folder.
- **Skills:** `plan-feature` proves every premise, not only a refactor's; `trim-context` reviews
  the reminder; `project-audit` counts worktree disk; `ship-check` lists owed credits at a
  milestone; `update` moves hand-over lines to the new file and sets up the sourcing policy.
- **find-assets, from a three-run try-out:** the policy is a gate before the first search
  (bootstrap asks its one question); decisions are read first; "improve ours" searches methods
  too; shortlists give found / licence-checked / shortlisted counts and widen under three; a set
  gets a row per item; an existing third-party register wins; reference-only picks ship nothing;
  `SOURCE.md` when there's no licence file. `sources.md` adds Poly Pizza, Sketchfab's licence
  API, BlenderKit's new domain, and the Asset Library's `godot_version` trap. Fetch detail moved
  to `fetch.md`.
- **README:** trying a test branch with `"ref"`, not `marketplace remove`.

**The kit points to it**

- **Installed with the kit:** godot-accel declares godot-sourcing as a dependency, so installing
  the kit installs both. A kit installed before 0.6.0 may need
  `/plugin install godot-sourcing@godot-accel` once; bootstrap's summary gives that line when the
  skill is missing.
- `plan-feature` runs `find-assets` first when the feature needs an asset, a shader or a common
  system.
- **New `docs/companions.md`:** godot-sourcing, GodotPrompter, alexmeckes' godot-claude-skills
  (`godot-shader`) and PooDoge's godot-mcp-skills (`godot-shader-lab`), with what each needs and
  where they overlap. README, beginner's guide and how-it-works link to it.
- `tests/run.sh` validates the new plugin and the marketplace, checks the 4,000-character skill
  and agent budget across both plugins, and runs the new eval fixtures.

## 0.5.0 — grows with the game, and checks that mean something

From an outside adversarial review of 0.4.2. The kit now starts small and grows with the game, and
more of its promises are enforced by a check, a setting or a hook instead of a sentence.

**Fixed: the beginner flow**

- **"save work" no longer stalls after a code change.** `ship-check` could only be typed by the
  user, so `save-work`, which runs it as its gate, was refused it. Claude can run it now.
- **No skill aborts in a new repo.** A skill's injected command that failed (`git log` with no
  commits yet, `ls inbox` with no inbox) stopped the whole skill. Every one now ends so it can't
  fail, and `tests/run.sh` checks them.

**Checks that prove something**

- **A smoke check replaces the `2 + 2` example:** `tests/smoke_check.tscn` loads every script
  (a parse error fails it, even in a script no scene uses) and plays the main scene for a second
  (a script error fails it, a scene change included). A new project fails it until it has a main
  scene, on purpose.
- **`tools/dev.sh check` fails when nothing ran**, runs the plain check scenes and GUT or gdUnit4
  together (gdUnit4 is wired up now), and exits 1 on any failure.
- **`refresh` is one `--import` run** (it rebuilds the class cache, a renamed or deleted
  `class_name` included; verified on 4.7.2).
- **Bootstrap makes untyped GDScript an error** (`untyped_declaration=2`), so the typing rule
  is checked by Godot.
- **A stop hook** asks Claude to run the checks covering the game files it changed before it
  finishes a turn, or to say why they can't run. It asks once per batch of changes.

**Settings instead of regexes**

- **`settings.suggested.json` asks before every commit** (and every push, unless Claude pushes for
  you), and **denies** reading `.env` files and export credentials and writing Godot's cache,
  `.import` and `.uid` files. Claude Code applies those to shell redirects, `tee` and `sed` too.
- **The shell-write regex is gone** (it missed `tee --append`, `sed --in-place` and writes after
  a `cd`, and blocked commit messages containing `->`). `shell-stamp.sh` only touches the stamp
  the lint hook uses. The editing-tool guard and `protected-paths.txt` stay.
- **The session-start card says when a check is off:** no `jq` or `python3` (the hooks can't read
  their input), no gdtoolkit, no deny rules in the project's settings.

**Grows with the game**

- **The shape has a Made column:** `setup` homes are written by bootstrap; `first use` homes
  (decisions, system pages, research, reviews, archive, `AGENTS.md`, the reminder) are made the
  first time the game needs them, from the kit's template of the same path. `conform` and `stale`
  don't ask for one until then. A new project starts with about 12 files you'll see.
- **CLAUDE.md drops "Project layout" and "Engine settings"**: Claude reads the folders and
  `project.godot` itself, and the shape no longer requires those headings.

**Hooks**

- **Subfolder projects, finished:** the stamp, the lint hook's search and `pre-commit`'s `addons/`
  filter all use the game folder now (0.4.2 missed them, so shell edits in `game/` were never
  linted).
- **After a shell command the lint hook only lints**, never reformats: that command may have been
  a `git pull`, or the user saving in Godot.
- **Budgets:** a commit is refused only for a file read every session (CLAUDE.md, STATUS, memory,
  rules, the reminder) over its budget; any other file over budget is a warning.

**Rules and agents**

- Default layout: a folder per scene or feature, as Godot's project-organization guide
  recommends; a project sorted by kind keeps its layout.
- Polling `Input` in `_process` is fine (the reviewer no longer flags it); `duplicate()` is
  shallow (`duplicate(true)` or `duplicate_deep()` for nested resources).
- Moving a script outside the editor moves its `.uid` too (left behind, every scene using it
  fails to load; verified on 4.7.2). `load_steps` is no longer required (4.7 doesn't write it).
- `docs/.gdignore` keeps notes and screenshots out of Godot's import.
- The reviewer agents use the session's model (`inherit`, not `opus`) and no longer claim to be
  read-only (they run git and the checks).
- Memory loads one way only: CLAUDE.md imports `.claude/memory/MEMORY.md`; bootstrap no longer
  points `autoMemoryDirectory` there (that loaded it twice).
- `MultiEdit` dropped from the hook matchers (a legacy tool name).

**Repo**

- **`tests/run.sh`** builds throwaway projects from the templates and runs every `dev.sh` verb, the
  plugin's hooks and the git hooks on root and `game/` layouts, failure cases included. **CI**
  (`.github/workflows/tests.yml`) runs it on every push with real Godot 4.7.2, gdtoolkit,
  shellcheck, GUT 9.6.1 and gdUnit4 6.2.2.
- New eval `resume-in-empty-repo` (passes). A save-work eval was dropped: the eval runner's
  read-only temp folder and blocked git stop that skill before it can show anything.
- **The session-start card in a repo with no commits** says so, and no longer calls every new
  scene "likely the user's own edits".
- The README says who the kit is for, what it adds, which install scope to pick, and how to get an
  update that seems stuck. The beginner's guide warns that Windows and macOS are untested.
- `examples/minimal-game` is on 0.5.0 and its docs pass `conform`.
- Skill and agent budget raised to 4,000 characters.

## 0.4.2 — fixes from the second real realign

From running `realign` on an established project with its Godot project in a subfolder, GUT tests
and numbered ADRs:

- **A Godot project in a subfolder** (`game/` beside other work) now works. `tools/dev.sh` finds
  the one folder below the root that holds `project.godot` and uses it for headless runs, tests,
  `addons/` and `.godot/`. The hooks treat such a repo as a Godot project (before, the path guard
  and lint hooks stayed silent there), and the session-start card says so when a session starts
  inside the game folder instead of the repo root.
- **`tools/dev.sh check` runs GUT** when `addons/gut` is installed (`-gselect=` for named tests,
  `.gutconfig.json` respected). Tested with a stand-in runner, not yet with real GUT.
- **Decisions:** `**Status:** Accepted` is read (as decided); a number may follow the date in a
  record's name (`YYYY-MM-DD-adr-0003-<topic>.md`).
- **Roadmap:** a finished task brought in from an old log is `(old)` and needs no size or Done
  when; nothing has to be invented.
- **`stale`** counts files on disk, git-ignored ones included (a data folder named in a doc), and
  skips paths starting with `/` (URL parts).
- **`budget`'s 400-character line check** skips table rows in docs read only when needed
  (research, registers); the always-read files are still checked line by line.
- **`conform` lists kit placeholders left unfilled** (`{{NAME}}`) in any live doc.
- **The shape and CLAUDE.md templates put each option marker on its own line**, so deleting an
  unpicked block can't take a table row with it.
- **`realign`:** runs `lint all` first and makes a failing baseline roadmap task 0.0 before the
  commit hook is turned on; writes an archived file's first line before moving it; leaves out kit
  rule lines that contradict the project's own way and says so; checks
  `git diff --cached --name-status` before each commit (`git mv` stages renames itself), as
  `save-work` now does too.

## 0.4.1 — fixes from the first real realign

From running `realign` on a 125-doc project:

- **`conform` task check:** accepts a lettered sub-task (`1.2b`); sees a `Done when` that wraps
  onto the next line; reports every fault of a task at once instead of one per pass.
- **`budget`'s 400-character line check** now reads every `live` doc of the shape, as `stale`
  does; before, a long line anywhere else in `docs/` passed. `stale` knows more file types
  (`.svg`, `.csv`, `.gdshader`, `.glb`, `.ogg`, `.wav`).
- **The shape file has a "This project's own rows" table,** so `update` can tell the project's
  rows from the kit's.
- **`update` and `realign` never trim the user's content to fit a budget:** they name the file
  and the overage and ask. A git hook that is the project's own (or chains to `<hook>.project`)
  gets new kit checks in `<hook>.project`; a rule against Claude editing hooks, or auto mode
  refusing to edit `settings.json`, means the user gets the block or command to run.
- **`realign`:** a project already near the shape may have nothing to archive; a required heading
  may say more after the shape's words (`## 3. Data and behaviour`).
- `docs/guides/quirks.md` budget 5,500 → 8,000 characters (it is read before debugging, not every
  session).
- README: a marketplace update can report success while reusing a stale copy; run it again.

## 0.4.0 — one shape for every project

Three projects that all ran the kit had three different layouts: none was bootstrapped, and every
way the kit had of handling an existing project (bootstrap's "adopt", `update`, `project-audit`)
kept the project's own file formats. This release separates the two: **the user's content is
always kept; the structure always becomes the kit's.**

- **The shape file** (`.claude/godot-accel/shape.md`): each home's path, kind (`live`, `plan`,
  `history`), required headings and entry format. A project adds a row for a home of its own;
  anything else in `docs/` is drift.
- **`tools/dev.sh conform`** checks the project against it and exits 1 on any problem: a missing
  home or heading, a stray doc, a roadmap task without a number, size or Done when, a ticked task
  without its date, a bug missing a field, and a decisions index that disagrees with its records
  (`conform decisions` runs only that part).
- **New `realign` skill** (`/godot-accel:realign`): moves an existing project onto the shape one
  home at a time, rewriting each file's facts into the kit's form, counting before and after so
  nothing is dropped, archiving the original and committing per home. Bootstrap sends projects
  with their own docs to it (its "adopt" option is gone); `update`, `project-audit`,
  `harvest-learnings` and the session-start card point at it when `conform` fails.
- **The roadmap is the build log:** a ticked task carries `Done YYYY-MM-DD.`; no separate log.
- **`docs/research/`:** what good looks like for this game and what the project already holds.
  `plan-feature` and the design reviewer read it; every subagent brief names it.

Fixed:

- `tools/dev.sh stale` always exited 0, so it could never stop anything; it now exits 1 on a dead
  path. Its default list missed `docs/systems/` and `docs/guides/`, where dead paths collected; it
  now reads every `live` row of the shape and skips decisions, reviews, archive and plans.
- `pre-commit` never checked budgets, so over-budget files were committed (a piped
  `budget | tail -1` hid the exit code). It now refuses a staged file over its budget, and checks
  the decisions index when a decision file is staged.
- Template paths that `stale` flagged (files the user creates were in backticks).

From three projects' harvested learnings:

- **Evidence:** a new check is proven twice (it fails without the fix, and its inputs really
  happened); a pipeline is proven by a clean run from empty; a subagent's report is a claim to
  check; a check proves something *uses* what was authored, not only that the data is right.
- **Scenes:** moving a node is an editor job (and `tidy` lists `[node` headers merged into the
  line above); a tool that writes a `.tscn` proves the round trip first; runtime saves drop
  `uid://` lines.
- **Tuning:** a preset-vs-file guard must bypass the resource cache; never regenerate a generated
  page over an uncommitted data file.
- **Parallel work:** worktree rules for several coding agents at once: linked inputs, one build
  lock, one renderer, code-only commits, shared docs merged by the main session.
- **Working with the user:** the final message stands alone (phone and remote users); use what
  the project already holds before making placeholders.
- **Prompt-reminder hook:** rules the user has had to repeat go in `.claude/reminder.md` and are
  shown with every message.
- **GDScript:** split a long script before lint's 1000-line cap forces it mid-task; never shave
  comments to fit. The playtester sends keys, not actions, and says when windowed input can't be
  driven remotely.
- **Quirks seeded**, each reproduced on Godot 4.7.2 or tagged as reported: JSON numbers load as
  floats, `load()` returns the cached instance, `.tres` stores only non-default values, runtime
  saves drop uids, helpers named like Object virtuals, physics-interpolation teleports, layout
  overflow, vsync-capped measurements, black captures on a locked desktop, LFS worktrees.
- `budgets.md`: a rules file holding a generated table trims its prose, never its rows.

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
