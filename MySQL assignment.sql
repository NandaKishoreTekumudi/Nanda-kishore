create database assignments;
use assignments;
CREATE TABLE salespeople (
snum int,
sname varchar(255),
city varchar(255),
comm float
);
INSERT INTO salespeople values
(1001, "Peel", "London", 0.12),
(1002,"Serres", "San Jose", 0.13),
(1004, "Motika","London",0.11),
(1007,"Rafkin","Barcelona",-.15),
(1003,"Axelrod","New York",0.1);
CREATE TABLE cust (
cnum INT NOT NULL PRIMARY KEY,
cname VARCHAR(255),
city VARCHAR(255),
rating INT,
snum INT,
FOREIGN KEY (snum) REFERENCES salespeople(snum)
);
INSERT INTO cust VALUES
(2001,"Hoffman","London",100,1001),
(2002,"Giovanne","Rome",200,1003),
(2003,"Liu","San Jose",300,1002),
(2004,"Grass","Brelin",100,1002),
(2006,"Clemens","London",300,1007),
( 2007,"Pereira","Rome",100,1004);

CREATE TABLE orders (
onum INT NOT NULL PRIMARY KEY,
amt FLOAT,
odate DATE,
cnum int,
snum int,
FOREIGN KEY (snum) REFERENCES salespeople(snum)
);
INSERT INTO orders VALUES
(3001, 18.69, '1994-10-03', 2008, 1007),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3009, 1713.23, '1994-10-04', 2002, 1003),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2006, 1001),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001);


-- 1.	Display snum,sname,city and comm of all salespeople.
SELECT snum, sname, city, comm FROM salespeople;

-- 2.	Display all snum without duplicates from all orders.
SELECT DISTINCT(snum) FROM orders;

-- 3.	Display names and commissions of all salespeople in london.
SELECT sname, comm FROM salespeople WHERE city = 'london';

-- 4.   All customers with rating of 100.
SELECT cname FROM cust WHERE rating = 100;

-- 5. Produce orderno, amount and date form all rows in the order table.
SELECT onum, amt, odate FROM orders;

-- 6. All customers in San Jose, who have rating more than 200.
SELECT cname FROM cust WHERE city = 'San Jose' AND rating > 200;


-- 7. All customers who were either located in San Jose or had a rating above 200.
SELECT cname FROM cust WHERE city = 'San Jose' OR rating > 200;


-- 8. All orders for more than $1000.
SELECT onum FROM orders WHERE amt > 1000;

-- 9. Names and citires of all salespeople in london with commission above 0.10.
SELECT sname, city FROM salespeople WHERE city = 'London' AND comm > 0.10;


-- 10. All customers excluding those with rating <= 100 unless they are located in Rome.
SELECT cname FROM cust WHERE city = 'Rome' OR rating > 100;


-- 11. All salespeople either in Barcelona or in london.
SELECT * FROM salespeople WHERE city = 'Barcelona' OR city = 'London';


-- 12. All salespeople with commission between 0.10 and 0.12. (Boundary values should be excluded)
SELECT * FROM salespeople 
WHERE comm > 0.10 AND comm < 0.12;

-- 13. All customers with NULL values in city column.
SELECT * FROM cust WHERE city is NULL;

-- 14. All orders taken on Oct 3Rd and Oct 4th 1994.
SELECT * FROM orders WHERE odate = '1994-10-04' OR odate = '1994-10-03';


-- 15. All customers serviced by peel or Motika.
SELECT c.cname FROM cust AS c 
JOIN salespeople AS s ON c.snum = s.snum
WHERE s.sname IN ('Peel', 'Motika');



-- 16. All customers whose names begin with a letter from A to B.
SELECT cname FROM cust 
WHERE cname LIKE 'A%' OR cname LIKE 'B%';



-- 17. All orders except those with 0 or NULL value in amt field.
SELECT * FROM orders WHERE amt != 0 OR amt != NULL;

-- 18. Count the number of salespeople currently listing orders in the order table
SELECT COUNT(DISTINCT(snum)) FROM orders;



-- 19. Largest order taken by each salesperson, datewise.
SELECT snum, odate, MAX(amt) FROM orders 
GROUP BY odate, snum;


-- 20. Largest order taken by each salesperson with order value more than $3000.
SELECT snum, odate, MAX(amt) FROM orders 
WHERE amt > 3000
GROUP BY odate, snum;


-- 21. Which day had the hightest total amount ordered.
SELECT odate FROM orders 
WHERE amt = (SELECT MAX(amt) FROM orders);

-- 22. Count all orders for Oct 3rd.
SELECT COUNT(onum) FROM orders WHERE odate = '1994-10-03';


