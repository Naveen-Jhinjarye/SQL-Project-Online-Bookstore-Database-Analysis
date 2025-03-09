CREATE DATABASE OBS ;

USE obs;

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

 /* 1) Retrieve all books in the "Fiction" genre */
SELECT *FROM books
WHERE Genre = 'Fiction';

/*2) Find books published after the year 1950 */

SELECT * FROM books
WHERE published_year > 1950 
ORDER BY published_year ASC ;

/* 3) List all customers from the Canada*/

SELECT * FROM customers 
WHERE Country = 'Canada';

/* 4) Show orders placed in November 2023*/
SELECT * FROM orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30'
ORDER BY Order_Date ASC;
/*5) Retrieve the total stock of books available*/

SELECT SUM(Stock) AS total_stock FROM books;

/*6) Find the details of the most expensive book*/

SELECT *  FROM books
WHERE Price = (SELECT MAX(Price)  FROM books);
/*7) Show all customers who ordered more than 1 quantity of a book*/

SELECT * FROM orders
WHERE Quantity > 1
ORDER BY Quantity ASC;

/*8) Retrieve all orders where the total amount exceeds $20*/ 

SELECT * FROM orders
WHERE Total_Amount > 20
ORDER BY Total_Amount ASC;

/*9) List all genres available in the Books table*/

SELECT DISTINCT Genre AS List FROM books
ORDER BY Genre ASC; 

/*10) Find the book with the lowest stock*/
SELECT * FROM books
WHERE Stock = (SELECT MIN(Stock) FROM books);

/*11) Calculate the total revenue generated from all orders*/

SELECT ROUND(SUM(Total_Amount), 2) AS Total_Revenue FROM orders;

-- ADVANCE QUERIES
/*1) Retrieve the total number of books sold for each genre*/

SELECT SUM(Quantity) AS NB, Genre
FROM books
JOIN orders ON books.Book_ID = orders.Book_ID
GROUP BY Genre;

/*2) Find the average price of books in the "Fantasy" genre*/

SELECT AVG(Price) AS Average_Price, Genre
FROM books
WHERE Genre = 'Fantasy';

/*3) List customers who have placed at least 2 orders*/

SELECT  customers.Name, customers.Customer_ID, COUNT(orders.Order_ID) AS order_c
FROM customers
JOIN orders ON customers.Customer_ID = orders.Customer_ID
GROUP BY  customers.Name, customers.Customer_ID
HAVING COUNT(orders.Order_ID) >= 2;

/*4) Find the most frequently ordered book*/

SELECT books.Title,orders.Book_ID, COUNT(orders.Order_ID) AS Order_Count
FROM orders
JOIN books ON orders.Book_ID = books.Book_ID
GROUP BY  books.Title,orders.Book_ID
ORDER BY  Order_Count DESC;

/*5) Show the top 3 most expensive books of 'Fantasy' Genre*/
SELECT Title, Genre, MAX(Price) AS Expensive_Book
FROM books
GROUP BY Genre, Title
HAVING Genre = 'Fantasy'
ORDER BY Expensive_Book DESC
LIMIT 3 ;

/*6) Retrieve the total quantity of books sold by each author*/

SELECT books.Author, SUM(Quantity) AS QB
FROM books
JOIN orders ON books.Book_ID = orders.Book_ID
GROUP BY books.Author
ORDER BY QB DESC;

/*7) List the cities where customers who spent over $30 are located*/

SELECT DISTINCT customers.City, orders.Total_Amount
FROM customers
JOIN orders ON customers.Customer_ID = orders.Customer_ID
WHERE  orders.Total_Amount > 30;

/*8) Find the customer who spent the most on orders*/

SELECT customers.Name, customers.Customer_ID, ROUND(SUM(orders.Total_Amount),1) AS TS
FROM orders
JOIN customers ON customers.Customer_ID = orders.Customer_ID
GROUP BY customers.Name, customers.Customer_ID
ORDER BY TS DESC;

/*9) Calculate the stock remaining after fulfilling all orders*/

SELECT books.Book_ID, books.Title, books.Stock,COALESCE(SUM(orders.Quantity),0) AS Order_Quantity,
books.stock - COALESCE(SUM(orders.Quantity),0) AS Remaining_Quantity
FROM books
LEFT JOIN orders ON books.Book_ID = orders.Book_ID
GROUP BY books.Book_ID, books.Title, books.Stock
ORDER BY books.Book_ID ASC;


