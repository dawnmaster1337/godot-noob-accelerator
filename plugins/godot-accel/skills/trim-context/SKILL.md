---
name: trim-context
description: End-of-session review — captures the session's lessons into their one home, then trims the files Claude reads every session (CLAUDE.md, rules, STATUS, the memory index and files) to their character budgets so each new session starts cheap. Runs from save-work's session save, or when the user says "trim", "review the session", "lessons" or worries about token use.
allowed-tools: Read Bash(git diff *) Bash(git log *) Bash(tools/dev.sh stale) Bash(tools/dev.sh budget)
---

!`if [ -x tools/dev.sh ]; then tools/dev.sh budget 2>&1; else echo "BUDGET CHECK DID NOT RUN (no tools/dev.sh): measure each file in .claude/budgets.md with wc -m"; fi; true`

!`if [ -x tools/dev.sh ]; then tools/dev.sh stale 2>&1; else echo "STALE CHECK DID NOT RUN (no tools/dev.sh)"; fi; true`

!`cat .claude/godot-accel/trim-context.md 2>/dev/null; true`

Project steps (from `.claude/godot-accel/trim-context.md`, shown above if any) run after step 3.

1. **Lessons.** List what went wrong or cost a lot this session: rework, detours, the user's
   corrections, tool quirks, wasted spend. Each goes to **exactly one** place:

   | Lesson | Home |
   |---|---|
   | How the user wants to work (a correction or a confirmed approach) | a memory file in `.claude/memory/` (rule, **Why**, **How to apply**) + its `MEMORY.md` line |
   | A rule the user made binding | the memory file **and** one line in CLAUDE.md "Hard rules" |
   | Engine, tool or shell quirk | code, if a script can own it (`tools/dev.sh`); else `docs/guides/quirks.md` |
   | A rule for code, scenes or docs | the matching `.claude/rules/*.md` |
   | A lesson that already happened twice | a check, a hook or a tool step, not more prose |

   Update an existing entry rather than adding a near-duplicate.
2. **Budgets.** Every file `budget` lists is trimmed now (how: `.claude/budgets.md`, "Trim
   by"): move detail into the doc it points to, delete what git already remembers, merge
   near-duplicates. Every line over 400 characters is split or cut. Re-run until it passes.
3. **Stale.** Delete memories and STATUS lines that are no longer true (a fixed bug, an answered
   question, a superseded plan); a Fixed list in `docs/known-bugs.md` past 20 lines loses the
   oldest. Fix every path `stale` listed. For each decision that changed this session, grep
   `docs/` for the old claim and fix every copy. Read each line of `.claude/reminder.md` against
   STATUS and the plan: a line about work that ended, or a rule a check now enforces, goes (keep
   its memory file if it is still true).
4. **Never trim:** canon, decision records, open questions the user hasn't answered, quirks that
   still apply. Over budget with only these left: cut what another home already holds, then
   stop; tell the user which files are still over and by how much, and make it a STATUS Next
   task. A budget is a reason to ask, never to delete protected content.
5. Report in one line: lessons added (where), characters saved, anything still over budget and why.
