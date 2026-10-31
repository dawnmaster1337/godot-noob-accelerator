# Inbox — drop things here between sessions

Godot ignores this folder (the `.gdignore` file) and git ignores everything in it except this
README, so nothing here can break the game. Claude checks it at the start of every session
(`resume`), moves what's ready into the project, and empties it.

- `assets/` — downloaded packs. **One folder per pack**, zip and all, plus a `NOTES.md`:

  ```
  Link: https://...
  Licence (as the page says it): CC0 / credit "..." / ...
  What it's for: e.g. "forest tiles", "a jump sound"
  ```

- `refs/` — pictures that show *what* something is (a real object, a mood).
- `notes/` — plain-text ideas: dialogue, playtest notes, bugs, feature wishes. Any `.md` or
  `.txt` file. Shapes you can copy are in `docs/guides/between-sessions.md`.
- `handovers/` — instructions written by another session or agent for this one.

Nothing for the project should stay in your Downloads folder: download there, then move it here.
