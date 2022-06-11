# DDL

库和表的管理操作

1. 库的管理: 创建, 修改, 删除
2. 表的管理: 创建, 修改, 删除

创建: create
修改: alter
删除: drop

### 库的管理

#### 库的创建

语法

```sql
CREATE DATABASE 库名;
```


```sql
-- 创建库 books
CREATE DATABASE books;
-- 存储在 C:\ProgramData\MySQL\MySQL Server 8.0\Data\books
--再次执行会报错 Can't create database 'books'; database exists

-- 增加容错性
CREATE DATABASE IF NOT EXISTS books;
```

#### 库的修改

```sql
-- 库的修改
-- 更改库的字符集 (默认 utf8)
ALTER DATABASE books CHARACTER SET gbk;
```

#### 库的删除

```sql
-- 库的删除
DROP DATABASE books;
-- 再次执行会报错 Can't drop database 'books'; database doesn't exist

DROP DATABASE IF EXISTS books;
```


### 表的管理

#### 表的创建

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


#### 表的修改

语法

```sql
ALTER TABLE <table_name> ADD|DROP|MODIFY|CHANGE COLUMN <column_name>[ 列类型 约束]
```

`CHANGE` 后的 `COLUMN` 可以省略



##### 修改列名

```sql
-- 修改列名
ALTER TABLE book CHANGE COLUMN publishdate pabDate DATETIME;
```

##### 修改列类型或约束

```sql
-- 修改列类型或约束
ALTER TABLE book MODIFY COLUMN pubDate TIMESTAMP;
```

##### 添加新列

```sql
-- 添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE;
```

##### 删除列

```sql
-- 删除列
ALTER TABLE author DROP annual;
```

##### 修改表名

```sql
-- 修改表名
ALTER TABLE author RENAME TO book_author;
```

#### 表的删除

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

## 通用写法

```sql
DROP DATABASE IF EXISTS 旧库名;
CREATE TABLE 新库名;

DROP TABLE IF EXISTS 旧表名;
CREATE TABLE 新表名(...);
```

## 表的复制

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

### 仅仅复制表的结构

```sql
-- 仅仅复制表的结构
CREATE TABLE author_copy_empty LIKE author;
-- SELECT * FROM author_copy_empty;
```

### 复制表的结构和数据

```sql
-- 复制表的结构和数据
CREATE TABLE author_copy SELECT * FROM author;
-- SELECT * FROM author_copy;
```

### 只复制部分数据

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

### 仅仅复制某些字段

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
