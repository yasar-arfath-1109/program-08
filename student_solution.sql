CREATE TABLE Employee (
    EmployeeID INT,
    EmployeeName VARCHAR(20),
    Department VARCHAR(20),
    Salary INT
);

INSERT INTO Employee VALUES
(101, 'Ravi', 'HR', 25000),
(102, 'Meena', 'IT', 40000),
(103, 'Kumar', 'Finance', 35000),
(104, 'Suresh', 'IT', 45000),
(105, 'Latha', 'HR', 30000);

SELECT COUNT(Salary) AS TotalEmployees FROM Employee;

SELECT MAX(Salary) AS MaximumSalary FROM Employee;

SELECT MIN(Salary) AS MinimumSalary FROM Employee;

SELECT AVG(Salary) AS AverageSalary FROM Employee;
