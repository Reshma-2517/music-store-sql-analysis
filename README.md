# Music Store SQL Analysis

## Project Overview

This project analyzes a music store database using MySQL to understand customer behavior, sales performance, music preferences, and artist and genre trends.

The analysis focuses on answering practical business questions using SQL rather than just retrieving data. The goal is to turn the database into useful insights that could help the business understand its customers, products, and sales.

## Business Problem

A music store has data about customers, invoices, tracks, artists, albums, genres, and employees. However, having the data alone does not explain how the business is performing.

The analysis aims to answer questions such as:

* Which customers generate the most revenue?
* Which genres are most popular?
* Which artists generate the highest sales?
* Which countries have the highest number of customers?
* What are the top-selling tracks?
* How much are customers spending?
* Which genres are popular in different countries?
* Which customers and artists contribute most to overall revenue?

These questions help convert raw transactional data into information that can support business decisions.

## Dataset

The project uses a relational music store database containing tables related to:

* Customers
* Invoices
* Invoice Lines
* Tracks
* Albums
* Artists
* Genres
* Media Types
* Employees
* Playlist
* PlaylistTrack

The tables are connected through primary and foreign keys, allowing customer purchases to be traced from invoices to individual tracks, artists, albums, and genres.

## Tools Used

* MySQL
* MySQL Workbench
* SQL

## SQL Concepts Used

The analysis uses SQL concepts including:

* SELECT and filtering
* Sorting and limiting results
* Aggregate functions
* GROUP BY and HAVING
* Joins
* Subqueries
* Common Table Expressions (CTEs)
* Window functions
* Views

The techniques were used based on the problem being solved rather than adding unnecessary complexity to the queries.

## Analysis Approach

The project follows a simple analysis process:

1. Understand the database structure and relationships.
2. Explore the available data.
3. Identify relevant business questions.
4. Write SQL queries to answer each question.
5. Validate the results.
6. Identify useful patterns and trends.
7. Translate the results into business insights.

## Key Analysis Areas

### Customer Analysis

Customer spending was analyzed to identify high-value customers and understand their contribution to total revenue.

### Sales Analysis

Invoice and invoice-line data were used to analyze revenue, purchase quantities, and sales performance.

### Genre Analysis

Genres were compared based on sales and customer preferences to identify the most popular types of music.

### Artist Analysis

Artist-level sales were analyzed to identify artists contributing significantly to store revenue.

### Country Analysis

Customer and sales data were compared across countries to understand differences in customer distribution and purchasing behavior.

### Top Genres by Country

Genre preferences were analyzed within each country. Ranking techniques were used to identify the highest-performing genres while handling cases where multiple genres had the same position.

## Business Insights

The analysis can help the business:

* Identify high-value customers for targeted offers.
* Understand which genres and artists drive sales.
* Focus marketing efforts on popular music categories.
* Identify countries with stronger customer activity.
* Understand customer purchasing patterns.
* Make better decisions about promotions and product focus.

The exact findings and values are available in the SQL analysis file.

## Conclusion

This project demonstrates the use of MySQL to analyze a relational music store database and answer practical business questions.

The main objective was not just to write SQL queries, but to understand the problem, select the relevant data, perform the analysis, and explain what the results mean from a business perspective.
