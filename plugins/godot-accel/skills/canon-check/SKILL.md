---
name: canon-check
description: Check new game writing against the project's story or world bible before it is built — dialogue, names, items, places, quest text. Reports contradictions and tone problems, and routes new inventions to a canon request.
argument-hint: "[the content, or the file it is in]"
---

Content: $ARGUMENTS

**Canon docs:** the ones CLAUDE.md declares, else `docs/canon/bible.md` and `docs/canon/README.md`.
None exist → say "no canon docs declared; nothing to check against" and stop.

Read the canon doc's premise, tone and naming rules and the entries the content touches, then
check. One line per problem, each with a fix:

1. **Canon:** contradicts nothing marked *canon*. If it must, stop and ask the user.
2. **Rules:** the canon's own rules (era or setting limits, real-world names, rating, what never
   appears).
3. **Names:** every proper noun exists in canon or is new; new ones are consistent in style with
   the existing ones and unique.
4. **Voice and tone:** characters sound like their entries; the tone matches the canon's.
5. **Repetition:** the same joke, phrase or idea already used nearby.
6. **Bookkeeping:** every new name, place, item or fact goes into a request file
   (`docs/canon/requests/YYYY-MM-DD-<topic>.md`, from `_template.md`), tagged *provisional*, in
   the same change. Build sessions never edit the bible itself (`docs/canon/README.md`).

Finish with **"canon-check: clean"** or the numbered list of fixes.
