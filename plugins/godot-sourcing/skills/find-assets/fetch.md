# Fetching and recording a pick

The rules keep third-party files untouched: a change goes in a project copy, never the original.
Renaming a downloaded file (a hash name to `baseball_cap.glb`) is fine; editing it isn't.

## Where it goes

- **Packs, models, textures, skies** → `assets/third_party/<source>-<slug>/`, with the pack's own
  licence file. Prefer glTF (`.glb`) for 3D. `curl -L` sends a User-Agent naming the project.
- **Addons** → `addons/<name>/` as shipped.
- **A shader** → its code copied exactly from the page (`curl` it; never retype or summarise)
  into `assets/third_party/godotshaders-<slug>/`. A port or change goes in a project copy
  (`shaders/<name>.gdshader`) whose first lines name the source URL, author and licence.
- **No direct download** (Quaternius, KayKit, itch.io, Sketchfab, `downloadable: false`) → give
  the page link and where the zip goes (`inbox/assets/` in a godot-accel project).

**No licence file to ship** (Poly Pizza, most single models) → write `SOURCE.md` beside it: the
file name (and the original name if renamed), the page URL and the date read, the author, the
licence and its URL, the credit line, and the file's sha256.

## The credit row

One home for credits, in the same change as the file:

1. The project's existing third-party register, if it has one (`.claude/godot-accel/shape.md`
   names it, or a file such as `docs/third-party-assets.md` already does the job). Never start a
   second one beside it.
2. Else, in a godot-accel project, `docs/production/manifest.md` from the kit's template (the
   session-start card names the folder; drop its example row), with its row under the shape's
   "This project's own rows".
3. Else a `CREDITS.md` line at the project root.

The row: asset · path · source URL · author · licence · credit line. A CC-BY credit line also
goes in the game's shipped credits; until it does, the row says "credit owed". Why: credits
rebuilt later are guessed.
