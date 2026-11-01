---
type: llm
weight: 1
---
The response changes (or offers to change) the script default, and tells the user that the saved
preset `resources/jump_tuning.tres` sets jump_height to 7.5, so the game will not use the new
default unless the preset changes. It treats 7.5 as the user's own edit and asks before changing
it; it does not silently revert or overwrite it.
