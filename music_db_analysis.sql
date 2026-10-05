CREATE DATABASE music_store;
USE music_store;

-- 1. Genre and MediaType
CREATE TABLE Genre (
	genre_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(120)
	);
SELECT * FROM Genre;


CREATE TABLE MediaType (
	media_type_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(120)
	);
SELECT * FROM MediaType;

-- 2. Employee
CREATE TABLE Employee (
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
	last_name VARCHAR(120),
	first_name VARCHAR(120),
	title VARCHAR(120),
	reports_to INT,
	levels VARCHAR(255),
	birthdate DATE,
	hire_date DATE,
	address VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(100)
	);
SELECT * FROM employee;


-- 3. Customer
CREATE TABLE Customer (
		customer_id INT PRIMARY KEY AUTO_INCREMENT,
		first_name VARCHAR(120),
		last_name VARCHAR(120),
		company VARCHAR(120),
		address VARCHAR(255),
		city VARCHAR(100),
		state VARCHAR(100),
		country VARCHAR(100),
		postal_code VARCHAR(20),
		phone VARCHAR(50),
		fax VARCHAR(50),
		email VARCHAR(100),
		support_rep_id INT,
		FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
		);
SELECT * FROM customer;
	   
-- 4. Artist
CREATE TABLE Artist (
	artist_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(120)
	);
SELECT * FROM Artist;

-- 5. Album	
CREATE TABLE Album (
		album_id INT PRIMARY KEY AUTO_INCREMENT,
		title VARCHAR(160),
		artist_id INT,
		FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);


