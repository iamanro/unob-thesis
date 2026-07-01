#import "../internal/i18n/index.typ": t

// Funkce: render-assignment-page
// Účel: Vykreslí jednu stranu zadání nebo lokalizovaný placeholder.
#let render-assignment-page(content, lang: "cs") = {
  set par(first-line-indent: 0mm)
  if content == none {
    place(center + horizon)[
      #text(style: "italic")[#t("assignment_placement", lang: lang)]
    ]
  } else {
    content
  }
}

// Funkce: render-assignment
// Účel: Za titulní stranu vloží rub titulního listu a oboustranné zadání.
#let render-assignment(assignment, lang: "cs") = {
  // První pagebreak vytvoří rub titulní strany, druhý přejde na líc zadání.
  pagebreak()
  pagebreak()
  render-assignment-page(assignment.front, lang: lang)
  pagebreak()
  render-assignment-page(assignment.back, lang: lang)
}
