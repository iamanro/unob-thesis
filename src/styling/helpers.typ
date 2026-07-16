/// Vykreslí centrované číslo stránky se zadaným nebo aktuálním číslováním.
#let centered-page-footer(numbering: auto) = context {
  set align(center)
  counter(page).display(if numbering == auto { page.numbering } else { numbering })
}

/// Pravidlo pro podnadpisy (úroveň 2–4): tučný blok dané velikosti a mezery.
#let subheading-rule(size, gap) = it => block(width: 100%)[
  #set text(size: size, weight: "bold")
  #v(gap)
  #it
  #v(gap)
]

/// Vynuluje čítače lokální pro kapitolu/přílohu.
#let reset-section-counters() = {
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(math.equation).update(0)
}

/// Vykreslí nečíslovaný H1 nadpis pro přední části a seznamy.
#let frontmatter-heading(title, bookmarked: true, outlined: true) = {
  heading(numbering: none, bookmarked: bookmarked, outlined: outlined, level: 1)[#title]
}
