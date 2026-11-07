#!/usr/bin/env bash
# A plain Godot 4 project whose policy makes all 2D art in-house.
set -e
here=$(cd "$(dirname "$0")" && pwd)
SOURCING_POLICY="$here/../lib/policy-2d-make.md"
. "$here/../lib/project.sh"
