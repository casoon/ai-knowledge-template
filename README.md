# AI Knowledge Template

Ein GitHub-Template-Repository für eine Wissensbasis, mit der KI-Systeme (Chats, RAG, Agenten) zuverlässig arbeiten können. Kein Framework, keine Installation für die Wissensbasis selbst — eine Ordnerstruktur mit echten Beispielinhalten, plus ein eigenes Validierungs-Tool und eine optionale Präsentationsschicht für alles, was öffentlich sein darf.

## Nutzen

1. Oben rechts auf **"Use this template"** klicken, um ein eigenes (privates) Repository daraus zu erzeugen.
2. Die Beispieleinträge in `knowledge/` ansehen — sie zeigen das Muster (Frontmatter, Prüfdatum, Status, Verlinkung, Nachfolge-Beziehungen, öffentlich/privat) an echten, untereinander verlinkten Beispielen.
3. Mit `./scripts/search.sh <begriff>` durch die Beispiele suchen — einfache Volltextsuche, bevor über einen Vektorindex nachgedacht wird.
4. Mit [`knowledge-lint`](https://github.com/casoon/knowledge-lint) prüfen (siehe unten).
5. Eigene Kategorien in `knowledge/_types.yml` ergänzen (z. B. `meetings/`, `vertraege/`) — kein Code-Change nötig.
6. **[`SETUP.md`](SETUP.md) abarbeiten**, bevor echte Daten hineinkommen. Dort steht als Checkliste, was ein abgeleitetes Repository ersetzen muss: eigener Age-Schlüssel, Firmenstammdaten, CODEOWNERS-Handles, Governance-Platzhalter, Lizenz, Site-Identität — und wie die Beispielinhalte entfernt werden.

Für den letzten Punkt gibt es zwei Kommandos, weil sie verschiedene Bereiche betreffen:

```bash
knowledge-lint clean knowledge   # Beispiel-Einträge in knowledge/
./scripts/clean-demo.sh --yes    # Typst-Demos und demo-*.json in documents/
```

`knowledge-lint clean` entfernt alle Beispiel-Einträge, setzt `_attachments.yml` zurück und lässt Ordnerstruktur und `knowledge/_template.md` als Vorlage stehen. Es fragt nicht nach und ist nicht rückgängig zu machen — nur direkt nach der Ableitung ausführen, nie in einer befüllten Wissensbasis. `clean-demo.sh` läuft ohne `--yes` als Trockenlauf.

## Struktur

```
ai-knowledge-template/
├── README.md
├── SETUP.md                   (Checkliste nach "Use this template")
├── CLAUDE.md                  (Projektkontext für Coding-Agenten)
├── GOVERNANCE.md
├── LICENSE
├── .sops.yaml
├── typstgen.toml
├── .claude/
│   └── skills/                (Arbeitsabläufe für Coding-Agenten)
│       ├── document-workflow/
│       ├── locale-maintenance/
│       └── knowledge-document-link/
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
│   ├── kunden/
│   ├── projekte/
│   ├── angebote/
│   ├── konzepte/
│   ├── dokumentation/
│   ├── auftragsbestaetigungen/
│   ├── protokolle/
│   ├── aenderungen/
│   ├── abnahmen/
│   ├── abrechnung/
│   ├── service/
│   ├── secrets/
│   └── example-assets/
├── site/                      (optional: Astro Starlight, nur public:true)
├── documents/                 (geschlossene Typst-Wurzel, PDFs werden nicht committed)
│   ├── _data/                 (company.json, demo-*.json, locales/)
│   ├── templates/
│   ├── offers/ order-confirmations/ protocols/
│   ├── concepts/ acceptance/ invoices/
│   └── documentation/ service/
└── scripts/
    ├── search.sh
    └── clean-demo.sh
```

Validiert wird mit [`knowledge-lint`](https://github.com/casoon/knowledge-lint) — einem eigenständigen Rust-Tool (kein Teil dieses Repos, `cargo install --git https://github.com/casoon/knowledge-lint`), damit es auch für andere Wissensbasen mit derselben `_types.yml`-Konvention nutzbar bleibt.

### `knowledge/` — die Wissensbasis

- **`_types.yml`** — deklariert die Kategorien (Name, `kind`, erwarteter `type`, Prüfintervall). Neue Kategorie = neuer Eintrag hier, kein Code-Change. Drei Kategorie-Arten (`kind`):
  - `knowledge_entry` — normaler Markdown-Eintrag mit Frontmatter (Standardfall: `entscheidungen/`, `prozesse/`, `produkte/`, `glossar/`).
  - `sops_secret` — SOPS-verschlüsselte YAML-Dateien, kein Frontmatter-Schema (`secrets/`).
  - `assets` — reiner Ablageort für Dateien, die aus `_attachments.yml` referenziert werden (`example-assets/`).
- **`_template.md`** — Frontmatter-Vorlage für neue `knowledge_entry`-Einträge: `title`, `type`, `created`, `last_reviewed`, `status`, `source`, `related`, `public`. Für Kunden- und Prozessartefakte stehen zusätzlich optionale Felder für Schutzklasse, Dokument-ID, Dokumentstatus und Typst-Quelle bereit.
- **`_attachments.yml`** — zentrale Registry für Verweise auf große Originaldateien (Scans, Exporte, PDFs), die nicht ins Repo eingebettet werden. [`knowledge-lint`](https://github.com/casoon/knowledge-lint) prüft, ob referenzierte Pfade noch existieren.
- **`secrets/`** — SOPS+age-verschlüsselte Dateien, siehe [`GOVERNANCE.md`](GOVERNANCE.md#geheime-daten). Bevorzugtes Muster bleibt aber ein `vault://`-Verweis statt Inline-Secrets, auch verschlüsselt.

### Freelancer-Ablauf und PDF-Ausgaben

Die zusätzlichen Beispielkategorien zeigen einen vollständigen, fiktiven Ablauf: `kunde → projekt → angebot → auftragsbestätigung → kickoff-protokoll → änderung → abnahme → rechnung → service`. Sie enthalten bewusst nur KI-lesbare Zusammenfassungen und stabile Dokument-IDs, keine echten personenbezogenen Daten oder Zahlungsdaten.

Der Wissensstatus (`status: aktuell | veraltet`) und der Geschäftsstatus eines Dokuments (`document_status`, z. B. `sent`, `accepted`, `paid`) sind getrennt: Eine versandte Rechnung kann als Wissenseintrag weiterhin aktuell sein. `typst_source` ist der vorgesehene Anker für ein privates `typstgen`, das PDF-Ausgaben bei Bedarf generiert. Die PDFs selbst gehören nicht in den RAG-Index.

Unter `documents/` liegen dafür acht zusammenhängende Typst-Demos (Angebot, Auftragsbestätigung, Protokoll, Konzept, Abnahme, Rechnung, Betriebsdokumentation und Servicevereinbarung). Templates, Demo-Stammdaten und Übersetzungen sind dort als echte Dateien abgelegt; sie werden über `typstgen compile <quelle> --config typstgen.toml` direkt zu PDFs (`cargo install typstgen`). Details stehen in [`documents/README.md`](documents/README.md).

Der Änderungsantrag im Ablauf hat bewusst keine Typst-Quelle. Er zeigt den Normalfall: Nicht jeder Vorgang braucht ein PDF, oft reicht der Wissenseintrag.

`konzepte/` und `dokumentation/` zeigen den Unterschied zwischen beiden Ebenen am deutlichsten. Die Typst-Quelle ist die ausführliche, kundenfähige Fassung mit Tabellen, Meilensteinen und Prozessbeschreibung; der Wissenseintrag daneben ist die kompakte, maschinenlesbare Zusammenfassung derselben Sache. Ein RAG-System liest den Eintrag, der Kunde bekommt das PDF.

Für einen privaten Klon, der sensible Kunden-, Angebots- oder Rechnungsdaten enthält, ist `classification` (`internal`, `confidential`, `secret`) eine Abrufvorgabe. Sie muss durch die Retrieval- und Berechtigungsschicht erzwungen werden; Frontmatter allein schützt keine Daten.

### `.claude/skills/` — wiederholbare Agenten-Abläufe

Die drei lokalen Skills beschreiben den PDF-Workflow, die Pflege der acht
Locale-Dateien und die Konsistenz zwischen Wissens- und Typst-Dokumenten. Sie
ergänzen die vorhandenen Dateien und Validierer; sie sind keine Quelle für
Kunden- oder Projektdaten.

Sie liegen unter `.claude/skills/`, damit Claude Code sie ohne weitere
Konfiguration findet. `CLAUDE.md` im Wurzelverzeichnis hält daneben die Regeln
fest, die für jede Änderung gelten — etwa dass `public: false` der Standard ist
und PDFs nicht committet werden.

### Validierung und Pflege: [`knowledge-lint`](https://github.com/casoon/knowledge-lint)

Ein eigenständiges Rust-Tool, installiert per `cargo install --git https://github.com/casoon/knowledge-lint --locked` — bewusst nicht Teil dieses Repos, damit es sich für jede Wissensbasis mit derselben `_types.yml`-Konvention nutzen lässt, nicht nur für dieses Template. Ein einzelnes Binary statt Bash-Textparsing, weil Frontmatter mit `grep`/`cut` an Sonderzeichen und verschachtelten Anführungszeichen leise falsch validiert statt laut zu scheitern:

```bash
# prüfen
knowledge-lint lint knowledge

# Beispielinhalte entfernen
knowledge-lint clean knowledge
```

`lint` prüft: Frontmatter-Vollständigkeit, gültige `status`-Werte, `type`-Konsistenz mit der Kategorie, auflösbare `related`-Verweise, überfällige `last_reviewed`-Daten (Schwelle aus `_types.yml`), dass jede Datei in `secrets/` tatsächlich SOPS-verschlüsselt ist, einen Klartext-Secret-Scan über den Rest der Wissensbasis, große Dateien (Warnung, `_attachments.yml` nutzen), und dass jeder Eintrag in `_attachments.yml` noch existiert (lokale Pfade werden geprüft, http(s)-URLs per HEAD-Request, Netzlaufwerk-Schemata übersprungen). Exit-Code 1 bei Fehlern.

Die GitHub Action in `.github/workflows/lint.yml` läuft bei Pull Requests **und** bei direkten Pushes auf den Standardbranch — in einem privaten Repository mit einer Person entstehen die meisten Einträge ohne PR, und ein Lint, der dort nie läuft, ist keiner. `knowledge-lint` ist dort auf einen Commit gepinnt und wird gecacht, damit eine Änderung am Tool nicht gleichzeitig alle abgeleiteten Repositories rot färbt. Zusätzlich prüft `./scripts/check-locales.sh`, dass alle acht Locale-Dateien denselben Schlüsselsatz haben wie `de.json`.

Was `knowledge-lint` bewusst **nicht** prüft: gegen welchen Schlüssel eine Datei unter `secrets/` verschlüsselt ist. Dafür sorgt der Platzhalter in `.sops.yaml` (siehe [`SETUP.md`](SETUP.md)).

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

## Was hier hineingehört

Eine Wissensbasis für KI-Systeme ist das Gedächtnis einer Organisation, nicht ihre Enzyklopädie. Die Aufnahmefrage lautet deshalb nicht "ist das wichtig?", sondern: **kann ein KI-System das zuverlässig aus einer vertrauenswürdigen öffentlichen Quelle beziehen?** Wenn ja, gehört es meistens nicht hinein.

Framework- und Sprachdokumentation zu kopieren ist der häufigste Fehler. Sie veraltet schneller, als sie gepflegt werden kann, verwässert das Retrieval und kostet Aufwand ohne Gegenwert. Deshalb speichert `knowledge/quellen/` **keine Inhalte, sondern Quellen** — welche Referenz für welches Thema in welcher Reihenfolge gilt. Ein Agent weiß damit, wo er nachschlägt, statt sich auf einen veralteten Auszug zu verlassen.

Was hineingehört, sind die vier Bereiche, die kein Modell und keine Suchmaschine kennen kann: **Identität** (`produkte/`, `glossar/`, `kunden/`), **Entscheidungen** (`entscheidungen/`), **Prozesse** (`prozesse/`) und **Kontext** (`projekte/`, `konzepte/`, `protokolle/`, `abrechnung/`, …).

Am wertvollsten sind die Entscheidungen. Nicht "wie funktioniert Astro?", sondern "warum setzen wir hier statisches Rendering ein?" — solche Begründungen gehen sonst verloren und werden immer wieder neu getroffen. Achte auf die Balance: Kontext entsteht von selbst, weil jeder Vorgang Material erzeugt. Identität, Entscheidungen und Prozesse muss jemand aktiv aufschreiben. Eine Basis, die fast nur aus Vorgängen besteht, hat viel Inhalt und wenig Gedächtnis. Details in [`GOVERNANCE.md`](GOVERNANCE.md).

## Warum diese Struktur

Jeder Beispieleintrag demonstriert eine konkrete Praxis, und die Einträge verlinken bewusst aufeinander statt isoliert zu stehen:

- `knowledge/produkte/produkt-x-preismodell.md` und `produkt-x-preismodell-2026.md` zeigen das Nachfolge-Muster: Der veraltete Eintrag wird nicht überschrieben, sondern bleibt mit `status: veraltet` und Verweis auf die aktuelle Fassung stehen.
- `knowledge/entscheidungen/2026-01-tooling-wahl.md` und `2025-09-format-markdown-frontmatter.md` zeigen, wie eine Entscheidung mit Kontext, Begründung und Quelle nachvollziehbar bleibt — auch die Entscheidung für dieses Repo-Format selbst ist als Beispiel dokumentiert. Der Anhang-Verweis darin zeigt das `_attachments.yml`-Muster.
- `knowledge/prozesse/eintrag-review.md` beschreibt den Prozess, der die anderen Beispiele konsistent hält.
- `knowledge/glossar/rag.md`, `chunking.md` und `vektorindex.md` bilden ein kleines verlinktes Glossar, alle drei `public: true` — deshalb erscheinen genau diese drei in `site/`, wenn es gebaut wird.
- `knowledge/quellen/frontend-web.md` zeigt das Gegenteil eines Wissenseintrags: eine Rangfolge von Nachschlagequellen plus die eigene Versionsbindung. Die Bindung an eine Version ist Eigenwissen, der Inhalt der Version nicht.
- `knowledge/secrets/beispiel-credential.yaml` ist echt SOPS-verschlüsselt (nicht simuliert), aber mit einem Demo-Schlüssel, dessen privater Teil nirgends im Repo existiert — für niemanden entschlüsselbar, rein zur Strukturdemonstration.
- `knowledge/prozesse/kunden-onboarding.md` zeigt, wie ein wiederkehrender Ablauf einmal festgehalten wird, statt in jedem Projekt neu erfunden zu werden — und verweist auf die Vorgangs-Kategorien, die er auslöst.
- Die Einträge unter `kunden/`, `projekte/`, `angebote/`, `konzepte/`, `auftragsbestaetigungen/`, `protokolle/`, `aenderungen/`, `abnahmen/`, `abrechnung/`, `dokumentation/` und `service/` bilden einen durchgängigen Freelancer-Vorgang ab. Sie zeigen, wie ein RAG-System Projekt- und Geschäftskontext nutzen kann, ohne auf generierte PDFs angewiesen zu sein.

## Lizenz

Inhalte stehen unter [CC BY 4.0](LICENSE).
