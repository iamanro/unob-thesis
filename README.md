# UNOB — Šablona závěrečných prací

Oficiální šablona pro psaní bakalářských, diplomových a disertačních prací na Univerzitě obrany v sázecím systému [Typst](https://typst.app/). Šablona pokrývá všechny fakulty (`fvl`, `fvt`, `vlf`, `uo`) a dokáže sázet česky i anglicky.

*(English version below — [jump to English](#unob-thesis-template).)*

> **Návod má dvě části:** **[Základní použití](#základní-použití)** ti stačí k napsání celé práce. **[Pokročilé](#pokročilé)** je referenční příručka — čti ji, jen když budeš chtít něco navíc. Nemusíš mu rozumět, abys mohl začít.

## Základní použití

### 1. Stažení šablony

Šablona je připravená k okamžité úpravě — nic se neinstaluje, píšeš rovnou v souboru `main.typ`. Stáhni si ji jedním ze dvou způsobů:

**Přes Git:**

```bash
git clone https://github.com/iamanro/unob-thesis.git
```

**Nebo ručně (bez Gitu):** otevři [stránku repozitáře](https://github.com/iamanro/unob-thesis), klikni na zelené tlačítko **Code ▸ Download ZIP** a stažený archiv rozbal.

### 2. Otevření a sazba

Práci píšeš v souboru **`main.typ`** v kořeni složky. Otevřít a průběžně sázet ho můžeš dvěma způsoby — vyber si jeden:

**Varianta A — VS Code + Tinymist (lokálně):**

1. Nainstaluj [VS Code](https://code.visualstudio.com/) a v něm z Marketplace rozšíření **Tinymist Typst**.
2. Ve VS Code zvol `File ▸ Open Folder…` a otevři složku `unob-thesis`.
3. Otevři `main.typ` a vpravo nahoře klikni na ikonu náhledu (**Preview**) — Typst sází živě, jak píšeš. (Kořen projektu se nastaví sám díky `.tinymist.toml`.)
4. Aby se použily přibalené fonty, nastav ve VS Code volbu `tinymist.fontPaths` na `template/fonts` (nebo si fonty nainstaluj systémově — viz [Fonty](#fonty)).
5. Hotové PDF vyexportuješ příkazem **Typst: Export to PDF** (`Ctrl/Cmd+Shift+P`).

**Varianta B — Typst Web App (v prohlížeči, bez instalace):**

1. Přihlaš se na [typst.app](https://typst.app/) a vytvoř nový prázdný projekt (**Empty project**).
2. Přetáhni do projektu **celý obsah** rozbalené složky — včetně `lib.typ`, `src/` a `template/` (i s fonty).
3. Otevři `main.typ`; sází se rovnou v prohlížeči a fonty se načtou automaticky.
4. Hotové PDF stáhneš tlačítkem **Download PDF**.

> Až bude šablona zveřejněná v [Typst Universe](https://typst.app/universe/), půjde projekt založit i jediným příkazem `typst init @preview/unob-thesis` — viz [Pokročilé](#pokročilé).

### 3. Příklad — soubor `main.typ`

Ve staženém projektu je `main.typ` už předvyplněný ukázkovou prací. Jádro, které upravuješ, vypadá takto:

```typ
#import "lib.typ": *

#let glossary = toml("template/glossary.toml")

#show: unob-thesis.with(
  lang: "cs",
  faculty: "fvl",                                   // fvl | fvt | vlf | uo
  thesis: (type: "master", title: "Název práce"),   // bachelor | master | doctoral
  author: person(name: "Jan", surname: "Novák", sex: "M"),
  supervisor: person(name: "Jana", surname: "Nováková", sex: "F"),
  acknowledgement: [Děkuji všem, kteří mě při zpracování práce podporovali.],
  abstract: (czech: [Český abstrakt.], english: [English abstract.]),
  keywords: (czech: "první, druhé", english: "first, second"),
  acronyms: glossary,
  terms: glossary,
  bibliography: bibliography("template/references.bib", style: "iso-690-numeric", full: true),
  appendix: [#include "template/appendix.typ"],
)

= Úvod
Text úvodu…

= První kapitola
Běžný text, zkratka #trm("iso") a citace @abrau2022.

= Závěr
Shrnutí práce.
```

### 4. Jak ho vyplnit

- **`faculty`** — tvoje fakulta: `fvl`, `fvt`, `vlf` nebo `uo`.
- **`thesis`** — `type` (`bachelor` / `master` / `doctoral`) a `title` (název práce).
- **`author` a `supervisor`** — jméno, příjmení a `sex` (`"M"` muž / `"F"` žena). Pohlaví je potřeba, aby se správně skloňovaly tvary v čestném prohlášení.
- **Text práce** piš pod blok `#show: …` — nadpisy kapitol přes `=`, podkapitoly přes `==`, `===`, běžný text normálně.
- **Zkratky a pojmy** dej do souboru `template/glossary.toml`; v textu je vkládej přes `#trm("iso")`.
- **Zdroje (literaturu)** dej do `template/references.bib`; cituj přes `@klíč`.
- **Poděkování, abstrakt a klíčová slova** vyplň v parametrech `acknowledgement`, `abstract`, `keywords`.
- **Přílohy** piš do souboru `template/appendix.typ`.

To je vše, co potřebuješ k napsání práce. Další volby (barvy, více bibliografií, ruční skloňování, kontrola před odevzdáním…) najdeš níže v části **[Pokročilé](#pokročilé)**.

---

## Pokročilé

Referenční příručka pro pokročilejší úpravy. Pro běžné psaní ji nepotřebuješ.

### Konfigurace

Veškerá konfigurace je inline v `main.typ` v bloku `#show: unob-thesis.with(...)`. Externí konfigurační soubor se nepoužívá. Kompletní příklad viz [Základní použití](#základní-použití).

| Parametr | Typ / hodnoty | Výchozí | Popis |
|---|---|---|---|
| `lang` | `"cs"` \| `"en"` | `"cs"` | Jazyk dokumentu |
| `draft` | bool | `false` | Pracovní režim (viz [Draft a final](#draft-a-final)) |
| `faculty` | `"fvl"` \| `"fvt"` \| `"vlf"` \| `"uo"` | `"uo"` | Fakulta |
| `programme` | obsah / string | `[]` | Studijní program |
| `specialisation` | obsah / string | `[]` | Studijní specializace |
| `thesis` | `(type, title)` | — | `type`: `"bachelor"` \| `"master"` \| `"doctoral"` |
| `author` | `person(...)` | — | Autor práce |
| `supervisor` | `person(...)` | — | Vedoucí / školitel |
| `first_advisor` | `person(...)` | prázdný | Odborný konzultant |
| `second_advisor` | `person(...)` | prázdný | Školitel-specialista (jen u disertace) |
| `assignment_front` | `none` \| obsah | `none` | Líc zadání, např. `image("zadani-1.pdf")` |
| `assignment_back` | `none` \| obsah | `none` | Rub zadání |
| `acknowledgement` | `false` \| obsah | `false` | Poděkování |
| `declaration` | bool | `true` | Čestné prohlášení |
| `ai_used` | bool | `false` | Prohlášení o použití AI |
| `acronyms` | `false` \| `true` \| slovník | `false` | Zkratky (viz [Glosář](#glosář)) |
| `terms` | `false` \| `true` \| slovník | `false` | Pojmy |
| `abstract` | `(czech, english)` | prázdné | Abstrakty |
| `keywords` | `(czech, english)` | prázdné | Klíčová slova |
| `introduction` | obsah | `[]` | Úvod (lze i přes `#introduction[...]`) |
| `outlines` | slovník | viz níže | Generované seznamy |
| `theme` | slovník | viz níže | Barevné přepínače |
| `bibliography` | `none` \| `bibliography(...)` \| pole | `none` | Bibliografie |
| `appendix` | `none` \| obsah | `none` | Přílohy |
| `submit_check` | bool | `false` | Přísná kontrola před odevzdáním |

`outlines` (každý klíč bool): `headings`, `acronyms`, `terms`, `figures`, `tables`, `equations`, `listings`.

`theme`: `color` (hlavní vypínač barev), `links_colored`, `faculty_colored`, `faculty_color` (vlastní barva nebo `none`), `link_color`.

`person(prefix, name, surname, suffix, sex, genitive)`: `sex` je `"M"`, `"F"` nebo `none` (pro `none` se použijí mužské tvary); `genitive` je volitelný ruční 2. pád celého jména pro čestné prohlášení.

### Veřejné API

Kořenový `lib.typ` exportuje:

- `unob-thesis`: hlavní šablona pro `#show`.
- `person(...)`: konfigurace autora, vedoucího a konzultantů.
- `acknowledgement[...]`, `introduction[...]`, `abstract-cs[...]`, `abstract-en[...]`, `keywords-cs(...)`, `keywords-en(...)`, `conclusion[...]`: metadata helpery pro zadání úvodních částí přímo v textu.
- `trm("klic", style: ..., case: ...)`: vložení zkratky nebo pojmu z glosáře.
- `singular`, `plural`, `first`, `first-plural`: styly pro `trm(...)`.
- `appendix[...]`: low-level helper pro přílohy (běžně stačí parametr `appendix`).

### Glosář

Zkratky i pojmy jsou v jednom souboru `glossary.toml`, jedna TOML tabulka na položku:

```toml
[iso]
short = "ISO"
en = "International Organization for Standardization"
cs = "Mezinárodní organizace pro standardizaci"

[zero_trust]
short = "Zero Trust"
cs = "nulová důvěra"
glossary = "Bezpečnostní model, který implicitně nedůvěřuje žádnému prvku sítě."
```

- Položka **bez** klíče `glossary` je **zkratka** (SEZNAM ZKRATEK). Při prvním výskytu se rozvine, dále se použije krátký tvar.
- Položka **s** klíčem `glossary` je **pojem** (SEZNAM POJMŮ s definicí).

Pole: `short` (povinné), `en` a `cs` (rozvinutý tvar), `glossary` (definice). Volitelně `plural`, `longplural` (anglický plurál), `csplural` (český plurál).

Použij `acronyms: toml("glossary.toml")`, aby se promítly tvoje úpravy souboru. Hodnota `acronyms: true` načte vestavěný **demo** glosář z balíčku (hodí se jen pro první kompilaci).

V textu používej `#trm("iso")`. Pro množné číslo `#trm("iso", style: plural)`, pro vynucené první (rozvinuté) použití `#trm("iso", style: first)`. Parametr `case` (1–7) určuje český pád, např. `#trm("iso", case: 3)` (jen u zkratek). Seznam zkratek nebo pojmů se vykreslí jen tehdy, když je v dokumentu skutečně použita odpovídající položka.

### Bibliografie

Bibliografie je nativní Typst `bibliography(...)` předaná do konfigurace. Styl `iso-690-numeric` odpovídá ČSN ISO 690 a je vestavěný (nevyžaduje soubor CSL):

```typ
bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true)
```

Lze předat i pole a rozdělit zdroje do více seznamů s vlastními nadpisy, případně použít vlastní CSL:

```typ
bibliography: (
  bibliography("knihy.bib", style: "iso-690-numeric", full: true, title: [Knihy]),
  bibliography("online.bib", style: "iso-690-numeric", full: true, title: [Online zdroje]),
)
```

Pro vypnutí použij `bibliography: none`.

### Skloňování jména vedoucího

Čestné prohlášení je vždy v češtině a jméno vedoucího se skloňuje do 2. pádu automaticky. Pokud heuristika jméno skloní špatně, zadej správný tvar ručně:

```typ
supervisor: person(
  name: "Jan", surname: "Kadlec", sex: "M",
  genitive: "Jana Kadlece",
)
```

### Draft a final

Parametr `draft` přepíná režim. **Draft** je pro psaní — vypne titulní stranu a úvodní sazbu a zapne širší okraje. **Final** je odevzdávaná verze s kompletní titulní stranou, prohlášením, seznamy atd. Číslování stránek začíná od 1 na první číslované straně (OBSAH).

### Generované seznamy

Seznam obrázků, tabulek, rovnic, výpisů, zkratek a pojmů se vykreslí jen tehdy, když v dokumentu reálně existují odpovídající položky — i když je příslušná volba v `outlines` nastavena na `true`.

### Přílohy

Přílohy se předávají jako obsah:

```typ
appendix: [#include "appendix.typ"]
```

Pokud přílohy neobsahují žádný H1 nadpis (`= Název přílohy`), nevykreslí se ani `SEZNAM PŘÍLOH`. Jednotlivé přílohy jsou v PDF záložkách, ale v hlavním obsahu je pouze `SEZNAM PŘÍLOH`.

### Fonty

Šablona používá rodinu **TeX Gyre**, která je přibalená ve složce `template/fonts/`:

- `TeX Gyre Termes` — hlavní text
- `TeX Gyre Termes Math` — matematická sazba
- `TeX Gyre Cursor` — kód a výpisy

Ve webové aplikaci se fonty načtou automaticky. Lokálně předej složku přes `--font-path template/fonts`, nebo si fonty nainstaluj systémově (pak `--font-path` není potřeba). Kompletní rodinu lze stáhnout z [CTAN](https://mirrors.ctan.org/fonts/tex-gyre.zip).

### Práce přímo s repozitářem

Pokud pracuješ přímo s tímto repozitářem, je k dispozici vývojový vzorek `main.typ` v kořeni (importuje lokální `lib.typ`) a [Taskfile](https://taskfile.dev/):

```bash
task build          # finální PDF do build/
task watch          # průběžná kompilace
task draft          # pracovní verze
task fonts          # seznam fontů
task clean          # úklid build/
```

### Vzhled a typografie (`src/config.toml`)

Veškeré laditelné hodnoty sazby jsou na jednom místě v [`src/config.toml`](src/config.toml) — velikosti nadpisů (H1–H4), písma (text, matematika, kód), řádkování a odsazení odstavce, okraje stránky, sazba tabulek, titulní strana a barvy fakult. Styly v `src/styling/*` je čtou přes `src/config.typ`, takže úprava vzhledu nevyžaduje zásah do Typst kódu.

Délky se zapisují jako řetězec s jednotkou (`"12pt"`, `"0.7em"`, `"35mm"`, `"47%"`; jednotky `pt`, `mm`, `cm`, `in`, `em`, `%`). Například zvětšení nadpisů kapitol:

```toml
[heading]
h1_size = "16pt"
```

Sekce `[faculty]` obsahuje oficiální barvy fakult — neměň je bez svolení Univerzity obrany (viz `NOTICE`).

### Doporučené doplňkové balíčky

Šablona záměrně neexportuje vlastní boxy, callout bloky ani kreslicí nástroje. Pokud potřebuješ víc, použij balíčky z Typst Universe a importuj je přímo v práci (ne v jádru šablony): `@preview/showybox`, `@preview/frame-it`, `@preview/cetz`, `@preview/fletcher`, `@preview/physica`, `@preview/zero`, `@preview/subpar`.

### Dobrá praxe a přístupnost

- Zkratky a pojmy drž v `glossary.toml` a používej je konzistentně.
- Preferuj vektorovou grafiku (`.svg`) a před odevzdáním optimalizuj větší obrázky.
- Před finálním odevzdáním vygeneruj final PDF a zkontroluj seznamy, reference i úvodní části.
- Pro přísnější validaci zapni `submit_check: true`.
- Nahraď veškerý ukázkový obsah (text, reference, glosář, metadata) vlastním.
- **Přístupnost (PDF/UA):** u vkládaných obrázků vždy doplň `alt` text — zejména u skenu zadání, např. `assignment_front: image("zadani.png", alt: "Zadání práce")`. Šablona sama nastavuje jazyk dokumentu, metadata (`title`, `author`, …) a `alt` u log; `alt` u vlastního obsahu musíš doplnit ty. Typst navíc ve výchozím stavu exportuje otagované (tagged) PDF, což je základ přístupnosti.

### Licence

Zdrojový kód šablony je licencován pod **MIT** (viz `LICENSE`).

Loga fakult a univerzity (`src/assets/logo*.svg`) jsou duševním vlastnictvím Univerzity obrany a **nejsou** kryta licencí MIT — smí se použít pouze v rámci skutečné závěrečné práce na Univerzitě obrany a nesmí se upravovat (viz `NOTICE`). Přibalené fonty TeX Gyre podléhají GUST Font License (viz `template/fonts/LICENSE-FONTS.txt`). Ověř si, že použití log odpovídá pravidlům Univerzity obrany a tvé fakulty.

---

# UNOB Thesis Template

Official Typst template for writing bachelor's, master's, and doctoral theses at the University of Defence. It covers all faculties (`fvl`, `fvt`, `vlf`, `uo`) and typesets in Czech and English.

> **This guide has two parts:** **[Basic usage](#basic-usage)** is all you need to write your whole thesis. **[Advanced](#advanced)** is a reference — read it only when you want more. You don't need to understand it to get started.

## Basic usage

### 1. Download the template

The template is ready to edit right away — nothing to install, you write directly in `main.typ`. Get it in one of two ways:

**With Git:**

```bash
git clone https://github.com/iamanro/unob-thesis.git
```

**Or manually (no Git):** open the [repository page](https://github.com/iamanro/unob-thesis), click the green **Code ▸ Download ZIP** button, and unpack the archive.

### 2. Open and typeset

You write your thesis in **`main.typ`** in the root of the folder. There are two ways to open it and get a live preview — pick one:

**Option A — VS Code + Tinymist (locally):**

1. Install [VS Code](https://code.visualstudio.com/) and the **Tinymist Typst** extension from the Marketplace.
2. In VS Code choose `File ▸ Open Folder…` and open the `unob-thesis` folder.
3. Open `main.typ` and click the preview icon (**Preview**) in the top-right — Typst typesets live as you write. (The project root is set automatically via `.tinymist.toml`.)
4. To use the bundled fonts, set `tinymist.fontPaths` to `template/fonts` in the VS Code settings (or install the fonts system-wide — see [Fonts](#fonts)).
5. Export the finished PDF with the **Typst: Export to PDF** command (`Ctrl/Cmd+Shift+P`).

**Option B — Typst web app (in the browser, no install):**

1. Sign in at [typst.app](https://typst.app/) and create a new **Empty project**.
2. Drag the **entire contents** of the unpacked folder into the project — including `lib.typ`, `src/`, and `template/` (with the fonts).
3. Open `main.typ`; it typesets right in the browser and the fonts load automatically.
4. Download the finished PDF with the **Download PDF** button.

> Once the template is published on [Typst Universe](https://typst.app/universe/), you will also be able to create a project with a single command, `typst init @preview/unob-thesis` — see [Advanced](#advanced).

### 3. Example — the `main.typ` file

In the downloaded project `main.typ` is already filled in with a sample thesis. The core you edit looks like this:

```typ
#import "lib.typ": *

#let glossary = toml("template/glossary.toml")

#show: unob-thesis.with(
  lang: "en",
  faculty: "fvl",                                   // fvl | fvt | vlf | uo
  thesis: (type: "master", title: "Thesis Title"),  // bachelor | master | doctoral
  author: person(name: "Jan", surname: "Novak", sex: "M"),
  supervisor: person(name: "Jana", surname: "Novakova", sex: "F"),
  acknowledgement: [Thanks to everyone who supported me.],
  abstract: (czech: [Český abstrakt.], english: [English abstract.]),
  keywords: (czech: "první, druhé", english: "first, second"),
  acronyms: glossary,
  terms: glossary,
  bibliography: bibliography("template/references.bib", style: "iso-690-numeric", full: true),
  appendix: [#include "template/appendix.typ"],
)

= Introduction
Introduction text…

= First chapter
Ordinary text, an acronym #trm("iso") and a citation @abrau2022.

= Conclusion
Summary of the thesis.
```

### 4. How to fill it in

- **`faculty`** — your faculty: `fvl`, `fvt`, `vlf`, or `uo`.
- **`thesis`** — `type` (`bachelor` / `master` / `doctoral`) and `title`.
- **`author` and `supervisor`** — name, surname, and `sex` (`"M"` / `"F"`). The sex is needed for correct Czech declension in the honour declaration.
- **Thesis text** goes below the `#show: …` block — chapter headings with `=`, subsections with `==`, `===`, ordinary text as usual.
- **Acronyms and terms** go in `template/glossary.toml`; insert them in text with `#trm("iso")`.
- **Sources** go in `template/references.bib`; cite with `@key`.
- **Acknowledgement, abstract, and keywords** — fill the `acknowledgement`, `abstract`, `keywords` parameters.
- **Appendices** go in `template/appendix.typ`.

That is everything you need to write your thesis. More options (colours, multiple bibliographies, manual declension, pre-submission checks…) are below under **[Advanced](#advanced)**.

---

## Advanced

Reference for advanced tweaks. You don't need it for everyday writing.

### Configuration

All configuration is inline in `main.typ` inside the `#show: unob-thesis.with(...)` block. There is no external configuration file. For a complete example see [Basic usage](#basic-usage).

| Parameter | Type / values | Default | Description |
|---|---|---|---|
| `lang` | `"cs"` \| `"en"` | `"cs"` | Document language |
| `draft` | bool | `false` | Draft mode (see [Draft and final](#draft-and-final)) |
| `faculty` | `"fvl"` \| `"fvt"` \| `"vlf"` \| `"uo"` | `"uo"` | Faculty |
| `programme` | content / string | `[]` | Study programme |
| `specialisation` | content / string | `[]` | Specialisation |
| `thesis` | `(type, title)` | — | `type`: `"bachelor"` \| `"master"` \| `"doctoral"` |
| `author` | `person(...)` | — | Thesis author |
| `supervisor` | `person(...)` | — | Supervisor |
| `first_advisor` | `person(...)` | empty | Advisor |
| `second_advisor` | `person(...)` | empty | Co-supervisor (doctoral only) |
| `assignment_front` | `none` \| content | `none` | Assignment front, e.g. `image("assignment-1.pdf")` |
| `assignment_back` | `none` \| content | `none` | Assignment back |
| `acknowledgement` | `false` \| content | `false` | Acknowledgement |
| `declaration` | bool | `true` | Honour declaration |
| `ai_used` | bool | `false` | AI-usage statement |
| `acronyms` | `false` \| `true` \| dict | `false` | Acronyms (see [Glossary](#glossary)) |
| `terms` | `false` \| `true` \| dict | `false` | Terms |
| `abstract` | `(czech, english)` | empty | Abstracts |
| `keywords` | `(czech, english)` | empty | Keywords |
| `introduction` | content | `[]` | Introduction (also via `#introduction[...]`) |
| `outlines` | dict | see below | Generated lists |
| `theme` | dict | see below | Colour switches |
| `bibliography` | `none` \| `bibliography(...)` \| array | `none` | Bibliography |
| `appendix` | `none` \| content | `none` | Appendices |
| `submit_check` | bool | `false` | Strict pre-submission validation |

`outlines` (each key bool): `headings`, `acronyms`, `terms`, `figures`, `tables`, `equations`, `listings`.

`theme`: `color` (master colour switch), `links_colored`, `faculty_colored`, `faculty_color` (custom colour or `none`), `link_color`.

`person(prefix, name, surname, suffix, sex, genitive)`: `sex` is `"M"`, `"F"`, or `none` (masculine forms are used for `none`); `genitive` is an optional manual genitive of the full name for the declaration.

### Public API

Root `lib.typ` exports:

- `unob-thesis`: the main `#show` template.
- `person(...)`: configuration of the author, supervisor, and advisors.
- `acknowledgement[...]`, `introduction[...]`, `abstract-cs[...]`, `abstract-en[...]`, `keywords-cs(...)`, `keywords-en(...)`, `conclusion[...]`: metadata helpers to set frontmatter sections inline in the text.
- `trm("key", style: ..., case: ...)`: inserts an acronym or glossary term.
- `singular`, `plural`, `first`, `first-plural`: styles for `trm(...)`.
- `appendix[...]`: low-level appendix helper (the `appendix` parameter is usually enough).

### Glossary

Acronyms and terms live in a single `glossary.toml`, one TOML table per entry:

```toml
[iso]
short = "ISO"
en = "International Organization for Standardization"
cs = "Mezinárodní organizace pro standardizaci"

[zero_trust]
short = "Zero Trust"
cs = "nulová důvěra"
glossary = "A security model that implicitly trusts no element of the network."
```

- An entry **without** a `glossary` key is an **acronym** (LIST OF ACRONYMS). It expands on first use, then the short form is used.
- An entry **with** a `glossary` key is a **term** (LIST OF TERMS, with a definition).

Fields: `short` (required), `en` and `cs` (expansion), `glossary` (definition). Optionally `plural`, `longplural` (English plural), `csplural` (Czech plural).

Load the glossary with `acronyms: toml("glossary.toml")` so your edits to the file take effect. `acronyms: true` loads a built-in **demo** glossary from the package (useful only for the first compile).

In text use `#trm("iso")`. For plural `#trm("iso", style: plural)`, for a forced first (expanded) use `#trm("iso", style: first)`. The `case` parameter (1–7) selects the Czech grammatical case, e.g. `#trm("iso", case: 3)` (acronyms only). A list renders only when the document actually uses a matching entry.

### Bibliography

The bibliography is native Typst `bibliography(...)`. The `iso-690-numeric` style matches ČSN ISO 690 and is built in (no CSL file needed):

```typ
bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true)
```

You can also pass an array to split sources into several lists with their own titles, or use a custom CSL:

```typ
bibliography: (
  bibliography("books.bib", style: "iso-690-numeric", full: true, title: [Books]),
  bibliography("online.bib", style: "iso-690-numeric", full: true, title: [Online sources]),
)
```

Use `bibliography: none` to disable it.

### Declension of the supervisor's name

The honour declaration is always in Czech and the supervisor's name is automatically declined into the genitive. If the heuristic gets it wrong, supply the correct form manually via `person(..., genitive: "Jana Kadlece")`.

### Draft and final

The `draft` parameter switches modes. **Draft** is for writing — it disables the title page and frontmatter and enables wider margins. **Final** is the submitted version with the full title page, declaration, lists, etc. Page numbering starts at 1 on the first numbered page (table of contents).

### Generated lists

Lists of figures, tables, equations, listings, acronyms, and terms render only when the document actually contains matching items — even if the corresponding option in `outlines` is `true`.

### Appendices

Appendices are passed as content: `appendix: [#include "appendix.typ"]`. If the appendices contain no H1 heading (`= Appendix Title`), the `LIST OF APPENDICES` section is not rendered.

### Fonts

The template uses the **TeX Gyre** family, bundled in `template/fonts/`:

- `TeX Gyre Termes` — body text
- `TeX Gyre Termes Math` — mathematics
- `TeX Gyre Cursor` — code and listings

In the web app the fonts load automatically. Locally pass the folder via `--font-path template/fonts`, or install the fonts system-wide (then `--font-path` is not needed). The full family is available from [CTAN](https://mirrors.ctan.org/fonts/tex-gyre.zip).

### Working in this repository

When working directly in this repository there is a development sample `main.typ` in the root (it imports the local `lib.typ`) and a [Taskfile](https://taskfile.dev/): `task build`, `task watch`, `task draft`, `task fonts`, `task clean`.

### Recommended additional packages

The template intentionally does not export custom boxes, callout blocks, or drawing tools. If you need more, use packages from Typst Universe and import them directly in your thesis (not in the template core): `@preview/showybox`, `@preview/frame-it`, `@preview/cetz`, `@preview/fletcher`, `@preview/physica`, `@preview/zero`, `@preview/subpar`.

### Good practice and accessibility

- Keep acronyms and terms in `glossary.toml` and use them consistently.
- Prefer vector graphics (`.svg`) and optimize larger images before submission.
- Before final submission, generate the final PDF and check the lists, references, and frontmatter.
- Enable `submit_check: true` for stricter validation.
- Replace all sample content (text, references, glossary, metadata) with your own.
- **Accessibility (PDF/UA):** always add `alt` text to images you insert — especially a scanned assignment, e.g. `assignment_front: image("assignment.png", alt: "Thesis assignment")`. The template sets the document language, PDF metadata (`title`, `author`, …), and `alt` on the faculty logos for you; add `alt` to your own content. Typst also writes a tagged PDF by default, which is the baseline for accessibility.

### License

The template source code is licensed under **MIT** (see `LICENSE`).

The faculty and university logos (`src/assets/logo*.svg`) are the intellectual property of the University of Defence and are **not** covered by the MIT license — they may be used only as part of a genuine University of Defence thesis and must not be modified (see `NOTICE`). The bundled TeX Gyre fonts are subject to the GUST Font License (see `template/fonts/LICENSE-FONTS.txt`). Make sure the logo usage complies with the rules of the University of Defence and your faculty.
