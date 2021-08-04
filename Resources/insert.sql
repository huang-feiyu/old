-- INSERT into author VALUES
-- (51, "库切", 26, 1940, 2, 9, 9999, 1, 1, 0);

-- INSERT INTO book VALUES
-- (175, "青春", "null", 230, 140, 1, 0, 0, 175, 0, 1, 175, 51, 129);

-- INSERT INTO my_info VALUES
-- (175, 2021, 8, 1, 0, "null", 80);

-- INSERT INTO release VALUES
-- (175, 2017, 2, 978, 7, 5339, 4702, 6);

-- -- INSERT INTO press VALUES
-- -- (5339, "浙江文艺出版社");

-- INSERT INTO country VALUES
-- (26, "南非");

-- INSERT INTO translator VALUES
-- (129, "王家湘");

UPDATE my_info 
SET date_month=8, date_day=4, read_times=3, book_link="https://huang-feiyu.github.io/2021/08/04/Sisyphus-myth/", score = 84
WHERE id = 50;