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
SELECT department_id, MIN(salary) as min_salary FROM Employees GROUP BY department_id HAVING MIN(salary) > (SELECT MIN(salary) from Employees where department_id = 50);

-- 7
SELECT MAX(avg_salary) from (SELECT AVG(salary) as avg_salary FROM Employees GROUP BY department_id) as EM;

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
FROM Employees as E join Departments D on D.department_id = E.department_id where E.hire_dat between '1995-01-01' and '2021-02-01' and E.salary between 1000 and 9999;