#!/usr/bin/env bash
# The kit's own tests: build throwaway projects from the templates (the same builder the evals
# use) and run every tools/dev.sh verb, the plugin's hooks and the git hooks against them, the
# failure cases included. Needs bash, git, godot and gdtoolkit on PATH; CI (.github/workflows/)
# installs them. GUT_DIR / GDUNIT_DIR: folders holding addons/gut and addons/gdUnit4, to test the
# real addons too (CI downloads them). Run from anywhere: tests/run.sh
set -u
REPO=$(cd "$(dirname "$0")/.." && pwd)
PLUGIN=$REPO/plugins/godot-accel
export KIT_TEMPLATES=$PLUGIN/skills/bootstrap/templates
HOOKS=$PLUGIN/hooks
export PATH="$HOME/.local/bin:$PATH"
WORK=$(mktemp -d "${TMPDIR:-/tmp}/kit-tests.XXXXXX")
trap 'rm -rf "$WORK"' EXIT
pass=0
fail=0

ok() {
	pass=$((pass + 1))
	echo "  ok   $1"
}
bad() {
	fail=$((fail + 1))
	echo "  FAIL $1"
	[ -n "${2:-}" ] && printf '%s\n' "$2" | head -40 | sed 's/^/       /'
}
# expect <exit code> <label> <cmd...>: run cmd, compare its exit code.
expect() {
	local want=$1 label=$2 out code
	shift 2
	out=$("$@" 2>&1)
	code=$?
	if [ "$code" = "$want" ]; then ok "$label"; else bad "$label (exit $code, wanted $want)" "$out"; fi
}
# expect_out <regex> <label> <cmd...>: cmd's output (any exit code) matches regex.
expect_out() {
	local want=$1 label=$2 out
	shift 2
	out=$("$@" 2>&1)
	if printf '%s' "$out" | grep -qE -- "$want"; then ok "$label"; else bad "$label (no /$want/)" "$out"; fi
}
# project <dir> [game]: a bootstrapped project from the templates, committed.
project() {
	mkdir -p "$1"
	(cd "$1" && KIT_GAME=${2:-.} . "$PLUGIN/evals/lib/kit-project.sh" && git config core.hooksPath .githooks) >/dev/null
}
# hook <script> <json> [env...]: run a plugin hook in the current project with that input.
hook() {
	local script=$1 json=$2
	printf '%s' "$json" | CLAUDE_PROJECT_DIR=$PWD bash "$HOOKS/$script"
}
g() { git -c user.name=t -c user.email=t@example.invalid "$@"; }

