#set page(numbering: none)
#set text(size: 10pt)

= PRŮVODCE ŠABLONOU

Tento průvodce je součástí ukázkového projektu. Vypnete jej parametrem `guide: false` v `#show: unob-thesis.with(...)`.

== Základní použití

Veškerá konfigurace je přímo v souboru `template/main.typ`, podobně jako u šablony SHAW/ZHAW:

```typ
#import "@preview/unob-thesis:0.3.0": *

#show: unob-thesis.with(
  lang: "cs",
  draft: false,
  faculty: "fvt",
  thesis: (
    type: "master",
    title: "Název práce",
  ),
  author: person(name: "Jan", surname: "Novák", sex: "M"),
  supervisor: person(name: "Jana", surname: "Nováková", sex: "F"),
  bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),
  appendix: [#include "appendix.typ"],
)
```

== Důležité parametry

- `lang`: jazyk dokumentu, `cs` nebo `en`.
- `draft`: pracovní režim; při `true` se nevykreslí plná titulní a úvodní sazba.
- `faculty`: fakulta, `fvl`, `fvt`, `vlf` nebo `uo`.
- `thesis`: typ a název práce.
- `author`, `supervisor`, `first_advisor`, `second_advisor`: osoby vytvořené pomocí `person(...)`.
- `assignment_front`, `assignment_back`, `acknowledgement`, `declaration`, `ai_used`: úvodní části práce.
- `abstract`, `keywords`, `introduction`: obsah úvodních částí.
- `acronyms`, `terms`, `outlines`: zkratky, pojmy a generované seznamy.
- `bibliography`: bibliografie vložená za tělo práce.
- `appendix`: přílohy vložené za bibliografii.

== Bibliografie a přílohy

Bibliografii předejte jako `bibliography(...)` objekt (jeden nebo více v poli).

```typ
// Jedna bibliografie
bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),

// Více seznamů (např. rozdělení podle typu zdroje)
bibliography: (
  bibliography("knihy.bib", style: "iso-690-numeric", full: true, title: [Knihy]),
  bibliography("online.bib", style: "iso-690-numeric", full: true, title: [Online zdroje]),
),
```

Pro každou bibliografii můžete nastavit vlastní `title`.
Přílohy držte v samostatném souboru `template/appendix.typ` a předejte je do parametru `appendix`.

== Zkratky a pojmy

Zkratky a pojmy jsou uložené v jednotném formátu v `template/glossary.toml`. Zapnete je parametry `acronyms: true` a `terms: true`, v textu je používáte přes `#trm("klic")`.

== Kompilace

Lokálně kompilujte hlavní soubor (fonty TeX Gyre jsou ve složce `fonts/`):

```bash
typst compile --font-path fonts main.typ thesis.pdf
typst watch --font-path fonts main.typ thesis.pdf
```
