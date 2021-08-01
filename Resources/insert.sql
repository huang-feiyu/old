-- INSERT into author VALUES
-- (50, "加西亚·马尔克斯", 25, 1927, 3, 6, 2014, 4, 17, 0),
-- (172, "欧内斯特·海明威", 8, 1899, 7, 21, 1961, 7, 2, 0);

-- INSERT INTO book VALUES
-- (173, "百年孤独", "null", 360, 262, 1, 1, 0, 173, 0, 1, 173, 50, 127),
-- (174, "老人与海", "null", 256, 70, 1, 1, 0, 174, 0, 2, 174, 172, 128);

-- INSERT INTO my_info VALUES
-- (173, 2021, 8, 1, 0, "null", 80),
-- (174, 2021, 8, 1, 0, "null", 80);

-- INSERT INTO release VALUES
-- (173, 2017, 8, 978, 7, 5442, 9117, 0),
-- (174, 2016, 10, 978, 7, 5168, 1168, 9);

-- INSERT INTO press VALUES
-- (5168, "台海出版社");

-- INSERT INTO country VALUES
-- (25, "哥伦比亚");

-- INSERT INTO translator VALUES
-- (127, "范晔"),
-- (128, "李亚飞");

-- UPDATE release 
-- SET area_number=7
-- WHERE id = 172;

UPDATE my_info 
SET date_month=8, date_day=1, read_times=1, book_link="https://huang-feiyu.github.io/2021/08/01/The-Brothers-Karamazov"
WHERE id = 1