echo "== static"
for f in "$HOOKS"/*.sh "$KIT_TEMPLATES"/tools/dev.sh "$KIT_TEMPLATES"/dot-githooks/{pre-commit,commit-msg,pre-push,lib.sh} "$0"; do
	expect 0 "bash -n ${f#"$REPO"/}" bash -n "$f"
done
if command -v shellcheck >/dev/null 2>&1; then
	expect 0 "shellcheck hooks and dev.sh" shellcheck -S warning -x "$HOOKS"/*.sh "$KIT_TEMPLATES"/tools/dev.sh
fi
expect 0 "repo .githooks is the template" diff -r "$REPO/.githooks" "$KIT_TEMPLATES/dot-githooks"
SOURCING=$REPO/plugins/godot-sourcing
for f in "$HOOKS/hooks.json" "$KIT_TEMPLATES/dot-claude/settings.suggested.json" "$PLUGIN/.claude-plugin/plugin.json" "$REPO/.claude-plugin/marketplace.json" "$SOURCING/.claude-plugin/plugin.json" "$SOURCING/.mcp.json"; do
	expect 0 "valid JSON ${f#"$REPO"/}" python3 -I -c 'import json,sys; json.load(open(sys.argv[1]))' "$f"
done
if command -v claude >/dev/null 2>&1; then
	expect 0 "claude plugin validate --strict" claude plugin validate "$PLUGIN" --strict
	expect 0 "claude plugin validate --strict (godot-sourcing)" claude plugin validate "$SOURCING" --strict
	expect 0 "claude plugin validate (marketplace)" claude plugin validate "$REPO"
fi
# CONTRIBUTING's budget: each skill and agent under 4,000 characters (bootstrap and realign,
# run once per project, excepted).
over=$(for f in "$REPO"/plugins/*/skills/*/SKILL.md "$REPO"/plugins/*/agents/*.md; do
	[ -f "$f" ] || continue
	case "$f" in */skills/bootstrap/* | */skills/realign/*) continue ;; esac
	n=$(wc -c <"$f")
	[ "$n" -lt 4000 ] || echo "${f#"$REPO"/}: $n characters"
done)
[ -z "$over" ] && ok "every skill and agent under 4,000 characters" || bad "skills or agents over budget" "$over"
# Every injected skill command must end so it can't exit non-zero: a failing one aborts the skill.
unsafe=$(grep -hn '^!`' "$REPO"/plugins/*/skills/*/SKILL.md | grep -vE '(; true|\|\| echo "[^"]*")`$')
[ -z "$unsafe" ] && ok "every skill's ! command ends in '; true' or '|| echo'" || bad "skill ! commands that can fail" "$unsafe"
cmds=$(grep -h '^!`' "$REPO"/plugins/*/skills/*/SKILL.md | sed 's/^!`//; s/`$//')
# godot-sourcing's eval fixtures build a project from scratch: they must run in an empty folder.
for f in "$SOURCING"/evals/*/fixture.sh "$SOURCING"/evals/lib/*.sh; do
	expect 0 "bash -n ${f#"$REPO"/}" bash -n "$f"
done
for c in "$SOURCING"/evals/*/fixture.sh; do
	d=$WORK/fixture-$(basename "$(dirname "$c")")
	mkdir -p "$d"
	expect 0 "eval fixture ${c#"$REPO"/}" bash -c 'cd "$1" && bash "$2" && test -f project.godot -a -f .claude/rules/sourcing.md' _ "$d" "$c"
done
for where in empty-git no-git; do
	d=$WORK/$where
	mkdir -p "$d"
	[ "$where" = empty-git ] && git -C "$d" init -q
	failed=$(cd "$d" && printf '%s\n' "$cmds" | while IFS= read -r c; do bash -c "$c" >/dev/null 2>&1 || echo "$c"; done)
	[ -z "$failed" ] && ok "every ! command exits 0 in a folder that is $where" || bad "! commands failing ($where)" "$failed"
done
for f in "$KIT_TEMPLATES"/tests/*.gd; do
	expect 0 "gdformat --check + gdlint ${f##*/}" sh -c "gdformat --check '$f' && gdlint '$f'"
done

echo "== a new project (root layout)"
P=$WORK/root
project "$P"
cd "$P" || exit 1
expect 0 "check passes (smoke check plays the main scene)" tools/dev.sh check
expect_out 'no errors in 600 frames' "run plays the main scene headless, bounded" tools/dev.sh run
expect_out 'all 1 check run' "check counts the smoke check" tools/dev.sh check
expect 0 "check smoke (by name)" tools/dev.sh check smoke
expect 1 "check of a missing name fails" tools/dev.sh check nothing
expect 0 "lint all" tools/dev.sh lint all
expect 0 "stale (first-use homes may be named before they exist)" tools/dev.sh stale
expect 0 "budget" tools/dev.sh budget
for _ in $(seq 49); do printf '%099d\n' 0; done >docs/STATUS.md
expect_out 'near budget: docs/STATUS.md 4900/5000 characters \(100 left\)' "budget names a file within 5% of its budget" tools/dev.sh budget
expect 0 "and still passes" tools/dev.sh budget
git checkout -q docs/STATUS.md
stamp=$(stat -c %Y .godot/dev-refresh.stamp)
sleep 1
mkdir -p .claude/worktrees/other && printf 'extends Node\n' >.claude/worktrees/other/new.gd
tools/dev.sh check >/dev/null 2>&1
[ "$(stat -c %Y .godot/dev-refresh.stamp)" = "$stamp" ] && ok "check ignores other sessions' worktrees" || bad "a file in .claude/worktrees/ triggered a refresh"
rm -rf .claude/worktrees
expect_out 'not needed yet' "conform matches, first-use homes not asked for" tools/dev.sh conform
expect 0 "conform exit code" tools/dev.sh conform
expect 0 "tidy" tools/dev.sh tidy

