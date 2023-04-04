# prvni_projekt
První repozitář pro první projekt SQL

1. otázka
  Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
    Co potřebuji vědět?
      * roky
      * mzdy
      * odvětví

--- dotaz pro vyselektování základních dat ---

SELECT
	cp.value,
	cp.payroll_year,
	cpib.name 
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code
WHERE value IS NOT NULL;

