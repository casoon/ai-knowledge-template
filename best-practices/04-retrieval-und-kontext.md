# Retrieval und Kontext

## Praxis

Eine Wissensbasis nützt nichts, wenn die KI die passenden Teile davon nicht zum richtigen Zeitpunkt in den Kontext bekommt. Das betrifft sowohl die technische Seite (Suche, Chunking, ggf. Vektorindex) als auch die inhaltliche: Ist ein Eintrag so geschrieben, dass er auch isoliert, ohne den Rest der Wissensbasis, verständlich ist?

Ein großes Kontextfenster ersetzt kein gezieltes Retrieval — mehr hineinzukopieren ist nicht dasselbe wie das Richtige hineinzukopieren.

## Woran man es erkennt, wenn es fehlt

- Die KI erhält bei jeder Anfrage entweder viel zu wenig oder unstrukturiert alles auf einmal.
- Relevante Einträge existieren, werden aber nie gefunden, weil Suchbegriffe und Formulierungen im Text nicht zusammenpassen.
- Antworten widersprechen der Wissensbasis, weil die KI stattdessen aus allgemeinem Trainingswissen geraten hat.

## Konkret

- Suchbegriffe und Formulierungen in der Wissensbasis werden an die tatsächlichen Fragen angepasst, nicht nur an die eigene Innensicht.
- Retrieval wird stichprobenartig geprüft: Findet die Suche für typische Fragen die richtigen Einträge?
- Bei Bedarf wird technisches Retrieval (Volltextsuche, Vektorsuche) eingesetzt — aber erst, wenn die inhaltliche Struktur trägt.
