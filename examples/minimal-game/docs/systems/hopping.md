# Hopping and pads: what is true now

Updated 2026-03-14 (session 3).

## 1. Overview

The frog hops one pad at a time on a button press; pads sink after a landing and respawn.

## 2. Scenes and scripts

| Path | Does |
|---|---|
| `scenes/frog.tscn`, `scripts/frog.gd` | Hops to the nearest pad in the facing direction |
| `scenes/pad.tscn`, `scripts/pad.gd` | Starts its sink timer on landing; emits `sinking`, `sunk` |

## 3. Data

`resources/hop_tuning.tres` (`HopTuning`): `hop_time` 0.25 s, `sink_delay` 0.6 s,
`respawn_delay` 2 s. Safe to edit in the Inspector.

## 4. Checks

`tests/pad_check.tscn` (sink and respawn timings), `tests/frog_check.tscn` (hop target).

## 5. Open

No wobble yet; the run doesn't end on a sunk pad yet (plan tasks 3–4).

## 6. Sources

- `2026-03-12-sinking-pads.md` — sink delay, wobble, respawn.

## 7. Doc vs code mismatches

None.
