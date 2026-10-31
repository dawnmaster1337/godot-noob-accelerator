---
name: trim-context
description: End-of-session review — captures the session's lessons into their one home, then trims the files Claude reads every session (CLAUDE.md, rules, STATUS, the memory index and files) to their character budgets so each new session starts cheap. Runs from save-work's session save, or when the user says "trim", "review the session", "lessons" or worries about token use.
allowed-tools: Read Bash(wc *) Bash(awk *) Bash(git diff *) Bash(git log *) Bash(tools/dev.sh stale)
---

!`cat .claude/budgets.md 2>/dev/null || echo "no .claude/budgets.md: use CLAUDE.md 8000, STATUS 5000, MEMORY.md 2000, each memory 1200, each rule 3000"`

!`wc -c CLAUDE.md AGENTS.md docs/STATUS.md .claude/rules/*.md .claude/memory/*.md docs/guides/*.md docs/systems/*.md 2>/dev/null | sort -n`

!`awk 'length > 400 {print FILENAME ":" FNR ": " length " chars"}' CLAUDE.md docs/STATUS.md .claude/rules/*.md .claude/memory/*.md 2>/dev/null`

!`tools/dev.sh stale 2>/dev/null`

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
2. **Budgets.** Every file over its budget above is trimmed now: move detail into the doc it
   points to, delete what git already remembers, merge near-duplicates. Every line listed over
   400 characters is split or cut.
3. **Stale.** Delete memories and STATUS lines that are no longer true (a fixed bug, an answered
   question, a superseded plan). Fix every path `stale` listed. For each decision that changed
   this session, grep `docs/` for the old claim and fix every copy.
4. **Never trim:** canon, decision records, open questions the user hasn't answered, quirks that
   still apply.
5. Report in one line: lessons added (where), characters saved, anything still over budget and why.
