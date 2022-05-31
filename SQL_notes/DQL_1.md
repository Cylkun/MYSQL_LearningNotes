# 进阶一: 基础查询

语法
```sql
SELECT 查询列表 FROM 表名;
```

特点:
1. 查询列表可以是: 表中的字段, 常量值, 表达式, 函数
2. 查询的结果是一个虚拟的表格

## 查询字段

```sql
USE myemployees;  # 可以不加, 建议加

-- 查询表中的单个字段
SELECT last_name FROM employees;

-- 查询表中的多个字段 (可以自定义顺序)
SELECT last_name, salary, email FROM employees;

-- 查询表中的所有字段
SELECT * FROM employees;
```

说明:
以下句子等价, 可以不加 \` , 加上之后可以避免歧义

```sql
-- employees 中有一列名为 'name'
SELECT name FROM employees;
SELECT NAME FROM employees;
SELECT `name` FROM employees;
```

## 查询常量和函数

```sql
-- 查询常量值
SELECT 100;
SELECT 'john';

-- 查询表达式
SELECT 100 * 98;

-- 查询函数
SELECT VERSION();
```

## 起别名

```sql
-- 起别名
SELECT 100 * 98 AS 结果;
SELECT last_name AS 姓, first_name AS 名 FROM employees;
```

好处:
1. 便于理解
2. 要查询的字段中存在重名, 可以进行区分

说明:
AS 可以省略, 用空格替代

```sql
SELECT last_name 姓, first_name 名 FROM employees;
```

特殊情况:
别名中存在空格或特殊符号, 应使用单引号或者双引号

```sql
SELECT last_name AS 'out put' FROM employees;
```

## 去重

```sql
-- 去重
SELECT department_id FROM employees;
SELECT DISTINCT department_id FROM employees;
```

## 拼接

Java 中的 + 号:
1. 运算符: 两个操作数都是数值型
2. 连接符: 只要有一个操作数为字符串

SQL 中的 + 号:
只能做运算符
1. 两个操作数都为数值型, 则做加法运算 `SELECT 100 + 90;`
2. 其中有一方是字符型数据, 试图将字符型数值转换成数值型. 
   1. 如果转换成功, 则继续做加法运算 `SELECT '123' + 90;`
   2. 否则, 将字符型数值转换成0 `'John' +  90`
3. 只要其中一方为 null, 则结果为 null `SELECT null + 90;`

```sql
-- 拼接
SELECT CONCAT(last_name, ' ', first_name) AS 姓名 FROM employees;
```


## 处理 NULL

```sql
-- 处理 NULL
SELECT commission_pct, IFNULL(commission_pct, 0) FROM employees;
```

## ISNULL

```sql
SELECT ISNULL(commission_pct), commission_pct FROM employees;
```
