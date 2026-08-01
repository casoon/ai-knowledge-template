#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")

#show: business_document.with(
  title: "Angebot Website-Relaunch",
  document_id: "CAS-ANG-2026-001",
  document_type: "ANGEBOT",
  client: "Muster & Partner GmbH (Demo)",
  project: "Website-Relaunch",
  status: "Angenommen",
  created_at: "16.07.2026",
  company: company,
  locale: locale,
)

= Leistungsumfang

- Strategie und Informationsarchitektur
- Gestaltung der zentralen Seitentypen
- Technische Umsetzung und redaktionelle Einweisung

= Annahmen

Inhalte, Bildmaterial und Freigaben werden durch den Kunden bereitgestellt.
Zusatzanforderungen werden als eigener Aenderungsantrag bewertet.

= Naechster Schritt

Die Auftragsbestaetigung startet die Projektarbeit.