-- 23. Count the number of different non NULL city values in customers table.
SELECT COUNT(DISTINCT(city)) FROM cust 
WHERE city IS NOT NULL;


-- 24. Select each customer’s smallest order.
SELECT cnum, MIN(amt) FROM orders 
GROUP BY cnum;


-- 25. First customer in alphabetical order whose name begins with G.
SELECT cname FROM cust
WHERE cname LIKE 'G%'
ORDER BY cname;


-- 26. Get the output like “ For dd/mm/yy there are ___ orders.
SELECT 
CONCAT("For ", DATE_FORMAT(odate,'%d/%m/%y')," there are ", COUNT(*)," orders") FROM orders
GROUP BY odate;


-- 27. Assume that each salesperson has a 12% commission. Produce order no., salesperson no., and amount of salesperson’s commission for that order.
SELECT onum, snum, (amt/ 100 * 12) AS commission FROM orders;

-- 28. Find highest rating in each city. Put the output in this form. For the city (city), the highest rating is : (rating).
SELECT CONCAT('For the city (', city, ') the highest rating is: ', MAX(rating)) 
FROM cust
GROUP BY city;

-- 29. Display the totals of orders for each day and place the results in descending order.
SELECT odate, COUNT(onum) FROM orders
GROUP BY odate
ORDER BY COUNT(onum) DESC;


-- 30. All combinations of salespeople and customers who shared a city. (ie same city).
SELECT s.sname, c.cname FROM salespeople AS s
JOIN cust AS c ON s.snum = c.snum
WHERE c.city = s.city;

-- 31. Name of all customers matched with the salespeople serving them.
SELECT s.sname, c.cname FROM salespeople AS s
JOIN cust AS c ON s.snum = c.snum
WHERE c.snum = s.snum;

-- 32. List each order number followed by the name of the customer who made the order.
SELECT o.onum, c.cname FROM orders AS o
JOIN cust AS c ON o.cnum = c.cnum;


-- 33. Names of salesperson and customer for each order after the order number.
SELECT onum, s.sname, c.cname FROM orders AS o
JOIN cust AS c ON o.cnum = c.cnum
JOIN salespeople AS s ON c.snum = s.snum;


-- 34. Produce all customer serviced by salespeople with a commission above 12%.
SELECT c.cname FROM cust AS c
JOIN salespeople AS s ON c.snum = s.snum
WHERE comm > 0.12;

-- 35. Calculate the amount of the salesperson’s commission on each order with a rating above 100.
SELECT onum, comm FROM salespeople AS s
JOIN orders AS o ON s.snum = o.snum
JOIN cust AS c ON c.cnum = o.cnum
WHERE c.rating > 100;


-- 36. Find all pairs of customers having the same rating.
SELECT c1.cnum AS customer1, c2.cnum AS customer2, c1.rating
FROM cust AS c1
JOIN cust AS c2 ON c1.rating = c2.rating AND c1.cnum < c2.cnum
ORDER BY c1.rating;

-- 37. Find all pairs of customers having the same rating, each pair coming once only.
SELECT c1.cnum AS customer1, c2.cnum AS customer2, c1.rating
FROM cust AS c1
JOIN cust AS c2 ON c1.rating = c2.rating AND c1.cnum < c2.cnum
ORDER BY c1.rating;


-- 38. Policy is to assign three salesperson to each customers. Display all such combinations
WITH RankedSales AS (
    SELECT c.cnum, s.snum, 
           ROW_NUMBER() OVER (PARTITION BY c.cnum ORDER BY s.snum) AS rn
    FROM cust c
    CROSS JOIN salespeople s
)
SELECT cnum, snum
FROM RankedSales
WHERE rn <= 3
ORDER BY cnum, snum;


-- 39. Display all customers located in cities where salesman serres has customer.
SELECT cname FROM cust
WHERE city =  (SELECT city FROM salespeople
WHERE sname = 'Serres');


-- 40. Find all pairs of customers served by single salesperson.
SELECT cname FROM cust
WHERE snum IN (SELECT snum FROM cust GROUP BY snum having COUNT(snum) > 1);


-- 41. Produce all pairs of salespeople which are living in the same city. Exclude combinations of salespeople with themselves as well as duplicates with the order reversed.
SELECT s1.sname , s2.sname FROM salespeople AS s1
JOIN salespeople AS s2 ON s1.city = s2.city AND s1.snum < s2.snum;

-- 42. Produce all pairs of orders by given customer, names that customers and eliminates duplicates.alter
SELECT o1.onum, o2.onum, o1.cnum FROM orders AS o1
JOIN orders AS o2 ON o1.cnum = o2.cnum AND o1.onum < o2.onum;

