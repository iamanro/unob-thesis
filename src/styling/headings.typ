#import "helpers.typ": reset-section-counters, subheading-rule
#import "../config.typ": cfg

/// Nastaví číslování, vzhled a zalamování nadpisů.
#let apply-heading-styles(body, draft: false) = {
  set page(footer: none)
  set heading(numbering: "1.1.1", supplement: [heading], depth: 3)

  show heading.where(level: 1): it => {
    if draft != true {
      // Kapitola vždy začíná na lichém (pravém) listu — kvůli oboustrannému tisku.
      // Případný vložený vakát (dorovnání parity) je bez patičky, aby na prázdné
      // straně nebylo číslo stránky.
      {
        set page(footer: none)
        pagebreak(to: "odd")
      }
    }

    reset-section-counters()

    block(width: 100%)[
      #set text(size: cfg.heading.h1, weight: "bold")
      #set par(first-line-indent: 0mm)
      #upper(it)
      #v(cfg.heading.h1-gap)
    ]
  }

  // Úrovně 2–4 se liší jen velikostí textu (viz subheading-rule).
  show heading.where(level: 2): subheading-rule(cfg.heading.h2, cfg.heading.sub-gap)
  show heading.where(level: 3): subheading-rule(cfg.heading.h3, cfg.heading.sub-gap)
  show heading.where(level: 4): subheading-rule(cfg.heading.h4, cfg.heading.sub-gap)
  show heading.where(level: 4): set heading(numbering: none)
  show heading.where(level: 5): set heading(numbering: none)


  body
}
