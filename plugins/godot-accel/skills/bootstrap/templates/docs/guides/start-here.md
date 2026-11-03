# Start here: making {{GAME_NAME}} with Claude

You don't need to know how to code. You describe what you want, Claude builds it, you play it and
say what to change. This page is the whole routine. Keep it open the first few times.

## The words that matter

Type these to Claude in plain English. They're not commands you have to get exactly right; Claude
knows what they mean.

| You say | Claude does |
|---|---|
| **resume** | Gets the latest from GitHub (asks first), reads where you left off, checks the inbox, tells you what's next |
| *what you want, in your own words* | Asks a few questions, one at a time, each with its own suggestion |
| **APR** | "As per recommendation": take Claude's suggestion. Works for a list too: "1 APR, 2 B, 3 APR" |
| **save work** | Checks everything still works, then asks to save a snapshot (a *commit*) and upload it |
| **wrap up** | The end-of-day save: also writes down where you stopped and what it learned |
| **I'm running out of usage** | A quick save that writes down what's next, so nothing is lost |
| **audit the project** | A health check when things feel messy: what's out of place or unused, then one question per fix |

## A normal session

1. Open a terminal in the project folder (the one with `project.godot` in it), type `claude`, then
   **resume**. In the desktop app, open that same folder. Opened one folder too high, the kit's
   checks and rules don't load; its start-up note tells you if that happened.
2. Ask for one thing. Small is good: "make the player jump", "add a coin that disappears when I
   touch it", "the jump feels floaty, make it snappier".
3. Answer Claude's questions. If you don't know, say **APR**.
4. Claude builds it and runs the checks. Then **you play it**: in Godot press **F5** (macOS:
   **Cmd+B**). Stop with **F8** or by closing the window.
5. Tell Claude what felt wrong, in your own words. Screenshots help. Repeat.
6. Happy with it? Say **save work** and answer **yes** when it asks to commit.
7. Done for the day? **wrap up**. Then it's safe to type `/clear` or close the terminal.

**One task per session works best:** resume, one task, save work, `/clear`, resume again. Claude
stays sharper and each session costs less.

## Good to know

- **Claude never saves to GitHub without your yes.** If you're unsure, say no and ask what it's
  saving.
- **Nothing is lost by saying no.** Uncommitted changes stay on your computer; Claude sees them next
  time.
- **`/clear`** gives Claude a fresh, empty memory of the chat (its project notes stay). Do it after
  a save, when a task is finished. It makes the next task cheaper and sharper.
- **Want to change a number yourself** (speed, jump height, a timing)? Once a system is built,
  its page in `docs/systems/` says which file and Inspector group it's in. Change it in Godot; Claude keeps
  your values.
- **Claude says the project was set up with an older kit?** Say **update the kit**: it adds
  what's new and asks before changing anything you wrote.
- **Got an idea or a bug while Claude isn't running?** Write it in a file in `inbox/notes/`
  (`docs/guides/between-sessions.md` has the shapes).
- **Never paste passwords or API keys into the chat.** If Claude needs one, it will tell you which
  terminal command to run yourself.
- **Stuck or confused?** Say so: "I don't understand, explain it like I've never coded". That's
  what it's there for.

## Words you'll hear

| Word | Means |
|---|---|
| **Godot** | The free game engine: the program your game is built and played in |
| **scene** (`.tscn`) | A piece of the game: a level, the player, a menu |
| **script** (`.gd`) | Code attached to a scene that makes it do things |
| **commit** | A saved snapshot of the whole project you can always go back to |
| **push** | Uploading your commits to GitHub, so they're backed up and on your other computers |
| **check** | A small automatic test Claude runs to prove something still works |
| **plan** | A short document Claude writes before building something big, for your OK |
| **decision record** | A note of what you decided and why, so nobody (including Claude) forgets |
