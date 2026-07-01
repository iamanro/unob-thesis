// ============================================================
// UNOB — Závěrečná práce
// Hlavní soubor — otevřete v editoru a upravujte.
// ============================================================
// Při prvním otevření v Zed / VS Code musí být root projektu
// nastaven na adresář s tímto souborem (detekuje se automaticky).
// ============================================================

#import "lib.typ": *

// Glosář se načítá z template/glossary.toml (cesta je relativní k tomuto souboru).
#let glossary = toml("template/glossary.toml")

#show: unob-thesis.with(
  lang: "cs",
  draft: false,
  faculty: "fvl",
  programme: "Teorie obrany státu",
  specialisation: "Řízení obrany státu",
  thesis: (
    type: "doctoral",
    title: "TODO:",
  ),
  author: person(
    prefix: "Mgr.",
    name: "Kristýna",
    surname: "Drmotová",
    suffix: none,
    sex: "F",
  ),
  supervisor: person(
    prefix: "plk. gšt. doc. Mgr. et Mgr. Ing.",
    name: "Libor",
    surname: "Kutěj",
    suffix: "Ph.D.",
    sex: "M",
  ),
  first_advisor: person(
    prefix: "Mgr.",
    name: "Jan",
    surname: "Novák",
    suffix: none,
  ),
  second_advisor: person(
    prefix: "Ing.",
    name: "František",
    surname: "Novák",
    suffix: none,
  ),
  assignment_front: none,
  assignment_back: none,
  acknowledgement: [
    Děkuji všem, kteří mě při zpracování práce podporovali.
  ],
  declaration: true,
  ai_used: true,
  acronyms: glossary,
  terms: glossary,
  abstract: (
    czech: [Český abstrakt práce.],
    english: [English abstract of the thesis.],
  ),
  keywords: (
    czech: "klíčové slovo 1, klíčové slovo 2, klíčové slovo 3",
    english: "keyword 1, keyword 2, keyword 3",
  ),
  outlines: (
    headings: true,
    acronyms: true,
    terms: true,
    figures: true,
    tables: true,
    equations: false,
    listings: false,
  ),
  theme: (
    color: true,
    links_colored: true,
    faculty_colored: true,
    faculty_color: none,
    link_color: none,
  ),
  guide: false,
  docs: false,
  submit_check: false,
  // Bibliografie s vlastním CSL stylem (Harvard). Parametr přijímá i pole
  // `bibliography(...)` hodnot, pokud chcete zdroje rozdělit do více seznamů.
  bibliography: bibliography("template/references.bib", style: "src/assets/csl/harvard.csl", full: true),
  appendix: [#include "template/appendix.typ"],
)

#introduction[
  Zde je úvodní text práce.
]

= TEORETICKÁ ČÁST / ANALÝZA SOUČASNÉHO STAVU

Normy #trm("iso") jsou důležité pro sjednocení procesů.
Při další zmínce už stačí #trm("iso").
Instituce #trm("acr") používá český rozpad jen v seznamu zkratek.
V některých dokumentech se objevují i #trm("iso", style: plural).
Model #trm("llm") dnes tvoří základ mnoha aplikací.
V dalších kapitolách už řešíme jen #trm("llm").
Koncept #trm("zero_trust") se prosazuje v kybernetické bezpečnosti.

Tato část je zatím v pracovní verzi a bude doplněna.

= CÍL A OMEZENÍ ZÁVĚREČNÉ PRÁCE

Cílem práce je navrhnout a ověřit řešení zadaného problému. Práce je omezena dostupností
zdrojů a časovým rámcem standardní doby studia.

= POUŽITÉ METODY

V práci jsou použity vědecké metody: analýza, syntéza, komparace a případová studie.

= PRAKTICKÁ ČÁST / VÝSLEDKY A DISKUSE

Výsledky jsou prezentovány v kontextu teoretického rámce stanoveného v předchozích kapitolách.
#lorem(50)

// Ukázka citací z různých zdrojů:
Výzkum @abrau2022 ukazuje základní přístupy,
zatímco @ackoff1989 a @nato2022 přinášejí další perspektivy.

#conclusion[
  Závěrečné shrnutí výsledků práce.
]
