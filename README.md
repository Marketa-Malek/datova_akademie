# prvni_projekt
První repozitář pro první projekt SQL


--- Tabulka 0.1 ----
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

---- TABULKA 0.2 ---
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
      
SELECT 
	payroll_year,
	industry,
	salary
FROM t_marketa_malek_project_sql_primary_final tmmpspf 
GROUP BY industry, payroll_year

Odpověď: Rostou.


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

Sammostatný sloupeček pro počet ks (litrů) na jednotlivé roky.

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

Sammostatný sloupeček pro počet ks (litrů) na jednotlivé roky.

3. otázka

Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

SELECT 
	t1.category_code,
	t1.food_category,
	t1.payroll_year,
	t1.food_price AS ceny2,
	t2.food_price AS ceny1,
	round (avg(t1.food_price),2) AS prumer_ceny,
	round((t1.food_price-t2.food_price)/t2.food_price *100,2) AS percent_grow
FROM t_marketa_malek_project_sql_primary_final AS t1
JOIN  t_marketa_malek_project_sql_primary_final AS t2
	ON t1.payroll_year = t2.payroll_year + 1
GROUP BY t1.category_code, t1.payroll_year
;

4. otázka

Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

CREATE VIEW v_ctvrta_otazka AS;
SELECT
	t1.payroll_year AS year1,
	t2.payroll_year,
	round (avg(t1.food_price),2) AS prumer_ceny,
	round (avg(t1.salary),2) AS prumer_mezd,
	round ((avg(t1.food_price) - avg(t2.food_price))/avg(t2.food_price)*100,2) AS price_grow,
	round ((avg(t1.salary)-avg(t2.salary))/ avg(t2.salary)* 100,2) AS salary_grow
FROM t_marketa_malek_project_sql_primary_final AS t1
JOIN t_marketa_malek_project_sql_primary_final AS t2
	ON t1.payroll_year = t2.payroll_year + 1
GROUP BY t1.payroll_year
;
	
SELECT 
	payroll_year,
	price_grow,
	salary_grow,
	salary_grow - price_grow AS difference
FROM v_ctvrta_otazka vco
ORDER BY difference DESC
;


