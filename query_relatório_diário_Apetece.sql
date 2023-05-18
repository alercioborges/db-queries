SELECT DISTINCT
	CONCAT( u.firstname , ' ' , u.lastname ) AS 'nome' ,
	u.email AS 'email' ,
	c.fullname AS 'curso' ,
	cfd.charvalue AS 'C.H. (horas)'
	,
	/* --- INSCRICAO MAIS ANTIGA --- */
	(
		SELECT
			FROM_UNIXTIME( MIN( subrs.timemodified ), '%d/%m/%Y %H:%i:%S' )
		FROM
			mdl_role_assignments subrs
				INNER JOIN mdl_context subctx ON ( subctx.id = subrs.contextid )
		WHERE
			subctx.instanceid = c.id
				AND subrs.userid = u.id
	) AS 'inscrito em'
	,
	/* --- DATA DE CONCLUSAO --- */
	IF( cc.timecompleted IS NULL , 'NÃO CONCLUIU' , FROM_UNIXTIME( cc.timecompleted, '%d/%m/%Y %H:%i:%S' ) ) AS 'realizado em'
	,
	/* --- DIAS DE CURSO DA INSCRICAO MAIS ANTIGA ATE CONCLUSAO -- */
	ROUND((
		(
			cc.timecompleted
			-
			(
				SELECT
					MIN( subrs.timemodified )
				FROM
					mdl_role_assignments subrs
						INNER JOIN mdl_context subctx ON ( subctx.id = subrs.contextid )
				WHERE
					subctx.instanceid = c.id
						AND subrs.userid = u.id
			)
		) / 60 / 60 / 24
	),0) AS 'dias'

FROM
	mdl_role_assignments rs
		INNER JOIN mdl_user u ON ( u.id = rs.userid )
		INNER JOIN mdl_context ctx ON ( ctx.id = rs.contextid )
		INNER JOIN mdl_course c ON ( c.id = ctx.instanceid )
			LEFT JOIN mdl_course_completions cc ON ( cc.course = c.id AND cc.userid = u.id )
				LEFT JOIN mdl_customfield_field cf ON ( cf.shortname = 'carga_horaria' )
					LEFT JOIN mdl_customfield_data cfd ON ( cfd.fieldid = cf.id AND cfd.instanceid = c.id )

WHERE
	ctx.contextlevel = 50
	/* CONSIDERA APENAS INSCRICOES COM ROLES "GRADEAVEIS" */ AND FIND_IN_SET( rs.roleid , ( SELECT value FROM mdl_config cfg WHERE cfg.name = 'gradebookroles' ) ) > 0
				
ORDER BY
	CONCAT( u.firstname , ' ' , u.lastname ) ,
	c.fullname