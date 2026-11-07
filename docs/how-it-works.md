# How it works

The kit is a set of habits, written down so Claude follows them every session instead of
relearning them. This page explains the habits and why each exists. Each "why" is something that
went wrong in a real project without it.

## The loop

```
resume → ask for something → (plan-feature) → build in small steps → checks → you play it
       → save work (commit on your yes) → … → wrap up (STATUS, lessons) → /clear or exit
```

## 1. Starting a session

**What happens:** the session-start hook gives Claude a status card (or, if the session started
one folder too high or low, where the project really is): uncommitted and unpushed
work, what's in `inbox/`, STATUS's "Next" paragraph, whether `godot` is reachable, and your own
standing guard (`.claude/start-guard.md`). You say **resume**; Claude fetches, shows incoming
commits from your other machine and asks before pulling, reads `docs/STATUS.md`, looks for
half-done work from a rushed ending, processes the inbox, and proposes **one task** for the
session: roadmap tasks are sized S/M/L, each with a "Done when" line, and the first is a
"green baseline" (every check passes) so later tasks can trust the checks.

**Why:** a hook's "0 commits not pushed" is not a fetch, and a machine once rebuilt work another
machine had already pushed. Sessions also end abruptly (usage limits), so resume looks for loose
ends instead of trusting the last summary. One task per session, then `/clear`, kept another
project at 22 finished stages in four days.

**Coming back after a while,** or after a plugin update: bootstrap stamps the kit version into
the project, and the card says when the project is behind. **update the kit** then adds the new
template files and merges new rule lines into the project's own versions, asking wherever a kit
line would change something the user wrote.

## 2. Planning

**What happens:** anything new and non-trivial goes through `plan-feature`. Claude asks the open
questions **one at a time, each with a recommendation** ("APR" takes it), records your answers in
a dated decision record, then writes a plan with a **Done =** paragraph a player could check and
small tasks, and waits for your OK. If GodotPrompter is installed, it loads the matching engine
skill and says which pattern it picked and which it rejected. If godot-sourcing is installed and
the feature needs an asset, a shader or a common system, it looks for a ready-made one first and
your pick becomes part of the decision.

**Why:** a dozen questions at once get skimmed; one at a time with a default gets real answers
fast. A decision that lives only in chat is forgotten by the next session.

## 3. One home per fact

| Kind of fact | Its one home |
|---|---|
| Rules | `CLAUDE.md` (short) and `.claude/rules/` (by topic; some load only for matching files) |
| How you like to work | `.claude/memory/` (one fact per file: the rule, **Why**, **How to apply**) |
| Where we are, what's next, open questions | `docs/STATUS.md` |
| What each system does **now** | `docs/systems/<system>.md` |
| **Why** it's that way | `docs/decisions/` (frozen once decided; indexed in its README) |
| What's next, and what landed when (the build log) | `docs/plans/roadmap.md`, `docs/plans/` |
| Bugs known and not yet fixed | `docs/known-bugs.md` |
| Engine and tool gotchas | `docs/guides/quirks.md` |
| What good looks like, what the project holds | `docs/research/` |

The full list, with each home's headings and entry format, is the project's
`.claude/godot-accel/shape.md`; `tools/dev.sh conform` checks the project against it. A project
that needs a home the kit lacks adds a row there, so it is declared rather than drift.

Everything else points at the home. When a decision changes, Claude greps `docs/` and fixes every
copy in the same change.

**Why:** the same rule in four places drifts into four versions, and a resumed session follows the
stale one. A plan line once overrode a locked standard that way.

**Content stays, structure converges.** Three projects that all ran the kit ended up with three
different layouts, because every way the kit had of handling an existing project kept the
project's own file formats. The shape file and `conform` make the structure checkable, and
`realign` moves a project onto it while keeping every fact the project holds.

## 4. Memory that travels

`.claude/memory/` lives in the repo, so it's on every machine and visible to any agent. CLAUDE.md
imports its index (`@.claude/memory/MEMORY.md`). Only the index loads at start, so any rule that
must never be missed is also copied, in one line, into CLAUDE.md's **Hard rules**.

**Why:** a binding rule kept only in a memory file was seen as one index line and got skipped.

## 5. Checking before you see anything

- After every `.gd` change: `gdformat` + `gdlint` for an editing tool's change, `gdlint` only for
  a shell command's (it may have been a `git pull`, or your own save in Godot); lint failures go
  straight back to Claude.
- Before edits: the path guard blocks Godot's cache and generated files for the editing tools,
  and the project's deny rules (`.claude/settings.json`) block them for shell commands too
  (redirects, `tee`, `sed`). The same settings make every commit ask you first.
