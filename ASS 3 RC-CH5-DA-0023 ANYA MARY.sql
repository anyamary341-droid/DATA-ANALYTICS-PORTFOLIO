--==================================== 3A=============================================
USE EnterpriseFlow

/*QUESTION 1.Order Frequency: "How many orders has each customer placed? Group by the Customer
ID to see who our frequent buyers are."*\

SELECT CustomerID, COUNT(OrderID) AS TOTAL_ORDER
FROM [CustomerTab].[orders]
GROUP BY CustomerID
ORDER BY TOTAL_ORDER DESC;

/*QUETION 2.Newest Hire: "Who was the very last person we hired? Show the TOP 1 employee based on
hire date."*\

SELECT TOP 1 *
FROM[Employee].[payrolls]
ORDER BY HIREDATE DESC;

/*QUESTION 3.Recent Sales: "Show the most recent 50 orders placed, starting with the very latest date
first."*\

SELECT TOP 50 *
FROM [CustomerTab].[orders]
ORDER BY ORDERDATE DESC;

/*QUESTION 4.Major Markets: "Show me only the cities that have more than 10 customers living in
them."*\

SELECT City, COUNT(CustomerID) AS TotalCustomers
FROM [CustomerTab].[Customers]
GROUP BY City
HAVING COUNT(CustomerID) > 10;

/*QUESTION 5.High-Cost Roles: "Which job titles are costing the company more than $10,000 in total
monthly salary?"*\

SELECT JobTitle, SUM(SALARY) AS TotalMonthlyCost
FROM [Employee].[payrolls]
GROUP BY JobTitle
HAVING SUM(SALARY) > 10000;

/*QUESTION 6.Payroll Ranking: "Show all employees and their salaries, ordered from the lowest paid to
the highest paid."*\

SELECT EMP.FirstName, EMP.LastName, EPAY.Salary
FROM [Employee].[employee_details] AS EMP
LEFT JOIN[Employee].[payrolls]  AS EPAY ON EMP.EmployeeID = EPAY.EmployeeID
ORDER BY EPAY.Salary ASC;

/*QUESTION 7.Budget Leaders: "Which 3 job titles have the highest individual monthly salaries?*\

SELECT TOP 3 JOBTITLE,SALARY
FROM[Employee].[payrolls]
ORDER BY SALARY DESC;

/*QUESTION 8.Quick Sample: "The auditor wants a random sample of the first 10 rows from the
EmployeeDetails table."*\

SELECT TOP 10 *
FROM[Employee].[employee_details]

/*QUESTION 9.Staff Distribution: "In which cities are our employees primarily based? Give us a count of
employees per city."*\

SELECT CITY, COUNT(EMPLOYEEID) AS EMPLOYEE_COUNT
FROM[Employee].[employee_details]
GROUP BY CITY
ORDER BY EMPLOYEE_COUNT DESC;

/*QUESTION 10. Top Spenders: "Identify the TOP 5 customers who have the highest total quantity of items
ordered across all their transactions."*\

SELECT TOP 5 CUSTOMERID,SUM(ORDERQUANTITY) AS TOTAL_QUANTITY
FROM[CustomerTab].[orders]
GROUP BY CUSTOMERID
ORDER BY TOTAL_QUANTITY DESC;