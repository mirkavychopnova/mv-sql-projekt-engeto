# Mirka Vychopnova Projekt - SQL Analýza

## Popis

Tento projekt se zaměřuje na analýzu dat týkajících se průměrných mezd a cen potravin v České republice v průběhu několika let. Projekt využívá SQL k dotazování a zpracování dat z různých tabulek obsahujících informace o mzdách, cenách potravin, HDP a dalších ekonomických ukazatelích.

1. **Základní dataset**:
   - V této části projektu je vytvořen základní dataset spojením několika tabulek obsahujících informace o mzdách a cenách potravin v České republice.
   - SQL příkaz `CREATE OR REPLACE TABLE` vytváří novou tabulku, která je výsledkem spojení potřebných dat.
   - Používají se klauzule `INNER JOIN` k propojení tabulek podle odpovídajících sloupců.

2. **Otázka č. 1**:
   - Pro analýzu trendů v mzdách je vytvořena dočasná tabulka 'yearly_totals', která agreguje průměrné mzdy podle odvětví a roku.
   - Pomocí funkce 'LAG' se určuje předchozí roční úroveň mzdových dat.
   - Výsledky jsou klasifikovány do kategorií 'Rostoucí mzda' nebo 'Klesající mzda' na základě srovnání s předchozím rokem.

3. **Otázka č. 2**:
   - Tato část se zabývá výpočtem, kolik litrů mléka a kilogramů chleba je možné koupit za první a poslední srovnatelné období v dostupných datech.
   - Jsou vybrány konkrétní kategorie potravin a spojeny s odpovídajícími mzdovými údaji.

4. **Otázka č. 3**:
   - Pro identifikaci kategorie potravin s nejpomalejším růstem cen je vytvořena dočasná tabulka 'price_yearly_totals'.
   - Pomocí funkce 'LAG' se určuje předchozí roční úroveň cen potravin.
   - Výsledky jsou klasifikovány jako 'Růst ceny' nebo 'Pokles ceny' na základě procentuálního meziročního nárůstu.

5. **Otázka č. 4**:
   - Tato část provádí analýzu existujícího roku, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd.
   - Používá se dočasná tabulka 'price_sallary_yearly_totals', která agreguje data o cenách potravin a mzdách podle roku a odvětví.
   - Jsou hledány roky, kdy byl rozdíl mezi procentuálním nárůstem cen potravin a mzdami vyšší než 10 %.

6. **Základní dataset pro GDP**:
   - V této části je vytvořen dataset obsahující ekonomické údaje, jako je HDP, gini index, daně, plodnost, úmrtnost, aj.
   - Přistupuje se k propojení tabulek obsahujících údaje o ekonomikách a zemích.

7. **Otázka č. 5**:
   - Poslední část se zaměřuje na analýzu vlivu výše HDP na změny ve mzdách a cenách potravin.
   - Výsledky HDP jsou kombinovány s mzdovými a cenovými daty pomocí spojení SQL tabulek.
   - Procentuální změny mezd a cen potravin jsou porovnávány s procentuálními změnami HDP.
