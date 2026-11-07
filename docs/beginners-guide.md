# The beginner's guide

**Make a game with Claude, starting from nothing.**

This guide is for you if you've never used Claude Code, never made a game in Godot, and maybe
never written code. You describe your game in plain English; Claude writes the code, keeps the
notes and checks its own work. You play it, react, and decide.

Setting up takes about an hour the first time. After that, every session starts with one word.

> [!TIP]
> **Once you're set up, you only need three words:** **resume** to start, **save work** after
> each thing you like, **wrap up** at the end of the day. Everything else, Claude asks you.

> [!NOTE]
> **How to read this:** do the steps in order. Grey boxes are things you type or copy. Anything
> in `<angle brackets>` is a placeholder: replace it with your own thing, brackets included.
> Each part ends with a ✅ **Check**, so you know it worked before moving on.

| | Part | Time |
|---|---|---|
| 1 | [What all these things are](#1-what-all-these-things-are) | 5 min |
| 2 | [Accounts](#2-accounts) | 10 min |
| 3 | [Install the tools](#3-install-the-tools) | 20–30 min |
| 4 | [Make your game's project](#4-make-your-games-project) | 5 min |
| 5 | [Start Claude in your project](#5-start-claude-in-your-project) | 5 min |
| 6 | [Install the kit](#6-install-the-kit) | 5 min |
| 7 | [Set up your project](#7-set-up-your-project) | 10 min |
| 8 | [Back it up on GitHub](#8-back-it-up-on-github) | 5 min |
| 9 | [Make something](#9-make-something) | as long as you like |
| 10 | [Every day after this](#10-every-day-after-this) | |

Also: [when something goes wrong](#when-something-goes-wrong) · [safety](#safety-in-four-lines) ·
[words you'll hear](#words-youll-hear)

---

## 1. What all these things are

| Thing | What it is | Why you need it |
|---|---|---|
| **Godot** | A free program for making games. You build and play your game in it | It's the engine your game runs on |
| **Claude Code** | Claude, working inside your project folder: it can read, write and run things there | It builds the game with you |
| **This kit** | An add-on (a *plugin*) for Claude Code | It teaches Claude to run a game project properly: take notes, remember your decisions, test its work, save safely |
| **Git** | A tool that saves snapshots (*commits*) of your project | You can always undo, and nothing gets lost |
| **GitHub** | A website that stores those snapshots online | A backup, and your project on more than one computer |
| **A terminal** | A window where you type commands instead of clicking | Claude Code runs in it. You'll only need a few commands |

**You don't need to learn to code.** You'll pick some up along the way, and you can always ask
Claude to "explain that like I've never coded".

## 2. Accounts

1. **Claude:** a paid Claude plan that includes Claude Code (or an Anthropic API account). See
   <https://claude.com/pricing>. Bigger plans give more usage per day, and games use a lot.
2. **GitHub:** a free account at <https://github.com/signup>. Pick a username you're happy to
   show people.

✅ **Check:** you can sign in to both websites.

## 3. Install the tools

> [!NOTE]
> The kit is only tested on **Linux** so far. The Windows and macOS steps below are the usual
> ones for each tool, but nobody has run the whole kit there yet. If something breaks, please
> [tell us](https://github.com/dawnmaster1337/godot-noob-accelerator/issues/new/choose).

### 3.1 Open a terminal

| System | How |
|---|---|
| Windows | Press the Windows key, type **Terminal**, press Enter |
| macOS | Press Cmd+Space, type **Terminal**, press Enter |
| Linux | Usually Ctrl+Alt+T |

You'll see a line waiting for you to type. To paste: Ctrl+Shift+V (Linux), Cmd+V (macOS),
right-click or Ctrl+V (Windows).

### 3.2 Godot

1. Download the **standard** version from <https://godotengine.org/download> (not .NET, unless
   you already know you want C#).
2. **Windows:** unzip it into a folder you'll keep, like `C:\Godot`. **macOS:** drag it into
   Applications. **Linux:** unzip it somewhere like `~/Applications`.
3. Double-click it once to check it opens, then close it.

Claude also needs to start Godot from the terminal, to run its checks, and the command must be
`godot`. The easiest way is to ask Claude once it's installed (3.4):

```
Help me make the "godot" command work in my terminal. Godot is installed at <where you put it>.
```

### 3.3 Git and the GitHub tool

| System | How |
|---|---|
| Windows | Install Git from <https://git-scm.com/download/win> (the default options are fine), then GitHub CLI from <https://cli.github.com> |
| macOS | Install Homebrew from <https://brew.sh> (copy its one command into Terminal), then `brew install git gh` |
| Linux | Your package manager, e.g. `sudo apt install git gh` or `sudo pacman -S git github-cli` |

Then sign git in to GitHub. Type this and answer its questions (choose **GitHub.com**, **HTTPS**
and **Login with a web browser**):

```bash
gh auth login
```

> [!WARNING]
> If your web browser is already signed in to a *different* GitHub account, sign out of it
> first (or use a private window). Otherwise you'll log the terminal in as that other account.

### 3.4 Claude Code

Follow the official quickstart: <https://code.claude.com/docs/en/quickstart>. It gives you one
command to copy into your terminal. When it's done, typing `claude` starts it, and the first time
it asks you to log in.

There's also a desktop app with Claude Code built in, if you'd rather click than type. This
guide uses the terminal because it works the same everywhere.

### 3.5 Optional helpers

Ask Claude to install these later: "install gdtoolkit for me", "install jq for me".

- **gdtoolkit** tidies and checks GDScript code automatically.
- **jq** helps the kit's automatic checks read their input.

The kit works without them, but those checks are then off. Claude's start-up note says which
one is missing, so you know.

✅ **Check:** in a terminal, `git --version` and `claude --version` each print a version number.

## 4. Make your game's project

1. Open Godot. In the Project Manager click **Create** (or **+ Create**).
2. Give it a name (your game's name is fine) and pick a folder you'll find again, like
   `Documents/Games/<your-game>`. Leave the renderer as it is and click **Create**.
3. Godot opens the empty project. Close Godot again.

✅ **Check:** your project folder contains a file called `project.godot`.

## 5. Start Claude in your project

In the terminal, go to your project folder. `cd` means "change directory":

```bash
cd <path to your project folder>
```

> [!TIP]
> Type `cd ` (with a space), drag the folder from your file browser onto the terminal window,
> and press Enter.

Then start Claude:

```bash
claude
```

The first time, it asks whether you trust this folder. Say yes: it's your project.

> [!IMPORTANT]
> Always start Claude in the folder that holds `project.godot`, never the folder above it. The
> kit's checks and rules only load from the folder a session starts in. If you get it wrong, the
> kit's start-up note tells you where the project is.

✅ **Check:** Claude Code is running, and the path it shows ends in your project's folder.

## 6. Install the kit

Inside Claude Code, type these one at a time, pressing Enter after each. Lines starting with `/`
are Claude Code commands, not messages to Claude.

```
/plugin marketplace add dawnmaster1337/godot-noob-accelerator
```

```
/plugin install godot-accel@godot-accel
```

It asks where to install. Pick **this repository (project scope)**, so the kit loads only in this
game.

Recommended companion, which gives Claude deep Godot know-how (how to build movement, menus,
saving and so on the right way):

```
/plugin marketplace add jame581/skillsmith
```

```
/plugin install godot-prompter@skillsmith
```

Optional, from the kit's own marketplace: before Claude makes a shader, a 3D model or a sky by
hand, it looks for a free one you're allowed to use in a game you sell, shows you a short list,
and waits for your pick:

```
/plugin install godot-sourcing@godot-accel
```

Restart Claude Code so they load: type `/exit`, then `claude` again.

✅ **Check:** type `/godot` and the list that pops up includes `/godot-accel:bootstrap`.

## 7. Set up your project

Type:

```
/godot-accel:bootstrap
```

Claude asks up to eight questions, **one at a time**, each with a suggested answer. Not sure?
Type **APR** ("as per recommendation") and it takes its suggestion. It asks:

1. Your game's name.
2. What the game is, in one line ("a cosy farming game where the crops talk").
3. Which language (**APR**: GDScript).
4. How to test (**APR**).
5. Whether your game has a story or world to keep consistent.
6. Whether you use a "Godot MCP server" (if you don't know what that is: **no**).
7. How new you are. Be honest: it changes how much it explains.
8. A few extras (**APR**).

Then it shows the list of files it will create and waits for your **yes**. It never overwrites a
file you already have. At the end it runs its checks and tells you what it made. One check, the
smoke test, fails at first on purpose: it plays your game's main scene, and there isn't one yet.
Your first feature makes one.

<details>
<summary>What it just made (you don't need to read these now)</summary>

| File | What it's for |
|---|---|
| `CLAUDE.md` | Claude's instructions for your project, read every session |
| `.claude/rules/` | Rules Claude follows: how to write code, talk to you, save |
| `.claude/memory/` | Things Claude learns about how you like to work |
| `docs/STATUS.md` | Where you stopped and what's next. **The most important file** |
| `docs/plans/` | The plan for your game, one task per session, and a plan for each big feature |
| `docs/known-bugs.md` | Bugs found and not fixed yet |
| `docs/guides/start-here.md` | The short version of this guide, for every day |
| `inbox/` | Your drop box: downloads, notes and ideas between sessions |
| `tools/dev.sh`, `tests/` | Automatic checks Claude runs to prove things still work |

More appear when your game needs them: `docs/decisions/` (every decision and why) with your first
decision, a page per system once it's built, and so on.

</details>

✅ **Check:** Claude's summary lists the checks: they pass, apart from the smoke test waiting for
a main scene (or it tells you `godot` isn't set up yet; see
[when something goes wrong](#when-something-goes-wrong)).

## 8. Back it up on GitHub

Ask Claude:

```
Make a private GitHub repo for this project and push it. Explain each step.
```

It shows each command, and Claude Code asks you before each commit and push (the kit's settings
make it ask). From now on, every **save work** backs your project up there.

✅ **Check:** your repository appears at `https://github.com/<your-username>`.

## 9. Make something

Ask for it in your own words. Start small:

```
I want a character I can move around with the arrow keys. Use a coloured square for now.
```

What happens next:

1. Claude asks a few questions, one at a time, each with a suggestion.
2. For anything bigger, it writes a short **plan** and waits for your OK.
3. It builds it, runs its checks, and tells you what the checks said and what to try.
4. **You play it.** Open Godot (double-click the project in the Project Manager) and press **F5**
   (macOS: **Cmd+B**). Stop with **F8**, or close the game window.
5. Tell Claude how it felt: "too slow", "it slides like ice", "make the square blue". You don't
   need technical words. Feel changes usually become a number Claude can tune, which you can
   also change yourself in Godot's Inspector.
6. When you like it: **save work**, then **yes** when it asks to commit.

✅ **Check:** your square moves when you press the arrow keys.

## 10. Every day after this

Open a terminal in your project folder, type `claude`, then:

| You say | What happens |
|---|---|
| **resume** | Claude checks GitHub for changes (asks before pulling), reads where you stopped, checks your inbox, and suggests one task for this session |
| *anything you want* | It plans, asks, builds, checks |
| **APR** | Take its suggestion |
| **save work** | Check, then save a snapshot (on your yes) and back it up |
| **wrap up** | End-of-day save: also writes down where you stopped and what it learned |
| **I'm running out of usage** | A fast save so nothing is lost |
| `/clear` | A fresh chat (the notes stay). Do it after a save, between tasks: cheaper and sharper |
| **audit the project** | Now and then, or when things feel messy: a plain-words list of what's out of place or unused, then one question per fix |
| **update the kit** | When Claude says the project was set up with an older kit: adds what's new, asks before changing anything you wrote |

> [!TIP]
> One task per session works best: **resume**, one task, **save work**, `/clear`, **resume**
> again.

Your project's own `docs/guides/start-here.md` has this table too.

## When something goes wrong

| What you see | What to do |
|---|---|
| "godot: command not found" | Ask Claude: "help me make the godot command work". Until then it can still write code, just not test it |
| Claude says a check failed | Normal! Say "fix it". It should fix it before showing you anything |
| The game doesn't start, or red errors in Godot | Copy the red text (or screenshot it into `inbox/notes/`) and tell Claude |
| Claude says the project was set up with an older kit | Say **update the kit**. It adds what's new and asks before changing anything you wrote |
| Claude's start-up note says the project is in another folder | `/exit`, `cd` into the folder it names, run `claude` again |
| Claude seems confused or repeats itself | **save work**, then `/clear`, then **resume** |
| You don't understand what it said | "Explain that like I've never coded" |
| You hit your usage limit | Next time, start with **resume**: it picks up from the notes |
| A push fails with "Repository not found" | You're likely logged in to GitHub as a different account. Ask Claude to check which (`gh auth status`) |
| You want to undo something | "Undo the last thing you changed" or "go back to the last commit". It asks before throwing anything away |
| It wants to do something you don't understand | Say no and ask what it is first. Nothing bad happens from saying no |

## Safety, in four lines

1. **Never paste passwords, API keys or tokens into the chat.** If a tool needs one, Claude tells
   you what to type in a normal terminal yourself.
2. **Read before you say yes** to a commit, a download or a purchase. "What will this do?" is
   always a fine answer.
3. **Only use free assets you're allowed to use** (look for CC0 or "free for commercial use").
4. **Save often.** A commit is free, and it's the undo button for your whole project.

## Words you'll hear

| Word | Plain meaning |
|---|---|
| **scene** (`.tscn`) | A building block of your game: a level, the player, a menu |
| **node** | One piece inside a scene: a sprite, a sound, a collision box |
| **script** (`.gd`) | Code attached to a node that makes it do things |
| **GDScript** | Godot's own simple coding language |
| **resource** (`.tres`) | A data file: a character's stats, an item, a level's settings |
| **Inspector** | The panel in Godot where you see and change a node's or resource's values |
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

## Where next

- [How it works](how-it-works.md): how the kit runs a project, and the failure behind each habit.
- [Structure](structure.md): every file the kit creates, and why.
- [Customising](customising.md): change the rules to fit how you work, as you grow.
- Found something confusing? That's useful feedback: see "Tell us how it went" in the
  [README](../README.md#-tell-us-how-it-went).