-- 43. Produce names and cities of all customers with the same rating as Hoffman.
SELECT cname, city FROM cust
WHERE rating = (SELECT rating FROM cust WHERE cname = 'Hoffman') AND cname != 'Hoffman';


-- 44. Extract all the orders of Motika.
SELECT onum FROM orders
WHERE snum = (SELECT snum FROM salespeople WHERE sname = 'Motika');


-- 45. All orders credited to the same salesperson who services Hoffman
SELECT onum FROM orders
WHERE snum = (SELECT snum FROM cust WHERE cname = 'Hoffman');

-- 46. All orders that are greater than the average for Oct 4
SELECT onum FROM orders
WHERE amt > (SELECT AVG(amt) FROM orders WHERE odate = '1994-10-04');


-- 47. Find average commission of salespeople in london.
SELECT avg(comm) FROM salespeople
WHERE city = 'London';

-- 48. Find all orders attributed to salespeople servicing customers in london.
SELECT * FROM orders
WHERE cnum IN (SELECT cnum FROM cust WHERE city = 'London');

-- 49. Extract commissions of all salespeople servicing customers in London.
SELECT comm FROM salespeople
WHERE snum IN (SELECT snum FROM cust WHERE city = 'London');


-- 50. Find all customers whose cnum is 1000 above the snum of serres
SELECT cname FROM cust
WHERE cnum > 
(SELECT snum + 1000 FROM salespeople 
WHERE sname = 'Serres');

-- 51. Count the customers with rating above San Jose’s average.

SELECT COUNT(cnum) FROM cust
WHERE rating > (SELECT AVG(rating) FROM cust WHERE city = 'San Jose');


-- 52. Obtain all orders for the customer named Cisnerous. (Assume you don’t know his customer no. (cnum)).
SELECT onum FROM orders
WHERE cnum = (SELECT cnum FROM cust WHERE cname = 'Cisnerous');


-- 53. Produce the names and rating of all customers who have above average orders
SELECT cname, rating FROM cust
WHERE cnum IN
(SELECT cnum FROM orders
WHERE onum > (SELECT AVG(onum) FROM orders));

-- 54. Find total amount in orders for each salesperson for whom this total is greater than the amount of the largest order in the table.
SELECT snum, SUM(amt) FROM orders
GROUP BY snum
HAVING SUM(amt) > (SELECT MAX(amt) FROM orders);

-- 55. Find all customers with order on 3rd Oct.
SELECT cname FROM cust
WHERE cnum IN (SELECT cnum FROM orders 
WHERE odate = '1994-10-03');

-- 56. Find names and numbers of all salesperson who have more than one customer.
SELECT sname, snum FROM salespeople
WHERE snum IN (SELECT snum FROM cust
GROUP BY snum
HAVING COUNT(snum) > 1);

-- 57. Check if the correct salesperson was credited with each sale.
SELECT o.onum, o.snum, c.snum, 
CASE WHEN o.snum = c.snum THEN 'Correct'
ELSE 'Incorrect'
END AS verification_status
FROM orders o
JOIN cust AS c ON o.cnum = c.cnum;

-- 58. Find all orders with above average amounts for their customers
SELECT o1.onum, o1.amt FROM orders AS o1
JOIN (
SELECT cnum, AVG(amt) AS avg_amt FROM orders
GROUP BY cnum) AS aa
ON o1.cnum = aa.cnum
WHERE o1.amt > aa.avg_amt;

-- 59. Find the sums of the amounts from order table grouped by date, eliminating all those dates where the sum was not at least 2000 above the maximum amount.
SELECT odate, SUM(amt) FROM orders
GROUP BY odate
HAVING SUM(amt) > (SELECT MAX(amt) + 2000 FROM orders);

-- 60. Find names and numbers of all customers with ratings equal to the maximum for their city.
SELECT cname, cnum FROM cust AS c
JOIN ( SELECT city, MAX(rating) AS max_rat FROM cust AS c1
GROUP BY city) AS mcr
ON c.city = mcr.city
WHERE c.rating = mcr.max_rat;

-- 61. Find all salespeople who have customers in their cities who they don’t service. ( Both way using Join and Correlated subquery.)
-- using Join
SELECT s.sname FROM salespeople AS s
JOIN cust AS c ON s.city = c.city
WHERE s.city = c.city AND s.snum != c.snum;
-- Correlated subquery.
SELECT sname FROM salespeople
WHERE city IN (SELECT city FROM cust
WHERE snum != salespeople.snum);


