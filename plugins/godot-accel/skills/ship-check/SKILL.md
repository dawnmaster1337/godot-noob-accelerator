---
name: ship-check
description: Pre-commit gate for a Godot project — lints changed GDScript, runs every headless check, play-tests (through the editor MCP's playtester when the project has one), runs the adversarial reviewer only at milestones, fixes what it finds, then proposes a commit. Use when save-work's gate calls for it, or the user asks to check everything before a commit ("ship check", "is it ready to commit?"). Not an export build.
argument-hint: "[what this change is supposed to do]"
allowed-tools: Read Bash(git status *) Bash(git diff *) Bash(git ls-files *) Bash(tools/dev.sh *) Bash(gdlint *) Bash(gdformat *)
---

!`git status --short 2>/dev/null || echo "not a git repo"`

!`git diff --stat HEAD 2>/dev/null | tail -5; true`

Intent of this change: $ARGUMENTS

!`cat .claude/godot-accel/ship-check.md 2>/dev/null; true`

Project steps (from `.claude/godot-accel/ship-check.md`, shown above if any) run after step 2.

Run in order; don't skip a step because an earlier one looked clean (step 3 runs only at a
milestone).

1. **Lint:** `tools/dev.sh lint` (gdlint + `gdformat --check` on changed `.gd` files). Fix every
   failure, re-run until clean. C# project: build it (`dotnet build`) and fix every error.
2. **Checks, then play:** every check, `tools/dev.sh check` (or the project's test command in
   CLAUDE.md); the per-step runs were only the targeted ones. A fixed bug: update
   `docs/known-bugs.md`; a check added for that fix is proven by reverting the fix once and
   watching it fail (`.claude/rules/showing-work.md`).
   Then play-test the change:
   - with a `playtester` agent in `.claude/agents/`: delegate to it with the intent above and a
     concrete scenario that exercises the change;
   - otherwise: run the game (`godot --path .`, or a test scene), read its output, and say what
     you could and could not verify; ask the user to play the scenario if it needs eyes.
   Fix every error, then play again.
3. **Adversarial review — milestones only:** the end of a roadmap milestone, merging a branch a
   subagent or worktree built, or when the user asks. Otherwise skip it and say so. When it runs,
   delegate to `adversarial-reviewer` with only the intent above and, for committed work, the
   commit range (the milestone's first commit's parent `..HEAD`): never your summary.
4. **Fix:** every CRITICAL and HIGH finding, and the obvious ones of any severity, without asking
   (bugs, crashes, softlocks, stuck input, lint, docs that contradict the code). Ask only about
   findings that touch a design decision, one at a time with a recommendation. Each MEDIUM or
   LOW you leave: one line on why it's acceptable now. Changed code → repeat steps 1–3 once; a
   second FIX FIRST verdict → stop and show the findings.
5. **Report and propose:** the reviewer's verdict (or "review skipped: not a milestone"), the
   play-test result, the checks' last line, **To try:** what the user should open and do to feel
   the change, and a commit message (imperative, ≤ 72 characters).
   Ask whether to commit. Commit only on yes, staged by path; push per `.claude/rules/git.md`.