- Before Claude finishes a turn in which it changed game files: the stop hook asks it to run the
  checks covering them, or to say why they can't run (once per batch of changes).
- After each small step: only the checks covering what changed (`tools/dev.sh check <name>`);
  Godot's cache is refreshed only when files changed.
- Per task (`ship-check`): lint, every headless check (`tools/dev.sh check`: the smoke check loads
  every script and plays the main scene; a run where no check ran fails), a play-test, fixes,
  "To try:" for you, a proposed commit.
- At milestones only: the `adversarial-reviewer`, given the intent but never Claude's own
  summary. Obvious fixes happen at once; design questions come to you one at a time.
- `.githooks/` (on once you run `git config core.hooksPath .githooks`): the same lint plus a
  secrets scan at commit time, catching edits made from a shell that the editor hooks miss.
  Optional identity checks run only on a machine set up for them (`.githooks/README.md`).
- `.claude/rules/showing-work.md`: quote the check output, review every case yourself first, show
  work neutrally, **never call it good**.

**Why:** "the user was the QA" was the most expensive failure in the source project: defects a
check would have caught reached the user round after round. Praise for output the user then
disliked cost trust and money.

## 6. Tuning, your hand edits and playtests

- Every value you feel (speed, timing, jump height) lives in a `Tuning` Resource you can change
  in the Inspector; each system page says where (`.claude/rules/tuning.md`).
- Uncommitted scene and resource changes are treated as yours: the session-start card lists
  them, and Claude builds on them instead of reverting them.
- "Too floaty" becomes a tuning change before a code change; bundled requests are built one
  piece at a time with a playtest after each; every task ends with what to open and try.

**Why:** in another project Claude overwrote values the owner had tuned by hand, and Godot's
habit of saving only non-default values hid it: a new script default lost silently to the old
preset.

## 7. Saving

- **Task save** (after each finished task, "save work"): tick the plan, run the gate, scan for
  secrets, commit **on your yes**, staged file by file, push if you agreed to that.
- **Session save** ("wrap up", "switching machines"): the task save plus STATUS, `trim-context`,
  and a check that another agent or machine could pick up from the repo alone.
- **Quick save** ("running out of usage"): STATUS Next and a work-in-progress commit, nothing else.
- Every save ends with **"Safe to /clear: yes"** or **"no, because…"**.

**Why:** updating STATUS after every task made half the commits bookkeeping; once per session is
enough. Staging by path stops one session committing another's half-done work.

## 8. Learning

At session end `trim-context` lists what went wrong or cost a lot and sends each lesson to exactly
one home (memory, a rule, `quirks.md`, or, if it already happened twice, a check or a hook). It
then trims every always-read file to its character budget (`.claude/budgets.md`) and lists dead
paths (`tools/dev.sh stale`).

`tools/dev.sh budget` checks the budgets and the 400-character line limit; every save runs it,
and the session-start card warns when STATUS is over.

**Why:** every always-read character is paid for in every session. Budgets counted in lines were
gamed by 3,000-character lines; characters can't be. And a budget nothing checks is ignored:
another project's status file grew to 875 lines of dated session notes, its first table cell one
paragraph of several hundred words, while its CLAUDE.md said "keep it to a few lines".

## 9. Keeping the project tidy

`project-audit` is a health check for the whole project. `tools/dev.sh tidy` finds the mechanical
drift: files not in git, code outside the folders CLAUDE.md names, scripts and scenes nothing
uses, scripts over 300 lines, scenes a hand edit broke, finished plans not archived;
`tools/dev.sh conform` finds docs out of their homes or form. The skill reads both, then judges what a script can't: duplicated logic, system pages that disagree with the code,
rules that clash, token cost. It writes a ranked report in plain words and asks about each fix.
Run it at the end of a milestone, or whenever the project feels messy or sessions feel slow.

**Why:** across many sessions and cleared contexts, Claude puts things in slightly different
places each time. Small drift is cheap to fix when it is listed; left alone, it becomes a project
nobody can find their way around.

## 10. Working beside other sessions and agents

- The inbox (`inbox/`) is your drop box between sessions: packs, notes, handovers.
- A canon session (optional) owns `docs/canon/`; build sessions send request files instead of
  editing the bible, so two sessions never overwrite each other.
- `AGENTS.md` lets any other AI tool or developer pick the project up: the read order and the
  per-task loop.

## 11. Feeding back to the kit

`harvest-learnings` compares your project's rules and docs with the kit's templates and drafts
GitHub issues for what any project would benefit from, with your game's content stripped out.