F=$WORK/fresh
mkdir -p "$F"
(cd "$F" && KIT_NO_GIT=1 . "$PLUGIN/evals/lib/kit-project.sh") >/dev/null
cd "$F" || exit 1
expect_out 'No commits yet' "session-start in a repo with no commits says so" hook session-start.sh '{}'
if hook session-start.sh '{}' | grep -q "likely the user's own"; then bad "session-start calls new files the user's edits"; else ok "and doesn't call new files the user's edits"; fi
cd "$P" || exit 1

echo "== check fails when it proves nothing, or the game is broken"
mv tests/smoke_check.tscn "$WORK/smoke.tscn"
expect 1 "no checks at all fails" tools/dev.sh check
expect_out 'no checks ran' "and says why" tools/dev.sh check
mv "$WORK/smoke.tscn" tests/smoke_check.tscn
printf 'extends Node2D\nfunc _ready(\n' >broken.gd
expect 1 "a script that doesn't parse fails the smoke check" tools/dev.sh check
rm broken.gd
cp main.gd "$WORK/main.gd"
printf 'extends Node2D\n\n\nfunc _ready() -> void:\n\tvar a: Array = []\n\tprint(a[3])\n' >main.gd
expect 1 "a runtime error in the main scene fails it" tools/dev.sh check
printf 'extends Node2D\n\n\nfunc _ready() -> void:\n\tpush_error("pushed boom")\n' >main.gd
expect 1 "an engine ERROR line fails it, though Godot exits 0 (push_error)" tools/dev.sh check
expect_out 'Godot printed errors' "and says why" tools/dev.sh check
expect 1 "run: an engine ERROR line fails the bounded headless run" tools/dev.sh run
printf '# expected on purpose\n\npushed boom\n' >tests/expected_errors.txt
expect 0 "an error listed in tests/expected_errors.txt doesn't fail it" tools/dev.sh check
rm tests/expected_errors.txt
printf 'extends Node2D\n\n@onready var hp: Node = $Missing\n\n\nfunc _ready() -> void:\n\tprint(hp)\n' >main.gd
expect 1 "a missing node fails it" tools/dev.sh check
cp "$WORK/main.gd" main.gd
printf 'extends Node2D\n\n\nfunc _ready() -> void:\n\tvar n = 3\n\tprint(n)\n' >untyped.gd
expect 1 "an untyped declaration fails it (untyped_declaration = error)" tools/dev.sh check
rm untyped.gd
sed -i '/main_scene/d' project.godot
expect 1 "no main scene fails it" tools/dev.sh check
expect_out 'a main scene is set' "and says which setting" tools/dev.sh check
git checkout -q project.godot
printf 'extends Node\n\n\nfunc _ready() -> void:\n\tprint("FAIL on purpose")\n\tget_tree().quit(1)\n' >tests/red_check.gd
sed 's/smoke_check/red_check/; s/SmokeCheck/RedCheck/' tests/smoke_check.tscn >tests/red_check.tscn
expect 1 "a failing check fails the run" tools/dev.sh check
rm tests/red_check.*
expect 0 "green again" tools/dev.sh check

echo "== shape: first-use homes"
mkdir -p docs/decisions
cp "$KIT_TEMPLATES"/docs/decisions/README.md docs/decisions/
printf '# Jump\n\nNo status line here.\n' >docs/decisions/2026-11-04-jump.md
expect 1 "a first-use home, once made, is checked" tools/dev.sh conform
rm -r docs/decisions
printf '# Notes\n' >docs/notes.md
expect 1 "an undeclared doc is drift" tools/dev.sh conform
rm docs/notes.md
printf 'See `docs/gone.md`.\n' >>docs/STATUS.md
expect 1 "stale still finds a dead path" tools/dev.sh stale
git checkout -q docs/STATUS.md

