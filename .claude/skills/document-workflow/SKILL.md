---
name: document-workflow
description: Erzeugt und prüft externe PDFs aus den Typst-Quellen dieses Repositories. Diesen Skill verwenden, wenn jemand ein Dokument unter `documents/` erstellen, ändern, kompilieren, alle Dokumente bauen oder einen PDF-Fehler in der Vorlage untersuchen möchte.
---

# Document workflow

`documents/` ist eine geschlossene Typst-Projektwurzel. Quellen, Templates,
Stammdaten und Übersetzungen bleiben dort als versionierbare Dateien; PDFs sind
generierte Artefakte und gehören nicht in den RAG-Index.

## Vorgehen

1. Lies `documents/README.md` und `typstgen.toml`, bevor du Pfade änderst.
2. Bewahre die virtuellen Pfade in den Quellen bei:

   ```typst
   #import "/templates/business.typ": business_document
   #let company = json("/_data/company.json")
   #let locale = json("/_data/locales/de.json")
   ```

3. Lege neue Quellen in der passenden Dokumentkategorie an. Verwende eine
   eindeutige Dokument-ID und halte sie mit dem verlinkten Wissenseintrag
   konsistent.
4. Erzeuge eine gezielt betroffene PDF:

   ```bash
   typstgen compile <quelle.typ> --config typstgen.toml
   ```

5. Prüfe bei Layout-Änderungen mindestens die erste PDF-Seite visuell. Achte
   auf Kopf, Statusblock, Tabellen, Umbrüche und Footer. Entferne reine
   Testartefakte anschließend oder lasse sie ignoriert; committe keine PDFs.

## Alle Demoquellen bauen

Schließe `documents/templates/` aus, denn Templates sind keine eigenständigen
Dokumente:

```bash
find documents -path documents/templates -prune -o -name '*.typ' -print0 |
  while IFS= read -r -d '' source; do
    typstgen compile "$source" --config typstgen.toml
  done
```

## Grenzen

Füge keine Zugangsdaten oder sensiblen Kundenwerte in die Demo-JSON-Dateien
ein. Verweise für Geheimnisse bleiben in der Wissensbasis oder im Vault.
