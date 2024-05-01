DELIMITER //

CREATE TRIGGER AvgRatingTrig_Delete
BEFORE DELETE ON UserFeedback
FOR EACH ROW
BEGIN
    DECLARE _CourseNum               INT;
    DECLARE _DepartmentCode          VARCHAR(10);
    DECLARE _NumRatings              INT;

    SELECT g.NumRatings, g.CourseNum, g.DepartmentCode
    INTO _NumRatings, _CourseNum, _DepartmentCode
    FROM GeneralCourse g JOIN SectionAttributes s ON 
        g.CourseNum = s.CourseNum AND g.Departmentcode = s.DepartmentCode
    WHERE s.CRN = old.CRN AND s.Semester = old.Semester AND s.Year = old.Year;

    IF _NumRatings = 1 THEN
        UPDATE GeneralCourse
        SET NumRatings = NULL, AvgRating = NULL
        WHERE CourseNum = _CourseNum AND DepartmentCode = _DepartmentCode;
    ELSE
        UPDATE GeneralCourse
        SET NumRatings = _NumRatings - 1, AvgRating = ((AvgRating * _NumRatings) - old.Rating) / (_NumRatings - 1)
        WHERE CourseNum = _CourseNum AND DepartmentCode = _DepartmentCode;
    END IF;
END;
//
DELIMITER ;