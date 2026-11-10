#!/usr/bin/env bash
# PreToolUse (Bash): writes the stamp the format + lint hook uses to find the files a shell
# command changed: its time is the cut-off, its content the commit HEAD was on (a command that
# moves HEAD, like a pull or checkout, brought its files from git). Shell writes to engine-owned files are a guard-rail of the deny rules bootstrap
# merges into the project's .claude/settings.json, which Claude Code applies to redirects, tee,
# sed and the other file commands it recognises (a regex here missed real writes and blocked
# harmless commands). Silent outside a Godot project.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
is_godot_project || exit 0
stamp=$(bash_stamp)
[ -d "${stamp%/*}" ] && git -C "$(project_root)" rev-parse -q --verify HEAD >"$stamp" 2>/dev/null
exit 0
