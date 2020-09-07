#!/usr/bin/env bash
#
# Environment variables:
#
# * `NODE_INSTALLER`: Which Node.js package manager to use (`yarn` or `npm`). Defaults to detecting
#   which package manager was used on the app.
#

set -e

if [[ "$NODE_INSTALLER" = "yarn" || ( -z "$NODE_INSTALLER" && -f "yarn.lock" ) ]]; then
  yarn
elif [[ "$NODE_INSTALLER" = "npm" || -f "package-lock.json" ]]; then
  npm install
else
  echo "ERROR: unknown NODE_INSTALLER ($NODE_INSTALLER)" 1>&2
  exit 1
fi
