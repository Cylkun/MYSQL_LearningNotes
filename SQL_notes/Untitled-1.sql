


-- 系统变量
-- 全局变量
SHOW GLOBAL VARIABLES;
SHOW GLOBAL VARIABLES LIKE '%char%';
SELECT @@global.autocommit;
SET GLOBAL autocommit = 0;
SET @@global.autocommit = 1;

-- 会话变量
SHOW SESSION VARIABLES;
SHOW VARIABLES;
SHOW SESSION VARIABLES LIKE '%char%';
SHOW VARIABLES LIKE '%char%';
-- ! 在 5.7.20 版本之后, 使用 `transaction_isolation` 替换 `tx_isolation`
SELECT @@session.transaction_isolation;
SELECT @@transaction_isolation;

SET SESSION transaction_isolation = 'READ-UNCOMMITTED';
SET transaction_isolation = 'REPEATABLE-READ';
SET @@session.transaction_isolation = 'READ-UNCOMMITTED';
SET @@transaction_isolation = 'REPEATABLE-READ';


-- 用户变量
-- 声明两个变量并赋初始值, 求和, 打印
SET @m = 1;
SET @n = 2;
SET @sum = @m + @n;
SELECT @sum;


-- 存储过程
-- 管理员身份进入命令行窗口
mysql -uroot -pcylk
use girls

-- 创建
-- 设置结束标志
DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
    INSERT INTO admin(username, `password`)
        VALUES('john', '0000'),
              ('lily', '0000'),
              ('rose', '0000'),
              ('jack', '0000'),
              ('tom', '0000');
END $

-- 调用
CALL myp1()$


-- 创建带 `IN` 模式参数的存储过程
-- 根据女神名, 查询对应的男神信息
-- 声明并初始化
CREATE PROCEDURE myp2(IN beautyName VARCHAR(20))-- ! 没有分号
BEGIN 
    SELECT bo.*
    FROM boys bo
        RIGHT JOIN beauty b ON bo.id = b.boyfriend_id
        WHERE b.name = beautyName; 
END $

-- 调用
CALL myp2('王语嫣') $


-- 创建存储过程实现, 用户是否登录成功
CREATE PROCEDURE myp3(IN username VARCHAR(20), IN `password` VARCHAR(20))
BEGIN
    DECLARE result INT DEFAULT 0;
    SELECT COUNT(*) INTO result
    FROM admin
    WHERE admin.username = username
        AND admin.`password` = `password`;

    SELECT IF(result>0, '成功', '失败');
END $

CALL myp3('张飞', '8888') $


-- 根据输入的女神名, 返回对应的男神名
CREATE PROCEDURE myp4(
    IN beautyName VARCHAR(20),
    OUT boyName VARCHAR(20)
)

BEGIN
	SELECT bo.boyname INTO boyname
	FROM boys bo
	    RIGHT JOIN beauty b ON b.boyfriend_id = bo.id
	WHERE b.name = beautyName;
END $

-- SET @bName $-- 可以不写
CALL myp4('王语嫣', @bName) $
SELECT @bName $


-- 根据输入的女神名, 返回对应的男神名和魅力值
CREATE PROCEDURE myp5(
    IN beautyName VARCHAR(20),
    OUT boyName VARCHAR(20),
    OUT userCP INT
)
BEGIN
    SELECT
        bo.boyname, bo.userCP INTO boyName, userCP
    FROM
        boys bo
        RIGHT JOIN beauty b ON b.boyfriend_id = bo.id
    WHERE
        b.name = beautyName;
END $

CALL myp5('王语嫣', @bName, @userCP) $
SELECT @bName, @userCP $


-- 传入 a 和 b 两个值, 最终 a 和 b 都翻倍并返回
CREATE PROCEDURE myp6(INOUT a INT, INOUT b INT)
BEGIN
    SET a = a * 2;
    SET b = b * 2;
END $

SET @m = 10 $
SET @n = 20 $
CALL myp6(@m, @n) $
SELECT @m, @n$


