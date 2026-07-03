#import "../styling/styles.typ": centered-page-footer
#import "cover.typ": render-cover
#import "draft.typ": render-draft-abstracts, render-draft-header
#import "frontmatter.typ": (
  render-abstracts, render-acknowledgement, render-assignment, render-declaration, render-introduction,
)
#import "lists.typ": render-lists

#let render-draft-layout(thesis, author, abstract, keywords, body, lang: "cs") = {
  set page(numbering: "1", footer: centered-page-footer())
  render-draft-header(thesis, author, lang: lang)
  render-draft-abstracts(abstract, keywords)
  body
}

#let render-final-layout(config, body, lang: "cs") = {
  let (
    university, thesis, author, supervisor, first_advisor, second_advisor, assignment,
    declaration, acknowledgement, abstract, keywords, outlines, glossary, introduction,
  ) = config

  render-cover(
    (
      university: university,
      thesis: thesis,
      author: author,
      supervisor: supervisor,
      first_advisor: first_advisor,
      second_advisor: second_advisor,
    ),
    lang: lang,
  )

  render-assignment(assignment, lang: lang)
  render-acknowledgement(acknowledgement, lang: lang)
  render-declaration(
    (
      declaration: declaration,
      author: author,
      supervisor: supervisor,
      university: university,
      thesis: thesis,
    ),
    lang: lang,
  )
  render-abstracts(abstract, keywords)
  // Zapne patičku s číslováním a vynuluje čítač stránek tak, aby první
  // číslovaná strana (OBSAH) měla číslo 1. Aktualizace čítače musí proběhnout
  // až po zalomení vyvolaném `set page`, tedy už na nové straně.
  set page(footer: centered-page-footer(numbering: "1"))
  counter(page).update(1)
  render-lists(outlines, glossary, lang: lang)
  render-introduction(introduction, lang: lang)
  body
}
