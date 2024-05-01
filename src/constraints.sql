ALTER TABLE UserFeedback ADD CONSTRAINT check_rating CHECK (Rating BETWEEN 0 AND 10);
ALTER TABLE UserFeedback ADD CONSTRAINT check_difficulty CHECK (Difficulty BETWEEN 0 AND 10);
ALTER TABLE UserFeedback ADD CONSTRAINT check_timecommit CHECK (TimeCommit >= 0);
ALTER TABLE UserFeedback ADD CONSTRAINT check_user_course_semester UNIQUE (Email, CRN, Semester, Year);