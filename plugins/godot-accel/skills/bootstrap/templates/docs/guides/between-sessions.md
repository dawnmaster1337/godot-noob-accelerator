# Working on {{GAME_NAME}} between Claude sessions

For you, when Claude isn't running (out of usage, or you just want to tinker). Nothing here can
break anything that Claude can't fix next session.

**Before and after every session:** open Claude in the project folder and type **resume**. Claude
shows what changed and what's next. When you're done, say **save work** (or **wrap up** at the
end of the day). Claude commits only after you say yes.

## 1. Bring in assets

1. Only take **free, commercial-use-OK** packs: CC0 or "credit required" is fine; avoid
   "non-commercial", "share-alike" (CC BY-SA) and GPL unless you know what that means for you.
2. Make a folder per pack in `inbox/assets/` and put the download in it. Don't unzip or rename.
3. Add a `NOTES.md` beside it (link, licence, what it's for).

Claude checks the licence, installs the pack unmodified, records it, and empties the inbox.

## 2. Write ideas down (no Godot needed)

Any `.md` or `.txt` file in `inbox/notes/`. These shapes help Claude turn them into the game:

```
## Idea: double jump
What: the player can jump again in mid-air, once.
Why: the second level has gaps that feel unfair.
```

```
## Playtest
- Level 1: the third platform is too far to reach.
- Menu: pressing Esc twice crashes.
```

```
## Line: shopkeeper
Shopkeeper: Back again? You must really like rocks.
```

## 3. Play and take notes

Open the project in Godot and press **F5** to play (**F8** or closing the window stops it).
Write what felt off in `inbox/notes/playtest.md` straight away, while you remember. Screenshots
help: put them in `inbox/notes/` too.

## Don't

- Edit `.gd` files (code) unless you want to: Claude can do it and keeps the checks passing.
- Touch anything in `.godot/` (Godot's cache) or `addons/` (other people's plugins).
- Move or rename files in Godot's FileSystem panel without telling Claude (other files point at
  them; Godot fixes most links, Claude checks the rest).
- Worry about git: leave changes uncommitted. Claude reviews them first thing.
