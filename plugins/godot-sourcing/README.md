# Godot Sourcing (plugin)

**Find or build, your call.** Left alone, Claude Code builds everything itself without asking: a
primitive tree, a hand-written water shader, a skybox from a gradient. Free, commercially
licensed versions often exist too. This plugin's `find-assets` skill asks you which you want.

When you ask for something to look or feel better, or Claude is about to write a shader, model a
mesh or build a common system, it:

1. asks you first: find a ready-made one, or build it here? Neither is recommended; it's your
   call. Your project's policy (`.claude/rules/sourcing.md`) can answer for a kind ahead of time:
   always build it, always find it, or ask (the default);
2. if you chose to find one: searches the sources for that kind: the 3D Asset Server (26 sites, including Poly Haven,
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
the kit's `inbox/`, and `plan-feature` asks find-or-build when a feature needs an asset.

## What it connects to

The plugin adds one MCP server, `3d-assets` (https://3d.shep.bot/mcp): the free, open-source
[3D Asset Server](https://3d.shep.bot/docs) by a third party. It needs no account or key, and
sends it only your search words. Because it comes with the kit, every Claude Code session with the
kit enabled connects to it when it starts, even when you never search; Claude only sends it
anything when you choose to find something. While it's a dependency of the kit it can't be turned off on its own:
`/plugin` refuses to disable it while godot-accel is enabled. Its privacy policy: https://3d.shep.bot/privacy. Everything else
is ordinary web search and `curl`.

Not legal advice: the skill reads each asset's licence and tells you when one is unclear, but the
call is yours.
