#import "./validate.typ": panic-local

// Jednosegmentové hlavičky tabulek (`[iso]`) obalí do uvozovek (`["iso"]`), aby
// TOML parser přijal i klíče se znaky, které by jako holý klíč neprošly, a chyba
// se pak nahlásila srozumitelně až ve validaci. Hlavičky s tečkou se ponechají,
// aby zůstaly platnými dotted-key tabulkami.
#let normalize-toml-table-headers(text) = {
  text
    .split("\n")
    .map(line => {
      let trimmed = line.trim()
      if trimmed.starts-with("[") and trimmed.ends-with("]") {
        let header = trimmed.slice(1, trimmed.len() - 1).trim()
        if not header.contains(".") {
          "[\"" + header + "\"]"
        } else {
          line
        }
      } else {
        line
      }
    })
    .join("\n")
}

// Šestice polí společných pro zkratky (short/en/cs/plural/longplural/csplural).
#let _acronym-fields(key, value) = (
  short: str(value.at("short", default: key)),
  en: value.at("en", default: none),
  cs: value.at("cs", default: none),
  plural: value.at("plural", default: none),
  longplural: value.at("longplural", default: none),
  csplural: value.at("csplural", default: none),
)

#let _entry(key, value) = {
  if type(value) != dictionary {
    panic-local(
      "Položka glosáře `" + key + "` musí být TOML tabulka.",
      "Glossary entry `" + key + "` must be a TOML table.",
    )
  }

  (key: key, .._acronym-fields(key, value), glossary: value.at("glossary", default: none))
}

#let normalize-glossary-dictionary(document) = {
  if document.at("acronyms", default: none) != none or document.at("terms", default: none) != none or document.at("entries", default: none) != none {
    panic-local(
      "Glosář používá jednotný formát: jedna TOML tabulka na položku (`[iso]`, `[llm]`, ...).",
      "Glossary uses the unified format: one TOML table per entry (`[iso]`, `[llm]`, ...).",
    )
  }

  let result = (:)
  for (raw_key, value) in document {
    let key = str(raw_key)
    result.insert(key, _entry(key, value))
  }
  if result.len() == 0 { false } else { result }
}

#let normalize-glossary-input(input) = {
  if input == false or input == none {
    false
  } else if type(input) == dictionary {
    normalize-glossary-dictionary(input)
  } else if type(input) == raw {
    normalize-glossary-dictionary(toml(bytes(normalize-toml-table-headers(input.text))))
  } else if type(input) == str {
    normalize-glossary-dictionary(toml(bytes(normalize-toml-table-headers(input))))
  } else {
    panic-local(
      "Nepodporovaný formát glosáře.",
      "Unsupported glossary format.",
    )
  }
}

#let _entries-to-dict(entries, transform) = {
  if type(entries) != dictionary { return false }
  let result = (:)
  for (key, entry) in entries {
    let value = transform(str(key), entry)
    if value != none { result.insert(str(key), value) }
  }
  if result.len() == 0 { false } else { result }
}

// Zkratka = položka BEZ klíče `glossary` a s jednoslovnou zkratkou.
// Položka s klíčem `glossary` je pojem (viz `glossary-to-terms`) — aby se
// nezobrazovala v obou seznamech zároveň. Zkratka bez rozvinutého tvaru
// (jen `short`) je přípustná.
#let glossary-to-acronyms(entries) = _entries-to-dict(entries, (key, entry) => {
  let short = str(entry.at("short", default: key))
  if entry.at("glossary", default: none) == none and not short.contains(" ") {
    _acronym-fields(key, entry)
  }
})

#let glossary-to-terms(entries) = _entries-to-dict(entries, (key, entry) => {
  let glossary = entry.at("glossary", default: none)
  if glossary != none {
    (
      short: str(entry.at("short", default: key)),
      long: none,
      description: glossary,
      plural: entry.at("plural", default: none),
      longplural: entry.at("longplural", default: none),
    )
  }
})

#let acronym-fields-from-value(key, value) = if type(value) == dictionary {
  _acronym-fields(key, value)
} else {
  (short: str(key), en: none, cs: none, plural: none, longplural: none, csplural: none)
}
