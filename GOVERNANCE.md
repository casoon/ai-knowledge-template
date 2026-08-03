# Governance

Kurze, tatsächlich befolgte Regeln statt Bürokratie.

## Wer darf schreiben

[Anpassen: z. B. Teammitglieder mit Domänenwissen zum jeweiligen Bereich. Neue Einträge per Pull Request, Review durch eine zweite Person, bevor sie in `knowledge/` landen.]

Die Vorlage unterscheidet vier Zuständigkeitsbereiche, weil sie unterschiedlich sensibel sind:

- **Allgemeines Wissen** (`entscheidungen/`, `prozesse/`, `produkte/`, `glossar/`) — breiter Schreibzugriff, Review durch eine zweite Person.
- **Kunden- und Projektvorgänge** (`kunden/`, `projekte/`, `konzepte/`, `dokumentation/`, `protokolle/`, `aenderungen/`) — nur Personen mit Mandat im jeweiligen Projekt.
- **Vertrags- und Finanzvorgänge** (`angebote/`, `auftragsbestaetigungen/`, `abnahmen/`, `abrechnung/`, `service/`) — nur Personen mit kaufmännischer Verantwortung.
- **Geheimdaten** (`secrets/`, `.sops.yaml`) — engster Kreis; wer `.sops.yaml` ändern kann, bestimmt, wer künftige Secrets lesen kann.

Die Zuständigkeit pro Ordner lässt sich technisch über [`.github/CODEOWNERS`](.github/CODEOWNERS) erzwingen, statt nur dokumentiert zu sein — dort sind Platzhalter für alle vier Bereiche hinterlegt, die durch echte GitHub-Handles ersetzt werden müssen. CODEOWNERS wirkt allerdings nur zusammen mit einer Review-Pflicht auf dem Standardbranch; ohne Branch-Schutz bleibt es eine Dokumentation.

## Wer darf lesen

Zugriffsrechte einer KI auf diese Wissensbasis entsprechen den Zugriffsrechten, die ein Mensch in derselben Rolle hätte — nicht mehr. Ein Zugriff, der einer Person nicht zustünde, steht auch keinem KI-System zu, das in ihrem Namen agiert.

## Was hier hineingehört

Eine Wissensbasis für KI-Systeme ist das Gedächtnis einer Organisation, nicht ihre Enzyklopädie. Die Aufnahmefrage lautet deshalb nicht "ist das wichtig?", sondern:

> **Kann ein KI-System diese Information zuverlässig aus einer vertrauenswürdigen öffentlichen Quelle beziehen?**

Ja → gehört meistens nicht hinein. Nein → gehört wahrscheinlich hinein.

Eine schärfere Fassung derselben Frage: Könnte jemand, der die Organisation morgen verlässt, diesen Inhalt aus öffentlichen Quellen rekonstruieren? Wenn ja, kostet der Eintrag Pflege, ohne etwas beizutragen.

Vier Bereiche machen den Kern aus, und die Kategorien in `_types.yml` ordnen sich ihnen zu:

| Bereich | Frage | Kategorien |
| --- | --- | --- |
| Identität | Wer sind wir, für wen arbeiten wir? | `produkte/`, `glossar/`, `kunden/` |
| Entscheidungen | Warum machen wir es so und nicht anders? | `entscheidungen/` |
| Prozesse | Wie arbeiten wir? | `prozesse/` |
| Kontext | Was ist in einem Vorgang passiert? | `projekte/`, `konzepte/`, `protokolle/`, `angebote/`, `abrechnung/`, … |

**Entscheidungen sind der wertvollste Teil.** Ein gutes System beantwortet nicht "wie funktioniert Astro?", sondern "warum setzen wir in diesem Projekt statisches Rendering ein?". Solche Begründungen gehen sonst verloren und werden immer wieder neu getroffen oder neu erklärt. Sie stehen in keiner Dokumentation der Welt.

