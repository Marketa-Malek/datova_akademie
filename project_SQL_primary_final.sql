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
