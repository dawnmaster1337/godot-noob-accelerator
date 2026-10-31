#!/usr/bin/env bash
# One entry point for the project's checks. Run from the project root: tools/dev.sh <verb>.
# Written by the {{KIT_NAME}} bootstrap; grow it with your own verbs.
set -u
cd "$(dirname "$0")/.." || exit 1

usage() {
	cat <<'EOF'
tools/dev.sh <verb> [args]
  check [name...]     refresh, then every tests/*_check.tscn headless (exit 1 = a failure);
                      names run only those checks (`dev.sh check player`)
  refresh             rebuild Godot's class cache and imports (after a new class_name or asset)
  lint [all|file...]  gdlint + gdformat --check on changed .gd files (all: the whole project)
  stale [file...]     backticked paths in the always-read docs that no longer exist
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
	refresh || fail=1
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
	[ $# -eq 0 ] && set -- CLAUDE.md AGENTS.md docs/STATUS.md .claude/memory/*.md .claude/rules/*.md docs/guides/llm-handoff.md
	grep -oHE '`[A-Za-z0-9_./-]+\.(md|gd|cs|py|sh|tscn|tres|json|png|txt|cfg)`' "$@" 2>/dev/null | tr -d '`' |
		while IFS=: read -r src path; do
			[ -e "$path" ] && continue
			case "$path" in -* | *YYYY* | *'<'*) continue ;; esac
			# A shortened path only has to end a tracked path.
			git ls-files | grep -qE "(^|/)$path\$" && continue
			echo "$src: $path"
		done | sort -u
}

verb=${1:-help}
[ $# -gt 0 ] && shift
case "$verb" in
	check) check "$@" ;;
	refresh) refresh ;;
	lint) lint "$@" ;;
	stale) stale "$@" ;;
	*) usage ;;
esac
