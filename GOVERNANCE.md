# Governance

Kurze, tatsächlich befolgte Regeln statt Bürokratie.

## Wer darf schreiben

[Anpassen: z. B. Teammitglieder mit Domänenwissen zum jeweiligen Bereich. Neue Einträge per Pull Request, Review durch eine zweite Person, bevor sie in `knowledge/` landen.] Die Zuständigkeit pro Ordner lässt sich technisch über [`.github/CODEOWNERS`](.github/CODEOWNERS) erzwingen, statt nur dokumentiert zu sein — dort sind Platzhalter hinterlegt, die durch echte GitHub-Handles ersetzt werden müssen.

## Wer darf lesen

Zugriffsrechte einer KI auf diese Wissensbasis entsprechen den Zugriffsrechten, die ein Mensch in derselben Rolle hätte — nicht mehr. Ein Zugriff, der einer Person nicht zustünde, steht auch keinem KI-System zu, das in ihrem Namen agiert.

## Was hier nicht landet

Personenbezogene Daten, vertrauliche Verträge, interne Bewertungen einzelner Personen. Im Zweifel: nicht aufnehmen, sondern separat und zugriffsbeschränkt verwalten.

## Prüfintervall

[Anpassen: z. B. Einträge unter `produkte/` und `prozesse/` werden vierteljährlich geprüft. `entscheidungen/` bleibt als Historie unverändert stehen und wird bei Bedarf durch einen neuen Eintrag ergänzt statt überschrieben. `glossar/` wird bei Bedarf aktualisiert.] `scripts/lint.sh` markiert `aktuell`-Einträge automatisch, deren `last_reviewed` das eingestellte Intervall überschreitet — der Standardwert im Skript sollte auf das hier festgelegte Intervall angepasst werden, nicht umgekehrt.

## Fehler melden

Über [Issue-Vorlage "Eintrag melden"](.github/ISSUE_TEMPLATE/eintrag-melden.md) im Repository, oder direkt an die verantwortliche Person aus dem Abschnitt "Wer darf schreiben".
