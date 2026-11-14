# Project memory

Working rules learned from the user, kept **in the repo** so every machine and every agent sees
them. `MEMORY.md` is the index: one line per memory, under 3,000 characters. Each memory is one
file, one fact, under 1,200 characters:

```markdown
---
name: short-kebab-slug
description: one line, used to decide whether this memory is relevant
metadata:
  type: user | feedback | project | reference
---

The rule or fact.

**Why:** what happened that made the user ask for this (session, date).

**How to apply:** when it applies and what to do. Related: [[other-slug]].
```

- `user`: who the user is and how they like to work. `feedback`: a correction or a confirmed
  approach. `project`: goals or constraints the code can't show. `reference`: where things live
  outside the repo.
- Update an existing memory rather than adding a near-duplicate; delete one that is no longer
  true. Never store secrets, or anything the code, docs or git history already say.
- **This folder is the project's one memory.** Claude Code's own auto memory stays on one
  machine, so the project's settings turn it off (`autoMemoryEnabled` in
  `.claude/settings.json`).
- **Claude Code loads only `MEMORY.md` at start.** A rule that must never be missed is also
  copied, in one line, into CLAUDE.md "Hard rules".
