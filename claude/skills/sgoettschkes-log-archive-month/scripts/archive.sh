#!/usr/bin/env bash
# Usage: archive.sh <log-dir> <today YYYY-MM-DD> [--apply]
# Moves every "## DD.MM.YYYY" section of "Daily Log.md" not in today's month
# into "YYYY MM Log.md" in the same dir. Without --apply: dry run, prints plan.
set -euo pipefail

DIR="$1"
TODAY="$2"
APPLY="${3:-}"
LOG="$DIR/Daily Log.md"
CUR="${TODAY:5:2}.${TODAY:0:4}"

[ -f "$LOG" ] || { echo "missing: $LOG" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# Lines before the first day heading (frontmatter + title) always stay.
awk -v cur="$CUR" -v work="$WORK" '
  BEGIN { out = work "/keep" }
  /^## [0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]$/ {
    month = substr($0, 7, 7)
    if (month == cur) {
      out = work "/keep"
    } else {
      out = work "/" substr(month, 4, 4) " " substr(month, 1, 2)
      print substr($0, 4) >> (out ".days")
    }
  }
  { print >> out }
' "$LOG"

shopt -s nullglob
months=("$WORK"/*.days)
if [ ${#months[@]} -eq 0 ]; then
  echo "nothing to archive"
  exit 0
fi

for days in "${months[@]}"; do
  name="$(basename "$days" .days)"
  target="$DIR/$name Log.md"
  count=$(wc -l < "$days" | tr -d ' ')
  if [ -f "$target" ]; then
    while read -r d; do
      if grep -qx "## $d" "$target"; then
        echo "abort: $d already in $name Log.md" >&2
        exit 1
      fi
    done < "$days"
    echo "$name Log.md: append $count days ($(head -1 "$days") - $(tail -1 "$days"))"
  else
    echo "$name Log.md: create with $count days ($(head -1 "$days") - $(tail -1 "$days"))"
  fi
done

[ "$APPLY" = "--apply" ] || exit 0

for days in "${months[@]}"; do
  name="$(basename "$days" .days)"
  target="$DIR/$name Log.md"
  if [ -f "$target" ]; then
    [ -n "$(tail -c 1 "$target")" ] && printf '\n' >> "$target"
  else
    printf -- "---\ndate: '%s'\n---\n\n# %s Log\n\n" "$TODAY" "$name" > "$target"
  fi
  cat "$WORK/$name" >> "$target"
done

cp "$WORK/keep" "$LOG"
echo "done"