echo "== plugin hooks (root layout)"
expect 2 "guard-paths blocks .godot/" hook guard-paths.sh "{\"tool_input\":{\"file_path\":\"$P/.godot/x.cfg\"}}"
expect 2 "guard-paths blocks a .uid" hook guard-paths.sh "{\"tool_input\":{\"file_path\":\"$P/main.gd.uid\"}}"
expect 2 "guard-paths blocks addons/ (protected-paths.txt)" hook guard-paths.sh "{\"tool_input\":{\"file_path\":\"$P/addons/x/y.gd\"}}"
expect 0 "guard-paths allows a game script" hook guard-paths.sh "{\"tool_input\":{\"file_path\":\"$P/main.gd\"}}"
expect 0 "shell-stamp never blocks (git commit -m 'a.uid -> b.uid')" hook shell-stamp.sh '{"tool_input":{"command":"git commit -m \"rename a.uid -> b.uid\""}}'
[ -f .godot/godot-accel-bash.stamp ] && ok "shell-stamp touches its stamp in .godot/" || bad "no stamp in .godot/"
sleep 1
printf 'extends Node2D\nvar  x: int = 1\n' >loose.gd
expect 0 "lint hook after a shell command: lints, exit 0 when clean" hook gd-format-lint.sh '{"tool_name":"Bash","tool_input":{"command":"x"}}'
grep -q 'var  x' loose.gd && ok "after a shell command, a file is not reformatted" || bad "lint hook reformatted a shell-changed file"
grep -qx loose.gd .godot/godot-accel-touched && ok "the changed file is noted for the stop hook" || bad "touched list" "$(cat .godot/godot-accel-touched 2>&1)"
expect 2 "stop-check asks for a check after game files changed" hook stop-check.sh '{}'
expect 0 "stop-check lets the next stop through (asks once)" hook stop-check.sh '{}'
expect 0 "stop-check: one batch blocks once, not every other turn" hook stop-check.sh '{}'
echo loose.gd >.godot/godot-accel-touched
cp tools/dev.sh "$WORK/dev.sh.bak"
sed -i 's/godot-accel-touched/kit-list/g' tools/dev.sh
expect 0 "stop-check stays off with a dev.sh that never clears the list" hook stop-check.sh '{}'
expect_out 'predates the kit.s stop check' "session-start says the stop check is off" hook session-start.sh '{}'
cp "$WORK/dev.sh.bak" tools/dev.sh
rm loose.gd
tools/dev.sh check >/dev/null 2>&1
[ ! -e .godot/godot-accel-touched ] && ok "tools/dev.sh check empties the list" || bad "touched list survives a check"
expect 0 "stop-check silent after a check" hook stop-check.sh '{}'
hook shell-stamp.sh '{"tool_input":{"command":"x"}}'
sleep 1
mkdir -p .claude/worktrees/other && printf 'extends Node\n' >.claude/worktrees/other/theirs.gd
hook gd-format-lint.sh '{"tool_name":"Bash","tool_input":{"command":"x"}}' >/dev/null 2>&1
[ ! -s .godot/godot-accel-touched ] && ok "other sessions' worktrees are not noted" || bad "a .claude/worktrees file was noted" "$(cat .godot/godot-accel-touched)"
rm -rf .claude/worktrees
hook shell-stamp.sh '{"tool_input":{"command":"git commit"}}'
sleep 1
printf 'extends Node\nfunc Pulled_In() -> void:\n\tpass\n' >pulled.gd
g add pulled.gd && g commit -qm pulled --no-verify
expect 0 "after a command that moved HEAD (pull, merge, checkout), lint doesn't block" hook gd-format-lint.sh '{"tool_name":"Bash","tool_input":{"command":"git commit"}}'
[ ! -s .godot/godot-accel-touched ] && ok "and its files are not noted as Claude's" || bad "files from git were noted" "$(cat .godot/godot-accel-touched)"
g reset -q --hard HEAD~1
printf 'extends Node2D\nvar  y: int = 1\n' >edited.gd
expect 0 "lint hook after an edit: formats" hook gd-format-lint.sh "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$P/edited.gd\"}}"
grep -q 'var y' edited.gd && ok "an edited file is formatted" || bad "edited file not formatted" "$(cat edited.gd)"
rm edited.gd .godot/godot-accel-touched
printf 'extends Node2D\nfunc bad_Name() -> void:\n\tpass\n' >lintfail.gd
expect 2 "lint hook reports a lint failure" hook gd-format-lint.sh "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$P/lintfail.gd\"}}"
rm lintfail.gd .godot/godot-accel-touched*
expect_out 'Session start' "session-start card" hook session-start.sh '{}'
expect_out 'Kit templates' "session-start names the templates folder" hook session-start.sh '{}'
if hook session-start.sh '{}' | grep -q "lacks the kit's deny rules"; then bad "session-start: settings flagged though they have the deny rules"; else ok "session-start: settings have the deny rules"; fi
printf '{}\n' >.claude/settings.json
expect_out "lacks the kit's deny rules" "session-start flags missing deny rules" hook session-start.sh '{}'
git checkout -q .claude/settings.json
cp .claude/godot-accel/kit-version "$WORK/kit-version.bak"
kitv=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$PLUGIN/.claude-plugin/plugin.json" | head -1)
echo "0.0.1" >.claude/godot-accel/kit-version
expect_out 'Suggest /godot-accel:update' "session-start: an older project suggests update" hook session-start.sh '{}'
echo "${kitv}-beta.1" >.claude/godot-accel/kit-version
expect_out 'Suggest /godot-accel:update' "session-start: a pre-release stamp is older than its release" hook session-start.sh '{}'
cp "$WORK/kit-version.bak" .claude/godot-accel/kit-version

