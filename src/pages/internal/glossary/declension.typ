#let apply-word-case-template(template, value) = {
  if type(template) != str or type(value) != str or value.len() == 0 {
    value
  } else if template == upper(template) {
    upper(value)
  } else if template.at(0) == upper(template.at(0)) {
    upper(value.at(0)) + value.slice(1)
  } else {
    value
  }
}

#let decline-czech-first-word(word, grammatical_case: 1, plural_form: false) = {
  if type(word) != str or word.len() == 0 {
    word
  } else {
    let lower_word = lower(word)
    if lower_word.ends-with("a") {
      let stem = lower_word.slice(0, lower_word.len() - 1)
      let palatal = if stem.ends-with("d") or stem.ends-with("t") or stem.ends-with("n") { "ě" } else { "e" }
      // Koncovky pádů 1–7 (pád je zaručeně 1..7, viz normalize-trm-case).
      let ending = if plural_form {
        ("y", "", "ám", "y", "y", "ách", "ami").at(grammatical_case - 1)
      } else {
        ("a", "y", palatal, "u", "o", palatal, "ou").at(grammatical_case - 1)
      }
      apply-word-case-template(word, stem + ending)
    } else if lower_word.ends-with("e") {
      let stem = lower_word.slice(0, lower_word.len() - 1)
      let ending = if plural_form {
        ("e", "i", "ím", "e", "e", "ích", "emi").at(grammatical_case - 1)
      } else {
        ("e", "e", "i", "i", "e", "i", "i").at(grammatical_case - 1)
      }
      apply-word-case-template(word, stem + ending)
    } else {
      word
    }
  }
}

#let decline-czech-phrase(phrase, grammatical_case: 1, plural_form: false) = {
  if type(phrase) != str {
    phrase
  } else {
    let words = phrase.split(" ")
    if words.len() == 0 {
      phrase
    } else {
      let declined = decline-czech-first-word(words.at(0), grammatical_case: grammatical_case, plural_form: plural_form)
      if words.len() == 1 { declined } else { declined + " " + words.slice(1).join(" ") }
    }
  }
}

#let build-acronym-first-display(fields, short_display, grammatical_case: 1, plural_form: false) = {
  let czech = fields.at("cs", default: none)
  let czech_plural = fields.at("csplural", default: none)
  let english = fields.at("en", default: none)
  let english_plural = fields.at("longplural", default: none)

  let czech_form = if czech != none {
    if plural_form and type(czech_plural) == str and grammatical_case == 1 { czech_plural } else { decline-czech-phrase(czech, grammatical_case: grammatical_case, plural_form: plural_form) }
  } else { none }
  let english_form = if english != none {
    // U víceslovných názvů nelze plurál tvořit pouhým "s" — použijte `longplural`.
    if plural_form { if english_plural != none { english_plural } else if type(english) == str and not english.contains(" ") { english + "s" } else { english } } else { english }
  } else { none }

  if czech_form != none and english_form != none { [#czech_form (#english_form - #short_display)] }
  else if czech_form != none { [#czech_form (#short_display)] }
  else if english_form != none { [#english_form (#short_display)] }
  else { [(#short_display)] }
}
