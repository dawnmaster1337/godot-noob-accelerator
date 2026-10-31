# Paid tools and services

Any call that spends the user's money or credit (image, sound or voice generation, cloud builds,
paid APIs):

- **Spend gate:** before the call, tell the user what it makes, the free estimate of the total,
  and the remaining balance; wait for an explicit OK. Every time, whatever the amount.
- **Local first:** use free and local tools first; pay only for the gap they can't reach. After
  each paid call, ask what local step could replace it next time.
- **Iterate small:** change an approved result one thing at a time; never re-roll from scratch
  hoping for better.
- **Never lose a paid result:** save the output and a ledger row in the same step; after an
  interruption, check what was paid for and recover it before anything else.
- Paid calls go through one project script that logs them, never through ad-hoc tools that skip it.
