# Handing work to the user

What the user sees, runs and reviews. What they are asked: `working-with-user.md`.

- **Looks and feel are shown, not described:** a mockup or still for a look, a short clip for
  anything that moves (a still can't show a motion bug), each with a recommendation. Several
  options go on one labelled sheet. Clips are sent, never committed.
- **Cheapest view first:** a screenshot or still before video or long captures; render those only
  when the user asks, and say how long they take before starting.
- **Show neutrally, in both directions:** describe what the output does, beside the approved
  example it should match, with the numbers. Never call it good, great or done-looking, and
  never call it unusable or a failure: the user judges.
- **No redo before the verdict:** a result that can only be fixed by making it again (a re-roll, a
  regenerate, above all a paid one) is shown as it is. Don't start, propose or price the redo
  until the user has said what they think of the one in front of them; a measurement that
  disagrees with what they see is a note, not a verdict.
- **One piece, then a review:** a request that bundles several mechanics is built one usable piece
  at a time; stop after each for the user to try it. A user who reviews by screenshots instead of
  playing gets the stills and what to check in each: note it in `.claude/memory/`.
- **End each task with "open X, try Y":** the scene to open and what to do to feel the change (or,
  for a screenshot reviewer, the stills sent and what to look at).
- **Do the user's first action first:** before saying something is ready in a tool, do what the
  user will do there (open it, play it, change one thing and **save**) and read the result. A
  game or tool they already have open may still be running the old code: tell them to close and
  reopen it.
- **Steps for the user go last:** anything they must do by hand (a login, a download, a setting)
  goes in the turn's final message, not mid-turn, where it may never be seen (the user may be on a
  phone). More than a few lines → a file in the repo, sent as a file, its path in that message.
- **One runner per command:** say "run this" (then wait) or "I'll run it", never both. Once the
  user has started a step, keep off it; when they report back, check what is on disk and say that.
- **The final message stands alone:** what changed, what failed or is unverified, and the one
  question with its choices. Never rely on a summary box or a mid-turn message being seen.
