---
title: "Konzept: Heimnetz neu aufbauen"
type: konzept
created: 2026-08-03
last_reviewed: 2026-08-03
status: aktuell
source: "Fiktive private Planung für dieses Template"
related: []
public: false
sphere: privat
classification: internal
---

## Zusammenfassung

Das gewachsene Heimnetz wird neu strukturiert: getrennte Netze für Arbeit,
Haushaltsgeräte und Gäste, Fernzugriff nur über ein VPN statt über offene
Portweiterleitungen. Anlass ist der Glasfaseranschluss, der ohnehin einen
Routertausch erzwingt.

## Kernpunkte

- Drei getrennte Netzsegmente; Haushaltsgeräte erreichen den Arbeitsrechner nicht.
- Kein Dienst wird direkt aus dem Internet erreichbar gemacht.
- Backups laufen auf zwei Ziele, eines davon außer Haus.

## Einordnung

Privates Vorhaben ohne Kundenbezug. Der Eintrag steht hier, weil die
Entscheidungen später nachvollziehbar bleiben sollen — nicht, weil sie für
Kundenarbeit relevant wären.

## Warum dieser Eintrag im Template steht

Er zeigt die Trennung, nicht das Heimnetz. Wer aus diesem Template ableitet,
sammelt früher oder später auch Privates: Bauvorhaben, Gesundheitsrecherchen,
Familienthemen. Ohne Trennung landet das im selben Index wie die Kundenarbeit,
und eine Frage zum Kundenprojekt zieht es in den Kontext.

Deshalb: `sphere: privat` im Frontmatter **und** Ablage unter `privat/`. Das
Feld erlaubt einer Retrieval-Schicht das Filtern ohne Pfad-Parsing, der Pfad
macht die Trennung beim Durchsehen sichtbar und erlaubt ein grobes
`**/privat/**`-Muster. Ein privater Eintrag verweist nie auf einen Kundeneintrag
und wird nie `public: true`.
