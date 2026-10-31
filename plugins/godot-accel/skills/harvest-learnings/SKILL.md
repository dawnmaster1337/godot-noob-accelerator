---
name: harvest-learnings
description: Turn what this project has learned about working with Claude into feedback for the Godot Noob Accelerator kit — compares the project's CLAUDE.md, rules, docs conventions and memory with the kit's templates, keeps only lessons that would help any project, strips all project content, and writes ready-to-paste GitHub issue bodies. Never posts anything. Run it by typing it.
argument-hint: "[optional: an area to focus on, e.g. rules, saving, hooks]"
disable-model-invocation: true
allowed-tools: Read Glob Grep Bash(diff *) Bash(git log *) Bash(ls *)
---

Focus: $ARGUMENTS

Kit templates: `${CLAUDE_SKILL_DIR}/../bootstrap/templates/` (`dot-claude/` = `.claude/`). Kit
version: `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`.

!`git log --oneline -- CLAUDE.md .claude docs/guides docs/decisions/README.md 2>/dev/null | head -30`

1. **Compare** the project with the templates: `CLAUDE.md` (sections added, removed, reworded;
   the Hard rules), each `.claude/rules/*.md`, `.claude/memory/` (every `feedback` and `user`
   memory), `.claude/budgets.md`, `docs/guides/quirks.md`, project skills and agents in
   `.claude/`, and the docs layout. The git log above shows what got corrected over time.
2. **Keep only lessons that would help any project** using the kit: a rule the user had to ask
   for twice, a step every save needed, a check that caught real bugs, a template section nobody
   used, a budget that was too tight. Drop anything that only makes sense for this game.
3. **Strip all project content:** no game name, story, characters, places, item or asset names,
   file paths unique to this project, people's names, usernames, emails, URLs, keys or machine
   details. Replace an example with a tiny invented one, marked *example*. Re-read each body for
   leftovers before showing it.
4. **Write one issue body per lesson** in this exact shape (it matches the kit's
   `learning.yml` form):

   ```
   ### Kit version
   <from plugin.json>
   ### Area
   <bootstrap | CLAUDE.md template | rules | memory | skills | agents | hooks | docs skeleton | other>
   ### What the kit does now
   <one or two lines; name the kit file>
   ### What we changed or learned
   <the change, or the rule we added>
   ### Why
   <what went wrong without it, in general terms>
   ### Suggested change to the kit
   <file + the exact text to add, change or remove>
   ### Checks
   - [x] I removed all project-specific content
   ```

5. **Show** the bodies to the user, numbered, and say: paste each into a new issue with the
   **Learning** template in the kit's repository. Never open, post or send anything yourself.
