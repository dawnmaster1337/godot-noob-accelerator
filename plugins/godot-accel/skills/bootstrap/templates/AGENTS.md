# Agents

This project is built with Claude Code and the {{KIT_NAME}} kit, but any AI agent or developer
can continue it: everything needed is in the repo. Each rule has one home; this page points at
them.

## Read, in order

1. `CLAUDE.md`: rules, layout, workflow and hard rules. They apply to every agent.
2. `.claude/rules/*.md`: code, scenes, tuning values, docs, git, working with the user.
3. `.claude/memory/MEMORY.md` and every file it links. Claude Code loads only the index; any
   other agent reads them all first.
4. `docs/STATUS.md`: where work stopped, what is next, the only open-questions list.
5. `docs/plans/roadmap.md` and the plan STATUS names.
6. Before touching a system: its page in `docs/systems/` (`docs/decisions/` says why). Before
   debugging: `docs/guides/quirks.md` and `docs/known-bugs.md`.
{{CANON_READ_LINE}}

## The loop

1. New system: plan first; the user's OK before any code.
2. Small steps. After each: lint, the checks for what you touched, one run; fix every error.
3. After each task: all checks, then commit on the user's yes, staged by path. Never commit
   secrets.
4. At session end: rewrite `docs/STATUS.md`.

Without Claude Code: the kit's skills (`resume`, `plan-feature`, `save-work`, `ship-check`,
`trim-context`) are Markdown files in the {{KIT_NAME}} plugin; follow their steps by hand.
Project skills: `.claude/skills/<name>/SKILL.md`.
