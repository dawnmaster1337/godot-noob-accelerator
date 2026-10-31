#!/usr/bin/env bash
# PostToolUse (Edit|Write): format, then lint, the .gd file Claude just wrote. A lint failure
# exits 2 so Claude sees it and fixes it in the same turn. Without gdtoolkit (gdformat, gdlint)
# it does nothing: ship-check's lint step reports the missing tool instead.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
export PATH="$HOME/.local/bin:$PATH"

input=$(cat)
file=$(json_field file_path "$input")
case "$file" in *.gd) ;; *) exit 0 ;; esac
[ -f "$file" ] || exit 0
case "$file" in */addons/* | */.godot/*) exit 0 ;; esac
command -v gdformat >/dev/null 2>&1 && command -v gdlint >/dev/null 2>&1 || exit 0

# Best effort: a parse error here is reported by gdlint below.
gdformat "$file" >/dev/null 2>&1

if ! lint=$(gdlint "$file" 2>&1); then
	printf 'gdlint failed for %s. Fix these before moving on:\n%s\n' "$file" "$lint" >&2
	exit 2
fi
exit 0
