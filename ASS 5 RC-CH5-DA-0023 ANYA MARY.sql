USE PARCH AND POSEY

/*1. The Regional Performance Report (JOINS & Grouping)*/
/*Scenario: The VP of Sales wants to know which geographical areas are bringing in
the most money.*/
/*The Task: Write a query that shows the total sales revenue (total_amt_usd) for each
Region. Your results should show the region name and the total revenue, sorted from
highest to lowest.*/

SELECT R.name,SUM(TOTAL_AMT_USD)AS TOTAL_SALES
FROM[dbo].[orders]AS O
LEFT JOIN accounts AS A
ON O.account_id=A.ID
LEFT JOIN sales_reps AS SR
ON SR.ID =A.sales_rep_id
LEFT JOIN region AS R
ON R.ID=SR.region_id
GROUP BY R.name
ORDER BY TOTAL_SALES DESC;

/*2. Categorizing Order Sizes (CASE Statement)
Scenario: The Warehouse Manager wants to label orders so they know which ones
need special handling.
The Task: Create a report that shows the account_id, the total quantity of paper, and
a new column called shipping_category.
• If total is over 500, label it 'Large'.
• If total is between 101 and 500, label it 'Medium'.
• If it is 100 or less, label it 'Small'.*/

SELECT O.ACCOUNT_ID,O.TOTAL AS TOTAL_PAPER,
CASE
WHEN TOTAL<100 THEN 'SMALL'
WHEN TOTAL BETWEEN 101 AND 500 THEN 'MEDIUM'
WHEN TOTAL > 500 THEN 'LARGE'
END AS SHIPPING_CATEGORY
FROM[dbo].[orders] AS O

/*3. Finding "Superstar" Sales Reps (CTE)
Scenario: The HR department is looking for sales representatives who have
generated more than $200,000 in total sales to give them a bonus.
The Task: Use a CTE to first calculate the total sales (total_amt_usd) for every Sales
Representative. Then, in your main query, select the names of the reps who crossed
the $200,000 threshold.*/


;WITH SUPERSTAR_SALES AS (
    SELECT 
        SR.NAME AS REP_NAME, 
        SUM(O.Total_amt_usd) AS Total_Sales
    FROM sales_reps SR
 LEFT JOIN accounts a ON sr.id = a.sales_rep_id
   LEFT JOIN orders o ON a.id = o.account_id
    GROUP BY sr.name)

SELECT * FROM Superstar_Sales
WHERE Total_Sales > 200000;

/*4. Direct Marketing Contact List (JOINS)
Scenario: The Marketing team wants to send a thank-you gift to the primary contact
person (primary_poc) of every account managed by the 'Northeast' region.
The Task: Provide a list of the Account Name, the Primary POC, and the Region Name.
Filter the list to only show the 'Northeast' region.*/

SELECT 
    a.name AS account_name, 
    a.primary_poc, 
    r.name AS region_name
FROM accounts AS a
LEFT JOIN sales_reps AS SR ON a.sales_rep_id = SR.id
LEFT JOIN region AS r ON SR.region_id = r.id
WHERE r.name = 'Northeast';

/*5. High-Value Account Behavior (Subquery in WHERE)
Scenario: We want to see which web channels (like Facebook or Google) are used by
our biggest spenders.
The Task: Count the number of web events for each channel, but only for accounts
that have placed at least one order greater than $10,000. Use a Subquery in your
WHERE clause to identify those specific account IDs.*/

SELECT 
    channel, 
    COUNT(*) AS event_count
FROM web_events
WHERE account_id IN (
    SELECT DISTINCT account_id
    FROM orders
    WHERE total_amt_usd > 10000)
GROUP BY channel
ORDER BY event_count DESC;

/*6. Comparing Account Averages (Subquery in FROM)
Scenario: Management wants to know the "average of the totals." They want to see
the average amount spent by all accounts.
The Task: First, write a Subquery in the FROM clause that finds the total amount
spent (total_amt_usd) for each individual account. Then, in your main query, find the
average of those totals.*/

SELECT 
    AVG(total_spent_per_account) AS overall_average_spent
FROM (
    SELECT 
        account_id, 
        SUM(total_amt_usd) AS total_spent_per_account
    FROM orders
    GROUP BY account_id)
 AS account_totals; 

 /*7. Identifying Paper Preferences (HAVING)
Scenario: The product team noticed some clients prefer "Gloss" paper over
"Standard" paper.
The Task: Write a query to find accounts that have ordered a total of more than
4,000 sheets of Gloss paper in their lifetime. Show the account name and the total
gloss quantity.*/

SELECT 
    A.name AS account_name, 
    SUM(O.gloss_qty) AS total_gloss_qty
FROM accounts AS a
JOIN orders AS O 
ON A.id = o.account_id
GROUP BY A.name
HAVING SUM(O.gloss_qty) > 4000;

/*8. The Top 5 Most Active Clients (TOP)
Scenario: The CEO wants to personally call our 5 most frequent customers to thank
them.
The Task: Use the TOP clause to find the 5 accounts that have placed the highest
number of individual orders. Show the Account Name and the count of their orders.*/

SELECT TOP 5
    A.name AS account_name, 
    COUNT(O.id) AS order_count
FROM accounts AS A
JOIN orders AS O
ON A.id = O.account_id
GROUP BY A.name
ORDER BY order_count DESC;

/*9. Checking for "Quiet" High-Value Accounts (Subquery in WHERE)
Scenario: The Customer Success team is worried. They want to find accounts that
have spent a lot of money in total but haven't had any "web events" (website visits)
recently.
The Task: Write a query to find the names of accounts that have a total lifetime
spend (total_amt_usd) of more than $50,000, but have zero web events recorded in
the web_events table.*/

SELECT 
    A.name AS account_name
FROM accounts AS A
JOIN orders AS O ON A.id = O.account_id
GROUP BY A.name, A.id  -- Add A.id here
HAVING SUM(O.total_amt_usd) > 50000
AND A.id NOT IN (
    SELECT DISTINCT account_id 
    FROM web_events);

    /*10. Seasonal Sales Performance (CASE & Grouping)
Scenario: The inventory team wants to know if our sales are "seasonal." They want to
see if we sell more in the first half of the year or the second half. The Task: Using the
orders table, create a report with two columns.
1. Use a CASE Statement on the occurred_at column:
o If the month is between 1 and 6, call it 'H1' (First Half).
o If the month is between 7 and 12, call it 'H2' (Second Half).
2. The second column should be the SUM of the total_amt_usd. Note: You will
need to use the MONTH() function in SQL Server to extract the month from the
date.*/



    SELECT SUM(total_amt_usd) AS TOTAL_SALES,
          CASE 
          WHEN  MONTH(occurred_at) BETWEEN 1 AND 6 THEN 'H1'
          ELSE 'H2'
          END AS SEASON
          FROM orders
          GROUP BY MONTH(occurred_at)
          

          
    
    