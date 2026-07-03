/// Normalizuje vstup. Pokud není slovník, vrátí prázdný.
#let _ensure-dict(value) = if type(value) == dictionary { value } else { (:) }

#let normalize-outlines(outlines) = {
  let cfg = _ensure-dict(outlines)
  (
    headings: cfg.at("headings", default: true),
    acronyms: cfg.at("acronyms", default: false),
    terms: cfg.at("terms", default: false),
    figures: cfg.at("figures", default: true),
    tables: cfg.at("tables", default: true),
    equations: cfg.at("equations", default: false),
    listings: cfg.at("listings", default: false),
  )
}

#let normalize-theme-config(theme) = {
  let cfg = _ensure-dict(theme)
  (
    color: cfg.at("color", default: false),
    links_colored: cfg.at("links_colored", default: true),
    faculty_colored: cfg.at("faculty_colored", default: true),
    faculty_color: cfg.at("faculty_color", default: none),
    link_color: cfg.at("link_color", default: none),
  )
}

#let metadata-or(label, fallback) = context {
  let items = query(label)
  if items.len() > 0 { items.last().value } else { fallback }
}

#let resolve-frontmatter(acknowledgement, introduction, abstract, keywords) = (
  acknowledgement: metadata-or(<unob-fm-acknowledgement>, acknowledgement),
  introduction: metadata-or(<unob-fm-introduction>, introduction),
  abstract: (
    czech: metadata-or(<unob-fm-abstract-cs>, abstract.czech),
    english: metadata-or(<unob-fm-abstract-en>, abstract.english),
  ),
  keywords: (
    czech: metadata-or(<unob-fm-keywords-cs>, keywords.czech),
    english: metadata-or(<unob-fm-keywords-en>, keywords.english),
  ),
)
