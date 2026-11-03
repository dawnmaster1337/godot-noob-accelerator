#!/usr/bin/env bash
# A Godot project that was never bootstrapped but keeps its own docs.
set -e
printf 'config_version=5\n\n[application]\nconfig/name="Smoke"\nconfig/features=PackedStringArray("4.7")\n' > project.godot
printf '# Smoke\n\nA test game where you jump over boxes.\n' > CLAUDE.md
printf '# TODO\n\n- [x] player jumps\n- [ ] boxes spawn\n' > TODO.md
mkdir -p notes
printf '# Where we are\n\nJump works. Next: spawning boxes.\n' > notes/status.md
printf '# Bugs\n\n- player clips through box corners\n' > BUGS.md
