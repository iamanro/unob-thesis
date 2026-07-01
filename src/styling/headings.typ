#import "helpers.typ": reset-section-counters, subheading-rule

/// Nastaví číslování, vzhled a zalamování nadpisů.
#let apply-heading-styles(body, draft: false) = {
  set page(footer: none)
  set heading(numbering: "1.1.1", supplement: [heading], depth: 3)

  show heading.where(level: 1): it => {
    if draft != true {
      pagebreak()
    }

    reset-section-counters()

    block(width: 100%)[
      #set text(size: 14pt, weight: "bold")
      #set par(first-line-indent: 0mm)
      #upper(it)
      #v(1em)
    ]
  }

  // Úrovně 2–4 se liší jen velikostí textu (viz subheading-rule).
  show heading.where(level: 2): subheading-rule(14pt)
  show heading.where(level: 3): subheading-rule(13pt)
  show heading.where(level: 4): subheading-rule(12pt)
  show heading.where(level: 4): set heading(numbering: none)

  body
}
