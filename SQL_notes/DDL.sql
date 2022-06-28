-- DDL
-- 库的管理
-- 库的创建
-- 创建库 books
CREATE DATABASE books;
-- 存储在 C:\ProgramData\MySQL\MySQL Server 8.0\Data\books
--再次执行会报错 Can't create database 'books'; database exists

-- 增加容错性
CREATE DATABASE IF NOT EXISTS books;

-- 库的修改
-- 更改库的字符集 (默认 utf8)
ALTER DATABASE books CHARACTER SET gbk;

-- 库的删除
DROP DATABASE books;
-- 再次执行会报错 Can't drop database 'books'; database doesn't exist

DROP DATABASE IF EXISTS books;


-- 表的管理
-- 表的创建

-- 创建表 book
CREATE TABLE book(
    id INT,  -- 编号
    bName VARCHAR(20),  -- 图书名
    price DOUBLE,  -- 价格
    authorId INT,  -- 作者编号
    -- 相比 `author VARCHAR(20),  -- 作者` 可以减少冗余
    publishDate DATETIME  -- 出版日期
);

DESC book;

-- 创建表 author
CREATE TABLE author(
    id INT,
    au_name VARCHAR(20),
    nation VARCHAR(10)
);

DESC author;

-- 表的修改
-- 修改列名
ALTER TABLE book CHANGE COLUMN publishdate pabDate DATETIME;

-- 修改列类型或约束
ALTER TABLE book MODIFY COLUMN pubDate TIMESTAMP;

-- 添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE;

-- 删除列
ALTER TABLE author DROP annual;

-- 修改表名
ALTER TABLE author RENAME TO book_author;


-- 表的删除
DROP TABLE book_author;

SHOW TABLES;  -- 查看所有表

DROP TABLE IF EXISTS book_author;

CREATE TABLE author(
    id INT,
    au_name VARCHAR(20),
    nation VARCHAR(10)
);



-- 表的复制
INSERT INTO
    author
VALUES
    (1, '村上春树', '日本'),
    (2, '莫言', '中国'),
    (3, '冯唐', '中国'),
    (4, '金庸', '中国');


-- 仅仅复制表的结构
CREATE TABLE author_copy_empty LIKE author;
-- SELECT * FROM author_copy_empty;

-- 复制表的结构和数据
CREATE TABLE author_copy SELECT * FROM author;
-- SELECT * FROM author_copy;

-- 只复制部分数据
CREATE TABLE author_copy_part
SELECT
    id,
    au_name
FROM
    author
WHERE
    nation = '中国';
-- SELECT * FROM author_copy_part;


-- 仅仅复制某些字段
CREATE TABLE author_copy_empty_part
SELECT id, au_name
FROM author
WHERE 0;
-- WHERE 1 = 2;  -- 设置不可能满足的条件
-- SELECT * FROM author_copy_empty_part;


-- 练习
-- 创建库 test
CREATE DATABASE test;
USE test;

-- 创建表 dept1
-- NAME    NULL?    TYPE
-- id               INT(7)
-- name             VARCHAR(25)
CREATE TABLE dept1(
    id INT(7),
    `name` VARCHAR(25)
);

-- * 将表 departments 中的数据插入新表 dept2 中
CREATE TABLE dept2
SELECT department_id, department_name
FROM myemployees.departments;  -- 跨库复制表结构

-- 创建表 emp5
-- NAME          NULL?    TYPE
-- id                     INT(7)
-- First_name             VARCHAR (25)
-- Last_name              VARCHAR(25)
-- Dept_id                INT(7)
CREATE TABLE emp5(
    id INT(7),
    First_name VARCHAR (25),
    Last_name VARCHAR(25),
    Dept_id INT(7)
);


-- 将表 emp5 的列 Last_name 的长度增加到 50
ALTER TABLE emp5 MODIFY COLUMN Last_name VARCHAR(50);

-- 根据表 employees 的结构创建 employees2
CREATE TABLE employees2 LIKE myemployees.employees;

-- 删除表 emp5
DROP TABLE emp5;
DROP TABLE IF EXISTS emp5;

-- 将表 employees2 重命名为 emp5
ALTER TABLE employees2 RENAME TO emp5;

-- 在表 emp5 中添加新列 test_column INT, 并检查所做的操作
ALTER TABLE emp5 ADD COLUMN test_column INT;
DESC emp5;

-- 直接删除表 emp5 中的列 dept_id
ALTER TABLE emp5 DROP COLUMN dept_id;
-- ! Can't DROP 'dept_id'; check that column/key exists
ALTER TABLE emp5 DROP COLUMN test_column;



