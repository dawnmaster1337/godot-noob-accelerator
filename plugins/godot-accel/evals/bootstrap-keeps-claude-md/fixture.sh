#!/usr/bin/env bash
# A Godot project that already has the user's own CLAUDE.md.
set -e
printf 'config_version=5\n\n[application]\nconfig/name="Smoke"\nconfig/features=PackedStringArray("4.4")\n' > project.godot
printf '# My notes\n\nKEEP-THIS-LINE: the user wrote this file by hand.\n' > CLAUDE.md
git init -q
