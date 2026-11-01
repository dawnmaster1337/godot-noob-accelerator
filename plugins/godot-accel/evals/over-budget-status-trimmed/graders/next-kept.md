---
type: regex
pattern: "KEEP-NEXT-STEP[\\s\\S]*KEEP-OPEN-QUESTION"
match: contains
target: { source: file, path: docs/STATUS.md }
arm: both
---
The Next step and the open question survive the trim.
