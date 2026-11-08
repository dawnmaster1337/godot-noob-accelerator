# Where to look, by kind

Each source's licence is listed as its own site states it; `licences.md` says what to do with
each. Facts here were checked live on 8 November 2026: if a URL or API answers differently now,
trust the site and tell the user so this file can be fixed.

## The 3D Asset Server (models, materials, textures, skies, sprites, UI, audio, fonts, packs)

One search across 26 asset sites, free, no account or key, most results with their licence. This
plugin connects it as the `3d-assets` MCP server (https://3d.shep.bot/mcp). Tools:

- `search_assets` — `query`, `types` (model, material, texture, hdri, sprite, ui, audio, font,
  pack), `free_only`, `downloadable_only`, `providers`, `limit`, `offset`.
- `get_asset` — `id` from a search (for example `polyhaven:ArmChair_01`), `format`,
  `resolution`; returns the licence, formats and a `bundleUrl` to download.
- `list_providers` — every source, its licence, and whether files download directly.

Read `license.commercialUse` and `license.attributionRequired` on each search result (`get_asset`
returns `license` as a plain name). A result with no `license` (common for OpenGameArt, CGTrader
and itch.io) has an unknown licence: read it on the source page first. A result with
`downloadable: false` is fetched from its `url` on the source site (Fab, Poliigon and TurboSquid
return a search link only). The server writes nothing to disk: download the `bundleUrl` with
`curl -L`. Limit: 120 requests a minute; on a 429, wait the `Retry-After` time and retry once.
Same search without MCP: `https://3d.shep.bot/v1/search?q=<words>&type=<type>&free=true&limit=10`.

Sources it covers that are CC0 throughout: Poly Haven, ambientCG, Kenney, TextureCan,
3DAssets.dev, Grab3D, cgbookcase (download on its site). Per asset (check each): Quaternius (CC0 or its own licence), OpenGameArt,
Sketchfab (needs a login), BlenderKit, Wikimedia Commons, itch.io. Credit always needed:
Scenario 3D Collection (CC-BY 4.0).

Direct, when the server is down:
- **Poly Haven** (CC0): `https://api.polyhaven.com/assets?t=<hdris|textures|models>`, then
  `/files/<id>` for download links. The API asks every client to send a User-Agent naming the
  project.
- **ambientCG** (CC0): `https://ambientcg.com/api/v2/full_json?q=<words>&type=<Material|HDRI|3DModel>&include=downloadData&limit=10`.

## Packs with no API of their own

- **Kenney** (CC0, no credit needed; don't use the Kenney logo): https://kenney.nl/assets.
  Downloads directly through the 3D Asset Server; from the site itself, by hand.
- **Quaternius**: https://quaternius.com — read each pack's licence.
- **KayKit** (free versions CC0; don't resell unmodified copies): https://kaylousberg.itch.io
Give the user the page and the folder for the zip; import it next session (`resume` in a
godot-accel project empties `inbox/assets/`).

## Shaders

- **Godot Shaders** (https://godotshaders.com): browse by type with
  `https://godotshaders.com/shader/?shader_type=<spatial|canvas_item>&pg=1`, or search with
  `site:godotshaders.com <effect>`. Licence is under each shader's code ("The shader code and all
  code snippets in this post are under …"): CC0, MIT or GPL v3; a Shadertoy port says it's
  CC BY-NC-SA 3.0 unless its author states otherwise (excluded). A page marked CC0 or MIT whose
  text names a Shadertoy original is still under the original's licence: read it on Shadertoy.
  The licence covers the code, not the page's images. A Godot version shows only in the tags, if
  at all: Godot 3 code (`hint_color`, `SCREEN_TEXTURE` read directly) needs a port to Godot 4.
- **Asset Library, category Shaders** (below, add `&category=3`), and GitHub (`gh search repos "<effect> shader"
  --topic godot --sort stars`).

## Addons, tools and whole systems

- **Asset Store** (https://store.godotengine.org, the Asset Library's successor, in beta):
  search `https://store.godotengine.org/search/?query=<words>`. No public API: read the page.
  Listings show the licence.
- **Asset Library** (older, still online; assets were not moved over automatically, so check
  both): `https://godotengine.org/asset-library/api/asset?filter=<words>&godot_version=<x.y>&max_results=10`.
  Fields: `asset_id`, `title`, `category`, `godot_version`, `cost` (the licence),
  `support_level`, `modify_date`. A stale `modify_date` or an older `godot_version` is a risk:
  say so in the shortlist.
- **GitHub:** `gh search repos "<words>" --topic godot --sort stars --limit 10 --json
  fullName,url,description,license,stargazersCount,pushedAt` (add `--license mit` to narrow).
  A `license` of `other` or none means reading the repository's LICENSE file.
  **awesome-godot** (https://github.com/Calinou/awesome-godot) lists free/libre addons,
  templates and demos.
- **Godot Forum** (https://forum.godotengine.org): `site:forum.godotengine.org <words>`. A post
  is a lead, never a licence: follow it to the repository or store page and read the licence there.
