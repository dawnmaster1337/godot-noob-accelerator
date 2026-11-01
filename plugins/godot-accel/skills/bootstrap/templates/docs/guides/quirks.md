# Engine and tool quirks

The one home for engine, tool and shell quirks; read before debugging. Budget: 5,500 characters.
A quirk that a script can own moves into the script (`tools/dev.sh`) and leaves this page.
User preferences go to `.claude/memory/`, not here.

One line per quirk: the symptom, then the fix. Example of the shape (delete it once real ones
arrive):

- *Example:* a new `class_name` is "not found" in a headless run → run
  `tools/dev.sh refresh` first (it rebuilds the class cache).

## Editor and MCP

## Headless checks

## GDScript and Godot

## Shell, git, agents

- *Seen 2026-10:* a background wait or kill with `pgrep -f`/`pkill -f '<pattern>'` hangs or kills
  its own shell (the pattern is in the shell's own command line) → wait on the PID
  (`while kill -0 $pid`), or write the pattern so it can't match itself (`pgrep -f '[b]uild.py'`).
- *Seen 2026-10:* `git push` says "Repository not found" with several `gh` accounts logged in →
  the active account has no access. One push as the owner, without switching accounts:
  `git -c credential.helper= -c "credential.helper=!f() { echo username=<account>; echo password=\$(gh auth token -u <account>); }; f" push`
