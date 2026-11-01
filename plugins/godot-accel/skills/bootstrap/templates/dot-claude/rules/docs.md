---
paths:
  - "docs/**"
  - "CLAUDE.md"
  - "AGENTS.md"
  - ".claude/**/*.md"
---

# Docs rules

- **One home per fact:** rules → CLAUDE.md and `.claude/rules/`; the user's working rules →
  `.claude/memory/`; where we are + the only open-questions list → `docs/STATUS.md`; what is true
  now → `docs/systems/`; why → `docs/decisions/` (frozen once decided); what's next →
  `docs/plans/`; bugs not yet fixed → `docs/known-bugs.md`; engine and tool gotchas →
  `docs/guides/quirks.md`. Everything else points there.
- **Names:** `YYYY-MM-DD-<topic>.md` for decisions, plans and reviews. Finished plans and old
  reviews move to `docs/archive/` (fix the links).
- **A decision changed?** Grep `docs/` for the old claim and fix every copy in the same change; add
  the record to `docs/decisions/README.md`.
- **Budgets in characters** (`.claude/budgets.md`); no line over 400 characters. Trim at session end.
- **Paths in backticks** (`scenes/<name>.tscn`) so `tools/dev.sh stale` can find dead ones.
- **Words:** the code says what the game says: one term per thing, the same in chat, docs, code
  and on screen. A renamed term is renamed everywhere.
- Plain words; short lines; tables for anything with more than two fields.
