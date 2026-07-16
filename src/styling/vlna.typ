// Česká sazba — nezlomitelné mezery („vlna").
// Lokální náhrada balíčku @preview/vlna: navíc řeší dvoupísmenná slova,
// tituly před/za jménem a běžné zkratky.
//
// Pravidla:
//   1. Za jedno- a dvoupísmennými slovy řádek nekončí (k, s, v, z, a, i, …,
//      ale i „po", „do", „je", „se") — mezera za nimi je nezlomitelná.
//   2. Tituly a zkratky PŘED jménem/výrazem (Ing., doc., pplk. gšt., např.,
//      viz, s., …) se váží k následujícímu slovu.
//   3. Tituly ZA jménem (Ph.D., CSc., …) se váží k předchozímu slovu.
//
// Ladění: `#show: apply-vlna.with(debug: true)` orámuje všechny zásahy.

// --- 1. Krátká slova (1–2 písmena) -----------------------------------------
// První písmeno libovolné (věta může začínat „V lese…"), druhé jen malé,
// aby se pravidlo nedotklo zkratek typu EU, AI, OSN. Řetězce („a v lese")
// vyřeší postupné nepřekrývající se shody — každé slovo si sváže svou mezeru.
#let short-word = regex("\\<\\p{L}\\p{Ll}?\\> ")

// --- 2. Tituly a zkratky PŘED jménem ----------------------------------------
#let before-list = (
  // === Oslovení ===
  "p.", "pan", "Pan", "pí.", "paní", "Paní", "sl.", // Česká
  "Mr.", "Mrs.", "Ms.", // Anglická

  // === Akademické tituly (před jménem) ===
  // Bakalářské
  "bc.", "Bc.", "BcA.",
  // Magisterské a inženýrské
  "mgr.", "Mgr.", "mga.", "MgA.",
  "ing.", "Ing.", "Ing. arch.",
  // Doktorské (tzv. „malé" a profesní)
  "dr.", "Dr.", // Obecný doktorát (historický, již se neuděluje)
  "mudr.", "MUDr.", // Lékařství
  "mvdr.", "MVDr.", // Veterinární lékařství
  "MDDr.", // Zubní lékařství
  "judr.", "JUDr.", // Právo
  "phdr.", "PhDr.", // Filosofie
  "rndr.", "RNDr.", // Přírodní vědy
  "PharmDr.", // Farmacie
  "thdr.", "ThDr.", // Teologie (starší doktorát)
  "ThLic.", // Licenciát teologie

  // === Akademické hodnosti (vědecko-pedagogické) ===
  "doc.", "Doc.", // Docent
  "prof.", "Prof.", // Profesor
  "akad.", // akademik (nejvyšší vědecká hodnost ČSAV, již se neuděluje)

  // === Čestné tituly ===
  "dr. h. c.", // Doctor honoris causa

  // === Vojenské hodnosti ===
  // Mužstvo
  "voj.", "svob.",
  // Poddůstojníci
  "des.", "čet.", "rtn.",
  // Praporčíci
  "rtm.", "nrtm.", "prap.", "nprap.", "šprap.",
  // Nižší důstojníci
  "por.", "npor.", "kpt.",
  // Vyšší důstojníci
  "mjr.", "pplk.", "pplk. gšt.", "plk.", "plk. gšt.",
  // Generálové
  "brig.gen.", "genmjr.", "genpor.", "arm.gen.",
  // === Policejní hodnosti (mimo již zavedené) ===
  "stržm.", "nstržm.", "pprap.", "ppor.",

  // === Zkratky ===
  "aj.", "apod.", "atd.", "atp.", "cca", "č.", "čj.", "kupř.", "mj.",
  "např.", "popř.", "pozn.", "př.", "příp.", "resp.", "s.", "str.", "sv.",
  "tj.", "tzv.", "tzn.", "viz", "zvl.",
)

// --- 3. Tituly ZA jménem -----------------------------------------------------
#let after-list = (
  "DiS.",
  "Ph.D.", // Doktor (vědecký, standardní)
  "PhD.", // zahraniční varianta
  "PhD", // zahraniční varianta bez teček
  "Th.D.", // Doktor teologie (vědecký)
  "CSc.", // Kandidát věd (dobíhá)
  "DrSc.", // Doktor věd (dobíhá)
  "DSc.", // Doktor věd (UK a AV ČR)
  "MBA", "LL.M.", "MSc.",
)

// --- Sestavení vzorů ---------------------------------------------------------
#let escape-dot(t) = t.replace(".", "\\.")

// Alternace: delší varianty první (jinak by „pplk." vyhrálo nad „pplk. gšt."
// a „Ing." nad „Ing. arch."). Položky NEkončící tečkou dostanou koncovou
// hranici slova, aby „PhD" nechytalo začátek „PhDr." ani „viz" slovo „vize".
#let alternation(list) = {
  list
    .sorted(key: t => -t.len())
    .map(t => escape-dot(t) + if not t.ends-with(".") { "\\>" } else { "" })
    .join("|")
}

#let before-pattern = regex("\\<(" + alternation(before-list) + ") ")
#let after-pattern = regex(" (" + alternation(after-list) + ")")

#let nbsp = "\u{00a0}"

// --- Aplikace ----------------------------------------------------------------
#let apply-vlna(doc, debug: false) = {
  // Všechna pravidla dělají totéž: každou mezeru ve shodě promění
  // v nezlomitelnou. U „dr. h. c. Novák" tím sváže i vnitřní mezery.
  let glue(color) = if debug {
    it => box(stroke: .5pt + color, outset: 1.5pt, it.text.replace(" ", nbsp))
  } else {
    it => it.text.replace(" ", nbsp)
  }

  show short-word: glue(purple)
  show before-pattern: glue(green)
  show after-pattern: glue(blue)

  // Volitelně (odkomentovat dle potřeby):
  // // číslo + % / jednotka:  „10 %" → „10~%"
  // show regex("(\d) (%|‰|Kč|km|kg|mm|cm|m|s|h)\>"): glue(orange)

  doc
}
