#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")

#show: business_document.with(
  title: "Abnahme Website-Relaunch",
  document_id: "ABN-2026-001",
  document_type: "ABNAHME",
  client: "Muster & Partner GmbH (Demo)",
  project: "Website-Relaunch",
  status: "Erfolgt",
  created_at: "01.08.2026",
  company: company,
  locale: locale,
)

= Gepruefter Umfang

Abgenommen werden die vereinbarten Seitentypen, der Referenzbereich, die
redaktionelle Uebergabe und die dokumentierten Zugaenge.

= Restpunkte

Offene Nacharbeiten erhalten eine eigene Zuständigkeit und einen Termin. Sie
aendern den Abnahmeumfang nicht stillschweigend.
