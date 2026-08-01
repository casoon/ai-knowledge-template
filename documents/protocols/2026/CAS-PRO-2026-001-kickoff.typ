#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")

#show: business_document.with(
  title: "Kickoff-Protokoll Website-Relaunch",
  document_id: "CAS-PRO-2026-001",
  document_type: "PROTOKOLL",
  client: "Muster & Partner GmbH (Demo)",
  project: "Website-Relaunch",
  status: "Abgestimmt",
  created_at: "22.07.2026",
  company: company,
  locale: locale,
)

= Entscheidungen

- Die Startseite erklaert Leistung, Zielgruppe und naechsten Schritt sofort.
- Der Kunde liefert Referenzen und Bildmaterial zum vereinbarten Termin.
- Der erste Entwurf behandelt Startseite und eine Leistungsseite.

= Offener Punkt

Ein zusaetzlicher Referenzbereich wird als `CR-2026-001` bewertet.