-- 数值类型
-- 设置有符号和无符号
DROP TABLE IF EXISTS tab_int;
CREATE TABLE tab_int(
    t1 INT,
    t2 INT UNSIGNED
);

DESC tab_int;

-- 默认有符号
INSERT INTO tab_int VALUES(-123456, 654321);

-- ! Out of range value for column 'T2' at row 1
INSERT INTO tab_int VALUES(-123456, -654321);
INSERT INTO tab_int VALUES(-123456, 944392384902384921);

-- 异常值未插入
SELECT * FROM tab_int;



DROP TABLE IF EXISTS tab_int_zerofill;
CREATE TABLE tab_int_zerofill(
    t1 INT(7) ZEROFILL,
    t2 INT(5) ZEROFILL UNSIGNED
);

INSERT INTO tab_int_zerofill VALUES (12, 123);
SELECT * FROM tab_int_zerofill;


-- 小数
CREATE TABLE tab_float(
    f1 FLOAT(5, 2),
    f2 DOUBLE(5, 2),
    F3 DECIMAL(5, 2)
);
DESC tab_float;

INSERT INTO tab_float VALUES (123.4, 123.45, 123.456);  -- 123.456 四舍五入为 123.46
SELECT * FROM tab_float_default;

-- ! Out of range value for column 'f1' at row 1
INSERT INTO tab_float VALUES (1234.5, 1234.56, 1234.567);  -- 123.456 四舍五入为 123.46
SELECT * FROM tab_float_default;

-- 查看默认值
CREATE TABLE tab_float_default(
    f1 FLOAT,
    f2 DOUBLE,
    F3 DECIMAL
);
DESC tab_float_default;

INSERT INTO tab_float_default VALUES (123.4, 123.45, 123.456);  -- 123.456 四舍五入为 123.46
SELECT * FROM tab_float_default;

-- 字符型
CREATE TABLE tab_char(
    c1 ENUM('a', 'b', 'c')  -- ENUM: 枚举类型
);
DESC tab_char;

INSERT INTO tab_char VALUES('a');
INSERT INTO tab_char VALUES('A');  -- 显示为 a
INSERT INTO tab_char VALUES('d');
-- ! Data truncated for column 'c1' at row 1

SELECT * FROM tab_char;

-- set 集合
CREATE TABLE tab_set(
    s1 SET('a', 'b', 'c', 'd')
);
DESC tab_set;

INSERT INTO tab_set VALUES('a');
INSERT INTO tab_set VALUES('a', 'd', 'c');
-- ! Column count doesn't match value count at row 1
INSERT INTO tab_set VALUES('a,D,c');  -- 显示为 a,c,d
-- 'a,d,c' 不能写成 'a, d, c', 否则报错 "Data truncated for column 's1' at row 1"
SELECT * FROM tab_set;


-- 日期型
CREATE TABLE tab_date(
    t1 DATETIME,
    t2 TIMESTAMP
);
DESC tab_date;

INSERT INTO tab_date VALUES(NOW(), NOW());
SELECT * FROM tab_date;
-- 显示变量
SHOW VARIABLES LIKE 'time_zone';

-- 修改时区
SET time_zone = '+9:00';
-- datetime 为当前系统时间, timestamp 为指定时区时间
INSERT INTO tab_date VALUES(NOW(), NOW());
SELECT * FROM tab_date;


-- 常见约束
-- 列级约束
CREATE TABLE major(
    id INT PRIMARY KEY,
    majorName VARCHAR(20)
);

CREATE TABLE stuinfo(
    id INT PRIMARY KEY,  -- 主键
    stuName VARCHAR(20) NOT NULL,  -- 非空
    gender CHAR(1) CHECK(gender='男' OR gender='女'),  -- 检查, mysql 不支持
    seat INT UNIQUE,  -- 唯一
    age INT DEFAULT 18, -- 默认
    majorId INT REFERENCES major(id)  -- 外键, mysql 不支持
);
DESC stuinfo;
-- 查看表的索引
SHOW INDEX FROM stuinfo;
DROP TABLE IF EXISTS stuinfo;

-- 表级约束
CREATE TABLE stuinfo(
    id INT,
    stuname VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorid INT,

    PRIMARY KEY(id), -- 主键, 显示 `PRIMARY` 不支持改名
    UNIQUE(seat), -- 唯一键
    CHECK(gender='男' OR gender='女'),  -- 检查
    FOREIGN KEY(majorId) REFERENCES major(id)  -- 外键
    -- * `NOT NULL` 和 `DEFAULT` 不支持
);
SHOW INDEX FROM stuinfo;
DROP TABLE IF EXISTS stuinfo;

