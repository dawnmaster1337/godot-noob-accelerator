---
name: project-audit
description: Health check of a game project — "audit the project", "is the repo tidy", "are the docs a mess", "why so many tokens", "what keeps going wrong", or a milestone's end. Writes one ranked report, then asks about each fix.
argument-hint: "[focus, e.g. code, docs, tokens, git, the last milestone]"
allowed-tools: Read Glob Grep Bash(wc *) Bash(git log *) Bash(git status *) Bash(git worktree list) Bash(tools/dev.sh tidy) Bash(tools/dev.sh stale) Bash(tools/dev.sh budget) Bash(tools/dev.sh conform)
---

Focus: $ARGUMENTS

!`if [ -x tools/dev.sh ]; then tools/dev.sh conform 2>&1; tools/dev.sh tidy 2>&1; tools/dev.sh stale 2>&1; tools/dev.sh budget 2>&1; else echo "CHECKS DID NOT RUN (no tools/dev.sh)"; fi; true`

!`git log --oneline -40 --stat 2>/dev/null | grep -cE 'docs/STATUS.md'; true`

**Read-only:** change nothing but the report (step 6) until the user answers. Plain words; explain jargon once. The
checks above find the mechanical problems; you judge what they mean.

1. **The repo:** files not in git, in the wrong folder, or never used (`tidy` above; read each
   before calling it dead: a scene loaded by a string path still counts as used). Folders the
   layout in CLAUDE.md doesn't mention. Two scripts doing one job.
2. **The code:** scripts over ~300 lines, the same logic in several places, names that don't
   match the game's words (`.claude/rules/docs.md`), values hard-coded that belong in a Tuning
   Resource.
3. **The docs:** `conform` problems rank first (a project off the shape → recommend `realign`,
   not piecemeal fixes); each fact in its one home; system pages
   that disagree with the code, or systems with no page; finished plans not archived; decisions
   with no index row; dead paths (`stale`).
4. **The rules and memory:** rules that disagree (CLAUDE.md, rules, memory, skills); binding rules
   only in a memory file or in chat; rules broken before that nothing enforces (→ a check or a
   hook); a project skill named like a kit skill (a fork: use `.claude/godot-accel/<skill>.md`).
5. **Cost:** what loads every session (CLAUDE.md and imports, rules without `paths:`, the memory
   index, hook output); over-budget files (`budget`); commits that are only bookkeeping; disk held
   by worktrees (`du -sh .claude/worktrees`, and any whose branch is merged).
6. **Report:** `docs/reviews/YYYY-MM-DD-audit.md` (no `docs/reviews/` yet: start it with the kit's
   `${CLAUDE_SKILL_DIR}/../bootstrap/templates/docs/reviews/README.md`): a five-line summary for the user; a ranked
   top-10 table (problem, one-line fix, effort S/M/L); detail by section with `file:line`
   evidence; "Keep as is".
7. **Ask** the decisions one at a time, each with a recommendation; record the answers in a
   decision record. Then fix what was agreed; obvious fixes with no design choice (archive a
   finished plan, fix a dead path) are done without asking and listed.
