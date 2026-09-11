#!/bin/bash
# Post-render hook: generate a PNG thumbnail from the dedicated front page PDF.
# Uses pdftk to isolate page 1, then pdftoppm to render a single PNG.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PDF_BASENAME="Analysing-Argumentation-Structures.pdf"
RENDER_PDF="$ROOT_DIR/.tmp-pdf/$PDF_BASENAME"
DOCS_PDF="$ROOT_DIR/docs/$PDF_BASENAME"
SOURCE_PDF=""
OUTPUT_DIR="$ROOT_DIR/source/figures"
OUTPUT_BASE="$OUTPUT_DIR/frontpage-thumbnail"
OUTPUT_PNG="${OUTPUT_BASE}.png"
TMP_DIR="$ROOT_DIR/.tmp"
TMP_SINGLE_PAGE="$TMP_DIR/frontpage-single-page.pdf"

if ! command -v pdftk >/dev/null 2>&1; then
  echo "[post-render-thumbnail] pdftk not found; skipping thumbnail generation"
  exit 0
fi

if ! command -v pdftoppm >/dev/null 2>&1; then
  echo "[post-render-thumbnail] pdftoppm not found; skipping thumbnail generation"
  exit 0
fi

if [ -f "$RENDER_PDF" ]; then
  SOURCE_PDF="$RENDER_PDF"
  echo "[post-render-thumbnail] using freshly rendered PDF: $SOURCE_PDF"
elif [ -f "$DOCS_PDF" ]; then
  SOURCE_PDF="$DOCS_PDF"
  echo "[post-render-thumbnail] using docs PDF fallback: $SOURCE_PDF"
else
  echo "[post-render-thumbnail] no source PDF found; looked for $RENDER_PDF and $DOCS_PDF"
  exit 0
fi

mkdir -p "$OUTPUT_DIR" "$TMP_DIR"

if [ -f "$OUTPUT_PNG" ]; then
  echo "[post-render-thumbnail] removing existing thumbnail: $OUTPUT_PNG"
  rm -f "$OUTPUT_PNG"
fi

# Extract exactly the first page for a predictable thumbnail source.
pdftk "$SOURCE_PDF" cat 1 output "$TMP_SINGLE_PAGE"

# Render to a single PNG file with a fixed width.
pdftoppm -png -singlefile -f 1 -scale-to-x 1200 -scale-to-y -1 "$TMP_SINGLE_PAGE" "$OUTPUT_BASE"

echo "[post-render-thumbnail] wrote ${OUTPUT_BASE}.png"
