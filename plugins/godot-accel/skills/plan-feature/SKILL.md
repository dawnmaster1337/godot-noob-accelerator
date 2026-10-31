---
name: plan-feature
description: Plan a new feature, mechanic or system for a Godot game before any code — when the user asks to plan, design or add something new ("I want the player to double jump", "let's add an inventory", "how should saving work", "plan the next milestone"). Asks the open questions one at a time with recommendations, records the answers as a decision, writes a plan with a Done line and tasks, and waits for the user's OK.
argument-hint: "[the feature in the user's words]"
---

Request: $ARGUMENTS

**Too small to plan?** A tweak to something that exists (a number, a colour, one line of
behaviour) needs no plan: say so in one line and build it with the normal workflow.

1. **Where it fits:** read `docs/plans/roadmap.md` (is it due now, or later?), the page in
   `docs/systems/` it touches and the decision records that page cites. If it contradicts a
   decision or a locked standard, say so and ask first.
2. **Echo it back** as a short list (what the player does, sees, feels) and confirm.
3. **Engine know-how:** if GodotPrompter is installed, load `godot-prompter:godot-grill` when
   there are open design decisions, then the domain skill (`player-controller`, `inventory-system`,
   `save-load`…). Without it, rely on the project's rules.
4. **Questions, one at a time,** scope first, each with a recommendation the user can take with
   "APR"; stop when nothing open changes the build. Plain words; a mockup for anything visual
   (`.claude/rules/working-with-user.md`).
5. **Record** the answers: `docs/decisions/YYYY-MM-DD-<topic>.md` from its `_template.md`
   (status decided, the user's answers, rejected options) and a row in
   `docs/decisions/README.md`.
6. **Plan:** `docs/plans/YYYY-MM-DD-<topic>.md` from its `_template.md`:
   - **Done =** one paragraph a player could check, plus the check that proves it headless;
   - **Design:** scene tree, signals, data resources; the pattern picked, the one rejected, why;
   - **Tasks:** small steps, each runnable, the last one a check in `tests/`.
   Add or link the task in `docs/plans/roadmap.md`.
7. **Show** the plan in under ten lines and ask for the OK. No code before it.
8. **On OK:** build task 1 (CLAUDE.md workflow: small steps, checks, a run after each), tick
   tasks as they land, and finish with `save-work`. When it's done, write or update the system's
   page in `docs/systems/` (what is true now).
