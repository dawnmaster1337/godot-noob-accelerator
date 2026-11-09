#!/usr/bin/env bash
# SessionStart (startup, resume, /clear, compaction): tells Claude how safe the work is in git,
# the user's uncommitted scene and resource edits, what waits in inbox/, what STATUS says is next
# and whether it is over budget, whether the project's kit version is behind the plugin, whether
# Godot and the hooks' own tools are reachable, whether the project's settings carry the kit's
# deny rules, and the project's own standing guard (.claude/start-guard.md). Read-only: never
# fetches, pulls or pushes.
# Outside a kit project it stays silent, unless one sits just above or below the start folder:
# then it says where, because every hook, project skill, agent and rule loads from the start
# folder and would otherwise be off without a word.
set -u
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
root=$(project_root)
cd "$root" 2>/dev/null || exit 0
if ! is_godot_project && [ ! -f docs/STATUS.md ]; then
	# A kit project is a folder with both project.godot and docs/STATUS.md.
	found=""
	dir=$root
	for _ in 1 2 3; do
		dir=$(dirname "$dir")
		[ -f "$dir/docs/STATUS.md" ] && { [ -f "$dir/project.godot" ] || [ -d "$dir/.claude/godot-accel" ]; } &&
			found="$dir" && break
	done
	if [ -z "$found" ]; then
		found=$(find . -maxdepth 3 \( -path '*/.*' -o -name node_modules \) -prune -o -name project.godot -print 2>/dev/null |
			while IFS= read -r p; do
				d=$(dirname "$p")
				# The kit files sit beside project.godot, or one folder up (a game/ subfolder).
				[ -f "$d/docs/STATUS.md" ] || d=$(dirname "$d")
				[ -f "$d/docs/STATUS.md" ] && printf '%s\n' "$root/${d#./}"
			done)
	fi
	# Only one candidate is a clear mistake; several means a workspace folder: stay quiet.
	[ -n "$found" ] && [ "$(printf '%s\n' "$found" | wc -l)" -eq 1 ] || exit 0
	printf '%s\n' "[godot-accel] This session started in $root, but the kit project is at $found. The kit's hooks and the project's skills, agents and rules load only from the folder a session starts in, so they are off here. If the user is here to work on that game, tell them first: start Claude Code in $found (desktop app: open that folder), then say resume."
	exit 0
fi

# Started in the game/ folder of a project whose kit files sit one folder up.
if [ ! -f docs/STATUS.md ] && [ -f ../docs/STATUS.md ] && [ -d ../.claude/godot-accel ]; then
	up=$(cd .. && pwd)
	printf '%s\n' "[godot-accel] This session started in the game folder $root, but the kit project is $up. The kit's hooks and the project's skills, agents and rules load only from the folder a session starts in. Tell the user first: start Claude Code in $up (desktop app: open that folder), then say resume."
	exit 0
fi

msg="[godot-accel] Session start."

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	changed=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
	msg="$msg Git: ${changed} uncommitted path(s)."
	# No commit yet: everything is new, nothing is the user's edit of a saved file.
	git rev-parse --verify -q HEAD >/dev/null 2>&1 || {
		fresh=1
		msg="$msg No commits yet: nothing is saved in git; suggest a first save-work."
	}
	if ! git remote get-url origin >/dev/null 2>&1; then
		msg="$msg NO remote: the work exists only on this machine; offer to set one up."
	else
		ahead=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo "?")
		msg="$msg ${ahead} commit(s) not pushed as of the last fetch. This is NOT a fetch: on resume, git fetch first; if behind, show the incoming commits and ask before git pull --ff-only."
	fi
	[ "$changed" != "0" ] && msg="$msg Uncommitted work: never discard it; suggest save-work before the session ends."
	# Scenes and resources changed outside a commit are most often the user's own editor work.
	edits=$(git status --porcelain 2>/dev/null | cut -c4- | grep -E '\.(tres|tscn)$' | head -10 | tr '\n' ' ')
	[ -n "$edits" ] && [ -z "${fresh:-}" ] && msg="$msg Uncommitted scene/resource edits, likely the user's own (re-read before editing, never revert; .claude/rules/tuning.md): ${edits}"
else
	msg="$msg Not a git repository yet: offer to set one up (nothing is backed up)."
fi

inbox=$(find inbox -type f ! -name README.md ! -name .gdignore ! -name .DS_Store 2>/dev/null | head -20 | tr '\n' ' ')
[ -n "$inbox" ] && msg="$msg Inbox has files to process (inbox/README.md): ${inbox}"

# STATUS 'Next' paragraph, whole, up to the next blank line.
next=$(awk '/^\*\*Next/{on=1} on&&/^$/{exit} on{printf "%s ", $0}' docs/STATUS.md 2>/dev/null | cut -c1-900)
[ -n "$next" ] && msg="$msg STATUS says: ${next}"
[ -f docs/STATUS.md ] || msg="$msg No docs/STATUS.md: the project is not on the kit's shape. A new project: /godot-accel:bootstrap; one with its own docs, rules or notes: /godot-accel:realign (it moves them into the kit's homes, keeping every fact)."

