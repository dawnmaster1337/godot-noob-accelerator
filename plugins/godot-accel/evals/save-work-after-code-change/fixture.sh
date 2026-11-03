#!/usr/bin/env bash
# A bootstrapped kit project with an uncommitted change to the main scene's script.
set -e
here=$(cd "$(dirname "$0")" && pwd)
KIT_TEMPLATES="$here/../../skills/bootstrap/templates"
. "$here/../lib/kit-project.sh"
printf 'extends Node2D\n\nconst SPEED: float = 120.0\n\n\nfunc _ready() -> void:\n\tprint("main ready at %%s" %% SPEED)\n' >main.gd
