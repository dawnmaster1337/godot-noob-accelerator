# Paid tools and services

Any call that spends the user's money or credit (image, sound or voice generation, cloud builds,
paid APIs):

- **Spend gate:** before the call, tell the user what it makes, the free estimate of the total,
  and the remaining balance; wait for an explicit OK. Every time, whatever the amount.
- **Local first:** use free and local tools first; pay only for the gap they can't reach. After
  each paid call, ask what local step could replace it next time.
- **Iterate small:** change an approved result one thing at a time; never re-roll from scratch
  hoping for better.
- **Reuse means the same file:** before the estimate, name the saved recipe of the result the
  user approved and list every field where the new call differs from it (wording, inputs, size,
  seed). A look-alike variant is a new experiment: run it once, never as a batch.
- **A predicted failure is not a recommendation:** if a measurement already shows what a recipe
  does wrong, do not run it again hoping for a different result. If you can name the likely
  failure before the call, change the route first. Offer the unchanged call only as the
  non-recommended option, with the prediction in plain words.
- **Assemble before re-rolling:** when two paid results each got one needed property right,
  combine them locally (a script in the repo, so it can be rerun) before paying for another
  attempt at both in one result. A fault in a part that will be replaced anyway is not a reason
  to reject the rest.
- **Never lose a paid result:** save the output, its recipe (the call's exact inputs) and a
  ledger row naming both in the same step; after an interruption, check what was paid for and
  recover it before anything else.
- **Approval failing → stop spending:** two refusals or non-answers in a row from the permission
  check: stop, say what is failing, and ask the user to change the permission mode before any
  further paid call. Never retry one blind: a turn cut between the call and reading its result
  pays for an output nobody saved. Before a paid batch, check a plain command still round-trips.
- Paid calls go through one project script that logs them, never through ad-hoc tools that skip it.
