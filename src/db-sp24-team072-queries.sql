--List of professors who teach 400 and 500 level courses with avg GPA greater than 3.5, group by department name--
SELECT
    p.FirstName,
    p.LastName,
    p.Netid,
    g.CourseNum,
    d.Department,
    g.CourseName,
    g.Avg_grade
FROM
    Professors p
    JOIN Teaches t ON t.NetId = p.NetId
    JOIN GPAHistory g ON g.CRN = t.CRN
    JOIN Departments d ON d.DepartmentCode = g.DepartmentCode
WHERE
    g.CourseNum LIKE "4%"
    OR g.CourseNum LIKE "5%"
GROUP BY
    d.Department,
    p.FirstName,
    p.LastName,
    p.Netid,
    g.CourseNum,
    g.CourseName,
    g.Avg_grade
HAVING
    avg(g.avg_grade) > 3.5
ORDER BY
    g.avg_grade DESC,
    d.department ASC
LIMIT
    15;

--Ranking of departments based on their academic performance, represented by the average GPA of courses offered, and the breadth of their academic offerings, indicated by the number of distinct courses available.--
--Departments with higher average GPAs and more course offerings are considered to be of higher academic standing.--
WITH DepartmentGPA AS (
    SELECT
        DepartmentCode,
        AVG(Avg_Grade) AS AverageGPA
    FROM
        GPAHistory
    GROUP BY
        DepartmentCode
),
DepartmentCourses AS (
    SELECT
        DepartmentCode,
        Count(DISTINCT CourseNum) AS CourseCount
    FROM
        GeneralCourse
    GROUP BY
        DepartmentCode
),
DepartmentRanking AS (
    SELECT
        d.DepartmentCode,
        d.Department,
        IFNULL(g.AverageGPA, 0) AS AvgGPA,
        IFNULL(c.CourseCount, 0) AS CourseCount,
        (
            IFNULL(g.AverageGPA, 0) * 0.7 + IFNULL(c.CourseCount, 0) * 0.3
        ) AS CombinedScore
    FROM
        Departments d
        LEFT JOIN DepartmentGPA g ON d.DepartmentCode = g.DepartmentCode
        LEFT JOIN DepartmentCourses c ON d.DepartmentCode = c.DepartmentCode
)
SELECT
    DepartmentCode,
    Department,
    AvgGPA,
    CourseCount,
    CombinedScore,
    RANK() OVER (
        ORDER BY
            CombinedScore DESC
    ) AS Ranking
FROM
    DepartmentRanking
ORDER BY
    CombinedScore DESC,
    DepartmentCode
LIMIT
    15;

--List of 1 Credit course offered by the CS department having avg_grade > 3.9--
SELECT
    DISTINCT c.CourseNum,
    c.CourseName,
    c.CreditHours,
    g.Semester,
    g.Year,
    g.Avg_grade
FROM
    GeneralCourse c
    JOIN GPAHistory g ON g.CourseNum = c.CourseNum
WHERE
    c.CreditHours = '1 hours.'
    AND g.Year IN (2022, 2023)
    AND g.Semester LIKE ‘ Sp % ’
GROUP BY
    c.CourseNum,
    c.CourseName,
    c.CreditHours,
    g.Semester,
    g.Year,
    g.Avg_grade
HAVING
    g.Avg_grade >= 3.9
ORDER BY
    g.CourseNum DESC
LIMIT
    15;

--List the Number of Courses offered by the CS and ECE departments with an avg_grade greater than or equal to 3.5 using Union.--
SELECT
    g.DepartmentCode,
    c.CourseNum,
    c.CourseName,
    c.CreditHours,
    g.Semester,
    g.Avg_grade
FROM
    GeneralCourse c
    JOIN GPAHistory g ON g.CourseNum = c.CourseNum
WHERE
    g.DepartmentCode = 'CS'
    AND g.CourseNum LIKE '5%'
    AND g.Avg_grade >= 3.5
GROUP BY
    g.DepartmentCode,
    c.CourseNum,
    c.CourseName,
    c.CreditHours,
    g.Semester,
    g.Avg_grade
UNION
SELECT
    g.DepartmentCode,
    c.CourseNum,
    c.CourseName,
    c.CreditHours,
    g.Semester,
    g.Avg_grade
FROM
    GeneralCourse c
    JOIN GPAHistory g ON g.CourseNum = c.CourseNum
WHERE
    g.DepartmentCode = 'ECE'
    AND g.CourseNum LIKE '5%'
    AND g.Avg_grade >= 3.5
GROUP BY
    g.DepartmentCode,
    c.CourseNum,
    c.CourseName,
    c.CreditHours,
    g.Semester,
    g.Avg_grade
ORDER BY
    Semester
LIMIT
    15;

--