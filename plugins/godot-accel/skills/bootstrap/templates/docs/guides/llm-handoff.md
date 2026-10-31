# Handoff guide for another model or agent

For any AI agent or developer picking up {{GAME_NAME}}. Everything needed is in the repo. Each
rule has one home; this page only points at them. Budget: 6,000 characters.

## 1. Read order

1. `CLAUDE.md`: project rules, layout, workflow, hard rules.
2. `.claude/rules/*.md`: rules for GDScript, scenes, docs, git and working with the user.
3. `.claude/memory/MEMORY.md` and every file it links: working rules learned from the user.
   Claude Code loads only the index at start; any other agent reads them all first.
4. `docs/STATUS.md`: where work stopped, what is next, the only open-questions list.
5. `docs/plans/roadmap.md` and the plan STATUS names.
6. Before touching a system: its page in `docs/systems/`; the records in `docs/decisions/` say why.
7. Before debugging: `docs/guides/quirks.md`.
{{CANON_READ_LINE}}

## 2. How the user works

`.claude/rules/working-with-user.md`: numbered questions one at a time, each with a
recommendation; "APR" means "as per recommendation"; commit only on the user's yes.

## 3. The per-task loop

1. New system: plan first (`plan-feature`), the user's OK before code.
2. Small steps. After each: lint, `tools/dev.sh check`, one live run; fix every error.
3. Task save (`save-work`): gate, plan tick, commit on yes, push.
4. Session end: session save (STATUS, lessons, budgets).

## 4. Procedures without Claude Code

Skills are Markdown: the kit's skills (`resume`, `plan-feature`, `save-work`, `ship-check`,
`trim-context`) are in the {{KIT_NAME}} plugin; follow their steps by hand if your tool has no
skills. Project skills, if any: `.claude/skills/<name>/SKILL.md`.
