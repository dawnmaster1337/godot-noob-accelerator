# <System>: what is true now

Updated YYYY-MM-DD (session <n>). One page per system; it says what the game does **now**. Why it
does it: the dated records listed under Sources. Budget: 10,000 characters (detail goes into the
record it cites).

## 1. Overview

What the system is for, in two or three lines.

## 2. Scenes and scripts

| Path | Does |
|---|---|
| | |

## 3. Data

Resource types and where their files live. Every value the user may tune, so they can change it
without asking:

| Value | File | Inspector group | Safe range | Does |
|---|---|---|---|---|
| | | | | |

## 4. Checks

The checks that prove it (`tools/dev.sh check <name>` runs them after a change here), and what
the live run should show.

Playtest checklist, for the user (tick and date each one when tried):

- [ ] *scenario* — last tried YYYY-MM-DD

## 5. Open

Known gaps and untested behaviour. Bugs: `docs/known-bugs.md`.

## 6. Sources (`docs/decisions/`)

- `YYYY-MM-DD-<topic>.md` — what it decided.

## 7. Doc vs code mismatches

Anything this page and the code disagree on, until one of them is fixed.
