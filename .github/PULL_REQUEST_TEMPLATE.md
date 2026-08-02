## Änderung

<!-- Neuer Eintrag, Aktualisierung, Korrektur -->

## Checkliste

- [ ] Frontmatter vollständig (`title`, `type`, `created`, `last_reviewed`, `status`, `source`)
- [ ] `status` ist `aktuell` oder `veraltet`
- [ ] `last_reviewed` aktualisiert, falls inhaltlich geprüft
- [ ] `related`-Verweise zeigen auf vorhandene Dateien (`knowledge-lint lint knowledge` lokal ausgeführt)
- [ ] Review durch eine zweite Person (siehe `knowledge/prozesse/eintrag-review.md`)

## Sichtbarkeit und Schutzklasse

- [ ] `public` bewusst gesetzt. `public: true` veröffentlicht den Eintrag über `site/` — bei Kunden-, Angebots- oder Rechnungsinhalten bleibt es bei `false`.
- [ ] `classification` gesetzt, falls der Eintrag Kunden-, Vertrags- oder Zugangsbezug hat (`internal`, `confidential`, `secret`).
- [ ] Keine Zugangsdaten im Klartext — stattdessen `vault://`-Verweis oder verschlüsselter Eintrag unter `knowledge/secrets/`.

## Dokumentbezug (falls vorhanden)

- [ ] `document_id` stimmt mit der Typst-Quelle überein, `typst_source` zeigt auf eine existierende Datei
- [ ] `document_status` beschreibt den Geschäftsstand, nicht den Wissensstand — die beiden sind getrennt
