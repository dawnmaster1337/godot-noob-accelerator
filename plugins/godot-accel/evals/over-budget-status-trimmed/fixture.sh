#!/usr/bin/env bash
set -e
here=$(cd "$(dirname "$0")" && pwd)
KIT_TEMPLATES="$here/../../skills/bootstrap/templates"
. "$here/../lib/kit-project.sh"
g() { git -c user.name=eval -c user.email=eval@example.invalid "$@"; }
{
	printf '# Project status — resume here\n\n## Resume here\n\n'
	printf '**Next (the user'"'"'s order):** (1) KEEP-NEXT-STEP: the double jump, task 0.3 of `docs/plans/roadmap.md`.\n\n'
	printf '## Open questions for the user (the only list; none blocking)\n\n1. KEEP-OPEN-QUESTION: should coins respawn?\n\n## Session notes\n\n'
	for i in $(seq 1 40); do
		printf -- '- 2026-10-%02d session %d: built and checked a small piece, the user played it, two tweaks, all checks passed, committed.\n' $((i % 28 + 1)) "$i"
		printf -- '  Details: moved a value into the tuning resource, fixed a lint warning, updated the system page.\n'
	done
} >docs/STATUS.md
g add -A && g commit -qm "Status after many sessions"
