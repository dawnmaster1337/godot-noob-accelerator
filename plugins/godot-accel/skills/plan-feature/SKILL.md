---
name: plan-feature
description: Plan a new feature, mechanic or system for a Godot game before any code — when the user asks to plan, design or add something new ("I want the player to double jump", "let's add an inventory", "how should saving work", "plan the next milestone"). Asks the open questions one at a time with recommendations, records the answers as a decision, writes a plan with a Done line and tasks, and waits for the user's OK.
argument-hint: "[the feature in the user's words]"
---

Request: $ARGUMENTS

**Too small to plan?** A tweak to something that exists (a number, a colour, one line of
behaviour) needs no plan: say so in one line and build it with the normal workflow.

1. **Where it fits:** read `docs/plans/roadmap.md` (is it due now, or later?), the page in
   `docs/systems/` it touches, the decision records that page cites, and `docs/research/` (what
   good looks like here; a subagent brief names it too). If it contradicts a decision or a locked
   standard, say so and ask first.
2. **Echo it back** as a short list (what the player does, sees, feels) and confirm.
3. **Engine know-how:** if GodotPrompter is installed, load `godot-prompter:godot-grill` when
   there are open design decisions, then the domain skill (`player-controller`, `inventory-system`,
   `save-load`…). Without it, rely on the project's rules. **Ready-made first:** if
   `godot-sourcing:find-assets` is available and the feature needs an asset, a shader or a
   common system, run it before designing one; the user's pick is recorded with the answers.
4. **Questions, one at a time,** scope first, each with a recommendation the user can take with
   "APR"; stop when nothing open changes the build. Plain words; a mockup for anything visual
   (`.claude/rules/working-with-user.md`).
5. **Record** the answers: `docs/decisions/YYYY-MM-DD-<topic>.md` from its `_template.md`
   (status decided, the user's answers, rejected options) and a row in
   `docs/decisions/README.md`. A home not made yet (the shape's *first use*: decisions, system
   pages) starts from the kit's template of the same path, `${CLAUDE_SKILL_DIR}/../bootstrap/templates/`;
   a `_template.md` is the project's if it has one, else the kit's.
6. **Plan:** `docs/plans/YYYY-MM-DD-<topic>.md` from its `_template.md`:
   - **Done =** one paragraph a player could check, plus the check that proves it headless;
   - **Design:** scene tree, signals, data resources; the pattern picked, the one rejected, why
     (the first system's plan also picks the layout style in `.claude/rules/gdscript.md`);
   - **Tasks:** small steps, each runnable, the last one a check in `tests/`.
   Add or link the task in `docs/plans/roadmap.md`.
   **A refactor proves its premise first:** grep the duplication and read two call sites (a doc's
   "used by" column is not evidence); say what the guarding check compares. A check that must fail
   when the refactor succeeds (byte-for-byte output) guards nothing. No caller needs it yet: park it.
7. **Show** the plan in under ten lines and ask for the OK. No code before it.
8. **On OK:** build task 1 (CLAUDE.md workflow: small steps, checks, a run after each), tick
   tasks as they land, and finish with `save-work`. When it's done, write or update the system's
   page in `docs/systems/` (what is true now).
