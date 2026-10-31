# Canon folder — who writes what

`docs/canon/bible.md` is the source of truth for story, setting, characters, names and tone.
Check it (the `canon-check` skill) before writing any dialogue, names, items, enemies or places.

Two Claude sessions can run at once in one checkout:

- **The canon session** talks story and world with the user and keeps the bible. It **owns
  `docs/canon/`** and writes nothing outside it. Start it with: "You are the canon session: read
  `docs/canon/README.md`."
- **The build session** (every other session) builds the game. It **never edits
  `docs/canon/bible.md`**; it asks for changes with a request file.

This keeps the two from overwriting or committing each other's half-done work.

## The build session

- Anything new for the bible (a name, place, item, fact) goes into a **new file**
  `docs/canon/requests/YYYY-MM-DD-<topic>.md`, copied from `requests/_template.md`, tagged
  *provisional*. One file per change set; never edit another session's request file.
- Canon wins: if the build needs something that contradicts canon, stop and ask the user.

## The canon session

- Start: `git fetch`, read this file, `bible.md`, `requests/`, then talk to the user.
- One question at a time, each with a recommendation. New inventions go in tagged
  *provisional*; the user's yes makes them *canon*. Ask before contradicting canon.
- Merge each request file into the bible, then delete it in the same commit.
- Open questions live in the bible's "Open questions" list.
- Save: stage only `docs/canon/` by path, commit on the user's yes, push.
