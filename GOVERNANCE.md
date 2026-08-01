# Governance

Kurze, tatsächlich befolgte Regeln statt Bürokratie.

## Wer darf schreiben

[Anpassen: z. B. Teammitglieder mit Domänenwissen zum jeweiligen Bereich. Neue Einträge per Pull Request, Review durch eine zweite Person, bevor sie in `knowledge/` landen.] Die Zuständigkeit pro Ordner lässt sich technisch über [`.github/CODEOWNERS`](.github/CODEOWNERS) erzwingen, statt nur dokumentiert zu sein — dort sind Platzhalter hinterlegt, die durch echte GitHub-Handles ersetzt werden müssen.

## Wer darf lesen

Zugriffsrechte einer KI auf diese Wissensbasis entsprechen den Zugriffsrechten, die ein Mensch in derselben Rolle hätte — nicht mehr. Ein Zugriff, der einer Person nicht zustünde, steht auch keinem KI-System zu, das in ihrem Namen agiert.

## Was hier nicht landet

Personenbezogene Daten, vertrauliche Verträge, interne Bewertungen einzelner Personen. Im Zweifel: nicht aufnehmen, sondern separat und zugriffsbeschränkt verwalten.

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

# Public Key aus der Ausgabe in .sops.yaml eintragen (den Demo-Key ersetzen)

# neue Datei verschlüsseln
sops -e -i knowledge/secrets/neue-datei.yaml

# lokal entschlüsseln (SOPS_AGE_KEY_FILE zeigt auf den privaten Schlüssel)
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
sops -d knowledge/secrets/neue-datei.yaml
```

[`knowledge-lint`](https://github.com/casoon/knowledge-lint) prüft bei jedem Lauf, dass jede Datei unter `secrets/` tatsächlich ein SOPS-`sops:`-Metadatenfeld enthält, und scannt den Rest der Wissensbasis auf offensichtliche Klartext-Schlüsselmuster.

## Prüfintervall

[Anpassen: z. B. Einträge unter `produkte/` und `prozesse/` werden vierteljährlich geprüft. `entscheidungen/` bleibt als Historie unverändert stehen und wird bei Bedarf durch einen neuen Eintrag ergänzt statt überschrieben. `glossar/` wird bei Bedarf aktualisiert.] `knowledge/_types.yml` legt pro Kategorie ein `review_interval_days` fest, gegen das [`knowledge-lint`](https://github.com/casoon/knowledge-lint) prüft — der Wert dort sollte dem hier festgelegten Intervall entsprechen, nicht umgekehrt.

## Fehler melden

Über [Issue-Vorlage "Eintrag melden"](.github/ISSUE_TEMPLATE/eintrag-melden.md) im Repository, oder direkt an die verantwortliche Person aus dem Abschnitt "Wer darf schreiben".
