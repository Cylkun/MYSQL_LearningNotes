# DDL

库和表的管理操作

1. 库的管理: 创建, 修改, 删除
2. 表的管理: 创建, 修改, 删除

创建: create
修改: alter
删除: drop

## 通用写法

```sql
DROP DATABASE IF EXISTS 旧库名;
CREATE TABLE 新库名;

DROP TABLE IF EXISTS 旧表名;
CREATE TABLE 新表名(...);
```


## 库的管理

语法

```sql
CREATE DATABASE [IF NOT EXISTS] 库名 [CHARACTER SET 字符集名];
ALTER DATABASE 库名 CHARACTER SET 字符集名称;
DROP DATABASE [IF EXISTS] 库名
```

### 库的创建

```sql
-- 创建库 books
CREATE DATABASE books;
-- 存储在 C:\ProgramData\MySQL\MySQL Server 8.0\Data\books
--再次执行会报错 Can't create database 'books'; database exists

-- 增加容错性
CREATE DATABASE IF NOT EXISTS books;
```

### 库的修改

```sql
-- 库的修改
-- 更改库的字符集 (默认 utf8)
ALTER DATABASE books CHARACTER SET gbk;
```

### 库的删除

```sql
-- 库的删除
DROP DATABASE books;
-- 再次执行会报错 Can't drop database 'books'; database doesn't exist

DROP DATABASE IF EXISTS books;
```


## 表的管理

### 表的创建

```sql
CREATE TABLE 表名(
    列名 列的类型[(长度) 约束],
    列名 列的类型[(长度) 约束],
    ...
    列名 列的类型[(长度) 约束]
)
```



```sql
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
```



```sql
-- 创建表 author
CREATE TABLE author(
    id INT,
    au_name VARCHAR(20),
    nation VARCHAR(10)
);

DESC author;
```


### 表的修改

语法

```sql
ALTER TABLE <table_name> ADD|DROP|MODIFY|CHANGE COLUMN <column_name>[ 列类型 约束]
```

`CHANGE` 后的 `COLUMN` 可以省略



#### 修改列名

```sql
-- 修改列名
ALTER TABLE book CHANGE COLUMN publishdate pabDate DATETIME;
```

#### 修改列类型或约束

```sql
-- 修改列类型或约束
ALTER TABLE book MODIFY COLUMN pubDate TIMESTAMP;
```

#### 添加新列

```sql
ALTER TABLE 表名 ADD COLUMN 列名 类型 [FIRST|AFTER 字段名]
```

```sql
-- 添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE;
```

#### 删除列

```sql
-- 删除列
ALTER TABLE author DROP annual;
```

#### 修改表名

```sql
-- 修改表名
ALTER TABLE author RENAME TO book_author;
```

### 表的删除

```sql
-- 表的删除
DROP TABLE book_author;

SHOW TABLES;  -- 查看所有表

DROP TABLE IF EXISTS book_author;

-- 重新创建
-- CREATE TABLE author(
--     id INT,
--     au_name VARCHAR(20),
--     nation VARCHAR(10)
-- );
```


### 表的复制

```sql
-- 插入数据
INSERT INTO
    author
VALUES
    (1, '村上春树', '日本'),
    (2, '莫言', '中国'),
    (3, '冯唐', '中国'),
    (4, '金庸', '中国');
```

#### 仅仅复制表的结构

```sql
-- 仅仅复制表的结构
CREATE TABLE author_copy_empty LIKE author;
-- SELECT * FROM author_copy_empty;
```

#### 复制表的结构和数据

```sql
-- 复制表的结构和数据
CREATE TABLE author_copy SELECT * FROM author;
-- SELECT * FROM author_copy;
```

#### 只复制部分数据

```sql
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
```

#### 仅仅复制某些字段

```sql
-- 仅仅复制某些字段
CREATE TABLE author_copy_empty_part
SELECT id, au_name
FROM author
WHERE 0;
-- WHERE 1 = 2;  -- 设置不可能满足的条件
-- SELECT * FROM author_copy_empty_part;
```