-- 为约束列起别名
CREATE TABLE stuinfo(
    id INT,
    stuname VARCHAR(20),
    gender CHAR(1),
    seat INT,
    age INT,
    majorid INT,

    CONSTRAINT pk PRIMARY KEY(id), -- 主键, 显示 `PRIMARY` 不支持改名
    CONSTRAINT uq UNIQUE(seat), -- 唯一键
    CONSTRAINT ck CHECK(gender='男' OR gender='女'),  -- 检查
    CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id)  -- 外键
    -- * `NOT NULL` 和 `DEFAULT` 不支持
);
SHOW INDEX FROM stuinfo;
DROP TABLE IF EXISTS stuinfo;

-- 通用写法
CREATE TABLE IF NOT EXISTS stuinfo(
    id INT PRIMARY KEY,  -- 主键
    stuname VARCHAR(20) NOT NULL,  -- 非空
    gender CHAR(1),
    age INT DEFAULT 18,  -- 默认值
    seat INT UNIQUE,  -- 唯一
    majorid INT,
    -- 外键命名方式 fk_<从表(当前表)>_<主表(相关表)>
    CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)  -- 外键
);
SHOW INDEX FROM stuinfo;
DROP TABLE IF EXISTS stuinfo;

-- 组合
CREATE TABLE IF NOT EXISTS stuinfo(
    id INT,
    stuname VARCHAR(20),
    gender CHAR(1),
    age INT DEFAULT 18,  -- 默认值
    seat INT UNIQUE,  -- 唯一
    majorid INT,

    PRIMARY KEY(id, stuname),  -- 主键的组合
    UNIQUE(seat, majorid)  -- 唯一的组合
);
SHOW INDEX FROM stuinfo;
DROP TABLE IF EXISTS stuinfo;

-- 添加多个约束
CREATE TABLE IF NOT EXISTS stuinfo(
    id INT PRIMARY KEY,
    stuname VARCHAR(20),
    gender CHAR(1),
    age INT NOT NULL DEFAULT 18,  -- 直接加, 没有顺序要求
    seat INT UNIQUE,
    majorid INT
);
SHOW INDEX FROM stuinfo;
DROP TABLE IF EXISTS stuinfo;

-- 修改表时添加约束
CREATE TABLE IF NOT EXISTS stuinfo(
    id INT,
    stuname VARCHAR(20),
    gender CHAR(1),
    age INT,
    seat INT,
    majorid INT
);
DROP TABLE IF EXISTS stuinfo;

-- 添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NOT NULL;
DESC stuinfo;

-- 添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;
DESC stuinfo;

-- 添加主键
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;  -- 添加列级约束
DESC stuinfo;
ALTER TABLE stuinfo ADD PRIMARY KEY(id);  -- 添加表级约束

-- 添加唯一
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;
DESC stuinfo;
ALTER TABLE stuinfo ADD UNIQUE(seat);

-- 添加外键
ALTER TABLE stuinfo ADD FOREIGN KEY(majorid) REFERENCES major(id);
ALTER TABLE stuinfo ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id);

-- 修改表时删除约束
-- 删除非空约束
-- 方法一
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NULL;
-- 方法二
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20);
DESC stuinfo;

-- 删除默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT;
DESC stuinfo;

-- 删除主键
ALTER TABLE stuinfo DROP PRIMARY KEY;
-- ! 无法删除
-- ALTER TABLE stuinfo MODIFY COLUMN id INT;
DESC stuinfo;

-- 删除唯一
ALTER TABLE stuinfo DROP INDEX seat;
-- ! 无法删掉 `UNIQUE`
-- ALTER TABLE stuinfo MODIFY COLUMN seat INT;
DESC stuinfo;
SHOW INDEX FROM stuinfo;  -- 也可以查到

-- 删除外键
-- mysql 支持分步删除: 1. 删除外键; 2. 删除索引
ALTER TABLE stuinfo DROP FOREIGN KEY fk_stuinfo_major;
ALTER TABLE stuinfo DROP INDEX fk_stuinfo_major;
SHOW INDEX FROM stuinfo;


-- 外键专题
INSERT INTO major
VALUES(1, 'java'), (2, 'h5'), (3, '大数据');
INSERT INTO stuinfo
SELECT 1, 'john1', '女', NULL, NULL, 1 UNION ALL
SELECT 2, 'john2', '女', NULL, NULL, 1 UNION ALL
SELECT 3, 'john3', '女', NULL, NULL, 2 UNION ALL
SELECT 4, 'john4', '女', NULL, NULL, 2 UNION ALL
SELECT 5, 'john5', '女', NULL, NULL, 1 UNION ALL
SELECT 6, 'john6', '女', NULL, NULL, 3 UNION ALL
SELECT 7, 'john7', '女', NULL, NULL, 3 UNION ALL
SELECT 8, 'john8', '女', NULL, NULL, 1;

