---
title: "Entscheidung: Vektor-Datenbank für internes RAG-System"
type: entscheidung
created: 2026-01-15
last_reviewed: 2026-01-15
status: aktuell
source: "Architektur-Review, 2026-01-15"
related: ["../glossar/rag.md"]
---

## Kontext

Für das interne RAG-System wird eine Vektor-Datenbank benötigt, die sich in die bestehende Postgres-Infrastruktur einfügt, ohne einen zusätzlichen Betriebsprozess zu erfordern.

## Entscheidung

`pgvector` als Postgres-Extension statt einer separaten Vektor-Datenbank (z. B. Pinecone, Weaviate).

## Begründung

- Kein zusätzlicher Dienst, keine zusätzliche Ausfallquelle.
- Team hat bereits Postgres-Betriebserfahrung.
- Datenvolumen (< 200.000 Einträge) rechtfertigt keine dedizierte Lösung.

## Konsequenzen

Bei deutlich wachsendem Datenvolumen (> 1 Mio. Einträge) muss diese Entscheidung erneut geprüft werden. Dieser Eintrag ist dann fällig zur Überprüfung, nicht stillschweigend weiter gültig — daher bleibt er stehen, statt gelöscht zu werden, auch wenn sich die Entscheidung später ändert.

## Anhang

Das Lastprofil aus dem Architektur-Review liegt als Originaldatei vor, nicht eingebettet — siehe `beispiel-anhang` in [`_attachments.yml`](../_attachments.yml).
