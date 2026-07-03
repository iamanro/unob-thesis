#import "utils.typ": has-value, has-person
#import "i18n/index.typ": t, is-supported-faculty, is-supported-language, is-supported-thesis-type

// Funkce: panic-i18n
// Účel: Vyvolá chybu na základě i18n klíče.
#let panic-i18n(key) = context {
  panic(t(key))
}

#let valid-sex(value) = value == none or value == "M" or value == "F"

#let validate-person-sex(person) = {
  if has-person(person) and not valid-sex(person.at("sex", default: none)) {
    panic-i18n("error_person_sex")
  }
}

#let validate-assignment-page(value) = {
  if value != none and type(value) != content {
    panic-i18n("error_assignment_content")
  }
}

// Funkce: validate-config
// Účel: Ověří vstupní konfiguraci šablony a při chybě vyvolá `panic`.
// Přijímá jeden slovník `config` (pojmenované klíče místo pořadí argumentů).
#let validate-config(config) = {
  let (
    lang, draft, university, thesis, author, supervisor, first_advisor, second_advisor,
    declaration, assignment, outlines, acronyms, terms, guide, docs, submit_check,
  ) = config

  if not is-supported-language(lang) {
    panic-i18n("error_unsupported_language")
  }

  if type(draft) != bool {
    panic-i18n("error_draft_bool")
  }

  if not is-supported-faculty(university.faculty) {
    panic-i18n("error_unsupported_faculty")
  }

  if not is-supported-thesis-type(thesis.type) {
    panic-i18n("error_unsupported_thesis_type")
  }

  if not has-value(thesis.title) {
    panic-i18n("error_title_required")
  }

  if not has-person(author) {
    panic-i18n("error_author_required")
  }

  validate-person-sex(author)
  validate-person-sex(supervisor)
  validate-person-sex(first_advisor)
  validate-person-sex(second_advisor)

  if declaration.declaration != false and not has-person(supervisor) {
    panic-i18n("error_supervisor_required_for_declaration")
  }

  if outlines.acronyms != false and type(acronyms) != dictionary {
    panic-i18n("error_outlines_acronyms_requires_dictionary")
  }

  if outlines.terms != false and type(terms) != dictionary {
    panic-i18n("error_outlines_terms_requires_dictionary")
  }

  if type(guide) != bool or type(docs) != bool {
    panic-i18n("error_guide_docs_bool")
  }

  if type(declaration.declaration) != bool or type(declaration.ai_used) != bool {
    panic-i18n("error_declaration_bool")
  }

  validate-assignment-page(assignment.front)
  validate-assignment-page(assignment.back)

  if type(submit_check) != bool {
    panic-i18n("error_submit_check_bool")
  }
}

// Funkce: validate-submit-check
// Účel: V přísném režimu ověří minimální náležitosti před odevzdáním.
#let validate-submit-check(
  submit_check,
  draft,
  supervisor,
  abstract,
  keywords,
  introduction,
  assignment,
  bibliography,
) = {
  if submit_check != true {
    return
  }

  let require_value(value, error_key) = {
    if not has-value(value) {
      panic-i18n(error_key)
    }
  }

  if draft == true {
    panic-i18n("error_submit_check_draft_disabled")
  }

  if not has-person(supervisor) {
    panic-i18n("error_submit_check_supervisor_required")
  }

  require_value(abstract.czech, "error_submit_check_abstract_cs_required")
  require_value(abstract.english, "error_submit_check_abstract_en_required")
  require_value(keywords.czech, "error_submit_check_keywords_cs_required")
  require_value(keywords.english, "error_submit_check_keywords_en_required")
  require_value(introduction, "error_submit_check_introduction_required")
  require_value(bibliography, "error_submit_check_bibliography_required")

  if assignment.front == none or assignment.back == none {
    panic-i18n("error_submit_check_assignment_required")
  }
}
