#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
#let project_data = json("/_data/demo-project.json")

#show: business_document.with(
  title: "Kickoff-Protokoll Website-Relaunch",
  document_id: "CAS-PRO-2026-001",
  document_type: "PROTOKOLL",
  client: project_data.at("client").at("company"),
  project: project_data.at("project").at("name"),
  status: "Abgestimmt",
  created_at: "22.07.2026",
  company: company,
  locale: locale,
)

= Teilnehmende und Ziel

Teilgenommen haben #project_data.at("client").at("contact") für den Kunden
und die Projektleitung von Musterstudio Digital GmbH. Ziel des Kickoffs war,
Arbeitsweise, Inhalte, Freigaben und die erste Lieferphase verbindlich zu
klären.

= Entscheidungen

#for decision in project_data.at("decisions") [
  - #decision
]

= Aufgaben bis zur ersten Freigabe

#table(
  columns: (1.3fr, 1fr, auto),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Aufgabe*], [*Verantwortlich*], [*Termin*],
  [Referenzen und Bildmaterial bereitstellen], [Kunde], [27.07.2026],
  [Seitenstruktur vorlegen], [Projektleitung], [31.07.2026],
  [Seitenstruktur prüfen und freigeben], [Kunde], [05.08.2026],
)

= Risiken und offene Punkte

Bildrechte und die Vollständigkeit der Referenzdaten sind vor der
Veröffentlichung zu prüfen. Ein zusätzlicher Referenzbereich wird als
`CR-2026-001` bewertet und nicht stillschweigend in den Auftrag übernommen.

= Nächster Termin

Die Designbesprechung findet nach Freigabe der Informationsarchitektur statt.
Der Termin wird erst festgelegt, wenn alle benötigten Inhalte vorliegen.
