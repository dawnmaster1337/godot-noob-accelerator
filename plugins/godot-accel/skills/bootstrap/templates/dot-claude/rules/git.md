# Git

- **Resume:** `git fetch` first. If the remote is ahead, list the incoming commits and ask before
  `git pull --ff-only`. "0 commits not pushed" from a start-up hook is not a fetch.
- **Commit only on the user's yes.** Small commits, imperative subjects (≤ 72 characters), grouped
  by topic. Then {{PUSH_POLICY}}
- **Stage by path** (`git add <file> …`): other sessions and the user may share this checkout.
  Never `git add -A`, `git add .`, `git commit -a`, a blanket `git checkout -- <glob>`,
  `git reset --hard` or `git clean`, and never rewrite pushed history.
- **Push says "Repository not found" or 403:** usually the wrong account, not a wrong URL. Run
  `gh auth status`; with several accounts, tell the user which owns the repo and ask. Never switch
  the account (`gh auth switch`) or change global git config without asking: it changes every
  other project too. A one-off push as the right account: `docs/guides/quirks.md`.
- **Secrets:** never paste, write or commit API keys or tokens. Key commands go in a normal
  terminal, never in chat. If a key lands in the chat or a file, tell the user to revoke it.
- Before ending a session: no uncommitted work left unsaid.
- Parallel work: a second session that writes code works in its own worktree; only one session at
  a time runs the game or edits `docs/STATUS.md`.
