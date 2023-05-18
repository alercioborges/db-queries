SELECT
	l.ip
FROM mdl_logstore_standard_log l
WHERE
	l.userid = 2
	AND l.courseid = 20
	AND l.component = 'mod_consentform'
	AND l.action = 'agree'
	AND l.target = 'agreement'
	AND l.timecreated = 
		(
		SELECT
			MAX(subl.timecreated)
		FROM mdl_logstore_standard_log subl
		WHERE
			subl.userid = 2
			AND subl.courseid = 20
			AND subl.component = 'mod_consentform'
			AND subl.action = 'agree'
			AND subl.target = 'agreement'
		)
		
/******************************************************************/

SELECT
	u.id,
	CONCAT(u.firstname, ' ', u.lastname) AS 'NOME',
	/************************ inicio cpf ************************/
	CASE
		WHEN (
				SELECT
					subuid.data
				FROM mdl_user_info_data subuid
				WHERE
					subuid.userid = u.id
					AND subuid.fieldid = 13
			) = '' THEN 'NÃO INSERIDO'
		ELSE
			(
				SELECT
					subuid.data
				FROM mdl_user_info_data subuid
				WHERE
					subuid.userid = u.id
					AND subuid.fieldid = 13
			) 
	END AS 'CPF',
	/************************ fim cpf ************************/
	/************************ inicio rg ************************/
	CASE
		WHEN (
				SELECT
					subuid.data
				FROM mdl_user_info_data subuid
				WHERE
					subuid.userid = u.id
					AND subuid.fieldid = 16
			) = '' THEN 'NÃO INSERIDO'
		ELSE
			(
				SELECT
					subuid.data
				FROM mdl_user_info_data subuid
				WHERE
					subuid.userid = u.id
					AND subuid.fieldid = 16
			) 
	END AS 'RG',
	/************************ fim rg ************************/
	cs.consentformcmid,
	DATE_FORMAT(FROM_UNIXTIME(cs.timestamp), '%d/%m/%Y %H:%i:%s') AS 'DATA DO ACEITE',
	/************************ ininio ip ************************/
	(
		SELECT
			l.ip
		FROM mdl_logstore_standard_log l
		WHERE
			l.userid = u.id
			AND l.courseid = 20
			AND l.component = 'mod_consentform'
			AND l.action = 'agree'
			AND l.target = 'agreement'
			AND l.timecreated = 
				(
					SELECT
						MAX(subl.timecreated)
					FROM mdl_logstore_standard_log subl
					WHERE
						subl.userid = u.id
						AND subl.courseid = 20
						AND subl.component = 'mod_consentform'
						AND subl.action = 'agree'
						AND subl.target = 'agreement'
				)
	) AS 'IP'
	/************************ fim ip ************************/
FROM mdl_consentform_state cs
	INNER JOIN mdl_user u ON u.id = cs.userid
WHERE
	cs.consentformcmid = 1912
	AND u.id IN 
		(
			SELECT DISTINCT
				subu.id
			FROM mdl_role_assignments subrs
				INNER JOIN mdl_user subu ON subu.id = subrs.userid
					INNER JOIN mdl_context sube ON subrs.contextid = sube.id
			WHERE
				sube.contextlevel = 50
				AND subrs.roleid = 5
				AND sube.instanceid = 20
		)
ORDER BY
	u.firstname,
	u.lastname

/******************************************************************/

SELECT DISTINCT
	u.id
FROM mdl_role_assignments rs
	INNER JOIN mdl_user u ON u.id=rs.userid
		INNER JOIN mdl_context e ON rs.contextid=e.id
WHERE
	e.contextlevel=50
	AND rs.roleid=5
	AND e.instanceid=20