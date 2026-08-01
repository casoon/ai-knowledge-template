# AI Knowledge Template

Ein GitHub-Template-Repository für eine Wissensbasis, mit der KI-Systeme (Chats, RAG, Agenten) zuverlässig arbeiten können. Kein Framework, keine Installation — eine Ordnerstruktur mit echten Beispielinhalten, die zeigen, wie sich das anwenden lässt, statt es nur zu beschreiben.

## Nutzen

1. Oben rechts auf **"Use this template"** klicken, um ein eigenes Repository daraus zu erzeugen.
2. Die Beispieleinträge in `knowledge/` ansehen — sie zeigen das Muster (Frontmatter, Prüfdatum, Status, Verlinkung, Nachfolge-Beziehungen) an echten, untereinander verlinkten Beispielen, nicht nur in der Theorie.
3. Mit `./scripts/search.sh <begriff>` durch die Beispiele suchen, um zu sehen, wie einfache Volltextsuche über Frontmatter und Inhalt funktioniert, bevor über einen Vektorindex nachgedacht wird.
4. Mit `./scripts/lint.sh` prüfen, ob alle Einträge vollständige Frontmatter haben, `related`-Verweise auflösbar sind und keine als `aktuell` markierten Einträge das Prüfintervall überschritten haben. Läuft auch automatisch als GitHub Action auf jeder Pull Request, die `knowledge/**` ändert.
5. Beispielinhalte entfernen, sobald die eigene Struktur klar ist:

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
├── .github/
│   ├── CODEOWNERS
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── ISSUE_TEMPLATE/
│   │   └── eintrag-melden.md
│   └── workflows/
│       └── lint.yml
├── knowledge/
│   ├── _template.md
│   ├── entscheidungen/
│   │   ├── 2025-09-format-markdown-frontmatter.md
│   │   └── 2026-01-tooling-wahl.md
│   ├── prozesse/
│   │   ├── eintrag-review.md
│   │   └── kunden-onboarding.md
│   ├── produkte/
│   │   ├── produkt-x-preismodell.md
│   │   └── produkt-x-preismodell-2026.md
│   └── glossar/
│       ├── chunking.md
│       ├── rag.md
│       └── vektorindex.md
└── scripts/
    ├── clean-examples.sh
    ├── lint.sh
    └── search.sh
```

- **`knowledge/`** — die eigentliche Wissensbasis, nach Typ geordnet. Vier Kategorien sind vorgegeben (Entscheidungen, Prozesse, Produkte, Glossar), lassen sich aber umbenennen oder erweitern.
- **`knowledge/_template.md`** — Frontmatter-Vorlage für neue Einträge: Titel, Typ, Erstellungsdatum, Datum der letzten Prüfung, Status, Quelle, verwandte Einträge.
- **`GOVERNANCE.md`** — wer schreiben darf, wer lesen darf, was hier explizit nicht hineingehört.
- **`.github/CODEOWNERS`** — macht die Zuständigkeit aus `GOVERNANCE.md` technisch verbindlich (Platzhalter-Handles, zum Anpassen).
- **`.github/PULL_REQUEST_TEMPLATE.md`** — Checkliste für neue oder geänderte Einträge, gespiegelt aus `knowledge/prozesse/eintrag-review.md`.
- **`.github/ISSUE_TEMPLATE/eintrag-melden.md`** — Vorlage, um einen falschen oder veralteten Eintrag zu melden.
- **`.github/workflows/lint.yml`** — führt `scripts/lint.sh` bei jeder Pull Request aus, die `knowledge/**` ändert.
- **`scripts/clean-examples.sh`** — entfernt alle Beispielinhalte nach der Template-Nutzung, behält die Struktur.
- **`scripts/search.sh`** — einfache Volltextsuche über `knowledge/`, zeigt Fundstelle, Status und Titel pro Treffer.
- **`scripts/lint.sh`** — prüft Frontmatter-Vollständigkeit, gültige `status`-Werte, `type`-Konsistenz mit dem Ordner, auflösbare `related`-Verweise und überfällige Prüfdaten. Exit-Code 1 bei Problemen, nutzbar lokal und in CI.

## Warum diese Struktur

Jeder Beispieleintrag demonstriert eine konkrete Praxis, und die Einträge verlinken bewusst aufeinander statt isoliert zu stehen:

- `knowledge/produkte/produkt-x-preismodell.md` und `produkt-x-preismodell-2026.md` zeigen das Nachfolge-Muster: Der veraltete Eintrag wird nicht überschrieben, sondern bleibt mit `status: veraltet` und Verweis auf die aktuelle Fassung stehen.
- `knowledge/entscheidungen/2026-01-tooling-wahl.md` und `2025-09-format-markdown-frontmatter.md` zeigen, wie eine Entscheidung mit Kontext, Begründung und Quelle nachvollziehbar bleibt — auch die Entscheidung für dieses Repo-Format selbst ist als Beispiel dokumentiert.
- `knowledge/prozesse/eintrag-review.md` beschreibt den Prozess, der die anderen Beispiele erst konsistent hält (wann wird `status` auf `veraltet` gesetzt, wann `last_reviewed` aktualisiert).
- `knowledge/glossar/rag.md`, `chunking.md` und `vektorindex.md` bilden ein kleines verlinktes Glossar und zeigen, wie granular ein Eintrag sein sollte, um einzeln in den Kontext geladen werden zu können.

Der Hintergrund dazu steht in einem begleitenden Artikel auf insights.casoon.de (folgt in Kürze).

## Lizenz

Inhalte stehen unter [CC BY 4.0](LICENSE).