-- 6. Track
CREATE TABLE Track (
	track_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(200),
	album_id INT,
	media_type_id INT,
	genre_id INT,
	composer VARCHAR(220),
	milliseconds INT,
	bytes INT,
	unit_price DECIMAL(10,2),
	FOREIGN KEY (album_id)
	REFERENCES Album(album_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	FOREIGN KEY (media_type_id)
	REFERENCES MediaType(media_type_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	FOREIGN KEY (genre_id)
	REFERENCES Genre(genre_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	);
SELECT * FROM track
LIMIT 5;

-- 7. Invoice
CREATE TABLE Invoice (
	invoice_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_id INT,
	invoice_date DATE,
	billing_address VARCHAR(255),
	billing_city VARCHAR(100),
	billing_state VARCHAR(100),
	billing_country VARCHAR(100),
	billing_postal_code VARCHAR(20),
	total DECIMAL(10,2),
	FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	);
SELECT * FROM Invoice
LIMIT 5;

-- 8. InvoiceLine
CREATE TABLE InvoiceLine (
	invoice_line_id INT PRIMARY KEY AUTO_INCREMENT,
	invoice_id INT,
	track_id INT,
	unit_price DECIMAL(10,2),
	quantity INT,
	FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	);
SELECT * FROM InvoiceLine
LIMIT 5;

-- 9. Playlist
CREATE TABLE Playlist (
	playlist_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255)
);

SELECT * FROM Playlist
LIMIT 5;

-- 10. PlaylistTrack
CREATE TABLE PlaylistTrack (
		playlist_id INT,
		track_id INT,
		PRIMARY KEY (playlist_id, track_id),
		FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		FOREIGN KEY (track_id) REFERENCES Track(track_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

SELECT COUNT(*) from track;



-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 1. Who is the senior most employee based on job title?  
-- -----------------------------------------------------------------------------------------------------------------------------------------
	SELECT 
		employee_id,
		CONCAT(first_name, ' ', last_name) AS employee_name,
		title,
		levels
	FROM Employee
	ORDER BY levels DESC
	LIMIT 1;

-- Insight:
/*  Identifies the employee with the highest organizational level, showing who holds the most senior position. 
	This helps understand the company’s leadership structure and reporting hierarchy. */

-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 2. Which countries have the most Invoices? 
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 	SELECT 
-- 		billing_country,
-- 		COUNT(invoice_id) AS invoice_count
-- 	FROM Invoice
-- 	GROUP BY billing_country
-- 	ORDER BY invoice_count DESC;
    
    -- ---------- view ----------------
CREATE VIEW invoice_count_by_country AS
SELECT 
    billing_country,
    COUNT(invoice_id) AS invoice_count
FROM Invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;

SELECT *
FROM invoice_count_by_country;
    
-- Insight: 
-- Shows which countries generate the highest number of customer transactions. 
-- These markets have stronger purchasing activity and can be important targets for regional marketing.

-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 3. What are the top 3 values of total invoice?
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 	SELECT 
-- 		invoice_id,
-- 		total AS invoice_total
-- 	FROM Invoice
-- 	ORDER BY total DESC
-- 	LIMIT 3;
    
SELECT invoice_id, total
FROM (
    SELECT 
        invoice_id,
        total,
        ROW_NUMBER() OVER (ORDER BY total DESC) AS rn
    FROM Invoice
) AS ranked_invoices
WHERE rn <= 3;
-- Insight:
-- Highlights the three largest individual invoices in the business. 
-- These transactions represent high-value purchases and can help identify unusually large customer orders.


-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 4. Which city has the best customers? - We would like to throw a promotional Music Festival in 
	-- the city we made the most money. Write a query that returns one city that has the highest sum of 
	-- invoice totals. Return both the city name & sum of all invoice totals 
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 	SELECT
-- 		billing_city,
-- 		SUM(total) AS total_revenue
-- 	FROM Invoice
-- 	GROUP BY billing_city
-- 	ORDER BY total_revenue DESC
-- 	LIMIT 1;
    
-- using CTE
    WITH city_revenue AS (
    SELECT
        billing_city,
        SUM(total) AS total_revenue
    FROM Invoice
    GROUP BY billing_city
)
SELECT
    billing_city,
    total_revenue
FROM city_revenue
ORDER BY total_revenue DESC
LIMIT 1;
-- Insight:
-- Identifies the city contributing the most total invoice revenue. 
-- This city represents a strong revenue market and could be considered when planning promotional events.

-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 5. Who is the best customer? - The customer who has spent the most money will be declared 
	-- the best customer. Write a query that returns the person who has spent the most money 
-- -----------------------------------------------------------------------------------------------------------------------------------------
	SELECT
		c.customer_id,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		SUM(i.total) AS total_spent
	FROM Customer AS c
	INNER JOIN Invoice AS i
	ON c.customer_id = i.customer_id
	GROUP BY c.customer_id, c.first_name, c.last_name
	ORDER BY total_spent DESC
	LIMIT 1;
-- Insight:
-- Identifies the customer who has generated the greatest total spending. 
-- This customer represents a high-value relationship and could be important for customer-retention strategies.

-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. 
	-- Return your list ordered alphabetically by email starting with A 
-- -----------------------------------------------------------------------------------------------------------------------------------------
	SELECT DISTINCT
		c.email,
		c.first_name,
		c.last_name,
		g.name AS genre
	FROM Customer AS c
	INNER JOIN Invoice AS i
	ON c.customer_id = i.customer_id
	INNER JOIN InvoiceLine AS il
	ON i.invoice_id = il.invoice_id
	INNER JOIN Track AS t
	ON il.track_id = t.track_id
	INNER JOIN Genre AS g
	ON t.genre_id = g.genre_id
	WHERE g.name = 'Rock'
	ORDER BY c.email;
-- Insight:
-- Identifies customers who have purchased Rock music, providing a clear audience segment based on listening preferences.
-- This information can support targeted Rock related promotions and recommendations

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 7. Let's invite the artists who have written the most rock music in our dataset. Write a query that 
-- returns the Artist name and total track count of the top 10 rock bands  
-- -----------------------------------------------------------------------------------------------------------------------------------------
    
-- Derived table
SELECT
    artist_name,
    COUNT(track_id) AS rock_track_count
FROM (
    SELECT
        ar.artist_id,
        ar.name AS artist_name,
        t.track_id
    FROM Artist AS ar
    INNER JOIN Album AS al
	ON ar.artist_id = al.artist_id
    INNER JOIN Track AS t
	ON al.album_id = t.album_id
    INNER JOIN Genre AS g
	ON t.genre_id = g.genre_id
    WHERE g.name = 'Rock'
) AS rock_tracks
GROUP BY artist_id, artist_name
ORDER BY rock_track_count DESC
LIMIT 10;

-- Insight:
-- Shows which artists have the largest number of Rock tracks in the catalog. 
-- These artists have strong representation in the Rock inventory and may be useful for genre-focused promotions.

-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 8. Return all the track names that have a song length longer than the average song length.- 
	-- Return the Name and Milliseconds for each track. Order by the song length, with the longest 
	-- songs listed first 
-- -----------------------------------------------------------------------------------------------------------------------------------------
	SELECT
		name AS track_name,
		milliseconds
	FROM Track
	WHERE milliseconds > (
		SELECT AVG(milliseconds)
		FROM Track
	)
	ORDER BY milliseconds DESC;
-- Insight:
-- Identifies songs that are longer than the overall average track duration. 
-- Helps identify the longer songs in the music catalog for further analysis of customer listening patterns.

-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 9. Find how much amount is spent by each customer on artists? Write a query to return 
	-- customer name, artist name and total spent 
-- -----------------------------------------------------------------------------------------------------------------------------------------

#using view ------------------------------------------
CREATE VIEW customer_artist_purchases AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ar.artist_id,
    ar.name AS artist_name,
    il.unit_price * il.quantity AS amount
FROM Customer AS c
INNER JOIN Invoice AS i
ON c.customer_id = i.customer_id
INNER JOIN InvoiceLine AS il
ON i.invoice_id = il.invoice_id
INNER JOIN Track AS t
ON il.track_id = t.track_id
INNER JOIN Album AS al
ON t.album_id = al.album_id
INNER JOIN Artist AS ar
ON al.artist_id = ar.artist_id;
    
#view query ----------------------------
SELECT
    customer_name,
    artist_name,
    SUM(amount) AS total_spent
FROM customer_artist_purchases
GROUP BY
    customer_id,
    customer_name,
    artist_id,
    artist_name
ORDER BY total_spent DESC;


-- Insight:
--  how much each customer spends on individual artists, revealing customer–artist purchasing patterns. 
-- This can support personalized recommendations and artist-specific marketing.



-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 10. We want to find out the most popular music Genre for each country. We determine the most 
	-- popular genre as the genre with the highest amount of purchases. Write a query that returns 
	-- each country along with the top Genre. For countries where the maximum number of purchases 
	-- is shared, return all Genres 
-- -----------------------------------------------------------------------------------------------------------------------------------------
WITH genre_purchases AS (
    SELECT
        i.billing_country AS country,
        g.name AS genre,
        COUNT(il.invoice_line_id) AS purchase_count
    FROM Invoice AS i
    JOIN InvoiceLine AS il
        ON i.invoice_id = il.invoice_id
    JOIN Track AS t
        ON il.track_id = t.track_id
    JOIN Genre AS g
        ON t.genre_id = g.genre_id
    GROUP BY
        i.billing_country,
        g.name
),

max_purchases AS (
    SELECT
        country,
        MAX(purchase_count) AS max_purchase_count
    FROM genre_purchases
    GROUP BY country
)

SELECT
    gp.country,
    gp.genre,
    gp.purchase_count
FROM genre_purchases AS gp
JOIN max_purchases AS mp
    ON gp.country = mp.country
    AND gp.purchase_count = mp.max_purchase_count
ORDER BY mp.max_purchase_count DESC;
	
-- Insight:
-- Identifies the most purchased genre in each country, revealing differences in music preferences across markets. 
-- Shared rankings also show where customer demand is distributed across multiple genres.

      
-- -----------------------------------------------------------------------------------------------------------------------------------------
	-- 11. Write a query that determines the customer that has spent the most on music for each 
	-- country. Write a query that returns the country along with the top customer and how much they 
	-- spent. For countries where the top amount spent is shared, provide all customers who spent this 
	-- amount
-- -----------------------------------------------------------------------------------------------------------------------------------------

WITH customer_spending AS (
    SELECT
        i.billing_country AS country,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(i.total) AS total_spent
    FROM Customer AS c
    INNER JOIN Invoice AS i
        ON c.customer_id = i.customer_id
    GROUP BY
	i.billing_country,
	c.customer_id,
	c.first_name,
	c.last_name
),

max_spending AS (
    SELECT
        country,
        MAX(total_spent) AS max_total_spent
    FROM customer_spending
    GROUP BY country
)
SELECT
    cs.country,
    cs.customer_name,
    cs.total_spent
FROM customer_spending AS cs
INNER JOIN max_spending AS ms
    ON cs.country = ms.country
    AND cs.total_spent = ms.max_total_spent
ORDER BY cs.country;
-- Insight:
-- Identifies the top customer in each country based on total spending. 
-- This helps reveal high-value customers within individual markets and supports country-level customer relationship strategies.











