----------------------------------------------
-- 插入区
----------------------------------------------
-- INSERT into author VALUES
-- (177, "玛格丽特·杜拉斯", 2, 1914, 4, 4, 1996, 3, 3, 1);

-- INSERT INTO translator VALUES
-- (139, "朱雁飞");

-- INSERT INTO book VALUES
-- (189, "在轮下", "Kindle", 272, 104, 1, 0, 0, 189, 0, 2, 189, 3, 139);

-- INSERT INTO my_info VALUES
-- (189, 2021, 9, 5, 1, "null", 83);

-- INSERT INTO release VALUES
-- (189, 2019, 5, 978, 7, 5404, 9102, 4);

-- INSERT INTO press VALUES
-- (5437, "东方出版中心");

-- INSERT INTO country VALUES
-- (26, "南非");


----------------------------------------------
-- 更新区
----------------------------------------------


-- UPDATE my_info
-- SET date_month=8, date_day=29,
--  read_times=1,
--  score = 87
-- WHERE id = 175;


----------------------------------------------
-- 查询区
----------------------------------------------
SELECT book.id as id, book.name as name, my_info.score as score
FROM book JOIN my_info ON book.my_info=my_info.id
ORDER BY my_info.score DESC;


----------------------------------------------
-- 插入区
----------------------------------------------
--- 94以上为我心目中top10作品, 5.5颗星, 多出的半颗星是我的心灵感受
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


--- 89以上为大力推荐作品, 5颗星

--- 84以上为很优秀作品, 4.5颗星

--- 80以上为很好的作品, 4颗星

--- 80分为我没有读过但是已经买了的作品
UPDATE my_info
SET score = 80
WHERE read_times = 0;

--- 80分以下是随便给的分
-- UPDATE my_info
-- SET score = 70
-- WHERE id in ();

--- 60分以下是垃圾书

--- 0分为完全读不懂的书，或者多个版本中较差的版本
-- UPDATE my_info
-- SET score = 0
-- WHERE id = 0;
