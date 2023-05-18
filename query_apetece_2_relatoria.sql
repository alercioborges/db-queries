SELECT
	CONCAT( u.firstname , ' ' , u.lastname ) AS 'Nome Completo',
	u.email AS 'Email',
	
	/* --- CARGA HORARIA CURSOS COMPLETADOS --- */
	(
		SELECT DISTINCT
			subcfd.charvalue
		FROM
			mdl_customfield_data subcfd
				JOIN mdl_customfield_field subcf ON ( subcf.id = subcfd.fieldid )
		WHERE
			subcfd.instanceid IN (
				SELECT DISTINCT
					subc.id
				FROM
					mdl_role_assignments subrs
						INNER JOIN mdl_user subu ON ( subu.id = subrs.userid )
						INNER JOIN mdl_context subctx ON ( subctx.id = subrs.contextid )
						INNER JOIN mdl_course subc ON ( subc.id = subctx.instanceid )
				WHERE
					subctx.contextlevel = 50 /* enrol em curso */
						AND FIND_IN_SET( subrs.roleid , ( SELECT value FROM mdl_config subcfg WHERE subcfg.name = 'gradebookroles' ) ) > 0
							AND subu.id = u.id /* USUARIO DA LINHA ATUAL DA QUERY PRINCIPAL */
								
										)
		AND subcf.shortname = 'carga_horaria'
	) AS 'C.H. (horas)'
	/* ---FIM CARGA HORARIA CURSOS COMPLETADOS --- */
	
	
	
	


FROM
	mdl_role_assignments rs
		INNER JOIN mdl_user u ON ( u.id = rs.userid )
		INNER JOIN mdl_context ctx ON ( ctx.id = rs.contextid )
		INNER JOIN mdl_course c ON ( c.id = ctx.instanceid )
		INNER JOIN mdl_course_completions
WHERE
	ctx.contextlevel = 50
		/* CONSIDERA APENAS INSCRICOES COM ROLES "GRADEAVEIS" */

GROUP BY
	u.id,
	c.id

ORDER BY
	u.firstname,
	u.lastname