## 练习

创建库 test

```sql
-- 创建库 test
CREATE DATABASE test;
USE test;
```


创建表 dept1

```
NAME    NULL?    TYPE
id               INT(7)
name             VARCHAR(25)
```


```sql
-- 创建表 dept1
CREATE TABLE dept1(
    id INT(7),
    `name` VARCHAR(25)
);
```

将表 departments 中的数据插入新表 dept2 中

```sql
-- * 将表 departments 中的数据插入新表 dept2 中
CREATE TABLE dept2
SELECT department_id, department_name
FROM myemployees.departments;  -- 跨库复制表结构
```


创建表 emp5

```
NAME          NULL?    TYPE
id                     INT(7)
First_name             VARCHAR (25)
Last_name              VARCHAR(25)
Dept_id                INT(7)
```

```sql
-- 创建表 emp5
CREATE TABLE emp5(
    id INT(7),
    First_name VARCHAR (25),
    Last_name VARCHAR(25),
    Dept_id INT(7)
);
```


将列 Last_name 的长度增加到 50

```sql
-- 将表 emp5 的列 Last_name 的长度增加到 50
ALTER TABLE emp5 MODIFY COLUMN Last_name VARCHAR(50);
```


根据表 employees 创建 employees2

```sql
-- 根据表 employees 的结构创建 employees2
CREATE TABLE employees2 LIKE myemployees.employees;
```


删除表 emp5

```sql
-- 删除表 emp5
DROP TABLE emp5;
DROP TABLE IF EXISTS emp5;
```


将表 employees2 重命名为 emp5

```sql
-- 将表 employees2 重命名为 emp5
ALTER TABLE employees2 RENAME TO emp5;
```

在表 dept 和 emp5 中添加新列 test_column, 并检查所做的操作

```sql
-- 在表 emp5 中添加新列 test_column INT, 并检查所做的操作
ALTER TABLE emp5 ADD COLUMN test_column INT;
DESC emp5;
```


直接删除表 emp5 中的列 dept_id

```sql
-- 直接删除表 emp5 中的列 dept_id
ALTER TABLE emp5 DROP COLUMN dept_id;
-- ! Can't DROP 'dept_id'; check that column/key exists

ALTER TABLE emp5 DROP COLUMN test_column;
```


## 常见的数据类型

- 数值型
	  - 整型
	- 小数
	    - 定点数
	    - 浮点数
- 字符型
      - 较短的文本
          - char
          - varchar
    - 较长的文本
          - text
          - blob (较长的二进制数据)
- 日期型

选取原则: 所选择的类型越简单越好, 能保存数值的类型越小越好



### 数值型: 整型

| 整数类型     | 字节 | 范围                                          |
| ------------ | ---- | --------------------------------------------- |
| tinyint(M)      | 1    | 有符号: -128 ~ 127<br />无符号: 0 ~ 255       |
| smallint(M)     | 2    | 有符号: -32768 ~ 32767<br />无符号: 0 ~ 65535 |
| mediumint(M)    | 3    |                                               |
| int, integer(M) | 4    |                                               |
| bigint(M)       | 5    |                                               |

特点

1. 默认有符号, 类型关键字后添加 `UNSIGNED` 设置无符号
2. 如果插入的数值超过整型的范围, 会报 `Out of range value` 异常, 不插入数值
3. 长度使用默认长度, 不可自定义, 但可以指定显示长度 `M` , 与 `ZEROFILL` 搭配可显示指定位数


```sql
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
```


```sql
INSERT INTO tab_int VALUES(-123456, -654321);
INSERT INTO tab_int VALUES(-123456, 944392384902384921);

-- 异常值未插入
SELECT * FROM tab_int;
```


