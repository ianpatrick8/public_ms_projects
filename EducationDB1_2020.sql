DROP TABLE STUDENT CASCADE CONSTRAINTS;
CREATE TABLE STUDENT(
ID CHAR(3),
Name VARCHAR2(20),
Midterm NUMBER(3,0) CHECK (Midterm>=0 AND Midterm<=100), Final NUMBER(3,0) CHECK (Final>=0 AND Final<=100), Homework NUMBER(3,0) CHECK (Homework>=0 AND Homework<=100), PRIMARY KEY (ID)
);
INSERT INTO STUDENT VALUES ( '445', 'Seinfeld', 85, 90, 99 );
INSERT INTO STUDENT VALUES ( '909', 'Costanza', 74, 72, 86 );
INSERT INTO STUDENT VALUES ( '123', 'Benes', 93, 89, 91 );
INSERT INTO STUDENT VALUES ( '111', 'Kramer', 99, 91, 93 );
INSERT INTO STUDENT VALUES ( '667', 'Newman', 78, 82, 83 );
INSERT INTO STUDENT VALUES ( '888', 'Banya', 50, 65, 50 );
SELECT * FROM STUDENT;
DROP TABLE WEIGHTS CASCADE CONSTRAINTS;
CREATE TABLE WEIGHTS(
    MidPct NUMBER(2,0) CHECK (MidPct>=0 AND MidPct<=100),
    FinPct NUMBER(2,0) CHECK (FinPct>=0 AND FinPct<=100),
    HWPct NUMBER(2,0) CHECK (HWPct>=0 AND HWPct<=100)
);
INSERT INTO WEIGHTS VALUES ( 30, 30, 40 );
SELECT * FROM WEIGHTS;
SELECT * FROM STUDENT;
COMMIT;


-- Part 2
-- anonymous PLS/SQL block
-- reports 3 weights in WEIGHTS table
-- outputs name of each student in STUDENT table and their overall score
-- overall score computed as x percent Midterm, y percent Final, z percent Homework
-- x, y, and z are the corresponding percentages found in the WEIGHTS table
-- converts each student's overall score to a letter grade by rule:
-- A = 90-100, B = 80-89.99, C = 65-79.99, F = 0-64.99
-- includes letter grade in output

SET SERVEROUTPUT ON;
DECLARE
    midtermPct WEIGHTS.midpct%type;
    finalPct WEIGHTS.finpct%type;
    homeworkPct WEIGHTS.hwpct%type;
    studentScore NUMBER(4,1);
    studentGrade VARCHAR2(1);
    
    studentInfo STUDENT%rowtype;
    cursor Students is SELECT * FROM STUDENT;
    
BEGIN

    SELECT midpct, finpct, hwpct
    INTO midtermPct, finalPct, homeworkPct
    FROM WEIGHTS;
    
    DBMS_OUTPUT.PUT_LINE('Weights:');
    DBMS_OUTPUT.PUT_LINE('Midterm Final Homework');
    DBMS_OUTPUT.PUT_LINE('   '||midtermPct||',   ' ||finalPct||',   ' ||homeworkPct);
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Grades: ');
    
    for student in Students
    loop
        studentScore := (student.midterm*midtermPct + student.final*finalpct + 
        student.homework*homeworkpct)/100;
        CASE 
        WHEN(studentScore >= 90) THEN studentGrade := 'A';
        WHEN(studentScore >= 80) THEN studentGrade := 'B';
        WHEN(studentScore >= 90) THEN studentGrade := 'C';
        ELSE studentGrade := 'F';    
        END CASE;
        
        DBMS_OUTPUT.PUT_LINE(student.id||' '||student.name||' '||studentScore||' '||studentGrade);
    end loop;
    
END;

-- Part 3

DROP TABLE ENROLLMENT CASCADE CONSTRAINTS;
DROP TABLE SECTION CASCADE CONSTRAINTS;
CREATE TABLE SECTION(
SectionID     CHAR(5),
 Course   VARCHAR2(7),
 Students NUMBER DEFAULT 0,
 CONSTRAINT PK_SECTION
          PRIMARY KEY (SectionID)
);
CREATE TABLE ENROLLMENT(
 SectionID     CHAR(5),
 StudentID     CHAR(7),
 CONSTRAINT PK_ENROLLMENT
          PRIMARY KEY (SectionID, StudentID),
 CONSTRAINT FK_ENROLLMENT_SECTION
          FOREIGN KEY (SectionID)
          REFERENCES SECTION (SectionID)
);
INSERT INTO SECTION (SectionID, Course) VALUES ( '12345', 'CSC 355'
);
INSERT INTO SECTION (SectionID, Course) VALUES ( '22109', 'CSC 309'
);
INSERT INTO SECTION (SectionID, Course) VALUES ( '99113', 'CSC 300'
);
INSERT INTO SECTION (SectionID, Course) VALUES ( '99114', 'CSC 300'
);
COMMIT;
SELECT * FROM SECTION;

-- A. Trigger for Insert - checks section value

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER sectionVal
BEFORE INSERT ON ENROLLMENT 
FOR EACH ROW 
DECLARE
    studentCount NUMBER;
BEGIN
    SELECT COUNT(*) INTO studentCount
    FROM ENROLLMENT 
    WHERE SectionID = :new.SectionID;
    studentCount := studentCount + 1;
    if studentCount > 5 THEN
    raise_application_error(-20102, 'Section is full, cannot add student');
    elsif studentCount <= 5 THEN 
        UPDATE SECTION SET SECTION.Students = studentCount
        WHERE SECTION.SectionID = :new.SectionID;
    END IF;
END;

-- Sample Test Data
INSERT INTO ENROLLMENT VALUES ('12345', '1234567'); 
INSERT INTO ENROLLMENT VALUES ('12345', '2234567'); 
INSERT INTO ENROLLMENT VALUES ('12345', '3234567');
INSERT INTO ENROLLMENT VALUES ('12345', '4234567'); 
INSERT INTO ENROLLMENT VALUES ('12345', '5234567'); 
INSERT INTO ENROLLMENT VALUES ('12345', '6234567'); 
SELECT * FROM Section;
SELECT * FROM Enrollment;


-- B. Trigger for Deletion - updates affected sections, checks for accuracy

CREATE OR REPLACE TRIGGER deletionVal
BEFORE DELETE ON ENROLLMENT 
FOR EACH ROW
BEGIN
    UPDATE SECTION
    SET Students = Students - 1
    WHERE SectionID = :old.SectionID;
END;


DELETE FROM ENROLLMENT WHERE StudentID = '1234567'; 
SELECT * FROM Section;
SELECT * FROM Enrollment;







