#import "/templates/business.typ": business_document

#let company = json("/_data/company.json")
#let locale = json("/_data/locales/de.json")
#let project_data = json("/_data/demo-project.json")

#show: business_document.with(
  title: "Redaktions- und Betriebsdokumentation",
  document_id: "CAS-DOC-2026-001",
  document_type: "DOKUMENTATION",
  client: project_data.at("client").at("company"),
  project: project_data.at("project").at("name"),
  status: "Final",
  created_at: "01.08.2026",
  company: company,
  locale: locale,
)

= Zweck und Geltung

Dieses Dokument beschreibt die redaktionelle Pflege und den technischen
Betrieb der neuen Website. Es richtet sich an die für Inhalte verantwortliche
Person beim Kunden sowie an die technische Betreuung. Zugangsdaten selbst
stehen nicht hier, sondern in verschlüsselten Secret-Einträgen oder im Vault.

= Systemüberblick

#table(
  columns: (1fr, 1.8fr),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Bereich*], [*Verantwortung*],
  [Inhalte und Freigaben], [#project_data.at("project").at("editorial_owner")],
  [Technische Wartung], [#project_data.at("project").at("technical_owner")],
  [Projektkennung], [#project_data.at("project").at("id")],
  [Starttermin], [#project_data.at("project").at("start")],
)

= Inhalte pflegen

Eine Leistungsseite besteht aus einem klaren Titel, einer kurzen Einordnung,
dem konkreten Nutzen, nachvollziehbaren Details und einem Kontaktweg. Neue
Inhalte sollten erst fachlich geprüft und dann als Entwurf im CMS angelegt
werden. Nach der Vorschau auf Desktop und Mobilgerät kann die Redaktion die
Seite freigeben.

== Referenzen

Jede Referenz beantwortet drei Fragen: Was war die Ausgangslage? Was wurde
umgesetzt? Welches Ergebnis oder welche Verbesserung ist sichtbar? Personen,
Logos und Bilder dürfen nur mit geklärter Freigabe veröffentlicht werden.

== Kontaktwege

Nach jeder Änderung an Kontaktformular, E-Mail-Adresse oder Telefonnummer ist
ein echter Test durchzuführen. Der Test umfasst Versand, Zustellung,
Bestätigung und die Darstellung auf einem Mobilgerät.

= Regelmäßige Betriebsaufgaben

#table(
  columns: (1.1fr, auto, 1.7fr),
  inset: 6pt,
  stroke: 0.5pt + rgb("#cbd5e1"),
  [*Aufgabe*], [*Rhythmus*], [*Nachweis*],
  [Sicherheits- und Systemupdates prüfen], [monatlich], [Status im Serviceprotokoll],
  [Kontaktweg und zentrale Formulare testen], [monatlich], [Testdatum und Ergebnis],
  [Inhalte und Referenzen durchsehen], [quartalsweise], [Freigabe oder Korrekturauftrag],
  [Backup- und Wiederherstellungsweg prüfen], [halbjährlich], [Dokumentierter Test],
)

= Releaseprozess

1. Änderung als Entwurf anlegen und fachlich prüfen.
2. Darstellung auf Desktop und Mobilgerät kontrollieren.
3. Betroffene Links, Formulare und strukturierte Daten testen.
4. Veröffentlichung mit Datum, Verantwortlichkeit und kurzem Changelog notieren.
5. Bei Fehlern zurückrollen oder einen klaren Korrekturauftrag erfassen.

= Support und Eskalation

Bei einem Ausfall zuerst Auswirkung, Zeitpunkt, betroffene URL und beobachtetes
Verhalten festhalten. Kritische Fälle werden unmittelbar an die technische
Betreuung gegeben. Inhaltswünsche und neue Funktionen sind keine Störung; sie
werden als Anforderung mit Ziel und Priorität dokumentiert.

= Verknüpfte Dokumente

Die Abnahme `ABN-2026-001` bestätigt den vereinbarten Lieferumfang. Der
laufende Betrieb wird über `SRV-2026-001` überprüft. Rechnungs- und
Zugangsdaten bleiben in ihren jeweils zugriffsbeschränkten RAG-Kontexten.
