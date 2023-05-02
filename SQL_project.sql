--- 1. otázka ---

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

--- 2. otázka ---

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

--- 3. otázka ---

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

--- 4. otázka ---

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

--- 5. otazka ---

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
