SELECT
	DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%d/%m/%Y %H:%i') AS 'DATA/HORA',
 	CONCAT(u.firstname, ' ', u.lastname) AS 'NOME',
 	u.email AS 'E-MAIL',
 	c.fullname AS 'CURSO',
 	q.name AS 'QUESTIONÀRIO', 	
 	'Tentativa do questionário entregue' AS 'EVENTO',
	 l.ip AS 'IP'
FROM mdl_logstore_standard_log l
	INNER JOIN mdl_user u ON u.id = l.userid
		INNER JOIN mdl_course c ON c.id = l.courseid
			INNER JOIN mdl_course_modules cm ON cm.id = l.contextinstanceid
				INNER JOIN mdl_quiz q ON q.id = cm.`instance`
WHERE l.component = 'mod_quiz'
AND l.action = 'submitted'
AND l.target = 'attempt'
AND l.timecreated >= UNIX_TIMESTAMP('2023-11-01 00:00:00')
ORDER BY l.timecreated DESC