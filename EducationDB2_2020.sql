
--2a

PurchaseAmt Number(6,2) Check( PurchaseAmt >= 0)

--2b

Street CHAR(10) Check(Street LIKE ‘A%’)

--2c
DROP TABLE Student;
DROP TABLE Grade;
DROP TABLE Course;

CREATE TABLE Student
    (
    StudentID Number (20) NOT NULL,
    Name VARCHAR2(30),
    Address VARCHAR2(30),
    GradYear NUMBER (4),
    
        PRIMARY KEY(StudentID)
    );
    
CREATE TABLE Course
    (
    CName VARCHAR2(30) NOT NULL,
    Department VARCHAR2(30),
    Credits NUMBER(2),
    
        PRIMARY KEY(CName)
    );
    
CREATE TABLE Grade
    (
        CName VARCHAR2(30) NOT NULL,
        StudentID NUMBER(20) NOT NULL,
        CGrade NUMBER(5,2),
        
        PRIMARY KEY(CName, StudentID),
        
        FOREIGN KEY(StudentID)
            REFERENCES Student(StudentID),
        FOREIGN KEY(CName)
            REFERENCES Course(CName)
    );

INSERT INTO Student VALUES(111, 'Charles Henry Johnson', 'Chicago, IL', 2014);
INSERT INTO Student VALUES(234, 'Olivia Muriel Munn', 'Peoria, IL', 2014);
INSERT INTO Student VALUES(322, 'Chad Quincy Ochocinco', 'Madison, WI', 2014);
INSERT INTO Student VALUES(436, 'Abigail Marie Spanberger', 'Saint Paul, MN', 2014);
INSERT INTO Student VALUES(524, 'Josh Mark Harnett', 'Minneapolis, MN', 2014);
INSERT INTO Student VALUES(675, 'Mary Anne Ryan', 'Los Angeles, CA', 2014);

INSERT INTO Course VALUES('Artificial Intelligence', 'Data Science', 4);  
INSERT INTO Course VALUES('Machine Learning', 'Data Science', 4);
INSERT INTO Course VALUES('Python Programming', 'Computer Science', 4);
INSERT INTO Course VALUES('Statistics', 'Mathematics', 3);
INSERT INTO Course VALUES('Business Analytics', 'Business', 3);

INSERT  INTO Grade VALUES('Artificial Intelligence', 436, 4.0);
INSERT  INTO Grade VALUES('Statistics', 111, 3.5);
INSERT  INTO Grade VALUES('Machine Learning', 234, 4.0);
INSERT  INTO Grade VALUES('Business Analytics', 675, 3.5);
INSERT  INTO Grade VALUES('Python Programming', 524, 4.0);
INSERT  INTO Grade VALUES('Artificial Intelligence', 234, 4.0);
INSERT  INTO Grade VALUES('Statistics', 322, 3.5);
INSERT  INTO Grade VALUES('Machine Learning', 524, 4.0);
INSERT  INTO Grade VALUES('Artificial Intelligence', 111, 4.0);
INSERT  INTO Grade VALUES('Business Analytics', 322, 3.5);
INSERT  INTO Grade VALUES('Machine Learning', 436, 4.0);



SELECT * FROM Course    
SELECT * FROM Student

--2.1

SELECT StudentID, Name 
FROM Student 
WHERE GradYear <= (SELECT MIN(GradYear) From Student) + 3;

--2.2

SELECT s.Name, g.CName
From Student s, Grade g
Where g.StudentID = s.StudentID AND s.Name LIKE '%Muriel%'
ORDER BY g.CGrade ASC;

--2.3

SELECT s.name, s.gradyear
FROM Student s
WHERE s.studentid in (SELECT s.studentid sid FROM student s LEFT JOIN grade g
ON s.studentid = g.studentid
GROUP BY s.studentid
HAVING COUNT(g.cname)<=1);

--2.4

SELECT Course.DEPARTMENT, ROUND(avg(length(stud.name)),2) FROM 
(SELECT s.StudentID as SID, s.Name as Name, s.Address AS Address, s.GradYear AS GradYear, g.CName AS CName, g.CGrade AS CGrade
FROM Student s LEFT OUTER JOIN Grade g
ON s.StudentID = g.StudentID) stud FULL OUTER JOIN 
Course ON stud.cname = course.cname
group by course.department
having course.department != 'null';

--2.4

UPDATE Student
SET GradYear = GradYear - 1
WHERE Address LIKE '%Chicago%';

--2.5

ALTER TABLE Course
ADD Chair CHAR(25);



-- Part 4 (e)
DROP TABLE together

CREATE TABLE together AS 
select temp1.SID, temp1.Name, temp1.Address, temp1.GradYear, course.CName, temp1.CGrade, Course.Department, Course.Credits from
(SELECT s.StudentID as SID, s.Name as Name, s.Address as Address, s.GradYear as GradYear, g.CName as CName, g.CGrade as Cgrade
FROM Student s LEFT OUTER JOIN Grade g
ON s.StudentID = g.StudentID) temp1 FULL OUTER JOIN
Course ON temp1.cname = course.cname
ORDER BY temp1.SID;

SELECT * FROM together;

SELECT Department, AVG(Cgrade), COUNT(*)
FROM together 
GROUP BY Department
HAVING Department != 'null';


    