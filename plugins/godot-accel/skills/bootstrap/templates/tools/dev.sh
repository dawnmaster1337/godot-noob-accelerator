#!/usr/bin/env bash
# One entry point for the project's checks. Run from the project root: tools/dev.sh <verb>.
# Written by the {{KIT_NAME}} bootstrap; grow it with your own verbs.
set -u
cd "$(dirname "$0")/.." || exit 1

# GAME: the folder holding project.godot: the repo root, or the one folder below it that holds
# one (a game/ beside other work). res://, tests/, addons/ and .godot/ live inside it; G is its
# prefix in repo paths ("" at the root).
GAME=.
if [ ! -f project.godot ]; then
	found=$(ls -d -- */project.godot 2>/dev/null)
	[ "$(printf '%s\n' "$found" | grep -c .)" = 1 ] && GAME=${found%/project.godot}
fi
G=""
[ "$GAME" = . ] || G="$GAME/"

usage() {
	cat <<'EOF'
tools/dev.sh <verb> [args]
  check [--refresh] [name...]
                      refresh if files changed, then every tests/*_check.tscn headless (the smoke
                      check among them), and the GUT or gdUnit4 tests when that addon is
                      installed (exit 1 = a failure, or no checks at all); names run only those
                      (`dev.sh check player`); --refresh forces the refresh
  refresh             rebuild Godot's class cache and imports (after a new class_name or asset)
  lint [all|file...]  gdlint + gdformat --check on changed .gd files (all: the whole project)
  stale [file...]     backticked paths in the live docs (the shape's live rows) that no longer
                      exist (exit 1 = some)
  conform [decisions] does the project match .claude/godot-accel/shape.md: every home there,
                      its headings, its entry format, no undeclared docs (exit 1 = a problem);
                      decisions: only the decision records against their index
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
	limit "$seconds" godot --headless --path "$GAME" "$@" </dev/null
}

need_godot() {
	command -v godot >/dev/null 2>&1 && return 0
	echo "godot is not on your PATH (docs/guides/setup-new-machine.md, step 1)"
	return 1
}

# A refresh costs a headless import run, so check skips it while nothing it reads has changed.
STAMP="$GAME/.godot/dev-refresh.stamp"

needs_refresh() {
	[ -f "$STAMP" ] || return 0
	[ -n "$(find "$GAME" \( -path "$GAME/.godot" -o -path ./.git -o -path ./inbox \) -prune -o -type f -newer "$STAMP" \
		\( -name '*.gd' -o -name '*.cs' -o -name '*.tscn' -o -name '*.tres' -o -name '*.res' \
		-o -name '*.gdshader' -o -name '*.png' -o -name '*.jpg' -o -name '*.webp' -o -name '*.svg' \
		-o -name '*.ogg' -o -name '*.wav' -o -name '*.mp3' -o -name '*.glb' -o -name '*.gltf' \
		-o -name '*.blend' -o -name '*.ttf' -o -name '*.otf' -o -name '*.csv' -o -name project.godot \) \
		-print -quit 2>/dev/null)" ]
}

refresh() {
	need_godot || return 1
	local log fail=0
	log=$(mktemp)
	# --import also rebuilds the class_name cache, a renamed or deleted class included (4.7.2).
	if ! headless 300 --import >"$log" 2>&1 || grep -q "SCRIPT ERROR\|Parse Error" "$log"; then
		echo "FAIL godot --headless --import"
		grep -E "SCRIPT ERROR|Parse Error|ERROR" "$log" | head -5
		fail=1
	fi
	rm -f "$log"
	[ "$fail" = 0 ] && mkdir -p "$GAME/.godot" && touch "$STAMP"
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

# gut_check [name...]: the GUT tests (all, or the files whose names match), one headless run each.
# A .gutconfig.json in the game folder sets where the tests are; else res://tests.
gut_check() {
	local log code fail=0 sel args=(-s addons/gut/gut_cmdln.gd -gexit)
	[ -f "$GAME/.gutconfig.json" ] || args+=(-gdir=res://tests)
	log=$(mktemp)
	[ $# -gt 0 ] || set -- ""
	for sel in "$@"; do
		if [ -n "$sel" ]; then
			headless 600 "${args[@]}" "-gselect=$sel" >"$log" 2>&1
		else
			headless 600 "${args[@]}" >"$log" 2>&1
		fi
		code=$?
		if [ "$code" -ne 0 ] || grep -q "SCRIPT ERROR" "$log"; then
			echo "FAIL GUT ${sel:-all tests} (exit $code)"
			grep -E "\[Failed\]|FAILED|SCRIPT ERROR|Failing" "$log" | head -8
			fail=1
		fi
	done
	rm -f "$log"
	[ "$fail" = 0 ] && echo "GUT: all tests passed"
	return $fail
}

# gdunit4_check [name...]: the gdUnit4 tests (all of tests/, or tests/<name>_test.gd), through the
# addon's own runner, which needs GODOT_BIN and refuses headless mode unless told (tests that send
# input events need a window). Exit 0 passes; 101 is warnings only (gdUnit4 6.2).
gdunit4_check() {
	local log code fail=0 sel target
	need_godot || return 1
	log=$(mktemp)
	[ $# -gt 0 ] || set -- ""
	for sel in "$@"; do
		target=res://tests
		[ -n "$sel" ] && target="res://tests/${sel%_test}_test.gd"
		(cd "$GAME" && GODOT_BIN=$(command -v godot) limit 600 bash addons/gdUnit4/runtest.sh \
			--headless --ignoreHeadlessMode -a "$target") >"$log" 2>&1 </dev/null
		code=$?
		if { [ "$code" -ne 0 ] && [ "$code" -ne 101 ]; } || grep -q "SCRIPT ERROR" "$log"; then
			echo "FAIL gdUnit4 ${sel:-all tests} (exit $code)"
			grep -E "FAILED|SCRIPT ERROR|Failed|ERROR" "$log" | head -8
			fail=1
		fi
	done
	rm -f "$log"
	[ "$fail" = 0 ] && echo "gdUnit4: all tests passed"
	return $fail
}

check() {
	local fail=0 name scene f count=0
	if [ "${1:-}" = --refresh ]; then
		shift
		rm -f "$STAMP"
	fi
	# The kit's stop hook asks for a check after Claude changes game files; this run answers it.
	rm -f "$GAME/.godot/godot-accel-touched" "$GAME/.godot/godot-accel-touched.asked"
	if needs_refresh; then refresh || fail=1; fi
	local framework=""
	[ -f "$GAME/addons/gut/gut_cmdln.gd" ] && framework=gut
	[ -f "$GAME/addons/gdUnit4/runtest.sh" ] && framework=gdunit4
	if [ $# -gt 0 ]; then
		local picked=()
		for name in "$@"; do
			scene="tests/${name%_check}_check.tscn"
			if [ -e "$GAME/$scene" ]; then
				run_check "$scene" || fail=1
				count=$((count + 1))
			elif [ -n "$framework" ]; then
				picked+=("$name")
			else
				echo "no check $G$scene"
				fail=1
			fi
		done
		if [ ${#picked[@]} -gt 0 ]; then
			"${framework}_check" "${picked[@]}" || fail=1
			count=$((count + ${#picked[@]}))
		fi
	else
		for f in "$GAME"/tests/*_check.tscn; do
			[ -e "$f" ] || continue
			scene=${f#"$GAME"/}
			run_check "$scene" || fail=1
			count=$((count + 1))
		done
		if [ -n "$framework" ]; then
			"${framework}_check" || fail=1
			count=$((count + 1))
		fi
	fi
	# Nothing ran is not a pass: a green run must have checked something.
	if [ "$count" = 0 ]; then
		echo "FAIL no checks ran: tests/ has no *_check.tscn (bootstrap writes tests/smoke_check.tscn) and no GUT or gdUnit4"
		return 1
	fi
	[ "$fail" = 0 ] && echo "all $count check run(s) passed"
	return $fail
}

lint() {
	command -v gdlint >/dev/null 2>&1 || { echo "gdtoolkit missing: pipx install 'gdtoolkit==4.*'"; return 1; }
	local files=()
	if [ "${1:-}" = all ]; then
		while IFS= read -r f; do files+=("$f"); done < <(git ls-files '*.gd' | grep -v "^${G}addons/")
	elif [ $# -gt 0 ]; then
		files=("$@")
	else
		while IFS= read -r f; do
			files+=("$f")
		done < <({
			git diff --name-only --diff-filter=d HEAD 2>/dev/null
			git ls-files --others --exclude-standard
		} | grep '\.gd$' | grep -v "^${G}addons/" | sort -u)
	fi
	[ ${#files[@]} -gt 0 ] || { echo "no .gd files to lint"; return 0; }
	gdlint "${files[@]}" && gdformat --check "${files[@]}"
}

SHAPE=.claude/godot-accel/shape.md

# shape_rows: "<path>|<kind>|<headings>|<entries>|<made>" for each row of the shape file. Made is
# "setup" (bootstrap writes it) or "first use" (made when first needed); a row without that
# column (an older shape) counts as setup.
shape_rows() {
	awk -F'|' 'NF > 5 && $3 ~ /`/ {
		p = $3; sub(/^[^`]*`/, "", p); sub(/`.*/, "", p)
		k = $4; gsub(/[ `]/, "", k)
		h = $5; gsub(/^ +| +$/, "", h)
		e = $6; gsub(/[ `]/, "", e)
		m = (NF > 7) ? $7 : ""; gsub(/^ +| +$/, "", m); if (m == "") m = "setup"
		print p "|" k "|" h "|" e "|" m
	}' "$SHAPE"
}

