---
name: knowledge-document-link
description: Hält die Verweise zwischen Wissenseinträgen unter `knowledge/` und den Typst-Quellen unter `documents/` konsistent. Diesen Skill verwenden, wenn ein Angebot, eine Rechnung, ein Projekt- oder Kundeneintrag angelegt, umbenannt, verschoben oder auf korrekte Dokument-ID und `typst_source` geprüft werden soll.
---

# Knowledge-document link

Die Wissensbasis enthält den suchbaren Kontext. Typst-Quellen erzeugen daraus
bei Bedarf externe PDFs. Beide Seiten brauchen dieselbe Dokument-ID, dürfen
aber keine PDF-Datei als Wissensquelle duplizieren.

## Vorgehen

1. Lies den betroffenen Wissenseintrag und die zugehörige `.typ`-Quelle.
2. Prüfe, dass `document_id` im Frontmatter mit `document_id` in der Typst-
   Quelle übereinstimmt.
3. Prüfe, dass `typst_source` auf die existierende Quelle unter `documents/`
   zeigt. Verwende einen relativen Repository-Pfad.
4. Prüfe die fachlichen Verbindungen (`related`): Kunde, Projekt und
   Vorgängerdokumente sollen auflösbar sein.
5. Ändere bei Umbenennungen beide Seiten in einem Zug und suche anschließend
   nach alten IDs oder Pfaden.

## Validierung

Führe nach Änderungen mindestens aus:

```bash
knowledge-lint lint knowledge
```

Falls das Binary nicht installiert ist, nutze die im Projekt-README
dokumentierte Installation aus dem Git-Repository. `knowledge-lint` prüft
Frontmatter, Kategorien, Status, `related`-Links, Attachments und typische
Secret-Fehler. Die fachliche Gleichheit von Dokument-ID und `typst_source`
prüfst du zusätzlich gezielt, weil sie projektübergreifend ist.

## Grenzen

Kein PDF in `knowledge/` ablegen und keine vertraulichen Angebots- oder
Rechnungsdaten in öffentlich markierte Einträge übernehmen.
