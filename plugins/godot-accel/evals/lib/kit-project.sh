#!/usr/bin/env bash
# Sourced by eval fixtures and by the repo's tests (tests/run.sh): turns the current folder into a
# Godot project bootstrapped from the kit's own templates (no canon, no MCP, plain checks): the
# setup files of bootstrap's file map only, so each case tests what a new project really gets.
# The caller sets KIT_TEMPLATES before sourcing; it stops loudly if they are not there.
# KIT_GAME=game puts the Godot project in a game/ subfolder; KIT_NO_GIT=1 skips the commit.
set -e
T=${KIT_TEMPLATES:?KIT_TEMPLATES not set}
[ -f "$T/CLAUDE.md" ] || { echo "kit templates not found at $T" >&2; exit 1; }

G=${KIT_GAME:-.}
mkdir -p "$G/tests"
# A game with a main scene, so the smoke check has something to play.
printf 'config_version=5\n\n[application]\nconfig/name="Evalgame"\nrun/main_scene="res://main.tscn"\nconfig/features=PackedStringArray("4.7")\n\n[debug]\n\ngdscript/warnings/untyped_declaration=2\n' >"$G/project.godot"
printf 'extends Node2D\n\n\nfunc _ready() -> void:\n\tprint("main ready")\n' >"$G/main.gd"
printf '[gd_scene format=3]\n\n[ext_resource type="Script" path="res://main.gd" id="1"]\n\n[node name="Main" type="Node2D"]\nscript = ExtResource("1")\n' >"$G/main.tscn"

mkdir -p .claude/godot-accel docs/plans docs/guides tools inbox .githooks
cp -R "$T/dot-claude/rules" "$T/dot-claude/memory" .claude/
cp "$T/dot-claude/budgets.md" "$T/dot-claude/protected-paths.txt" .claude/
cp "$T/dot-claude/settings.suggested.json" .claude/settings.json
cp "$T/dot-claude/godot-accel/shape.md" .claude/godot-accel/
rm -f .claude/rules/csharp.md .claude/rules/godot-mcp.md .claude/rules/paid-tools.md
cp "$T/docs/STATUS.md" "$T/docs/known-bugs.md" "$T/docs/.gdignore" docs/
cp "$T/docs/plans/roadmap.md" docs/plans/
cp "$T/docs/guides/"*.md docs/guides/
cp "$T/tools/dev.sh" tools/
cp "$T/tests/smoke_check."* "$G/tests/"
cp "$T/inbox/README.md" "$T/inbox/.gdignore" inbox/
cp "$T/dot-githooks/"* .githooks/
chmod +x .githooks/pre-commit .githooks/commit-msg .githooks/pre-push
cp "$T/CLAUDE.md" .

# Fill the placeholders the way bootstrap would for this setup.
fill() {
	perl -0pi -e '
		s/^\{\{#(MCP|CANON|PAID|STANDARDS|MANIFEST)\}\}\n.*?^\{\{\/\1\}\}\n//gms;
		s/\{\{#(MCP|CANON|PAID|STANDARDS|MANIFEST)\}\}.*?\{\{\/\1\}\}//gs;
		s/\{\{[#\/]GODOTPROMPTER\}\}//g;
		s/\{\{GAME_NAME\}\}/Evalgame/g;
		s/\{\{PITCH\}\}/A small test platformer./g;
		s/\{\{GODOT_VERSION\}\}/4.7/g;
		s/\{\{LANGUAGE\}\}/GDScript/g;
		s/\{\{CURRENT_GOAL\}\}/a playable prototype/g;
		s/\{\{PILLAR_1\}\}/*to be agreed in the first planning session*/g;
		s/\{\{DATE\}\}/2026-11-01/g;
		s/\{\{PUSH_POLICY\}\}/the user pushes (`git push`) when they want./g;
		s/\{\{RUN_STEP\}\}/one bounded headless run of the game (`tools\/dev.sh run`), reading its output/g;
		s/\{\{TEST_COMMAND\}\}/`tools\/dev.sh check <name>` runs one check (`tests\/<name>_check.tscn`)/g;
		s/\{\{(KIT_NAME)\}\}/godot-accel/g;
		s/\{\{(KIT_REPO)\}\}/godot-noob-accelerator/g;
		s/^.*\{\{(CANON_READ_LINE|BEGINNER_LINE|MCP_SETUP_STEP)\}\}.*\n//mg;
	' "$@"
}
fill CLAUDE.md tools/dev.sh .claude/rules/*.md .claude/godot-accel/shape.md docs/*.md docs/*/*.md
chmod +x tools/dev.sh

# The .gitignore lines bootstrap appends (Godot's cache, secrets, the inbox).
sed 's/{{KIT_NAME}}/godot-accel/g' "$T/gitignore.snippet" >.gitignore

# The version stamp bootstrap writes (KIT_NO_STAMP=1 imitates a project set up before 0.3.0).
if [ "${KIT_NO_STAMP:-0}" != 1 ] && [ -f "$T/../../../.claude-plugin/plugin.json" ]; then
	mkdir -p .claude/godot-accel
	sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$T/../../../.claude-plugin/plugin.json" >.claude/godot-accel/kit-version
fi

# Commit with a throwaway identity so the case starts from a clean tree.
git init -q
[ "${KIT_NO_GIT:-0}" = 1 ] && return 0 2>/dev/null
git add -A
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "Bootstrapped from the kit"