echo "== git hooks"
printf '%*s\n' 9000 '' | tr ' ' x >>CLAUDE.md
git add CLAUDE.md
expect 1 "pre-commit refuses CLAUDE.md over budget" .githooks/pre-commit
git checkout -q HEAD -- CLAUDE.md
long=$(printf '%*s' 7000 '' | tr ' ' 'b')
printf '\n%s\n' "$(printf '%s\n' "$long" | fold -w 300)" >>docs/known-bugs.md
git add docs/known-bugs.md
expect 0 "pre-commit only warns for a doc not read every session" .githooks/pre-commit
expect_out 'warning: docs/known-bugs.md' "and says so" .githooks/pre-commit
git checkout -q HEAD -- docs/known-bugs.md
mkdir -p addons/third
printf 'extends Node\nfunc Bad_Name():\n  pass\n' >addons/third/x.gd
git add -f addons/third/x.gd
expect 0 "pre-commit skips addons/" .githooks/pre-commit
git reset -q
rm -r addons
mkdir -p docs/plans
printf '# Mask shader\n\nSee 2026-11-09-mask-shader-for-the-water-and-the-sky.md\n' >docs/plans/2026-11-09-mask-shader-for-the-water-and-the-sky.md
git add docs/plans/2026-11-09-mask-shader-for-the-water-and-the-sky.md
expect 0 "pre-commit: a word ending in 'sk-' is not a key (mask-shader)" .githooks/pre-commit
git reset -q
rm docs/plans/2026-11-09-mask-shader-*
printf 'key = "sk-ant-%s"\n' "$(printf '%*s' 40 '' | tr ' ' a)" >leak.cfg
git add leak.cfg
expect 1 "pre-commit refuses a key-shaped string" .githooks/pre-commit
expect_out '    leak.cfg' "and names the file" .githooks/pre-commit
git reset -q
rm leak.cfg

