-- Základní dataset
CREATE OR REPLACE TABLE t_mirka_vychopnova_project_SQL_primary_final AS (
SELECT *
FROM 
    (SELECT 
         cp.payroll_year AS payroll_year,
         AVG(cp.value) AS czechia_payroll_avg_value,
         cpib.name AS czechia_payroll_industry_branch_name,
         cpib.code AS czechia_payroll_industry_branch_code,
         cpc.name AS czechia_payroll_calculation_name,
         cpc.code AS czechia_payroll_calculation_code,
         cpu.name AS czechia_payroll_unit_name,
         cpu.code AS czechia_payroll_unit_code,
         cpvt.name AS czechia_payroll_value_type_name,
         cpvt.code AS czechia_payroll_value_type_code
     FROM czechia_payroll cp 
     INNER JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
     INNER JOIN czechia_payroll_calculation cpc ON cp.calculation_code = cpc.code 
     INNER JOIN czechia_payroll_unit cpu ON cp.unit_code = cpu.code 
     INNER JOIN czechia_payroll_value_type cpvt ON cp.value_type_code = cpvt.code
     WHERE cp.value_type_code = '5958'
     GROUP BY
         cp.payroll_year,
         cpib.name) AS payroll
INNER JOIN 
    (SELECT 
         YEAR(cp.date_from) AS price_year,
         AVG(cp.value) AS czechia_price_avg_value,
         cp.category_code AS czechia_price_category_code,
         cpc.name AS czechia_price_category_name,
         cpc.price_value AS czechia_price_category_price_value,
         cpc.price_unit AS czechia_price_category_price_unit,
         cr.name AS czechia_region_name,
         cr.code AS czechia_region_code
     FROM czechia_price cp
     INNER JOIN czechia_price_category cpc ON cp.category_code = cpc.code
     INNER JOIN czechia_region cr ON cp.region_code = cr.code
     GROUP BY
         YEAR(cp.date_from),
         cpc.name) AS price 
ON payroll.payroll_year = price.price_year);



-- Otázka č. 1 ------------------------------------------------------------------
-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
WITH yearly_totals AS (
SELECT
  czechia_payroll_industry_branch_code,
  czechia_payroll_industry_branch_name,
  payroll_year,
  SUM(czechia_payroll_avg_value) AS total_avg_value,
  LAG(SUM(czechia_payroll_avg_value)) OVER (PARTITION BY czechia_payroll_industry_branch_code ORDER BY payroll_year) AS previous_year_total
FROM t_mirka_vychopnova_project_SQL_primary_final
WHERE czechia_payroll_avg_value IS NOT NULL
GROUP BY
  czechia_payroll_industry_branch_code,
  czechia_payroll_industry_branch_name,
  payroll_year
)
SELECT
  czechia_payroll_industry_branch_code,
  czechia_payroll_industry_branch_name,
  payroll_year,
  total_avg_value,
  CASE
      WHEN total_avg_value < previous_year_total THEN 'Klesající mzda'
      ELSE 'Rostoucí mzda'
  END AS profit_status
FROM yearly_totals
ORDER BY
    czechia_payroll_industry_branch_code,
    payroll_year;

-- Otázka č. 2 ------------------------------------------------------------------
-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
SELECT
  payroll_year,
  czechia_payroll_avg_value,
  czechia_payroll_unit_name,
  czechia_payroll_industry_branch_name,
  czechia_price_avg_value,
  czechia_price_category_name,
  czechia_price_category_price_value,
  czechia_price_category_price_unit,
  FLOOR(czechia_payroll_avg_value / czechia_price_avg_value) AS yearly_avr_payroll_vs_avg_price
FROM t_mirka_vychopnova_project_SQL_primary_final
WHERE
   czechia_price_category_code IN ('114201', '111301');
 
-- Otázka č. 3 ------------------------------------------------------------------
-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
WITH price_yearly_totals AS (
    SELECT
        czechia_price_category_name,
        czechia_price_category_code,
        price_year,
        SUM(czechia_price_avg_value) AS total_price_avg_value,
        LAG(SUM(czechia_price_avg_value)) OVER (PARTITION BY czechia_price_category_code ORDER BY price_year) AS previous_year_price
    FROM 
        t_mirka_vychopnova_project_SQL_primary_final tmvpspf
    WHERE
        czechia_price_avg_value IS NOT NULL
    GROUP BY
        czechia_price_category_name,
        czechia_price_category_code,
        price_year
)
SELECT
    czechia_price_category_code,
    czechia_price_category_name,
    price_year,
    total_price_avg_value,
    (total_price_avg_value / LAG(total_price_avg_value) OVER (PARTITION BY czechia_price_category_code ORDER BY price_year) - 1) * 100 AS percent_change,
    CASE
        WHEN total_price_avg_value < previous_year_price THEN 'Pokles ceny'
        ELSE 'Růst ceny'
    END AS price_status
FROM 
    price_yearly_totals
