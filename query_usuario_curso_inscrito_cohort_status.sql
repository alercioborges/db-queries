SELECT
	u.id,
	u.username,
	CONCAT(u.firstname, " ", u.lastname) AS "NOME",
	c.fullname AS "CURSO",
	c.id AS "ID DO CURSO",
	c.visible AS "VISIVEL",
	ch.name AS "COHORT"
FROM mdl_role_assignments rs
	INNER JOIN mdl_user u ON u.id=rs.userid
		INNER JOIN mdl_context e ON rs.contextid=e.id
			INNER JOIN mdl_course c ON c.id = e.instanceid
				INNER JOIN mdl_cohort_members cm ON cm.userid = u.id
					INNER JOIN mdl_cohort ch ON ch.id = cm.cohortid
WHERE
	e.contextlevel=50
	AND u.id = 3361