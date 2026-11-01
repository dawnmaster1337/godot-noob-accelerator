#!/usr/bin/env bash
# PreToolUse (Edit|Write|MultiEdit|NotebookEdit): refuse edits to files Godot or other people own
# (path_block_reason in lib.sh). Exit 2 blocks the edit and shows the reason to Claude. Silent
# outside a Godot project, or when the project registers its own guard-paths.sh.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
is_godot_project || exit 0
project_has_own_hook guard-paths.sh && exit 0

input=$(cat)
file=$(json_field file_path "$input")
[ -n "$file" ] || file=$(json_field notebook_path "$input")
[ -n "$file" ] || exit 0

root=$(project_root)
rel=${file#"$root"/}
reason=$(path_block_reason "$rel")
if [ -n "$reason" ]; then
	echo "Blocked by godot-accel: $rel $reason" >&2
	exit 2
fi
exit 0
