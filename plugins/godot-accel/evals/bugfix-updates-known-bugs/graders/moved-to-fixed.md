---
type: regex
pattern: "## Fixed[\\s\\S]*Coin counted twice"
match: contains
target: { source: file, path: docs/known-bugs.md }
arm: both
---
The bug is in the Fixed list after the fix.
