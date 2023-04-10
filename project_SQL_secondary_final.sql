Spojení tabulek economie a countries přes country. Dále vyselektování zemí EU přes kontinent.


CREATE TABLE t_marketa_malek_project_SQL_secondary_final
SELECT 
	c.continent,
	e.country,
	e.GDP,
	e.gini,
	e.population,
	e.`year`
FROM economies e 
JOIN countries c
	ON e.country = c.country
WHERE c.continent = 'europe'
	AND e.`year` BETWEEN 2006 AND 2018













