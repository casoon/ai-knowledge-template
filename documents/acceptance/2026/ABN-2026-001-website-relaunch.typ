#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
#let project_data = json("/_data/demo-project.json")

#show: business_document.with(
  title: "Abnahme Website-Relaunch",
  document_id: "ABN-2026-001",
  document_type: "ABNAHME",
  client: project_data.at("client").at("company"),
  project: project_data.at("project").at("name"),
  status: "Erfolgt",
  created_at: "01.08.2026",
  company: company,
  locale: locale,
)

= Geprüfter Umfang

Abgenommen werden die vereinbarten Seitentypen, der Referenzbereich, die
redaktionelle Übergabe und die dokumentierten Zugänge.

= Prüfprotokoll

#table(
  columns: (1.5fr, 1fr, auto),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Prüfpunkt*], [*Ergebnis*], [*Status*],
  [Startseite erklärt Leistung und nächsten Schritt], [Inhalt und CTA vorhanden], [Erfüllt],
  [Leistungsseiten sind über Navigation erreichbar], [Struktur geprüft], [Erfüllt],
  [Referenzbereich kann im CMS gepflegt werden], [Redaktionsprobe erfolgt], [Erfüllt],
  [Kontaktweg funktioniert auf Mobilgeräten], [Formular und Links geprüft], [Erfüllt],
)

= Übergabe

Die Redaktion erhält die Betriebsdokumentation `CAS-DOC-2026-001`, eine
Einweisung und die Referenz auf die verschlüsselt verwalteten Zugänge. Die
fachliche Verantwortung für neue Inhalte bleibt bei
#project_data.at("project").at("editorial_owner").

= Restpunkte

Offene Nacharbeiten erhalten eine eigene Zuständigkeit und einen Termin. Sie
ändern den Abnahmeumfang nicht stillschweigend. Im Demo bestehen keine
abnahmehindernden Restpunkte.

= Folgevorgänge

Nach der Abnahme folgen Schlussrechnung, Serviceübergang und die erste
regelmäßige Wartungsprüfung.
