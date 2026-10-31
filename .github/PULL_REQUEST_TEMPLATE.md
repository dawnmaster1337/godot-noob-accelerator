## What this changes

<!-- One or two lines. Link the issue if there is one. -->

## Why

<!-- What went wrong without it. Every rule needs a why. -->

## Checks

- [ ] Process, not content: no game content, personal details, keys or absolute paths
- [ ] Not engine knowledge that belongs in GodotPrompter
- [ ] `claude plugin validate plugins/godot-accel --strict` and `claude plugin validate .` pass
- [ ] Hooks: `bash -n` passes; they exit 0 when a tool is missing and outside a Godot project
- [ ] Skills and agents under 3,000 characters (bootstrap excepted); generated CLAUDE.md under 200 lines
- [ ] Bootstrap still never overwrites an existing file
- [ ] Tried in a throwaway project with `claude --plugin-dir ./plugins/godot-accel`
- [ ] CHANGELOG "Unreleased" updated
