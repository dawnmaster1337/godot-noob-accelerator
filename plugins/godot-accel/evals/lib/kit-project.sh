#!/usr/bin/env bash
# Sourced by eval fixtures: turns the current folder into a Godot project bootstrapped from the
# kit's own templates (no canon, no MCP, plain checks), so each case tests the shipped rules.
# The caller sets KIT_TEMPLATES before sourcing; it stops loudly if they are not there.
set -e
T=${KIT_TEMPLATES:?KIT_TEMPLATES not set}
[ -f "$T/CLAUDE.md" ] || { echo "kit templates not found at $T" >&2; exit 1; }

printf 'config_version=5\n\n[application]\nconfig/name="Evalgame"\nconfig/features=PackedStringArray("4.7")\n' >project.godot

mkdir -p .claude docs tools tests inbox
cp -R "$T/dot-claude/rules" "$T/dot-claude/memory" .claude/
cp "$T/dot-claude/budgets.md" "$T/dot-claude/protected-paths.txt" .claude/
rm -f .claude/rules/csharp.md .claude/rules/godot-mcp.md .claude/rules/paid-tools.md
cp -R "$T/docs/." docs/
rm -rf docs/canon docs/standards.md docs/production
cp "$T/AGENTS.md" "$T/tools/dev.sh" .
mv dev.sh tools/
cp "$T/tests/example_check."* tests/
cp "$T/inbox/README.md" "$T/inbox/.gdignore" inbox/
cp "$T/CLAUDE.md" .

# Fill the placeholders the way bootstrap would for this setup.
fill() {
	perl -0pi -e '
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
		s/\{\{RUN_STEP\}\}/one run of the game (`godot --path .`), reading its output/g;
		s/\{\{TEST_COMMAND\}\}/`tools\/dev.sh check <name>` runs one check/g;
		s/\{\{LAYOUT\}\}/`scenes\/` · `scripts\/` · `resources\/`/g;
		s/\{\{ENGINE_SETTINGS\}\}/1280×720 viewport, `canvas_items` stretch, Forward+ renderer./g;
		s/\{\{AUTOLOADS\}\}/none yet/g;
		s/\{\{(KIT_NAME)\}\}/godot-accel/g;
		s/\{\{(KIT_REPO)\}\}/godot-noob-accelerator/g;
		s/^.*\{\{(CANON_READ_LINE|BEGINNER_LINE|MCP_SETUP_STEP)\}\}.*\n//mg;
		s/\{\{MEMORY_LINK_STEP\}\}//g;
	' "$@"
}
fill CLAUDE.md AGENTS.md tools/dev.sh .claude/rules/*.md docs/*.md docs/*/*.md
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
git add -A
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "Bootstrapped from the kit"
