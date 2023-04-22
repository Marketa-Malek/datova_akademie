### SQL_projekt


# --- **Tabulka 0.1** ----
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

Následná úprava o další data --> upgrade na 0.2

# ---- **TABULKA 0.2** ---
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

## **1. otázka**
  Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
    Co potřebuji vědět?
      - roky
      - mzdy
      - odvětví
      
SELECT 
	payroll_year,
	industry,
	salary
FROM t_marketa_malek_project_sql_primary_final AS t1 
GROUP BY industry, payroll_year;

**Odpověď**: Nárůst byl od 8 000 Kč a výše. Nejvíce se objevule kolem 10 000 Kč. Objevuje se i vyšší a to přes 23 000 Kč (infor. a kom. činnosti).


## **2. otázka**

Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Co potřebuji vědět?
	- category_code pro danou potravinu
	- mzdy
	- cenu potraviny
	- vypsané roky

--- MLÉKO ---

SELECT
	food_category,
	food_price,
	payroll_year,
	salary,
	round (salary/food_price,2) AS quantity
FROM t_marketa_malek_project_sql_primary_final AS t1 
WHERE category_code = 114201
GROUP BY payroll_year;

Sammostatný sloupeček pro počet ks (litrů) na jednotlivé roky. 
**Odpověď**: V rozmezí 809 - 1 358 l.

--- CHLÉB ---

SELECT
	food_category,
	food_price,
	payroll_year,
	salary,
	round (salary/food_price,2) AS quantity
FROM t_marketa_malek_project_sql_primary_final AS t1 
WHERE category_code = 111301
GROUP BY payroll_year;

Samostatný sloupeček pro počet ks na jednotlivé roky. 
**Odpověď**: V rozmezí 624 - 1 082 ks.
Tato otázka byla konečně příjemná a snad je správně, protože mi zabrala nejméně času. Možná by bylo lepší mít ceny zprůměrované, ale uvidím, zda je i toto správná cesta.

## **3. otázka**

Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Co potřebuji vědet?
	- napojení tabulek pomocí payroll_year pro spočítání meziročního růstu
	- kategorie potravin
	- cenu potravin
	- meziroční nárůst v procentech

SELECT 
	t1.category_code,
	t1.food_category,
	t1.payroll_year,
	t1.food_price AS ceny2,
	t2.food_price AS ceny1,
	round (avg(t1.food_price),2) AS average_price,
	round((t1.food_price-t2.food_price)/t2.food_price *100,2) AS percent_grow
FROM t_marketa_malek_project_sql_primary_final AS t1
JOIN  t_marketa_malek_project_sql_primary_final AS t2
	ON t1.payroll_year = t2.payroll_year + 1
GROUP BY t1.category_code, t1.payroll_year
;

**Odpověď**:
Nejnižší hodnota procentuálního růstu:
Jogurt bílý netučný	2009	-84.13

Nejvyšší hodnota procentuálního růstu:
Hovězí maso zadní bez kosti	2007	702.5

Nad touhle jsem se trápila asi 3 dny. Nevím zda je dobře, dělala jsem, co jsem mohla x_x

## **4. otázka**

Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Co potřebuji vědět?
	- meziroční nárůsty mezd v procentech
	- meziroční nárůsty cen v procentech
	- rozdíl mezi procentuálními růsty

CREATE VIEW v_fourth_question AS 
SELECT
	t1.payroll_year AS year1, 
	t2.payroll_year, 
	round (avg(t1.food_price),2) AS average_price, 
	round (avg(t1.salary),2) AS average_salary,
	round ((avg(t1.food_price) - avg(t2.food_price))/avg(t2.food_price)*100,2) AS price_grow,
	round ((avg(t1.salary)-avg(t2.salary))/ avg(t2.salary)*100,2) AS salary_grow 
FROM t_marketa_malek_project_sql_primary_final AS t1 
JOIN t_marketa_malek_project_sql_primary_final AS t2 
	ON t1.payroll_year = t2.payroll_year + 1 
GROUP BY t1.payroll_year;

SELECT 
	payroll_year, 
	price_grow,
	salary_grow, 
	salary_grow - price_grow AS difference 
FROM v_fourth_question AS v1
ORDER BY difference DESC

**Odpověď**: 
Nejvyšší hodnota v roce 2008 je 11,64.
Nejnižší hodnota je v roce 2012 -8,98.
	
Něco ve stylu otázky číslo 3 :(

## **5. otázka**

Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

Zde jsem si napojila tabulku economies pro přidání dat s GDP. Napojení tabulky economies samu na sebe pro meziroční procentuální růst. Využila jsem vytvořeného view z předchozí otázky pro snadnější tvoření příkazu.

SELECT 
	e.country,
	e.`year`,
	e2.`year`,
	round(e.GDP,0) AS GDP,
	round(e2.GDP,0) AS GDP2,
	average_price,
	average_salary,
	round ((e.GDP - e2.GDP)/ e2.GDP * 100,2) AS GDP_grow,
	price_grow,
	salary_grow
FROM economies e
JOIN v_fourth_question AS v1
	ON e.`year` = v1.payroll_year
JOIN economies e2 
	ON e.`year` = e2.`year`+1
WHERE e.country = 'Czech republic'
	AND e2.country = 'Czech republic'
	AND e.`year` BETWEEN 2006 AND 2019
	AND e2.`year` BETWEEN 2006 AND 2019
GROUP BY e.`year`

**Odpověď** V některých letech měl nárůst GDP projev na mzdy, jinde následují rok na cenu potravin.

Práce na projektu byla jako cesta do Mordoru. Je mi jasné, že prvním odevzdáním cesta nekončí. Ráda si chyby opravím a byla bych ráda za případnou zpětnou vazbu :).

