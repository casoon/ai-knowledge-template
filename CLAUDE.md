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
