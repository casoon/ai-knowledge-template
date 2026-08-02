#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
#let project_data = json("/_data/demo-project.json")
#let offer = json("/_data/demo-offer.json")

#show: business_document.with(
  title: "Auftragsbestätigung Website-Relaunch",
  document_id: "CAS-AUF-2026-001",
  document_type: "AUFTRAGSBESTAETIGUNG",
  client: project_data.at("client").at("company"),
  project: project_data.at("project").at("name"),
  status: "Bestätigt",
  created_at: "20.07.2026",
  company: company,
  locale: locale,
)

= Bestätigter Auftrag

Dieses Dokument bestätigt die Annahme von #offer.at("id"). Der Auftrag
umfasst Strategie, Informationsarchitektur, Design, technische Umsetzung und
redaktionelle Übergabe für #project_data.at("project").at("name").

= Lieferumfang

#table(
  columns: (1.2fr, 2fr),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Baustein*], [*Lieferergebnis*],
  [Strategie], [Freigegebene Seitenstruktur und Priorisierung],
  [Design], [Startseite und wiederverwendbare Seitentypen],
  [Umsetzung], [Responsive Website mit CMS-Anbindung],
  [Übergabe], [Einweisung und Betriebsdokumentation],
)

= Zusammenarbeit

Der Kunde stellt Inhalte, Bildmaterial und fachliche Freigaben bereit. Die
Projektkommunikation erfolgt über dokumentierte Aufgaben und Protokolle;
Freigaben werden mit Datum und Bezug zum jeweiligen Lieferergebnis festgehalten.

= Termine

Der geplante Launch ist der #project_data.at("project").at("target_launch").
Verschiebt sich eine kundenabhängige Freigabe, wird die Terminwirkung
transparent im Projektprotokoll festgehalten.

= Änderungen

Neue Anforderungen werden nur nach dokumentierter Bewertung von Aufwand,
Termin und Freigabe Teil des Auftrags. Der Referenzbereich wird im Demoablauf
als Änderungsantrag `CR-2026-001` behandelt.
