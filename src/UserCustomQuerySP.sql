DELIMITER //

CREATE PROCEDURE UserCustomQuery
(_DepartmentCode VARCHAR(10), _GPAFloor DECIMAL(10,2), _CourseRatingFloor DECIMAL(10,2), _CreditHours VARCHAR(255), _IntersectOrUnion INT)
BEGIN
-- 0 is intersect, 1 is union
IF _IntersectOrUnion = 0 THEN
    SELECT DISTINCT
        c.DepartmentCode,
        c.CourseNum,
        c.CourseName,
        c.CreditHours,
	    c.AvgRating,
        AVG(g.Avg_grade) AS _Avg_grade
    FROM
        GeneralCourse c
        JOIN GPAHistory g ON g.CourseNum = c.CourseNum
    WHERE
        c.DepartmentCode = _DepartmentCode
        AND c.CreditHours = _CreditHours
        AND c.AvgRating >= _CourseRatingFloor
    GROUP BY
        c.DepartmentCode,
        c.CourseNum,
        c.CourseName,
        c.CreditHours,
	    c.AvgRating
    HAVING
        _Avg_grade >= _GPAFloor
    ORDER BY
        AvgRating DESC, _Avg_grade DESC;
ELSE
    SELECT DISTINCT
        c.DepartmentCode,
        c.CourseNum,
        c.CourseName,
        c.CreditHours,
	    c.AvgRating,
        AVG(g.Avg_grade) AS _Avg_grade
    FROM
        GeneralCourse c
        JOIN GPAHistory g ON g.CourseNum = c.CourseNum
    WHERE
        c.DepartmentCode = _DepartmentCode
        AND c.CreditHours = _CreditHours
        AND c.AvgRating >= _CourseRatingFloor
    GROUP BY
        c.DepartmentCode,
        c.CourseNum,
        c.CourseName,
        c.CreditHours,
	    c.AvgRating
    UNION
    SELECT DISTINCT
        c.DepartmentCode,
        c.CourseNum,
        c.CourseName,
        c.CreditHours,
	    c.AvgRating,
        AVG(g.Avg_grade) AS _Avg_grade
    FROM
        GeneralCourse c
        JOIN GPAHistory g ON g.CourseNum = c.CourseNum
    WHERE
        c.DepartmentCode = _DepartmentCode
        AND c.CreditHours = _CreditHours
    GROUP BY
        c.DepartmentCode,
        c.CourseNum,
        c.CourseName,
        c.CreditHours,
	    c.AvgRating
    HAVING
        _Avg_grade >= _GPAFloor
    ORDER BY
        AvgRating DESC, _Avg_grade DESC;

END IF;
END;

//
DELIMITER ;
