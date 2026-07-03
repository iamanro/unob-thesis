#import "../styling/packages.typ": ez-today
#import "internal/i18n/index.typ": t, thesis-type-is-bachelor-or-master, thesis-type-is-doctoral
#import "internal/utils.typ": has-person, has-value
#import "internal/people.typ": format-name
#import "internal/localization.typ": get-city-name, get-faculty-name, get-thesis-type-name
#import "../styling/theme.typ": get-logo-path

/// Vizuální parametry titulní strany.
/// Pro ruční změnu vzhledu upravuj primárně tuto strukturu.
#let cover-vars = (
  page_height: 240mm,
  logo_height: 6.71cm,

  size_university: 16pt,
  size_faculty: 14pt,
  size_programme: 14pt,
  size_specialisation: 14pt,
  size_thesis_type: 24pt,
  size_title: 16pt,
  size_people: 14pt,
  size_city_year: 16pt,

  weight_faculty: "bold",
  weight_programme: "bold",
  weight_specialisation: "regular",
  weight_thesis_type: "bold",
  weight_title: "bold",

  header_row_1_height: 16pt,
  header_row_2_height: 14pt,
  header_row_3_height: 14pt,
  header_row_4_height: 14pt,
  people_row_height: 1.5em,

  gap_after_header: 24pt,
  gap_after_logo: 24pt,
  gap_after_thesis_type: 24pt,
  gap_after_title: 24pt,

  paragraph_leading: 1.5em,
)

/// Vykreslí jeden řádek s pevnou výškou.
#let cover-row(content, size: 14pt, weight: "regular", height: 14pt) = block(
  width: 100%,
  height: height,
  clip: false,
)[
  #align(center + horizon)[
    #set text(size: size, weight: weight)
    #content
  ]
]

/// Vykreslí řádek v bloku osob se stejnou výškou i při prázdném obsahu.
#let cover-people-row(content, vars) = block(
  width: 100%,
  height: vars.people_row_height,
  clip: false,
)[
  #set text(size: vars.size_people)
  #content
]

/// Vykreslí titulní stranu práce podle konfigurace školy, práce a osob.
#let render-cover(
  config,
  lang: "cs",
  vars: cover-vars,
) = {
  let university = config.university
  let thesis = config.thesis
  let author = config.author
  let supervisor = config.supervisor
  let first_advisor = config.first_advisor
  let second_advisor = config.second_advisor

  show heading: none
  context heading(
    numbering: none,
    bookmarked: true,
    level: 1,
    outlined: false,
  )[ #t("title_page", lang: lang) ]

  set par(first-line-indent: 0mm)
  set page(footer: none)

  let labeled-value(label_key, value) = if has-value(value) {
    [#t(label_key, lang: lang)#value]
  } else {
    []
  }

  let role-label(primary_key, alternate_key) = context if thesis-type-is-bachelor-or-master(thesis.type) {
    t(primary_key, lang: lang)
  } else {
    t(alternate_key, lang: lang)
  }

  let person-row(person, label) = cover-people-row(
    if has-person(person) { [#label#format-name(person)] } else { [] },
    vars,
  )

  let faculty_line = if university.faculty != "uo" {
    upper(get-faculty-name(university.faculty, lang: lang))
  } else {
    []
  }
  let programme_line = labeled-value("programme_label", university.programme)
  let specialisation_line = labeled-value("specialisation_label", university.specialisation)
  let logo-alt = if lang == "en" { "University of Defence logo" } else { "Logo Univerzity obrany" }

  // Pravidlo: Titulka je bez gridu s pevnou osnovou sekcí.
  block(width: 100%, height: vars.page_height)[
    #set par(first-line-indent: 0mm, leading: vars.paragraph_leading, justify: false)

    #align(center + top)[
      #cover-row(
        upper(t("university_name", lang: lang)),
        size: vars.size_university,
        height: vars.header_row_1_height,
      )
      #cover-row(
        faculty_line,
        size: vars.size_faculty,
        weight: vars.weight_faculty,
        height: vars.header_row_2_height,
      )
      #cover-row(
        programme_line,
        size: vars.size_programme,
        weight: vars.weight_programme,
        height: vars.header_row_3_height,
      )
      #cover-row(
        specialisation_line,
        size: vars.size_specialisation,
        weight: vars.weight_specialisation,
        height: vars.header_row_4_height,
      )
    ]

    #v(vars.gap_after_header)

    #align(center + horizon)[
      #image(get-logo-path(university.faculty), alt: logo-alt, height: vars.logo_height, width: auto)
    ]

    #v(vars.gap_after_logo)

    #align(center + horizon)[
      #set text(size: vars.size_thesis_type, weight: vars.weight_thesis_type)
      #upper(get-thesis-type-name(thesis.type, lang: lang))
    ]

    #v(vars.gap_after_thesis_type)

    #align(center + horizon)[
      // Sémantický element `title` (přístupnost/PDF-UA) s vlastním vzhledem
      // titulky — show rule potlačí výchozí blokovou sazbu, set text dorovná.
      #show title: it => it.body
      #set text(size: vars.size_title, weight: vars.weight_title)
      #title(thesis.title)
    ]

    #v(vars.gap_after_title)

    #align(left + top)[
      #cover-people-row([
        #if author.sex != "F" { t("author_male", lang: lang) } else { t("author_female", lang: lang) }
        #format-name(author)
      ], vars)

      #person-row(supervisor, role-label("supervisor_work_label", "supervisor_label"))

      #person-row(first_advisor, role-label("advisor_label", "co_supervisor_label"))

      #if thesis-type-is-doctoral(thesis.type) {
        person-row(second_advisor, t("co_supervisor_label", lang: lang))
      }
    ]

    #place(bottom + center, scope: "parent", float: true)[
      #set text(size: vars.size_city_year)
      #upper(get-city-name(university.faculty, lang: lang))#ez-today.today(format: " Y")
    ]
  ]
}
