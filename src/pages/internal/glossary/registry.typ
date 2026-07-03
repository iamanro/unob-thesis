#import "../../../styling/vendor/glossarium/glossarium.typ": register-glossary, count-refs as count_refs
#import "./parse.typ": acronym-fields-from-value

#let acronyms-group = "__acronyms"
#let terms-group = "__terms"
#let acronym-label-prefix = "__unob_acronym_list_"

#let acronyms-registry = state("unob-acronyms-registry", (:))
#let terms-registry = state("unob-terms-registry", (:))

#let registry-definitions(registry) = {
  let raw = registry.get()
  if type(raw) == dictionary { raw } else { (:) }
}

#let acronyms-to-glossary-entries(acronyms_dict) = {
  if type(acronyms_dict) != dictionary {
    ()
  } else {
    acronyms_dict
      .pairs()
      .sorted(key: ((key, value)) => str(value.at("short", default: str(key))).normalize(form: "nfd"))
      .map(((raw_key, value)) => {
        let key = str(raw_key)
        let fields = acronym-fields-from-value(key, value)
        let short = str(fields.at("short", default: key))
        let plural_raw = fields.at("plural", default: none)
        (
          key: key,
          short: short,
          long: fields.at("en", default: none),
          description: fields.at("cs", default: none),
          plural: if plural_raw != none { plural_raw } else { short },
          longplural: fields.at("longplural", default: none),
          group: acronyms-group,
        )
      })
  }
}

#let terms-to-glossary-entries(terms_dict) = {
  if type(terms_dict) != dictionary {
    ()
  } else {
    terms_dict
      .pairs()
      .sorted(key: ((key, _)) => str(key).normalize(form: "nfd"))
      .map(((key, value)) => (
        key: str(key),
        short: value.at("short", default: str(key)),
        long: value.at("long", default: none),
        description: value.at("description", default: none),
        plural: value.at("plural", default: none),
        longplural: value.at("longplural", default: none),
        group: terms-group,
      ))
  }
}

#let filter-entries-by-usage(entries) = entries.filter(entry => count_refs(str(entry.at("key", default: ""))) > 0)
#let get-used-acronym-entries(acronyms) = filter-entries-by-usage(acronyms-to-glossary-entries(acronyms))
#let get-used-term-entries(terms) = filter-entries-by-usage(terms-to-glossary-entries(terms))
#let has-used-acronyms(acronyms) = get-used-acronym-entries(acronyms).len() > 0
#let has-used-terms(terms) = get-used-term-entries(terms).len() > 0

#let merge-registry-entries(acronym_entries, term_entries) = {
  let merged = (:)
  for entry in term_entries { merged.insert(str(entry.at("key")), entry) }
  for entry in acronym_entries {
    let key = str(entry.at("key"))
    let existing = merged.at(key, default: none)
    if existing == none {
      merged.insert(key, entry)
    } else {
      merged.insert(key, (
        key: key,
        short: existing.at("short", default: entry.at("short", default: key)),
        long: existing.at("long", default: entry.at("long", default: none)),
        description: existing.at("description", default: entry.at("description", default: none)),
        plural: existing.at("plural", default: entry.at("plural", default: none)),
        longplural: existing.at("longplural", default: entry.at("longplural", default: none)),
        group: existing.at("group", default: entry.at("group", default: "")),
      ))
    }
  }
  merged.values()
}

#let init-glossary-runtime(acronyms, terms: false) = {
  let safe_acronyms = if type(acronyms) == dictionary { acronyms } else { (:) }
  let safe_terms = if type(terms) == dictionary { terms } else { (:) }
  let acronym_entries = acronyms-to-glossary-entries(safe_acronyms)
  let term_entries = terms-to-glossary-entries(safe_terms)
  let all_entries = merge-registry-entries(acronym_entries, term_entries)

  acronyms-registry.update(safe_acronyms)
  terms-registry.update(safe_terms)

  if all_entries.len() > 0 { register-glossary(all_entries) }
}
