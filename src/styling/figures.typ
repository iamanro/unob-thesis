/// Nastaví vzhled popisků a číslování obrázků, tabulek a rovnic.
#let apply-figure-styles(body) = {
  set figure(numbering: n => numbering(
    "1.1 ",
    // Před první číslovanou kapitolou je čítač 0 — vynutíme alespoň 1.
    calc.max(counter(heading).get().first(), 1),
    n,
  ))

  set figure.caption(separator: " ")
  for kind in (table, raw, math.equation) {
    show figure.where(kind: kind): set figure.caption(position: top, separator: [])
  }

  set table(stroke: 0.7pt)
  set table.hline(stroke: .5pt)
  show table.cell.where(y: 0): strong
  show table: set text(size: 10pt, hyphenate: true)
  show table: set par(justify: true)

  show figure.caption: it => [
    #v(1em)
    #it.supplement #it.counter.display(it.numbering)~#it.body
    #v(1em)
  ]

  let figure_spacing = 1em
  show figure: it => {
    let content = block(
      width: 100%,
      breakable: true,
      spacing: 1.2em,
      inset: (y: figure_spacing),
      align(center, it),
    )
    if it.placement == none {
      content
    } else {
      place(it.placement, float: true, content)
    }
  }

  show math.equation.where(block: true): it => {
    v(.5em)
    it
    v(.5em)
  }

  body
}
