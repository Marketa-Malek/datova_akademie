# prvni_projekt
První repozitář pro první projekt SQL


--- vytvoření tabulky ----
CREATE TABLE t_marketa_malek_project_SQL_primary_final as
SELECT
	cpc.name AS food_category,
	cp.value AS food_price,
	cpib.name,
	cpay.value,
	cp.category_code,
	cpay.payroll_year
FROM czechia_price cp 
JOIN czechia_payroll cpay 
	ON cpay.payroll_year = YEAR (cp.date_from)
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cpay.industry_branch_code = cpib.code 
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code 
WHERE cpay.value_type_code = 5958
	AND cp.region_code IS NULL
;

---- NOVÁ TABULKA ---
CREATE TABLE t_marketa_malek_project_SQL_primary_final AS
SELECT
	cpc.name AS food_category,
	cp.value AS food_price,
	cpib.name AS industry,
	cpay.value AS salary,
	cp.category_code,
	cpay.payroll_year,
	cp.region_code
FROM czechia_price cp 
JOIN czechia_payroll cpay 
	ON cpay.payroll_year = YEAR(cp.date_from)
JOIN czechia_payroll_industry_branch cpib 
	ON cpay.industry_branch_code = cpib.code 
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code 
WHERE cpay.value_type_code = 5958
	AND cp.region_code IS NULL
GROUP BY cpay.payroll_year, cp.category_code, cpay.industry_branch_code;

1. otázka
  Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
    Co potřebuji vědět?
      * roky
      * mzdy
      * odvětví


2. otázka

Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

--- MLÉKO ---

SELECT
	food_category,
	food_price,
	payroll_year,
	value,
	round (value/food_price,2) AS pocet_ks
FROM t_marketa_malek_project_sql_primary_final tmmpspf 
WHERE category_code = 114201
GROUP BY payroll_year

Sammostatný sloupeček pro počet ks (litrů) na jednotlivé roky

--- CHLÉB ---

SELECT
	food_category,
	food_price,
	payroll_year,
	value,
	round (value/food_price,2) AS pocet_ks
FROM t_marketa_malek_project_sql_primary_final tmmpspf 
WHERE category_code = 111301
GROUP BY payroll_year;




