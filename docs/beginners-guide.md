# The beginner's guide: make a game with Claude, from zero

This guide is for you if you've **never used Claude Code, never made a game in Godot, and maybe
never written code**. You'll describe your game in plain English; Claude writes the code, keeps
the notes, and checks its own work. You play, react, and decide.

It takes about an hour to set up the first time. After that, every session starts with one word.

> **How to read this:** do the steps in order. Grey boxes are things you type or copy. Anything in
> `<angle brackets>` is a placeholder: replace it with your own thing, without the brackets.

---

## Part 1 — What all these things are

| Thing | What it is | Why you need it |
|---|---|---|
| **Godot** | A free program for making games. You build and play your game in it | It's the engine your game runs on |
| **Claude Code** | Claude, working inside your project folder: it can read, write and run things there | It builds the game with you |
| **This kit** | An add-on (a *plugin*) for Claude Code | It teaches Claude how to run a game project properly: take notes, remember your decisions, test its work, save safely |
| **Git** | A tool that saves snapshots (*commits*) of your project | You can always undo, and nothing gets lost |
| **GitHub** | A website that stores those snapshots online | Backup, and your project on more than one computer |
| **A terminal** | A window where you type commands instead of clicking | Claude Code runs in it. You'll only need a few commands |

**You don't need to learn to code.** You'll pick some of it up along the way, and you can always
ask Claude "explain that like I've never coded".

---

## Part 2 — Accounts (10 minutes)

1. **Claude:** you need a paid Claude plan that includes Claude Code (or an Anthropic API
   account). See https://claude.com/pricing. Bigger plans give you more usage per day; games use a
   lot.
2. **GitHub:** make a free account at https://github.com/signup. Pick a username you're happy to
   show people.

---

## Part 3 — Install the tools (20–30 minutes)

### 3.1 Open a terminal

- **Windows:** press the Windows key, type **Terminal**, press Enter.
- **macOS:** press Cmd+Space, type **Terminal**, press Enter.
- **Linux:** you probably know; usually Ctrl+Alt+T.

You'll see a line waiting for you to type. That's it. To paste in a terminal: Ctrl+Shift+V
(Linux), Cmd+V (macOS), right-click or Ctrl+V (Windows).

### 3.2 Godot

1. Go to https://godotengine.org/download and download the **standard** version (not .NET,
   unless you already know you want C#).
2. **Windows:** unzip it into a folder you'll keep, like `C:\Godot`. **macOS:** drag Godot into
   Applications. **Linux:** unzip it somewhere like `~/Applications`.
3. Open it once by double-clicking to check it works, then close it.

Claude also needs to start Godot from the terminal (to run its tests). The command must be
`godot`. The easiest way: once Claude Code is installed (3.4), ask it:

```
Help me make the "godot" command work in my terminal. Godot is installed at <where you put it>.
```

### 3.3 Git and the GitHub tool

- **Windows:** install Git from https://git-scm.com/download/win (all the default options are
  fine), then GitHub CLI from https://cli.github.com.
- **macOS:** install Homebrew from https://brew.sh (copy its one command into Terminal), then
  type `brew install git gh`.
- **Linux:** use your package manager, e.g. `sudo apt install git gh` or `sudo pacman -S git github-cli`.

Then sign git in to GitHub. Type this and follow its questions (choose **GitHub.com**, **HTTPS**,
and **log in with a web browser**):

```bash
gh auth login
```

### 3.4 Claude Code

Follow the official quickstart: https://code.claude.com/docs/en/quickstart. It gives you one
command to copy into your terminal for your system. When it's done, typing `claude` in a terminal
starts it, and the first time it asks you to log in.

There is also a desktop app (it has Claude Code built in) if you'd rather click than type; this
guide uses the terminal because it works the same everywhere.

### 3.5 Optional helpers (ask Claude to do these for you later)

- **gdtoolkit**: tidies and checks GDScript code automatically. Ask Claude: "install gdtoolkit
  for me".
- **jq**: a small tool the kit's automatic checks use. Ask Claude: "install jq for me".

The kit works without them; it just skips those checks and tells you.

---

## Part 4 — Make your game's project (5 minutes)

