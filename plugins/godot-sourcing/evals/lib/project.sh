#!/usr/bin/env bash
# A minimal Godot 4 project in the current folder: project.godot and one scene, nothing sourced.
# Sourced by each case's fixture.sh. SOURCING_POLICY=<file>: also write .claude/rules/sourcing.md.
cat >project.godot <<'GODOT'
config_version=5

[application]

config/name="Eval Game"
run/main_scene="res://main.tscn"
config/features=PackedStringArray("4.7", "Forward Plus")
GODOT
cat >main.tscn <<'TSCN'
[gd_scene format=3]

[node name="Main" type="Node3D"]
TSCN
if [ -n "${SOURCING_POLICY:-}" ]; then
	mkdir -p .claude/rules
	cp "$SOURCING_POLICY" .claude/rules/sourcing.md
fi
