#!/usr/bin/env bash
# One entry point for the project's checks. Run from the project root: tools/dev.sh <verb>.
# Written by the {{KIT_NAME}} bootstrap; grow it with your own verbs.
set -u
cd "$(dirname "$0")/.." || exit 1

usage() {
	cat <<'EOF'
tools/dev.sh <verb> [args]
  check [--refresh] [name...]
                      refresh if files changed, then every tests/*_check.tscn headless (exit 1 =
                      a failure); names run only those checks (`dev.sh check player`);
                      --refresh forces the refresh (after deleting or renaming a class_name)
  refresh             rebuild Godot's class cache and imports (after a new class_name or asset)
  lint [all|file...]  gdlint + gdformat --check on changed .gd files (all: the whole project)
  stale [file...]     backticked paths in the always-read docs that no longer exist
  budget              files over their .claude/budgets.md budget, lines over 400 characters
  tidy                what has drifted: unsaved files, docs and code out of place, unused
                      scripts and scenes, long scripts, finished plans (project-audit reads it)
EOF
}

# limit <seconds> <cmd...>: run a command with a time limit (timeout, else perl, else none).
limit() {
	local seconds=$1
	shift
	if command -v timeout >/dev/null 2>&1; then
		timeout "$seconds" "$@"
	elif command -v perl >/dev/null 2>&1; then
		perl -e 'alarm shift; exec @ARGV' "$seconds" "$@"
	else
		"$@"
	fi
}

# headless <seconds> <godot args...>: one headless Godot run that never waits on stdin.
headless() {
	local seconds=$1
	shift
	limit "$seconds" godot --headless --path . "$@" </dev/null
}

need_godot() {
	command -v godot >/dev/null 2>&1 && return 0
	echo "godot is not on your PATH (docs/guides/setup-new-machine.md, step 1)"
	return 1
}

# A refresh costs two headless editor runs, so check skips it while nothing it reads has changed.
STAMP=.godot/dev-refresh.stamp

needs_refresh() {
	[ -f "$STAMP" ] || return 0
	[ -n "$(find . \( -path ./.godot -o -path ./.git -o -path ./inbox \) -prune -o -type f -newer "$STAMP" \
		\( -name '*.gd' -o -name '*.cs' -o -name '*.tscn' -o -name '*.tres' -o -name '*.res' \
		-o -name '*.gdshader' -o -name '*.png' -o -name '*.jpg' -o -name '*.webp' -o -name '*.svg' \
		-o -name '*.ogg' -o -name '*.wav' -o -name '*.mp3' -o -name '*.glb' -o -name '*.gltf' \
		-o -name '*.blend' -o -name '*.ttf' -o -name '*.otf' -o -name '*.csv' -o -name project.godot \) \
		-print -quit 2>/dev/null)" ]
}

refresh() {
	need_godot || return 1
	local log fail=0 step
	log=$(mktemp)
	for step in "--editor --quit" "--import"; do
		# shellcheck disable=SC2086
		if ! headless 300 $step >"$log" 2>&1 || grep -q "SCRIPT ERROR\|Parse Error" "$log"; then
			echo "FAIL godot --headless $step"
			grep -E "SCRIPT ERROR|Parse Error|ERROR" "$log" | head -5
			fail=1
		fi
	done
	rm -f "$log"
	[ "$fail" = 0 ] && mkdir -p .godot && touch "$STAMP"
	return $fail
}

# run_check <tests/x_check.tscn>: prints only a failure; returns 1 on one.
run_check() {
	local scene=$1 log code
	log=$(mktemp)
	headless 120 "res://$scene" >"$log" 2>&1
	code=$?
	if [ "$code" -ne 0 ] || grep -q "SCRIPT ERROR" "$log"; then
		echo "FAIL $scene (exit $code)"
		grep -E "FAIL|SCRIPT ERROR|failed" "$log" | head -5
		rm -f "$log"
		return 1
	fi
	rm -f "$log"
	return 0
}

check() {
	local fail=0 name scene count=0
	if [ "${1:-}" = --refresh ]; then
		shift
		rm -f "$STAMP"
	fi
	if needs_refresh; then refresh || fail=1; fi
	if [ $# -gt 0 ]; then
		for name in "$@"; do
			scene="tests/${name%_check}_check.tscn"
			[ -e "$scene" ] || { echo "no check $scene"; fail=1; continue; }
			run_check "$scene" || fail=1
			count=$((count + 1))
		done
	else
		for scene in tests/*_check.tscn; do
			[ -e "$scene" ] || continue
			run_check "$scene" || fail=1
			count=$((count + 1))
		done
	fi
	[ "$fail" = 0 ] && echo "all $count check(s) passed"
	return $fail
}

lint() {
	command -v gdlint >/dev/null 2>&1 || { echo "gdtoolkit missing: pipx install 'gdtoolkit==4.*'"; return 1; }
	local files=()
	if [ "${1:-}" = all ]; then
		while IFS= read -r f; do files+=("$f"); done < <(git ls-files '*.gd' | grep -v '^addons/')
	elif [ $# -gt 0 ]; then
		files=("$@")
	else
		while IFS= read -r f; do
			files+=("$f")
		done < <({
			git diff --name-only --diff-filter=d HEAD 2>/dev/null
			git ls-files --others --exclude-standard
		} | grep '\.gd$' | grep -v '^addons/' | sort -u)
	fi
	[ ${#files[@]} -gt 0 ] || { echo "no .gd files to lint"; return 0; }
	gdlint "${files[@]}" && gdformat --check "${files[@]}"
}

stale() {
	[ $# -eq 0 ] && set -- CLAUDE.md AGENTS.md docs/STATUS.md .claude/memory/*.md .claude/rules/*.md
	grep -oHE '`[A-Za-z0-9_./-]+\.(md|gd|cs|py|sh|tscn|tres|json|png|txt|cfg)`' "$@" 2>/dev/null | tr -d '`' |
		while IFS=: read -r src path; do
			[ -e "$path" ] && continue
			case "$path" in -* | *YYYY* | *'<'*) continue ;; esac
			# A shortened path only has to end a tracked path.
			git ls-files | grep -qE "(^|/)$path\$" && continue
			echo "$src: $path"
		done | sort -u
}

# used_by <text> <file>: does any scene, resource, script or project.godot other than <file>
# contain <text>? (Godot's cache and git's folder don't count.)
used_by() {
	grep -rlsF --include='*.tscn' --include='*.tres' --include='*.gd' --include='*.cs' \
		--include=project.godot --exclude-dir=.godot --exclude-dir=.git -e "$1" . |
		grep -vxF "./$2" | grep -q .
}

# tidy: things that drift as sessions come and go. It only reports; project-audit decides.
tidy() {
	local n=0 layout f cls
	# section <title> <lines>: print a titled list, count its items.
	section() {
		[ -n "$2" ] || return 0
		printf '%s (%s):\n%s\n' "$1" "$(printf '%s\n' "$2" | wc -l | tr -d ' ')" "$(printf '%s\n' "$2" | sed 's/^/  /')"
		n=$((n + $(printf '%s\n' "$2" | wc -l)))
	}
	section "Not in git yet: commit them (Godot's .uid files belong in git) or add them to .gitignore" \
		"$(git ls-files --others --exclude-standard 2>/dev/null | grep -v '^inbox/')"
	section "Docs outside docs/ (each fact has one home: CLAUDE.md's table)" \
		"$(git ls-files --cached --others --exclude-standard '*.md' 2>/dev/null |
			grep -vE '^(docs|\.claude|inbox|addons)/|^(README|CLAUDE|AGENTS|CHANGELOG|CONTRIBUTING|LICENSE)[^/]*$|/README\.md$')"
	# Top-level folders CLAUDE.md's "Project layout" names; code anywhere else has wandered.
	layout=$(awk '/^## Project layout/{on=1; next} /^## /{on=0} on' CLAUDE.md 2>/dev/null |
		grep -oE '`[A-Za-z0-9_.-]+/' | tr -d '`/' | sort -u)
	if [ -n "$layout" ]; then
		section "Code outside the folders CLAUDE.md's layout names" \
			"$(git ls-files '*.gd' '*.cs' '*.tscn' '*.tres' 2>/dev/null |
				grep -vE '^(addons|tests|tools)/' | while IFS= read -r f; do
					printf '%s\n' "$layout" | grep -qxF "${f%%/*}" || echo "$f"
				done)"
	fi
	# Used = some other scene, resource, script or project.godot names its file or its class_name.
	section "Never used by any scene, script or project.godot" \
		"$(git ls-files '*.gd' '*.tscn' 2>/dev/null | grep -vE '^(addons|tests)/' | while IFS= read -r f; do
			used_by "${f##*/}" "$f" && continue
			cls=$(sed -n 's/^class_name \([A-Za-z0-9_]*\).*/\1/p' "$f" 2>/dev/null | head -1)
			[ -n "$cls" ] && used_by "$cls" "$f" && continue
			echo "$f"
		done)"
	section "Scripts over 300 lines (split out a helper)" \
		"$(git ls-files '*.gd' 2>/dev/null | grep -v '^addons/' | while IFS= read -r f; do
			[ "$(wc -l <"$f")" -gt 300 ] && echo "$f ($(wc -l <"$f" | tr -d ' ') lines)"
		done)"
	section "Finished plans still in docs/plans/ (move them to docs/archive/plans/)" \
		"$(for f in docs/plans/*.md; do
			case "$f" in */roadmap.md | */_template.md) continue ;; esac
			[ -f "$f" ] && grep -q '^- \[x\]' "$f" && ! grep -q '^- \[ \]' "$f" && echo "$f"
		done)"
	section "class_name used twice" \
		"$(git ls-files '*.gd' 2>/dev/null | xargs grep -h '^class_name ' 2>/dev/null |
			awk '{print $2}' | sort | uniq -d)"
	echo "tidy: $n item(s) to look at"
	return 0
}

