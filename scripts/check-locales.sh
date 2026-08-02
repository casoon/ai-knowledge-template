#!/usr/bin/env bash
# Prüft, dass jede Locale-Datei denselben Schlüsselsatz hat wie de.json und
# keinen leeren Wert enthält. Der Schlüsselsatz wird aus de.json gelesen, nicht
# hier hartkodiert — sonst wird der Check still falsch, sobald jemand einen
# Schlüssel ergänzt.
set -euo pipefail

cd "$(dirname "$0")/.."

locales_dir=documents/_data/locales
reference="$locales_dir/de.json"

if [ ! -f "$reference" ]; then
  echo "Referenzdatei $reference fehlt." >&2
  exit 1
fi

expected=$(jq -S 'keys' "$reference")
failed=0

for file in "$locales_dir"/*.json; do
  name=$(basename "$file")

  if ! jq -e . "$file" >/dev/null 2>&1; then
    echo "$name: kein gültiges JSON" >&2
    failed=1
    continue
  fi

  actual=$(jq -S 'keys' "$file")
  if [ "$actual" != "$expected" ]; then
    echo "$name: Schlüsselsatz weicht von de.json ab" >&2
    diff <(echo "$expected") <(echo "$actual") >&2 || true
    failed=1
    continue
  fi

  if ! jq -e 'all(.[]; type == "string" and length > 0)' "$file" >/dev/null; then
    echo "$name: enthält leere oder nicht-textuelle Werte" >&2
    failed=1
  fi
done

if [ "$failed" -ne 0 ]; then
  exit 1
fi

echo "Locale-Dateien konsistent zu de.json."
