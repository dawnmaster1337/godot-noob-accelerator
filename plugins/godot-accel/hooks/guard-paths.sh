#!/usr/bin/env bash
# PreToolUse (Edit|Write): refuse edits to files Godot or other people own. Always blocked:
# .godot/ (cache), *.import (import settings), *.uid (Godot writes them), .env files (secrets).
# Also blocked: each glob in .claude/protected-paths.txt; a line starting with ! is an exception.
# Exit 2 blocks the edit and shows the reason to Claude. Silent outside a Godot project.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
is_godot_project || exit 0

input=$(cat)
file=$(json_field file_path "$input")
[ -n "$file" ] || file=$(json_field notebook_path "$input")
[ -n "$file" ] || exit 0

root=$(project_root)
rel=${file#"$root"/}

block() {
	echo "Blocked by godot-accel: $rel $1" >&2
	exit 2
}

case "$rel" in
	.godot/* | */.godot/*) block "is in Godot's cache (.godot/). Change the source scene or resource instead." ;;
	*.import) block "is an import-settings file Godot generates. Change import settings in the editor." ;;
	*.uid) block "is a .uid file Godot generates. Never hand-edit it." ;;
	.env | .env.* | */.env | */.env.*) block "looks like a secrets file." ;;
esac

list="$root/.claude/protected-paths.txt"
[ -f "$list" ] || exit 0
allowed=0
protected=""
while IFS= read -r line || [ -n "$line" ]; do
	line=${line%%#*}
	line=$(printf '%s' "$line" | tr -d '[:space:]')
	[ -n "$line" ] || continue
	if [ "${line#!}" != "$line" ]; then
		# shellcheck disable=SC2254
		case "$rel" in ${line#!}) allowed=1 ;; esac
	else
		# shellcheck disable=SC2254
		case "$rel" in $line) protected=$line ;; esac
	fi
done <"$list"
[ -n "$protected" ] && [ "$allowed" = 0 ] &&
	block "is protected by .claude/protected-paths.txt ($protected): third-party or engine-owned. Build on top of it elsewhere, or add an ! exception there if the user agrees."
exit 0
