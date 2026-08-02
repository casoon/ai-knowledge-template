---
name: locale-maintenance
description: Pflegt und erweitert die JSON-Übersetzungen unter `documents/_data/locales/`. Diesen Skill verwenden, wenn eine Sprache ergänzt, Übersetzungen geändert oder die Schlüssel aller Locale-Dateien auf Konsistenz geprüft werden sollen.
---

# Locale maintenance

`documents/_data/locales/de.json` ist die Referenz für die Struktur aller
Sprachdateien. Jede Locale enthält exakt denselben Schlüsselsatz, damit die
Typst-Templates ohne Sonderfälle arbeiten.

## Neue Sprache anlegen

1. Lies `de.json` und übernimm jeden Schlüssel unverändert.
2. Lege `<iso-639-1>.json` mit einem zweibuchstabigen Sprachcode an.
3. Übersetze nur die Werte. Behalte JSON, Schlüssel und Platzhalter stabil.
4. Wechsle den Locale-Pfad in einer Typst-Quelle nur, wenn das konkrete
   Dokument auch in dieser Sprache ausgegeben werden soll:

   ```typst
   #let locale = json("/_data/locales/en.json")
   ```

## Validierung

Prüfe nach jeder Änderung alle Dateien gegen die Referenzstruktur:

```bash
./scripts/check-locales.sh
```

Das Skript liest den erwarteten Schlüsselsatz aus `de.json`, statt ihn zu
wiederholen — eine hartkodierte Liste wird still falsch, sobald jemand einen
Schlüssel ergänzt. Es meldet abweichende Schlüssel, leere Werte und ungültiges
JSON und läuft auch in der GitHub Action.

Wenn die geänderte Sprache in einer Quelle verwendet wird, kompiliere diese
Quelle anschließend mit `typstgen compile <quelle.typ> --config typstgen.toml`.

## Schreibstil

Übersetze Kontextbegriffe wie `client`, `project`, `status`, `date` und
`contact` sachlich. Produktnamen, Dokument-IDs und rechtlich relevante Texte
werden nicht in dieser Datei übersetzt.
