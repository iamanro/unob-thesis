#set page(numbering: none)
#set text(size: 10pt)

= INTERNÍ DOKUMENTACE API

Tento dokument se zobrazí při `docs: true` v `#show: unob-thesis.with(...)`.

== Veřejný vstup

Hlavní veřejný vstup je `unob-thesis`. Konfigurace je inline v Typstu, bez externího konfiguračního souboru:

```typ
#show: unob-thesis.with(
  lang: "cs",
  draft: false,
  faculty: "fvt",
  thesis: (type: "master", title: "Název práce"),
  author: person(name: "Jan", surname: "Novák", sex: "M"),
  supervisor: person(name: "Jana", surname: "Nováková", sex: "F"),
  bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),
  appendix: [#include "appendix.typ"],
)
```

== Exporty z `lib.typ`

- `unob-thesis`: hlavní `#show` šablona.
- `person(...)`: osoba pro autora, vedoucího, školitele nebo konzultanta.
- `acknowledgement[...]`, `introduction[...]`, `abstract-cs[...]`, `abstract-en[...]`, `keywords-cs(...)`, `keywords-en(...)`, `conclusion[...]`: metadata helpery.
- `trm("key")`: jednotné API pro zkratky i pojmy.
- `singular`, `plural`, `first`, `first-plural`: styly pro `trm(...)`.
- `appendix[...]`: low-level režim příloh; běžně používejte parametr `appendix`.

== Glosář

Glosář používá jeden podporovaný TOML formát s jednou tabulkou na položku:

```toml
[iso]
short = "ISO"
en = "International Organization for Standardization"
cs = "Mezinárodní organizace pro standardizaci"
glossary = "Volitelný popis pojmu."
```

Parametry `acronyms: true` a `terms: true` načítají `template/glossary.toml`. V textu používejte jen `#trm("iso")`.

== Bibliografie a přílohy

Bibliografii předejte jako nativní Typst obsah:

```typ
bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true)
```

Přílohy předejte přes parametr `appendix`. Pokud přílohy neobsahují žádný H1 nadpis, nevykreslí se ani `SEZNAM PŘÍLOH`.

== Interní vrstvy

- `src/pages/*`: titulní strana, frontmatter, seznamy, přílohy a hlavní orchestrace.
- `src/pages/internal/*`: validace, metadata, osoby, lokalizace a glosář.
- `src/styling/*`: globální sazba, nadpisy, figury, přílohy a externí balíčky.
- `src/styling/vendor/*`: vendorizované moduly.
