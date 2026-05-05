#!/usr/bin/env zsh
# install.sh — installs bruno-workspace to /usr/local/bin

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
TARGET="/usr/local/bin/bruno-workspace"

cp "$SCRIPT_DIR/bruno-workspace" "$TARGET"
chmod +x "$TARGET"

print -P "%F{green}✓%f installed: $TARGET"
print ""
print "Usage:"
print "  bruno-workspace           # auto-detect ticket from branch"
print "  bruno-workspace DEV-1234  # use explicit name"
