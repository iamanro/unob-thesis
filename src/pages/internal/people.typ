// Funkce: person
// Co: Vytvoří záznam osoby pro konfiguraci šablony.
// `genitive`: volitelný 2. pád celého jména ("Jana Nováka") pro čestné
// prohlášení. Pokud je `none`, použije se automatické skloňování. Nastavte
// ručně, pokud heuristika jméno skloní špatně.
#let person(
  prefix: "",
  name: "",
  surname: "",
  suffix: none,
  sex: none,
  genitive: none,
) = (
  prefix: prefix,
  name: name,
  surname: surname,
  suffix: suffix,
  sex: sex,
  genitive: genitive,
)

// Funkce: format-name
// Co: Sestaví celé jméno osoby včetně titulů.
#let format-name(person) = [
  #person.prefix
  #person.name
  #if person.suffix != none {
    [#person.surname, #person.suffix]
  } else {
    [#person.surname]
  }
]

// Funkce: format-supervisor-for-declaration
// Co: Vrátí jméno vedoucího nebo školitele ve 2. pádě.
#let format-supervisor-for-declaration(supervisor) = {
  import "i18n/genitiv.typ": genitiv
  let override = supervisor.at("genitive", default: none)
  let name-in-genitive = if override != none {
    override
  } else {
    [#genitiv(supervisor.name) #genitiv(supervisor.surname)]
  }
  [
    #supervisor.prefix
    #name-in-genitive,
    #if supervisor.suffix != none {
      [#supervisor.suffix,]
    } else {
      []
    }
  ]
}
