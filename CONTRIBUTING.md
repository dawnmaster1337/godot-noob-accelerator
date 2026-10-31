# Contributing

Thanks for helping. The kit improves from what real projects run into.

## Ways to help

1. **Feedback** (no code): open an issue with the **Feedback** template.
2. **Learnings** from your project: run `/godot-accel:harvest-learnings` in it and paste each
   body into an issue with the **Learning** template.
3. **Pull requests**: fixes to skills, templates, hooks or docs.

## Rules for changes

- **Process, not content.** The kit holds how a project is run. No game content, story, assets or
  personal details; an example is tiny, invented and marked *example*.
- **Not engine knowledge.** How to build a Godot system belongs in
  [GodotPrompter](https://github.com/jame581/GodotPrompter); link to it instead.
- **Every rule needs a why:** say what went wrong without it.
- **Budgets:** each skill and agent under 3,000 characters (`bootstrap` excepted); the generated
  `CLAUDE.md` under 200 lines. Prefer a pointer to a rule's one home over a copy.
- **Hooks must be portable:** no absolute paths; check every tool they call and exit 0 cleanly if
  it's missing; do nothing outside a Godot project.
- **Bootstrap never overwrites** a user's file.
- Skill descriptions trigger on how people actually talk ("save work", "I want to add…").

## Before opening a PR

```bash
claude plugin validate plugins/godot-accel --strict
claude plugin validate .
for f in plugins/godot-accel/hooks/*.sh; do bash -n "$f"; done
```

Then try it end to end (the smoke test in [docs/customising.md](docs/customising.md#testing-changes)).
Evals live in `plugins/godot-accel/evals/`; they make real model calls, so run them only when
you mean to (`claude plugin eval plugins/godot-accel --max-cost-usd 2`).

Add a line to [CHANGELOG.md](CHANGELOG.md) under "Unreleased" and bump the version in
`plugins/godot-accel/.claude-plugin/plugin.json` when releasing: users only get an update
when that version changes.
