# Godot Noob Accelerator

**A way of working for making a Godot 4 game with Claude Code.** Not engine tips: the process
around them. How a session starts and ends, where decisions and lessons are written down, how
Claude checks its own work before you see it, and how nothing gets lost between sessions or
machines.

It came out of a real game project built over ~100 Claude Code sessions by someone new to
coding. Every rule in it exists because something went wrong without it.

**Never used Claude Code or Godot?** Start with the [beginner's guide](docs/beginners-guide.md).
It goes from zero to a moving character on screen.

## Who it's for

- **Vibe coders** and beginners: you describe the game, Claude builds it, the kit keeps it
  organised and safe.
- **Developers** who want Claude to keep a project's memory, decisions and checks in order over
  months, not just one chat.

## What's in it: two layers

1. **A Claude Code plugin** (installed once, updated like any plugin) with:

   | Skill | You type or say | It does |
   |---|---|---|
   | `bootstrap` | `/godot-accel:bootstrap` | Sets your project up: asks ≤ 8 questions, writes the files below, never overwrites one |
   | `resume` | "resume" | Fetches (asks before pulling), reads where you stopped, finds half-done work, empties the inbox, says what's next |
   | `plan-feature` | "I want to add…" | Questions one at a time with recommendations → decision record → plan with a "Done =" line → your OK before code |
   | `ship-check` | `/godot-accel:ship-check` | Lint, every headless check, a play-test, a review at milestones, fixes, then a proposed commit |
   | `save-work` | "save work", "wrap up", "running out of usage" | Task, session or quick save; commits only on your yes; ends with "safe to /clear: yes/no" |
   | `trim-context` | "trim", "lessons" (or from a session save) | Each lesson to its one home; keeps always-read files under their budgets |
   | `workflow-audit` | "audit our workflow" | Read-only review of the setup: contradictions, hidden rules, token cost → a ranked report |
   | `canon-check` | before new dialogue or names | Checks writing against your story/world bible (if you keep one) |
   | `harvest-learnings` | `/godot-accel:harvest-learnings` | Turns your project's lessons into feedback issues for this kit; posts nothing |

   | Agent | Does |
   |---|---|
   | `adversarial-reviewer` | Hostile review of uncommitted changes; finds the diff itself; SHIP or FIX FIRST with failure scenarios |
   | `design-reviewer` | Is it fun? Does it read, reward, teach? Ranked changes in player terms |
   | `canon-reviewer` | Batch review of writing against the canon docs |

   | Hook | When | Does |
   |---|---|---|
   | session start | start, resume, `/clear`, compaction | Git state (and "this is not a fetch"), your uncommitted scene edits, inbox, STATUS Next and size, Godot on PATH, your own standing guard |
   | path guard | before an edit | Blocks `.godot/`, `*.import`, `*.uid`, `.env`, and paths in `.claude/protected-paths.txt` |
   | format + lint | after editing a `.gd` | `gdformat`, then `gdlint`; a lint failure goes straight back to Claude |

2. **The `bootstrap` skill's templates**, written into your project (plugins can't ship a
   CLAUDE.md or rules, so they're copied in once and become yours):
   `CLAUDE.md`, `AGENTS.md`, `.claude/rules/` (how to write code, scenes, docs; git; working with
   you; showing work; tuning values and your hand edits), `.claude/memory/`, `docs/` (STATUS,
   decisions, plans and roadmap, system pages, a bug log, guides), `inbox/`, `tools/dev.sh`, an
   example headless check, git hooks (lint and a secrets scan at commit time, once you turn them
   on), `.gitignore` lines, and optional extras
   (canon docs, a standards page, an asset manifest, a paid-tools spend gate, a playtester
   agent for an editor MCP). Every file and why: [docs/structure.md](docs/structure.md).

## Install

Inside Claude Code:

```
/plugin marketplace add dawnmaster1337/godot-noob-accelerator
/plugin install godot-accel@godot-accel
```

Restart Claude Code (`/exit`, then `claude`). **Updates:** third-party marketplaces don't
auto-update by default. Run `/plugin marketplace update godot-accel`, or turn on
auto-update under `/plugin` → Marketplaces.

**Prerequisites:** Godot 4 callable as `godot` from a terminal, and git. Optional:
[gdtoolkit](https://github.com/Scony/godot-gdscript-toolkit) (`pipx install "gdtoolkit==4.*"`)
for format and lint, `jq` or `python3` for the hooks. Missing ones are skipped, never fatal.

## First run

In a terminal, in your Godot project's folder (one with `project.godot`):

```
claude
/godot-accel:bootstrap
```

Answer the questions ("APR" takes the recommendation), approve the file list, then read
`docs/guides/start-here.md` in your project. From then on, every session starts with **resume**
and ends with **save work** or **wrap up**. How it all fits: [docs/how-it-works.md](docs/how-it-works.md).

## Companions

| | What | Why |
|---|---|---|
| **Recommended** | [GodotPrompter](https://github.com/jame581/GodotPrompter): `/plugin marketplace add jame581/skillsmith`, `/plugin install godot-prompter@skillsmith` | Deep Godot 4 engine know-how (56 skills: movement, UI, save/load, testing, code review, design grilling). This kit is the process layer and deliberately doesn't duplicate it; `plan-feature`, the rules and the reviewer use its skills when present |
| Optional | A Godot editor MCP server (several exist; search "Godot MCP") | Lets Claude run the game and read its logs. Bootstrap writes a "never work blind" rule and a `playtester` agent for it |

## Things to know

- **A hook defined both here and in your own settings runs twice.** If you already have
  gdformat/gdlint or path-guard hooks in `.claude/settings.json`, remove your copies or expect
  doubled output.
- **Terse-output or compression plugins** can hide the check output this process asks Claude to
  quote. If Claude stops quoting checks, try without them.
- The kit never commits, pushes, posts or spends anything without your yes.

## Feedback

This is v0.1.0 and it gets better from real projects.

- **Tried it?** Open an issue with the **Feedback** template: what worked, what didn't, what you
  changed.
- **Your project learned something?** Run `/godot-accel:harvest-learnings`. It compares your
  project with the kit's templates and writes ready-to-paste issue bodies for the **Learning**
  template, with your game's content stripped out. It never posts anything itself.
- Changes welcome: [CONTRIBUTING.md](CONTRIBUTING.md).

## Licence

[MIT](LICENSE).