1. Open Godot. In the Project Manager click **Create** (or **+ Create**).
2. Give it a name (your game's name is fine), pick a folder you'll find again (like
   `Documents/Games/<your-game>`), leave the renderer as it is, click **Create**.
3. Godot opens the empty project. Close Godot again (Claude works best with the files closed the
   first time).

---

## Part 5 — Start Claude in your project (5 minutes)

In the terminal, go to your project folder. `cd` means "change directory" (go into a folder):

```bash
cd <path to your project folder>
```

Tip: type `cd ` (with a space), then drag the folder from your file browser onto the terminal
window, and press Enter.

Then start Claude:

```bash
claude
```

The first time, it asks whether you trust this folder: say yes (it's your project).

---

## Part 6 — Install this kit and its companion (5 minutes)

Inside Claude Code, type these one at a time and press Enter after each. The lines starting with
`/` are Claude Code commands, not messages to Claude.

```
/plugin marketplace add dawnmaster1337/godot-noob-accelerator
```

```
/plugin install godot-accel@godot-accel
```

Recommended companion, which gives Claude deep Godot know-how (how to build movement, menus,
saving and so on the right way):

```
/plugin marketplace add jame581/skillsmith
```

```
/plugin install godot-prompter@skillsmith
```

Then restart Claude Code so they load: type `/exit`, then `claude` again.

---

## Part 7 — Set up your project with the kit (10 minutes)

Type:

```
/godot-accel:bootstrap
```

Claude asks you up to eight questions, **one at a time**, and suggests an answer for each. If
you're not sure, type **APR** ("as per recommendation") and it takes its suggestion. It asks:

1. Your game's name.
2. What the game is, in one line ("a cosy farming game where the crops talk").
3. Which language (say **APR**: GDScript).
4. How to test (say **APR**).
5. Whether your game has a story or world to keep consistent.
6. Whether you use a "Godot MCP server" (if you don't know what that is: **no**).
7. How new you are (be honest: it changes how much it explains).
8. A few extras (say **APR**).

Then it shows you a list of files it will create and waits for your **yes**. It never overwrites
a file you already have. When it's done, it tells you what it made and what to do next.

### What it just made (you don't need to read these now)

| File | What it's for |
|---|---|
| `CLAUDE.md` | Claude's instructions for your project. It reads this every session |
| `.claude/rules/` | Rules Claude follows: how to write code, how to talk to you, how to save |
| `.claude/memory/` | Things Claude learns about how you like to work |
| `docs/STATUS.md` | Where you stopped and what's next. **The most important file** |
| `docs/decisions/` | Every decision you make, and why, so nobody forgets |
| `docs/plans/` | The plan for your game, and for each big feature |
| `docs/guides/start-here.md` | The short version of this guide, for every day |
| `inbox/` | Your drop box: put downloads, notes and ideas here between sessions |
| `tools/dev.sh` and `tests/` | Automatic checks Claude runs to prove things still work |

---

## Part 8 — Put it on GitHub (5 minutes)

Ask Claude:

```
Make a private GitHub repo for this project and push it. Explain each step.
```

It will show you each command and ask before running anything that changes things. From now on,
every **save work** backs your project up there.

---

## Part 9 — Make something

Just ask for it, in your own words. Start small:

```
I want a character I can move around with the arrow keys. Use a coloured square for now.
```

What happens next:

1. Claude asks a few questions, one at a time, each with a suggestion.
2. For anything bigger, it writes a short **plan** and waits for your OK.
3. It builds it, runs its checks, and tells you what it did and what the checks said.
4. **You play it.** Open Godot (double-click the project in the Project Manager) and press **F5**
   (macOS: **Cmd+B**). Stop with **F8** or close the game window.
5. Tell Claude how it felt. "Too slow", "it slides like ice", "the square should be blue". You don't
   need technical words.
6. When you like it: **save work**, then **yes** when it asks to commit.

---

## Part 10 — Every day after this

Open a terminal in your project folder, type `claude`, then:

| You say | What happens |
|---|---|
| **resume** | Claude checks GitHub for changes (asks before pulling), reads where you stopped, checks your inbox, and tells you what's next |
| *anything you want* | It plans, asks, builds, checks |
| **APR** | Take its suggestion |
| **save work** | Check, then save a snapshot (on your yes) and back it up |
| **wrap up** | End-of-day save: also writes down where you stopped and what it learned |
| **I'm running out of usage** | A fast save so nothing is lost |
| `/clear` | Fresh chat (its notes stay). Do it after a save, between tasks: it's cheaper and sharper |

Your project's own `docs/guides/start-here.md` has this table too.

---

## When something goes wrong

| What you see | What to do |
|---|---|
| "godot: command not found" | Ask Claude: "help me make the godot command work". Until then it can still write code, just not test it |
| Claude says a check failed | Normal! Say "fix it". It should fix it before showing you anything |
| The game doesn't start / red errors in Godot | Copy the red text (or screenshot it into `inbox/notes/`) and tell Claude |
| Claude seems confused or repeats itself | Say **save work**, then `/clear`, then **resume** |
| You don't understand what it said | "Explain that like I've never coded" |
| You hit your usage limit | Next time, start with **resume**: it picks up from the notes |
| You want to undo something | "Undo the last thing you changed" or "go back to the last commit". It asks before throwing anything away |
| It wants to do something you don't understand | Say no. Ask what it is first. Nothing bad happens from saying no |

---

## Safety, in four lines

1. **Never paste passwords, API keys or tokens into the chat.** If a tool needs one, Claude tells
   you what to type in a normal terminal yourself.
2. **Read before you say yes** to a commit, a download or a purchase. "What will this do?" is
   always a fine answer.
3. **Only use free assets you're allowed to use** (look for CC0 or "free for commercial use").
4. **Save often.** A commit is free and it's the undo button for your whole project.

---

## Words you'll hear

| Word | Plain meaning |
|---|---|
| **scene** (`.tscn`) | A building block of your game: a level, the player, a menu |
| **node** | One piece inside a scene: a sprite, a sound, a collision box |
| **script** (`.gd`) | Code attached to a node that makes it do things |
| **GDScript** | Godot's own simple coding language |
| **resource** (`.tres`) | A data file: a character's stats, an item, a level's settings |
| **autoload** | Something that's always running, like the music or the save system |
| **commit** | A saved snapshot of the whole project |
| **push / pull** | Upload to / download from GitHub |
| **repo** | Your project's home on GitHub |
| **check / test** | A small automatic program that proves something works |
| **plan** | A short document Claude writes before a big feature, for your OK |
| **decision record** | A note of what you decided and why |
| **skill** | A recipe Claude follows for a job (setting up, saving, planning) |
| **subagent** | A helper Claude sends off to do one job, like a reviewer |
| **hook** | An automatic check that runs on its own at certain moments |
| **plugin** | An add-on for Claude Code. This kit is one |
| **MCP server** | An optional bridge that lets Claude control another program, like the Godot editor |
| **APR** | "As per recommendation": take Claude's suggested answer |

---

## Where next

- `docs/how-it-works.md`: how the kit runs a project, in more depth.
- `docs/structure.md`: every file the kit creates, and why.
- `docs/customising.md`: change the rules to fit how you work.
- Found something confusing? That's useful feedback: see "Feedback" in the README.
