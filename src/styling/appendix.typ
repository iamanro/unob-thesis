#import "../pages/internal/i18n/index.typ": t
#import "helpers.typ": centered-page-footer, frontmatter-heading, reset-section-counters, subheading-rule

// Formát číslování stránek a figur v přílohách (A–1, A–2, ...).
#let appendix-num-fmt = "A\u{2013}1"
#let appendix-list-indent = -7mm

#let appendix-heading-number(it) = if it.numbering != none {
  numbering(it.numbering, ..counter(heading).at(it.location()))
} else {
  none
}

#let appendix-page-number(n) = numbering(
  appendix-num-fmt,
  calc.max(counter(heading).get().first(), 1),
  n,
)

// Funkce: render-appendix-list-title
// Účel: Vykreslí seznam příloh jako H1, aby byl v hlavním obsahu i PDF záložkách.
#let render-appendix-list-title(lang: "cs") = {
  frontmatter-heading(t("list_appendices", lang: lang), bookmarked: true, outlined: true)
}

#let has-appendix-headings(lang: "cs") = {
  query(heading.where(level: 1, supplement: t("appendix", lang: lang))).len() > 0
}

// Funkce: apply-appendix-outline-styles
// Účel: Vykreslí seznam příloh bez zapojení přílohových nadpisů do hlavního obsahu.
#let apply-appendix-outline-styles(lang: "cs") = context {
  let appendix_label = t("appendix", lang: lang)
  let entries = query(heading.where(level: 1, supplement: appendix_label))
  for entry in entries {
    let number = appendix-heading-number(entry)
    let title = if number != none { [#appendix_label #number #entry.body] } else { entry.body }

    block(width: 100%)[
      #h(appendix-list-indent)#upper(strong(title))
    ]
  }
}

// Funkce: apply-appendix-content-styles
// Účel: Nastaví číslování, nadpisy, čítače a figurální pravidla pro přílohy.
#let apply-appendix-content-styles(body, lang: "cs") = {
  show heading.where(level: 1): set heading(
    numbering: "A",
    supplement: t("appendix", lang: lang),
    outlined: false,
    bookmarked: true,
  )

  show heading.where(level: 1): it => {
    pagebreak()
    counter(page).update(1)
    block(width: 100%)[
      #set text(size: 14pt, weight: "bold")
      #set par(first-line-indent: 0mm)
      #it.supplement
      #{ appendix-heading-number(it) }
      #upper(it.body)
      #reset-section-counters()
    ]
  }

  set page(
    numbering: appendix-page-number,
    footer: centered-page-footer(),
  )

  counter(page).update(1)
  counter(heading).update(0)
  set heading(numbering: "A.1.1", outlined: false, bookmarked: true)

  set figure(numbering: appendix-page-number)

  for kind in (image, table, math.equation, raw) {
    show figure.where(kind: kind): set figure(outlined: false)
  }

  show heading.where(level: 2): set heading(outlined: false, bookmarked: true)
  show heading.where(level: 3): set heading(outlined: false, bookmarked: true)
  show heading.where(level: 4): set heading(numbering: none, outlined: false, bookmarked: true)
  show heading.where(level: 2): subheading-rule(14pt)
  show heading.where(level: 3): subheading-rule(13pt)
  show heading.where(level: 4): subheading-rule(12pt)

  body
}
