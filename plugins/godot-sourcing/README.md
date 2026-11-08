# Godot Sourcing (plugin)

**Ready-made before handmade.** Left alone, Claude Code builds everything itself: a primitive
tree, a hand-written water shader, a skybox from a gradient. Free, better, commercially licensed
versions are usually one search away. This plugin's `find-assets` skill looks there first.

When you ask for something to look or feel better, or Claude is about to write a shader, model a
mesh or build a common system, it:

1. checks your project's sourcing policy (`.claude/rules/sourcing.md`, made the first time: a
   kind you make yourself on purpose is never sourced);
2. searches the sources for that kind: the 3D Asset Server (26 sites, including Poly Haven,
   ambientCG and Kenney), Godot Shaders, the Asset Store and Asset Library, GitHub, awesome-godot
   and the Godot Forum;
3. drops anything you can't use in a game you might sell (non-commercial, GPL code, no licence);
4. shows a shortlist of up to five, with licence, preview link and the work to adapt each, and
   **waits for your pick**;
5. fetches the pick unmodified, records its source and credit line, imports it and shows it in
   the game.

Say **"find a toon water shader"**, **"I need some low-poly trees"**, or
`/godot-sourcing:find-assets <what you need>`.

## Install

Installing the Godot Noob Accelerator (`godot-accel@godot-accel`) installs this plugin too. On its
own:

```
/plugin marketplace add dawnmaster1337/godot-noob-accelerator
/plugin install godot-sourcing@godot-accel
```

It works in any Godot 4 project and fits in with the Godot Noob Accelerator (`godot-accel`) when
both are installed: credits go in the kit's asset manifest, packs you download by hand go through
the kit's `inbox/`, and `plan-feature` checks for a ready-made asset before planning one.

## What it connects to

The plugin adds one MCP server, `3d-assets` (https://3d.shep.bot/mcp): the free, open-source
[3D Asset Server](https://3d.shep.bot/docs) by a third party. It needs no account or key, and
sends it only your search words. Its privacy policy: https://3d.shep.bot/privacy. Everything else
is ordinary web search and `curl`.

Not legal advice: the skill reads each asset's licence and tells you when one is unclear, but the
call is yours.
