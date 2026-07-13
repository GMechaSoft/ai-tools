#!/usr/bin/env bash
set -euo pipefail

SOURCE="$(cd "$(dirname "$0")/../opencode" && pwd)"
TARGET="$HOME/.opencode"
BACKUP="$TARGET-old"

[ -e "$BACKUP" ] && rm -rf "$BACKUP"
[ -e "$TARGET" ] && mv "$TARGET" "$BACKUP"

ln -s "$SOURCE" "$TARGET"
echo "Linked $SOURCE -> $TARGET"

if [ -d "$BACKUP" ]; then
  cp -a "$BACKUP/." "$TARGET/"
  rm -rf "$BACKUP"
fi
