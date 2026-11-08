# Companions

The kit is about working carefully. These plugins add what it deliberately leaves out: engine
know-how, ready-made assets and shader craft. None is required. Checked November 2026; each
project's own README is the source of truth.

| Companion | What it adds | Needs |
|---|---|---|
| **[godot-sourcing](../plugins/godot-sourcing/)** (this repository) | Looks for free, commercially licensed shaders, models, textures, skies, addons and systems before Claude builds them; shortlists with licences, fetches your pick, records the credit. | Installed with godot-accel. It connects the free [3D Asset Server](https://3d.shep.bot/docs). |
| **[GodotPrompter](https://github.com/jame581/GodotPrompter)** | How to build Godot things: movement, menus, saving, plus `shader-basics` and `assets-pipeline` (importing what godot-sourcing fetches). | Nothing else. |
| **[godot-claude-skills](https://github.com/alexmeckes/godot-claude-skills)** (alexmeckes) | A `godot-shader` skill for 2D/3D effects and post-processing, with scene-design and GDScript skills. | Works best with [godot-mcp](https://github.com/alexmeckes/godot-mcp) (recommended, not required). |
| **[godot-mcp-skills](https://github.com/PooDoge/godot-mcp-skills)** (PooDoge) | `godot-shader-lab`: iterate a shader by editing, screenshotting and checking the result, with 12 recipes. Also scene building, debugging, a collision audit and a scene health check. | The Godot editor open, and the MCP server its README links: [godot-mcp](https://github.com/tugcantopaloglu/godot-mcp) by tugcantopaloglu (free, MIT, Godot 4.4+). |

## Install

godot-sourcing comes with godot-accel. On its own, or with a kit installed before 0.6.0:

```
/plugin marketplace add dawnmaster1337/godot-noob-accelerator
/plugin install godot-sourcing@godot-accel
```

```
/plugin marketplace add jame581/skillsmith
/plugin install godot-prompter@skillsmith
```

```
/plugin marketplace add alexmeckes/godot-claude-skills
/plugin install godot-claude-skills
```

godot-mcp-skills has no marketplace yet: clone it, then `claude plugins install
/path/to/godot-mcp-skills` (its README).

## Before you add several

- **Shader skills overlap.** GodotPrompter's `shader-basics`, alexmeckes' `godot-shader` and
  PooDoge's `godot-shader-lab` all trigger on "shader". Pick one to iterate with; godot-sourcing
  finds a starting shader for any of them.
- **One editor MCP server per project.** The kit's rules assume one server drives the editor
  (`.claude/rules/godot-mcp.md`), and bootstrap records its name. A companion that needs a
  different server means switching, not adding a second.
- **Names that look alike:** PooDoge's README calls its server "godot-mcp-pro" but links
  tugcantopaloglu's free godot-mcp. A separate, paid "Godot MCP Pro" exists; it isn't the one
  that README links.
