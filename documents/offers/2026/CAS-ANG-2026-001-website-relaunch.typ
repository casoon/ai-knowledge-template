#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
#let project_data = json("/_data/demo-project.json")
#let offer = json("/_data/demo-offer.json")

#show: business_document.with(
  title: "Angebot Website-Relaunch",
  document_id: "CAS-ANG-2026-001",
  document_type: "ANGEBOT",
  client: project_data.at("client").at("company"),
  project: project_data.at("project").at("name"),
  status: "Angenommen",
  created_at: offer.at("date"),
  company: company,
  locale: locale,
)

= Ausgangslage und Ziel

Die bestehende Website erklärt die Leistungen nur allgemein und führt
Interessierte nicht klar zu einer Anfrage. Das Projekt soll
#project_data.at("project").at("goal")

= Leistungsbausteine

#table(
  columns: (1.3fr, 2fr, auto, auto),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Leistung*], [*Ergebnis*], [*Menge*], [*Netto*],
  ..offer.at("items").map(item => (
    [#item.at("title")],
    [#item.at("description")],
    [#item.at("quantity")],
    [#item.at("amount")],
  )).flatten(),
)

= Vorgehen und Meilensteine

#table(
  columns: (1.1fr, auto, 1.5fr),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Phase*], [*Termin*], [*Ergebnis*],
  ..project_data.at("milestones").map(milestone => (
    [#milestone.at("name")],
    [#milestone.at("date")],
    [#milestone.at("result")],
  )).flatten(),
)

= Investition

#align(right)[
  #table(
    columns: (auto, auto),
    inset: 5pt,
    stroke: none,
    [Nettosumme], [#offer.at("net_total")],
    [Umsatzsteuer], [#offer.at("vat")],
    [*Gesamtsumme*], [*#offer.at("gross_total")*],
  )
]

= Voraussetzungen und Abgrenzung

Inhalte, Bildmaterial und fachliche Freigaben werden durch den Kunden
bereitgestellt. Neue Seitentypen, zusätzliche Funktionen oder Anforderungen,
die nicht im Leistungsbaustein stehen, werden als Änderungsantrag bewertet.

= Konditionen und nächster Schritt

Dieses Angebot ist bis zum #offer.at("valid_until") gültig.
#offer.at("payment_terms") Mit der schriftlichen Auftragsbestätigung
startet die Projektarbeit.
