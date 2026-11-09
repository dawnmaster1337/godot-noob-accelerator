#!/usr/bin/env bash
# A plain Godot 4 project whose policy asks find-or-build for every kind (the default).
set -e
here=$(cd "$(dirname "$0")" && pwd)
SOURCING_POLICY="$here/../lib/policy-all-ask.md"
. "$here/../lib/project.sh"
