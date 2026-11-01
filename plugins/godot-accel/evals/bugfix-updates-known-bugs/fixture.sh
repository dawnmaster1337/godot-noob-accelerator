#!/usr/bin/env bash
set -e
here=$(cd "$(dirname "$0")" && pwd)
KIT_TEMPLATES="$here/../../skills/bootstrap/templates"
. "$here/../lib/kit-project.sh"
g() { git -c user.name=eval -c user.email=eval@example.invalid "$@"; }
mkdir -p scripts
cat >scripts/coin.gd <<'GD'
extends Area2D

signal collected

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D) -> void:
	collected.emit()
	$AnimationPlayer.play("pop")
	await $AnimationPlayer.animation_finished
	queue_free()
GD
perl -0pi -e 's/(## Open\n\n.*?```\n.*?```\n)/$1\n### Coin counted twice\n- Status: open\n- Area: coins\n- Reported: 2026-10-30 (user)\n- Repro: walk into a coin, then step back and forth over it while it plays its pop animation.\n- Expected: the score goes up by 1.\n- Actual: the score goes up once per touch until the animation ends.\n/s' docs/known-bugs.md
g add -A && g commit -qm "Add coins; log the double-count bug"
