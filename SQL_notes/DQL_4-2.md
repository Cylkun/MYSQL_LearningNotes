# 进阶四-2: 常见函数 (多行函数)

分类:

1. SUM: 求和
2. AVG: 平均值
3. MAX: 最大值
4. MIN: 最小值
5. COUNT: 计算个数

特点:

1. SUM, AVG 一般处理数值型; MAX, MIN, COUNT 可以处理任何类型
2. 全部忽略空值
3. 可以和 `DISTINCT` 搭配去重
4. 和分组函数一同查询的字段时, 只能在 `GROUP BY` 后使用

## 简单使用

```sql
-- 简单使用
SELECT
  SUM(salary),
  AVG(salary),
  MAX(salary),
  MIN(salary),
  COUNT(salary)
FROM
  employees;

-- 保留两位小数
SELECT ROUND(AVG(salary), 2) FROM employees;
```

## 参数支持哪些类型

```sql
-- 不报错但无意义
SELECT SUM(last_name), AVG(last_name) FROM employees;
SELECT SUM(hiredate), AVG(hiredate) FROM employees;
-- 可排序的值就行
SELECT MAX(last_name), MIN(last_name) FROM employees;
SELECT MAX(hiredate), MIN(hiredate) FROM employees;

SELECT COUNT(last_name) FROM employees;
-- 计算非空值的个数
SELECT COUNT(commission_pct) FROM employees;
```

## 是否忽略空值

```sql
-- 是否忽略空值
SELECT SUM(commission_pct), SUM(commission_pct)/107, SUM(commission_pct)/35, AVG(commission_pct) FROM employees;
SELECT MAX(commission_pct), MIN(commission_pct) FROM employees;
SELECT COUNT(commission_pct) FROM employees;
```

## 和 `DISTINCT` 搭配

```sql
-- 和 DISTINCT 搭配
SELECT SUM(DISTINCT salary), SUM(salary) FROM employees;
SELECT AVG(DISTINCT salary), AVG(salary) FROM employees;
SELECT MAX(DISTINCT salary), MAX(salary) FROM employees;
SELECT MIN(DISTINCT salary), MIN(salary) FROM employees;
SELECT COUNT(DISTINCT salary), COUNT(salary) FROM employees;
```

## COUNT 专题

MYISAM 存储引擎下, `COUNT(*)`  效率高
INNODB 存储引擎下, `COUNT(*)` 和 `COUNT(1)` 效率差不多, 都比 `COUNT(字段)` 效率高

一般使用 `COUNT(*)` 作统计行数

```sql
-- 统计行数: 一行中只要有一行不为空值就 +1
SELECT COUNT(*) FROM employees;
-- 添加一列全 1, 统计 1 的个数 (常量就行)
SELECT COUNT(1) FROM employees;
```

## 练习

查询公司员工工资的最大值, 最小值, 平均值, 总和

```sql
-- 查询公司员工工资的最大值, 最小值, 平均值, 总和
SELECT MAX(salary), MIN(salary), AVG(salary), SUM(salary) FROM employees;
```

查询员工表中的最大入职时间和最小入职时间的相差天数 (DIFFRENCE)

```sql
-- 查询员工表中的最大入职时间和最小入职时间的相差天数 (DIFFRENCE)
SELECT DATEDIFF(MAX(hiredate), MIN(hiredate)) AS `DIFFERENCE`
FROM employees;
```

查询部门编号为 90 的员工个数

```sql
-- 查询部门编号为 90 的员工个数
SELECT COUNT(*) FROM employees WHERE department_id = 90;
```

