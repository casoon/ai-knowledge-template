#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")

#show: business_document.with(
  title: "Servicevereinbarung Website-Wartung",
  document_id: "SRV-2026-001",
  document_type: "SERVICE",
  client: "Muster & Partner GmbH (Demo)",
  project: "Website-Relaunch",
  status: "Aktiv",
  created_at: "01.08.2026",
  company: company,
  locale: locale,
)

= Leistungsrahmen

Der Service umfasst regelmaessige Updates, technische Pruefungen und ein
kurzes Statusprotokoll.

= Abgrenzung

Neue Funktionen, umfangreiche Inhalte und Strukturänderungen sind neue
Anforderungen und werden getrennt beauftragt.

= Zugangsdaten

Zugaenge werden nicht in diesem Dokument gespeichert. Es verweist im privaten
Klon ausschliesslich auf verschluesselte Secret-Eintraege oder Vault-Referenzen.
