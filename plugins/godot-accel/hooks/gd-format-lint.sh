#!/usr/bin/env bash
# PostToolUse (Edit|Write|MultiEdit|Bash): format, then lint, the .gd files Claude just changed:
# the file an editing tool wrote, or every .gd file a shell command changed (newer than the stamp
# guard-bash.sh touched before it). A lint failure exits 2 so Claude sees it and fixes it in the
# same turn. Without gdtoolkit (gdformat, gdlint) it does nothing: ship-check's lint step reports
# the missing tool instead. Stands down when the project registers its own gd-format-lint.sh.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
export PATH="$HOME/.local/bin:$PATH"
project_has_own_hook gd-format-lint.sh && exit 0
command -v gdformat >/dev/null 2>&1 && command -v gdlint >/dev/null 2>&1 || exit 0

input=$(cat)
root=$(project_root)
files=()
if [ "$(json_top tool_name "$input")" = Bash ]; then
	is_godot_project || exit 0
	stamp=$(bash_stamp)
	[ -f "$stamp" ] || exit 0
	while IFS= read -r f; do files+=("$f"); done < <(
		cd "$root" && find . \( -path ./.godot -o -path ./.git -o -path ./addons -o -path ./inbox \) -prune \
			-o -type f -name '*.gd' -newer "$stamp" -print 2>/dev/null
	)
else
	file=$(json_field file_path "$input")
	case "$file" in *.gd) ;; *) exit 0 ;; esac
	case "$file" in */addons/* | */.godot/*) exit 0 ;; esac
	[ -f "$file" ] && files=("$file")
fi
[ ${#files[@]} -gt 0 ] || exit 0

failed=""
for f in "${files[@]}"; do
	case "$f" in /*) ;; *) f="$root/${f#./}" ;; esac
	# Best effort: a parse error here is reported by gdlint below.
	gdformat "$f" >/dev/null 2>&1
	lint=$(gdlint "$f" 2>&1) || failed="$failed$lint
"
done
if [ -n "$failed" ]; then
	printf 'gdlint failed. Fix these before moving on:\n%s' "$failed" >&2
	exit 2
fi
exit 0
