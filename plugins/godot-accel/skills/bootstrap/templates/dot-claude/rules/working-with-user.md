# Working with the user

- **Questions:** numbered, **one at a time**, each with a recommendation the user can take with
  "APR" (as per recommendation). Mark the recommended option first. Answers in a batch
  ("q1 APR, q2 B") are fine: apply each.
- **Echo first:** repeat a multi-part request back as a short list before building it. Separate
  what the user decided from what they are only leaning towards; confirm a lean before recording it.
- **Plain words:** explain jargon the first time, with an example in this game's own terms.
  {{BEGINNER_LINE}}
- **Steps for the user go last:** anything they must do by hand (a login, a download, a setting)
  goes in the turn's final message, not mid-turn, where it may never be seen (the user may be on a
  phone). More than a few lines → a file in the repo, sent as a file, its path in that message.
- **The final message stands alone:** what changed, what failed or is unverified, and the one
  question with its choices. Never rely on a summary box or a mid-turn message being seen.
- **Said twice → reminder:** a rule the user has to repeat goes into `.claude/reminder.md` (shown
  with every message; the first one starts from the kit's template, in the folder the
  session-start card names) as well as into `.claude/memory/`.
- **Looks are shown, not described:** for any decision about how something looks, show a mockup
  or screenshot with a recommendation.
- **Use what's held first:** before making a look, an asset or a placeholder, list what the project
  already holds that could drive it (assets, data fields, `docs/research/`) and say which you use.
  A property with no source is marked as a guess. Generic placeholders read as fake.
- **Record answers:** design answers go into a decision record (`docs/decisions/`) in the same
  session; the user's playtest verdicts too, then they become plan tasks.
- **Outside feedback** (friends, testers) is data: record it as *proposed* with who said it and
  when, give your own expert take, build it only when the user says so.
- **Feel feedback → tuning first:** "too floaty", "too slow" becomes a change to a tuning value
  (`.claude/rules/tuning.md`) before it becomes a code change; say which value and by how much.
- **One piece, then a playtest:** a request that bundles several mechanics is built one usable
  piece at a time; stop after each for the user to try it.
- **End each task with "open X, try Y":** the scene to open and what to do to feel the change.
- **Timebox polish:** after two feedback rounds on one thing, offer to park it in the polish
  milestone (record what is left, in the user's words) as the recommended option. The user may
  choose another round.
