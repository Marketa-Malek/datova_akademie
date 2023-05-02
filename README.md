# SQL_projekt


# Tabulka 0.1
CREATE TABLE t_marketa_malek_project_SQL_primary_final as

```
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
	AND cp.region_code IS NULL;
```

Následná úprava o další data --> upgrade na 0.2

# TABULKA 0.2
CREATE TABLE t_marketa_malek_project_SQL_primary_final AS

```
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
```

# **1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**
  
   Co potřebuji vědět?
      - roky
      - mzdy
      - odvětví
      
```
CREATE OR REPLACE VIEW v_first_question AS
SELECT
	t1.payroll_year,
	t1.industry,
	t1.salary,
	t2.salary AS salary_previous,
	t1.salary - t2.salary AS diference
FROM (
	SELECT 
		payroll_year,
		industry,
		ROUND (AVG(salary),0) AS salary
	FROM t_marketa_malek_project_sql_primary_final AS t1 
	GROUP BY industry, payroll_year) AS t1 
LEFT JOIN (SELECT 
		payroll_year,
		industry,
		ROUND (AVG(salary),0) AS salary
	FROM t_marketa_malek_project_sql_primary_final 
	GROUP BY industry, payroll_year) AS t2
	ON t1.payroll_year = t2.payroll_year + 1
	AND t1.industry = t2.industry
GROUP BY industry, payroll_year

SELECT 
	industry,
	round(SUM(diference), 0) AS total_salary_growth
FROM v_first_question AS v1
GROUP BY industry;
```

**Odpověď:** 
- Nejnižší nárůst byl v kategorii: Ubytování, stravování a pohostinství, a to 7 928 Kč. 
- Do 10 000 Kč byl nárůst v administrativě, peněžnictví a pojišťovnictví, ostatních činnostech a v oblasti nemovitostí. 
- Nejvyšší nárůst byl v informační a komunikační činnosti s 23 739 Kč. Zbylá odvětví měla nárůst od 10 000 do 16 876 Kč. 


# **2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

Co potřebuji vědět?
	- category_code pro danou potravinu
	- mzdy
	- cenu potraviny
	- vypsané roky
```
SELECT
	category_code,
	food_category,
	food_price,
	payroll_year,
	salary,
	round (AVG(salary)/AVG(food_price),0) AS quantity
FROM t_marketa_malek_project_sql_primary_final AS t1 
WHERE category_code IN (114201, 111301) 
GROUP BY category_code, payroll_year;
```

**Odpověď:**
- V prvním měřitelném roce (2006) bylo možné zakoupit 1 112 ks chleba a 1 340 l mléka. 
- Následující rok cena chleba vzrostla výrazněji, než u mléka. Z tohoto důvodu bylo možné zakoupit o 173 ks pečiva méně, než předchozí rok. Počet litrů mléka klesl o 124. 
- V průběhu let se počet kusů potravin zvyšoval i snižoval dle toho, jak se navyšovaly mzdy a ceny potravin. Jelikož cena mléka byla vždy nižší, bylo vždy možné zakoupit více litrů mléka, než kusů chleba.

# **3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

Co potřebuji vědet?
	- napojení tabulek pomocí payroll_year pro spočítání meziročního růstu
	- kategorie potravin
	- cenu potravin
	- meziroční nárůst v procentech
```
CREATE VIEW v_third_question AS 
SELECT 
	t1.category_code,
	t1.food_category,
	t1.payroll_year,
	t1.food_price AS price2,
	t2.food_price AS price1,
	round(avg(t1.food_price),2) AS average_price,
	round((t1.food_price - t2.food_price)/t2.food_price * 100,2) AS percent_growth
FROM t_marketa_malek_project_sql_primary_final AS t1
JOIN  t_marketa_malek_project_sql_primary_final AS t2
	ON t1.payroll_year = t2.payroll_year + 1
GROUP BY t1.category_code, t1.payroll_year
;

SELECT 
	category_code,
	food_category,
	ROUND(AVG(percent_growth),0) AS average_percent_growth
FROM v_third_question AS v1
GROUP BY category_code
ORDER BY average_percent_growth;
```

**Odpověď:**
- V záporných hodnotách má nevyšší číslo ( - 77) jogurt bílý netučný. 
- Nad -50% se nachází také minerální voda, pivo, mouka hladká pšeničná a mrkev. 
- Do -50% zde máme mléko, cukr krystal. chléb, banány, vejce slepičí a jablka. 
- V plusových hodnotách do 50% máme pomeranče, rýži, těstoviny s rajčaty a pečivo pšeničné bílé. 
- Nad 50% a do 100% růstu jsou papriky a kuřecí maso. 
- Nad 100% se nachází bílé víno, kapr živý a rostlinný tuk. 
- Nad 200% je to vepřová pečeně, šunkový salám, eidam sýr, máslo a s nejvyšším nárůstem 497% hovězí maso zadní bez kosti.**



# **4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší, než růst mezd (větší než 10 %)?**

Co potřebuji vědět?
	- meziroční nárůsty mezd v procentech
	- meziroční nárůsty cen v procentech
	- rozdíl mezi procentuálními růsty

```
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
```

**Odpověď:**
- Ano, v roce 2007 a 2008 byl rozdíl v nárustu cen a mezd nad 10%.
	


# **5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?**

Zde jsem si napojila tabulku economies pro přidání dat s GDP. Napojení tabulky economies samu na sebe pro meziroční procentuální růst. Využila jsem vytvořeného view z předchozí otázky pro snadnější tvoření příkazu.

```
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
```

**Odpověď:**
- Na začátku sledovaného období měl GDP nárůst hodnotu 5.57. Mzdy měly hodnotu 10.48 a potraviny 0.28.
- Následující rok GDP kleslo a s ním i mzdy. Do mínusových hodnot šly cen potravin. 
- Hodnota GDP klesla v roce 2009. Ceny vzrostly zatímco mzdy zůstaly na podobné hodnotě.
- Od roku 2013 do 2015 GDP výrazně vzrostlo ( z -0.05 na 5.39). Zareagovaly ceny potravin, ale více mzdy a to výrazným nárůstem (na 7,33). 
- nárůst cen potravin se projevil až v následujícím roce s hodnotou 8.44
- na konci sledovaného období mělo GDP hodnotu 5.17 -- ceny klesly do mínusu a mzdy se snížily na 5.08
