#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")

#show: business_document.with(
  title: "Auftragsbestaetigung Website-Relaunch",
  document_id: "CAS-AUF-2026-001",
  document_type: "AUFTRAGSBESTAETIGUNG",
  client: "Muster & Partner GmbH (Demo)",
  project: "Website-Relaunch",
  status: "Bestaetigt",
  created_at: "20.07.2026",
  company: company,
  locale: locale,
)

= Bestaetigter Auftrag

Dieses Dokument bestaetigt die Annahme von `CAS-ANG-2026-001`. Der
Leistungsumfang ergibt sich aus dem Angebot und den dort genannten Annahmen.

= Aenderungen

Neue Anforderungen werden nur nach dokumentierter Bewertung von Aufwand,
Termin und Freigabe Teil des Auftrags.
