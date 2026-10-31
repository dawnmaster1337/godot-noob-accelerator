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
