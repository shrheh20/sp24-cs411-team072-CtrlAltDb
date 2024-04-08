--List of professors who teach 400 and 500 level courses with avg GPA greater than 3.5, group by department name--

Select p.FirstName, p.LastName, p.Netid, g.CourseNum, d.Department, g.CourseName, g.Avg_grade 
from Professors p join Teaches t on t.NetId=p.NetId  
Join GPAHistory g on g.CRN=t.CRN 
Join Departments d on d.DepartmentCode=g.DepartmentCode 
Where g.CourseNum like "4%" or g.CourseNum like "5%" 
Group by d.Department, p.FirstName, p.LastName, p.Netid, g.CourseNum, g.CourseName, g.Avg_grade 
Having avg(g.avg_grade) >3.5 
Order by g.avg_grade desc, d.department asc 
limit 15;

--Ranking of departments based on their academic performance, represented by the average GPA of courses offered, and the breadth of their academic offerings, indicated by the number of distinct courses available.--
--Departments with higher average GPAs and more course offerings are considered to be of higher academic standing.--

With DepartmentGPA AS (
    Select DepartmentCode, AVG(Avg_Grade) AS AverageGPA 
    From GPAHistory Group By DepartmentCode
), DepartmentCourses AS (
    Select DepartmentCode, Count(DISTINCT CourseNum) AS CourseCount
    From GeneralCourse Group By DepartmentCode
), DepartmentRanking AS (
    Select 
        d.DepartmentCode, d.Department,
        IFNULL(g.AverageGPA, 0) AS AvgGPA,
        IFNULL(c.CourseCount, 0) AS CourseCount,
        (IFNULL(g.AverageGPA, 0) * 0.7 + IFNULL(c.CourseCount, 0) * 0.3) AS CombinedScore
    From Departments d LEFT JOIN DepartmentGPA g ON d.DepartmentCode = g.DepartmentCode LEFT JOIN DepartmentCourses c ON d.DepartmentCode = c.DepartmentCode
)
Select DepartmentCode,Department,AvgGPA,CourseCount,CombinedScore, 
RANK() OVER (ORDER BY CombinedScore DESC) AS Ranking
From DepartmentRanking
Order By CombinedScore DESC, DepartmentCode
LIMIT 15;


--List of 1 Credit course offered by the CS department having avg_grade > 3.9--

Select distinct c.CourseNum, c.CourseName, c.CreditHours, g.Semester, g.Year, g. Avg_grade 
from GeneralCourse c join GPAHistory g on g.CourseNum=c.CourseNum
Where c.CreditHours='1 hours.' and g.Year in (2022,2023) AND g.Semester LIKE ‘Sp%’ 
Group by c.CourseNum, c.CourseName, c.CreditHours, g.Semester, g.Year, g. Avg_grade 
Having g.Avg_grade >=3.9 
Order by g.CourseNum desc Limit 15;

--List the Number of Courses offered by the CS and ECE departments with an avg_grade greater than or equal to 3.5 using Union.--

SELECT g.DepartmentCode, c.CourseNum, c.CourseName, c.CreditHours, g.Semester, g.Avg_grade
FROM GeneralCourse c
JOIN GPAHistory g ON g.CourseNum = c.CourseNum
WHERE g.DepartmentCode = 'CS' AND g.CourseNum LIKE '5%' AND g.Avg_grade >= 3.5
GROUP BY g.DepartmentCode, c.CourseNum, c.CourseName, c.CreditHours, g.Semester, g.Avg_grade

UNION

SELECT g.DepartmentCode, c.CourseNum, c.CourseName, c.CreditHours, g.Semester, g.Avg_grade
FROM GeneralCourse c
JOIN GPAHistory g ON g.CourseNum = c.CourseNum
WHERE g.DepartmentCode = 'ECE' AND g.CourseNum LIKE '5%' AND g.Avg_grade >= 3.5
GROUP BY g.DepartmentCode, c.CourseNum, c.CourseName, c.CreditHours, g.Semester, g.Avg_grade

ORDER BY Semester
LIMIT 15;

--

