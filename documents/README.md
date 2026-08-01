# Typst-Demos

Dieses Verzeichnis ist eine geschlossene Typst-Projektwurzel: Quellen,
Templates, Stammdaten und Übersetzungen liegen alle hier. Damit erzeugt
`typstgen` PDFs ohne docgen, Subprocess oder virtuelle Daten-Injection.
Die Quellen ergänzen die Markdown-Zusammenfassungen in `knowledge/`, ersetzen
sie aber nicht.

## Voraussetzungen und Workflow

1. `typstgen` installieren:

   ```bash
   cargo install typstgen
   ```

2. Stammdaten in [`_data/company.json`](_data/company.json) und Texte in
   [`_data/locales/`](./_data/locales) anpassen. Acht vollständige Locales
   (`de`, `en`, `es`, `fr`, `it`, `nl`, `pl`, `pt`) verwenden dieselben
   Schlüssel. Nur echte, versionierte Dateien verwenden; Zugangsdaten gehören
   nicht in die JSON-Dateien.

3. Ein Dokument erzeugen:

   ```bash
   typstgen compile documents/offers/2026/CAS-ANG-2026-001-website-relaunch.typ \
     --config typstgen.toml
   ```

4. Alle Demoquellen erzeugen:

   ```bash
   find documents -path documents/templates -prune -o -name '*.typ' -print0 | while IFS= read -r -d '' source; do
     typstgen compile "$source" --config typstgen.toml
   done
   ```

Die PDFs liegen jeweils neben ihrer Quelle. Sie sind per `.gitignore`
ausgeschlossen und gehören nicht in den RAG-Index.

## Pfadkonvention

[`typstgen.toml`](../typstgen.toml) setzt `documents/` als virtuelle
Dateiwurzel. Deshalb verwenden die Quellen bewusst absolute virtuelle Pfade:

```typst
#import "/templates/business.typ": business_document
#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
```

Das macht sie unabhängig vom Verzeichnis der einzelnen Quelle. Neue Dokumente
können ein vorhandenes `.typ` kopieren, eine Dokument-ID vergeben und dieselben
Dateien einbinden. Weitere Templates gehören nach `templates/`, weitere
Stammdaten oder Locale-Dateien nach `_data/`.

Alle Werte sind fiktive Demo-Daten.

## Dokumentfluss

1. Angebot
2. Auftragsbestaetigung
3. Kickoff-Protokoll
4. Aenderungsantrag
5. Abnahme
6. Rechnung
7. Servicevereinbarung

Die jeweilige `document_id` stimmt mit dem verknuepften Wissenseintrag unter
`knowledge/` ueberein. `typstgen` ist ausschliesslich Renderer: Status,
Berechtigung und Retrieval werden ausserhalb des Renderers entschieden.
