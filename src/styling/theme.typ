// Data: Vizuální metadata fakult.
#let faculty-theme = (
  fvl: (color: rgb("#808205"), logo: "../assets/logoFVL.svg"),
  fvt: (color: rgb("#6188cd"), logo: "../assets/logoFVT.svg"),
  vlf: (color: rgb("#ea0738"), logo: "../assets/logoVLF.svg"),
  uo:  (color: rgb("#fec820"), logo: "../assets/logoUO.svg"),
)

// Funkce: get-faculty-color
// Co: Vrátí barvu fakulty podle zkratky.
#let get-faculty-color(faculty) = {
  faculty-theme.at(faculty, default: (color: rgb("#000000"))).color
}

// Funkce: resolve-theme-color
// Co: Převede hex řetězec z konfigurace na Typst barvu.
/// Převede hex řetězec z konfigurace na Typst barvu; pokud je prázdný, vrátí fallback.
#let resolve-theme-color(value, fallback: none) = {
  if type(value) == str and value.trim().len() > 0 {
    rgb(value.trim())
  } else {
    fallback
  }
}

// Funkce: resolve-theme
// Co: Normalizuje uživatelské nastavení barev pro sazbu.
#let resolve-theme(theme, faculty) = (
  color: theme.at("color", default: false),
  links_colored: theme.at("color", default: false) and theme.at("links_colored", default: true),
  faculty_colored: theme.at("color", default: false) and theme.at("faculty_colored", default: true),
  faculty_color: resolve-theme-color(theme.at("faculty_color", default: none), fallback: get-faculty-color(faculty)),
  link_color: resolve-theme-color(theme.at("link_color", default: none), fallback: none),
)

// Funkce: get-logo-path
// Co: Sestaví cestu k logu fakulty pro `src/pages/cover.typ`.
#let get-logo-path(faculty) = {
  faculty-theme.at(faculty, default: (logo: "../assets/logo" + upper(faculty) + ".svg")).logo
}
