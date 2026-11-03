# Roadmap: {{GAME_NAME}}

The build order. Work follows it; `docs/STATUS.md` says where it stands. Each milestone ends with
a playable build and a review (`project-audit` or the adversarial reviewer). A task with its own
plan links to it.

**This is also the build log.** Tick a task when it lands and add the date:
`- [x] 1.2 (M) What. Done when: … Done 2026-03-14.` A finished task brought in from an old log is
`- [x] 0.12 (old) What. Done 2026-03-14.`, with no size or Done when invented. A finished
milestone moves to `docs/archive/` with its dates. No separate log: the why is in
`docs/decisions/`, the bugs in `docs/known-bugs.md`, every change in `git log`.

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

- [ ] 3.1 (M) Parked polish items (each with the user's words and the cause). Done when: …
- [ ] 3.2 …
