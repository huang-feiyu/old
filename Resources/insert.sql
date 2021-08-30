----------------------------------------------
-- 插入区
----------------------------------------------
-- INSERT into author VALUES
-- (176, "罗兰·巴特", 2, 1915, 11, 12, 1980, 3, 25, 0);

-- INSERT INTO translator VALUES
-- (136, "汪耀进、武佩荣"),
-- (137, "靖振忠");

-- INSERT INTO book VALUES
-- (186, "恋人絮语",   "null", 225, 201, 0, 0, 1, 186, 0, 5, 186, 176, 136),
-- (187, "索拉里斯星", "null", 254, 180, 1, 1, 1, 187, 0, 1, 187,  34, 137);

-- INSERT INTO my_info VALUES
-- (186, 2021, 8, 21, 0, "null", 80),
-- (187, 2021, 8, 21, 0, "null", 80);

-- INSERT INTO release VALUES
-- (186, 2018, 6, 978, 7, 208, 13904, 6),
-- (187, 2018, 6, 978, 7, 5447, 8217, 3);

-- INSERT INTO press VALUES
-- (5437, "东方出版中心");

-- INSERT INTO country VALUES
-- (26, "南非");


----------------------------------------------
-- 更新区
----------------------------------------------

UPDATE my_info
SET date_month=8, date_day=29,
 read_times=1,
 score = 87
WHERE id = 175;


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
-- UPDATE my_info
-- SET score = 100
-- WHERE id = 1;

-- UPDATE my_info
-- SET score = 99
-- WHERE id = 80;

-- UPDATE my_info
-- SET score = 98
-- WHERE id IN (56, 42);

-- UPDATE my_info
-- SET score = 97
-- WHERE id IN (55, 100);

-- UPDATE my_info
-- SET score = 96
-- WHERE id IN (48, 52, 50);

-- UPDATE my_info
-- SET score = 95
-- WHERE id IN (58, 101, 66, 59, 15);


-- --- 89以上为大力推荐作品, 5颗星
-- UPDATE my_info
-- SET score=94
-- WHERE id IN (61, 60, 70, 63);

-- UPDATE my_info
-- SET score=93
-- WHERE id IN (166, 167, 64, 37, 57);



-- UPDATE my_info
-- SET score=90
-- WHERE id IN ();

-- -- --- 84以上为很优秀作品, 4.5颗星
-- -- UPDATE my_info
-- -- SET score = 88
-- -- WHERE id = 90;

-- --- 80以上为很好的作品, 4颗星

-- --- 80分为我没有读过但是已经买了的作品
-- -- UPDATE my_info
-- -- SET score = 80
-- -- WHERE read_times = 0;

-- --- 80分以下是随便给的分
-- UPDATE my_info
-- SET score = 70
-- WHERE id in (91);

--- 60分以下是垃圾书