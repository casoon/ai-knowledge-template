---
title: "Prozess: Neue und veraltete Einträge reviewen"
type: prozess
created: 2025-09-10
last_reviewed: 2026-02-01
status: aktuell
source: "Internes Playbook, Team Ops"
related: ["../entscheidungen/2025-09-format-markdown-frontmatter.md"]
sphere: geschaeftlich
---

## Ablauf für neue Einträge

1. Neuer Eintrag per Pull Request, ausgehend von `knowledge/_template.md`.
2. Review durch eine zweite Person mit Fachwissen zum Thema – nicht durch die Person, die den Eintrag geschrieben hat.
3. Merge erst, wenn Frontmatter vollständig ist (`type`, `created`, `last_reviewed`, `status`, `source`).

## Ablauf für die turnusmäßige Prüfung

1. Einträge unter `produkte/` und `prozesse/` werden vierteljährlich durchgesehen (siehe `GOVERNANCE.md`).
2. Gilt ein Eintrag nicht mehr, wird `status` auf `veraltet` gesetzt und – falls es einen Nachfolger gibt – im `related`-Feld darauf verwiesen, statt den Eintrag zu löschen oder stillschweigend zu überschreiben.
3. `last_reviewed` wird bei jeder Prüfung aktualisiert, auch wenn sich inhaltlich nichts geändert hat – das macht sichtbar, dass geprüft wurde, statt dass der Eintrag einfach nur alt aussieht.

## Bekannte Stolperstellen

Ein Review, der nur den Diff prüft, aber nicht `last_reviewed` aktualisiert, hinterlässt einen Eintrag, der jünger aussieht, als er tatsächlich geprüft wurde.
