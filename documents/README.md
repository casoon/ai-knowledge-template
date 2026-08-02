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

## Daten und Layout getrennt

Die Quellen enthalten keine Zahlen und keine Kundenangaben im Fließtext. Sie
lesen sie aus `_data/`:

| Datei | Inhalt |
| --- | --- |
| `_data/company.json` | eigene Firmenangaben für den Briefkopf |
| `_data/demo-project.json` | Kunde, Projektziel, Meilensteine, Entscheidungen |
| `_data/demo-offer.json` | Angebotspositionen, Mengen, Nettopreise |
| `_data/demo-invoice.json` | Rechnungspositionen und Zahlungsangaben |
| `_data/locales/*.json` | Beschriftungen des Templates in acht Sprachen |

Dadurch ändert eine Preis- oder Terminkorrektur genau eine Stelle statt sechs
Textpassagen. Alle Werte in den `demo-*.json` sind fiktiv.

## Dokumentfluss

Neun Schritte bilden einen vollständigen Vorgang ab, acht davon mit Typst-Quelle:

| # | Dokument | Quelle | Dokument-ID |
| --- | --- | --- | --- |
| 1 | Angebot | `offers/2026/` | `CAS-ANG-2026-001` |
| 2 | Auftragsbestätigung | `order-confirmations/2026/` | `CAS-AUF-2026-001` |
| 3 | Kickoff-Protokoll | `protocols/2026/` | `CAS-PRO-2026-001` |
| 4 | Konzept | `concepts/2026/` | `CAS-KON-2026-001` |
| 5 | Änderungsantrag | — | `CR-2026-001` |
| 6 | Abnahme | `acceptance/2026/` | `ABN-2026-001` |
| 7 | Rechnung | `invoices/2026/` | `RE-2026-001` |
| 8 | Redaktions- und Betriebsdokumentation | `documentation/2026/` | `CAS-DOC-2026-001` |
| 9 | Servicevereinbarung | `service/2026/` | `SRV-2026-001` |

Der Änderungsantrag hat bewusst keine Typst-Quelle. Er zeigt den Normalfall:
Nicht jeder Vorgang braucht ein PDF, der Wissenseintrag unter
`knowledge/aenderungen/` reicht. Deshalb trägt er auch keine `typst_source`.

Jede `document_id` stimmt mit dem verknüpften Wissenseintrag unter `knowledge/`
überein. `konzepte/` und `dokumentation/` zeigen dabei den Unterschied am
deutlichsten: Die Typst-Quelle ist die ausführliche, kundenfähige Fassung mit
Tabellen und Prozessbeschreibung, der Wissenseintrag die kompakte,
maschinenlesbare Zusammenfassung derselben Sache.

`typstgen` ist ausschließlich Renderer: Status, Berechtigung und Retrieval
werden außerhalb des Renderers entschieden.

## Demo-Inhalte entfernen

Vor dem ersten echten Dokument:

```bash
../scripts/clean-demo.sh          # Trockenlauf, zeigt nur an
../scripts/clean-demo.sh --yes    # entfernt Quellen und demo-*.json
```

`templates/`, `_data/company.json` und `_data/locales/` bleiben erhalten.
`knowledge-lint clean` räumt dagegen nur `knowledge/` auf und lässt dieses
Verzeichnis unberührt — beide Schritte sind nötig, siehe [`SETUP.md`](../SETUP.md).
