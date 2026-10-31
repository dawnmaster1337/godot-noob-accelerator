# identity-guard shared helpers. Sourced by the hooks.
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
