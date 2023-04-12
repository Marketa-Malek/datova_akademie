--- 1. otázka ---

SELECT 
	payroll_year,
	industry,
	salary
FROM t_marketa_malek_project_sql_primary_final tmmpspf 
GROUP BY industry, payroll_year;


--- 2. otázka ---

SELECT
	food_category,
	food_price,
	payroll_year,
	salary,
	round (salary/food_price,2) AS pocet_ks
FROM t_marketa_malek_project_sql_primary_final tmmpspf 
WHERE category_code = 114201
GROUP BY payroll_year;

SELECT
	food_category,
	food_price,
	payroll_year,
	salary,
	round (salary/food_price,2) AS pocet_ks
FROM t_marketa_malek_project_sql_primary_final tmmpspf 
WHERE category_code = 111301
GROUP BY payroll_year;


--- 3. otázka ---

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

--- 4. otázka ---

CREATE VIEW v_ctvrta_otazka AS; 
SELECT 
	t1.payroll_year AS year1, 
	t2.payroll_year, 
	round (avg(t1.food_price),2) AS prumer_ceny, 
	round (avg(t1.salary),2) AS prumer_mezd, 
	round ((avg(t1.food_price) - avg(t2.food_price))/avg(t2.food_price)100,2) AS price_grow, 
	round ((avg(t1.salary)-avg(t2.salary))/ avg(t2.salary) 100,2) AS salary_grow 
FROM t_marketa_malek_project_sql_primary_final AS t1 
JOIN t_marketa_malek_project_sql_primary_final AS t2 
	ON t1.payroll_year = t2.payroll_year + 1 
GROUP BY t1.payroll_year ;

SELECT 
	payroll_year, 
	price_grow, 
	salary_grow, 
	salary_grow - price_grow AS difference 
FROM v_ctvrta_otazka vco 
ORDER BY difference DESC

--- 5. otazka ---

SELECT 
	e.country,
	e.`year`,
	e2.`year`,
	round(e.GDP,0) AS GDP,
	round(e2.GDP,0) AS GDP2,
	prumer_ceny,
	prumer_mezd,
	round ((e.GDP - e2.GDP)/ e2.GDP * 100,2) AS GDP_grow,
	price_grow,
	salary_grow
FROM economies e
JOIN v_ctvrta_otazka AS v1
	ON e.`year` = v1.payroll_year
JOIN economies e2 
	ON e.`year` = e2.`year`+1
WHERE e.country = 'Czech republic'
	AND e2.country = 'Czech republic'
	AND e.`year` BETWEEN 2006 AND 2019
	AND e2.`year` BETWEEN 2006 AND 2019
GROUP BY e.`year`














