# AI Knowledge Template

Ein GitHub-Template-Repository für eine Wissensbasis, mit der KI-Systeme (Chats, RAG, Agenten) zuverlässig arbeiten können. Kein Framework, keine Installation — eine Ordnerstruktur mit echten Beispielinhalten, die zeigen, wie sich das anwenden lässt, statt es nur zu beschreiben.

## Nutzen

1. Oben rechts auf **"Use this template"** klicken, um ein eigenes Repository daraus zu erzeugen.
2. Die Beispieleinträge in `knowledge/` ansehen — sie zeigen das Muster (Frontmatter, Prüfdatum, Status, Verlinkung) an echten Beispielen, nicht nur in der Theorie.
3. Beispielinhalte entfernen, sobald die eigene Struktur klar ist:

   ```bash
   ./scripts/clean-examples.sh
   ```

   Das Skript löscht alle Beispiel-Einträge und lässt die Ordnerstruktur sowie `knowledge/_template.md` als Vorlage für neue Einträge stehen.

## Struktur

```
ai-knowledge-template/
├── README.md
├── LICENSE
├── GOVERNANCE.md
├── knowledge/
│   ├── _template.md
│   ├── entscheidungen/
│   ├── prozesse/
│   ├── produkte/
│   └── glossar/
└── scripts/
    └── clean-examples.sh
```

- **`knowledge/`** — die eigentliche Wissensbasis, nach Typ geordnet. Vier Kategorien sind vorgegeben (Entscheidungen, Prozesse, Produkte, Glossar), lassen sich aber umbenennen oder erweitern.
- **`knowledge/_template.md`** — Frontmatter-Vorlage für neue Einträge: Titel, Typ, Erstellungsdatum, Datum der letzten Prüfung, Status, Quelle, verwandte Einträge.
- **`GOVERNANCE.md`** — wer schreiben darf, wer lesen darf, was hier explizit nicht hineingehört.
- **`scripts/clean-examples.sh`** — entfernt alle Beispielinhalte nach der Template-Nutzung, behält die Struktur.

## Warum diese Struktur

Jeder Beispieleintrag demonstriert eine konkrete Praxis: `knowledge/produkte/produkt-x-preismodell.md` zeigt, wie ein veralteter Eintrag markiert statt stillschweigend überschrieben wird. `knowledge/entscheidungen/2026-01-tooling-wahl.md` zeigt, wie eine Entscheidung mit Begründung und Quelle nachvollziehbar bleibt. Der Hintergrund dazu steht in einem begleitenden Artikel auf insights.casoon.de (folgt in Kürze).

## Lizenz

Inhalte stehen unter [CC BY 4.0](LICENSE).
