#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")

#show: business_document.with(
  title: "Rechnung Website-Relaunch",
  document_id: "RE-2026-001",
  document_type: "RECHNUNG",
  client: "Muster & Partner GmbH (Demo)",
  project: "Website-Relaunch",
  status: "Versandt",
  created_at: "01.08.2026",
  company: company,
  locale: locale,
)

= Abrechnungsbezug

Die Rechnung bezieht sich auf die dokumentierte Abnahme `ABN-2026-001`.

= Positionen

#table(
  columns: (1fr, auto),
  inset: 7pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Leistung*], [*Menge*],
  [Konzeption und Umsetzung (Demo)], [1 Pauschale],
  [Redaktionelle Uebergabe (Demo)], [1 Pauschale],
)

= Zahlungsstatus

Die vollstaendigen Rechnungsdaten, das Zahlungsziel und die steuerliche
Behandlung werden im privaten Datenmodell gepflegt. Diese Demo enthaelt keine
echten Finanzdaten.