# live_docs: every file of a live row (the markdown pages, for a folder row).
live_docs() {
	local path kind heads entries made
	while IFS='|' read -r path kind heads entries made; do
		[ "$kind" = live ] || continue
		case "$path" in
		*/) [ -d "$path" ] && find "$path" -type f -name '*.md' | sort ;;
		*) [ -f "$path" ] && echo "$path" ;;
		esac
	done < <(shape_rows)
}

stale() {
	local docs=() f found known
	if [ $# -eq 0 ]; then
		if [ -f "$SHAPE" ]; then
			while IFS= read -r f; do docs+=("$f"); done < <(live_docs)
		else
			docs=(CLAUDE.md AGENTS.md docs/STATUS.md .claude/memory/*.md .claude/rules/*.md)
		fi
		[ ${#docs[@]} -gt 0 ] || return 0
		set -- "${docs[@]}"
	fi
	# Files on disk count, git-ignored ones too (a data folder named in a doc); Godot's cache doesn't.
	known=$(git ls-files --cached --others 2>/dev/null | grep -v '\.godot/')
	# A first-use home not made yet may be named before it exists.
	local later="" path kind heads entries made
	if [ -f "$SHAPE" ]; then
		while IFS='|' read -r path kind heads entries made; do
			[ "$made" = "first use" ] && [ ! -e "$path" ] && later="$later$path
"
		done < <(shape_rows)
	fi
	found=$(grep -oHE '`[A-Za-z0-9_./-]+\.(md|gd|cs|py|sh|tscn|tres|json|png|svg|txt|cfg|csv|gdshader|glb|ogg|wav)`' "$@" 2>/dev/null | tr -d '`' |
		while IFS=: read -r src path; do
			[ -e "$path" ] || [ -e "$GAME/$path" ] && continue
			case "$path" in /* | -* | *YYYY* | *'<'*) continue ;; esac
			printf '%s' "$later" | while IFS= read -r p; do
				case "$path" in "$p" | "${p%/}"/*) echo y ;; esac
			done | grep -q y && continue
			# A shortened path only has to end a known path.
			printf '%s\n' "$known" | grep -qE "(^|/)$path\$" && continue
			echo "$src: $path"
		done | sort -u)
	[ -z "$found" ] && return 0
	echo "$found"
	return 1
}

# shape_headings <path> <"A; B; C">: each page must have these ## headings, in this order.
shape_headings() {
	local f
	case "$1" in
	*/) find "$1" -maxdepth 1 -type f -name '*.md' ! -name README.md ! -name _template.md | sort ;;
	*) echo "$1" ;;
	esac | while IFS= read -r f; do
		awk -v want="$2" -v f="$f" 'BEGIN { n = split(want, w, /; */) }
			/^```/ { fence = !fence }
			!fence && /^## / { h = substr($0, 4); if (i < n && index(h, w[i + 1]) == 1) i++ }
			END { if (i < n) print f ": no \"## " w[i + 1] "\" heading (wanted, in order: " want ")" }' "$f"
	done
}

# shape_tasks <roadmap>: `- [ ] 1.2 (M) What. Done when: …` (a letter may follow the number:
# `1.2b`); a ticked task also says `Done YYYY-MM-DD.` A finished task moved from an old log is
# `(old)` and needs no Done when. Every fault of a task is reported at once.
shape_tasks() {
	awk -v f="$1" 'function flush(   miss, old) {
			if (t == "" || t ~ /^- \[.\] [0-9.]+[a-z]? *(…|\.\.\.) *$/) { t = ""; return }
			if (t !~ /^- \[[ xX]\] [0-9]+\.[0-9]+[a-z]? /) miss = miss "; a number (1.2)"
			if (t !~ /^- \[[ xX]\] [0-9]+\.[0-9]+[a-z]? \(([SML]|old)\) /) miss = miss "; a size (S/M/L, or old)"
			old = t ~ /^- \[[ xX]\] [0-9]+\.[0-9]+[a-z]? \(old\) /
			if (!old && t !~ /Done +when/) miss = miss "; a Done when"
			if (old && t ~ /^- \[ \]/) miss = miss "; a tick (old is only for finished tasks)"
			if (t ~ /^- \[[xX]\]/ && t !~ /Done [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/) miss = miss "; its Done date (Done YYYY-MM-DD.)"
			if (miss != "") print f ":" ln ": task without " substr(miss, 3) ": " substr(t, 1, 60)
			t = ""
		}
		/^- \[[ xX]\] / { flush(); t = $0; ln = FNR; next }
		t != "" && /^  +[^ ]/ { line = $0; sub(/^ +/, "", line); t = t " " line; next }
		{ flush() }
		END { flush() }' "$1"
}

# shape_bugs <known-bugs>: each Open bug has its six fields; each Fixed line is
# `YYYY-MM-DD <title>: <cause> → <fix>`.
shape_bugs() {
	awk -v f="$1" 'function flush() {
			if (b == "") return
			split("Status Area Reported Repro Expected Actual", need, " ")
			for (k = 1; k <= 6; k++) if (index(body, "- " need[k] ":") == 0) miss = miss " " need[k]
			if (miss != "") print f ":" ln ": open bug \"" b "\" lacks:" miss
			b = ""; body = ""; miss = ""
		}
		/^```/ { fence = !fence; next }
		fence { next }
		/^## / { flush(); sec = substr($0, 4); next }
		sec ~ /^Open/ && /^### / { flush(); b = substr($0, 5); ln = FNR; next }
		sec ~ /^Open/ && b != "" { body = body "\n" $0; next }
		sec ~ /^Fixed/ && /^(- |[0-9])/ && !/^(- )?[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [^:]+: .+(→|->)/ {
			print f ":" FNR ": fixed line is not `YYYY-MM-DD <title>: <cause> → <fix>`" }
		END { flush() }' "$1"
}

# shape_decisions <dir>: every record has an index row in <dir>/README.md naming its file, and
# the row's date and status match the record's file name and **Status:** line.
shape_decisions() {
	local dir=${1%/} f base status row rdate rstatus
	[ -f "$dir/README.md" ] || { echo "$dir/README.md: missing (the decisions index)"; return; }
	for f in "$dir"/*.md; do
		base=${f##*/}
		case "$base" in README.md | _template.md) continue ;; esac
		[ -f "$f" ] || continue
		echo "$base" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}-.+\.md$' ||
			echo "$f: name is not YYYY-MM-DD-<topic>.md"
		# `**Status: decided**` or `**Status:** Accepted`; "accepted" is read as decided.
		status=$(sed -n -e 's/.*\*\*Status:\*\* *\([A-Za-z][A-Za-z]*\).*/\1/p;t' \
			-e 's/.*\*\*Status: *\([A-Za-z][A-Za-z]*\).*/\1/p' "$f" | head -1 | tr 'A-Z' 'a-z')
		[ "$status" = accepted ] && status=decided
		case "$status" in
		proposed | decided | binding | superseded) ;;
		'') echo "$f: no **Status: <word>** line" ;;
		*) echo "$f: status '$status' is not proposed, decided, binding or superseded" ;;
		esac
		row=$(awk -F'|' -v b="$base" 'index($3, b) { print; exit }' "$dir/README.md")
		if [ -z "$row" ]; then
			echo "$f: no row in $dir/README.md (its Topic cell links the file)"
			continue
		fi
		rdate=$(echo "$row" | awk -F'|' '{ gsub(/[ *]/, "", $2); print $2 }')
		rstatus=$(echo "$row" | awk -F'|' '{ gsub(/[*`]/, "", $4); split($4, w, " "); print tolower(w[1]) }')
		[ "$rstatus" = accepted ] && rstatus=decided
		[ "$rdate" = "${base:0:10}" ] || echo "$dir/README.md: row for $base has date '$rdate'"
		[ -z "$status" ] || [ "$rstatus" = "$status" ] ||
			echo "$dir/README.md: row for $base says '$rstatus', the record says '$status'"
	done
	awk -F'|' '$2 ~ /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ { print $3 }' "$dir/README.md" |
		while IFS= read -r cell; do
			base=$(echo "$cell" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}-[A-Za-z0-9_.-]+\.md' | head -1)
			if [ -z "$base" ]; then
				echo "$dir/README.md: a row names no record file:$cell"
			elif [ ! -f "$dir/$base" ]; then
				echo "$dir/README.md: a row names $base, which does not exist"
			fi
		done
}

