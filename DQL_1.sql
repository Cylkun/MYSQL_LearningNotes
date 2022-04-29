-- 进阶1: 基础查询

USE myemployees;

-- 查询表中的单个字段
SELECT last_name FROM employees;

-- 查询表中的多个字段 (可以自定义顺序)
SELECT last_name, salary, email FROM employees;

-- 查询表中的所有字段
SELECT * FROM employees;

-- 查询常量值
SELECT 100;
SELECT 'john';

-- 查询表达式
SELECT 100 * 98;

-- 查询函数
SELECT VERSION();

-- 起别名
SELECT 100 * 98 AS 结果;
SELECT last_name AS 姓, first_name AS 名 FROM employees;
SELECT last_name 姓, first_name 名 FROM employees;
SELECT last_name AS 'out put' FROM employees;

-- 去重
SELECT department_id FROM employees;
SELECT DISTINCT department_id FROM employees;

SELECT 100+90;
SELECT '123' + 90;
SELECT null + 90;

-- 拼接
SELECT CONCAT(last_name, ' ', first_name) AS 姓名 FROM employees;

-- 处理 NULL
SELECT commission_pct, IFNULL(commission_pct, 0) FROM employees;

