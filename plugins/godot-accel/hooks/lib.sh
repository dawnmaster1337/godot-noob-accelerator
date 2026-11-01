#!/usr/bin/env bash
# Shared helpers for the kit's hooks. Sourced, never run.

# project_root: the project Claude is working in.
project_root() {
	printf '%s' "${CLAUDE_PROJECT_DIR:-$PWD}"
}

# is_godot_project: true when the project root holds project.godot.
is_godot_project() {
	[ -f "$(project_root)/project.godot" ]
}

# json_field <key> <json>: one string field from the hook input, via jq or python3.
# Prints nothing when neither tool exists (the hook then does nothing).
json_field() {
	local key=$1 json=$2
	if command -v jq >/dev/null 2>&1; then
		printf '%s' "$json" | jq -r --arg k "$key" '.tool_input[$k] // empty' 2>/dev/null
	elif command -v python3 >/dev/null 2>&1; then
		printf '%s' "$json" | python3 -I -c '
import json, sys
try:
    v = json.load(sys.stdin).get("tool_input", {}).get(sys.argv[1], "")
    print(v if isinstance(v, str) else "", end="")
except Exception:
    pass
' "$key"
	fi
}

# json_top <key> <json>: one top-level string field of the hook input (tool_name, …).
json_top() {
	local key=$1 json=$2
	if command -v jq >/dev/null 2>&1; then
		printf '%s' "$json" | jq -r --arg k "$key" '.[$k] // empty' 2>/dev/null
	elif command -v python3 >/dev/null 2>&1; then
		printf '%s' "$json" | python3 -I -c '
import json, sys
try:
    v = json.load(sys.stdin).get(sys.argv[1], "")
    print(v if isinstance(v, str) else "", end="")
except Exception:
    pass
' "$key"
	fi
}

# project_has_own_hook <script name>: true when the project's own settings already register a
# hook script of the same name (written before the plugin shipped one). The project's copy wins,
# so the same job doesn't run twice and report every failure twice.
project_has_own_hook() {
	local root
	root=$(project_root)
	grep -qsF "hooks/$1" "$root/.claude/settings.json" "$root/.claude/settings.local.json"
}

# path_block_reason <path relative to the project root>: why the kit refuses to let Claude write
# it, or nothing. Always: Godot's cache, import settings, .uid files, .env files. Also each glob
# in .claude/protected-paths.txt; a line starting with ! is an exception.
path_block_reason() {
	local rel=$1 list line allowed=0 protected=""
	case "$rel" in
		.godot/* | */.godot/*) echo "is in Godot's cache (.godot/). Change the source scene or resource instead." && return ;;
		*.import) echo "is an import-settings file Godot generates. Change import settings in the editor." && return ;;
		*.uid) echo "is a .uid file Godot generates. Never hand-edit it." && return ;;
		.env | .env.* | */.env | */.env.*) echo "looks like a secrets file." && return ;;
	esac
	list="$(project_root)/.claude/protected-paths.txt"
	[ -f "$list" ] || return 0
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
		echo "is protected by .claude/protected-paths.txt ($protected): third-party or engine-owned. Build on top of it elsewhere, or add an ! exception there if the user agrees."
	return 0
}

# bash_stamp: touched before each shell command, so the format + lint hook can find the .gd files
# that command changed. Lives in Godot's (git-ignored) cache folder.
bash_stamp() {
	printf '%s' "$(project_root)/.godot/godot-accel-bash.stamp"
}
