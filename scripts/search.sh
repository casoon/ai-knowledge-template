#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ $# -eq 0 ]; then
  echo "Nutzung: $0 <suchbegriff>" >&2
  exit 1
fi

query="$1"

echo "Treffer für \"$query\":"
echo

grep -ril "$query" knowledge --include="*.md" | grep -v "_template.md" | while read -r file; do
  title=$(grep -m1 '^title:' "$file" | sed -E 's/^title: *"?//; s/"?$//')
  status=$(grep -m1 '^status:' "$file" | sed -E 's/^status: *//')
  printf "%-55s %-10s %s\n" "$file" "[$status]" "$title"
done
