DELIMITER //

CREATE TRIGGER AvgRatingTrig_Update
AFTER UPDATE ON UserFeedback
FOR EACH ROW
BEGIN
    DECLARE _CourseNum               INT;
    DECLARE _DepartmentCode          VARCHAR(10);
    DECLARE _NumRatings              INT;

    IF old.Rating <> new.Rating  THEN
        SELECT g.NumRatings, g.CourseNum, g.DepartmentCode
        INTO _NumRatings, _CourseNum, _DepartmentCode
        FROM GeneralCourse g JOIN SectionAttributes s ON 
            g.CourseNum = s.CourseNum AND g.Departmentcode = s.DepartmentCode
        WHERE s.CRN = new.CRN AND s.Semester = new.Semester AND s.Year = new.Year;
        UPDATE GeneralCourse
        SET AvgRating = ((AvgRating * _NumRatings) - old.Rating + new.Rating) / (_NumRatings)
        WHERE CourseNum = _CourseNum AND DepartmentCode = _DepartmentCode;
    END IF;
END;
//
DELIMITER ;