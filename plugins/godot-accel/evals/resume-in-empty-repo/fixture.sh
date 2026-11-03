#!/usr/bin/env bash
# Bootstrapped, `git init` run, nothing committed yet, and no inbox/: the state right after setup.
set -e
here=$(cd "$(dirname "$0")" && pwd)
KIT_TEMPLATES="$here/../../skills/bootstrap/templates"
KIT_NO_GIT=1
. "$here/../lib/kit-project.sh"
rm -rf inbox
