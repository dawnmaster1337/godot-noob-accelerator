#!/usr/bin/env bash
# PostToolUse (Edit|Write|Bash): notes the game files Claude just changed (scripts, scenes,
# resources, shaders) for the stop hook, then formats and lints the GDScript among them: the file
# an editing tool wrote, or every file a shell command changed (newer than the stamp
# shell-stamp.sh touched before it). After a shell command it only lints: that command may have
# been a git pull or checkout, or the user may have saved in Godot meanwhile, and their files are
# theirs. A lint failure exits 2 so Claude sees it and fixes it in the same turn. Without
# gdtoolkit (gdformat, gdlint) it only notes the files; the session-start card says lint is off.
# Its lint stands down when the project registers its own gd-format-lint.sh.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
export PATH="$HOME/.local/bin:$PATH"
is_godot_project || exit 0

input=$(cat)
root=$(project_root)
changed=()
format=1
if [ "$(json_top tool_name "$input")" = Bash ]; then
	format=0
	stamp=$(bash_stamp)
	[ -f "$stamp" ] || exit 0
	while IFS= read -r f; do changed+=("${f#./}"); done < <(
		cd "$root" && find . \( -name .godot -o -name .git -o -name addons -o -name inbox \) -prune -o -type f \
			\( -name '*.gd' -o -name '*.cs' -o -name '*.tscn' -o -name '*.tres' -o -name '*.gdshader' \) \
			-newer "$stamp" -print 2>/dev/null
	)
else
	file=$(json_field file_path "$input")
	case "$file" in */addons/* | */.godot/* | */inbox/*) exit 0 ;; esac
	case "$file" in *.gd | *.cs | *.tscn | *.tres | *.gdshader) [ -f "$file" ] && changed=("${file#"$root"/}") ;; esac
fi
[ ${#changed[@]} -gt 0 ] || exit 0

# Remembered until the next tools/dev.sh check, which empties the list (stop-check.sh reads it).
touched=$(state_file touched)
[ -d "${touched%/*}" ] && printf '%s\n' "${changed[@]}" >>"$touched"

project_has_own_hook gd-format-lint.sh && exit 0
command -v gdformat >/dev/null 2>&1 && command -v gdlint >/dev/null 2>&1 || exit 0
failed=""
for f in "${changed[@]}"; do
	case "$f" in *.gd) ;; *) continue ;; esac
	case "$f" in /*) ;; *) f="$root/$f" ;; esac
	# Best effort: a parse error here is reported by gdlint below.
	[ "$format" = 1 ] && gdformat "$f" >/dev/null 2>&1
	lint=$(gdlint "$f" 2>&1) || failed="$failed$lint
"
done
if [ -n "$failed" ]; then
	printf 'gdlint failed. Fix these before moving on:\n%s' "$failed" >&2
	exit 2
fi
exit 0
