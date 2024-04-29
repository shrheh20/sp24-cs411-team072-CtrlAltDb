DELIMETER //
CREATE TRIGGER AvgRatingTrig_Insert
    DECLARE @CourseNum               INT;
    DECLARE @DepartmentCode          VARCHAR(10);
    DECLARE @NumRatings              INT;
    AFTER UPDATE ON UserFeedback
    FOR EACH ROW
    BEGIN
        IF old.Rating <> new.Rating  THEN
            SELECT @NumRatings = g.NumRatings,
                @CourseNum = g.CourseNum,
                @DepartmentCode = g.DepartmentCode
                FROM GeneralCourse g JOIN SectionAttributes s ON 
                g.CourseNum = s.CourseNum AND g.Departmentcode = s.DepartmentCode
                WHERE s.CRN = new.CRN AND s.Semester = new.Semester AND s.Year = new.Year;
            UPDATE GeneralCourse
            SET AvgRating = ((AvgRating * @NumRatings) - old.Rating + new.Rating) / (@NumRatings)
            WHERE CourseNum = @CourseNum AND DepartmentCode = @DepartmentCode;
        END IF;
    END;
//
DELIMETER ;