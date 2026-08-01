#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

STALE_DAYS=365 # Anpassen an das Prüfintervall aus GOVERNANCE.md

errors=0

epoch_of() {
  date -j -f "%Y-%m-%d" "$1" +%s 2>/dev/null || date -d "$1" +%s 2>/dev/null || echo ""
}

today_epoch=$(epoch_of "$(date +%Y-%m-%d)")

folder_type() {
  case "$1" in
    entscheidungen) echo "entscheidung" ;;
    prozesse) echo "prozess" ;;
    produkte) echo "produkt" ;;
    glossar) echo "glossar" ;;
    *) echo "" ;;
  esac
}

field() {
  grep -m1 "^$2:" "$1" 2>/dev/null | cut -d: -f2- | sed -E 's/^ *"?//; s/"? *$//' || true
}

fail() {
  echo "  FEHLER: $1"
  errors=$((errors + 1))
}

while IFS= read -r file; do
  folder=$(basename "$(dirname "$file")")
  expected_type=$(folder_type "$folder")

  echo "Prüfe $file"

  grep -q '^title:' "$file" || fail "title fehlt"
  grep -q '^source:' "$file" || fail "source fehlt"

  type=$(field "$file" type)
  created=$(field "$file" created)
  last_reviewed=$(field "$file" last_reviewed)
  status=$(field "$file" status)

  [ -z "$created" ] && fail "created fehlt"
  [ -z "$last_reviewed" ] && fail "last_reviewed fehlt"

  if [ -z "$status" ]; then
    fail "status fehlt"
  elif [ "$status" != "aktuell" ] && [ "$status" != "veraltet" ]; then
    fail "status '$status' ist weder 'aktuell' noch 'veraltet'"
  fi

  if [ -n "$expected_type" ] && [ "$type" != "$expected_type" ]; then
    fail "type '$type' passt nicht zum Ordner '$folder' (erwartet: '$expected_type')"
  fi

  if [ -n "$last_reviewed" ]; then
    review_epoch=$(epoch_of "$last_reviewed")
    if [ -n "$review_epoch" ] && [ -n "$today_epoch" ]; then
      age_days=$(( (today_epoch - review_epoch) / 86400 ))
      if [ "$status" = "aktuell" ] && [ "$age_days" -gt "$STALE_DAYS" ]; then
        fail "last_reviewed liegt $age_days Tage zurück (> $STALE_DAYS), Eintrag ist aber als 'aktuell' markiert"
      fi
    fi
  fi

  related_line=$(grep -m1 '^related:' "$file" || true)
  if [ -n "$related_line" ]; then
    dir=$(dirname "$file")
    while read -r rel; do
      [ -z "$rel" ] && continue
      [ -f "$dir/$rel" ] || fail "related-Verweis '$rel' zeigt auf keine vorhandene Datei"
    done < <(echo "$related_line" | grep -oE '"[^"]+"' | tr -d '"')
  fi

done < <(find knowledge -type f -name "*.md" ! -name "_template.md")

echo
if [ "$errors" -gt 0 ]; then
  echo "$errors Problem(e) gefunden."
  exit 1
fi

echo "Alle Einträge sind vollständig und aktuell."
