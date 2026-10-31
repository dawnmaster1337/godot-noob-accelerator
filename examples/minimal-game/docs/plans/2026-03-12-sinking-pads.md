# Sinking pads — plan

**Status: approved** (user, session 3). Decision record: `docs/decisions/2026-03-12-sinking-pads.md`.

**Done =** the frog lands on a pad; the pad wobbles, then sinks 0.6 s after the landing, and comes
back 2 s later. Standing on it when it sinks ends the run. `tests/pad_check.tscn` proves the
timings headless.

## Design

`Pad` (Area2D) owns a `Timer` started on `body_entered`; it emits `sinking` and `sunk` upwards; the
main scene ends the run on `sunk` if the frog is still on it. Timings from `HopTuning`. Picked a
per-pad Timer over a global pad manager: each pad is independent, nothing to keep in sync.

## Tasks

- [x] 1. `Pad` sinks after `sink_delay`; respawns after `respawn_delay`.
- [x] 2. `tests/pad_check.tscn`: sink and respawn timings.
- [ ] 3. The wobble for the last 0.3 s.
- [ ] 4. The run ends when the frog is on a sinking pad.
