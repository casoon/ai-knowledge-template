---
title: "Entscheidung: Markdown mit YAML-Frontmatter statt Wiki-Tool für die Wissensbasis"
type: entscheidung
created: 2025-09-04
last_reviewed: 2026-01-15
status: aktuell
source: "Team-Retro, 2025-09-04"
related: ["../prozesse/eintrag-review.md"]
---

## Kontext

Die Wissensbasis lag zuvor in einem Wiki-Tool mit eigener Oberfläche. KI-Systeme mussten Inhalte per API oder Export abrufen, Diffs und Reviews liefen außerhalb des normalen Entwicklungsworkflows.

## Entscheidung

Wissenseinträge als Markdown-Dateien mit YAML-Frontmatter in einem Git-Repository, nicht in einem separaten Wiki-Tool.

## Begründung

- Versionierung, Review und Historie kommen kostenlos mit Git, statt separat gebaut zu werden.
- Metadaten im Frontmatter sind für Menschen und Maschinen gleichermaßen les- und parsbar.
- Kein zusätzliches Tool, kein zusätzlicher Login, keine zusätzliche Zugriffsverwaltung neben der bestehenden Repo-Berechtigung.

## Konsequenzen

Suche und Retrieval müssen selbst gebaut oder mit einfachen Mitteln (Volltextsuche, siehe `scripts/search.sh`) abgedeckt werden, statt eine eingebaute Wiki-Suche zu nutzen. Für die Größenordnung dieser Wissensbasis ist das ein akzeptabler Tausch.
