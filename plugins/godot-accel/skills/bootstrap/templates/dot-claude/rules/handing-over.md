# Handing work to the user

What the user sees, runs and reviews. What they are asked: `working-with-user.md`.

- **Looks and feel are shown, not described:** a mockup or still for a look, a short clip for
  anything that moves (a still can't show a motion bug), each with a recommendation. Several
  options go on one labelled sheet. Clips are sent, never committed.
- **One piece, then a review:** a request that bundles several mechanics is built one usable piece
  at a time; stop after each for the user to try it. A user who reviews by screenshots instead of
  playing gets the stills and what to check in each: note it in `.claude/memory/`.
- **End each task with "open X, try Y":** the scene to open and what to do to feel the change (or,
  for a screenshot reviewer, the stills sent and what to look at).
- **Steps for the user go last:** anything they must do by hand (a login, a download, a setting)
  goes in the turn's final message, not mid-turn, where it may never be seen (the user may be on a
  phone). More than a few lines → a file in the repo, sent as a file, its path in that message.
- **One runner per command:** say "run this" (then wait) or "I'll run it", never both. Once the
  user has started a step, keep off it; when they report back, check what is on disk and say that.
- **The final message stands alone:** what changed, what failed or is unverified, and the one
  question with its choices. Never rely on a summary box or a mid-turn message being seen.
