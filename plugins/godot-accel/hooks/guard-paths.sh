#!/usr/bin/env bash
# PreToolUse (Edit|Write|NotebookEdit): refuse edits to files Godot or other people own
# (path_block_reason in lib.sh). It works even where the project's settings lack the kit's deny
# rules. A path is checked from the project root and, when the game sits in a subfolder, from the
# game folder too (game/addons/ is protected like addons/). A file in another checkout of the
# same repository (another session's worktree, or the main checkout seen from a worktree) is
# checked from that checkout's root: its addons/ are protected too. Exit 2 blocks the edit and
# shows the reason to Claude. Silent outside a Godot project, or when the project registers its
# own copy.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
hook_start
is_godot_project || exit 0
project_has_own_hook guard-paths.sh && exit 0

file=$(json_field file_path "$HOOK_INPUT")
[ -n "$file" ] || file=$(json_field notebook_path "$HOOK_INPUT")
[ -n "$file" ] || exit 0

abs=$(norm_path "$file")
root=$(norm_path "$(project_root)")
game=$(norm_path "$(game_dir)")
# The nearest folder that exists (the file may be new, in a new folder), then its checkout.
dir=${abs%/*}
while [ -n "$dir" ] && [ ! -d "$dir" ]; do
	case "$dir" in */*) dir=${dir%/*} ;; *) dir="" ;; esac
done
own=$(project_in "${dir:-/}")
if [ -n "$own" ] && [ "$own" != "$root" ]; then
	own=$(norm_path "$own")
	game="$own${game#"$root"}"
	root=$own
fi
rel=${abs#"$root"/}
reason=$(path_block_reason "$rel")
if [ -z "$reason" ] && [ "$game" != "$root" ] && [ "${abs#"$game"/}" != "$abs" ]; then
	rel=${abs#"$game"/}
	reason=$(path_block_reason "$rel")
fi
if [ -n "$reason" ]; then
	echo "Blocked by godot-accel: $rel $reason" >&2
	exit 2
fi
exit 0
