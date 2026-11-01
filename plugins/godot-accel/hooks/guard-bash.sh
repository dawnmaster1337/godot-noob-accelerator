#!/usr/bin/env bash
# PreToolUse (Bash): the editing-tool guard (guard-paths.sh) never sees a shell command, so this
# refuses a command that writes a protected file through a redirect (> or >>), tee, or an
# in-place sed/perl edit. Deleting or moving files (rm, mv, cp) is left alone: clearing Godot's
# cache is a normal fix. It also touches the stamp the format + lint hook uses after the command.
# Silent outside a Godot project, or when the project registers its own guard-bash.sh.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
is_godot_project || exit 0
root=$(project_root)
[ -d "$root/.godot" ] && touch "$(bash_stamp)" 2>/dev/null
project_has_own_hook guard-bash.sh && exit 0

input=$(cat)
cmd=$(json_field command "$input")
[ -n "$cmd" ] || exit 0

# Paths written by > >> or tee; with sed -i / perl -i, every word of the command.
targets=$(printf '%s\n' "$cmd" | grep -oE '(>>?|(^|[ |;&])tee( +-a)?) *[^ ;|&<>()]+' |
	sed -E 's/^[ |;&]*(>>?|tee( +-a)?) *//')
if printf '%s' "$cmd" | grep -qE '(^|[ |;&(])(sed|perl)( +-[a-zA-Z]+)* +-[a-zA-Z]*i'; then
	targets="$targets
$(printf '%s\n' "$cmd" | tr ' ;|&()' '\n\n\n\n\n\n')"
fi

while IFS= read -r t; do
	t=${t#\"}
	t=${t%\"}
	t=${t#\'}
	t=${t%\'}
	[ -n "$t" ] || continue
	t=${t#"$root"/}
	t=${t#./}
	reason=$(path_block_reason "$t")
	if [ -n "$reason" ]; then
		echo "Blocked by godot-accel: this command writes $t, which $reason If the user asked for exactly this, ask them to run it themselves." >&2
		exit 2
	fi
done < <(printf '%s\n' "$targets")
exit 0
