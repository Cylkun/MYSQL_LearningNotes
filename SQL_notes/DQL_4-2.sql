-- 进阶4-2: 常见函数 (分组函数)
-- 简单使用
SELECT
  SUM(salary),
  AVG(salary),
  MAX(salary),
  MIN(salary),
  COUNT(salary)
FROM
  employees;

SELECT ROUND(AVG(salary), 2) FROM employees;

-- 参数支持哪些类型
-- 无意义
SELECT SUM(last_name), AVG(last_name) FROM employees;
SELECT SUM(hiredate), AVG(hiredate) FROM employees;
-- 可排序的值就行
SELECT MAX(last_name), MIN(last_name) FROM employees;
SELECT MAX(hiredate), MIN(hiredate) FROM employees;

SELECT COUNT(last_name) FROM employees;
-- 计算非空值的个数
SELECT COUNT(commission_pct) FROM employees;

-- 是否忽略空值
SELECT SUM(commission_pct), SUM(commission_pct)/107, SUM(commission_pct)/35, AVG(commission_pct) FROM employees;
SELECT MAX(commission_pct), MIN(commission_pct) FROM employees;
SELECT COUNT(commission_pct) FROM employees;

-- 和 DISTINCT 搭配
SELECT SUM(DISTINCT salary), SUM(salary) FROM employees;
SELECT AVG(DISTINCT salary), AVG(salary) FROM employees;
SELECT MAX(DISTINCT salary), MAX(salary) FROM employees;
SELECT MIN(DISTINCT salary), MIN(salary) FROM employees;
SELECT COUNT(DISTINCT salary), COUNT(salary) FROM employees;

-- COUNT 专题
-- 统计行数: 一行中只要有一行不为空值就 +1
SELECT COUNT(*) FROM employees;
-- 添加一列全 1, 统计 1 的个数 (常量就行)
SELECT COUNT(1) FROM employees;

-- 练习
-- 查询公司员工工资的最大值, 最小值, 平均值, 总和
SELECT MAX(salary), MIN(salary), AVG(salary), SUM(salary) FROM employees;

-- 查询员工表中的最大入职时间和最小入职时间的相差天数 (DIFFRENCE)
SELECT DATEDIFF(MAX(hiredate), MIN(hiredate)) AS `DIFFERENCE` FROM employees;

-- 查询部门编号为 90 的员工个数
SELECT COUNT(*) FROM employees WHERE department_id = 90;