# The kit's shape (.claude/godot-accel/shape.md): only the count here; tools/dev.sh conform lists them.
if [ -f .claude/godot-accel/shape.md ] && grep -q '^conform()' tools/dev.sh 2>/dev/null; then
	problems=$(bash tools/dev.sh conform 2>/dev/null | grep -c '^conform: .*:' | tr -d ' ')
	[ "${problems:-0}" -gt 0 ] 2>/dev/null &&
		msg="$msg SHAPE: tools/dev.sh conform finds ${problems} problem(s) (docs out of their homes or form): suggest /godot-accel:realign."
fi

# STATUS over its budget (from .claude/budgets.md, else 5,000 characters).
if [ -f docs/STATUS.md ]; then
	budget=$(awk -F'|' '$2 ~ /docs\/STATUS\.md/ {gsub(/[^0-9]/, "", $3); print $3; exit}' .claude/budgets.md 2>/dev/null)
	size=$(wc -m <docs/STATUS.md | tr -d ' ')
	[ "$size" -gt "${budget:-5000}" ] 2>/dev/null &&
		msg="$msg docs/STATUS.md is ${size} characters, over its ${budget:-5000} budget: trim it at the next save (trim-context)."
fi

# Kit version: the project's stamp (written by bootstrap and update) against this plugin's.
if [ -d .claude/godot-accel ] || [ -f .claude/budgets.md ]; then
	kit=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$(dirname "$0")/../.claude-plugin/plugin.json" | head -1)
	mine=""
	[ -f .claude/godot-accel/kit-version ] && mine=$(tr -d '[:space:]' <.claude/godot-accel/kit-version)
	if [ -z "$mine" ]; then
		msg="$msg KIT: this project was set up with a kit older than 0.3.0 (no .claude/godot-accel/kit-version); the kit is now ${kit}. Suggest /godot-accel:update to bring in the newer rules and templates."
	elif [ -n "$kit" ] && [ "$mine" != "$kit" ]; then
		# A pre-release (0.6.0-beta.1) sorts before its release: "~" does that in sort -V, "-" doesn't.
		newest=$(printf '%s\n%s\n' "${mine//-/\~}" "${kit//-/\~}" | sort -V | tail -1)
		if [ "$newest" = "${kit//-/\~}" ]; then
			msg="$msg KIT: this project is on kit ${mine}; the kit is now ${kit}. Suggest /godot-accel:update."
		else
			msg="$msg KIT: this project was updated with kit ${mine}, but this machine's plugin is ${kit}: suggest /plugin marketplace update godot-accel."
		fi
	fi
fi

# What the kit's checks need on this machine. Missing, they are off without a word, so say it.
if is_godot_project; then
	command -v godot >/dev/null 2>&1 ||
		msg="$msg 'godot' is not on PATH: headless checks can't run (docs/guides/setup-new-machine.md)."
	have_json_reader ||
		msg="$msg Neither jq nor python3 is installed: the kit's file guard and lint hooks are OFF. Tell the user: install jq (Linux: the package manager; macOS: brew install jq)."
	PATH="$HOME/.local/bin:$PATH" command -v gdlint >/dev/null 2>&1 ||
		msg="$msg gdtoolkit is not installed: GDScript is not linted or formatted. Tell the user: pipx install 'gdtoolkit==4.*'."
	[ -f tools/dev.sh ] && ! grep -qs 'godot-accel-touched' tools/dev.sh &&
		msg="$msg tools/dev.sh predates the kit's stop check (it never clears its list), so that check is off until /godot-accel:update."
	[ -f tools/dev.sh ] && ! grep -qsF 'Edit(.godot/**)' .claude/settings.json &&
		msg="$msg .claude/settings.json lacks the kit's deny rules (shell writes to Godot's files, secrets reads): suggest /godot-accel:update."
fi

# The project's own standing guard, HTML comments stripped, capped.
if [ -f .claude/start-guard.md ]; then
	guard=$(sed -e 's/<!--.*-->//g' -e '/<!--/,/-->/d' .claude/start-guard.md | tr '\n' ' ' | tr -s ' ' | cut -c1-1200)
	case "$guard" in *[![:space:]]*) msg="$msg GUARD: ${guard}" ;; esac
fi

# Where the kit's templates are, for a home the shape marks "first use" that doesn't exist yet.
[ -f .claude/godot-accel/shape.md ] &&
	msg="$msg Kit templates (for a first-use home in .claude/godot-accel/shape.md): $(cd "$(dirname "$0")/.." && pwd)/skills/bootstrap/templates/"

# Plain stdout is added to Claude's context for SessionStart.
printf '%s\n' "$msg"
exit 0
