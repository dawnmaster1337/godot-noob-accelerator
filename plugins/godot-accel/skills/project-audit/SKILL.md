---
name: project-audit
description: Read-only health check of a game project and how it is run with Claude — when the user asks to "audit the project", "check the repo is tidy", "are the docs a mess", "audit our workflow", "why are we using so many tokens", "what keeps going wrong", or at the end of a milestone. Finds files in the wrong place, unused or overgrown code, scattered or stale docs, contradicting rules and token cost; writes a ranked report in plain words; then asks about each fix one at a time.
argument-hint: "[focus, e.g. code, docs, tokens, git, the last milestone]"
allowed-tools: Read Glob Grep Bash(wc *) Bash(git log *) Bash(git status *) Bash(git worktree list) Bash(tools/dev.sh tidy) Bash(tools/dev.sh stale) Bash(tools/dev.sh budget)
---

Focus: $ARGUMENTS

!`if [ -x tools/dev.sh ]; then tools/dev.sh tidy 2>&1; tools/dev.sh stale 2>&1; tools/dev.sh budget 2>&1; else echo "CHECKS DID NOT RUN (no tools/dev.sh)"; fi; true`

!`git log --oneline -40 --stat 2>/dev/null | grep -cE 'docs/STATUS.md'; true`

**Read-only:** change nothing until the user answers. Plain words; explain jargon once. The
checks above find the mechanical problems; you judge what they mean.

1. **The repo:** files not in git, in the wrong folder, or never used (`tidy` above; read each
   before calling it dead: a scene loaded by a string path still counts as used). Folders the
   layout in CLAUDE.md doesn't mention. Two scripts doing one job.
2. **The code:** scripts over ~300 lines, the same logic in several places, names that don't
   match the game's words (`.claude/rules/docs.md`), values hard-coded that belong in a Tuning
   Resource.
3. **The docs:** each fact in its one home (CLAUDE.md's table); docs outside `docs/`; system pages
   that disagree with the code, or systems with no page; finished plans not archived; decisions
   with no index row; dead paths (`stale`).
4. **The rules and memory:** rules that disagree (CLAUDE.md, rules, memory, skills); binding rules
   only in a memory file or in chat; rules broken before that nothing enforces (→ a check or a
   hook); a project skill named like a kit skill (a fork: use `.claude/godot-accel/<skill>.md`).
5. **Cost:** what loads every session (CLAUDE.md and imports, rules without `paths:`, the memory
   index, hook output); over-budget files (`budget`); commits that are only bookkeeping.
6. **Report:** `docs/reviews/YYYY-MM-DD-audit.md`: a five-line summary for the user; a ranked
   top-10 table (problem, one-line fix, effort S/M/L); detail by section with `file:line`
   evidence; "Keep as is".
7. **Ask** the decisions one at a time, each with a recommendation; record the answers in a
   decision record. Then fix what was agreed; obvious fixes with no design choice (archive a
   finished plan, fix a dead path) are done without asking and listed.
