#!/usr/bin/env bash
# UserPromptSubmit: repeats the rules the user has had to say twice (.claude/reminder.md, the
# text below its first --- line) with every message, so they keep their weight in long sessions.
# Silent when that text is empty, outside a Godot project, or when the project registers its own
# copy of this hook.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
is_godot_project || exit 0
project_has_own_hook prompt-reminder.sh && exit 0
file="$(project_root)/.claude/reminder.md"
[ -f "$file" ] || exit 0
text=$(awk 'on { print } /^---$/ { on = 1 }' "$file" | tr '\n' ' ' | tr -s ' ' | sed 's/^ //' | cut -c1-1000)
case "$text" in *[![:space:]]*) ;; *) exit 0 ;; esac
# Plain stdout is added to Claude's context for UserPromptSubmit.
printf '[godot-accel] Rules the user has had to repeat: %s\n' "$text"
exit 0
