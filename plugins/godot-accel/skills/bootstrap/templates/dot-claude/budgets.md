# Context budgets (characters)

Read by the `trim-context` skill at session end. Files read every session cost tokens in every
session: keep them under budget. Over budget → trim now (move detail into the doc it points to).

| File | Budget | Trim by |
|---|---|---|
| `CLAUDE.md` | 8,000 | move detail into rules or the doc it points to; keep rules, not explanations |
| `docs/STATUS.md` | 5,000 | done items → delete (git keeps them); queues → the plan |
| `.claude/memory/MEMORY.md` | 2,000 | merge related memories; delete ones the docs now cover |
| `.claude/memory/*.md` (each) | 1,200 | one fact, its why, how to apply; no diary |
| `.claude/rules/*.md` (each) | 3,000 | one topic per file |
| `docs/guides/quirks.md` | 5,500 | quirks a script now owns → delete |
| `docs/guides/llm-handoff.md` | 6,000 | pointers only |
| `docs/systems/*.md` (each) | 10,000 | detail into the decision record it cites |
| `.claude/skills/*/SKILL.md`, `.claude/agents/*.md` (each) | 3,000 | steps and pointers |
