-- JOINS'
-- SYNTAX
SELECT [Column names] 
FROM [table] [abbv]
JOIN [table2] [abbv2] ON abbv.prop = abbv2.prop WHERE [Conditions];

SELECT a.name, b.name FROM some_table a JOIN another_table b ON a.some_id = b.some_id;
SELECT a.name, b.name FROM some_table a JOIN another_table b ON a.some_id = b.some_id WHERE b.email = 'e@mail.com';
-- Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT *
FROM invoice AS i
JOIN invoice_line as il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > 0.99;
-- Get the invoice_date, customer first_name and last_name, and total from all invoices.
SELECT i.invoice_date, i.total, c.first_name, c.last_name
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;
-- Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;]
-- Get the album title and the artist name from all albums.
SELECT al.title, ar.name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id;
-- Get all playlist_track track_ids where the playlist name is Music.
SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p ON pt.playlist_id = p.playlist_id
WHERE p.name = 'Music';
-- Get all track names for playlist_id 5.
SELECT t.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
WHERE pt.playlist_id = 5;
-- Get all track names and the playlist name that they're on ( 2 joins ).
SELECT t.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;
-- Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
SELECT t.name, al.title
FROM track t
JOIN album al ON t.album_id = al.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';

-- NESTED QUERIES
-- SYNTAX
SELECT [column names] 
FROM [table] 
WHERE column_id IN ( SELECT column_id FROM [table2] WHERE [Condition] );
-- Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT * 
FROM invoice
WHERE invoice_id IN 
(SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99);
-- Get all playlist tracks where the playlist name is Music.
SELECT * FROM playlist_track
WHERE playlist_id IN 
(SELECT playlist_id FROM playlist WHERE name = 'Music');
-- Get all track names for playlist_id 5.
SELECT name FROM track
WHERE track_id IN 
(SELECT track_id FROM playlist_track WHERE playlist_id = 5);
-- Get all tracks where the genre is Comedy.
SELECT * FROM track
WHERE genre_id IN 
(SELECT genre_id FROM genre WHERE name = 'Comedy');
-- Get all tracks where the album is Fireball.
SELECT * FROM track
WHERE album_id IN 
(SELECT album_id FROM album WHERE name = 'Fireball');
-- Get all tracks for the artist Queen ( 2 nested subqueries ).
SELECT * FROM track
WHERE album_id 
IN 
	(SELECT album_id FROM album WHERE artist_id 
   IN 
 		(SELECT artist_id FROM artist WHERE name = 'Queen')
);

-- UPDATING ROWS
-- SYNTAX
UPDATE [table] 
SET [column1] = [value1], [column2] = [value2] 
WHERE [Condition];

UPDATE athletes SET sport = 'Picklball' WHERE sport = 'pockleball';
-- Find all customers with fax numbers and set those numbers to null.
UPDATE customer
SET fax = NULL
WHERE fax IS NOT NULL;
-- Find all customers with no company (null) and set their company to "Self".
UPDATE customer
SET company = 'Self'
WHERE company IS NULL;
-- Find the customer Julia Barnett and change her last name to Thompson.
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';
-- Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';
-- Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = (SELECT genre_id FROM genre WHERE name = 'Metal')
AND composer IS NULL;
-- Refresh your page to remove all database changes.


-- GROUP BY
-- Find a count of how many tracks there are per genre. Display the genre name with the count.
SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name;
-- Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;
-- Find a list of all artists and how many albums they have.
SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

-- DISTINCT
-- From the track table find a unique list of all composers.
SELECT DISTINCT composer
FROM track;
-- From the invoice table find a unique list of all billing_postal_codes.
SELECT DISTINCT billing_postal_code
FROM invoice;
-- From the customer table find a unique list of all companys.
SELECT DISTINCT company
FROM customer;

-- DELETE ROWS
-- Delete all 'bronze' entries from the table.
DELETE 
FROM practice_delete WHERE type = 'Bronze';
-- Delete all 'silver' entries from the table.
DELETE 
FROM practice_delete WHERE type = 'Silver';
-- Delete all entries whose value is equal to 150.
DELETE 
FROM practice_delete WHERE value = 150;

-- ECOMMERCE SIMULATION
-- Create 3 tables following the criteria in the summary.
  -- users need a name and an email.
  CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL
 );
  -- products need a name and a price
  CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price NUMERIC NOT NULL
 );
  -- orders need a ref to product.
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  product_id INTEGER,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
 );
  -- All 3 need primary keys.

-- Add some data to fill up each table.
  -- At least 3 users
  INSERT INTO users (name, email)
  VALUES 
    ('TramyNguyen', 'tn@gmail.com'),
    ('BobaGirl', 'bobagirl@gmail.com'),
    ('TeaLover', 'tealover@gmail.com');
  -- 3 products
  INSERT INTO products (name, price)
  VALUES 
    ('TramyNguyen', 10),
    ('BobaGirl', 20),
    ('TeaLover', 30);
  -- 3 orders.
  INSERT INTO orders (product_id)
  VALUES 
    (1),
    (2),
    (3);
    
-- Run queries against your data.
  -- Get all products for the first order.
  SELECT * FROM products p
  INNER JOIN orders o ON p.product_id = o.product_id
  WHERE o.order_id = 1;
  -- Get all orders.
  SELECT * FROM orders;
  -- Get the total cost of an order ( sum the price of all products on an order ).
  SELECT SUM(o.order_id)
  FROM products p
  INNER JOIN orders o ON p.product_id = o.product_id
  WHERE o.order_id = 1;
-- Add a foreign key reference from orders to users.
ALTER TABLE orders
ADD COLUMN user_id INT REFERENCES users(user_id);
-- Update the orders table to link a user to each order.
ALTER TABLE users
ADD COLUMN order_id INT
REFERENCES orders(order_id);

UPDATE users 
SET order_id = 1
WHERE user_id = 1;

UPDATE users 
SET order_id = 2
WHERE user_id = 2;

UPDATE users 
SET order_id = 3
WHERE user_id = 3;
-- Run queries against your data.
  -- Get all orders for a user.
  SELECT *
  FROM users u
  INNER JOIN orders o
  ON o.order_id = u.order_id
  WHERE u.user_id = 1;
  -- Get how many orders each user has.
  SELECT COUNT(*), u.name
  FROM users u
  INNER JOIN orders o
  ON o.order_id = u.order_id
  GROUP BY u.user_id;