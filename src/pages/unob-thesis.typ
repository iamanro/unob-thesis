#import "internal/i18n/index.typ": normalize-thesis-type as i18n-normalize-thesis-type, setup-language
#import "../styling/styles.typ": apply-base-styles, apply-figure-styles, apply-heading-styles
#import "../styling/theme.typ": resolve-theme
#import "appendix.typ": appendix as render-appendix
#import "render.typ": render-draft-layout, render-final-layout
#import "internal/validation.typ": validate-config, validate-submit-check
#import "internal/config.typ": normalize-outlines, normalize-theme-config, resolve-frontmatter
#import "internal/glossary-source.typ": has-entries, resolve-glossary-source
#import "internal/people.typ": person
#import "internal/glossary/index.typ": (
  glossary-show, glossary-to-acronyms, glossary-to-terms,
  init-glossary-runtime, normalize-glossary-input, validate-glossary-registry,
)

// Funkce: unob-thesis
// Účel: Hlavní veřejný vstup šablony s inline konfigurací po vzoru SHAW/ZHAW.
#let unob-thesis(
  body,
  lang: "cs",
  draft: false,
  faculty: "uo",
  programme: [],
  specialisation: [],
  thesis: (
    type: "bachelor",
    title: [Název práce],
  ),
  author: person(name: "Jan", surname: "Novák", sex: "M"),
  supervisor: person(name: "Jana", surname: "Nováková", sex: "F"),
  first_advisor: person(),
  second_advisor: person(),
  assignment_front: none,
  assignment_back: none,
  acknowledgement: false,
  declaration: true,
  ai_used: false,
  acronyms: false,
  terms: false,
  abstract: (
    czech: [],
    english: [],
  ),
  keywords: (
    czech: "",
    english: "",
  ),
  theme: (
    color: false,
    links_colored: true,
    faculty_colored: true,
    faculty_color: none,
    link_color: none,
  ),
  introduction: [],
  outlines: (
    headings: true,
    acronyms: false,
    terms: false,
    figures: true,
    tables: true,
    equations: false,
    listings: false,
  ),
  guide: false,
  docs: false,
  submit_check: false,
  bibliography: none,
  appendix: none,
) = {
  show: setup-language.with(lang: lang)

  // Časná kontrola tvaru `thesis` — čte se dříve než běží `validate-config`,
  // takže bez ní by chybějící klíč skončil nesrozumitelnou chybou Typstu.
  if type(thesis) != dictionary or thesis.at("type", default: none) == none or thesis.at("title", default: none) == none {
    panic(
      "Parametr `thesis` musí být slovník s klíči `type` a `title`, např. "
        + "`thesis: (type: \"master\", title: \"Název práce\")`. / "
        + "`thesis` must be a dictionary with `type` and `title`.",
    )
  }

  let university = (faculty: faculty, programme: programme, specialisation: specialisation)
  let assignment = (front: assignment_front, back: assignment_back)
  let declaration_config = (declaration: declaration, ai_used: ai_used)
  let outline_config = normalize-outlines(outlines)
  let theme_config = normalize-theme-config(theme)

  let normalized_thesis = (
    type: i18n-normalize-thesis-type(thesis.type),
    title: thesis.title,
  )

  // Rozhodnuti o zdroji glosáře: pokud je `true`, načte se výchozí soubor
  let need-default = (acronyms == true) or (terms == true)
  let has-custom-acronyms = (type(acronyms) in (str, raw)) or (type(acronyms) == dictionary and acronyms.len() > 0)
  let has-custom-terms = (type(terms) in (str, raw)) or (type(terms) == dictionary and terms.len() > 0)
  let glossary_source = if need-default {
    resolve-glossary-source(true, "../../../template/glossary.toml")
  } else if has-custom-acronyms {
    resolve-glossary-source(acronyms, false)
  } else if has-custom-terms {
    resolve-glossary-source(terms, false)
  } else {
    false
  }
  let glossary_entries = normalize-glossary-input(glossary_source)
  let want-acronyms = acronyms != false and acronyms != none
  let want-terms = terms != false and terms != none
  let resolved_acronyms = if want-acronyms { glossary-to-acronyms(glossary_entries) } else { false }
  let resolved_terms = if want-terms { glossary-to-terms(glossary_entries) } else { false }

  // Seznamy se zobrazí jen pokud existují položky k zobrazení
  let show-acronyms = has-entries(resolved_acronyms) and outline_config.acronyms
  let show-terms = has-entries(resolved_terms) and outline_config.terms
  let effective-outlines = outline_config + (acronyms: show-acronyms, terms: show-terms)

  let fm = resolve-frontmatter(acknowledgement, introduction, abstract, keywords)
  let effective-theme = resolve-theme(theme_config, university.faculty)

  validate-glossary-registry(resolved_acronyms, resolved_terms)

  validate-config((
    lang: lang,
    draft: draft,
    university: university,
    thesis: thesis,
    author: author,
    supervisor: supervisor,
    first_advisor: first_advisor,
    second_advisor: second_advisor,
    declaration: declaration_config,
    assignment: assignment,
    outlines: effective-outlines,
    acronyms: resolved_acronyms,
    terms: resolved_terms,
    guide: guide,
    docs: docs,
    submit_check: submit_check,
  ))

  validate-submit-check(
    submit_check,
    draft,
    supervisor,
    fm.abstract,
    fm.keywords,
    fm.introduction,
    assignment,
    bibliography,
  )

  show: apply-base-styles.with(
    draft: draft,
    author: author,
    thesis: normalized_thesis,
    abstract: fm.abstract,
    keywords: fm.keywords,
    theme: effective-theme,
  )
  show: apply-heading-styles.with(draft: draft)
  show: apply-figure-styles
  show: glossary-show

  [#metadata(draft) <unob-layout-draft>]
  init-glossary-runtime(resolved_acronyms, terms: resolved_terms)

  if draft {
    render-draft-layout(
      normalized_thesis,
      author,
      fm.abstract,
      fm.keywords,
      body,
      lang: lang,
    )
  } else {
    if docs != false {
      include "internal/docs.typ"
    }

    if guide != false {
      include "internal/guide.typ"
    }

    render-final-layout(
      (
        university: university,
        thesis: normalized_thesis,
        author: author,
        supervisor: supervisor,
        first_advisor: first_advisor,
        second_advisor: second_advisor,
        assignment: assignment,
        declaration: declaration_config,
        acknowledgement: fm.acknowledgement,
        abstract: fm.abstract,
        keywords: fm.keywords,
        outlines: effective-outlines,
        glossary: (acronyms: resolved_acronyms, terms: resolved_terms),
        introduction: fm.introduction,
      ),
      body,
      lang: lang,
    )
  }

  if bibliography != none {
    // Podpora jedné i více bibliografií (Typst 0.15+)
    let bibs = if type(bibliography) == array { bibliography } else { (bibliography,) }
    for bib in bibs {
      bib
    }
  }
  if appendix != none {
    render-appendix(draft: draft, lang: lang)[#appendix]
  }
}
