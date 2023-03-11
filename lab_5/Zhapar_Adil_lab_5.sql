-- 1
CREATE TABLE Unit (
    UnitId VARCHAR(3) PRIMARY KEY ,
    Topic VARCHAR(10),
    Room INT,
    Book VARCHAR(20)
);

CREATE TABLE Student (
    StudentId VARCHAR(10),
    UnitId VARCHAR(3) FOREIGN KEY REFERENCES Unit(UnitId),
    CONSTRAINT PK_Student PRIMARY KEY (StudentId, UnitId),
);

CREATE TABLE Tutor (
    TutorId VARCHAR(10) PRIMARY KEY ,
    TutEmail VARCHAR(20)
);

CREATE TABLE Grade (
    TutorId VARCHAR(10) FOREIGN KEY REFERENCES Tutor(TutorId),
    Date DATE ,
    UnitId VARCHAR(3),
    StudentId VARCHAR(10),
    Grade DECIMAL,
    CONSTRAINT PK_Grade PRIMARY KEY (StudentId, Date),
    FOREIGN KEY (StudentId, UnitId) REFERENCES Student(StudentId, UnitId)
);

INSERT INTO Unit VALUES('U1', 'GMT', 629, 'Deumlich');
INSERT INTO Unit VALUES('U2', 'Gln', 631, 'Zehnder');
INSERT INTO Unit VALUES('U5', 'PhF', 632, 'Dummlers');
INSERT INTO Unit VALUES('U4', 'AVQ', 621, 'SwissTopo');

INSERT INTO Student VALUES ('St1', 'U1');
INSERT INTO Student VALUES ('St1', 'U2');
INSERT INTO Student VALUES ('St4', 'U1');
INSERT INTO Student VALUES ('St2', 'U5');
INSERT INTO Student VALUES ('St2', 'U4');

INSERT INTO Tutor VALUES ('Tut1', 'tut1@fhbb.ch');
INSERT INTO Tutor VALUES ('Tut3', 'tut3@fhbb.ch');
INSERT INTO Tutor VALUES ('Tut5', 'tut5@fhbb.ch');

INSERT INTO Grade VALUES ('Tut1', '2003-02-23', 'U1', 'St1', 4.7);
INSERT INTO Grade VALUES ('Tut3', '2002-11-18', 'U2', 'St1', 5.1);
INSERT INTO Grade VALUES ('Tut1', '2003-02-23', 'U1', 'St4', 4.3);
INSERT INTO Grade VALUES ('Tut3', '2003-05-05', 'U5', 'St2', 4.3);
INSERT INTO Grade VALUES ('Tut5', '2003-07-04', 'U4', 'St2', 5.0);


-- 2
CREATE TABLE Manager (
    ManagerNo VARCHAR(20) PRIMARY KEY ,
    Position VARCHAR(20)
);


CREATE TABLE Project (
    ProjectName VARCHAR(20) PRIMARY KEY ,
    Budget NUMERIC,
    TeamSize INT,
    ManagerNo VARCHAR(20) foreign key references Manager(ManagerNo)
);

INSERT INTO Manager VALUES ('Manager1', 'CTO');
INSERT INTO Manager VALUES ('Manager2', 'CTO2');

INSERT INTO Project VALUES ('Project1', 11000000, 15, 'Manager1');
INSERT INTO Project VALUES ('Project2', 1500000, 12, 'Manager2');

-- 3
CREATE TABLE Movie (
    Id VARCHAR(10) primary key ,
    Name VARCHAR(30)
);

CREATE TABLE Actor (
    Id VARCHAR(10) PRIMARY KEY ,
    FirstName VARCHAR(20),
    LastName VARCHAR(20)
);

CREATE TABLE Assistant (
    Id VARCHAR(10) PRIMARY KEY ,
    FirstName VARCHAR(20),
    LastName VARCHAR(20)
);

CREATE TABLE Cast (
    ActorId VARCHAR(10) FOREIGN KEY REFERENCES Actor(Id),
    MovieId VARCHAR(10) FOREIGN KEY REFERENCES Movie(Id),
    Salary NUMERIC,
    AssistantId VARCHAR(10) FOREIGN KEY REFERENCES Assistant(Id),
    CONSTRAINT PK_Cast PRIMARY KEY (ActorId, MovieId)
);

INSERT INTO Movie VALUES('M100', 'Silent Code');
INSERT INTO Movie VALUES('M200', 'Winter Promises');

INSERT INTO Actor VALUES ('A11', 'Paloma', 'Luna');
INSERT INTO Actor VALUES ('A22', 'Logan', 'Jones');
INSERT INTO Actor VALUES ('A33', 'Esmeralda', 'Porter');
INSERT INTO Actor VALUES ('A44', 'Clive', 'Rooney');
INSERT INTO Actor VALUES ('A55', 'Maxwell', 'Smith');

INSERT INTO Assistant VALUES ('AA01', 'Julie', 'Jacobs');
INSERT INTO Assistant VALUES ('AA02', 'Bob', 'Becker');
INSERT INTO Assistant VALUES ('AA03', 'Lisa', 'Jacobs');

INSERT INTO Cast VALUES ('A11', 'M100', 1200000, 'AA01');
INSERT INTO Cast VALUES ('A22', 'M100', 1300000, 'AA01');
INSERT INTO Cast VALUES ('A33', 'M100', 1200100, 'AA02');
INSERT INTO Cast VALUES ('A44', 'M100', 500000, 'AA02');
INSERT INTO Cast VALUES ('A11', 'M200', 1000000, 'AA03');
INSERT INTO Cast VALUES ('A44', 'M200', 900000, 'AA01');
INSERT INTO Cast VALUES ('A55', 'M200', 300000, 'AA02');

-- 5
CREATE TABLE Lecturer (
    Id int primary key ,
    Name VARCHAR(40)
);

CREATE TABLE Course (
    Code VARCHAR(20) primary key ,
    Name VARCHAR(50),
    Department VARCHAR(10),
    Address VARCHAR(30),
    LecturerId INT FOREIGN KEY REFERENCES Lecturer(Id)
);

CREATE TABLE Student_5 (
    No VARCHAR(30),
    CourseCode VARCHAR(20) FOREIGN KEY REFERENCES Course(Code),
    CONSTRAINT PK_Student_5 primary key (No, CourseCode)
);

INSERT INTO Lecturer VALUES (1234, 'John');
INSERT INTO Lecturer VALUES (4567, 'Ali');
INSERT INTO Lecturer VALUES (6789, 'Mary');

INSERT INTO Course VALUES ('ECC202', 'DBMS', 'COM', 'Nicosia', 1234);
INSERT INTO Course VALUES ('ECC002', 'System Simulation', 'COM', 'Nicosia', 4567);
INSERT INTO Course VALUES ('COM490', 'Graduation Project', 'COM', 'Nicosia', 6789);

INSERT INTO Student_5 VALUES ('202101234', 'ECC202');
INSERT INTO Student_5 VALUES ('202101234', 'ECC002');
INSERT INTO Student_5 VALUES ('202101234', 'COM490');

SELECT S.No, C.name, L.name
FROM Student_5 as S join Course C
    on S.CourseCode = C.Code
join Lecturer L on C.LecturerId = L.Id;
