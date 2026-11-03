---
name: save-work
description: Save work safely so nothing is lost between sessions or machines. Task save after every finished task or when the user says "save", "save work" or "commit". Session save when the user says "wrap up", "I'm done", "switching machines" or at the end of a session. Quick save when the user says they are running out of usage or tokens. Each ends by saying whether it is safe to /clear.
argument-hint: "[what was done] [task|session|quick]"
allowed-tools: Read Bash(git status *) Bash(git diff *) Bash(git log *) Bash(git remote *) Bash(git rev-list *) Bash(tools/dev.sh *)
---

Work done: $ARGUMENTS

!`git status --short 2>/dev/null | head -30; true`

!`git log --oneline -3 2>/dev/null || echo "no commits yet"`

!`git remote -v 2>/dev/null | head -2; true`

!`cat .claude/godot-accel/save-work.md 2>/dev/null; true`

**Which size:** "wrap up", "I'm done", "switching machines", session ending → **session save**;
running out of usage → **quick save**; otherwise **task save**. Project steps (from
`.claude/godot-accel/save-work.md`, shown above if any) run before the commit.

## Task save

1. **Plan tick:** tick the finished task in its plan (`- [x]`). STATUS waits for the session save.
   A manifest (`docs/production/manifest.md`)? Each new placeholder or third-party file has a row.
2. **Gate:** code or scene changes → run the `ship-check` skill (its steps 1–5); then always `tools/dev.sh stale` and
   `budget`.
3. **Secrets:** no API keys, tokens, private keys or `.env` files in the diff or in untracked files
   being added. Found one → stop and say so.
4. **Commit on the user's yes:** show the files and a proposed message (imperative, ≤ 72
   characters); stage **by path**, then `git diff --cached --name-status` holds only those (a
   `git mv` stages itself); commit only after yes.
5. **Push** if the project's git rule says so (`.claude/rules/git.md`), and report it.
6. One line: what is saved, what is pushed, what is next.

## Session save (the task save, then)

1. **STATUS:** rewrite `docs/STATUS.md`: done (short), **Next** in the user's order, open questions
   (the only list). Under 5,000 characters.
2. **Lessons and budgets:** run `trim-context`.
3. **Handoff check:** could another machine pick this up from the repo alone? STATUS Next is
   concrete; decisions indexed; new setup steps in `docs/guides/setup-new-machine.md`; nothing
   important only in this chat. Fix gaps now.
4. Gate, secrets, commit on yes, push, as in the task save.
5. Switching machines: "on the other machine, start `claude` in the project folder: **resume**".

## Quick save (low on usage)

Skip the gate and trim. Write STATUS **Next** (what was being done, the exact next step, any
half-done file) in a few lines, run the secrets check, commit on yes (say it's a work-in-progress
commit) and push. Lessons wait for the next session save.

## Last line, always

**"Safe to /clear: yes"** only when everything is committed and pushed, or **"Safe to /clear: no,
because …"** (uncommitted files, unpushed commits, a question left open).
