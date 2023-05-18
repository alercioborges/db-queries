SELECT
	u.id AS USERID ,
	CONCAT( u.firstname , ' ' , u.lastname ) AS 'Nome Completo' ,
	u.email AS 'Email'
	,
	/* --- CARGA HORARIA CURSOS COMPLETADOS --- */
	(
		SELECT
			SUM( ABS( subcfd.charvalue ) )
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
							/* JOIN COURSE COMPLETION DO USUARIO */ JOIN mdl_course_completions subcc ON ( subcc.course = subc.id AND subcc.userid = subu.id )
				WHERE
					subctx.contextlevel = 50 /* enrol em curso */
						AND FIND_IN_SET( subrs.roleid , ( SELECT value FROM mdl_config subcfg WHERE subcfg.name = 'gradebookroles' ) ) > 0
							AND subu.id = u.id /* USUARIO DA LINHA ATUAL DA QUERY PRINCIPAL */
								AND ( subcc.timecompleted IS NOT NULL AND subcc.timecompleted > 0 ) /* APENAS COMPLETADOS */
		)
		AND subcf.shortname = 'carga_horaria'
	) AS 'C.H. (horas)'
	,
	COUNT( DISTINCT c.id ) AS 'Cursos'
	,
	/* --- CURSOS COMPLETADOS --- */
	(
		SELECT
			COUNT( DISTINCT subcc.id )
		FROM
			mdl_role_assignments subrs
				INNER JOIN mdl_user subu ON ( subu.id = subrs.userid )
				INNER JOIN mdl_context subctx ON ( subctx.id = subrs.contextid )
				INNER JOIN mdl_course subc ON ( subc.id = subctx.instanceid )
					/* JOIN COURSE COMPLETION DO USUARIO */ JOIN mdl_course_completions subcc ON ( subcc.course = subc.id AND subcc.userid = subu.id )
		WHERE
			subctx.contextlevel = 50 /* enrol em curso */
				AND FIND_IN_SET( subrs.roleid , ( SELECT value FROM mdl_config subcfg WHERE subcfg.name = 'gradebookroles' ) ) > 0
					AND subu.id = u.id /* USUARIO DA LINHA ATUAL DA QUERY PRINCIPAL */
						AND ( subcc.timecompleted IS NOT NULL AND subcc.timecompleted > 0 ) /* APENAS COMPLETADOS */
	) AS 'Completos',
	
	
	/*cursos incompletos*/
	
	(SELECT COUNT( DISTINCT c.id ) - (
		SELECT
			COUNT( DISTINCT subcc.id )
		FROM
			mdl_role_assignments subrs
				INNER JOIN mdl_user subu ON ( subu.id = subrs.userid )
				INNER JOIN mdl_context subctx ON ( subctx.id = subrs.contextid )
				INNER JOIN mdl_course subc ON ( subc.id = subctx.instanceid )
					/* JOIN COURSE COMPLETION DO USUARIO */ JOIN mdl_course_completions subcc ON ( subcc.course = subc.id AND subcc.userid = subu.id )
		WHERE
			subctx.contextlevel = 50 /* enrol em curso */
				AND FIND_IN_SET( subrs.roleid , ( SELECT value FROM mdl_config subcfg WHERE subcfg.name = 'gradebookroles' ) ) > 0
					AND subu.id = u.id /* USUARIO DA LINHA ATUAL DA QUERY PRINCIPAL */
						AND ( subcc.timecompleted IS NOT NULL AND subcc.timecompleted > 0 ) /* APENAS COMPLETADOS */
	) ) AS 'Pendente',
	
	/*Performace(porcentagem de concluido)*/
	ROUND(((
		SELECT
			COUNT( DISTINCT subcc.id )
		FROM
			mdl_role_assignments subrs
				INNER JOIN mdl_user subu ON ( subu.id = subrs.userid )
				INNER JOIN mdl_context subctx ON ( subctx.id = subrs.contextid )
				INNER JOIN mdl_course subc ON ( subc.id = subctx.instanceid )
					/* JOIN COURSE COMPLETION DO USUARIO */ JOIN mdl_course_completions subcc ON ( subcc.course = subc.id AND subcc.userid = subu.id )
		WHERE
			subctx.contextlevel = 50 /* enrol em curso */
				AND FIND_IN_SET( subrs.roleid , ( SELECT value FROM mdl_config subcfg WHERE subcfg.name = 'gradebookroles' ) ) > 0
					AND subu.id = u.id /* USUARIO DA LINHA ATUAL DA QUERY PRINCIPAL */
						AND ( subcc.timecompleted IS NOT NULL AND subcc.timecompleted > 0 ) /* APENAS COMPLETADOS */
	)*100)/COUNT( DISTINCT c.id ),2) AS 'Performace(%)'


FROM
	mdl_role_assignments rs
		INNER JOIN mdl_user u ON ( u.id = rs.userid )
		INNER JOIN mdl_context ctx ON ( ctx.id = rs.contextid )
		INNER JOIN mdl_course c ON ( c.id = ctx.instanceid )
WHERE
	ctx.contextlevel = 50
		/* CONSIDERA APENAS INSCRICOES COM ROLES "GRADEAVEIS" */ AND FIND_IN_SET( rs.roleid , ( SELECT value FROM mdl_config cfg WHERE cfg.name = 'gradebookroles' ) ) > 0

GROUP BY
	u.id

ORDER BY
	u.firstname ,
	u.lastname