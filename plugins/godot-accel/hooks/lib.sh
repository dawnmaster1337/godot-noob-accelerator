#!/usr/bin/env bash
# Shared helpers for the kit's hooks. Sourced, never run.

# project_root: the project Claude is working in.
project_root() {
	printf '%s' "${CLAUDE_PROJECT_DIR:-$PWD}"
}

# is_godot_project: true when the project root holds project.godot, or is a git repo with exactly
# one folder below it that does (a game/ beside other work). A folder of several games is not.
is_godot_project() {
	local root
	root=$(project_root)
	[ -f "$root/project.godot" ] && return 0
	[ -e "$root/.git" ] || return 1
	[ -n "$(sub_game "$root")" ]
}

# sub_game <root>: the one folder right below root that holds project.godot, or nothing (none, or
# several: a folder of games is not one project).
sub_game() {
	local p found="" n=0
	for p in "$1"/*/project.godot; do
		[ -f "$p" ] || continue
		found=${p%/project.godot}
		n=$((n + 1))
	done
	[ "$n" = 1 ] && printf '%s' "$found"
}

# game_dir: the folder holding project.godot: the project root, or the one folder below it that
# holds one (tools/dev.sh finds it the same way). Its .godot/ is Godot's cache.
game_dir() {
	local root found
	root=$(project_root)
	found=""
	[ -f "$root/project.godot" ] || found=$(sub_game "$root")
	printf '%s' "${found:-$root}"
}

# state_file <name>: a kit file in Godot's (git-ignored) cache folder: the stamp touched before
# each shell command, the list of game files Claude changed since the last check.
state_file() {
	printf '%s' "$(game_dir)/.godot/godot-accel-$1"
}

# have_json_reader: true when jq or python3 exists. Without both, the hooks that read their
# input do nothing, and the session-start card says so.
have_json_reader() {
	command -v jq >/dev/null 2>&1 || command -v python3 >/dev/null 2>&1
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

# json_string <text>: the text as a JSON string, via jq or python3 (for a hook's JSON output).
json_string() {
	if command -v jq >/dev/null 2>&1; then
		printf '%s' "$1" | jq -Rs .
	else
		printf '%s' "$1" | python3 -I -c 'import json, sys; print(json.dumps(sys.stdin.read()), end="")'
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

# bash_stamp: touched before each shell command, so the format + lint hook can find the files
# that command changed.
bash_stamp() {
	state_file bash.stamp
}