echo "== a game in a subfolder (game/)"
S=$WORK/sub
project "$S" game
cd "$S" || exit 1
expect 0 "check from the repo root" tools/dev.sh check
expect 0 "lint all" tools/dev.sh lint all
expect 0 "conform" tools/dev.sh conform
expect 0 "stale" tools/dev.sh stale
expect 2 "guard-paths blocks game/.godot/" hook guard-paths.sh "{\"tool_input\":{\"file_path\":\"$S/game/.godot/x\"}}"
expect 2 "guard-paths blocks game/addons/ (protected from the game folder)" hook guard-paths.sh "{\"tool_input\":{\"file_path\":\"$S/game/addons/x/y.gd\"}}"
expect 2 "guard-paths folds ../ (game/scripts/../addons/)" hook guard-paths.sh "{\"tool_input\":{\"file_path\":\"$S/game/scripts/../addons/x/y.gd\"}}"
expect 2 "guard-paths takes a relative path from the root" hook guard-paths.sh '{"tool_input":{"file_path":"./game/.godot/x"}}'
expect 0 "guard-paths allows a game script in game/" hook guard-paths.sh "{\"tool_input\":{\"file_path\":\"$S/game/main.gd\"}}"
hook shell-stamp.sh '{"tool_input":{"command":"x"}}'
[ -f game/.godot/godot-accel-bash.stamp ] && ok "shell-stamp puts its stamp in game/.godot/" || bad "no stamp in game/.godot/"
sleep 1
printf 'extends Node\nfunc bad_Name() -> void:\n\tpass\n' >game/lintme.gd
mkdir -p game/addons/third
printf 'extends Node\nfunc Bad_Name():\n  pass\n' >game/addons/third/x.gd
out=$(hook gd-format-lint.sh '{"tool_name":"Bash","tool_input":{"command":"x"}}' 2>&1)
code=$?
[ "$code" = 0 ] && printf '%s' "$out" | grep -q '"additionalContext":.*lintme.gd' && ok "shell edits in game/ are linted, reported without blocking" || bad "game/ shell edit not reported (exit $code)" "$out"
printf '%s' "$out" | grep -q addons && bad "game/addons/ was linted" "$out" || ok "game/addons/ is not linted"
rm game/lintme.gd
git add -f game/addons/third/x.gd
expect 0 "pre-commit skips game/addons/" .githooks/pre-commit
git reset -q

# The real test addons, when CI (or you) provides them.
if [ -n "${GUT_DIR:-}" ] && [ -d "$GUT_DIR/addons/gut" ]; then
	echo "== GUT"
	G=$WORK/gut
	project "$G"
	cd "$G" || exit 1
	cp -R "$GUT_DIR/addons" .
	printf 'extends GutTest\n\n\nfunc test_adds() -> void:\n\tassert_eq(2 + 2, 4)\n' >tests/test_math.gd
	expect 0 "check runs GUT beside the smoke check" tools/dev.sh check
	expect 0 "check test_math (one GUT file)" tools/dev.sh check test_math
	printf 'extends GutTest\n\n\nfunc test_fails() -> void:\n\tassert_eq(2 + 2, 5)\n' >tests/test_red.gd
	expect 1 "a failing GUT test fails check" tools/dev.sh check
fi
if [ -n "${GDUNIT_DIR:-}" ] && [ -d "$GDUNIT_DIR/addons/gdUnit4" ]; then
	echo "== gdUnit4"
	U=$WORK/gdunit
	project "$U"
	cd "$U" || exit 1
	cp -R "$GDUNIT_DIR/addons" .
	printf 'extends GdUnitTestSuite\n\n\nfunc test_adds() -> void:\n\tassert_int(2 + 2).is_equal(4)\n' >tests/math_test.gd
	expect 0 "check runs gdUnit4 beside the smoke check" tools/dev.sh check
	expect 0 "check math (one gdUnit4 suite)" tools/dev.sh check math
	printf 'extends GdUnitTestSuite\n\n\nfunc test_fails() -> void:\n\tassert_int(2 + 2).is_equal(5)\n' >tests/red_test.gd
	expect 1 "a failing gdUnit4 test fails check" tools/dev.sh check
fi

# An example holds only the docs layer: lay it over a fresh project, and its docs must be in the
# current kit's form.
echo "== examples/"
for e in "$REPO"/examples/*/; do
	name=$(basename "$e")
	X=$WORK/example-$name
	project "$X"
	cp -R "$e"/. "$X"/
	rm -f "$X/README.md"
	cd "$X" || exit 1
	expect 0 "examples/$name: conform" tools/dev.sh conform
	# No stale here: an example has no game code, so the files its docs name don't exist.
	expect 0 "examples/$name: budget" tools/dev.sh budget
done

echo
echo "$pass passed, $fail failed"
[ "$fail" = 0 ]
