----------------------------------------------
-- 插入区
----------------------------------------------
-- -- INSERT into author VALUES
-- -- (174, "河合隼雄", 4, 1928, 6, 23, 2007, 7, 19, 0),
-- -- (175, "安娜·陀思妥耶夫斯卡娅", 1, 1846, 9, 12, 1918, 6, 9, 1);

-- INSERT INTO translator VALUES
-- (135, "马振骋");

-- INSERT INTO book VALUES
-- (183, "窄门", "null", 176, 106, 1, 0, 1, 183, 0, 2, 183, 5, 135),
-- (184, "违背道德的人", "null", 160, 100, 0, 0, 0, 184, 0, 2, 184, 5, 135),
-- (185, "田园交响曲", "null", 100, 41, 0, 0, 0, 185, 0, 2, 185, 5, 135);

-- INSERT INTO my_info VALUES
-- (183, 2021, 8, 13, 1, "https://huang-feiyu.github.io/2021/08/13/Moral-Trilogy", 85),
-- (184, 2021, 8, 12, 1, "https://huang-feiyu.github.io/2021/08/13/Moral-Trilogy", 83),
-- (185, 2021, 8, 11, 1, "https://huang-feiyu.github.io/2021/08/13/Moral-Trilogy", 80);

-- INSERT INTO release VALUES
-- (183, 2018, 6, 978, 7, 02, 014107, 4),
-- (184, 2018, 6, 978, 7, 02, 014055, 8),
-- (185, 2018, 6, 978, 7, 02, 014150, 0);

-- INSERT INTO press VALUES
-- (5437, "东方出版中心");

-- INSERT INTO country VALUES
-- (26, "南非");


----------------------------------------------
-- 查询区
----------------------------------------------
SELECT book.id as id, book.name as name, my_info.score as score
FROM book JOIN my_info ON book.my_info=my_info.id
ORDER BY my_info.score DESC;


----------------------------------------------
-- 插入区
----------------------------------------------
--- 94以上为我心目中top10作品, 5.5颗星, 多出的一颗星是我的心灵感受
UPDATE my_info
SET score = 100
WHERE id = 1;

UPDATE my_info
SET score = 99
WHERE id = 80;

UPDATE my_info
SET score = 98
WHERE id IN (56, 42);

UPDATE my_info
SET score = 97
WHERE id IN (55, 100);

UPDATE my_info
SET score = 96
WHERE id IN (48, 52, 50);

UPDATE my_info
SET score = 95
WHERE id IN (58, 101, 66, 59, 15);


--- 89以上为大力推荐作品, 5颗星
UPDATE my_info
SET score=94
WHERE id IN (61, 60, 70, 63);

UPDATE my_info
SET score=93
WHERE id IN (166, 167, 64, 37, 57);



UPDATE my_info
SET score=90
WHERE id IN ();

-- --- 84以上为很优秀作品, 4.5颗星
-- UPDATE my_info
-- SET score = 88
-- WHERE id = 90;

--- 80以上为很好的作品, 4颗星

--- 80分为我没有读过但是已经买了的作品
-- UPDATE my_info
-- SET score = 80
-- WHERE read_times = 0;

--- 80分以下是随便给的分
UPDATE my_info
SET score = 70
WHERE id in (91);

--- 60分以下是垃圾书