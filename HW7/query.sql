-- =========================================================================
-- Практична робота до теми 7. «Вкладені запити. Повторне використання коду»
-- =========================================================================

-- Задача 1. Підзапит для визначення авторів, чиї книги не замовляли
SELECT a.AuthorID, a.Name
FROM Authors a
WHERE NOT EXISTS (
  SELECT 1
  FROM AuthorBook ab
  JOIN OrderItem oi ON oi.BookID = ab.BookID
  WHERE ab.AuthorID = a.AuthorID
);

-- Задача 2. Книги з продажами вище середнього
SELECT b.Title, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM OrderItem oi
JOIN Books b ON b.BookID = oi.BookID
GROUP BY b.Title
HAVING Revenue > (
  SELECT AVG(Quantity * UnitPrice) FROM OrderItem
);

-- Задача 3. Рейтинг книг у межах жанру (CTE + віконна функція)
WITH sales AS (
  SELECT b.Title, b.Genre, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
  FROM Books b
  JOIN OrderItem oi ON oi.BookID = b.BookID
  GROUP BY b.Title, b.Genre
)
SELECT Title, Genre, Revenue,
       RANK() OVER (PARTITION BY Genre ORDER BY Revenue DESC) AS GenreRank
FROM sales;

-- Задача 4. Повторне використання коду (VIEW)
CREATE OR REPLACE VIEW v_book_sales AS
SELECT b.BookID, b.Title, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM Books b
LEFT JOIN OrderItem oi ON oi.BookID = b.BookID
GROUP BY b.BookID, b.Title;

-- Виклик створеного VIEW
SELECT * FROM v_book_sales ORDER BY Revenue DESC;