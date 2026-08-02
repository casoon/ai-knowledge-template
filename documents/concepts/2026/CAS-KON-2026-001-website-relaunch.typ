#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
#let project_data = json("/_data/demo-project.json")

#show: business_document.with(
  title: "Konzept Website-Relaunch",
  document_id: "CAS-KON-2026-001",
  document_type: "KONZEPT",
  client: project_data.at("client").at("company"),
  project: project_data.at("project").at("name"),
  status: "Freigegeben für Umsetzung",
  created_at: "31.07.2026",
  company: company,
  locale: locale,
)

= Zusammenfassung

Die neue Website soll die Leistung von Muster & Partner schneller erklären,
Vertrauen aufbauen und qualifizierte Anfragen erleichtern. Das Konzept
übersetzt dieses Ziel in eine klare Seitenstruktur, wiederverwendbare Inhalte
und einen nachvollziehbaren Freigabeprozess.

= Ausgangslage

Die bisherige Website mischt Zielgruppen, Leistungen und Referenzen auf wenigen
Seiten. Interessierte erkennen weder den konkreten Nutzen noch den passenden
nächsten Schritt. Redaktionelle Aktualisierungen hängen außerdem an
einzelnen Personen statt an einer einfachen, dokumentierten Struktur.

= Ziele und Erfolgskriterien

#table(
  columns: (1.2fr, 1.8fr),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Ziel*], [*Messbares Ergebnis*],
  [Verständlichkeit], [Besucher erkennen Leistung und Zielgruppe auf der Startseite.],
  [Anfragen], [Jede zentrale Leistungsseite bietet einen klaren Kontaktweg.],
  [Vertrauen], [Referenzen beschreiben Ausgangslage, Leistung und Ergebnis.],
  [Pflege], [Die Redaktion kann Inhalte ohne technische Hilfe aktualisieren.],
)

= Zielgruppen und Kernbotschaft

Die primäre Zielgruppe sind Entscheider kleiner und mittlerer Unternehmen,
die eine verlässliche Umsetzung suchen und den Nutzen für ihren Betrieb
schnell verstehen wollen. Sekundär angesprochen werden Bestandskunden mit
Erweiterungs- oder Wartungsbedarf.

Die Kernbotschaft lautet: Muster & Partner verbindet fachliche Beratung mit
praktischer Umsetzung und bleibt auch nach dem Projekt erreichbar.

= Informationsarchitektur

#table(
  columns: (1fr, 1.8fr, 1fr),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Bereich*], [*Aufgabe*], [*Nächster Schritt*],
  [Startseite], [Positionierung, Kernleistungen und Vertrauen], [Beratung anfragen],
  [Leistungen], [Je Leistung Problem, Vorgehen und Ergebnis], [Passende Leistung ansehen],
  [Referenzen], [Belegbare Beispiele mit Kontext], [Ähnliches Projekt besprechen],
  [Über uns], [Arbeitsweise und Ansprechpartner], [Kontakt aufnehmen],
  [Kontakt], [Niedrige Hürde für Anfrage], [Formular oder Rückruf],
)

= Inhaltliche Prinzipien

- Jede Seite beantwortet zuerst: Für wen ist das, welches Problem wird gelöst und was ist der nächste Schritt?
- Aussagen werden mit konkreten Beispielen, Ergebnissen oder Prozessdetails belegt.
- Fachbegriffe werden dort erklärt, wo sie für eine Entscheidung relevant sind.
- Bilder ergänzen die Aussage und erhalten beschreibende Alternativtexte.

= Gestaltung und Komponenten

Das Design verwendet eine ruhige Grundfläche, eine Akzentfarbe für
Handlungsaufforderungen und wiederkehrende Komponenten für Leistungsblöcke,
Referenzen, Hinweise und Kontaktwege. Dadurch bleibt die Website konsistent,
auch wenn später neue Seiten hinzukommen.

= Umsetzungs- und Freigabeprozess

#table(
  columns: (1.1fr, auto, 1.6fr),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Phase*], [*Termin*], [*Freigabe*],
  ..project_data.at("milestones").map(milestone => (
    [#milestone.at("name")],
    [#milestone.at("date")],
    [#milestone.at("result")],
  )).flatten(),
)

Freigaben beziehen sich immer auf einen konkreten Stand. Neue Anforderungen
werden als Änderungsantrag beschrieben, bevor sie Design, Budget oder Termin
beeinflussen.

= Risiken und Annahmen

Der Termin hängt von vollständigen Inhalten, geklärten Bildrechten und
zeitnahen Freigaben ab. Fehlen diese Voraussetzungen, wird zuerst die Wirkung
auf den Launch bewertet und anschließend ein realistischer Folgetermin
vereinbart.

= Nächste Schritte

Nach Freigabe dieses Konzepts entstehen Informationsarchitektur und
Startseitenentwurf. Die Umsetzung folgt erst, wenn Struktur, Inhalte und
Verantwortlichkeiten nachvollziehbar entschieden sind.
