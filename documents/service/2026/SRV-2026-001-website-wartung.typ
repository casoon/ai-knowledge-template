#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
#let project_data = json("/_data/demo-project.json")

#show: business_document.with(
  title: "Servicevereinbarung Website-Wartung",
  document_id: "SRV-2026-001",
  document_type: "SERVICE",
  client: project_data.at("client").at("company"),
  project: project_data.at("project").at("name"),
  status: "Aktiv",
  created_at: "01.08.2026",
  company: company,
  locale: locale,
)

= Leistungsrahmen

Der Service umfasst regelmäßige Updates, technische Prüfungen und ein
kurzes Statusprotokoll. Er beginnt nach erfolgreicher Abnahme und wird
vierteljährlich auf Umfang und Risiken geprüft.

#table(
  columns: (1.4fr, 1.7fr, auto),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Bereich*], [*Leistung*], [*Rhythmus*],
  [Technik], [Sicherheitsupdates und Funktionsprüfung], [monatlich],
  [Monitoring], [Prüfung wichtiger Formulare und Erreichbarkeit], [monatlich],
  [Redaktion], [Hinweise zu auffälligen Inhalten oder Fehlern], [quartalsweise],
  [Bericht], [Kompaktes Protokoll mit offenen Punkten], [quartalsweise],
)

= Reaktionswege

Kritische Ausfälle werden nach Eingang priorisiert bearbeitet. Normale
Änderungswünsche werden gesammelt, bewertet und als separater Auftrag oder
Änderungsantrag eingeplant.

= Abgrenzung

Neue Funktionen, umfangreiche Inhalte und Strukturänderungen sind neue
Anforderungen und werden getrennt beauftragt. Die fachliche Pflege der Inhalte
liegt bei #project_data.at("project").at("editorial_owner").

= Zugangsdaten und Dokumentation

Zugänge werden nicht in diesem Dokument gespeichert. Es verweist im privaten
Klon ausschließlich auf verschlüsselte Secret-Einträge oder Vault-Referenzen.
Die technische Übergabe ist in `CAS-DOC-2026-001` dokumentiert.
