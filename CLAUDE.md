# Projektkontext für Coding-Agenten

Wissensbasis aus Markdown-Dateien mit Frontmatter plus Typst-Quellen für PDFs.
Kein Framework, keine Build-Pipeline für `knowledge/`.

## Wo was hingehört

- `knowledge/<kategorie>/*.md` — Wissenseinträge. Kategorien sind in
  `knowledge/_types.yml` deklariert; eine neue Kategorie ist ein Eintrag dort,
  kein Code-Change. Frontmatter-Vorlage: `knowledge/_template.md`.
- `documents/` — geschlossene Typst-Projektwurzel. Quellen verwenden absolute
  virtuelle Pfade (`/templates/…`, `/_data/…`), niemals relative.
- `site/` — Starlight, zeigt ausschließlich Einträge mit `public: true`.
- `.claude/skills/` — die Abläufe für Dokumente, Locales und die Verknüpfung
  zwischen `knowledge/` und `documents/`.

## Bevor du einen Eintrag anlegst

Prüfe: **Kann ein KI-System das zuverlässig aus einer vertrauenswürdigen
öffentlichen Quelle beziehen?** Wenn ja, gehört es nicht hierher. Diese Basis
ist das Gedächtnis der Organisation, nicht ihre Enzyklopädie.

Keine kopierte Framework-, Sprach- oder Tool-Dokumentation. Stattdessen unter
`knowledge/quellen/` festhalten, welche Referenz für welches Thema gilt. Die
Bindung an eine Version ist Eigenwissen, der Inhalt der Version nicht.

Am wertvollsten sind `entscheidungen/` und `prozesse/` — das Warum und das Wie,
die nirgends sonst stehen. Wenn du beim Zusammenfassen eines Vorgangs auf eine
begründete Entscheidung stößt, gehört sie zusätzlich als eigener Eintrag nach
`entscheidungen/`, nicht nur als Satz in der Zusammenfassung. Sonst ist sie
gespeichert, aber nicht auffindbar.

## Geschäftlich und privat

Jeder Eintrag trägt `sphere: geschaeftlich | privat`. In `konzepte/` und
`dokumentation/` — den Kategorien, in denen beides vorkommt — muss der Wert zum
Unterordner passen: `privat` liegt unter `privat/`, sonst unter
`geschaeftlich/`. Alle anderen Kategorien sind ihrer Natur nach geschäftlich
und bleiben flach.

Ein privater Eintrag verweist nie auf einen Kundeneintrag und wird nie
`public: true`.

## Regeln

- Standard ist `public: false`. Ein Eintrag wird aktiv freigegeben, nie
  versehentlich.
- Keine Zugangsdaten im Klartext, auch nicht in den JSON-Dateien unter
  `documents/_data/`. Stattdessen `vault://`-Verweis oder verschlüsselter
  Eintrag unter `knowledge/secrets/`.
- Wissensstatus (`status`) und Geschäftsstatus (`document_status`) sind
  getrennt. Eine bezahlte Rechnung bleibt als Wissenseintrag `aktuell`.
- Keine PDFs committen. Sie sind generierte Artefakte und in `.gitignore`.
- Ein veralteter Eintrag wird nicht überschrieben, sondern bekommt
  `status: veraltet` und einen `related`-Verweis auf den Nachfolger.

## Validierung

```bash
knowledge-lint lint knowledge
```

Prüft Frontmatter, Kategorien, Status, `related`-Verweise, Prüfintervalle,
Verschlüsselung unter `secrets/` und die Einträge in `_attachments.yml`.
