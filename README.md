# AI Knowledge Template

Ein GitHub-Template-Repository für eine Wissensbasis, mit der KI-Systeme (Chats, RAG, Agenten) zuverlässig arbeiten können. Kein Framework, keine Installation für die Wissensbasis selbst — eine Ordnerstruktur mit echten Beispielinhalten, plus ein eigenes Validierungs-Tool und eine optionale Präsentationsschicht für alles, was öffentlich sein darf.

## Nutzen

1. Oben rechts auf **"Use this template"** klicken, um ein eigenes (privates) Repository daraus zu erzeugen.
2. Die Beispieleinträge in `knowledge/` ansehen — sie zeigen das Muster (Frontmatter, Prüfdatum, Status, Verlinkung, Nachfolge-Beziehungen, öffentlich/privat) an echten, untereinander verlinkten Beispielen.
3. Mit `./scripts/search.sh <begriff>` durch die Beispiele suchen — einfache Volltextsuche, bevor über einen Vektorindex nachgedacht wird.
4. Mit [`knowledge-lint`](https://github.com/casoon/knowledge-lint) prüfen und aufräumen (siehe unten).
5. Eigene Kategorien in `knowledge/_types.yml` ergänzen (z. B. `customers/`, `projects/`, `meetings/`) — kein Code-Change nötig.
6. Beispielinhalte entfernen, sobald die eigene Struktur klar ist:

   ```bash
   knowledge-lint clean knowledge
   ```

   Entfernt alle Beispiel-Einträge, setzt `_attachments.yml` zurück und lässt die Ordnerstruktur sowie `knowledge/_template.md` als Vorlage stehen.

## Struktur

```
ai-knowledge-template/
├── README.md
├── LICENSE
├── GOVERNANCE.md
├── .sops.yaml
├── .github/
│   ├── CODEOWNERS
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── ISSUE_TEMPLATE/
│   │   └── eintrag-melden.md
│   └── workflows/
│       └── lint.yml
├── knowledge/
│   ├── _types.yml
│   ├── _attachments.yml
│   ├── _template.md
│   ├── entscheidungen/
│   ├── prozesse/
│   ├── produkte/
│   ├── glossar/
│   ├── secrets/
│   └── example-assets/
├── site/                      (optional: Astro Starlight, nur public:true)
└── scripts/
    └── search.sh
```

Validiert wird mit [`knowledge-lint`](https://github.com/casoon/knowledge-lint) — einem eigenständigen Rust-Tool (kein Teil dieses Repos, `cargo install --git https://github.com/casoon/knowledge-lint`), damit es auch für andere Wissensbasen mit derselben `_types.yml`-Konvention nutzbar bleibt.

### `knowledge/` — die Wissensbasis

- **`_types.yml`** — deklariert die Kategorien (Name, `kind`, erwarteter `type`, Prüfintervall). Neue Kategorie = neuer Eintrag hier, kein Code-Change. Drei Kategorie-Arten (`kind`):
  - `knowledge_entry` — normaler Markdown-Eintrag mit Frontmatter (Standardfall: `entscheidungen/`, `prozesse/`, `produkte/`, `glossar/`).
  - `sops_secret` — SOPS-verschlüsselte YAML-Dateien, kein Frontmatter-Schema (`secrets/`).
  - `assets` — reiner Ablageort für Dateien, die aus `_attachments.yml` referenziert werden (`example-assets/`).
- **`_template.md`** — Frontmatter-Vorlage für neue `knowledge_entry`-Einträge: `title`, `type`, `created`, `last_reviewed`, `status`, `source`, `related`, `public`.
- **`_attachments.yml`** — zentrale Registry für Verweise auf große Originaldateien (Scans, Exporte, PDFs), die nicht ins Repo eingebettet werden. [`knowledge-lint`](https://github.com/casoon/knowledge-lint) prüft, ob referenzierte Pfade noch existieren.
- **`secrets/`** — SOPS+age-verschlüsselte Dateien, siehe [`GOVERNANCE.md`](GOVERNANCE.md#geheime-daten). Bevorzugtes Muster bleibt aber ein `vault://`-Verweis statt Inline-Secrets, auch verschlüsselt.

### Validierung und Pflege: [`knowledge-lint`](https://github.com/casoon/knowledge-lint)

Ein eigenständiges Rust-Tool, installiert per `cargo install --git https://github.com/casoon/knowledge-lint --locked` — bewusst nicht Teil dieses Repos, damit es sich für jede Wissensbasis mit derselben `_types.yml`-Konvention nutzen lässt, nicht nur für dieses Template. Ein einzelnes Binary statt Bash-Textparsing, weil Frontmatter mit `grep`/`cut` an Sonderzeichen und verschachtelten Anführungszeichen leise falsch validiert statt laut zu scheitern:

```bash
# prüfen
knowledge-lint lint knowledge

# Beispielinhalte entfernen
knowledge-lint clean knowledge
```

`lint` prüft: Frontmatter-Vollständigkeit, gültige `status`-Werte, `type`-Konsistenz mit der Kategorie, auflösbare `related`-Verweise, überfällige `last_reviewed`-Daten (Schwelle aus `_types.yml`), dass jede Datei in `secrets/` tatsächlich SOPS-verschlüsselt ist, einen Klartext-Secret-Scan über den Rest der Wissensbasis, große Dateien (Warnung, `_attachments.yml` nutzen), und dass jeder Eintrag in `_attachments.yml` noch existiert (lokale Pfade werden geprüft, http(s)-URLs per HEAD-Request, Netzlaufwerk-Schemata übersprungen). Exit-Code 1 bei Fehlern, läuft automatisch als GitHub Action auf jeder Pull Request, die `knowledge/**` ändert.

### `site/` — optionale Präsentationsschicht (Astro Starlight)

Zeigt **nur** Einträge mit `public: true` im Frontmatter — alles andere (auch neue eigene Kategorien) bleibt unsichtbar, ohne dass man aktiv etwas ausschließen muss:

```bash
cd site
npm install
npm run dev    # führt vorher scripts/sync-public.mjs aus
npm run build
```

`scripts/sync-public.mjs` kopiert bei jedem `dev`/`build` alle `public: true`-Einträge aus `knowledge/` nach `site/src/content/docs/` (generiert, nicht Teil des Repos). Standardmäßig ist `public: false` — ein Eintrag muss aktiv freigegeben werden, nicht umgekehrt.

### Governance und Prozess

- **`GOVERNANCE.md`** — wer schreiben darf, wer lesen darf, was hier nicht landet, wie mit Geheimdaten umgegangen wird, Prüfintervall.
- **`.github/CODEOWNERS`** — macht die Zuständigkeit aus `GOVERNANCE.md` technisch verbindlich (Platzhalter-Handles, zum Anpassen).
- **`.github/PULL_REQUEST_TEMPLATE.md`** — Checkliste, gespiegelt aus `knowledge/prozesse/eintrag-review.md`.
- **`.github/ISSUE_TEMPLATE/eintrag-melden.md`** — Vorlage, um einen falschen oder veralteten Eintrag zu melden.

## Warum diese Struktur

Jeder Beispieleintrag demonstriert eine konkrete Praxis, und die Einträge verlinken bewusst aufeinander statt isoliert zu stehen:

- `knowledge/produkte/produkt-x-preismodell.md` und `produkt-x-preismodell-2026.md` zeigen das Nachfolge-Muster: Der veraltete Eintrag wird nicht überschrieben, sondern bleibt mit `status: veraltet` und Verweis auf die aktuelle Fassung stehen.
- `knowledge/entscheidungen/2026-01-tooling-wahl.md` und `2025-09-format-markdown-frontmatter.md` zeigen, wie eine Entscheidung mit Kontext, Begründung und Quelle nachvollziehbar bleibt — auch die Entscheidung für dieses Repo-Format selbst ist als Beispiel dokumentiert. Der Anhang-Verweis darin zeigt das `_attachments.yml`-Muster.
- `knowledge/prozesse/eintrag-review.md` beschreibt den Prozess, der die anderen Beispiele konsistent hält.
- `knowledge/glossar/rag.md`, `chunking.md` und `vektorindex.md` bilden ein kleines verlinktes Glossar, alle drei `public: true` — deshalb erscheinen genau diese drei in `site/`, wenn es gebaut wird.
- `knowledge/secrets/beispiel-credential.yaml` ist echt SOPS-verschlüsselt (nicht simuliert), aber mit einem Demo-Schlüssel, dessen privater Teil nirgends im Repo existiert — für niemanden entschlüsselbar, rein zur Strukturdemonstration.

Der Hintergrund dazu steht in einem begleitenden Artikel auf insights.casoon.de (folgt in Kürze).

## Lizenz

Inhalte stehen unter [CC BY 4.0](LICENSE).