ORDER BY
  percent_change DESC;

-- Otázka č. 4 ------------------------------------------------------------------
-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)
WITH price_sallary_yearly_totals AS (
    SELECT
        czechia_price_category_name,
        czechia_price_category_code,
        price_year,
        SUM(czechia_price_avg_value) AS total_price_avg_value,
        LAG(SUM(czechia_price_avg_value)) OVER (PARTITION BY czechia_price_category_code ORDER BY price_year) AS previous_year_price,
        czechia_payroll_industry_branch_code,
        czechia_payroll_industry_branch_name,
        payroll_year,
        SUM(czechia_payroll_avg_value) AS total_avg_value,
        LAG(SUM(czechia_payroll_avg_value)) OVER (PARTITION BY czechia_payroll_industry_branch_code ORDER BY payroll_year) AS previous_year_total
    FROM 
        t_mirka_vychopnova_project_SQL_primary_final tmvpspf
    WHERE
        czechia_price_avg_value IS NOT NULL
    GROUP BY
        czechia_price_category_name,
        czechia_price_category_code,
        price_year,
        czechia_payroll_industry_branch_code,
        czechia_payroll_industry_branch_name,
        payroll_year
)
SELECT DISTINCT
    price_year
FROM (
    SELECT
        price_year,
        ABS(((total_price_avg_value - previous_year_price) / previous_year_price) * 100 - ((total_avg_value - previous_year_total) / previous_year_total) * 100) AS difference
    FROM 
        price_sallary_yearly_totals
) AS differences
WHERE difference > 10
ORDER BY
    price_year;

-- Základní dataset pro GDP
CREATE OR REPLACE TABLE t_mirka_vychopnova_project_SQL_secondary_final AS (
SELECT 
  c.*,
  e.YEAR,
  e.GDP,
  e.gini,
  e.taxes,
  e.fertility,
  e.mortaliy_under5
FROM economies e
INNER JOIN countries c ON e.country = c.country)

-- Otázka č. 5 ------------------------------------------------------------------
-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

WITH CZ_GDP AS (
    SELECT 
        year,
        GDP,
        LAG(GDP) OVER (ORDER BY year) AS previous_year_gdp,
        CASE
            WHEN LAG(GDP) OVER (ORDER BY year) IS NOT NULL AND GDP != 0 THEN ROUND(((GDP - LAG(GDP) OVER (ORDER BY year)) / LAG(GDP) OVER (ORDER BY year)) * 100, 2)
            ELSE NULL
        END AS gdp_year_on_year_percentage_change
    FROM t_mirka_vychopnova_project_SQL_secondary_final
    WHERE abbreviation = 'CZ'
),
yearly_totals AS (
    SELECT
        czechia_payroll_industry_branch_code,
        czechia_payroll_industry_branch_name,
        payroll_year,
        SUM(czechia_payroll_avg_value) AS total_avg_value,
        LAG(SUM(czechia_payroll_avg_value)) OVER (PARTITION BY czechia_payroll_industry_branch_code ORDER BY payroll_year) AS previous_year_total
    FROM 
        t_mirka_vychopnova_project_SQL_primary_final tmvpspf
    WHERE
        czechia_payroll_avg_value IS NOT NULL
    GROUP BY
        czechia_payroll_industry_branch_code,
        czechia_payroll_industry_branch_name,
        payroll_year
),
price_yearly_totals AS (
    SELECT
        czechia_price_category_name,
        czechia_price_category_code,
        price_year,
        SUM(czechia_price_avg_value) AS total_price_avg_value,
        LAG(SUM(czechia_price_avg_value)) OVER (PARTITION BY czechia_price_category_code ORDER BY price_year) AS previous_year_price
    FROM 
        t_mirka_vychopnova_project_SQL_primary_final tmvpspf
    WHERE
        czechia_price_avg_value IS NOT NULL
    GROUP BY
        czechia_price_category_name,
        czechia_price_category_code,
        price_year
)
SELECT
    gdp.year AS year,
    gdp.GDP AS gdp,
    gdp.gdp_year_on_year_percentage_change,
    ROUND(CASE
        WHEN totals.previous_year_total IS NOT NULL AND totals.previous_year_total != 0 
        THEN ((totals.total_avg_value - totals.previous_year_total) / totals.previous_year_total) * 100
        ELSE NULL
    END, 2) AS payroll_year_on_year_percentage_change,
    ROUND(CASE
        WHEN price_totals.previous_year_price IS NOT NULL AND price_totals.previous_year_price != 0 
        THEN ((price_totals.total_price_avg_value - price_totals.previous_year_price) / price_totals.previous_year_price) * 100
        ELSE NULL
    END, 2) AS price_year_on_year_percentage_change
FROM CZ_GDP gdp
JOIN yearly_totals totals ON gdp.year = totals.payroll_year
JOIN price_yearly_totals price_totals ON gdp.year = price_totals.price_year
ORDER BY gdp.year;