Achte dabei auf die Balance. Kontext entsteht von selbst — jeder Vorgang erzeugt Material. Identität, Entscheidungen und Prozesse muss jemand aktiv aufschreiben. Eine Basis, die fast nur aus Vorgängen besteht, hat viel Inhalt und wenig Gedächtnis.

## Was hier nicht landet

Alles, was sich ständig ändert und anderswo besser gepflegt wird: Sprach- und Framework-Dokumentation, HTML- und CSS-Referenzen, Git-Handbücher, Linux-Befehle. Solche Kopien veralten schnell, verwässern das Retrieval und erzeugen Pflegeaufwand ohne Gegenwert.

Statt Inhalte zu kopieren, hält `quellen/` fest, **welche Quelle für welches Thema in welcher Reihenfolge gilt**. Damit weiß ein Agent, wo er nachschlägt, statt sich auf einen veralteten Auszug im Index zu verlassen.

Eine Ausnahme ist erwähnenswert, weil sie oft übersehen wird: Die *Bindung* an eine Version ist eigenes Wissen, der Inhalt der Version nicht. "Wir sind auf Astro 6" gehört hinein — die dortige API-Referenz nicht, sondern nur als Verweis.

Außerdem nicht hierher: personenbezogene Daten, vertrauliche Verträge, interne Bewertungen einzelner Personen. Im Zweifel nicht aufnehmen, sondern separat und zugriffsbeschränkt verwalten.

## Geschäftlich und privat

Jeder Eintrag trägt `sphere: geschaeftlich | privat`. In Kategorien, in denen beides vorkommt — hier `konzepte/` und `dokumentation/` — entspricht dem zusätzlich ein Unterordner:

```
knowledge/konzepte/geschaeftlich/CAS-KON-2026-001-website-relaunch.md
knowledge/konzepte/privat/2026-08-heimnetz-neuaufbau.md
```

Doppelt, weil beides gebraucht wird: Das Feld erlaubt einer Retrieval-Schicht das Filtern ohne Pfad-Parsing und gilt auch in den flachen Kategorien; der Pfad macht die Trennung beim Durchsehen sichtbar und erlaubt ein grobes `**/privat/**`-Muster.

Der Grund ist praktisch, nicht formal. Wer eine Wissensbasis über Jahre führt, sammelt darin früher oder später auch Privates — Bauvorhaben, Gesundheitsrecherchen, Familienthemen. Ohne Trennung liegt das im selben Index wie die Kundenarbeit: Eine Frage zum Kundenprojekt zieht es in den Kontext, und ein an einen Kunden gerichteter Auszug kann es enthalten.

Private Einträge sind nie `public: true` und verweisen nicht auf Kundeneinträge. Wer ausschließlich betrieblich arbeitet, lässt `sphere` auf `geschaeftlich` stehen und die `privat/`-Ordner leer — der Aufwand ist ein Frontmatter-Feld, der Nutzen zeigt sich beim ersten privaten Eintrag.

## Wie ein Eintrag altert

Entscheidungen sammeln sich nicht an, sie werden abgelöst. Ein überholter Eintrag wird nicht überschrieben, sondern bekommt `status: veraltet` und einen `related`-Verweis auf seinen Nachfolger. Das erhält die Frage "warum haben wir das damals anders entschieden?" — oft die eigentlich interessante.

## Sensible Daten im privaten Klon

Die öffentliche Vorlage enthält nur fiktive Daten. Ein privater Klon kann Kunden-, Angebots- und Rechnungsdaten enthalten, wenn die verantwortliche Person das bewusst erlaubt. Jeder solcher Eintrag erhält eine `classification`:

- `internal` — für interne Arbeit ohne besondere Freigabe.
- `confidential` — nur für Rollen mit Kunden- oder Finanzbezug.
- `secret` — Zugangsdaten und vergleichbare Geheimnisse; nur für den konkreten, notwendigen Vorgang abrufbar.

