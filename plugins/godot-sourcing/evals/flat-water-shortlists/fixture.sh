#!/usr/bin/env bash
# A plain Godot 4 project with a sourcing policy that allows everything.
set -e
here=$(cd "$(dirname "$0")" && pwd)
SOURCING_POLICY="$here/../lib/policy-all-source.md"
. "$here/../lib/project.sh"
