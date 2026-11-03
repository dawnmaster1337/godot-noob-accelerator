#!/usr/bin/env bash
# Stop: when Claude changed game files (scripts, scenes, resources, shaders) since the last
# tools/dev.sh check, it may not finish until it has run the checks or said why they can't run.
# "Never claim it works without running it" as a hook, not only a sentence. It blocks once per
# batch of changes (a marker file), so a check that can't run never traps the session.
# gd-format-lint.sh writes the list; tools/dev.sh check empties it. Silent outside a kit project,
# or when the project registers its own stop-check.sh.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
is_godot_project || exit 0
project_has_own_hook stop-check.sh && exit 0
[ -f "$(project_root)/tools/dev.sh" ] || exit 0
touched=$(state_file touched)
[ -s "$touched" ] || exit 0
if [ -f "$touched.asked" ]; then
	rm -f "$touched.asked"
	exit 0
fi
touch "$touched.asked"
files=$(sort -u "$touched" | head -8 | tr '\n' ' ')
echo "godot-accel: you changed ${files}since the last tools/dev.sh check. Before you finish, run the checks that cover them (tools/dev.sh check <name>, or all of them) and quote the result, or tell the user why they can't run." >&2
exit 2
