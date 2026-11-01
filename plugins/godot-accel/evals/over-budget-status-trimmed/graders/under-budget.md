---
type: regex
pattern: "^[\\s\\S]{0,5000}$"
match: contains
target: { source: file, path: docs/STATUS.md }
arm: both
---
STATUS is under its 5,000-character budget afterwards.
