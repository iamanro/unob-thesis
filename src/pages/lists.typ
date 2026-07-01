#import "internal/i18n/index.typ": t
#import "../styling/styles.typ": frontmatter-heading
#import "internal/glossary/index.typ": (
  generate-acronyms-list, generate-terms-list, has-used-acronyms, has-used-terms,
)

/// Vykreslí obsah a volitelné seznamy (zkratky, pojmy, obrázky, tabulky, rovnice, výpisy).
#let render-lists(
  outlines,
  glossary,
  lang: "cs",
) = {
  // Patička s číslováním je zapnutá ve volajícím (render-final-layout).

  if outlines.headings != false {
    show outline.entry.where(level: 1): it => {
      set text(size: 14pt, weight: "bold")
      upper(it)
    }
    show outline.entry.where(level: 2): it => {
      set text(size: 13pt)
      it
    }
    show outline.entry.where(level: 3): it => {
      set text(size: 12pt, style: "italic")
      it
    }

    outline(
      target: heading.where(supplement: [heading], outlined: true),
      indent: 1em,
      depth: 3,
      title: t("toc", lang: lang),
    )
  }

  // Zkratky a pojmy — vykreslí se jen pokud byly v textu použity
  context if outlines.acronyms != false and has-used-acronyms(glossary.acronyms) {
    frontmatter-heading(t("list_acronyms", lang: lang))
    generate-acronyms-list(glossary.acronyms)
  }

  context if outlines.terms != false and has-used-terms(glossary.terms) {
    frontmatter-heading(t("list_terms", lang: lang))
    generate-terms-list(glossary.terms)
  }

  // Zbývající seznamy se vykreslí jen při reálných položkách v dokumentu.
  let sections = (
    ("figures",   "list_figures",   figure.where(kind: image, outlined: true), false),
    ("tables",    "list_tables",    figure.where(kind: table, outlined: true), true),
    ("equations", "list_equations", math.equation,                         true),
    ("listings",  "list_listings",  figure.where(kind: raw, outlined: true),   true),
  )
  for (key, label, target, bookmarked) in sections {
    context if outlines.at(key) != false and query(target).len() > 0 {
      frontmatter-heading(t(label, lang: lang), bookmarked: bookmarked)
      outline(title: none, target: target)
    }
  }
}
