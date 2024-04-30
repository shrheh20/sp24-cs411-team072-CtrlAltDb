DELIMITER //

CREATE TRIGGER AvgRatingTrig_Insert
AFTER INSERT ON UserFeedback
FOR EACH ROW
BEGIN
    DECLARE _CourseNum               INT;
    DECLARE _DepartmentCode          VARCHAR(10);
    DECLARE _NumRatings              INT;

    SELECT g.NumRatings, g.CourseNum, g.DepartmentCode
    INTO _NumRatings, _CourseNum, _DepartmentCode
    FROM GeneralCourse g JOIN SectionAttributes s ON 
        g.CourseNum = s.CourseNum AND g.Departmentcode = s.DepartmentCode
    WHERE s.CRN = new.CRN AND s.Semester = new.Semester AND s.Year = new.Year;

    IF _NumRatings IS NULL THEN
            UPDATE GeneralCourse
            SET NumRatings = 1, AvgRating = new.Rating
            WHERE CourseNum = _CourseNum AND DepartmentCode = _DepartmentCode;
    ELSE
            UPDATE GeneralCourse
            SET NumRatings = _NumRatings + 1, AvgRating = ((AvgRating * _NumRatings) + new.Rating) / (_NumRatings + 1)
            WHERE CourseNum = _CourseNum AND DepartmentCode = _DepartmentCode;
    END IF;
END;
//
DELIMITER ;