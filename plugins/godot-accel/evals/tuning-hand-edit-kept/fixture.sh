#!/usr/bin/env bash
set -e
here=$(cd "$(dirname "$0")" && pwd)
KIT_TEMPLATES="$here/../../skills/bootstrap/templates"
. "$here/../lib/kit-project.sh"
g() { git -c user.name=eval -c user.email=eval@example.invalid "$@"; }
# The user's tuning resource, then an uncommitted Inspector edit to its preset.
mkdir -p scripts resources
cat >scripts/jump_tuning.gd <<'GD'
class_name JumpTuning
extends Resource
## Peak height of a jump, in tiles.
@export_range(1.0, 12.0, 0.5) var jump_height: float = 4.0
## Seconds from take-off to the peak.
@export_range(0.1, 1.0, 0.05) var time_to_peak: float = 0.4
GD
cat >resources/jump_tuning.tres <<'TRES'
[gd_resource type="Resource" script_class="JumpTuning" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/jump_tuning.gd" id="1"]

[resource]
script = ExtResource("1")
jump_height = 6.0
TRES
g add scripts resources && g commit -qm "Add jump tuning"
sed -i 's/jump_height = 6.0/jump_height = 7.5/' resources/jump_tuning.tres
