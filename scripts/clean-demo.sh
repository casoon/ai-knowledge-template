#!/usr/bin/env bash
# Entfernt die Demo-Inhalte unter documents/ — die Typst-Quellen und die
# fiktiven Projekt-, Angebots- und Rechnungsdaten. `knowledge-lint clean`
# räumt nur knowledge/ auf und lässt documents/ unberührt; dieses Skript ist
# das Gegenstück dazu.
#
# Erhalten bleiben: documents/templates/, documents/_data/company.json,
# documents/_data/locales/ und documents/README.md — also alles, was als
# Vorlage für eigene Dokumente gebraucht wird.
#
# Standardmäßig ein Trockenlauf. Erst `--yes` löscht wirklich.
set -euo pipefail

cd "$(dirname "$0")/.."

apply=false
if [ "${1:-}" = "--yes" ]; then
  apply=true
elif [ $# -gt 0 ]; then
  echo "Nutzung: $0 [--yes]" >&2
  exit 1
fi

targets=()

while IFS= read -r source; do
  targets+=("$source")
done < <(find documents -path documents/templates -prune -o -name '*.typ' -print | sort)

for data in documents/_data/demo-*.json; do
  [ -e "$data" ] && targets+=("$data")
done

if [ ${#targets[@]} -eq 0 ]; then
  echo "Keine Demo-Inhalte unter documents/ gefunden."
  exit 0
fi

if [ "$apply" = false ]; then
  echo "Trockenlauf — folgende Dateien würden entfernt:"
  printf '  %s\n' "${targets[@]}"
  echo
  echo "Zum Ausführen: $0 --yes"
  exit 0
fi

rm -f "${targets[@]}"

# Jahres- und Kategorieordner, die dadurch leer geworden sind, mit entfernen.
find documents -mindepth 1 -type d -empty -delete

echo "${#targets[@]} Demo-Dateien entfernt. documents/templates/, _data/company.json"
echo "und _data/locales/ sind erhalten geblieben."
