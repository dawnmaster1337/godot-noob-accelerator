---
name: realign
description: Move an existing Godot project onto the kit's shape — when it was never bootstrapped, was set up by hand or by an older kit, or the session-start card or `tools/dev.sh conform` says it is off the shape. Finds every file doing a kit home's job (status, roadmap, logs, hand-off notes, bug lists, quirks, references, rules), rewrites its facts into the kit's home and form, archives the original and proves nothing was dropped. One home at a time, each on the user's yes. Run it by typing it.
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
   the templates if missing, and the kit's `tools/dev.sh` (the project's own verbs merged in, as
   `update` step 5 does). Run `tools/dev.sh conform`.
2. **Inventory** every file doing a home's job, whatever its name or place: root and `docs/`
   markdown, `.claude/` notes, hand-offs, CLAUDE.md sections that are really status or a plan,
   memory files holding binding rules, project skills and hooks named like the kit's. Read each;
   one file can feed several homes.
3. **Map table**, under 20 lines: their file → kit home(s) · what moves · what is a duplicate (and
   of what) · what needs its own shape row (a home the kit lacks; recommend folding into a kit
   home first). Unclear items: ask one at a time, with a recommendation. One yes for the table.
4. **Migrate one home at a time:** status → roadmap → bugs → decisions → quirks → systems →
   research → rules and memory → CLAUDE.md. For each:
   - Write the kit file from its template, filled from their content in the kit's form. STATUS
     keeps only where work stopped, Next and open questions (the rest to its home). Roadmap tasks
     get number, size and Done when; a ticked task gets `Done YYYY-MM-DD.` from the old log or
     `git log` (unknown: ask once for all). Bugs get the six fields (unknown → `?`, never
     invented). Decisions get a **Status:** line and an index row.
   - **Count before and after** (tasks, bugs, decisions, quirks, rules) and show both; explain or
     fix any difference.
   - `git mv` the old file to `docs/archive/realign/`, its first line naming the new home; fix
     links to it (`tools/dev.sh stale`). A project skill or hook duplicating a kit one: the kit's
     stands down; the user decides whether to delete theirs.
   - `tools/dev.sh conform` and `stale`: that home's problems are gone. Offer a commit for it,
     staged by path.
   A big project can take one home per session: `conform` shows what is left.
5. **Fill the rest** as bootstrap would: missing kit files from the templates, placeholders from
   CLAUDE.md and `project.godot`; bootstrap's questions only where nothing in the project answers
   them. CLAUDE.md keeps every rule the user wrote, in the kit's sections; a binding rule that
   lived only in memory or chat gets its Hard rules line.
6. **Prove:** `tools/dev.sh conform`, `stale`, `budget`, `check`, `lint all`; quote the output.
   Write the plugin's version to `.claude/godot-accel/kit-version`.
7. **Report** in a few lines: homes moved (with the counts), files archived, new shape rows, what
   is still open. Then `save-work`.
