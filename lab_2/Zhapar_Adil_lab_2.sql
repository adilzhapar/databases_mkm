ALTER TABLE Employees
ADD department_id INT;

ALTER TABLE Employees
ADD FOREIGN KEY (department_id) REFERENCES Departments(department_id);

UPDATE Employees SET Employees.department_id = 10 WHERE SUBSTRING(job_id, 1, 2) = 'AD';
UPDATE Employees SET Employees.department_id = 20 WHERE SUBSTRING(job_id, 1, 2) = 'MK';
UPDATE Employees SET Employees.department_id = 50 WHERE SUBSTRING(job_id, 1, 2) = 'SH';
UPDATE Employees SET Employees.department_id = 60 WHERE SUBSTRING(job_id, 1, 2) = 'IT';
UPDATE Employees SET Employees.department_id = 80 WHERE SUBSTRING(job_id, 1, 2) = 'SA';
UPDATE Employees SET Employees.department_id = 110 WHERE SUBSTRING(job_id, 1, 2) = 'AC';

-- 1
SELECT * FROM Employees WHERE salary > (SELECT AVG(salary) from Employees WHERE department_id = 60);

-- 2
SELECT employee_id, full_name, salary, department_id FROM Employees WHERE salary in (SELECT min(salary) from Employees group by department_id);

-- 3
SELECT * FROM Departments WHERE department_id in
                                (SELECT department_id from Employees WHERE hire_dat in
                           (select min(hire_dat) from Employees group by department_id));

-- 4
SELECT * FROM Employees where len(full_name) = (SELECT max(LEN(replace(full_name, ' ', ''))) from Employees);

-- 5
select AVG(salary) from Employees group by department_id having count(department_id) =  (SELECT MAX (mycount)
FROM (SELECT department_id, COUNT(department_id) mycount
FROM Employees
GROUP BY department_id) as Em);

-- 6
SELECT department_id, MIN(salary) as min_salary
FROM Employees
GROUP BY department_id
HAVING MIN(salary) > (SELECT MIN(salary) from Employees where department_id = 50);

-- 7
SELECT MAX(avg_salary) from (SELECT AVG(salary) as avg_salary
                             FROM Employees GROUP BY department_id) as EM;

-- 8
SELECT full_name, department_name
FROM Employees JOIN Departments D on Employees.department_id = D.department_id;

-- 9
select department_name
from Departments where department_id != ALL(select department_id from Employees);

-- 10
select E.full_name, J.gra
FROM Employees AS E JOIN Job_grades AS J ON E.salary BETWEEN J.lowest_sal AND J.highest_sal;

-- 11
SELECT E.full_name, E.job_id, D.department_name, E.hire_dat
FROM Employees as E join Departments D on D.department_id = E.department_id
where E.hire_dat between '1995-01-01' and '2021-02-01' and E.salary between 1000 and 9999;


-- PART TWO
CREATE TABLE Locations (
    location_id INT primary key ,
    location_name VARCHAR(50),
    country_id VARCHAR(10)
);

INSERT INTO Locations VALUES (1700, 'Barcelona', 'ESP');
INSERT INTO Locations VALUES (1800, 'Tokyo', 'JPN');
INSERT INTO Locations VALUES (1500, 'Kyoto', 'JPN');
INSERT INTO Locations VALUES (1400, 'Madrid', 'ESP');
INSERT INTO Locations VALUES (2500, 'Valencia', 'ESP');

-- 12
SELECT E.full_name, L.location_name
FROM Employees AS E JOIN Departments AS D
ON E.department_id = D.department_id
JOIN Locations L on D.location_id = L.location_id;

-- 13
SELECT E.full_name, L.location_name, E.salary * 0.1
    AS montly_pension_contribution, E.salary * 0.1 * 12 as annual_pension_contribution,
                                    E.salary * 0.9 * 0.1 as medical_contribution
FROM Employees AS E JOIN Departments AS D
ON E.department_id = D.department_id
JOIN Locations L on D.location_id = L.location_id;

-- 14
SELECT TOP 3 L.location_name, AVG(SALARY) as avg_salary
FROM Employees AS E JOIN Departments AS D
ON E.department_id = D.department_id
JOIN Locations L on D.location_id = L.location_id
GROUP BY L.location_name
ORDER BY avg_salary DESC;

-- 15
SELECT * FROM Employees WHERE department_id = 50
                          AND employee_id != ALL(SELECT manager_id
                        from Departments where department_id = 50);

-- 16
SELECT E.*
FROM Employees AS E JOIN Departments AS D
ON E.department_id = D.department_id
JOIN Locations L on D.location_id = L.location_id
AND L.location_id = 1400;

-- 17
SELECT *
FROM Employees
WHERE employee_id NOT IN
      (SELECT manager_id FROM Departments where manager_id IS NOT NULL);

-- 18
SELECT E.employee_id, L.location_name
FROM Employees E INNER JOIN Departments D
    on D.department_id = E.department_id
INNER JOIN Locations L on D.location_id = L.location_id AND E.employee_id = 103;

-- 19
SELECT D.manager_id, COUNT(employee_id) - 1
FROM Employees E JOIN Departments D on E.department_id = D.department_id
GROUP BY manager_id;

-- 20
SELECT * FROM Employees
WHERE employee_id IN (SELECT manager_id FROM Departments);

-- PART THREE

CREATE TABLE Countries (
    country_id VARCHAR(10) PRIMARY KEY ,
    country_name VARCHAR(50),
    region_id INT
);

INSERT INTO Countries VALUES('JPN', 'Japan', 1);
INSERT INTO Countries VALUES('ESP', 'Spain', 2);

ALTER TABLE Locations
ADD FOREIGN KEY (country_id) REFERENCES Countries(country_id);

-- 21
SELECT DISTINCT (D.department_id), C.country_name, L.location_name
FROM Employees
    JOIN Departments D on D.department_id = Employees.department_id
    JOIN Locations L on D.location_id = L.location_id
    JOIN Countries C on L.country_id = C.country_id
WHERE D.department_id IN
    (SELECT department_id
     FROM Employees
     GROUP BY department_id
     HAVING COUNT(department_id) >= 2);

-- 22
SELECT E.full_name, L.location_name
FROM Employees E JOIN Departments D on D.department_id = E.department_id
JOIN Locations L on D.location_id = L.location_id
WHERE location_name = 'Barcelona';