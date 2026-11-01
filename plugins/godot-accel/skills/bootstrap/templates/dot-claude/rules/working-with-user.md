# Working with the user

- **Questions:** numbered, **one at a time**, each with a recommendation the user can take with
  "APR" (as per recommendation). Mark the recommended option first. Answers in a batch
  ("q1 APR, q2 B") are fine: apply each.
- **Echo first:** repeat a multi-part request back as a short list before building it. Separate
  what the user decided from what they are only leaning towards; confirm a lean before recording it.
- **Plain words:** explain jargon the first time, with an example in this game's own terms.
  {{BEGINNER_LINE}}
- **Looks are shown, not described:** for any decision about how something looks, show a mockup
  or screenshot with a recommendation.
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
- **Reviews:** the adversarial reviewer runs at the end of a milestone, when merging a branch
  built by a subagent or worktree, or when the user asks; not after every task. Afterwards fix the
  obvious findings at once (bugs, crashes, softlocks, lint, docs that contradict code) and ask
  only about findings that touch a design decision, one at a time.
- **Trigger words** ("resume", "save work", "wrap up", "running out of usage"…) belong to the
  kit's skills: follow the skill whose description matches (`resume`, `save-work`).
