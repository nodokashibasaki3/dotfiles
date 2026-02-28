#!/usr/bin/env bash
set -euo pipefail

JOURNALS_DIR="$HOME/Desktop/dev/logseq/journals"

TODAY="$(date +%Y_%m_%d)"
TODAY_FILE="$JOURNALS_DIR/${TODAY}.md"

# Check if file has real content (not empty / whitespace)
has_content() {
  local f="$1"
  [[ -f "$f" ]] && grep -q '[^[:space:]]' "$f"
}

LAST_WITH_CONTENT=""

# Find newest journal with content (excluding today)
for f in $(ls -1 "$JOURNALS_DIR"/*.md | sort -r); do
  base="$(basename "$f")"

  [[ "$base" == "${TODAY}.md" ]] && continue

  if has_content "$f"; then
    LAST_WITH_CONTENT="$f"
    break
  fi
done

if [[ -z "$LAST_WITH_CONTENT" ]]; then
  echo "No previous journal with content found."
  exit 1
fi

# Overwrite today's journal (no backup)
cp "$LAST_WITH_CONTENT" "$TODAY_FILE"

echo "Copied:"
echo "From: $LAST_WITH_CONTENT"
echo "To:   $TODAY_FILE"

