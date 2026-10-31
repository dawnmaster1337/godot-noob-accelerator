# Sinking pads, session 3, 2026-03-12

**Status: decided** (user, session 3: questions 1 and 3 "APR", question 2 as below). Plan:
`docs/plans/2026-03-12-sinking-pads.md`. Supersedes: none.

## Decisions

| Topic | Decision | Why |
|---|---|---|
| When a pad sinks | 0.6 s after the frog lands | Long enough to read, short enough to push the player on |
| Warning | The pad wobbles for the last 0.3 s | Pillar 2: every sink is readable before it happens |
| Respawn | 2 s after sinking, in the same place | Keeps the one screen learnable |

## The user's answers

1. Sink delay: "APR" (0.6 s, tunable in `HopTuning`).
2. Warning: "a wobble, not a colour change, I'm colour-blind-ish" — wobble chosen over red tint.
3. Respawn: "APR".

## Rejected options

- Red tint as the warning: hard to read for the user.
- Random respawn positions: the screen stops being learnable.
