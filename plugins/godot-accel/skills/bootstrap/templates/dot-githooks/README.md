# Git hooks

Checks git runs at commit and push time. They catch what Claude's editor hooks miss, such as
an edit made from a shell. **They do nothing until you turn them on**, once per clone, per
machine (cloning does not turn them on):

```bash
git config core.hooksPath .githooks
```

Check it took: `git config --get core.hooksPath` prints `.githooks`.

| Hook | Always checks | With identity-guard set up, also checks |
|---|---|---|
| `pre-commit` | GDScript passes `gdformat --check` and `gdlint` (skipped without gdtoolkit); no `.godot/`, no `.env`, nothing key-shaped staged | author and committer; staged files carry no real-identity strings |
| `commit-msg` | nothing | the message carries no real-identity strings |
| `pre-push` | hands the push over to git-lfs when the repo uses it | every commit being pushed: identity, plus real-identity and handle strings in the pushed tree and messages |

Each hook then runs a project hook of its own, if one exists: `<hook>.project` next to it
(`pre-commit.project`, …), executable.

Skip every check for one commit or push: `git commit --no-verify`, `git push --no-verify`.

## identity-guard (optional, per person)

For anyone who keeps an account's real identity separate from its public handle. It is **off
unless the folder `~/.config/identity-guard/` exists** on this machine (another folder:
set `IDENTITY_GUARD_DIR`). Without that folder you can ignore this section.

When it is on:

- A commit must be authored by `<id>+<owner-of-origin>@users.noreply.github.com`, or by
  `noreply@anthropic.com` / `noreply@github.com`. The owner is read from the `origin` URL,
  so these files hold no account name and are safe in a public repo. A commit made with one
  account's noreply address is rejected in another account's repo. A push to a remote whose
  owner can't be read from its URL is refused.
- Content is scanned against two pattern files in that folder, `patterns` and
  `handle-patterns` (mode 600, one case-insensitive extended regex per line). A missing file
  skips its scan with a note; the identity check still runs. A public repo must never contain
  the strings it is scanned for, which is why they live outside it.
- Handle patterns are skipped when the pattern also matches the remote owner's own name, since
  a handle is legitimate in its own account's repos.
- `IDENTITY_GUARD_SKIP=1` turns identity-guard off for one command; the project checks and the
  git-lfs handover still run.

### Allow list

A repo may carry `.identity-guard-allow`, one entry per line, exempting paths from the
**content** scan only, never from the email check:

```
docs/lore/      a path prefix
*               the whole repo (content legitimately about the owner)
!messages       also skip the commit-message scan
```

### Gotchas found while building these

- **Do not use `\b`** in the pattern files. It is not portable across grep implementations,
  and a shell whose `echo` builtin expands escapes (zsh, dash) silently writes a literal
  backspace byte instead. Write pattern files with a quoted heredoc and check with `od -c`.
- A **blank line** in a `grep -f` pattern file matches every line, which would block every
  commit. The hooks strip blanks and comments before use.
- `pre-commit` receives **no arguments**; only `commit-msg` gets the message file.
  Referencing `$1` in `pre-commit` under `set -u` makes the hook fail closed and block
  everything.
- Setting `core.hooksPath` makes git ignore `.git/hooks`, including the pre-push hook git-lfs
  installs there; that is why `pre-push` hands over to git-lfs itself.