```sql
DROP TABLE IF EXISTS tab_int_zerofill;
CREATE TABLE tab_int_zerofill(
    t1 INT(7) ZEROFILL,
    t2 INT(5) ZEROFILL UNSIGNED
);

INSERT INTO tab_int_zerofill VALUES (12, 123);
SELECT * FROM tab_int_zerofill;
```



### 数值型: 小数

小数: 浮点数类型, 定点数类型


| 浮点数类型     | 字节 | 范围 |
| ------------- | ---- | ---- |
| float(M, D)   | 4    |      |
| double(M, D)  | 8    |      |

| 定点数类型                    | 字节  | 范围                                                         |
| ---------------------------- | ----- | ------------------------------------------------------------ |
| DEC(M, D)<br />DECIMAL(M, D) | M + 2 | 最大范围与 `double` 相同, 给定 `decimal` 的有效取值范围由 M, C 决定 |

M: 整数部分和小数部分的位数
D: 小数点后的位数

特点:

1. M, D 都可省略, `FLOAT` 和 `DOUBLE` 默认不做限制, 会根据插入的数值的精读来决定精度, `DECIMAL` 默认为 (10, 0)
2. 定点型的精度较高, 如果插入数值的精度要求较高, 建议使用定点数类型 (货币运算等)

### 串数据 字符型

串数据: 文本型, 二进制

字符型:

- 较短的文本: char, varchar
- 较长的文本: text, blob (较大的二进制)

#### 较短的文本

| 字符串类型 | 含义           | 描述及存储需求 |
| ---------- | -------------- | -------------- |
| char(M)    | 固定长度的字符 | 0 ~ 255        |
| varchar(M) | 可变长度的字符 | 0 ~ 65535      |

M: 最大字符数
`char` 后 M 可以省略, 默认为 1, `varchar` 后 M 不可以省略

使用 `char` 效率更高

| 其他类型              | 含义         |
| --------------------- | ------------ |
| binary<br />varbinary | 较短的二进制 |
| enum                  | 枚举         |
| set                   | 集合         |



### 日期类型

| 日期时间类型 | 字节 | 最小值              | 最大值              |
| ------------ | ---- | ------------------- | ------------------- |
| date         | 4    | 1000-01-01          | 9999-12-31          |
| datetime     | 8    | 1000-01-01 00:00:00 | 9999-12-31 23:59:59 |
| timestamp    | 4    | 19700101 080001     | 2038 年的某个时刻   |
| time         | 3    | -838:59:59          | 838:59:59           |
| year         | 1    | 1901                | 2155                |

`timestamp` 和实际时区有关, 更能反应实际的日期, `datetime` 只能反映插入的当地时区



## 常见约束

含义: 用于限制表中的数据, 了保证表中的数据的一致性 (准确性和可靠性)

```sql
CREATE TABLE 表名(
    字段名 字段类型 列级约束,
    字段名 字段类型,
    ...
    表级约束
);
```

六大约束

- `NOTNULL`: 非空, 用于保证该字段的值不为空
- `DEFAULT`: 默认, 用于保证该字段有默认值
- `PRIMARY KEY`: 主键, 用于保证该字段的值具有唯一性, 并且非空
- `UNIQUE`: 唯一, 用于保证该字段的值具有唯一性, 可以为空
- `CHECK`: 检查 (MySQL 不支持)
- `FOREIGN KEY`: 外键, 限制两个表的关系, 用于保证该字段的值必须来自于主表的关联列的值. 在从表中添加外键约束, 用于引用主表中某些列的值. 

添加表的时机:

- 创建表时
- 修改表时 (在添加数据之前)

约束的添加分类:

- 列级约束: 六大约束语法上都支持, 但外键约束没有效果
- 表级约束: 除了非空和默认, 其他的都支持



### 列级约束

语法: 直接在字段名和类型后面追加 `约束类型` 即可, 只支持 `DEFAULT`, `NOT NULL`, `PRIMARY KEY`, `UNIQUE`


```sql
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
```


### 表级约束

语法

```sql
[CONSTRAINT 约束名 ]约束类型(字段名)
```

