#import "./registry.typ": acronym-label-prefix, term-label-prefix, get-acronym-entries, get-term-entries

#let has-glossary-value(value) = value != none and value != [] and (type(value) != str or value.trim().len() > 0)

#let generate-acronyms-list(acronyms) = {
  let entries = get-acronym-entries(acronyms)
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
        // Menší řádkování uvnitř jednoho záznamu (mezera mezi originálem a
        // překladem) a `breakable: false`, aby se originál a překlad nikdy
        // nerozdělily přes zlom strany — celý záznam zůstane pohromadě.
        let explanation = if meaning == none {
          none
        } else {
          block(breakable: false, {
            set par(leading: 0.5em)
            if translation == none {
              meaning
            } else {
              stack(spacing: 2mm, meaning, translation)
            }
          })
        }
        if explanation == none { () } else { ([#strong(short)#label(acronym-label-prefix + key)], explanation) }
      }).flatten(),
    )
  }
}

// Vlastní sazba SEZNAMU POJMŮ. Pořadí je dané `get-term-entries` (české řazení
// dle zobrazeného názvu, viz registry). Každý záznam nese návěští pro
// prolinkování z textu a je `breakable: false`, aby se nedělil přes zlom strany.
#let generate-terms-list(terms) = {
  let entries = get-term-entries(terms)
  if entries.len() > 0 {
    for entry in entries {
      let short = str(entry.at("short", default: entry.at("key")))
      let key = str(entry.at("key", default: short))
      let description = entry.at("description", default: none)
      block(breakable: false, below: 5mm, {
        set par(leading: 0.5em, first-line-indent: 0pt)
        [#strong(short)#label(term-label-prefix + key): #description]
      })
    }
  }
}