# budget_rules: "<glob> <characters>" per budgeted file, from .claude/budgets.md (else defaults).
budget_rules() {
	if [ -f .claude/budgets.md ]; then
		awk -F'|' 'NF > 3 && $2 ~ /`/ {
			n = $3; gsub(/[^0-9]/, "", n); if (n == "") next
			s = $2
			while (match(s, /`[^`]+`/)) { print substr(s, RSTART + 1, RLENGTH - 2), n; s = substr(s, RSTART + RLENGTH) }
		}' .claude/budgets.md
	else
		printf '%s\n' "CLAUDE.md 8000" "docs/STATUS.md 5000" ".claude/memory/MEMORY.md 2000" \
			".claude/memory/*.md 1200" ".claude/rules/*.md 3000"
	fi
}

budget() {
	local seen=" " problems=0 count=0 glob limit f size pass
	# Pass 1: rows naming one file; pass 2: glob rows, for files no row named. No here-strings or
	# here-docs: they need a writable temp folder, which a sandbox may not give.
	for pass in exact glob; do
		while read -r glob limit; do
			case "$glob" in *'*'*) [ "$pass" = glob ] || continue ;; *) [ "$pass" = exact ] || continue ;; esac
			for f in $glob; do
				[ -f "$f" ] || continue
				case "$seen" in *" $f "*) continue ;; esac
				[ "$pass" = glob ] && [ "${f##*/}" = README.md ] && continue
				seen="$seen$f "
				count=$((count + 1))
				size=$(wc -m <"$f" | tr -d ' ')
				if [ "$size" -gt "$limit" ]; then
					echo "over budget: $f $size/$limit characters"
					problems=$((problems + 1))
				fi
			done
		done < <(budget_rules)
	done
	local long
	long=$(awk 'length > 400 {print FILENAME ":" FNR ": " length " characters"}' \
		CLAUDE.md docs/STATUS.md .claude/rules/*.md .claude/memory/*.md 2>/dev/null)
	if [ -n "$long" ]; then
		echo "$long" | sed 's/^/line over 400: /'
		problems=$((problems + $(echo "$long" | wc -l)))
	fi
	if [ "$problems" = 0 ]; then
		echo "budget: $count file(s) within budget"
		return 0
	fi
	echo "budget: $problems problem(s)"
	return 1
}

verb=${1:-help}
[ $# -gt 0 ] && shift
case "$verb" in
	check) check "$@" ;;
	refresh) refresh ;;
	lint) lint "$@" ;;
	stale) stale "$@" ;;
	budget) budget ;;
	tidy) tidy ;;
	*) usage ;;
esac
