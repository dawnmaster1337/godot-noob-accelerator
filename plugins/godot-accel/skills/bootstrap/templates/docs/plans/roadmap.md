# Roadmap: {{GAME_NAME}}

The build order. Work follows it; `docs/STATUS.md` says where it stands. Each milestone ends with
a playable build and a review (`project-audit` or the adversarial reviewer). Tick tasks off as
they land; a task with its own plan links to it.

**One task per session.** Each task fits one session: size **S** (under an hour), **M** (a
session), **L** (too big: split it, or give it a plan with its own tasks). Each has a
**Done when** a player could check. Shape: `- [ ] 1.2 (M) What. Done when: what the player sees.`

## M0: foundations (systems and tools; placeholder art)

- [ ] 0.0 (S) Green baseline. Done when: `tools/dev.sh check` and `tools/dev.sh lint all` pass,
  so every later task can trust the checks.
- [ ] 0.1 (M) Player moves on screen (the first `plan-feature`). Done when: …
- [ ] 0.2 …

## M1: vertical slice (one small area, at final quality)

- [ ] 1.1 …

## M2: content (the rest of the areas)

- [ ] 2.1 …

## M3: polish and the first build others can play

- [ ] 3.1 Parked polish items (each with the user's words and the cause).
- [ ] 3.2 …
