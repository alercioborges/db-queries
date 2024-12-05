SELECT
        u.id,
        CONCAT(u.firstname, ' ', u.lastname) AS 'fullname',       
        u.email,        
        (
		  	SELECT
		  		CASE
				  WHEN subm.name = 'quiz' THEN (SELECT name FROM mdl_quiz WHERE id = subcm.instance)
				  END
		  		FROM mdl_course_modules subcm
            JOIN mdl_modules subm ON subcm.module = subm.id
            JOIN mdl_course subc ON subcm.course = subc.id
            LEFT JOIN mdl_course_modules_completion subcmc ON subcmc.coursemoduleid = subcm.id
            WHERE subc.id = c.id
            AND subcm.completion <> 0
				AND subcm.section = 2		  
		  ) AS 'activity_01'   
        
        FROM mdl_course AS c
        JOIN mdl_context AS ctx ON c.id = ctx.instanceid
        JOIN mdl_role_assignments AS ra ON ra.contextid = ctx.id
        JOIN mdl_user AS u ON u.id = ra.userid
        WHERE  
        ra.roleid = 5
        AND ctx.instanceid = c.id
        AND u.deleted = 0
        AND u.suspended = 0
        AND c.id = 2