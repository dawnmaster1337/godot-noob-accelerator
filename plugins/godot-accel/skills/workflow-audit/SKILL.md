---
name: workflow-audit
description: Read-only audit of how a project is being run with Claude — when the user asks to "audit our workflow", "review our setup", "why are we using so many tokens", "what keeps going wrong" or at the end of a milestone. Checks rules, memory, skills, agents, hooks, docs and budgets for contradictions, hidden rules, drift and cost; writes a ranked report; then asks about each fix one at a time.
argument-hint: "[focus, e.g. tokens, docs, git, the last milestone]"
allowed-tools: Read Glob Grep Bash(wc *) Bash(awk *) Bash(git log *) Bash(git status *) Bash(git worktree list) Bash(tools/dev.sh stale)
---

Focus: $ARGUMENTS

!`wc -c CLAUDE.md AGENTS.md .claude/rules/*.md .claude/memory/*.md .claude/skills/*/SKILL.md .claude/agents/*.md docs/STATUS.md 2>/dev/null | sort -n | tail -25`

!`git log --oneline -40 --stat 2>/dev/null | grep -cE 'docs/STATUS.md'`

**Read-only:** change nothing until the user answers. Plain words; explain jargon once.

1. **Always-loaded cost:** what loads every session (CLAUDE.md and its imports, rules without
   `paths:`, the memory index, hook output, skill and agent descriptions, plugins'). Sizes in
   characters ÷ 4 ≈ tokens. Flag anything loaded always that only one task needs (→ a skill or a
   path-scoped rule).
2. **Contradictions and drift:** rules that disagree (CLAUDE.md vs rules vs memory vs skills vs
   docs); claims in docs the code no longer matches; stale paths; decisions without an index row.
3. **Hidden rules:** binding rules that live only in a memory file (only the index loads) or only
   in chat history; procedures the user keeps asking for that no skill holds.
4. **Honour-system rules:** rules nothing enforces that have been broken before (git log, quirks,
   lessons) → candidates for a hook, a check or a script.
5. **Session loop:** how resume, saving, STATUS upkeep and reviews actually go (commit history:
   how many commits are bookkeeping only); parallel sessions sharing one checkout.
6. **Docs:** one home per fact? Over-budget files; lessons in more than one place.
7. **Report:** `docs/reviews/YYYY-MM-DD-workflow.md`: a five-line summary; a ranked top-10 table
   (problem, one-line fix, effort S/M/L); detail by section with file:line evidence; "Keep as is".
8. **Ask** the decisions one at a time, each with a recommendation; record the answers in a
   decision record; then fix what was agreed (obvious, no-design fixes: do them without asking
   and list them).
