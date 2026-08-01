#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Entferne Beispielinhalte aus knowledge/ ..."

find knowledge -type f -name "*.md" ! -name "_template.md" -delete

for dir in knowledge/entscheidungen knowledge/prozesse knowledge/produkte knowledge/glossar; do
  mkdir -p "$dir"
  touch "$dir/.gitkeep"
done

echo "Fertig. knowledge/_template.md dient als Vorlage für neue Einträge."
