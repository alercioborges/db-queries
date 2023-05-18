SELECT
    DATE_FORMAT(MIN(FROM_UNIXTIME(l.timecreated)), '%d/%m/%Y às %H:%i') AS 'FA',
    DATE_FORMAT(MAX(FROM_UNIXTIME(l.timecreated)), '%d/%m/%Y às %H:%i') AS 'LA'
FROM mdl_logstore_standard_log l
    WHERE
        l.courseid = 1070
        AND l.userid = 10


-----------------------------
ultimo acesso

SELECT
u.id,
CONCAT(u.firstname, ' ', u.lastname) AS 'NOME',
DATE_FORMAT(MAX(FROM_UNIXTIME(ul.timeaccess)), '%d/%m/%Y às %H:%i') AS 'Último acesso'
FROM mdl_role_assignments rs
INNER JOIN mdl_context e ON rs.contextid=e.id
INNER JOIN mdl_role r ON rs.roleid=r.id
INNER JOIN mdl_user u ON rs.userid=u.id
INNER JOIN mdl_course c ON c.id = 
INNER JOIN mdl_enrol en ON e.instanceid=en.courseid
INNER JOIN mdl_user_enrolments ue ON en.id=ue.enrolid
INNER JOIN mdl_user_lastaccess ul ON (e.instanceid=ul.courseid AND rs.userid=ul.userid)
WHERE
e.contextlevel=50
AND rs.userid=ue.userid
AND ue.status = 0
AND en.status = 0
AND r.id = 3 AND 4
AND en.courseid = 1070


/**************************************************************/

SELECT
    u.id AS 'ID usuário',
    CONCAT(u.firstname, ' ', u.lastname) AS 'NOME',
    c.id AS 'ID curso',
    c.fullname AS 'CURSO',
    r.archetype AS 'PAPEL',
    /** inicio primeiro acesso **/
    IFNULL(
        (
            SELECT
                DATE_FORMAT(MIN(FROM_UNIXTIME(subl.timecreated)), '%d/%m/%Y às %H:%i')
        FROM mdl_logstore_standard_log subl
        WHERE subl.courseid = en.courseid AND subl.userid = u.id), 'NUNCA')
    AS 'Primeiroaceso',
/** fim primeiro acesso **/    
IFNULL(DATE_FORMAT(FROM_UNIXTIME(ul.timeaccess), '%d/%m/%Y às %H:%i'), 'NUNCA') AS 'Último acesso'
FROM mdl_role_assignments rs
INNER JOIN mdl_context e ON rs.contextid = e.id
INNER JOIN mdl_role r ON rs.roleid = r.id
INNER JOIN mdl_user u ON rs.userid = u.id
INNER JOIN mdl_course c ON c.id = e.instanceid
INNER JOIN mdl_enrol en ON e.instanceid = en.courseid
INNER JOIN mdl_user_enrolments ue ON en.id = ue.enrolid
LEFT JOIN mdl_user_lastaccess ul ON (e.instanceid=ul.courseid AND rs.userid=ul.userid)
WHERE
e.contextlevel = 50
AND rs.userid = ue.userid
AND ue.status = 0
AND en.status = 0
AND r.id IN (3, 4)
AND en.courseid = 97
ORDER BY
u.firstname,
u.lastname


/****************************************************************************************/

SELECT
DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d') AS 'DATA',
COUNT(DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d')) AS 'QUANTIDADE DE ACESSOS',
/******** inicio MIN *********/
(SELECT
    DATE_FORMAT(MIN(FROM_UNIXTIME(l.timecreated)), '%d/%m/%Y às %H:%i')
    ) AS 'ACESSO INICIAL',
/******** fim MIN *********/
/******** inicio MAX *********/
(SELECT 
    DATE_FORMAT(MAX(FROM_UNIXTIME(l.timecreated)), '%d/%m/%Y às %H:%i')
) AS 'ACESSO FINAL'
/******** fim MAX *********/
FROM mdl_logstore_standard_log l
WHERE
l.userid = 10
AND l.courseid = 1070
GROUP BY
DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d')

/****************************************************************************************/

SELECT  
TIMESTAMPDIFF(
    MINUTE,
    DATE_FORMAT(
        FROM_UNIXTIME(
            MIN(subl.timecreated)
            ), '%Y-%m-%d %H:%i:%s'
        ), 
    DATE_FORMAT(
        FROM_UNIXTIME(
            MAX(subl.timecreated)
            ), '%Y-%m-%d %H:%i:%s'
        )
    )
FROM mdl_logstore_standard_log subl
WHERE
subl.userid = 10
AND subl.courseid = 1070

/****************************************************************************************/



SELECT
DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d') AS 'DATA',
COUNT(DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d')) AS 'QUANTIDADE DE ACESSOS',
/******** inicio MIN *********/
(
    SELECT
    DATE_FORMAT(
        MIN(
            FROM_UNIXTIME(l.timecreated)
            ),
        '%d/%m/%Y às %H:%i'
        )
    ) AS 'ACESSO INICIAL',
/******** fim MIN *********/
/******** inicio MAX *********/
(
    SELECT 
    DATE_FORMAT(
        MAX(
            FROM_UNIXTIME(l.timecreated)
            ),
        '%d/%m/%Y às %H:%i'
        )
) AS 'ACESSO FINAL'
/******** fim MAX *********/
/**********************/
(
    SELECT  
    DATEDIFF(
        MINUTE,
        'ACESSO INICIAL', 
        'ACESSO FINAL'
        )
    FROM mdl_logstore_standard_log subl
    WHERE
    subl.userid = l.userid
    AND subl.courseid = l.courseid
)
/***********************/
FROM mdl_logstore_standard_log l
WHERE
l.userid = 10
AND l.courseid = 1070
GROUP BY
DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d')

/*********************************************************************************/

SELECT
    TIMESTAMPDIFF(
        MINUTE,        
      MIN('2009-05-18 11:45:42'), 
      MAX('2009-05-18 11:49:49')
   ) AS 'TOTAL'
FROM mdl_logstore_standard_log l
WHERE
    l.userid = 10
    AND l.courseid = 1070

/************************************************************************/

SELECT
    TIMESTAMPDIFF(
    HOUR,
    DATE_FORMAT(MIN(FROM_UNIXTIME(l.timecreated)), '%Y-%m-%d %H:%i:%s'),
    DATE_FORMAT(MAX(FROM_UNIXTIME(l.timecreated)), '%Y-%m-%d %H:%i:%s')
    )
FROM mdl_logstore_standard_log l
WHERE
    l.userid = 10
    AND l.courseid = 1070

/************************************************************************/

Nome do evento: Módulo do curso visualizado + inicio proximo evento

/************************************************************************/

SELECT
    l.*
FROM mdl_logstore_standard_log l
WHERE
    l.courseid = 97
    AND l.userid = 10
    AND l.eventname LIKE '%course_module_viewed%'