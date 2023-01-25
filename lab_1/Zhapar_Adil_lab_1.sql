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
SELECT employee_id, full_name, email, salary * 12 as annual_salary FROM Employees;

-- 3
SELECT DISTINCT job_id from Employees;

-- 4
SELECT * FROM Employees WHERE job_id = 'IT_PROG' AND salary > 5000;

-- 5
SELECT employee_id, full_name, job_id FROM Employees WHERE salary BETWEEN 4000 AND 7000;

-- 6
SELECT full_name, salary from Employees WHERE salary NOT BETWEEN 3000 AND 9000;

-- 7
SELECT employee_id, full_name, salary * 12 as annual_salary from Employees where salary * 12 < 50000;

-- 8
SELECT employee_id, full_name, salary FROM Employees WHERE salary > 4000 AND salary < 7000;
-- The difference with task 5 is that BETWEEN takes ranges inclusively while operators not

-- 9
SELECT employee_id, full_name, salary, job_id FROM Employees WHERE employee_id IN (144, 102, 200, 205);

-- 10
SELECT employee_id, full_name, salary, job_id FROM Employees WHERE employee_id NOT IN (144, 102, 200, 205);

-- 11
SELECT employee_id, full_name, salary from Employees WHERE full_name LIKE '% _a%';

-- 12
SELECT full_name FROM Employees WHERE full_name LIKE '__a%';

-- 13
SELECT employee_id, full_name, email, salary FROM Employees WHERE
        email =  CONCAT(SUBSTRING(full_name, 1, 1),
            UPPER(SUBSTRING(full_name, PATINDEX('% %', full_name) + 1, LEN(full_name) - PATINDEX('% %', full_name))));

-- 14
SELECT employee_id, full_name, email, salary from Employees ORDER BY salary, hire_dat DESC ;

-- 15
SELECT employee_id, full_name, salary FROM Employees ORDER BY employee_id DESC;

-- 16
SELECT AVG(salary) as avg, MAX(salary) as max,
       MIN(salary) as min, SUM(salary) as sum from Employees;

-- 17
SELECT * FROM Employees WHERE SUBSTRING(phone_number, 1, 1) = SUBSTRING(REVERSE(phone_number), 1, 1);

-- 18
SELECT COUNT(DISTINCT(job_id)) as number_of_jobs from Employees;

-- 19
SELECT SUM(salary) as salary_sums, job_id FROM Employees GROUP BY job_id;

-- 20
SELECT AVG(salary) as salary_avg, job_id FROM Employees GROUP BY job_id;

-- 21
SELECT MAX(salary) as max_salary, job_id FROM Employees  WHERE salary > 10000 GROUP BY job_id ORDER BY max_salary DESC;

-- 22
SELECT MAX(avg_salary) as max_salary
FROM (SELECT job_id, AVG(salary) AS avg_salary
      FROM Employees group by job_id) as maxSalary;

-- 23
SELECT CONCAT(full_name, ' earns ', salary, ' per month, but wants ', salary * 3) as [Dream Salaries] FROM Employees;

-- 24
SELECT full_name, LEN(full_name) as length from Employees;

-- 25
SELECT SUBSTRING(full_name, 1, CHARINDEX(' ', full_name)) as full_name from Employees;

-- 26
SELECT SUBSTRING(full_name, 1, 3) from Employees;

-- 27
SELECT REVERSE(full_name) FROM Employees;

-- 28
SELECT REPLACE(full_name, 'en', 'yu') from Employees;

-- 29
SELECT UPPER(full_name) from Employees;

-- 30
SELECT full_name, MIN(hire_dat) AS hire_dat, job_id from Employees
                                                    GROUP BY job_id, full_name ORDER BY hire_dat;
-- Not the hardest, but usually required query to find earliest employees in each job category