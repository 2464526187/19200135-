CREATE TABLE 借阅
(	证件号 CHAR(10) NOT NULL,
	图书编号 CHAR(13) NOT NULL,
	借阅日期 DATE NOT NULL,
	应还日期 DATE NOT NULL,
	归还日期 DATE ,
	罚款金 MONEY NOT NULL DEFAULT 0.0 CHECK (罚款金>=0.0)
	CONSTRAINT Book_Borrow_pkzjsh PRIMARY KEY (证件号,图书编号,借阅日期),
	CONSTRAINT Book_Borrow_fkzjh FOREIGN KEY (证件号) REFERENCES 读者(证件号),
	CONSTRAINT Book_Borrow_fktsbh FOREIGN KEY (图书编号) REFERENCES 图书(图书编号)
)
例3-2 ALTER TABLE 读者 ADD DEFAULT ('可用') FOR 证件状态
例3-3 ALTER TABLE 读者 DROP COLUMN 联系方式
例3-4 ALTER TABLE 读者 ADD 电话 CHAR(12)
例3-5 ALTER TABLE 图书 ALTER COLUMN 图书名称 VARCHAR(50) NULL
例3-6 DROP TABLE 图书类型 CASCADE
例3-7 CREATE VIEW 计算机图书
          AS
	SELECT 图书 .*,图书类型.图书分类名称
	FROM 图书,图书类型
	WHERE 图书.图书分类号=图书类型.图书分类号
		AND 图书类型.图书分类名称 LIKE '计算机%'
         SELECT  * FROM 计算机图书
例3-8 CREATE VIEW 读者借书情况表(读者证件号,读者姓名,图书名称,借书日期)
          AS
	SELECT 读者.证件号,读者.姓名,图书.图书名称,借阅.借阅日期
	FROM 读者,图书,借阅
	WHERE 读者.证件号=借阅.证件号
		AND 图书.图书编号=借阅.图书编号
例3-9 DROP VIEW 计算机图书
例3-10 CREATE INDEX BookBorrowInfo_ZJH_JYRQ
            ON 借阅 (证件号,借阅日期)
例3-11 CREATE INDEX BookBorrowInfo_FLH
 ON 图书(图书分类号)
 CREATE INDEX BookBorrowInfo_TSMC
 ON 图书(图书名称)
 CREATE INDEX BookBorrowInfo_CBS
 ON 图书(出版社)
例3-12 SELECT 图书名称,出版社,价格 FROM 图书 WHERE 作者='杨万华'
例3-13 SELECT DISTINCT 图书名称,价格 FROM 图书 WHERE 图书名称='计算机主板维修从业技能全程通'
例3-14 SELECT  图书名称 ,COUNT(*) 总馆藏量
FROM 图书
GROUP BY 图书名称
ORDER BY 总馆藏量 DESC
例3-15 SELECT 姓名,图书名称,借阅.借阅日期,借阅.归还日期
FROM 图书,读者,借阅
WHERE 读者.证件号=借阅.证件号 AND 图书.图书编号=借阅.图书编号
	AND 姓名='王小虎'
例3-16 SELECT 读者.姓名 ,COUNT(*) 借书数量
FROM 读者,借阅
WHERE 读者.证件号=借阅.证件号
GROUP BY 读者.姓名
例3-17SELECT 姓名 AS 不可借阅图书的读者,证件状态
FROM 读者
WHERE 证件状态='失效'
例3-18 SELECT 读者.证件号,读者.姓名
FROM 读者,借阅
WHERE 读者.证件号=借阅.证件号
	AND 借阅.应还日期<借阅.归还日期
例3-19 SELECT 读者.证件号,读者.姓名
FROM 读者,借阅
WHERE GETDATE()>应还日期
	AND 读者.证件号=借阅.证件号
	AND 借阅.归还日期 IS NULL
例3-20 SELECT COUNT(*) 借书总量
FROM 借阅
WHERE 借阅日期 <'2015-09-01'
例3-21 UPDATE 读者
SET 证件状态='可用'
WHERE 姓名='陈晓琪'
例3-22 DELETE FROM 借阅
WHERE 证件号=(SELECT 证件号 FROM 读者 WHERE 姓名='李涵')
例3-23 INSERT INTO 图书(图书编号,图书名称,图书分类号,作者,出版社,价格)
VALUES('9787115231011','C++程序设计','TP301','谭浩强','清华大学出版社','24.00')
例3-24 INSERT INTO 借阅(证件号,图书编号,借阅日期,应还日期,归还日期,罚款金)
VALUES('J200902002','9787115231011','2015-10-13','2015-11-13','','')
例3-25 UPDATE 借阅
SET 罚款金=0.1*(SELECT DATEDIFF(DAY,归还日期,GETDATE()) 超期天数
				FROM 借阅
				WHERE 证件号='W200912004'AND 图书编号='9787115224996')
WHERE 证件号='W200912004' AND 图书编号='9787115224996'
例3-26 CREATE TRIGGER INSERT_借阅
ON 借阅
FOR INSERT
AS
IF
	(SELECT COUNT(*) FROM 读者,inserted
	WHERE 读者.证件号=inserted.证件号)=0
	BEGIN
		PRINT'没有该读者信息'
		ROLLBACK TRANSACTION
	END
例3-27 CREATE TRIGGER INSERT_借阅
ON 借阅
FOR UPDATE
AS
IF
	UPDATE(借阅日期)
	BEGIN
		PRINT'不能手工修改借阅日期'
		ROLLBACK TRANSACTION
	END
例3-28 CREATE TRIGGER DELETE_读者
ON 读者
FOR DELETE
AS
	DELETE FROM 借阅
	WHERE 证件号 in
	(SELECT 证件号 FROM deleted)