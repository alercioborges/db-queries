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
			{role_assignments} subrs
				INNER JOIN {context} subctx ON ( subctx.id = subrs.contextid )
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
					{role_assignments} subrs
						INNER JOIN {context} subctx ON ( subctx.id = subrs.contextid )
				WHERE
					subctx.instanceid = c.id
						AND subrs.userid = u.id
			)
		) / 60 / 60 / 24
	),0) AS 'dias'

FROM
	{role_assignments} rs
		INNER JOIN {user} u ON ( u.id = rs.userid )
		INNER JOIN {context} ctx ON ( ctx.id = rs.contextid )
		INNER JOIN {course} c ON ( c.id = ctx.instanceid )
			LEFT JOIN {course_completions} cc ON ( cc.course = c.id AND cc.userid = u.id )
				LEFT JOIN {customfield_field} cf ON ( cf.shortname = 'carga_horaria' )
					LEFT JOIN {customfield_data} cfd ON ( cfd.fieldid = cf.id AND cfd.instanceid = c.id )

WHERE
	ctx.contextlevel = 50
		/* CONSIDERA APENAS INSCRICOES COM ROLES "GRADEAVEIS" */ AND FIND_IN_SET( rs.roleid , ( SELECT value FROM {config} cfg WHERE cfg.name = 'gradebookroles' ) ) > 0

ORDER BY
	CONCAT( u.firstname , ' ' , u.lastname ) ,
	c.fullname