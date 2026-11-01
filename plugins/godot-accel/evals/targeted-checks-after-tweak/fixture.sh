#!/usr/bin/env bash
set -e
here=$(cd "$(dirname "$0")" && pwd)
KIT_TEMPLATES="$here/../../skills/bootstrap/templates"
. "$here/../lib/kit-project.sh"
g() { git -c user.name=eval -c user.email=eval@example.invalid "$@"; }
mkdir -p scripts
printf 'extends CharacterBody2D\n\nconst WALK_SPEED: float = 200.0\n' >scripts/player.gd
for n in player enemy hud; do
	sed "s/example_check/${n}_check/; s/ExampleCheck/$(echo ${n^})Check/" tests/example_check.tscn >tests/${n}_check.tscn
	cp tests/example_check.gd tests/${n}_check.gd
done
cat >docs/systems/player.md <<'MD'
# Player: what is true now

## 4. Checks

`tests/player_check.tscn` (walk speed, jump). `tools/dev.sh check player` runs it.
MD
g add -A && g commit -qm "Add player, enemy and HUD checks"
