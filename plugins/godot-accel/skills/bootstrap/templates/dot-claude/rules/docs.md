---
paths:
  - "docs/**"
  - "CLAUDE.md"
  - "AGENTS.md"
  - ".claude/**/*.md"
---

# Docs rules

- **One home per fact:** the table in CLAUDE.md says where each kind of fact lives; everything
  else points there. Decision records are frozen once decided.
- **A doc that mirrors code is generated from it:** once a page lists more than a handful of
  things the code offers (options, moves, items), a tool verb writes it by calling the code (never
  by re-parsing the source), and a check fails when the committed page differs from a fresh build.
  A number in a doc names the command that produces it.
- **Names:** `YYYY-MM-DD-<topic>.md` for decisions, plans and reviews. Finished plans and old
  reviews move to `docs/archive/` (fix the links).
- **A decision changed?** Grep `docs/` for the old claim and fix every copy in the same change; add
  the record to `docs/decisions/README.md`.
- **Budgets in characters** (`.claude/budgets.md`); no line over 400 characters. Trim at session end.
- **Paths in backticks** (`scenes/<name>.tscn`) so `tools/dev.sh stale` can find dead ones.
- **Words:** the code says what the game says: one term per thing, the same in chat, docs, code
  and on screen. A renamed term is renamed everywhere.
- Plain words; short lines; tables for anything with more than two fields.
