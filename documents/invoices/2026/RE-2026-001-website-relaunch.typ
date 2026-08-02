#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
#let project_data = json("/_data/demo-project.json")
#let invoice = json("/_data/demo-invoice.json")

#show: business_document.with(
  title: "Rechnung Website-Relaunch",
  document_id: "RE-2026-001",
  document_type: "RECHNUNG",
  client: project_data.at("client").at("company"),
  project: project_data.at("project").at("name"),
  status: "Versandt",
  created_at: invoice.at("date"),
  company: company,
  locale: locale,
)

= Rechnungsdaten

#table(
  columns: (42mm, 1fr),
  inset: 4pt,
  stroke: none,
  [Rechnungsnummer], [#invoice.at("id")],
  [Kundennummer], [#invoice.at("customer_number")],
  [Leistungszeitraum], [#invoice.at("performance_period")],
  [Zahlbar bis], [#invoice.at("due_date")],
)

= Abrechnungsbezug

Die Rechnung bezieht sich auf den ersten Projektabschnitt und die
dokumentierte Informationsarchitektur. Die vollständige Schlussrechnung wird
erst nach der Abnahme `ABN-2026-001` erstellt.

= Positionen

#table(
  columns: (1fr, auto, auto, auto),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Leistung*], [*Menge*], [*Einheit*], [*Netto*],
  ..invoice.at("items").map(item => (
    [#item.at("title")],
    [#item.at("quantity")],
    [#item.at("unit")],
    [#item.at("net")],
  )).flatten(),
)

= Summe

#v(0.5em)
#block(width: 100%)[
  #align(right)[Nettosumme: #invoice.at("net_total")]
]
#block(width: 100%)[
  #align(right)[Umsatzsteuer (#invoice.at("vat_rate")): #invoice.at("vat")]
]
#block(width: 100%)[
  #align(right)[*Rechnungsbetrag: #invoice.at("gross_total")*]
]

= Zahlungs- und Rechnungsinformationen

Bitte als Verwendungszweck #invoice.at("payment_reference") angeben. Der
Zahlungseingang wird im privaten RAG als eigener Statuswechsel protokolliert;
die Rechnung selbst wird nach Versand nicht stillschweigend überschrieben.

== Rückfragen und Korrekturen

Rückfragen zu Positionen oder Leistungszeitraum werden mit Rechnungsnummer,
Projektkennung und betroffener Position erfasst. Eine inhaltliche Korrektur
erhält einen eigenen, nachvollziehbaren Beleg statt einer stillen Änderung
dieser Rechnung.

== Hinweis zum Demo-Datensatz

Alle Angaben sind fiktiv und zeigen nur die Datenstruktur. Steuerdaten,
Bankverbindung und Empfängeradresse werden im privaten Klon gepflegt und nur
im berechtigten Finanzkontext abgerufen.