-- 62. Extract cnum,cname and city from customer table if and only if one or more of the customers in the table are located in San Jose.
SELECT cnum, cname, city
FROM cust
WHERE (SELECT COUNT(cnum) FROM cust WHERE city = 'San Jose')>0;


-- 63. Find salespeople no. who have multiple customers.
SELECT snum, COUNT(cnum) FROM cust
GROUP BY snum
HAVING COUNT(cnum) > 1; 


-- 64. Find salespeople number, name and city who have multiple customers.
SELECT snum, sname, city FROM salespeople
WHERE snum IN (SELECT snum FROM cust
GROUP BY snum
HAVING COUNT(cnum) > 1); 

-- 65. Find salespeople who serve only one customer.
SELECT snum FROM cust
GROUP BY snum
HAVING COUNT(cnum) = 1; 

-- 66. Extract rows of all salespeople with more than one current order.
SELECT snum, sname FROM salespeople
WHERE snum IN (SELECT snum FROM orders
GROUP BY snum HAVING COUNT(onum) > 1);


-- 67. Find all salespeople who have customers with a rating of 300. (use EXISTS)
SELECT snum FROM salespeople AS s
WHERE EXISTS (SELECT snum FROM cust AS c
WHERE c.snum = s.snum AND c.rating = 300);


-- 68. Find all salespeople who have customers with a rating of 300. (use Join).
SELECT s.snum FROM salespeople AS s
JOIN cust AS c ON s.snum = c.snum
WHERE c.rating = 300;

-- 69. Select all salespeople with customers located in their cities who are not assigned to them. (use EXISTS).
SELECT * FROM salespeople AS s
WHERE EXISTS (SELECT 1 FROM cust AS c
WHERE s.city = c.city AND s.snum != c.snum);

-- 70. Extract from customers table every customer assigned the a salesperson who currently has at least one other customer ( besides the customer being selected) with orders in order table.
SELECT * 
FROM cust  AS c1
WHERE EXISTS (
    SELECT 1 
    FROM cust  AS c2
    JOIN orders o ON c2.cnum = o.cnum
    WHERE c2.snum = c1.snum  
    AND c2.cnum != c1.cnum
);


-- 71. Find salespeople with customers located in their cities ( using both ANY and IN)
-- using IN
SELECT s.snum, s.sname FROM salespeople AS s
WHERE s.snum IN (SELECT c.snum FROM cust AS c
WHERE c.city = s.city);
-- using any
SELECT s.snum, s.sname FROM salespeople AS s
WHERE s.snum = ANY (SELECT c.snum FROM cust AS c
WHERE c.city = s.city);


-- 72. Find all salespeople for whom there are customers that follow them in alphabetical order. (Using ANY and EXISTS)
SELECT s.snum, s.sname FROM salespeople AS s
WHERE s.snum = ANY (SELECT c.snum FROM cust AS c);


-- 73. Select customers who have a greater rating than any customer in rome.
SELECT cnum, cname FROM cust
WHERE rating > (SELECT MAX(rating) FROM cust WHERE city = 'Rome');

-- 74. Select all orders that had amounts that were greater that atleast one of the orders from Oct 6th.
SELECT onum FROM orders
WHERE amt > (SELECT MIN(amt) FROM orders
WHERE odate = '1994-10-06');

-- 75. Find all orders with amounts smaller than any amount for a customer in San Jose. (Both using ANY and without ANY)
-- Using ANY
SELECT onum FROM orders
WHERE amt < (SELECT o.amt FROM orders AS o
WHERE o.cnum = ANY (SELECT cnum FROM cust
WHERE city = 'San Jose'));
-- Without using any
SELECT onum FROM orders
WHERE amt < (SELECT o.amt FROM orders AS o
WHERE o.cnum = (SELECT cnum FROM cust
WHERE city = 'San Jose'));


-- 76. Select those customers whose ratings are higher than every customer in Paris. ( Using both ALL and NOT EXISTS).
-- Using ALL
SELECT cnum, cname FROM cust
WHERE rating > ALL (SELECT rating FROM cust
WHERE city = 'Paris');
-- Using NOT EXISTS
SELECT c1.cnum, c1.cname FROM cust AS c1
WHERE NOT EXISTS (SELECT rating FROM cust AS c2
WHERE c2.city = 'Paris' AND c1.rating >c2.rating );


-- 77. Select all customers whose ratings are equal to or greater than ANY of the Seeres.
SELECT cnum, cname FROM cust
WHERE rating >= ANY (SELECT rating FROM cust
WHERE snum = (SELECT snum FROM salespeople
WHERE sname = 'Serres'));


