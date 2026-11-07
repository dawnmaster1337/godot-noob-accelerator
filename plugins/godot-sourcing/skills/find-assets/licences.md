# Licences: what can go in a game you might sell

The default policy below assumes the game may be sold and its code kept closed.
`.claude/rules/sourcing.md` can narrow it; it never widens it past "ask". Not legal advice: when
a licence is unclear, say so and let the user decide.

| Licence | Default | Why |
|---|---|---|
| CC0, public domain, Unlicense | **take** | No conditions. Still record the source: provenance is what proves it was CC0. |
| MIT, BSD, zlib, Apache-2.0 (code: shaders, addons) | **take** | Commercial use allowed; keep the licence notice with the code (the shipped addon's LICENSE, or the header in a ported shader). |
| CC-BY 3.0 / 4.0 | **take, with credit** | Commercial use allowed if the game credits it: title, author, source link, licence link, and "modified" if changed. Write the exact line when the asset is fetched. |
| CC-BY-SA 3.0 / 4.0 | **ask** | Changes to the asset must be released under the same licence; fine for some games, not others. |
| GPL, LGPL, AGPL (code) | **exclude** | GPL code in a closed game obliges releasing the game's source. |
| Any NC licence, including a Shadertoy port (CC BY-NC-SA 3.0 unless its author says otherwise) | **exclude** | No commercial use. |
| "Royalty-free" or custom terms (an itch.io page, a store's own licence) | **ask** | Read the terms to the user in one line each: what's allowed, what isn't. |
| No licence stated | **exclude** | No licence means no permission, however public the page. |

**Mixed packs:** a pack's headline licence doesn't cover a file credited to someone else in it.
Read the pack's licence file, not only its page.

**Excluded but the best match?** Name it in one line under the shortlist ("best look, but
non-commercial") so the user knows it exists, and never fetch it.
