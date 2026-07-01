#import "../../../styling/vendor/glossarium/glossarium.typ": make-glossary, gls, glspl
#import "../../../styling/vendor/glossarium/themes/default.typ": is-first as is_first_ref
#import "./validate.typ": panic-local
#import "./parse.typ": acronym-fields-from-value
#import "./registry.typ": acronyms-registry, registry-definitions, terms-registry
#import "./lookup.typ": find-key-or-short-case-insensitive, link-to-acronym-entry, panic-unknown-key, resolve-known-key
#import "./declension.typ": build-acronym-first-display

#let glossary-show = make-glossary
#let is-first = is_first_ref

#let singular = "singular"
#let plural = "plural"
#let first = "first"
#let first-plural = "first_plural"

#let normalize-trm-style(style) = {
  // Konstanty mají stejnou hodnotu jako svůj řetězec (singular == "singular" …),
  // takže stačí porovnat s konstantou; navíc povolíme aliasy "default" a kebab tvar.
  if style == none or style == singular or style == "default" {
    singular
  } else if style == plural {
    plural
  } else if style == first {
    first
  } else if style == first-plural or style == "first-plural" {
    first-plural
  } else {
    panic-local(
      "Neznámý styl `" + str(style) + "`. Použijte `singular`, `plural`, `first` nebo `first_plural`.",
      "Unknown style `" + str(style) + "`. Use `singular`, `plural`, `first`, or `first_plural`.",
    )
  }
}

#let normalize-trm-case(case) = {
  if type(case) == int and case >= 1 and case <= 7 {
    case
  } else {
    panic-local(
      "Neznámý pád `" + str(case) + "`. Použijte číslo 1 až 7.",
      "Unknown case `" + str(case) + "`. Use numbers 1 to 7.",
    )
  }
}

#let acronym(short, force-first: false, grammatical_case: 1) = context {
  let definitions = registry-definitions(acronyms-registry)
  let key = resolve-known-key("zkratka", "acronym", short, definitions, unknown_cs: "Neznámá", unknown_en: "Unknown")
  let fields = acronym-fields-from-value(key, definitions.at(key))
  let short_form = str(fields.at("short", default: key))
  let display = build-acronym-first-display(fields, short_form, grammatical_case: grammatical_case)
  let rendered = if force-first or is-first(key) { gls(key, display: display, link: false) } else { gls(key, first: false, link: false) }
  link-to-acronym-entry(key, rendered)
}

#let acronym-plural(short, force-first: false, grammatical_case: 1) = context {
  let definitions = registry-definitions(acronyms-registry)
  let key = resolve-known-key("zkratka", "acronym", short, definitions, unknown_cs: "Neznámá", unknown_en: "Unknown")
  let fields = acronym-fields-from-value(key, definitions.at(key))
  let short_form = str(fields.at("short", default: key))
  // `plural` je v záznamu vždy přítomné (často `none`) — `.at(default:)` proto
  // nestačí, je nutné ošetřit `none` explicitně.
  let plural_field = fields.at("plural", default: none)
  let short_plural = if plural_field == none { short_form } else { str(plural_field) }
  let display = build-acronym-first-display(fields, short_plural, grammatical_case: grammatical_case, plural_form: true)
  let rendered = if force-first or is-first(key) { glspl(key, display: display, link: false) } else { glspl(key, first: false, link: false) }
  link-to-acronym-entry(key, rendered)
}

#let term(key, force-first: false) = context {
  let definitions = registry-definitions(terms-registry)
  let term_key = resolve-known-key("pojem", "term", key, definitions)
  if force-first { gls(term_key, first: true, link: false) } else { gls(term_key, link: false) }
}

#let term-plural(key, force-first: false) = context {
  let definitions = registry-definitions(terms-registry)
  let term_key = resolve-known-key("pojem", "term", key, definitions)
  if force-first { glspl(term_key, first: true, link: false) } else { glspl(term_key, link: false) }
}

#let trm(key, style: singular, case: 1, force: none) = context {
  let requested_key = str(key)
  let resolved_style = normalize-trm-style(style)
  let resolved_case = normalize-trm-case(case)
  let force_first = force == true or force == first or force == "first"
  let effective_style = if force_first {
    if resolved_style == plural or resolved_style == first-plural { first-plural } else { first }
  } else { resolved_style }

  let acronyms = registry-definitions(acronyms-registry)
  let terms = registry-definitions(terms-registry)
  let acronym_key = find-key-or-short-case-insensitive(requested_key, acronyms)
  let term_key = find-key-or-short-case-insensitive(requested_key, terms)

  if acronym_key != none {
    if effective_style == plural { acronym-plural(acronym_key, grammatical_case: resolved_case) }
    else if effective_style == first { acronym(acronym_key, force-first: true, grammatical_case: resolved_case) }
    else if effective_style == first-plural { acronym-plural(acronym_key, force-first: true, grammatical_case: resolved_case) }
    else { acronym(acronym_key, grammatical_case: resolved_case) }
  } else if term_key != none {
    if effective_style == plural { term-plural(term_key) }
    else if effective_style == first { term(term_key, force-first: true) }
    else if effective_style == first-plural { term-plural(term_key, force-first: true) }
    else { term(term_key) }
  } else {
    let merged = (:)
    for (candidate, value) in acronyms { merged.insert(str(candidate), value) }
    for (candidate, value) in terms {
      if merged.at(str(candidate), default: none) == none { merged.insert(str(candidate), value) }
    }
    panic-unknown-key("pojem nebo zkratka", "term or acronym", requested_key, merged)
  }
}
