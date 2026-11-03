#!/usr/bin/env bash
# PreToolUse (Bash): touches the stamp the format + lint hook uses to find the files a shell
# command changed. Shell writes to engine-owned files are refused by the deny rules bootstrap
# merges into the project's .claude/settings.json, which Claude Code applies to redirects, tee,
# sed and the other file commands it recognises (a regex here missed real writes and blocked
# harmless commands). Silent outside a Godot project.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
is_godot_project || exit 0
stamp=$(bash_stamp)
[ -d "${stamp%/*}" ] && touch "$stamp" 2>/dev/null
exit 0
