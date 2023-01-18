-- Zhapar Adil

CREATE TABLE Employees (
    employee_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(50),
    hire_dat DATE,
    job_id VARCHAR(50),
    salary INTEGER
);

CREATE TABLE Departments (
    department_id INTEGER PRIMARY KEY ,
    department_name VARCHAR(50),
    manager_id INTEGER,
    location_id INTEGER
);

CREATE TABLE Job_grades (
    gra CHAR(1),
    lowest_sal INTEGER,
    highest_sal INTEGER
);

-- INSERT INTO Employees VALUES (lorem ipsum)

-- 1
SELECT employee_id, full_name, hire_dat, salary FROM Employees;

-- 2
SELECT employee_id, full_name, email, salary * 12 FROM Employees;

-- 3
    SELECT DISTINCT job_id from Employees;

-- 4
SELECT * FROM Employees WHERE job_id = 'IT_PROG' AND salary > 5000;

-- 5
SELECT employee_id, full_name, job_id FROM Employees WHERE salary BETWEEN 4000 AND 7000;

-- 6
SELECT full_name, salary from Employees WHERE salary NOT BETWEEN 3000 AND 9000;

-- 7
SELECT employee_id, full_name, salary * 12 from Employees where salary * 12 < 50000;

-- 8
SELECT employee_id, full_name, salary FROM Employees WHERE salary > 4000 AND salary < 7000;
-- The difference with task 5 is that BETWEEN takes ranges inclusively while operators not

