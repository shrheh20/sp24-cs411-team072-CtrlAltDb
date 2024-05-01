DELIMITER //

CREATE PROCEDURE DeleteUserReviews
(_Email VARCHAR(255), _Archive INT)
BEGIN
    START TRANSACTION;
    outerBlock: BEGIN
        DECLARE userExists INT;
        SELECT COUNT(*) INTO userExists FROM Users WHERE Email = _Email;

        IF userExists = 0 THEN
            ROLLBACK;
            LEAVE outerBlock;
        END IF;

        IF _Archive = 1 THEN
            DROP TABLE IF EXISTS trashedUserFeedback;
            CREATE TABLE trashedUserFeedback(FeedbackId                INT,
                                        Email                   VARCHAR(255),
                                        Year                    INT,
                                        CRN                     INT,
                                        Semester                VARCHAR(16),
                                        Testimony               VARCHAR(16384),
                                        Rating                  DECIMAL(10,2),
                                        Difficulty              DECIMAL(10,2),
                                        TimeCommit              DECIMAL(10,2),
                                        Time_stamp              TIMESTAMP,
                                        PRIMARY KEY (FeedbackId));
            INSERT INTO trashedUserFeedback (SELECT * FROM UserFeedback WHERE Email = _Email);
        END IF;

        DELETE FROM UserFeedback WHERE Email = _Email;
        COMMIT;
    END outerBlock;
END;

//
DELIMITER ;
