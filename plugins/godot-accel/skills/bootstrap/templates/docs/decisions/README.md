# Decisions — index

One file per topic: `YYYY-MM-DD-<topic>.md`, copied from `_template.md` (a number may follow the
date: `YYYY-MM-DD-adr-0003-<topic>.md`). A record is frozen
history once decided: a later change gets a new record that says what it supersedes, and the
old record's status line says "superseded by …". What is true *now* lives in `docs/systems/`.

A decision that still stands but whose stated **why** turned out false is not superseded: keep
the text, and add to its status line what is wrong and where the correction lives. How a mistake
was made is history too.

Status words: **proposed** (waiting for the user) · **decided** (the user agreed) · **binding**
(the user said it must never be skipped) · **superseded by X** · **decided (reason corrected: X)**.

When a decision changes: grep `docs/` for the old claim and fix every copy in the same change.

One row per record, newest first. Date = the record's file name date; Topic links the file
(`[topic](YYYY-MM-DD-topic.md)`); Status = the first word of the record's **Status:** line
(`**Status:** Accepted` is read as decided).
`tools/dev.sh conform` checks the rows against the records.

| Date | Topic | Status | The rule in one line |
|---|---|---|---|
| | | | |
