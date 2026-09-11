#!/bin/bash
# Pre-render hook: populate index.qmd based on the active Quarto profile.
#
# Quarto hard-requires index.qmd as the first book chapter but we need
# different content there per output format:
#
#   html profile (default) → index.qmd = index-html.qmd  (Vorwort / homepage)
#   pdf  profile           → index.qmd = ch01.qmd    (Einleitung = chapter 1)
#
# Quarto sets QUARTO_PROFILE to the active profile name before invoking
# pre-render scripts, so we can branch on it here.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$SCRIPT_DIR/source"

echo "Quarto called with the following profile: $QUARTO_PROFILE"
if [ "$QUARTO_PROFILE" = "pdf" ]; then
  echo "[pre-render] pdf profile active → copying ch00.qmd to index.qmd"
  cp "$SOURCE_DIR/ch00.qmd" "$SOURCE_DIR/index.qmd"
else
  echo "[pre-render] html profile active → copying index-html.qmd to index.qmd"
  cp "$SOURCE_DIR/index-html.qmd" "$SOURCE_DIR/index.qmd"
fi
