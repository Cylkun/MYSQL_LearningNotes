# 进阶三: 排序查询

语法

```sql
SELECT 查询列表
FROM 表
[WHERE 筛选条件]
ORDER BY 排序列表 [ASC | DESC]  -- default: ASC
```

特点

1. ASC: 升序, DESC: 降序, 默认升序
2. ORDER BY 子句中可以支持单个字段, 多个字段, 表达式, 函数, 别名
3. ORDER BY 一般放在查询语句的最后面 (除了 LIMIT)


## 按单个字段排序

1. 查询员工信息, 要求工资从高到低

```sql
-- 查询员工信息, 要求工资从高到低
SELECT * FROM employees ORDER BY salary ASC;
```

2. 查询员工信息, 要求工资从低到高

```sql
-- 查询员工信息, 要求工资从低到高
SELECT * FROM employees ORDER BY salary;
SELECT * FROM employees ORDER BY salary DESC;
```

3. 查询部门编号大于等于90的员工信息, 按入职时间的先后排序

```sql
-- 查询部门编号大于等于90的员工信息, 按入职时间的先后排序
SELECT *
FROM employees
WHERE department_id >= 90
ORDER BY hiredate ASC;
```


## 按表达式排序

按年薪的高低显示员工的信息 (表达式排序)

```sql
-- 按年薪的高低显示员工的信息 (表达式排序)
SELECT *, salary * 12 * (1 + IFNULL(commission_pct, 0)) 年薪
FROM employees
ORDER BY salary * 12 * (1 + IFNULL(commission_pct, 0)) DESC;
```


## 按别名排序

按年薪的高低显示员工的信息 (别名排序)

```sql
-- 按年薪的高低显示员工的信息 (别名排序)
SELECT *, salary * 12 * (1 + IFNULL(commission_pct, 0)) 年薪
FROM employees
ORDER BY 年薪 DESC;
```


## 按函数排序

按姓名长度降序显示员工的姓和工资 (按函数排序)

```sql
-- 按姓名长度降序显示员工的姓和工资 (按函数排序)
SELECT
    LENGTH(last_name) 姓的长度,
    last_name,
    salary
FROM
    employees
ORDER BY
    姓的长度 DESC;
```


## 按多个字段排序

查询员工信息, 要求先按工资升序, 再按员工编号降序 (按多个字段排序)

```sql
-- 查询员工信息, 要求先按工资升序, 再按员工编号降序 (按多个字段排序)
SELECT *
FROM employees
ORDER BY salary ASC, employee_id DESC;
```

## 练习

查询员工的姓名和部门号和年薪, 按年薪降序, 按姓名升序

```sql
-- 查询员工的姓名和部门号和年薪, 按年薪降序, 按姓名升序
SELECT
  CONCAT(first_name, ' ', last_name) AS `name`,
  department_id,
  salary * 12 *(1 + IFNULL(commission_pct, 0)) AS salary_year
FROM
  employees
ORDER BY
  salary_year DESC,
  `name` ASC;
```

选择工资不在8000到17000的员工的姓名和工资, 按工资降序

```sql
-- 选择工资不在8000到17000的员工的姓名和工资, 按工资降序
SELECT
  CONCAT(first_name, ' ', last_name) AS `name`,
  salary
FROM
  employees
WHERE
  salary NOT BETWEEN 8000 AND 17000
ORDER BY
  salary DESC;
```

查询邮箱中包含e的员工信息, 并先按邮箱的字节数降序, 再按部门号升序

```sql
-- 查询邮箱中包含e的员工信息, 并先按邮箱的字节数降序, 再按部门号升序
SELECT
  *
FROM
  employees
WHERE
  email LIKE '%e%'
ORDER BY
  LENGTH(email) DESC,
  department_id ASC;
```
