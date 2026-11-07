# Sourcing ready-made assets

The project's policy for `find-assets` (godot-sourcing plugin). The user owns it; change a row
by saying so. Why it exists: some projects make every asset themselves on purpose, and a
sourced asset in the wrong kind would undo that.

## What may be sourced

`source`: search free sources first, then build only what's missing · `make`: never source;
build or generate it here · `ask`: ask each time.

| Kind | Policy |
|---|---|
| Shaders and visual effects | {{SHADERS}} |
| 3D models and animations | {{MODELS}} |
| Textures, materials, skies (HDRI) | {{TEXTURES}} |
| 2D art (sprites, tiles, UI) | {{ART_2D}} |
| Sound effects and music | {{AUDIO}} |
| Fonts | {{FONTS}} |
| Addons, tools, whole systems | {{ADDONS}} |

## Licences

{{LICENCE_LINE}}

Where downloads go: `assets/third_party/<source>-<slug>/` and `addons/<name>/`, unmodified.
Where credits go: the asset manifest (docs/production/manifest.md) in a godot-accel project,
else CREDITS.md at the project root.
