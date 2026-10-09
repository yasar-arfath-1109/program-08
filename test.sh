#!/bin/bash

MYSQL="mysql -h127.0.0.1 -P3306 -uroot -proot"

echo "========================================"
echo " Employee Aggregate Functions Assignment"
echo "========================================"

if [ ! -f "student_solution.sql" ]; then
    echo "FAIL: student_solution.sql file not found."
    exit 1
fi

echo "Creating fresh CollegeDB database..."

$MYSQL -e "DROP DATABASE IF EXISTS CollegeDB;"
$MYSQL -e "CREATE DATABASE CollegeDB;"

echo "Executing student_solution.sql..."

if ! $MYSQL CollegeDB < student_solution.sql; then
    echo "FAIL: Error while executing student_solution.sql"
    exit 1
fi

echo ""
echo "Checking Employee table..."
echo ""

MARKS=0

# ----------------------------------------
# Test Case 1: Employee table exists
# ----------------------------------------

TABLE=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Employee';
")

if [ "$TABLE" -eq 1 ]; then
    echo "PASS: Employee table exists."
    MARKS=$((MARKS+2))
else
    echo "FAIL: Employee table was not created."
    exit 1
fi

# ----------------------------------------
# Test Case 2: All required columns exist
# ----------------------------------------

COLUMNS=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Employee'
AND COLUMN_NAME IN ('EmployeeID','EmployeeName','Department','Salary');
")

if [ "$COLUMNS" -eq 4 ]; then
    echo "PASS: All required columns exist."
    MARKS=$((MARKS+1))
else
    echo "FAIL: Required columns are missing."
fi

# ----------------------------------------
# Test Case 3: Five records inserted
# ----------------------------------------

RECORDS=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(*)
FROM Employee;
")

if [ "$RECORDS" -eq 5 ]; then
    echo "PASS: All 5 employee records inserted."
    MARKS=$((MARKS+1))
else
    echo "FAIL: Expected 5 records, found $RECORDS."
fi

# ----------------------------------------
# Test Case 4: COUNT()
# ----------------------------------------

COUNT_RESULT=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(Salary) FROM Employee;
")

if [ "$COUNT_RESULT" -eq 5 ]; then
    echo "PASS: COUNT() result is correct."
    MARKS=$((MARKS+1))
else
    echo "FAIL: COUNT() result is incorrect."
fi

# ----------------------------------------
# Test Case 5: MAX()
# ----------------------------------------

MAX_RESULT=$($MYSQL -N -s CollegeDB -e "
SELECT MAX(Salary) FROM Employee;
")

if [ "$MAX_RESULT" -eq 45000 ]; then
    echo "PASS: MAX() result is correct."
    MARKS=$((MARKS+2))
else
    echo "FAIL: MAX() result is incorrect."
fi

# ----------------------------------------
# Test Case 6: MIN()
# ----------------------------------------

MIN_RESULT=$($MYSQL -N -s CollegeDB -e "
SELECT MIN(Salary) FROM Employee;
")

if [ "$MIN_RESULT" -eq 25000 ]; then
    echo "PASS: MIN() result is correct."
    MARKS=$((MARKS+1))
else
    echo "FAIL: MIN() result is incorrect."
fi

# ----------------------------------------
# Test Case 7: AVG()
# ----------------------------------------

AVG_RESULT=$($MYSQL -N -s CollegeDB -e "
SELECT ROUND(AVG(Salary),2) FROM Employee;
")

if [ "$AVG_RESULT" = "35000.00" ] || [ "$AVG_RESULT" = "35000" ]; then
    echo "PASS: AVG() result is correct."
    MARKS=$((MARKS+2))
else
    echo "FAIL: AVG() result is incorrect."
fi

echo ""
echo "========================================"
echo "Aggregate Function Results"
echo "========================================"

$MYSQL CollegeDB -e "
SELECT
    COUNT(Salary) AS Total_Employees,
    MAX(Salary) AS Maximum_Salary,
    MIN(Salary) AS Minimum_Salary,
    AVG(Salary) AS Average_Salary
FROM Employee;
"

echo ""
echo "========================================"
echo "Total Marks: $MARKS / 10"
echo "========================================"

if [ "$MARKS" -eq 10 ]; then
    echo "SUCCESS: All test cases passed."
    exit 0
else
    echo "Some test cases failed."
    exit 1
fi
