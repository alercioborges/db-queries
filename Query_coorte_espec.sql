SELECT
	u.username,
	u.firstname,
	u.lastname,
	u.email
	
FROM mdl_user u
	INNER JOIN mdl_cohort_members cm ON cm.userid=u.id

WHERE
	cm.cohortid=21
	
ORDER BY
	u.firstname,
	u.lastname
	
