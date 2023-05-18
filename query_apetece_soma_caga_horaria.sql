SELECT
	c.fullname AS 'nome do curso',
	ABS(cfd.charvalue) AS 'c.h. (horas)'	
	
FROM mdl_course c
	LEFT JOIN mdl_customfield_field cf ON ( cf.shortname = 'carga_horaria' )
		LEFT JOIN mdl_customfield_data cfd ON ( cfd.fieldid = cf.id AND cfd.instanceid = c.id )

WHERE
	c.id <> 1
	
UNION ALL
SELECT 
	'total c.h. (horas)',
	 
	/*-- TOTAL CARGA HORARIA --*/
	(	SELECT
			SUM(ABS(subcfd.charvalue)) AS 'total'
		FROM mdl_customfield_data subcfd
		JOIN mdl_customfield_field subcf ON ( subcf.id = subcfd.fieldid )
	)
	/*-- FIM TOTAL CARGA HORARIA --*/