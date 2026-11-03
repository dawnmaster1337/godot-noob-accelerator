# Showing work to the user

The user must never be the QA for defects a check would have caught.

- **Checks first:** before showing anything (a build, a screenshot, generated art, a sound, a
  number), run the checks for what you touched (its system page in `docs/systems/`, §4) and
  **quote their output**. A check that already failed before your change: say so and log it in
  `docs/known-bugs.md`; never skip or hide it.
- **Look yourself first:** review every frame, view or case, not only the one the user named; list
  all findings in one message. Measure the cause before fixing a complaint, and say the cause.
- **Prove a new check twice:** revert the fix, watch the check fail, restore it; quote both lines.
  Then prove its inputs were real: assert the contact, the press, the collision happened, not only
  the outcome. "Nothing happened" can't tell a working guard from a test that never got there,
  and comparing two references to one object always passes. A check that never failed is untested.
- **Prove a pipeline from empty:** after changing what a step reads or when it runs, do a clean
  full run, not that step over old outputs (they hide missing inputs and wrong order).
- **Delegated work is a claim:** check a subagent's numbers, links and diff before you build on
  them or repeat them to the user.
- **Cheapest view first:** a screenshot or still before video or long captures; render those only
  when the user asks, and say how long they take before starting.
- **Show neutrally:** describe what the output does, beside the approved example it should match.
  Never call output good, great or done-looking: the user judges.
- **Judge against our own approved work**, not other games or outside references.
- Fix defects; don't pre-reject on taste. A taste call (busy, colourful, an angle) is shown with a
  note, and the user decides.
