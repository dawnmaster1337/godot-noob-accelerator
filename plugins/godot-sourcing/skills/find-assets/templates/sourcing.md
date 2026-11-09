# Find or build: the project's choices

The project's policy for `find-assets` (godot-sourcing plugin). The user owns it; change a row
by saying so. Why it exists: whether to use a ready-made asset or build one is the user's call,
and some projects make every asset of a kind themselves on purpose.

## Per kind

`ask`: ask each time, find or build · `source`: find ready-made options without asking ·
`make`: always build or generate it here, never search.

| Kind | Policy |
|---|---|
| Shaders and visual effects | {{SHADERS}} |
| 3D models and animations | {{MODELS}} |
| Textures, materials, skies (HDRI) | {{TEXTURES}} |
| 2D art (sprites, tiles, UI) | {{ART_2D}} |
| Sound effects and music | {{AUDIO}} |
| Fonts | {{FONTS}} |
| Addons, tools, whole systems | {{ADDONS}} |

## Licences for what is found

{{LICENCE_LINE}}

Where downloads go: `assets/third_party/<source>-<slug>/` and `addons/<name>/`, unmodified.
Where credits go: the project's existing third-party register if it has one, else the asset
manifest (docs/production/manifest.md) in a godot-accel project, else CREDITS.md at the root.
