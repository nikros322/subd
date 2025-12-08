-- Clean up old tables
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS books_no_index;

-- SECTION 1: TABLE WITH FULLTEXT INDEX

-- 2. Create the 'books' table
CREATE TABLE books ( 
    id INT PRIMARY KEY, 
    title VARCHAR(100), 
    author VARCHAR(50), 
    year INT 
); 

-- 3. Correct MariaDB setting for recursion limit (CRITICAL FIX)
SET SESSION max_recursive_iterations = 150000; 

-- 4. Insert 150,000 synthetic records (Wait for this step to complete)
INSERT INTO books (id, title, author, year) 
WITH RECURSIVE numbers(n) AS ( 
    SELECT 0 
    UNION ALL 
    SELECT n + 1 FROM numbers WHERE n < 149999 
) 
SELECT 
    n+1 AS id, 
    CONCAT('Book', n+1) AS title, 
    CONCAT('Author', FLOOR(RAND()*100)) AS author, 
    1950 + FLOOR(RAND()*70) AS year 
FROM numbers; 

-- 5. Add the FULLTEXT Index
ALTER TABLE books 
ADD FULLTEXT(title, author); 

-- 6. Test 1: Search using the FULLTEXT Index
SELECT '--- Test 1: Search with FULLTEXT Index ---' AS test_type; 
EXPLAIN SELECT * FROM books 
WHERE MATCH(title, author) AGAINST('Book10' IN NATURAL LANGUAGE MODE); 

SELECT * FROM books WHERE MATCH(title, author) AGAINST('Book10' IN NATURAL LANGUAGE MODE) LIMIT 5; 

-- SECTION 2: TABLE WITHOUT FULLTEXT INDEX (Search via LIKE)

-- 7. Create the second table 'books_no_index'
CREATE TABLE books_no_index ( 
    id INT PRIMARY KEY, 
    title VARCHAR(100), 
    author VARCHAR(50), 
    year INT 
); 

-- 8. Copy 150,000 records
INSERT INTO books_no_index (id, title, author, year) 
SELECT * FROM books; 

-- 9. Test 2: Search without a dedicated index (Table Scan)
SELECT '--- Test 2: Search without Index (LIKE) ---' AS test_type; 
EXPLAIN SELECT * FROM books_no_index 
WHERE title LIKE '%Book10%'; 

SELECT * FROM books_no_index WHERE title LIKE '%Book10%' LIMIT 5;