```sql
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
```

### 为约束列起别名

```sql
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
```

### 通用写法

```sql
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
```

### 组合

```sql
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
```

### 添加多个约束

```sql
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
```




### 主键, 唯一, 外键对比

|                    | 主键       | 唯一                          |
| ------------------ | ---------- | ----------------------------- |
| 保证唯一性         | ✔️          | ✔️                             |
| 是否允许为空       | ❌          | ✔️ (不允许同时出现两个 `NULL`) |
| 一个表中可以有多个 | ❌ (唯一)   | ✔️                             |
| 是否允许组合       | ✔️ (不推荐) | ✔️(不推荐)                     |

主键和唯一

1. 区别
	1. 一个表至多有一个主键, 但可以有多个唯一
	2. 主键不允许为空, 唯一键可以为空
2. 相同点
	1. 都具有唯一性
	2. 都支持组合键, 但不推荐

外键

1. 要求在从表中设置外键关系
2. 从表的外键列的类型和主表的关联列的类型要求一致或兼容, 名称无要求
3. 主表的关联列必须是一个 key (一般是主键或唯一)
4. 插入数据时, 先插入主表, 再插入从表
5. 删除数据时, 先删除从表, 再删除主表


### 修改表时添加约束

语法

```sql
-- 添加列级约束
ALTER TABLE 表名 MODIFY COLUMN 字段名 字段类型 新约束;

-- 添加表级约束
ALTER TABLE 表名 ADD[CONSTRAINT 约束名 ]约束类型(字段名);



-- 添加列级约束
ALTER TABLE <table_name> MODIFY COLUMN <column_name> <data_type> <constraint>;

-- 添加表级约束
ALTER TABLE <table_name> ADD[CONSTRAINT <constrain_name> ]<constraint>(<column_name>);
```


```sql
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
```



```sql
-- 添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NOT NULL;
DESC stuinfo;
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20);
DESC stuinfo;
```



```sql
-- 添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;
```



```sql
-- 添加主键
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;  -- 添加列级约束
ALTER TABLE stuinfo ADD PRIMARY KEY(id);  -- 添加表级约束
```



```sql
-- 添加唯一
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;
ALTER TABLE stuinfo ADD UNIQUE(seat);
```



```sql
-- 添加外键
ALTER TABLE stuinfo ADD FOREIGN KEY(majorid) REFERENCES major(id);
ALTER TABLE stuinfo ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id);
```


### 修改表时删除约束

```sql
-- 删除非空约束
-- 方法一
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NULL;
-- 方法二
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20);
DESC stuinfo;
```



```sql
-- 删除默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT;
DESC stuinfo;
```



```sql
-- 删除主键
ALTER TABLE stuinfo DROP PRIMARY KEY;
-- ! 无法删除
-- ALTER TABLE stuinfo MODIFY COLUMN id INT;
DESC stuinfo;
```



```sql
-- 删除唯一
ALTER TABLE stuinfo DROP INDEX seat;
-- ! 无法删掉 `UNIQUE`
-- ALTER TABLE stuinfo MODIFY COLUMN seat INT;
DESC stuinfo;
SHOW INDEX FROM stuinfo;  -- 也可以查到
```



```sql
-- 删除外键
-- mysql 支持分步删除: 1. 删除外键; 2. 删除索引
ALTER TABLE stuinfo DROP FOREIGN KEY fk_stuinfo_major;
ALTER TABLE stuinfo DROP INDEX fk_stuinfo_major;
SHOW INDEX FROM stuinfo;
```

### 删除含有外键的主表数据

```sql
-- 插入数据
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
```

级联删除: 删除主表数据的同时直接删除从表中对应行

```sql
-- 级联删除: 删除主表数据的同时直接删除从表中对应行
ALTER TABLE stuinfo ADD CONSTRAINT fk_stu_major FOREIGN KEY(majorid) REFERENCES major(id) ON DELETE CASCADE;
DELETE FROM major WHERE id=3;
```