-- 练习
-- 创建存储过程实现传入用户名和密码, 插入到 admin 表中
CREATE PROCEDURE test_pro1(IN username VARCHAR(20), IN `password` VARCHAR(20))
BEGIN
    INSERT INTO admin(admin.username, admin.password) VALUES(username, `password`);
END $

CALL test_pro1('admin', '0000') $
SELECT * FROM admin $

-- 创建存储过程实现传入女神编号, 返回女神名称和女神电话
CREATE PROCEDURE test_pro2(IN id INT, OUT `name` VARCHAR(20), OUT phone VARCHAR(20))
BEGIN
    SELECT b.name, b.phone INTO `name`, phone
    FROM beauty b
    WHERE b.id = id;
END $

CALL test_pro2(1, @n, @p) $
SELECT @n, @p $

-- 创建存储存储过程或函数实现传入两个女神生日, 返回大小
CREATE PROCEDURE test_pro3(IN birth1 DATETIME, IN birth2 DATETIME, OUT result INT)
BEGIN
    SELECT DATEDIFF(birth1,birth2) INTO result;
END $

CALL test_pro3('1998-1-1', NOW(), @result) $
SELECT @result $


-- 删除存储过程
DROP PROCEDURE myp6 $

-- 只能一个一个删, 不能一次删除多个
-- ! ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ', myp2' at line 1
DROP PROCEDURE myp1, myp2 $


-- 查看存储过程的信息
-- ! Table 'girls.myp3' doesn't exist
DESC myp3;

SHOW CREATE PROCEDURE myp2;


-- 练习
-- 创建存储过程或函数实现传入一个日期, 格式化成 xx年xx月xx日 并返回
CREATE PROCEDURE test_pro4(IN mydate DATETIME, OUT strDate VARCHAR(20))
BEGIN
    SELECT DATE_FORMAT(mydate, '%y年%m月%d日') INTO strDate;
END $

CALL test_pro4(NOW(), @strdate) $
SELECT @strdate $

-- 创建存储过程或函数实现传入女神名称, 返回: 女神 and 男神  格式的字符串
CREATE PROCEDURE test_pro5(IN beautyName VARCHAR(20), OUT `str` VARCHAR(50))
BEGIN
    SELECT CONCAT(beautyName, ' and ', IFNULL(bo.boyName, 'NULL')) INTO `str`
    FROM beauty b
        LEFT JOIN boys bo ON b.boyfriend_id = bo.id
    WHERE b.name = beautyName;
END $

CALL test_pro5('王语嫣', @str) $
SELECT @str $
-- +-----------------+
-- | @str            |
-- +-----------------+
-- | 王语嫣 and 段誉 |
-- +-----------------+
-- 1 row in set (0.00 sec)

-- ! SELECT CONCAT(beautyName, ' and ', bo.boyName) INTO boyName
-- 如果 bo.boyName 为空, 则 CONCAT 的值将为空


-- 创建存储过程或函数, 根据传入的条目数和起始索引, 查询 beauty 表的记录
CREATE PROCEDURE test_pro6(IN startIndex INT, IN size INT)
BEGIN
    SELECT *
    FROM beauty
    LIMIT startIndex, size;
END $

CALL test_pro6(3, 5) $
-- +----+--------+------+---------------------+-------------+--------------+--------------+
-- | id | name   | sex  | borndate            | phone       | photo        | boyfriend_id |
-- +----+--------+------+---------------------+-------------+--------------+--------------+
-- |  7 | 岳灵珊 | 女   | 1987-12-30 00:00:00 | 18219876577 | NULL         |            2 |
-- | 10 | 王语嫣 | 女   | 1992-02-03 00:00:00 | 18209179577 | NULL         |            4 |
-- | 14 | 金星   | 女   | 1987-01-01 00:00:00 | 18966668888 | NULL         |            2 |
-- | 15 | 娜扎   | 女   | 1987-01-01 00:00:00 | 18966668888 | NULL         |            2 |
-- | 18 | 张飞   | 女   | NULL                | 18966668888 | NULL         |            2 |
-- +----+--------+------+---------------------+-------------+--------------+--------------+
-- 5 rows in set (0.00 sec)
/*
```


```sql
*/