Die Berechtigung muss vor dem Retrieval geprüft werden. Verschlüsselung schützt gespeicherte Daten, ersetzt aber keine Zugriffskontrolle: Kann ein Agent einen Secret-Eintrag entschlüsseln und abrufen, kann er seinen Inhalt auch in einer Antwort ausgeben. Daher nur die minimal erforderlichen Einträge in den Kontext laden und Zugriffe protokollieren.

## Geheime Daten

Bevorzugtes Muster: **gar nicht speichern, nur referenzieren.** Ein Passwort oder API-Key gehört in einen echten Passwort-Manager/Vault, ein Wissenseintrag verweist nur darauf, z. B. `Zugang: vault://kunde-x/webserver`. Das ist robuster als jede Verschlüsselung im Repo, weil Key-Rotation, Zugriffsprotokolle und Widerruf dort bereits gelöst sind.

Wenn strukturierte Geheimdaten trotzdem versioniert werden müssen (z. B. eine Konfiguration mit eingebetteten Werten), ist `knowledge/secrets/` mit [SOPS](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age) der Fallback — verschlüsselt nur die Werte, Struktur und Keys bleiben lesbar und diffbar:

```bash
# einmalig: eigenes Schlüsselpaar erzeugen, NIE ins Repo committen
age-keygen -o ~/.config/sops/age/keys.txt

# Public Key aus der Ausgabe in .sops.yaml eintragen und dort den Platzhalter
# in der zweiten creation_rule ersetzen. Solange er steht, bricht `sops -e`
# ab — Absicht, damit kein echtes Secret gegen den Demo-Key verschlüsselt wird.

# neue Datei verschlüsseln
sops -e -i knowledge/secrets/neue-datei.yaml

# lokal entschlüsseln (SOPS_AGE_KEY_FILE zeigt auf den privaten Schlüssel)
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
sops -d knowledge/secrets/neue-datei.yaml
```

[`knowledge-lint`](https://github.com/casoon/knowledge-lint) prüft bei jedem Lauf, dass jede Datei unter `secrets/` tatsächlich ein SOPS-`sops:`-Metadatenfeld enthält, und scannt den Rest der Wissensbasis auf offensichtliche Klartext-Schlüsselmuster.

## Prüfintervall

[Anpassen: z. B. Einträge unter `produkte/` und `prozesse/` werden vierteljährlich geprüft. `entscheidungen/` bleibt als Historie unverändert stehen und wird bei Bedarf durch einen neuen Eintrag ergänzt statt überschrieben. `glossar/` wird bei Bedarf aktualisiert.]

Für die Vorgangs-Kategorien richtet sich das Intervall nach der Halbwertszeit der Information, nicht nach ihrer Wichtigkeit:

- **Laufende Vorgänge** (`projekte/`, `angebote/`) ändern sich wöchentlich — kurzes Intervall, sonst steht schnell etwas Falsches im Kontext.
- **Aktive Beziehungen** (`kunden/`, `protokolle/`, `aenderungen/`, `service/`) werden vierteljährlich geprüft.
- **Abgeschlossene Vorgänge** (`auftragsbestaetigungen/`, `abnahmen/`, `abrechnung/`) sind Historie und werden jährlich nur noch auf Auffindbarkeit geprüft, nicht inhaltlich fortgeschrieben.
- **Projektartefakte** (`konzepte/`, `dokumentation/`) gelten für die Dauer des Projekts und werden halbjährlich gegen den tatsächlichen Stand geprüft — veraltete Betriebsdokumentation ist gefährlicher als gar keine.

`knowledge/_types.yml` legt pro Kategorie ein `review_interval_days` fest, gegen das [`knowledge-lint`](https://github.com/casoon/knowledge-lint) prüft — der Wert dort sollte dem hier festgelegten Intervall entsprechen, nicht umgekehrt.

## Fehler melden

Über [Issue-Vorlage "Eintrag melden"](.github/ISSUE_TEMPLATE/eintrag-melden.md) im Repository, oder direkt an die verantwortliche Person aus dem Abschnitt "Wer darf schreiben".
