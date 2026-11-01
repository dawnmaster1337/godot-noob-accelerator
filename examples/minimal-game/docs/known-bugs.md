# Known bugs

## Open

### Frog can hop while a pad is sinking under it
- Status: open
- Area: hopping
- Reported: 2026-03-14 (user, playtest)
- Repro: land on a pad, wait for the wobble, press hop on the last frame.
- Expected: the run ends, or the hop is allowed; the user hasn't decided (STATUS question 1).
- Actual: the frog hops and lands, but the sinking pad's score is counted twice.

## Fixed

- 2026-03-13 Hop target picked a pad behind the frog: angle compared in degrees and radians →
  both in radians.
