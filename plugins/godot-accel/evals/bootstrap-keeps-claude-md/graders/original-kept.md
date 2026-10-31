---
type: regex
pattern: "KEEP-THIS-LINE: the user wrote this file by hand."
match: contains
target: { source: file, path: CLAUDE.md }
arm: both
---
The user's own line is still in CLAUDE.md after the run.