级联置空: 删除主表数据的同时修改从表中对应行的值为空

```sql
-- 级联置空: 删除主表数据的同时修改从表中对应行的值为空
ALTER TABLE stuinfo ADD CONSTRAINT fk_stu_major FOREIGN KEY(majorid) REFERENCES major(id) ON DELETE SET NULL;
DELETE FROM major WHERE id=3;
```



### 练习

向表 emp2 的 id 列中添加 PRIMARY KEY 约束 (my_emp_id_pk)

```sql
-- 向表 emp2 的 id 列中添加 PRIMARY KEY 约束 (my_emp_id_pk)
ALTER TABLE emp2 ADD CONSTRAINT my_emp_id_pk PRIMARY KEY(id);
ALTER TABLE emp2 MODIFY COLUMN id INT PRIMARY;
```

向表 dept2 的 id 列中添加 PRIMARY KEY 约束 (my_dept_id_pk)

```sql
-- 向表 dept2 的 id 列中添加 PRIMARY KEY 约束 (my_dept_id_pk)
ALTER TABLE dept2 ADD CONSTRAINT my_dept_id_pk PRIMARY KEY(id);
ALTER TABLE dept2 MODIFY COLUMN id INT PRIMARY;
```



向表 emp2 中添加列 dept_id, 并在其中定义 FOREIGN KEY 约束, 与之相关联的列是 dept2 表中的 id 列

```sql
-- 向表 emp2 中添加列 dept_id, 并在其中定义 FOREIGN KEY 约束, 与之相关联的列是 dept2 表中的 id 列
ALTER TABLE emp2 ADD COLUMN dept_id INT;
ALTER TABLE emp2 ADD CONSTRAINT fk_emp2_dept2 FOREIGN KEY(dept_id) REFERENCES dept2(id);
-- ! 有错
ALTER TABLE emp2 ADD COLUMN dept_id INT REFERENCES dept2(id);
```



|          | 位置         | 支持的约束类型             | 是否可以起约束名    |
| -------- | ------------ | -------------------------- | ------------------- |
| 列级约束 | 列的后面     | 语法都支持, 但外键没有效果 | 不可以              |
| 表级约束 | 所有列的下面 | 默认和非空不支持, 其他支持 | 可以 (主键没有效果) |



## 标识列/自增长列

标识列: 可以不用手动插入值, 系统提供默认的序列子

```sql
-- 标识列
CREATE TABLE tab_identity(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20)
);
DROP TABLE IF EXISTS tab_identity;

-- 重复插入
INSERT INTO tab_identity VALUES(NULL, 'john');
INSERT INTO tab_identity(name) VALUES('lucy');
SELECT * FROM tab_identity;
```

修改起始值和步长

```sql
-- 修改起始值和步长
SHOW VARIABLES LIKE '%auto_increment%';
-- mysql 不支持设置起始值, 支持设置步长
SET auto_increment_increment=3;
SET auto_increment_increment=1;

-- 更改起始值
INSERT INTO tab_identity VALUES(10, 'john');
-- * 之后的插入从 11 开始
```

标识列是否必须是主键

```sql
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
```

标识列是否唯一

```sql
-- 标识列是否唯一
CREATE TABLE tab_identity(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    seat INT UNIQUE AUTO_INCREMENT
);
-- ! Incorrect table definition; there can be only one auto column and it must be defined as a key
DROP TABLE IF EXISTS tab_identity;
```

自增长列是否只能是 INT

```sql
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
```



特点:

1. 标识列必须是 `key`, 但不一定是主键, 可以是其他键
2. 一个表中只能有一个标识列
3. 标识列的类型只能是数值型
4. 标识列可以设置步长, 也可以通过手动插入值来设置起始值



修改表时设置标识列

```sql
-- 修改表时设置标识列
CREATE TABLE tab_identity(
    id INT PRIMARY KEY,
    name VARCHAR(20)
);
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;
```


