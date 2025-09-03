-- Name: percentage.sql
-- Author: Sabysachi Mitra
-- Date: 12/15/2024
-- Desc: Calculating percentage of a value of a all the values in a table.
-- 
-- Create example data
-- 
CREATE TABLE movie_earnings (
  movie_name   VARCHAR(30),
  actor_name   VARCHAR(30),
  earnings     NUMBER
);
-- 
INSERT INTO movie_earnings VALUES
   ('Thor: Love and Thunder', 'Chris Hemsworth', 5000000);
INSERT INTO movie_earnings VALUES
   ('Thor: Love and Thunder', 'Natalie Portman', 2000000);
INSERT INTO movie_earnings VALUES
   ('Thor: Love and Thunder', 'Christian Bale',  1000000);
 
INSERT INTO movie_earnings VALUES
   ('Minions: The Rise of Gru', 'Steve Carell',  500000);
INSERT INTO movie_earnings VALUES
   ('Minions: The Rise of Gru', 'Pierre Coffin', 100000);
COMMIT;
-- 
SELECT * FROM movie_earnings;
--
-- Calculating percentage of each actor of total earnings 
-- 
SELECT movie_name, actor_name,
       ROUND(100 * earnings/sums.total, 2) AS percent
FROM movie_earnings, (
       SELECT SUM(earnings) AS total
         FROM movie_earnings
     ) sums
ORDER BY percent DESC;
--
SELECT
    movie_name, actor_name,
    ROUND(
       100 * earnings / SUM(earnings) OVER (),
    2) AS percent
FROM movie_earnings
ORDER BY percent DESC;