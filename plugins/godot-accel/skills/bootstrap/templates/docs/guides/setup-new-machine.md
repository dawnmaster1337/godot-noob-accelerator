# Setting up {{GAME_NAME}} on another computer

## The daily routine (every machine, every session)

1. Open a terminal in the project folder (the one with `project.godot`) and start `claude`. Not
   the folder above it: the kit's hooks, rules and agents load only from where a session starts.
2. Type **resume**. Claude fetches from GitHub, shows anything new from your other machine, and
   pulls only after you say yes.
3. Work.
4. Say **save work** after each finished task, **wrap up** at the end. Claude commits on your
   yes and pushes, so the other machine can get it.

Never leave a machine with work that isn't pushed: the other machine can't see it.

## 1. Install the tools (once per machine)

| Tool | Why | Get it |
|---|---|---|
| Godot {{GODOT_VERSION}} | the engine | https://godotengine.org/download (same version on every machine) |
| Git | saves history, syncs machines | https://git-scm.com/downloads |
| GitHub CLI (`gh`) | signs git in to GitHub | https://cli.github.com |
| Claude Code | the assistant | https://code.claude.com/docs |
| Python 3 + gdtoolkit | formats and lints GDScript | `pipx install "gdtoolkit==4.*"` |
| jq | the kit's hooks read JSON with it | your package manager (`brew install jq`, `apt install jq`, …) |

Godot must be callable as `godot` from a terminal (`godot --version` prints {{GODOT_VERSION}}). On
macOS, link the app's binary into your PATH; on Windows, add the folder that holds the `.exe`.

## 2. Get the project

```bash
gh auth login
gh repo clone <your-github-name>/<repo>
cd <repo>
git config core.hooksPath .githooks
```

The last line turns on the project's git checks (format, lint, no secrets), if it has them.

## 3. Claude Code

1. Install the kit plugin once per machine: start Claude Code in the project folder and run
   `/plugin marketplace add dawnmaster1337/{{KIT_REPO}}`, then `/plugin install {{KIT_NAME}}@{{KIT_NAME}}`.
   If this project's `.claude/settings.json` already turns the kit on, pick **project scope**.
2. Recommended companion for Godot know-how: GodotPrompter (see the kit's README).
3. Claude's memory for this project is in the repo (`.claude/memory/`), loaded through
   `CLAUDE.md`: nothing to set up.
{{MCP_SETUP_STEP}}

## 4. First run

`tools/dev.sh check` (it builds Godot's cache first). Everything should pass. Then open the
editor: `godot --path . -e`.
