# Mirka Vychopnova Projekt - SQL Analýza

## Popis

Tento projekt se zaměřuje na analýzu dat týkajících se průměrných mezd a cen potravin v České republice v průběhu několika let. Projekt využívá SQL k dotazování a zpracování dat z různých tabulek obsahujících informace o mzdách, cenách potravin, HDP a dalších ekonomických ukazatelích.

**Základní dataset**:
   - V této části projektu je vytvořen základní dataset spojením několika tabulek obsahujících informace o mzdách a cenách potravin v České republice.
   - SQL příkaz `CREATE OR REPLACE TABLE` vytváří novou tabulku, která je výsledkem spojení potřebných dat.
   - Používají se klauzule `INNER JOIN` k propojení tabulek podle odpovídajících sloupců.

---

**Otázka č. 1**:
   - Pro analýzu trendů v mzdách je vytvořena dočasná tabulka 'yearly_totals', která agreguje průměrné mzdy podle odvětví a roku.
   - Pomocí funkce 'LAG' se určuje předchozí roční úroveň mzdových dat.
   - Výsledky jsou klasifikovány do kategorií 'Rostoucí mzda' nebo 'Klesající mzda' na základě srovnání s předchozím rokem.
  
**Výsledky**
- Odvětví s klesajícími mzdami:
  - Zemědělství, lesnictví, rybářství (2009)
  - Těžba a dobývání (2009, 2013, 2014, 2016)
  - Ubytování, stravování a pohostinství (2009, 2011)
  - Profesní, vědecké a technické činnosti (2010, 2013)
  - Veřejná správa a obrana; povinné sociální zabezpečení (2010, 2011)
  - Vzdělávání (2010)
  - Kulturní, zábavní a rekreační činnosti (2011, 2013)
  - Výroba a rozvod elektřiny, plynu, tepla a klimatizace (2013)
  - Zásobování vodou; činnosti související s odpady a sanacemi (2013)
  - Stavebnictví (2013)
  - Velkoobchod a maloobchod; opravy a údržba motorových vozidel (2013)
  - Informační a komunikační činnosti (2013)
  - Peněžnictví a pojišťovnictví (2013)
  - Činnosti v oblasti nemovitostí (2013)
  - Administrativní a podpůrné činnosti (2013)
   
**Závěr**

Analýza ukazuje, že v některých letech docházelo k poklesu průměrných mezd v několika odvětvích. Nejvíce postiženým rokem byl rok 2013, kdy došlo k poklesu mezd v mnoha různých odvětvích. Tyto výsledky mohou naznačovat ekonomické výzvy nebo specifické problémy v daných odvětvích během analyzovaných období.

---

**Otázka č. 2**:
   - Tato část se zabývá výpočtem, kolik litrů mléka a kilogramů chleba je možné koupit za první a poslední srovnatelné období v dostupných datech.
   - Jsou vybrány konkrétní kategorie potravin a spojeny s odpovídajícími mzdovými údaji.
  
**Výsledky**

**Chléb**

- Nejvyšší nárůst kupní síly: "Informační a komunikační činnosti" (nárůst z 2193 ks na 2314 ks), což ukazuje na významné zvýšení kupní síly v tomto odvětví.
- Peněžnictví a pojišťovnictví: Pokles z 2461 ks na 2232 ks, což je jeden z mála sektorů s výrazným poklesem kupní síly.
- Profesní, vědecké a technické činnosti: Mírný nárůst z 1480 ks na 1570 ks.
- Stavebnictví: Nárůst z 1100 ks na 1154 ks.
- Ubytování, stravování a pohostinství: Malý nárůst z 706 ks na 774 ks, což je nejnižší úroveň mezi všemi sektory.
- Veřejná správa a obrana; povinné sociální zabezpečení: Nárůst z 1430 ks na 1485 ks.
- Výroba a rozvod elektřiny, plynu, tepla a klimatizace: Výrazný nárůst z 1788 ks na 1905 ks.
- Zemědělství, lesnictví, rybářství: Nárůst z 906 ks na 1043 ks.
- Zdravotní a sociální péče: Nárůst z 1147 ks na 1351 ks.

**Mléko**

