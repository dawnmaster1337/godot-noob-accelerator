# identity-guard shared helpers. Sourced by the hooks.

# identity-guard is per person, not per repo: its checks run only on a machine
# that has its config folder. Without the folder the hooks still run the
# project checks (lint, secrets, the git-lfs handover) and say nothing else.
IG_DIR="${IDENTITY_GUARD_DIR:-$HOME/.config/identity-guard}"
ig_active() { [ -d "$IG_DIR" ] && [ "${IDENTITY_GUARD_SKIP:-0}" != "1" ]; }

# Builds a sanitised copy of a pattern file: comments and blank lines removed.
# A blank line in a `grep -f` file matches EVERYTHING, so this is not optional.
ig_clean_patterns() {   # ig_clean_patterns <src> -> prints temp path, or nothing
  [ -r "${1:-}" ] || return 1
  local t; t=$(mktemp) || return 1
  grep -vE '^[[:space:]]*(#|$)' "$1" > "$t" 2>/dev/null
  if [ -s "$t" ]; then printf '%s\n' "$t"; else rm -f "$t"; return 1; fi
}
# Owner of the push/origin remote, derived from the URL so no account name is
# hard-coded in a committed file.
ig_owner() {
  printf '%s' "${1:-}" \
    | sed -E 's#^git@[^:]+:#https://host/#; s#^ssh://[^/]+/#https://host/#' \
    | sed -E 's#^https?://[^/]+/##; s#/.*$##; s#\.git$##'
}
ig_email_ok() {   # ig_email_ok <email> <owner>
  case "$1" in noreply@anthropic.com|noreply@github.com) return 0 ;; esac
  [ -n "${2:-}" ] || return 1
  printf '%s' "$1" | grep -qiE "^[0-9]+\+$2@users\.noreply\.github\.com\$"
}

# ---- allow list ------------------------------------------------------------
# A repo may carry `.identity-guard-allow`: one entry per line, exempting paths
# from the CONTENT scan only -- never from the author/committer email check.
#   docs/lore/              a path prefix
#   *                       the whole repo (for a repo whose content is
#                           legitimately about the owner, e.g. their own site)
#   !messages               also skip the commit-message scan
# Comments (#) and blank lines ignored.
ig_allow_file() { printf '%s\n' "$(git rev-parse --show-toplevel 2>/dev/null)/.identity-guard-allow"; }
ig_allow_has() {   # ig_allow_has <token>  -- is this exact token present?
  local af; af=$(ig_allow_file)
  [ -r "$af" ] || return 1
  grep -vE '^[[:space:]]*(#|$)' "$af" 2>/dev/null | grep -qxF "$1"
}
ig_allowed() {     # ig_allowed <path> -- exempt from the content scan?
  local af p; af=$(ig_allow_file)
  [ -r "$af" ] || return 1
  while IFS= read -r p; do
    case "$p" in ''|\#*) continue ;; '!'*) continue ;; esac
    [ "$p" = '*' ] && return 0
    case "$1" in
      "$p"|"$p"*) return 0 ;;
    esac
    case "$1" in $p) return 0 ;; esac   # glob
  done < <(grep -vE '^[[:space:]]*(#|$)' "$af" 2>/dev/null)
  return 1
}
