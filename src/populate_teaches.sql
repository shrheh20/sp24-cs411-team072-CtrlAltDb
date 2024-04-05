/*
    This SQL stored procedure populates our Teaches table based on the 
    SectionAttributes table and the Professors table. It goes through each SectionAttributes
    entry and find each professor in the Professors string. Once it finds a professor,
    it looks for that professor in the Professors table and takes the first match within
    a department. That means there could be some misqueues, but this should be very unlikely.
    Once it finds the match, it inserts a new entry into Teaches, allowing us to link the
    courses taught by a professor.
*/
CREATE PROCEDURE populate_teaches()
    BEGIN
        DECLARE done int default 0;
        DECLARE temp_CRN VARCHAR(255);
        DECLARE temp_Semester VARCHAR(16);
        DECLARE temp_Year INT;
        DECLARE temp_Professors VARCHAR(1024);
        DECLARE temp_NetId VARCHAR(255);
        DECLARE delimiter_position INT;
        DECLARE temp_LastNameFirstIni VARCHAR(255);
        DECLARE temp_DepartmentCode VARCHAR(10);
        DECLARE num_of_rows_found INT default 0;
        DECLARE section_cur CURSOR FOR SELECT CRN,Semester,Year,Professors,DepartmentCode FROM SectionAttributes;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        OPEN section_cur;

        REPEAT
            FETCH section_cur INTO temp_CRN, temp_Semester, temp_Year, temp_Professors, temp_DepartmentCode;
            WHILE LENGTH(temp_Professors) > 0 DO
                SET delimiter_position = INSTR(temp_Professors, ';');

                IF delimiter_position > 0 THEN
                    SET temp_LastNameFirstIni = SUBSTRING(temp_Professors, 1, delimiter_position - 1);
                    SET temp_Professors = SUBSTRING(temp_Professors, delimiter_position + 1);
                ELSE
                    SET temp_LastNameFirstIni = temp_Professors;
                    SET temp_Professors = '';
                END IF;

                SELECT NetId INTO temp_NetId FROM Professors WHERE LastNameFirstIni = temp_LastNameFirstIni AND DepartmentCode = temp_DepartmentCode LIMIT 1;
                SELECT FOUND_ROWS() INTO num_of_rows_found;

                IF num_of_rows_found = 0 THEN
                    SET temp_NetId = NULL;
                END IF;

                IF temp_NetId IS NULL THEN
                    CONTINUE;
                ELSE
                    INSERT INTO Teaches(CRN, Semester, Year, NetId)
                    VALUES(temp_CRN, temp_Semester, temp_Year, temp_NetId);
                END IF;
            END WHILE;
        UNTIL done
        END REPEAT;
        CLOSE section_cur;
    END