# Showing work to the user

The user must never be the QA for defects a check would have caught.

- **Checks first:** before showing anything (a build, a screenshot, generated art, a sound, a
  number), run the checks for what you touched (its system page in `docs/systems/`, §4) and
  **quote their output**. A check that already failed before your change: say so and log it in
  `docs/known-bugs.md`; never skip or hide it.
- **Look yourself first:** review every frame, view or case, not only the one the user named; list
  all findings in one message. Measure the cause before fixing a complaint, and say the cause.
- **Prove a new check:** a check written for a fix is proven by reverting the fix, watching the
  check fail, and restoring it; quote both lines. A check that has never failed is untested.
- **Cheapest view first:** a screenshot or still before video or long captures; render those only
  when the user asks, and say how long they take before starting.
- **Show neutrally:** describe what the output does, beside the approved example it should match.
  Never call output good, great or done-looking: the user judges.
- **Judge against our own approved work**, not other games or outside references.
- Fix defects; don't pre-reject on taste. A taste call (busy, colourful, an angle) is shown with a
  note, and the user decides.
