// Gemeinsames, bewusst schlankes Layout für die Typst-Demos.
// Alle Daten werden von der jeweiligen Quelle als echte JSON-Dateien geladen.

#let business_document(
  title: none,
  document_id: none,
  document_type: none,
  client: none,
  project: none,
  status: "Entwurf",
  created_at: none,
  company: none,
  locale: none,
  body,
) = {
  set page(
    paper: "a4",
    margin: (left: 22mm, right: 22mm, top: 24mm, bottom: 22mm),
    footer: align(center)[
      #text(size: 8pt, fill: rgb("#5e6472"))[#document_id - #document_type]
    ],
  )

  set text(font: "Libertinus Serif", size: 10.5pt, lang: "de")
  set par(leading: 0.7em)
  set heading(numbering: "1.")

  show heading.where(level: 1): it => {
    v(1.5em)
    text(size: 16pt, weight: "bold", fill: rgb("#c81e43"))[#it.body]
    v(0.45em)
  }

  grid(
    columns: (1fr, 55mm),
    gutter: 12mm,
    [
      #text(size: 14pt, weight: "bold")[#company.at("name")]\
      #text(size: 8.5pt, fill: rgb("#5e6472"))[#company.at("address")]\
      #link("mailto:" + company.at("email"))[#company.at("email")]
    ],
    align(right)[
      #text(size: 9pt, fill: rgb("#5e6472"))[
        #document_type\
        #document_id\
        #locale.at("status"): #status\
        #locale.at("date"): #created_at
      ]
    ],
  )

  v(2em)
  text(size: 24pt, weight: "bold")[#title]
  v(1.5em)

  grid(
    columns: (34mm, 1fr),
    row-gutter: 4pt,
    [*#locale.at("client"):*], [#client],
    [*#locale.at("project"):*], [#project],
  )

  v(2em)
  body
}
