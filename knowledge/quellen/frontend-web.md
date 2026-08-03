---
title: "Quellenhierarchie: Frontend und Web-Plattform"
type: quelle
created: 2026-08-03
last_reviewed: 2026-08-03
status: aktuell
source: "Festlegung des Teams"
related: ["../entscheidungen/2026-01-tooling-wahl.md"]
public: true
---

## Zweck

Dieser Eintrag speichert **kein** Fachwissen, sondern legt fest, wo Fachwissen
nachgeschlagen wird. Framework-Dokumentation gehört nicht in die Wissensbasis:
Sie veraltet schneller, als sie gepflegt werden kann, und ein veralteter Auszug
im Index ist schlechter als kein Eintrag — er sieht aus wie eine Antwort.

Was hier steht, ist dagegen echtes Eigenwissen: welche Quelle in Konfliktfällen
gewinnt, und auf welcher Version wir tatsächlich sind.

## Reihenfolge

Bei widersprüchlichen Angaben gilt die Quelle weiter oben.

| Thema | Primäre Quelle | Danach |
| --- | --- | --- |
| HTML | [WHATWG HTML Standard](https://html.spec.whatwg.org/) | MDN |
| CSS | [MDN](https://developer.mozilla.org/de/docs/Web/CSS) | W3C-Spezifikation |
| Barrierefreiheit | [WCAG 2.2](https://www.w3.org/TR/WCAG22/) | WAI-ARIA Authoring Practices |
| JavaScript, TypeScript | MDN, TypeScript Handbook | — |
| Framework X | offizielle Dokumentation | GitHub-Issues des Projekts |

Blogartikel, Stack-Overflow-Antworten und KI-Trainingswissen sind keine Quellen
in diesem Sinne. Sie taugen als Hinweis, nicht als Beleg.

## Versionsbindung

Die Bindung an eine Version ist Eigenwissen, der Inhalt der Version nicht.
Deshalb steht hier, worauf wir festgelegt sind — und nur ein Verweis auf das,
was dort dokumentiert ist.

| Werkzeug | Version | Anmerkung |
| --- | --- | --- |
| _(Beispiel)_ Node | 22 LTS | Untergrenze für alle Projekte |

Steigt eine Version, wird diese Tabelle geändert und nicht die
Framework-Dokumentation nachgepflegt.

## Abgrenzung

Sobald ein Eintrag anfängt, Syntax oder API-Verhalten zu beschreiben, gehört er
nicht mehr hierher. Die richtige Reaktion ist dann ein Verweis auf die primäre
Quelle — oder, wenn es um eine bewusste Abweichung vom Standardvorgehen geht,
ein Eintrag unter `entscheidungen/`.
