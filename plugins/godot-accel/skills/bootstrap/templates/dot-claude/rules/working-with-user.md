# Working with the user

What the user is asked and how their answers are kept. What they are handed: `handing-over.md`.

- **Questions:** numbered, **one at a time**, each with a recommendation the user can take with
  "APR" (as per recommendation). Mark the recommended option first. Answers in a batch
  ("q1 APR, q2 B") are fine: apply each.
- **A prepared list goes stale:** before reading out questions written in an earlier session,
  check each against the code as it is now; drop or rewrite what moved. Each must be answerable
  from what the user can see, with the deciding facts in the options: an internal name or a file
  path means it isn't ready to ask.
- **Echo first:** repeat a multi-part request back as a short list before building it. Separate
  what the user decided from what they are only leaning towards; confirm a lean before recording it.
- **Plain words:** explain jargon the first time, with an example in this game's own terms.
  {{BEGINNER_LINE}}
- **Said twice → reminder:** a rule the user has to repeat goes into `.claude/reminder.md` (shown
  with every message; the first one starts from the kit's template, in the folder the
  session-start card names) as well as into `.claude/memory/`.
- **Use what's held first:** before making a look, an asset or a placeholder, list what the project
  already holds that could drive it (assets, data fields, `docs/research/`) and say which you use.
  A property with no source is marked as a guess. Generic placeholders read as fake.
- **Record answers:** design answers go into a decision record (`docs/decisions/`) in the same
  session; the user's playtest verdicts too, then they become plan tasks.
- **A rejected plan is paused:** before any task in a plan, read its verdicts. A recorded
  rejection or a named other direction makes the next task a question with a recommendation, not
  work. Flagging the risk and building anyway is not asking.
- **Outside feedback** (friends, testers) is data: record it as *proposed* with who said it and
  when, give your own expert take, build it only when the user says so.
- **Feel feedback → tuning first:** "too floaty", "too slow" becomes a change to a tuning value
  (`.claude/rules/tuning.md`) before it becomes a code change; say which value and by how much.
- **Timebox polish:** after two feedback rounds on one thing, offer to park it in the polish
  milestone (record what is left, in the user's words) as the recommended option. The user may
  choose another round.
