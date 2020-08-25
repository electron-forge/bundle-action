#!/usr/bin/env bash
#
# Environment variables:
#
# * `NODE_INSTALLER`: Which Node.js package manager to use (`yarn` or `npm`). Defaults to detecting
#   which package manager was used on the app via `yarn-or-npm` (which is used by Electron Forge).
#

if [[ "$NODE_INSTALLER" = "npm" ]]; then
  npm run package -- --platform "$TARGET_PLATFORM"
elif [[ "$NODE_INSTALLER" = "yarn" ]]; then
  yarn package --platform "$TARGET_PLATFORM"
else
  $(npm bin)/yarn-or-npm run package -- --platform "$TARGET_PLATFORM"
fi
