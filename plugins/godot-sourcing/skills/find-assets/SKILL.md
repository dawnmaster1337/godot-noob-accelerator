---
name: find-assets
description: Look for a ready-made, commercially licensed asset before building one by hand — shaders, 3D models, textures and materials, skies and HDRIs, sprites, sounds, fonts, Godot addons and common systems. Use when the user wants something to look or feel better or needs an asset ("make the water look nicer", "I need some trees", "add a skybox", "find a toon shader", "is there an inventory addon"), and before writing a shader, modelling a mesh or building a common system from scratch. Shortlists matches with their licences and waits for the user's pick.
argument-hint: "[what's needed, in the user's words]"
---

Need: $ARGUMENTS

Why this exists: left alone, Claude builds everything locally (a primitive tree, a hand-written
water shader) while free, better, commercially licensed versions sit one search away.

1. **Policy:** read `.claude/rules/sourcing.md`. None yet → make it from
   `${CLAUDE_SKILL_DIR}/templates/sourcing.md`, asking one at a time with a recommendation
   ("APR" takes it): which kinds are `make` (rec: none) and the licence line (rec: "the default
   in licences.md"). A `make` kind is never sourced: say so and stop (some projects make their
   art themselves on purpose).
2. **What's here first:** `assets/`, `addons/`, the asset manifest and `docs/research/` if they
   exist. Something held that fits beats a download. Note the Godot version
   (`project.godot`, `config/features`).
3. **Search** the sources for the kind, two or more in parallel, using
   `${CLAUDE_SKILL_DIR}/sources.md`. Search in plain words for the effect, not the code.
4. **Filter** by `${CLAUDE_SKILL_DIR}/licences.md` and the policy. Read the licence on the
   asset's own page or file, never only a search snippet (a Godot Shaders "Shadertoy port" is
   non-commercial unless its author says otherwise). Drop what the Godot version can't use
   without a port, or mark the port as work.
5. **Shortlist**, at most five, one table: name · source · licence (credit needed?) · format and
   Godot version · preview link · why it fits · work to adapt. Recommend one. If nothing fits,
   say what was searched and offer to build it. **Download nothing before the user picks**: a
   pick is a design call, and an unwanted pack is clutter in git.
6. **Fetch the pick** unmodified (the rules keep third-party files untouched):
   - packs, models, textures, skies → `assets/third_party/<source>-<slug>/` with the pack's own
     licence file; prefer glTF (`.glb`) for 3D. `curl` sends a User-Agent naming the project.
   - addons → `addons/<name>/` as shipped.
   - a shader → its code copied exactly from the page (`curl` it; never retype or summarise)
     into `assets/third_party/godotshaders-<slug>/`; a port or change goes in a project copy
     (`shaders/<name>.gdshader`) whose first lines name the source URL, author and licence.
   - no direct download (Quaternius, KayKit, itch.io, Sketchfab, `downloadable: false`) →
     give the page link and where the zip goes (`inbox/assets/` in a godot-accel project).
7. **Record it in the same change:** a row in `docs/production/manifest.md` (asset · source
   URL · author · licence · credit line). No manifest: in a godot-accel project, make it from
   the kit's template (the session-start card names the folder; drop its example row) and add
   its row under the shape's "This project's own rows"; elsewhere, a `CREDITS.md` line. A
   CC-BY credit line also goes in the game's credits. Why: credits rebuilt later are guessed.
8. **Use it:** import (`tools/dev.sh refresh`, or `godot --headless --import --path .`), wire
   it in, run the game and show it. Hand-offs if installed: import settings
   `godot-prompter:assets-pipeline`; shader changes `godot-prompter:shader-basics` or a companion
   shader skill (https://github.com/dawnmaster1337/godot-noob-accelerator/blob/main/docs/companions.md).
