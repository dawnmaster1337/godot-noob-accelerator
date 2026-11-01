# Context budgets (characters)

Checked by `tools/dev.sh budget` (from `trim-context` and every save). Files read every session
cost tokens in every session: keep them under budget. Over budget → trim now (move detail into
the doc it points to), unless what is left is protected (`trim-context` step 4): then it
becomes a task, never a deletion. A file named in its own row uses that row; a glob row skips `README.md`.
Any line over 400 characters fails too (a long table cell is a long line).

| File | Budget | Trim by |
|---|---|---|
| `CLAUDE.md` | 8,000 | move detail into rules or the doc it points to; keep rules, not explanations |
| `docs/STATUS.md` | 5,000 | done items → delete (git keeps them); queues → the plan |
| `.claude/memory/MEMORY.md` | 2,000 | merge related memories; delete ones the docs now cover |
| `.claude/memory/*.md` (each) | 1,200 | one fact, its why, how to apply; no diary |
| `.claude/rules/*.md` (each) | 3,000 | one topic per file |
| `docs/guides/quirks.md` | 5,500 | quirks a script now owns → delete |
| `docs/known-bugs.md` | 6,000 | Fixed list → the last 20 (git keeps the rest) |
| `docs/systems/*.md` (each) | 10,000 | detail into the decision record it cites |
| `.claude/skills/*/SKILL.md`, `.claude/agents/*.md` (each) | 3,000 | steps and pointers |
