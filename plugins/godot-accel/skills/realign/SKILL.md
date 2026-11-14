---
name: realign
description: Move an existing Godot project onto the kit's shape, by typing it — never bootstrapped, set up by hand, or off the shape. Rewrites each stray status, plan, bug or rules file into its kit home, one at a time on the user's yes, keeping every fact.
argument-hint: "[optional: one home, e.g. bugs, roadmap, status]"
disable-model-invocation: true
---

Home: $ARGUMENTS (none = every home)

Kit templates: `${CLAUDE_SKILL_DIR}/../bootstrap/templates/` (`dot-claude/` = `.claude/`; file
map, placeholders and questions: `../bootstrap/SKILL.md`). Kit version:
`${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`.

!`if [ -x tools/dev.sh ] && grep -q '^conform()' tools/dev.sh; then tools/dev.sh conform 2>&1; else echo "no conform check yet (step 1 brings it)"; fi; git status --short 2>/dev/null | head -20; true`

**The rule: the user's content is always kept; the structure always becomes the kit's.** Paths,
headings and entry formats follow `.claude/godot-accel/shape.md`. Every fact, task, bug, decision,
quirk and rule the project holds survives, in the user's words where they fit: restructure, don't
reword. Afterwards no home has two files.

0. **Ready?** No `project.godot` → stop (bootstrap step 0). No docs of its own at all → bootstrap
   instead. Uncommitted work → offer `save-work` first, so each move is its own commit.
1. **The checking tools first:** add `.claude/godot-accel/shape.md` and `.claude/budgets.md` from
   the templates if missing, and the kit's `tools/dev.sh` (the project's own verbs merged in; it
   finds a Godot project in a subfolder such as `game/` itself, and runs GUT or gdUnit4 when
   installed) with `tests/smoke_check.*`.
   Scripts, git hooks, `settings.json` and budgets merge by `update` step 5's rules (a hook that
   is theirs gets new checks in `<hook>.project`). Run `tools/dev.sh conform` and `lint all`.
   **Lint already failing** → roadmap task 0.0 (green baseline); tell the user the commit hook
   will refuse commits touching those files until then, and recommend turning it on after 0.0.
2. **Inventory** every file doing a home's job, whatever its name or place: root and `docs/`
   markdown, `.claude/` notes, hand-offs, CLAUDE.md sections that are really status or a plan,
   memory files holding binding rules, project skills and hooks named like the kit's. Read each;
   one file can feed several homes.
3. **Map table**, under 20 lines: their file → kit home(s) · what moves · what is a duplicate (and
   of what) · what needs its own shape row (a home the kit lacks; recommend folding into a kit
   home first; rows go under "This project's own rows"). Unclear items: ask one at a time, with
   a recommendation. One yes for the table.
4. **Migrate one home at a time:** status → roadmap → bugs → decisions → quirks → systems →
   research → rules and memory → CLAUDE.md. For each:
   - Write the kit file from its template, filled from their content in the kit's form. STATUS
     keeps only where work stopped, Next and open questions (the rest to its home). Open roadmap
     tasks get number, size and Done when. A finished entry from an old log becomes
     `- [x] 0.12 (old) What. Done YYYY-MM-DD.` (date from the log or `git log`; never invent a
     size or a Done when). Bugs get the six fields (unknown → `?`, never invented). Decisions
     get a **Status:** line and an index row; their numbers stay after the date
     (`YYYY-MM-DD-adr-0003-<topic>.md`), and `**Status:** Accepted` reads as decided.
   - **Count before and after** (tasks, bugs, decisions, quirks, rules) and show both; explain or
     fix any difference.
   - A file whose job moved: write its first line naming the new home, then `git mv` it to
     `docs/archive/realign/` (the project may protect its archive); fix links (`stale`). A
     project already near the shape often only has formats to fix and nothing to archive.
   - A required heading that doesn't fit: a heading may say more after the shape's words
     (`## 3. Data and behaviour`); never rename content to fit a heading.
   - Over a budget after the move → name file and overage and ask; never trim their content.
   - A project hook duplicating a kit one: the kit's stands down; the user decides whether to
     delete theirs. A project skill named like a kit skill: show both skills' `!` commands and
     `allowed-tools` lines side by side and recommend the kit's (`update` step 3); the user
     decides.
   - `tools/dev.sh conform` and `stale`: that home's problems are gone. Offer a commit for it,
     staged by path; check `git diff --cached --name-status` first (`git mv` stages itself).
   A big project can take one home per session: `conform` shows what is left.
5. **Fill the rest** as bootstrap would: missing **setup** files from the templates (a *first use*
   home the project has no content for stays unmade; `conform` doesn't ask for it), every placeholder
   filled (`conform` lists any left) from CLAUDE.md and `project.godot`; bootstrap's questions
   only where nothing in the project answers them. A kit rule line that contradicts the
   project's own way (its events autoload, its folder style, review by images) is left out, and
   the user told. CLAUDE.md keeps every rule the user wrote, in the kit's sections; a binding
   rule that lived only in memory or chat gets its Hard rules line.
6. **Prove:** `tools/dev.sh conform`, `stale`, `budget`, `check`, `lint all`; quote the output.
   Write the plugin's version to `.claude/godot-accel/kit-version`.
7. **Report** in a few lines: homes moved (with the counts), files archived, new shape rows, what
   is still open. Then `save-work`.
