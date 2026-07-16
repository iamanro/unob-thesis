# Changelog

Všechny významné změny šablony `unob-thesis`. Formát vychází z
[Keep a Changelog](https://keepachangelog.com/cs/1.0.0/),
verzování dle [SemVer](https://semver.org/lang/cs/).

## [0.3.0] – 2026-07-16

Verze odladěná v reálném nasazení na disertační práci. Přináší přepis glosáře,
odstranění externích závislostí a řadu oprav sazby.

### Přidáno
- **Centralizovaná typografie v `src/config.toml`** – velikosti nadpisů, písma,
  řádkování a odsazení odstavce, okraje (vč. `[page.draft]`), sazba tabulek,
  mezery seznamů, barva nebarevných odkazů, titulní strana a barvy fakult jsou
  na jednom místě (načítá je `src/config.typ`), místo roztroušených hodnot ve
  `styling/*`. Chování oproti 0.2.0 zůstává identické (ověřeno pixelovým diffem).
- **`flex-caption`** – popisky obrázků a tabulek ve dvou verzích: dlouhá
  (název + zdroj) pod objektem, krátká (jen název) v Seznamu obrázků / tabulek.
  Exportováno z `lib.typ` a napojeno na generované seznamy.
- **Číselný citační styl** `src/assets/csl/numeric.csl` (vedle `harvard.csl`)
  pro číslované citace ve tvaru `[1]`.
- **Klikací prolinky glosáře** – výskyt `#trm(...)` v textu odkazuje na příslušnou
  položku v Seznamu zkratek / pojmů (pokud existuje).

### Změněno
- **Glosář přepsán na bezstavovou implementaci** (`internal/glossary/*`) stavějící
  na `query`/`context` a registru položek. Chování v seznamech je předvídatelnější
  a nezávisí na pořadí zpracování.
- **Přepracovaná titulní strana** (`cover.typ`) – zjednodušené a konzistentnější
  rozvržení a velikosti (hlavička fakulta/program/specializace, výška loga,
  pevné mezery).
- **Sazba příloh** – značka „PŘÍLOHA A" tučně + název normální vahou, bez
  tečkového vodiče; z názvů příloh v seznamu se odstraní poznámky pod čarou.
- **Oboustranný tisk** – kapitoly začínají vždy na lichém (pravém) listu;
  dorovnávací vakát je bez patičky a bez čísla stránky.
- **Knižní styl tabulek** – popisek nad tabulkou, bez oddělovače.
- `assignment_front` / `assignment_back` nově přijímají i `false` (strana zadání
  se vůbec nevysází), nejen `none` nebo obsah.
- Matematická sazba má fallback na písmo „New Computer Modern Math".

### Opraveno
- **Prázdný OBSAH** – nesoulad `supplement` mezi nadpisy a generováním obsahu
  vedl k tichému vysázení prázdného OBSAHu; sjednoceno.
- **Spolknuté chybové hlášky glosáře** – hlášky v hodnotové pozici se maskovaly
  pozdější typovou chybou; nahrazeno přímými `panic` s dvojjazyčným textem.

### Odstraněno
- Závislost na balíčku `@preview/glossarium` (nahrazena vlastním glosářem).
- Závislost na balíčku `@preview/vlna` – nahrazena vlastní `apply-vlna`
  (`src/styling/vlna.typ`), která navíc ošetřuje dvoupísmenná slova, tituly
  před/za jménem a zkratky (nezlomitelné mezery).

## [0.2.0]

Výchozí publikovaná verze šablony (glosář postavený na `@preview/glossarium`,
zalamování přes `@preview/vlna`).

[0.3.0]: https://github.com/iamanro/unob-thesis/releases/tag/v0.3.0
[0.2.0]: https://github.com/iamanro/unob-thesis/releases/tag/v0.2.0
