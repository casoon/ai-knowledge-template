# Nach "Use this template"

Checkliste für ein abgeleitetes Repository. Die Punkte unter "Bevor echte Daten
hineinkommen" sind nicht optional — ohne sie verschlüsselt SOPS gegen einen
Demo-Schlüssel, und Demo-Firmendaten stehen in echten Kundendokumenten.

## Bevor echte Daten hineinkommen

- [ ] **Repository auf privat stellen.** "Use this template" erzeugt standardmäßig
      ein öffentliches Repository. Für Kunden-, Angebots- oder Rechnungsdaten muss
      es privat sein, bevor der erste Commit landet.
- [ ] **Eigenen Age-Schlüssel eintragen.** In `.sops.yaml` den Platzhalter
      `PLATZHALTER_EIGENEN_AGE_PUBLIC_KEY_EINTRAGEN` in Regel 2 durch den eigenen
      Public Key ersetzen:

      ```bash
      age-keygen -o ~/.config/sops/age/keys.txt
      ```

      Solange der Platzhalter steht, bricht `sops -e` ab — das ist der Schutz
      davor, ein echtes Secret gegen den unwiederbringlichen Demo-Schlüssel zu
      verschlüsseln. Der private Schlüssel gehört nicht ins Repository.
- [ ] **Demo-Beispiele entfernen.** Zwei Schritte, weil sie verschiedene Bereiche
      betreffen:

      ```bash
      knowledge-lint clean knowledge   # löscht die Beispiel-Einträge in knowledge/
      ./scripts/clean-demo.sh          # Trockenlauf für documents/
      ./scripts/clean-demo.sh --yes    # führt aus
      ```

      `knowledge-lint clean` ist destruktiv und ohne Rückfrage. Nur direkt nach
      der Ableitung ausführen, nie in einer befüllten Wissensbasis.
- [ ] **`documents/_data/company.json` auf die eigene Firma ändern.** Enthält im
      Template "Musterstudio Digital GmbH" und erscheint im Kopf jedes erzeugten
      PDFs.
- [ ] **`LICENSE` ersetzen oder löschen.** Das Template steht unter CC BY 4.0.
      Für ein privates Datenrepository ist das die falsche Aussage — dort gehört
      entweder keine Lizenz hin oder eine eigene.

## Governance und Zuständigkeit

- [ ] **`.github/CODEOWNERS`** — die Platzhalter-Handles (`@dein-team-lead` usw.)
      durch echte GitHub-Handles oder Teams ersetzen. Bei einem Solo-Repository
      ohne Review-Pflicht kann die Datei auch entfallen; dann in `GOVERNANCE.md`
      vermerken, dass die Zuständigkeit nicht technisch erzwungen wird.
- [ ] **`GOVERNANCE.md`** — die beiden `[Anpassen: …]`-Blöcke ("Wer darf
      schreiben", "Prüfintervall") auf die eigene Realität schreiben.
- [ ] **`knowledge/_types.yml`** — eigene Kategorien ergänzen oder nicht benötigte
      entfernen. Die `review_interval_days` sollten dem entsprechen, was in
      `GOVERNANCE.md` steht.
- [ ] **Branch-Schutz**, falls mit mehreren Personen gearbeitet wird. CODEOWNERS
      wirkt nur zusammen mit einer Review-Pflicht auf dem Standardbranch.

## Präsentationsschicht (nur falls `site/` genutzt wird)

- [ ] **`site/astro.config.mjs`** — `title`, `description`, `social`-Link und
      `site` (die spätere Deploy-URL) anpassen. Ohne korrektes `site` erzeugt
      Starlight falsche Canonical- und Sitemap-URLs.
- [ ] **`site/package.json`** — `name` anpassen.
- [ ] Prüfen, welche Einträge `public: true` tragen. Standard ist `public: false`;
      veröffentlicht wird nur, was aktiv freigegeben wurde.
- [ ] Wenn `site/` nicht gebraucht wird: Verzeichnis löschen und die
      entsprechenden Zeilen aus `.gitignore` entfernen.

## Werkzeuge installieren

```bash
cargo install --git https://github.com/casoon/knowledge-lint --locked
cargo install typstgen   # nur nötig, wenn PDFs erzeugt werden sollen
```

## Nicht vergessen

- [ ] `README.md` auf das eigene Repository umschreiben. Der Text hier beschreibt
      das Template, nicht die daraus entstandene Wissensbasis.
- [ ] Diese Datei (`SETUP.md`) am Ende löschen — sie gilt nur für die Ableitung.

## Warum die Demo-Einträge irgendwann rot werden

`knowledge-lint` meldet Einträge, deren `last_reviewed` älter ist als das
`review_interval_days` ihrer Kategorie. Die mitgelieferten Beispiele sind auf den
Stand ihrer Erstellung datiert und laufen deshalb nach einigen Wochen bis Monaten
in genau diese Warnung. Das ist der Mechanismus, um den es geht — und es ist ein
weiterer Grund, die Beispiele nach der Ableitung zu entfernen statt sie
mitzuschleppen.
