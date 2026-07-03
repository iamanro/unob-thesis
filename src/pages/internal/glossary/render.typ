#import "../../../styling/vendor/glossarium/glossarium.typ": print-glossary
#import "./registry.typ": acronym-label-prefix, get-used-acronym-entries, get-used-term-entries

#let has-glossary-value(value) = value != none and value != [] and (type(value) != str or value.trim().len() > 0)

#let print-terms-title-bold(entry) = {
  let short = entry.at("short", default: none)
  let long = entry.at("long", default: none)
  let txt = strong.with(delta: 200)

  if has-glossary-value(short) and has-glossary-value(long) {
    txt(short + [ -- ] + long)
  } else if has-glossary-value(long) {
    txt(long)
  } else {
    txt(short)
  }
}

#let generate-acronyms-list(acronyms) = {
  let entries = get-used-acronym-entries(acronyms)
  if entries.len() > 0 {
    let sorted = entries.sorted(key: entry => str(entry.at("short", default: entry.at("key"))).normalize(form: "nfd"))
    grid(
      columns: (auto, 1fr),
      column-gutter: 5mm,
      row-gutter: 5mm,
      ..sorted.map(entry => {
        let short = str(entry.at("short", default: entry.at("key")))
        let key = str(entry.at("key", default: short))
        let long = entry.at("long", default: none)
        let description = entry.at("description", default: none)
        let meaning = if long != none { long } else { description }
        let translation = if long != none { description } else { none }
        let explanation = if meaning == none {
          none
        } else if translation == none {
          [#meaning]
        } else {
          stack(spacing: 5mm, [#meaning], [#translation])
        }
        if explanation == none { () } else { ([#strong(short)#label(acronym-label-prefix + key)], explanation) }
      }).flatten(),
    )
  }
}

#let generate-terms-list(terms) = {
  let entries = get-used-term-entries(terms)
  if entries.len() > 0 {
    print-glossary(
      entries,
      show-all: true,
      minimum-refs: 0,
      disable-back-references: true,
      user-print-group-heading: (..args) => [],
      user-group-break: () => [],
      user-print-title: print-terms-title-bold,
    )
  }
}
