DELIMETER //
CREATE TRIGGER AvgRatingTrig_Update
    DECLARE @CourseNum               INT;
    DECLARE @DepartmentCode          VARCHAR(10);
    DECLARE @NumRatings              INT;
    AFTER INSERT ON UserFeedback
    FOR EACH ROW
    BEGIN
        SELECT @NumRatings = g.NumRatings,
               @CourseNum = g.CourseNum,
               @DepartmentCode = g.DepartmentCode
            FROM GeneralCourse g JOIN SectionAttributes s ON 
            g.CourseNum = s.CourseNum AND g.Departmentcode = s.DepartmentCode
            WHERE s.CRN = new.CRN AND s.Semester = new.Semester AND s.Year = new.Year;
        IF @NumRatings IS NULL THEN
                UPDATE GeneralCourse
                SET NumRatings = 1, AvgRating = new.Rating
                WHERE CourseNum = @CourseNum AND DepartmentCode = @DepartmentCode;
        ELSE
                UPDATE GeneralCourse
                SET NumRatings = @NumRatings + 1, AvgRating = ((AvgRating * @NumRatings) + new.Rating) / (@NumRatings + 1)
                WHERE CourseNum = @CourseNum AND DepartmentCode = @DepartmentCode;
        END IF;

    END;
//
DELIMETER ;