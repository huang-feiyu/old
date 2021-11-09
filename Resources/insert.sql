----------------------------------------------
-- 插入区
----------------------------------------------
-- INSERT into author VALUES
-- (183,  "洛莉·戈特利布", 8, 1988, 1, 1, 9999, 1, 1, 1);

INSERT INTO translator VALUES
(150, "严忠志");

INSERT INTO book VALUES
(202, "托尔斯泰或陀思妥耶夫斯基", "Kindle", 347, 342, 0, 0, 1,
 202, 0, 8, 202, 179, 150);

INSERT INTO my_info VALUES
(202, 2021, 11, 9, 1, "null", 88);

INSERT INTO release VALUES
(202, 2011, 10, 978, 7, 308, 08711, 7);

-- INSERT INTO type VALUES
-- (26, "科学哲学");

-- INSERT INTO press VALUES
-- (55590, "河南文艺出版社");

-- INSERT INTO country VALUES
-- (26, "南非");


----------------------------------------------
-- 更新区
----------------------------------------------

-- UPDATE my_info
-- SET score=79
-- WHERE id = 200;

-- UPDATE release
-- SET release_number=9514
-- WHERE id=200;

----------------------------------------------
-- 查询区
----------------------------------------------
SELECT book.id as id, book.name as name, my_info.score as score
FROM book JOIN my_info ON book.my_info=my_info.id
ORDER BY my_info.score DESC;


----------------------------------------------
-- 评分区
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
-- UPDATE my_info
-- SET score = 85
-- WHERE id IN (87, 173);

--- 84以上为很优秀作品, 4.5颗星

--- 80以上为很好的作品, 4颗星

--- 80分为我没有读过但是已经买了的作品
-- UPDATE my_info
-- SET score = 80
-- WHERE read_times = 0;

--- 80分以下是随便给的分
-- UPDATE my_info
-- SET score = 70
-- WHERE id in ();

--- 60分以下是垃圾书

--- 0分为完全读不懂的书，或者多个版本中较差的版本
-- UPDATE my_info
-- SET score = 0
-- WHERE id = 0;
