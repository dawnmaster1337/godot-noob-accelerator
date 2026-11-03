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
- **Budgets:** each skill and agent under 4,000 characters (`bootstrap` and `realign`, run once
  per project, excepted); the generated `CLAUDE.md` under 200 lines. A skill's body loads only
  when it runs, so the number is a nudge toward steps and pointers, not a target. Prefer a
  pointer to a rule's one home over a copy.
- **A skill's `!` commands can't fail:** a failing one aborts the whole skill before Claude sees
  it (a `git log` in a repo with no commits did). Each ends in `; true` or `|| echo "…"`;
  `tests/run.sh` checks every one.
- **A rule that must hold is a check, a setting or a hook,** not only a sentence: deny and ask
  rules in `settings.suggested.json`, a `tools/dev.sh` verb, a hook. Prose rules are for judgement.
- **Hooks must be portable:** no absolute paths; check every tool they call and exit 0 cleanly if
  it's missing; do nothing outside a Godot project.
- **Bootstrap never overwrites** a user's file.
- Skill descriptions trigger on how people actually talk ("save work", "I want to add…").

## Before opening a PR

```bash
tests/run.sh
```

It builds throwaway projects from the templates and runs every `tools/dev.sh` verb, the plugin's
hooks and the git hooks against them, failure cases included, plus `claude plugin validate`,
`bash -n`, shellcheck and the `.githooks` copy check. It needs `godot` and gdtoolkit on PATH. CI
(`.github/workflows/tests.yml`) runs it on every push, with real GUT and gdUnit4 as well.

The repo's own `.githooks/` is a copy of the template: change the template, then copy it over.

Then try it end to end (the smoke test in [docs/customising.md](docs/customising.md#testing-changes)).
Evals live in `plugins/godot-accel/evals/`; they make real model calls, so run them only when
you mean to (`claude plugin eval plugins/godot-accel --scaffold --allow-tools Bash Write Edit --runs 1`;
cases with a `fixture.sh` need `--scaffold`, or they run in an empty folder).

Add a line to [CHANGELOG.md](CHANGELOG.md) under "Unreleased" and bump the version in
`plugins/godot-accel/.claude-plugin/plugin.json` when releasing: users only get an update
when that version changes.
