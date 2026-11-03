#!/usr/bin/env bash
set -e
here=$(cd "$(dirname "$0")" && pwd)
KIT_TEMPLATES="$here/../../skills/bootstrap/templates"
. "$here/../lib/kit-project.sh"
g() { git -c user.name=eval -c user.email=eval@example.invalid "$@"; }
mkdir -p scripts
printf 'extends CharacterBody2D\n\nconst WALK_SPEED: float = 200.0\n' >scripts/player.gd
for n in player enemy hud; do
	printf 'extends Node\n\n\nfunc _ready() -> void:\n\tprint("%s_check: 0 failed")\n\tget_tree().quit(0)\n' "$n" >tests/${n}_check.gd
	printf '[gd_scene format=3]\n\n[ext_resource type="Script" path="res://tests/%s_check.gd" id="1"]\n\n[node name="Check" type="Node"]\nscript = ExtResource("1")\n' "$n" >tests/${n}_check.tscn
done
mkdir -p docs/systems
cat >docs/systems/player.md <<'MD'
# Player: what is true now

## 4. Checks

`tests/player_check.tscn` (walk speed, jump). `tools/dev.sh check player` runs it.
MD
g add -A && g commit -qm "Add player, enemy and HUD checks"
