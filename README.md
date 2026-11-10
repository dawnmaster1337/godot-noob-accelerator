<div align="center">

<img src="assets/readme/hero.svg" alt="Godot Noob Accelerator: make a Godot game with Claude Code, without the mess. Built by a beginner, for beginners." width="100%">

[![Latest release](https://img.shields.io/github/v/release/dawnmaster1337/godot-noob-accelerator?label=release&color=d97757&cacheSeconds=3600)](https://github.com/dawnmaster1337/godot-noob-accelerator/releases)
[![Godot 4](https://img.shields.io/badge/Godot-4.x-478cbf?logo=godotengine&logoColor=white)](https://godotengine.org)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-d97757)](https://code.claude.com/docs)
[![Licence: MIT](https://img.shields.io/badge/licence-MIT-5cc8a8)](LICENSE)

**Claude Code forgets between sessions, calls untested work done and can undo what you tuned by
hand. This kit gives it notes it reads first, checks it runs before you see anything, and a habit
of asking before it changes what's yours.**

<a href="docs/beginners-guide.md"><img src="assets/readme/btn-beginner.svg" alt="New to all of this? Start the beginner's guide" width="420"></a>
<a href="#-install"><img src="assets/readme/btn-quickstart.svg" alt="Already use Claude Code? 5-minute quick start" width="420"></a>

</div>

<br>

## 👋 What is it?

A free add-on for **Claude Code** that helps it build your **Godot** game carefully, over weeks.
You describe what you want in plain words; Claude writes the code, keeps the notes and checks its
work. You play it and decide. **No coding experience needed.**

<img src="assets/readme/promises.svg" alt="Three habits it adds. It remembers: where you stopped, what you decided and why. It checks first: it runs your game's checks before you see anything. It asks first: it saves only on your yes and never quietly changes a value you tuned by hand." width="100%">

- 🧠 **It remembers** where you stopped, what you decided and why, in notes it reads every session.
- ✅ **It checks first:** it runs your game's checks before you see anything, and says what they said.
- ✋ **It asks first:** it saves only on your yes, and never quietly changes a value you tuned by hand.

## 🎬 What it looks like

You type a few words. Claude does the work, asks one question at a time (each with a suggestion
you can take by saying **APR**), and tells you what its checks said and what to try.

<img src="assets/readme/session.svg" alt="An illustrated session. You type resume; Claude says it got two changes from your laptop and suggests one task. You say APR. It asks one question with a recommendation, builds it, reports 4 checks passed and what to try. You say it feels floaty; it suggests changing one tuning value. You say save work; it asks before committing and backs up to GitHub." width="100%">

## ⚖️ Plain Claude Code, or with the kit?

<img src="assets/readme/compare.svg" alt="Five situations compared. A new session: plain Claude Code remembers little; with the kit it reads its notes. When it says it works: plain is often untested; the kit ran the checks first. Your hand-tuned jump: plain can change it back; the kit asks before touching it. A big feature: plain starts coding; the kit asks a few questions and writes a plan. Two computers: plain can redo work; the kit fetches first." width="100%">

<details>
<summary>The comparison, in words</summary>

| | Plain Claude Code | With the kit |
|---|---|---|
| A new session | Remembers little; you explain it all again | Reads its notes: where you stopped, what's next |
| "It works!" | Often untested; you find the bugs | The checks ran first, and it tells you what they said |
| Your hand-tuned jump | Can quietly change it back | Treated as yours; it asks before touching it |
| A big new feature | Starts coding straight away | A few questions, a short plan, then your OK |
| Two computers | One can redo what the other already did | It fetches first and asks before pulling |

</details>

## 🎯 Is it for you?

<img src="assets/readme/audience.svg" alt="Never written code: made for you. Made a few things: also for you. A game jam or a weekend try: plain Claude Code is enough. A seasoned developer: it may feel slow; take the parts you like." width="100%">

**Yes** if you've never coded, or you've made a few things and want Claude to stop making a mess
of a bigger game. **Probably not** for a game jam or a weekend try: plain Claude Code is enough
there. Seasoned developers may find it slow; every rule can be changed or switched off.

## 💥 Why we made it

These six things went wrong in our own games. Each one is now a rule or a check.

<img src="assets/readme/stories.svg?v=5" alt="Six real problems, each now a rule or a check: bugs it should have caught; notes that grew to 875 lines; Claude forgot what we decided; three games with three note layouts; Claude undid a jump we tuned by hand; one computer redid another's work." width="100%">

<details>
<summary>The six stories, in words</summary>

| What went wrong | What the kit does now |
|---|---|
| Claude kept handing over work that didn't run | It runs the checks before you see anything, and quotes them |
| Its notes grew to 875 lines, all read every session | Notes have size limits, and a check warns |
| Weeks later, it did something we'd decided against | Decisions are written down and read first |
| Three games kept their notes three different ways | One layout in every game (one went from 29 problems to 0) |
| It quietly undid a jump we'd tuned by hand | Your changes are yours: it asks before touching them |
| One computer redid work another had already pushed | Each session checks your other computers first |

They help a lot. They don't make Claude perfect: you still play and decide.

</details>

## 🔁 How it goes

<img src="assets/readme/loop.svg" alt="A loop of six steps: resume, pick one task, plan anything new, build and check, you play it, save work. Then start a fresh session." width="100%">

| You say | Claude… |
|---|---|
| **resume** | picks up where you stopped, on any computer |
| **I want to add…** | asks a few questions, then makes a plan for your OK |
| **let me play it** | tells you what to open and what to try |
| **feels too slow** *(any feeling)* | changes a setting you can see, not the code |
| **save work** | saves, but only when you say yes |
| **wrap up** | writes down where you stopped, for next time |

Not sure what Claude means? Say **"explain like I'm new"**.

## 🌳 Find or build: your call

<img src="assets/readme/find-or-build.svg" alt="You ask for some trees. Pip, the kit's robot, asks: find a ready-made one, or build it here? It recommends neither. Find shows up to five free options with licences and records the credit of your pick. Build makes it in your project." width="100%">

Before Claude makes a model, a shader, a texture or an addon, it asks whether you'd like a
ready-made one or one built for you. It doesn't push either way. Choose **find**, and it shows up
to five free options you're allowed to use in a game you sell, waits for your pick, and writes
down the credit. This comes with the kit as a second plugin, `godot-sourcing`.

## 🚀 Install

<img src="assets/readme/install.svg" alt="Four steps: get Godot, git and Claude Code; add the kit with two commands; start Claude Code in your game's folder; type the bootstrap command and answer a few questions." width="100%">

**First time?** Follow the **[beginner's guide](docs/beginners-guide.md)**: about an hour, from
nothing installed to a character moving on screen.

**Already set up?** Start Claude Code **in your game's folder** (the one with `project.godot`),
then run these one at a time:

```
/plugin marketplace add dawnmaster1337/godot-noob-accelerator
```

```
/plugin install godot-accel@godot-accel
```

When it asks where, pick **this repository (project scope)**, so the kit loads only in this game.
Restart Claude Code in the same folder, then type:

```
/godot-accel:bootstrap
```

> [!TIP]
> **Already started a game with its own notes?** Type `/godot-accel:realign` instead. It moves
> them into the kit's places and keeps everything.

## 🙋 The honest bit

**We're beginners too.** This is one noob's way of keeping Claude Code careful, shared in case it
helps you. It works for our own games. It might not work for yours. If it doesn't,
[tell us](#-tell-us-how-it-went).

| | |
|---|---|
| 🐢 **Slower** | Claude asks questions and runs checks before showing you things |
| 📦 **Files** | About 12 you'll see (notes, a check script, a smoke test) and 20 hidden ones (Claude's rules, git checks). More appear only when your game needs them |
| 🐧 **Tested on** | Linux so far. Windows and macOS should work; nobody has run the whole kit there yet |
| 💸 **Cost** | The kit is free. Claude Code needs a paid Claude plan |
| 🌐 **Connects to** | `godot-sourcing` connects each session, as it starts, to a free third-party asset search: the [3D Asset Server](https://3d.shep.bot/docs) (no account; [its privacy policy](https://3d.shep.bot/privacy)). It gets your search words only when you choose to find something. It can't be switched off on its own while the kit is on |
| 🧪 **Proof** | Our checks prove Claude *followed* the process. We haven't yet measured whether games come out better than with plain Claude Code |

## 📚 Learn more

<img src="assets/readme/docs-map.svg" alt="Five guides: the beginner's guide, how it works, every file the kit adds, making it yours, and companions." width="100%">

| Guide | What's in it |
|---|---|
| 🚩 [Beginner's guide](docs/beginners-guide.md) | From nothing installed to a moving character, in about an hour |
| ⚙️ [How it works](docs/how-it-works.md) | Every habit the kit gives Claude, and the failure behind it |
| 📁 [Every file](docs/structure.md) | What the kit adds to your project, and why |
| 🖌️ [Make it yours](docs/customising.md) | Change rules, add steps, turn things off |
| 🧩 [Companions](docs/companions.md) | Other plugins that work well beside it, like GodotPrompter for Godot know-how |

All of them, with pictures: the [docs hub](docs/README.md).

## 💬 Tell us how it went

Especially if you got stuck: that's the most useful thing we can hear.
[Open an issue](https://github.com/dawnmaster1337/godot-noob-accelerator/issues/new/choose), even
if it's just "I gave up at step 2". Your project learned something? Say
`/godot-accel:harvest-learnings` and it drafts feedback with your game's details removed.

<details>
<summary><b>Updating, trying a test branch, contributing</b></summary>

- **Updating:** run `/plugin marketplace update godot-accel`, then `/plugin` → godot-accel →
  update, and start a new session. Then say **update the kit** in your project. Still the old
  version? Run the marketplace update again: it can reuse a stale copy.
- **Trying a test branch:** in `~/.claude/settings.json` (and the project's
  `.claude/settings.json`, if it lists the kit), add `"ref": "<branch>"` to the `godot-accel`
  entry's `source` under `extraKnownMarketplaces`. Then run
  `claude plugin marketplace add 'dawnmaster1337/godot-noob-accelerator#<branch>'` and
  `claude plugin update godot-accel@godot-accel`. Remove the `ref` to go back. Don't run
  `marketplace remove`: it uninstalls the kit and rewrites the project's settings.
- **Kit installed before 0.6.0?** `/plugin install godot-sourcing@godot-accel` adds find-or-build.
- [Contributing](CONTRIBUTING.md) · [Changelog](CHANGELOG.md)

</details>

<sub>📜 [MIT licence](LICENSE). Pip the robot and the artwork in `assets/` are part of this repo,
under the same licence; `assets/src/make_art.py` draws most of it. Not affiliated with or endorsed
by the Godot Foundation or Anthropic.</sub>
