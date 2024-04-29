DELIMETER //
CREATE TRIGGER AvgRatingTrig_Delete
    DECLARE @CourseNum               INT;
    DECLARE @DepartmentCode          VARCHAR(10);
    DECLARE @NumRatings              INT;
    BEFORE DELETE ON UserFeedback
    FOR EACH ROW
    BEGIN
        SELECT @NumRatings = g.NumRatings,
               @CourseNum = g.CourseNum,
               @DepartmentCode = g.DepartmentCode
            FROM GeneralCourse g JOIN SectionAttributes s ON 
            g.CourseNum = s.CourseNum AND g.Departmentcode = s.DepartmentCode
            WHERE s.CRN = old.CRN AND s.Semester = old.Semester AND s.Year = old.Year;
        IF @NumRatings = 1 THEN
                UPDATE GeneralCourse
                SET NumRatings = 0, AvgRating = NULL
                WHERE CourseNum = @CourseNum AND DepartmentCode = @DepartmentCode;
        ELSE
                UPDATE GeneralCourse
                SET NumRatings = @NumRatings - 1, AvgRating = ((AvgRating * @NumRatings) - old.Rating) / (@NumRatings - 1)
                WHERE CourseNum = @CourseNum AND DepartmentCode = @DepartmentCode;
        END IF;

    END;
//
DELIMETER ;