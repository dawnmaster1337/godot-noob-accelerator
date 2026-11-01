#!/usr/bin/env bash
# SessionStart (startup, resume, /clear, compaction): tells Claude how safe the work is in git,
# the user's uncommitted scene and resource edits, what waits in inbox/, what STATUS says is next
# and whether it is over budget, whether Godot is reachable, and the project's own standing guard
# (.claude/start-guard.md). Read-only: never fetches, pulls or pushes.
# Silent outside a Godot project or a project set up with the kit.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
root=$(project_root)
cd "$root" 2>/dev/null || exit 0
is_godot_project || [ -f docs/STATUS.md ] || exit 0

msg="[godot-accel] Session start."

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	changed=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
	msg="$msg Git: ${changed} uncommitted path(s)."
	if ! git remote get-url origin >/dev/null 2>&1; then
		msg="$msg NO remote: the work exists only on this machine; offer to set one up."
	else
		ahead=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo "?")
		msg="$msg ${ahead} commit(s) not pushed as of the last fetch. This is NOT a fetch: on resume, git fetch first; if behind, show the incoming commits and ask before git pull --ff-only."
	fi
	[ "$changed" != "0" ] && msg="$msg Uncommitted work: never discard it; suggest save-work before the session ends."
	# Scenes and resources changed outside a commit are most often the user's own editor work.
	edits=$(git status --porcelain 2>/dev/null | cut -c4- | grep -E '\.(tres|tscn)$' | head -10 | tr '\n' ' ')
	[ -n "$edits" ] && msg="$msg Uncommitted scene/resource edits, likely the user's own (re-read before editing, never revert; .claude/rules/tuning.md): ${edits}"
else
	msg="$msg Not a git repository yet: offer to set one up (nothing is backed up)."
fi

inbox=$(find inbox -type f ! -name README.md ! -name .gdignore ! -name .DS_Store 2>/dev/null | head -20 | tr '\n' ' ')
[ -n "$inbox" ] && msg="$msg Inbox has files to process (inbox/README.md): ${inbox}"

# STATUS 'Next' paragraph, whole, up to the next blank line.
next=$(awk '/^\*\*Next/{on=1} on&&/^$/{exit} on{printf "%s ", $0}' docs/STATUS.md 2>/dev/null | cut -c1-900)
[ -n "$next" ] && msg="$msg STATUS says: ${next}"
[ -f docs/STATUS.md ] || msg="$msg No docs/STATUS.md: the project is not bootstrapped (/godot-accel:bootstrap)."

# STATUS over its budget (from .claude/budgets.md, else 5,000 characters).
if [ -f docs/STATUS.md ]; then
	budget=$(awk -F'|' '$2 ~ /docs\/STATUS\.md/ {gsub(/[^0-9]/, "", $3); print $3; exit}' .claude/budgets.md 2>/dev/null)
	size=$(wc -m <docs/STATUS.md | tr -d ' ')
	[ "$size" -gt "${budget:-5000}" ] 2>/dev/null &&
		msg="$msg docs/STATUS.md is ${size} characters, over its ${budget:-5000} budget: trim it at the next save (trim-context)."
fi

if is_godot_project && ! command -v godot >/dev/null 2>&1; then
	msg="$msg 'godot' is not on PATH: headless checks can't run (docs/guides/setup-new-machine.md)."
fi

# The project's own standing guard, HTML comments stripped, capped.
if [ -f .claude/start-guard.md ]; then
	guard=$(sed -e 's/<!--.*-->//g' -e '/<!--/,/-->/d' .claude/start-guard.md | tr '\n' ' ' | tr -s ' ' | cut -c1-1200)
	case "$guard" in *[![:space:]]*) msg="$msg GUARD: ${guard}" ;; esac
fi

# Plain stdout is added to Claude's context for SessionStart.
printf '%s\n' "$msg"
exit 0