-- 78. Find all salespeople who have no customers located in their city. ( Both using ANY and ALL)
SELECT s.snum, s.sname, city FROM salespeople AS s
WHERE s.city != ALL (SELECT c.city FROM cust AS c
WHERE c.snum = s.snum);
-- Using ANY
SELECT s.snum, s.sname, city FROM salespeople AS s
WHERE s.city != ANY (SELECT c.city FROM cust AS c
WHERE s.snum = c.snum);


-- 79. Find all orders for amounts greater than any for the customers in London.
SELECT onum FROM orders
WHERE amt > ANY  (SELECT amt FROM orders
WHERE cnum IN (SELECT cnum FROM cust
WHERE city = 'London'));


-- 80. Find all salespeople and customers located in london.
SELECT sname FROM salespeople WHERE city = 'London'
UNION ALL
SELECT cname FROM cust WHERE city = 'London';

-- 81. For every salesperson, dates on which highest and lowest orders were brought
SELECT o.snum , 
CASE
WHEN o.amt = m.mia THEN odate END AS min_order,
CASE
WHEN o.amt = m.maa THEN odate END AS max_order
FROM orders AS o
JOIN (SELECT snum, MIN(amt) AS mia, MAX(amt) AS maa FROM orders
GROUP BY snum) AS m ON o.snum = m.snum
ORDER BY snum;


-- 82. List all of the salespeople and indicate those who don’t have customers in their cities as well as those who do have.
SELECT s.snum, s.sname, s.city, 
CASE 
WHEN EXISTS (SELECT 1 FROM cust c WHERE c.city = s.city AND c.snum = s.snum) 
THEN 'Has Customers in City' 
ELSE 'No Customers in City' 
END AS customer_status
FROM salespeople s;

-- 83. Append strings to the selected fields, indicating weather or not a given salesperson was matched to a customer in his city.
SELECT s.snum, s.sname, s.city,
CONCAT(s.sname,' ',
CASE 
WHEN EXISTS (SELECT 1 FROM cust c WHERE c.city = s.city AND c.snum = s.snum) 
THEN 'Has Customers in City' 
ELSE 'No Customers in City' 
END) AS sales_status
FROM salespeople s;


-- 4. Create a union of two queries that shows the names, cities and ratings of all customers.
-- Those with a rating of 200 or greater will also have the words ‘High Rating’, while the
-- others will have the words ‘Low Rating’.
SELECT cname, city, rating, 'High Rating' AS rating_status
FROM cust
WHERE rating >= 200
UNION
SELECT cname, city, rating, 'Low Rating' AS rating_status
FROM cust
WHERE rating < 200;


-- 85. Write command that produces the name and number of each salesperson and each
-- customer with more than one current order. Put the result in alphabetical order.
SELECT s.snum AS ID, s.sname AS Name, 'Salesperson' AS Type
FROM salespeople s
UNION
SELECT c.cnum AS ID, c.cname AS Name, 'Customer' AS Type
FROM cust c
WHERE c.cnum IN (SELECT cnum FROM orders GROUP BY cnum HAVING COUNT(*) > 1)
ORDER BY Name;

-- . Form a union of three queries. Have the first select the snums of all salespeople in San
-- Jose, then second the cnums of all customers in San Jose and the third the onums of all
-- orders on Oct. 3. Retain duplicates between the last two queries, but eliminates and
-- redundancies between either of them and the first.
SELECT snum AS ID, 'Salesperson' AS Type
FROM salespeople
WHERE city = 'San Jose'
UNION
SELECT cnum AS ID, 'Customer' AS Type
FROM cust
WHERE city = 'San Jose'
UNION ALL
SELECT onum AS ID, 'Order' AS Type
FROM orders
WHERE odate = '1994-10-03';


-- 87. Produce all the salesperson in London who had at least one customer there.
SELECT DISTINCT s.snum, s.sname
FROM salespeople AS s
JOIN cust AS c ON s.snum = c.snum
WHERE s.city = 'London' AND c.city = 'London';

-- 88. Produce all the salesperson in London who did not have customers there.
SELECT DISTINCT s.snum, s.sname
FROM salespeople AS s
JOIN cust AS  c ON s.snum = c.snum
WHERE s.city = 'London' AND c.city != 'London';

-- 89. We want to see salespeople matched to their customers without excluding those
-- salesperson who were not currently assigned to any customers. (User OUTER join and
-- UNION)
SELECT s.snum, s.sname, c.cnum, c.cname
FROM salespeople AS s
LEFT JOIN cust AS c ON s.snum = c.snum
UNION
SELECT s.snum, s.sname, c.cnum, c.cname
FROM salespeople AS s
RIGHT JOIN cust AS c ON s.snum = c.snum;
