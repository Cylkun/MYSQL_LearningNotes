


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


-- 函数
-- 无参有返回
-- 返回公司员工的个数

-- 运行前先执行 `set global log_bin_trust_function_creators=1;`, 否则会报错
-- ! ERROR 1418 (HY000): This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)
SET GLOBAL log_bin_trust_function_creators = 1;
-- 创建时用 `RETURNS`, 只声明类型, 不写具体变量
CREATE FUNCTION myf1() RETURNS INT
BEGIN
    -- 定义变量
    DECLARE c INT DEFAULT 0;
    -- 赋值
    SELECT COUNT(*) INTO c
    FROM employees;
    -- 返回
    RETURN c;  -- 返回时用 `RETURN`
END $

SELECT myf1() $


-- 有参有返回
-- 根据员工名返回它的工资
CREATE FUNCTION myf2(empName VARCHAR(20)) RETURNS DOUBLE
BEGIN
    -- 定义用户变量
    SET @sal = 0;
    SELECT salary INTO @sal
    FROM employees
    WHERE last_name = empName;
    RETURN @sal;
END $

-- 使用前不需要 `CALL`
-- 有重名会报错
-- ! Result consisted of more than one row
-- SELECT myf2('k_ing') $
SELECT myf2('Kochhar') $


-- 根据部门名, 返回该部门的平均工资
CREATE FUNCTION myf3(dname VARCHAR(20)) RETURNS DOUBLE
BEGIN
    DECLARE avg_salary DOUBLE;
    SELECT AVG(e.salary) INTO avg_salary
    FROM employees e
    WHERE e.department_id = (
        SELECT d.department_id
        FROM departments d
        WHERE d.department_name = dname -- 'Adm'
    );
    RETURN avg_salary;
END $

SELECT myf3('Adm');

-- 
SHOW CREATE FUNCTION myf3;

-- 删除函数
DROP FUNCTION myf3;

-- 练习
-- 创建函数, 实现传入两个 float, 返回二者之和
CREATE FUNCTION myf4(f1 FLOAT, f2 FLOAT) RETURNS FLOAT
BEGIN
    DECLARE f3 FLOAT;
    SELECT f1 + f2 INTO f3;  -- SET f3 = f1 + f2;
    RETURN f3;
END $

SELECT myf4(1, 2);


-- 流程控制结构
-- CASE
-- 创建存储过程, 根据传入成绩显示等级, 如果成绩 90-100 返回 A, 如果成绩 80-90 返回 B, 如果成绩 60-80 返回 C, 否则返回 D
CREATE PROCEDURE test_case(IN score INT)
BEGIN
    CASE
    -- WHEN score >= 90 AND score <= 100 THEN SELECT 'A';
    WHEN score BETWEEN 90 AND 100 THEN SELECT 'A';
    WHEN score >= 80 THEN SELECT 'B';
    WHEN score >= 60 THEN SELECT 'C';
    ELSE SELECT 'D';
    END CASE;  -- ! 不要忘记
END $

CALL test_case(95) $
CALL test_case(83) $

-- IF 结构 (不是 IF 函数)
-- 创建函数, 实现传入成绩, 如果成绩 >90, 返回 A, 如果成绩 >80,返回 B, 如果成绩 >60, 返回 C, 否则返回 D
CREATE FUNCTION test_if(score FLOAT) RETURNS CHAR
BEGIN
    DECLARE ch CHAR DEFAULT 'A';
    IF score > 90 THEN SET ch = 'A';
    ELSEIF score > 80 THEN SET ch = 'B';
    ELSEIF score > 60 THEN SET ch = 'C';
    ELSE SET ch = 'D';
    END IF;
    RETURN ch;
END $

SELECT test_if(87) $

-- 循环控制
-- while
CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= insertCount DO
        INSERT INTO admin(username, `password`) VALUES(CONCAT('Rose', i), '666');
        SET i = i + 1;
    END WHILE;
END $

CALL pro_while1(100)$
SELECT * FROM admin;$


-- 添加 leave 语句
-- 批量插入, 根据次数插入到 admin 表中多条记录, 如果次数 >20 则停止
CREATE PROCEDURE test_while2(IN insertCount INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    a:WHILE i <= insertCount DO
        INSERT INTO admin(username, `password`) VALUES(CONCAT('xiaohua',i),'0000');
        IF i >= 20 THEN LEAVE a;
        END IF;
        SET i = i + 1;
    END WHILE a;
END $

CALL test_while2(30) $
SELECT * FROM admin; $


-- 添加 iterate 语句
-- 批量插入, 根据次数插入到 admin 表中多条记录, 只插入偶数次
CREATE PROCEDURE test_while3(IN insertCount INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    a:WHILE i <= insertCount DO
        SET i = i + 1;
        IF MOD(i, 2) != 0 THEN ITERATE a;
        END IF;
        INSERT INTO admin(username, `password`) VALUES(CONCAT('xiaohua', i), '0000');
    END WHILE a;
END $

CALL test_while3(10) $
SELECT * FROM admin; $


-- 已知表 stringcontent, 向该表插入指定个数的随机的字符串
-- 其中字段: id 自增长 ; content varchar(20)
CREATE TABLE stringcontent(
    id INT PRIMARY KEY AUTO_INCREMENT,
    content VARCHAR(20)
);

CREATE PROCEDURE test_randstr_insert(IN insertCount INT) 
BEGIN 
    DECLARE i INT DEFAULT 1;
    DECLARE `str` VARCHAR(26) DEFAULT 'abcdefghijklmnopqrstuvwxyz';
    DECLARE startIndex INT DEFAULT 1;  -- 代表初始索引
    DECLARE `len` INT DEFAULT 1;  -- 代表截取的字符长度
    WHILE i <= insertcount DO
        SET startIndex = FLOOR(RAND() * 26 + 1);  -- 代表初始索引, 随机范围 1 到 26
        SET `len` = FLOOR(RAND() * (20 - startIndex + 1) + 1);  -- 代表截取长度, 随机范围 1 到 (20 - startIndex + 1), 20 为限制长度 `content VARCHAR(20)`
        INSERT INTO stringcontent(content) VALUES(SUBSTR(`str`, startIndex, `len`));
        SET i = i + 1;
    END WHILE;
END $

CALL test_randstr_insert(10)$
SELECT * FROM stringcontent;
