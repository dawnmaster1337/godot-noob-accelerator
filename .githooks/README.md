# identity-guard hooks

Three git hooks that stop the owner's real identity, and the retired handle, from
reaching a repository.

| Hook | Checks |
|---|---|
| `pre-commit` | author + committer belong to the account that owns `origin`; staged files carry no real-identity strings |
| `commit-msg` | the commit message carries no real-identity strings |
| `pre-push` | every commit being pushed, not just HEAD: identity, plus real-identity and handle strings in the pushed tree and messages |

## Why there are no names in these files

The allowed email is *derived* from the `origin` URL: a commit must be authored by
`<id>+<owner-of-origin>@users.noreply.github.com`, or by `noreply@anthropic.com` /
`noreply@github.com`. So these hooks hold no account name and are safe in a public
repo — and they enforce account separation for free: a commit made with one
account's noreply address is rejected in the other account's repo.

The strings to search for live **outside every repo**, in
`~/.config/identity-guard/patterns` and `~/.config/identity-guard/handle-patterns`
(mode 600). If a file is missing, that scan is skipped and a note is printed; the
identity check still runs. Keeping them out of the repo is the point: a public repo
must never contain the strings it is being scanned for.

Handle patterns are skipped when the pattern also matches the remote owner's own
name, since a handle is legitimate in its own account's repos.

## Activating them

`core.hooksPath` is per-clone local config. **Cloning a repo does not activate the
hooks** — run this once per clone, per machine:

```bash
git config core.hooksPath .githooks
```

Check it took: `git config --get core.hooksPath` should print `.githooks`.

## Escape hatch

`IDENTITY_GUARD_SKIP=1 git commit …` bypasses every check. For a genuine false
positive only.

## Gotchas found while building these

- **Do not use `\b`** in the pattern files. It is not portable across grep
  implementations, and a shell whose `echo` builtin expands escapes (zsh, dash)
  will silently write a literal backspace byte into the file instead. Write
  pattern files with a quoted heredoc and verify with `od -c`.
- A **blank line** in a `grep -f` pattern file matches every line, which would
  block every commit. The hooks strip blanks and comments before use.
- `pre-commit` receives **no arguments**; only `commit-msg` gets the message file.
  Referencing `$1` in `pre-commit` under `set -u` makes the hook fail closed and
  block everything.
