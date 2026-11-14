# Showing work to the user

The user must never be the QA for defects a check would have caught.

- **Checks first:** before showing anything (a build, a screenshot, generated art, a sound, a
  number), run the checks for what you touched (its system page in `docs/systems/`, §4) and
  **quote their output**. A check that already failed before your change: say so and log it in
  `docs/known-bugs.md`; never skip or hide it.
- **Look yourself first:** review every frame, view or case, not only the one the user named; list
  all findings in one message. Measure the cause before fixing a complaint, and say the cause.
- **A UI change is done only when seen:** checks prove logic, not visibility, and a panel's own
  status line reports success either way. With an editor MCP, drive it, do the thing and
  screenshot it (twice when it moves); without one, hand it over as not yet seen, never as working.
- **Prove a new check twice:** revert the fix, watch the check fail, restore it; quote both lines.
  A break must cross the threshold it tests: work out the margin, then exceed it. Then prove its inputs were real: assert the contact, the press, the collision happened, not only
  the outcome. "Nothing happened" can't tell a working guard from a test that never got there,
  and comparing two references to one object always passes. A check that never failed is untested.
- **A negative from driven input is not a finding:** a synthetic key or click (an MCP, a script)
  may never reach the code path. Confirm it did before writing "doesn't work"; else record it as
  unverified, with the one manual step that settles it.
- **Suspect the ruler first:** a number that moves when you change how you sample it is a fault
  in the check, not a result. Measure it a second way before acting on it.
- **Prove a pipeline from empty:** after changing what a step reads or when it runs, do a clean
  full run, not that step over old outputs (they hide missing inputs and wrong order).
- **Delegated work is a claim:** check a subagent's numbers, links and diff before you build on
  them or repeat them to the user.
- **Sort every finding before showing,** yours and a reviewing agent's. One you can state as a
  measurement against our own approved work or convention, not other games or outside references
  (a part missing, two sides that differ, a broken edge, the wrong view), is a **defect**: fix
  it, then show; never pass it on labelled as an opinion. One about preference (busy, colourful,
  an angle) is **taste**: show it with the number, and the user decides. A fix that means making
  the thing again waits for the user: "No redo before the verdict" in `handing-over.md`.