- Nejvyšší nárůst kupní síly: "Informační a komunikační činnosti" (nárůst z 2449 litrů na 2830 litrů), což ukazuje na výrazné zvýšení kupní síly v tomto odvětví.
- Peněžnictví a pojišťovnictví: Mírný pokles z 2749 litrů na 2730 litrů.
- Profesní, vědecké a technické činnosti: Výrazný nárůst z 1653 litrů na 1921 litrů.
- Stavebnictví: Nárůst z 1229 litrů na 1412 litrů.
- Těžba a dobývání: Nárůst z 1665 litrů na 1816 litrů.
- Ubytování, stravování a pohostinství: Mírný nárůst z 788 litrů na 947 litrů, což je stále nejnižší úroveň mezi všemi sektory.
- Velkoobchod a maloobchod; opravy a údržba motorových vozidel: Nárůst z 1237 litrů na 1483 litrů.
- Veřejná správa a obrana; povinné sociální zabezpečení: Výrazný nárůst z 1597 litrů na 1817 litrů.
- Výroba a rozvod elektřiny, plynu, tepla a klimatizace: Výrazný nárůst z 1997 litrů na 2330 litrů.
- Vzdělávání: Nárůst z 1323 litrů na 1500 litrů.
- Zásobování vodou; činnosti související s odpady a sanacemi: Nárůst z 1280 litrů na 1438 litrů.
- Zdravotní a sociální péče: Nárůst z 1281 litrů na 1652 litrů.
- Zemědělství, lesnictví, rybářství: Nárůst z 1012 litrů na 1276 litrů.
- Zpracovatelský průmysl: Nárůst z 1272 litrů na 1603 litrů.

**Závěr**

Tabulka ukazuje obecný trend růstu kupní síly zaměstnanců napříč většinou odvětví mezi lety 2006 a 2018, s několika výjimkami. Tento růst je nejvýraznější v odvětvích jako "Informační a komunikační činnosti" a "Výroba a rozvod elektřiny, plynu, tepla a klimatizace". Naopak některá odvětví, jako "Peněžnictví a pojišťovnictví", zaznamenala pokles kupní síly.

---

**Otázka č. 3**:
   - Pro identifikaci kategorie potravin s nejpomalejším růstem cen je vytvořena dočasná tabulka 'price_yearly_totals'.
   - Pomocí funkce 'LAG' se určuje předchozí roční úroveň cen potravin.
   - Výsledky jsou klasifikovány jako 'Růst ceny' nebo 'Pokles ceny' na základě procentuálního meziročního nárůstu.

**Výsledky**
- Rostlinný roztíratelný tuk (2009)

**Závěr**

Nejpomaleji zdražuje kategorie Rostlinný roztíratelný tuk, a to zhruba o 0,016 %.

---

**Otázka č. 4**:
   - Tato část provádí analýzu roku, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd.
   - Používá se dočasná tabulka 'price_sallary_yearly_totals', která agreg

uje data o cenách potravin a mzdách podle roku a odvětví.
   - Jsou hledány roky, kdy byl rozdíl mezi procentuálním nárůstem cen potravin a mezd vyšší než 10 %.

**Výsledky**

- 2007
- 2008
- 2009
- 2010
- 2011
- 2012
- 2013
- 2014
- 2015
- 2016
- 2017
- 2018

**Závěr**

Data ukazují, že potraviny zdražují rychleji, než se zvyšuje cena mezd.

---

**Základní dataset pro HDP**:
   - V této části je vytvořen dataset obsahující ekonomické údaje, jako je HDP, gini index, daně, plodnost, úmrtnost a další.
   - Přistupuje se k propojení tabulek obsahujících údaje o ekonomikách a zemích.

---

**Otázka č. 5**:
   - Poslední část se zaměřuje na analýzu vlivu výše HDP na změny ve mzdách a cenách potravin.
   - Výsledky HDP jsou kombinovány s mzdovými a cenovými daty pomocí spojení SQL tabulek.
   - Procentuální změny mezd a cen potravin jsou porovnávány s procentuálními změnami HDP.
  
**Výsledky**
![image](https://github.com/mirkavychopnova/mv-sql-projekt-engeto/assets/153125736/c43aa6ba-f48a-4249-a9f2-697e30225f5f)

**Závěr**

Z grafu je patrné, že existuje určitá korelace mezi růstem HDP, mezd a cen potravin. Výjimkou byl rok 2009, kdy byl výraznější pokles cen potravin, ale výše mezd se oproti roku 2008 prakticky nezměnila. Můžeme to přisuzovat celosvětové finanční krizi.