-- 删除含有外键的主表数据
-- 级联删除: 删除主表数据的同时直接删除从表中对应行
ALTER TABLE stuinfo ADD CONSTRAINT fk_stu_major FOREIGN KEY(majorid) REFERENCES major(id) ON DELETE CASCADE;
DELETE FROM major WHERE id=3;

-- 级联置空: 删除主表数据的同时修改从表中对应行的值为空
ALTER TABLE stuinfo ADD CONSTRAINT fk_stu_major FOREIGN KEY(majorid) REFERENCES major(id) ON DELETE SET NULL;
DELETE FROM major WHERE id=3;




-- 练习
-- 向表 emp2 的 id 列中添加 PRIMARY KEY 约束 (my_emp_id_pk)
ALTER TABLE emp2 ADD CONSTRAINT my_emp_id_pk PRIMARY KEY(id);
ALTER TABLE emp2 MODIFY COLUMN id INT PRIMARY KEY;

-- 向表 dept2 的 id 列中添加 PRIMARY KEY 约束 (my_dept_id_pk)
ALTER TABLE dept2 ADD CONSTRAINT my_dept_id_pk PRIMARY KEY(id);
ALTER TABLE dept2 MODIFY COLUMN id INT PRIMARY KEY;

-- 向表 emp2 中添加列 dept_id, 并在其中定义 FOREIGN KEY 约束, 与之相关联的列是 dept2 表中的 id 列
ALTER TABLE emp2 ADD COLUMN dept_id INT;
ALTER TABLE emp2 ADD CONSTRAINT fk_emp2_dept2 FOREIGN KEY(dept_id) REFERENCES dept2(id);
-- ! 有错
-- ALTER TABLE emp2 ADD COLUMN dept_id INT REFERENCES dept2(id);


-- 标识列
CREATE TABLE tab_identity(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
);
DROP TABLE IF EXISTS tab_identity;
TRUNCATE TABLE tab_identity;
DELETE FROM tab_identity;

-- 重复插入
INSERT INTO tab_identity VALUES(NULL, 'john');
INSERT INTO tab_identity(name) VALUES('lucy');
SELECT * FROM tab_identity;

-- 修改起始值和步长
SHOW VARIABLES LIKE '%auto_increment%';
-- mysql 不支持设置起始值, 支持设置步长
SET auto_increment_increment=3;
SET auto_increment_increment=1;

-- 更改起始值
INSERT INTO tab_identity VALUES(10, 'john');
-- * 之后的插入从 11 开始


-- 标识列是否必须是主键
CREATE TABLE tab_identity(
    id INT PRIMARY KEY,
    name VARCHAR(20),
    seat INT AUTO_INCREMENT
);
-- ! Incorrect table definition; there can be only one auto column and it must be defined as a key

CREATE TABLE tab_identity(
    id INT PRIMARY KEY,
    name VARCHAR(20),
    seat INT UNIQUE AUTO_INCREMENT
);
DROP TABLE IF EXISTS tab_identity;



-- 标识列是否唯一
CREATE TABLE tab_identity(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    seat INT UNIQUE AUTO_INCREMENT
);
-- ! Incorrect table definition; there can be only one auto column and it must be defined as a key
DROP TABLE IF EXISTS tab_identity;

-- 自增长列是否只能是 INT
CREATE TABLE tab_identity(
    id INT PRIMARY KEY,
    name VARCHAR(20) UNIQUE AUTO_INCREMENT
);
-- ! Incorrect column specifier for column 'name'

CREATE TABLE tab_identity(
    id FLOAT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20)
);
INSERT INTO tab_identity(name) VALUES('john');
SELECT * FROM tab_identity;
DROP TABLE IF EXISTS tab_identity;


-- 修改表时设置标识列
CREATE TABLE tab_identity(
    id INT PRIMARY KEY,
    name VARCHAR(20)
);
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;

-- 修改表时删除标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY;
-- ! Multiple primary key defined
ALTER TABLE tab_identity MODIFY COLUMN id INT;
-- * 虽然没有标识 `PRIMARY KEY`, 但仍然是主键
DESC tab_identity;

ALTER TABLE tab_identity DROP PRIMARY KEY;

SHOW INDEX FROM tab_identity;


