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
- **Parallel work** (sessions or subagents that write code): each in its own worktree. Link
  git-ignored inputs (raw data, caches) from the main checkout and `git lfs pull` there. Heavy
  jobs (builds, exports) share one lock (`flock /tmp/<project>-build.lock <command>`): parallel
  builds run out of memory. Only one agent runs the game or captures the screen at a time. Agents
  commit code only, never generated outputs, and never edit shared docs (`docs/STATUS.md`, plans,
  logs): they return that text in their report. The main session merges, rebuilds once and runs
  the checks. Repo-wide scripts and formatters skip `.claude/worktrees/` (other sessions' work).
- **After merging an agent's branch:** check `git status` in its worktree (keep or move any
  uncommitted file that isn't a generated output), then `git worktree remove <path>` and
  `git worktree prune`. Keep worktrees whose branch isn't merged (`git branch --no-merged`).
