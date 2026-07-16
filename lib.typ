// Veřejné API šablony UNOB.
// Jediný soubor, který uživatel importuje ve svém main.typ.

#import "src/pages/unob-thesis.typ": unob-thesis
#import "src/pages/internal/people.typ": person
#import "src/pages/appendix.typ": appendix

// Flexibilní popisky figur (dlouhá verze pod figurou, krátká v seznamech).
#import "src/styling/flex-caption.typ": flex-caption

// Glosář — sazba zkratek, pojmů a jejich stylové konstanty.
#import "src/pages/internal/glossary/index.typ": first, first-plural, plural, singular, trm

// Sekce práce — vloží metadata pro úvod, závěr, abstrakt, klíčová slova.
#import "src/pages/internal/metadata.typ": (
  abstract-cs, abstract-en, acknowledgement, conclusion, introduction, keywords-cs, keywords-en,
)