# conform [decisions]: does the project match the shape file? Exit 1 on any problem.
conform() {
	local n=0 homes=0 later=0 path kind heads entries made paths="" f p ok
	report() {
		[ -n "$1" ] || return 0
		printf '%s\n' "$1" | sed 's/^/conform: /'
		n=$((n + $(printf '%s\n' "$1" | wc -l)))
	}
	if [ "${1:-}" = decisions ]; then
		[ -d docs/decisions ] && report "$(shape_decisions docs/decisions/)"
		[ "$n" = 0 ]
		return
	fi
	if [ ! -f "$SHAPE" ]; then
		echo "conform: no $SHAPE: this project is not on the kit's shape (/godot-accel:realign)"
		return 1
	fi
	[ -f .claude/godot-accel/kit-version ] || report "no .claude/godot-accel/kit-version (bootstrap, realign and update write it)"
	while IFS='|' read -r path kind heads entries made; do
		homes=$((homes + 1))
		paths="$paths$path
"
		case "$kind" in live | plan | history) ;; *) report "$SHAPE: $path has kind '$kind' (live, plan or history)" ;; esac
		case "$made" in setup | "first use") ;; *) report "$SHAPE: $path has made '$made' (setup or first use)" ;; esac
		if [ ! -e "$path" ]; then
			# A first-use home appears when the game first needs it (from the kit's template).
			if [ "$made" = "first use" ]; then
				later=$((later + 1))
			else
				report "$path: missing (a home in $SHAPE)"
			fi
			continue
		fi
		[ -n "$heads" ] && report "$(shape_headings "$path" "$heads")"
		case "$entries" in
		'') ;;
		task) report "$(shape_tasks "$path")" ;;
		bug) report "$(shape_bugs "$path")" ;;
		decision) report "$(shape_decisions "$path")" ;;
		*) report "$SHAPE: $path has entries '$entries' (task, bug or decision)" ;;
		esac
	done < <(shape_rows)
	# A kit placeholder ({{NAME}}) left unfilled in a live doc.
	report "$(live_docs | while IFS= read -r f; do grep -nHE '\{\{[#/]?[A-Z_]+\}\}' "$f"; done |
		cut -c1-120 | sed 's/$/ … (an unfilled kit placeholder)/')"
	# A doc no row covers is drift: its content belongs in the home that does its job.
	while IFS= read -r f; do
		case "$f" in README.md | CHANGELOG.md | CONTRIBUTING.md | LICENSE.md | CODE_OF_CONDUCT.md | SECURITY.md) continue ;; esac
		ok=""
		while IFS= read -r p; do
			[ -n "$p" ] || continue
			case "$f" in "$p") ok=1 ;; "${p%/}"/*) [ "${p%/}" != "$p" ] && ok=1 ;; esac
		done < <(printf '%s' "$paths")
		[ -n "$ok" ] || report "$f: a doc no row in the shape covers (move it into its home, or add a row)"
	done < <(git ls-files --cached --others --exclude-standard 2>/dev/null |
		grep -E '^docs/.*\.md$|^[^/]+\.md$|^\.claude/[^/]+\.md$' | sort -u)
	if [ "$n" = 0 ]; then
		echo "conform: matches $SHAPE ($homes homes, $later not needed yet)"
		return 0
	fi
	echo "conform: $n problem(s); /godot-accel:realign moves a project onto the shape"
	return 1
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
	local n=0 layout f cls top
	# section <title> <lines>: print a titled list, count its items.
	section() {
		[ -n "$2" ] || return 0
		printf '%s (%s):\n%s\n' "$1" "$(printf '%s\n' "$2" | wc -l | tr -d ' ')" "$(printf '%s\n' "$2" | sed 's/^/  /')"
		n=$((n + $(printf '%s\n' "$2" | wc -l)))
	}
	section "Not in git yet: commit them (Godot's .uid files belong in git) or add them to .gitignore" \
		"$(git ls-files --others --exclude-standard 2>/dev/null | grep -v '^inbox/')"
	# Top-level folders CLAUDE.md's "Project layout" names; code anywhere else has wandered.
	layout=$(awk '/^## Project layout/{on=1; next} /^## /{on=0} on' CLAUDE.md 2>/dev/null |
		grep -oE '`[A-Za-z0-9_.-]+/' | tr -d '`/' | sort -u)
	if [ -n "$layout" ]; then
		section "Code outside the folders CLAUDE.md's layout names" \
			"$(git ls-files '*.gd' '*.cs' '*.tscn' '*.tres' 2>/dev/null |
				grep -vE "^(${G}addons|${G}tests|tools)/" | while IFS= read -r f; do
					top=${f#"$G"}
					printf '%s\n' "$layout" | grep -qxF "${top%%/*}" || echo "$f"
				done)"
	fi
	# Used = some other scene, resource, script or project.godot names its file or its class_name.
	section "Never used by any scene, script or project.godot" \
		"$(git ls-files '*.gd' '*.tscn' 2>/dev/null | grep -vE "^(${G}addons|${G}tests)/" | while IFS= read -r f; do
			used_by "${f##*/}" "$f" && continue
			cls=$(sed -n 's/^class_name \([A-Za-z0-9_]*\).*/\1/p' "$f" 2>/dev/null | head -1)
			[ -n "$cls" ] && used_by "$cls" "$f" && continue
			echo "$f"
		done)"
	section "Scripts over 300 lines (split out a helper as its own change: lint fails at 1000)" \
		"$(git ls-files '*.gd' 2>/dev/null | grep -v "^${G}addons/" | while IFS= read -r f; do
			[ "$(wc -l <"$f")" -gt 300 ] && echo "$f ($(wc -l <"$f" | tr -d ' ') lines)"
		done)"
	section "Finished plans still in docs/plans/ (move them to docs/archive/plans/)" \
		"$(for f in docs/plans/*.md; do
			case "$f" in */roadmap.md | */_template.md) continue ;; esac
			[ -f "$f" ] && grep -q '^- \[x\]' "$f" && ! grep -q '^- \[ \]' "$f" && echo "$f"
		done)"
	section "Scenes where a [node header doesn't start a line (a hand edit merged two lines)" \
		"$(git ls-files '*.tscn' 2>/dev/null | grep -v "^${G}addons/" | xargs grep -nE '[^[:space:]]\[node name=' 2>/dev/null)"
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
	# Long lines: every live doc of the shape (else the always-read files).
	local docs=()
	if [ -f "$SHAPE" ]; then
		while IFS= read -r f; do docs+=("$f"); done < <(live_docs)
	else
		docs=(CLAUDE.md docs/STATUS.md .claude/rules/*.md .claude/memory/*.md)
	fi
	long=""
	[ ${#docs[@]} -gt 0 ] &&
		long=$(awk 'FNR == 1 { always = FILENAME == "CLAUDE.md" || FILENAME == "docs/STATUS.md" || FILENAME ~ /^\.claude\/(rules|memory)\// }
			# Table rows are exempt in docs read only on demand (registers, research).
			length > 400 && (always || $0 !~ /^\|/) { print FILENAME ":" FNR ": " length " characters" }' "${docs[@]}" 2>/dev/null)
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
	conform) conform "$@" ;;
	budget) budget ;;
	tidy) tidy ;;
	*) usage ;;
esac
