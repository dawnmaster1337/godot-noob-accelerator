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

**What happens:** the session-start hook gives Claude a status card: uncommitted and unpushed
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

## 2. Planning

**What happens:** anything new and non-trivial goes through `plan-feature`. Claude asks the open
questions **one at a time, each with a recommendation** ("APR" takes it), records your answers in
a dated decision record, then writes a plan with a **Done =** paragraph a player could check and
small tasks, and waits for your OK. If GodotPrompter is installed, it loads the matching engine
skill and says which pattern it picked and which it rejected.

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
| What's next | `docs/plans/` |
| Bugs known and not yet fixed | `docs/known-bugs.md` |
| Engine and tool gotchas | `docs/guides/quirks.md` |

Everything else points at the home. When a decision changes, Claude greps `docs/` and fixes every
copy in the same change.

**Why:** the same rule in four places drifts into four versions, and a resumed session follows the
stale one. A plan line once overrode a locked standard that way.

## 4. Memory that travels

`.claude/memory/` lives in the repo, so it's on every machine and visible to any agent. CLAUDE.md
imports its index (`@.claude/memory/MEMORY.md`). Only the index loads at start, so any rule that
must never be missed is also copied, in one line, into CLAUDE.md's **Hard rules**.

**Why:** a binding rule kept only in a memory file was seen as one index line and got skipped.

## 5. Checking before you see anything

- After every `.gd` edit: `gdformat` + `gdlint` (hook); lint failures go straight back to Claude.
- Before edits: the path guard blocks Godot's cache and generated files.
- After each small step: only the checks covering what changed (`tools/dev.sh check <name>`);
  Godot's cache is refreshed only when files changed.
- Per task (`ship-check`): lint, every headless check (`tools/dev.sh check`; a check scene's exit
  code is its failure count), a play-test, fixes, "To try:" for you, a proposed commit.
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

## 9. Reviewing the process itself

`workflow-audit` reviews the setup like code: contradictions, rules nothing enforces, hidden
rules, token cost, bookkeeping-only commits. It writes a ranked report and asks about each fix.
Run it at the end of a milestone or when sessions feel slow.

## 10. Working beside other sessions and agents

- The inbox (`inbox/`) is your drop box between sessions: packs, notes, handovers.
- A canon session (optional) owns `docs/canon/`; build sessions send request files instead of
  editing the bible, so two sessions never overwrite each other.
- `AGENTS.md` and `docs/guides/llm-handoff.md` let any other AI tool pick the project up.

## 11. Feeding back to the kit

`harvest-learnings` compares your project's rules and docs with the kit's templates and drafts
GitHub issues for what any project would benefit from, with your game's content stripped out.
