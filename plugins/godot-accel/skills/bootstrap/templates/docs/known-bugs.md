# Known bugs

The one list of bugs known and not yet fixed. Check it before fixing a bug; update it in the same
change as the fix. Playtest notes from `inbox/` land here. Budget: 6,000 characters.

## Open

Copy this block per bug, newest first. Status: `open` · `in progress` · `can't reproduce`.

A cause written here is a claim until measured: re-measure it (a cheap temporary trace) before
building its fix, and correct the entry when it's wrong. `can't reproduce` is a finding, not a
dead end: it usually means the data model can't express something the reporter expects. Ask
what the data *cannot* say before relabelling anything; if it was never a bug, say so and why.

```
### <Short title>
- Status: open
- Area: <system, matching a page in docs/systems/>
- Reported: YYYY-MM-DD (who)
- Repro: <steps, as a player would do them>
- Expected: <what should happen>
- Actual: <what happens>
```

## Fixed

One line each, newest first: `YYYY-MM-DD <title>: <cause> → <fix>`. Keep the last 20; git keeps
the rest.
