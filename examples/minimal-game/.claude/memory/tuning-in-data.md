---
name: tuning-in-data
description: Hop and sink timings live in resources/hop_tuning.tres, never as constants in code
metadata:
  type: feedback
---

Every timing the player feels (hop length, sink delay, pad respawn) is an `@export` on the
`HopTuning` resource in `resources/hop_tuning.tres`, not a constant in a script.

**Why:** session 2, the user wanted to try a longer sink delay between Claude sessions and
couldn't find it: it was a `const` in `pad.gd`.

**How to apply:** any new feel number goes into `HopTuning`; mention it in
`docs/systems/hopping.md` §3 so the user knows where to change it.
