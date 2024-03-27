# DDL for team072 database for CS 411 SP24

CREATE TABLE Professors(
    NetId                   VARCHAR(255) PRIMARY KEY,
    LastName                VARCHAR(255),
    FirstName               VARCHAR(255),
    Department              VARCHAR(255)
);

CREATE TABLE Users(
    Email                   VARCHAR(255) PRIMARY KEY,
    Password                VARCHAR(255),
    LastName                VARCHAR(255),
    FirstName               VARCHAR(255)
);

CREATE TABLE GeneralCourse(
    CourseNum               INT,
    Name                    VARCHAR(255),
    Department              VARCHAR(10),
    CreditHours             INT,
    Description             VARCHAR(16384),
    PreReqs                 VARCHAR(1024),
    PRIMARY KEY (CourseNum, Name, Department)
);

CREATE TABLE SectionAttributes(
    CRN                     INT,
    Semester                VARCHAR(16),
    Year                    INT,
    LastNameFirstIni        VARCHAR(255),
    Department              VARCHAR(10),
    Name                    VARCHAR(255),
    CourseNum               INT,
    FOREIGN KEY (Department, Name, CourseNum) REFERENCES GeneralCourse(Department, Name, CourseNum) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (CRN, Semester, Year)
);

CREATE TABLE GPAHistory(
    CRN                     INT,
    Semester                VARCHAR(16),
    Year                    INT,
    A+ INT, A INT, A- INT, B+ INT, B INT, B- INT, C+ INT, C INT, C- INT, D+ INT, D INT, D- INT, F INT,
    CourseNum               INT,
    Department              VARCHAR(10),
    CourseName              VARCHAR(255),
    Instructor              VARCHAR(255),
    Sched_Type              VARCHAR(10),
    Avg_Grade               DECIMAL,
    FOREIGN KEY (CourseNum, Department, CourseName) REFERENCES GeneralCourse(CourseNum, Department, Name) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (CRN, Semester, Year)
);

CREATE TABLE Teaches(
    CRN                     INT,
    Semester                VARCHAR(16),
    Year                    INT,
    NetId                   VARCHAR(255),
    FOREIGN KEY (CRN, Semester, Year) REFERENCES SectionAttributes(CRN, Semester, Year) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (NetId) REFERENCES Professors(NetId) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (CRN, Semester, Year, NetId)
);

CREATE TABLE UserFeedback(
    FeedbackId              VARCHAR(255) PRIMARY KEY,
    Email                   VARCHAR(255),
    Year                    INT,
    CRN                     INT,
    Semester                VARCHAR(16),
    Testimony               VARCHAR(16384),
    Rating                  DECIMAL,
    Difficulty              DECIMAL,
    TimeCommit              DECIMAL,
    Time_stamp              TIMESTAMP, 
    LastName                VARCHAR(255),
    FirstName               VARCHAR(255),
    FOREIGN KEY (Email) REFERENCES Users(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Year, CRN, Semester) REFERENCES SectionAttributes(Year, CRN, Semester) ON DELETE CASCADE ON UPDATE CASCADE
);
