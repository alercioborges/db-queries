SELECT
timecompleted FROM mdl_course_completions WHERE timecompleted > 0 AND course=? AND userid=?
Essa data vai existir se houver configuração de rastreamento de conclusão do curso no Moodle.

 

Critério II- Data de lançamento da nota final no curso

SELECT g.timecreated,g.timemodified FROM mdl_grade_items i INNER JOIN mdl_grade_grades g ON i.id=g.itemid WHERE i.itemtype = 'course' AND i.courseid=? AND g.userid=?
 

Critério III- Data do último acesso no curso

SELECT MAX(timecreated) AS timeend FROM mdl_logstore_standard_log   WHERE  courseid=? AND userid=2