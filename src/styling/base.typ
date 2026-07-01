#import "packages.typ": apply-vlna, codly, codly-init, codly-languages
#import "helpers.typ": centered-page-footer

/// Nastaví globální sazbu dokumentu (text, stránka, rovnice, odkazy).
#let apply-base-styles(
  body,
  draft: false,
  author: (),
  thesis: (),
  abstract: (),
  keywords: (),
  theme: (),
) = {
  // Určení barvy odkazů: priorita — vlastní > fakultní > černá
  let links_on = theme.at("links_colored", default: false)
  let faculty_on = theme.at("faculty_colored", default: false)
  let link_color = if not links_on {
    rgb("#000000")
  } else if theme.at("link_color", default: none) != none {
    theme.at("link_color")
  } else if faculty_on and theme.at("faculty_color", default: none) != none {
    theme.at("faculty_color")
  } else {
    rgb("#000000")
  }
  show link: set text(fill: link_color)

  show: codly-init.with()
  codly(languages: codly-languages)

  if draft != true {
    show: apply-vlna

    // Pravidlo: Při `draft: false` přidá kompenzaci proti vdovám a sirotkům.
    show par: it => {
      let threshold = 10%
      block(breakable: false, height: threshold)
      v(-threshold, weak: true)
      it
    }
  }

  // Sestavení řetězce klíčových slov z české i anglické varianty
  let keywords-cs = if type(keywords.czech) == str { keywords.czech.trim() } else { "" }
  let keywords-en = if type(keywords.english) == str { keywords.english.trim() } else { "" }
  let combined_keywords = if keywords-cs.len() > 0 and keywords-en.len() > 0 {
    keywords-cs + ", " + keywords-en
  } else if keywords-cs.len() > 0 {
    keywords-cs
  } else {
    keywords-en
  }

  set document(
    author: author.prefix
      + " "
      + author.name
      + " "
      + author.surname
      + " "
      + author.suffix,
    title: thesis.title,
    date: auto,
    description: abstract.czech,
    keywords: combined_keywords,
  )

  set text(
    bottom-edge: "bounds",
    size: 12pt,
    overhang: true,
    font: "TeX Gyre Termes",
    fallback: true,
    hyphenate: true,
    costs: if draft != true {
      (runt: 1000%, hyphenation: 1000%, widow: 1000%, orphan: 1000%)
    } else {
      (runt: 100%, hyphenation: 100%, widow: 100%, orphan: 100%)
    },
  )

  show math.equation: set text(font: "TeX Gyre Termes Math", fallback: true)
  show raw: set text(font: "TeX Gyre Cursor", fallback: true)

  set page(
    margin: if draft != true {
      (inside: 35mm, outside: 25mm, y: 25mm)
    } else {
      (left: 10mm, right: 50mm, top: 10mm, bottom: 10mm)
    },
    header: none,
    // Vlastní patička číslo skutečně vykresluje; `numbering` jen určuje vzor,
    // který si `centered-page-footer()` přečte z `page.numbering`.
    numbering: "1",
    footer: centered-page-footer(),
    paper: "a4",
    binding: auto,
  )

  set par(
    first-line-indent: (amount: 7mm, all: true),
    linebreaks: if draft != true { "optimized" } else { "simple" },
    leading: 1.05em,
    justify: true,
  )

  set enum(indent: 1em)
  set list(indent: 1em)

  set math.equation(numbering: (..nums) => {
    // Před první číslovanou kapitolou je čítač 0 — vynutíme alespoň 1.
    let safe_section = calc.max(counter(heading).get().first(), 1)
    numbering("(1.1)", safe_section, ..nums)
  })

  body
}
