-- 进阶3: 排序查询
-- 查询员工信息, 要求工资从高到低
SELECT
  *
FROM
  employees
ORDER BY
  salary ASC;
SELECT
  *
FROM
  employees
ORDER BY
  salary;
SELECT
  *
FROM
  employees
ORDER BY
  salary DESC;
-- 查询部门编号大于等于90的员工信息, 按入职时间的先后排序
SELECT
  *,
FROM
  employees
WHERE
  department_id >= 90
ORDER BY
  hiredate ASC;
-- 按年薪的高低显示员工的信息 (表达式排序)
SELECT
  *,
  salary * 12 * (1 + IFNULL(commission_pct, 0)) 年 薪
FROM
  employees
ORDER BY
  salary * 12 * (1 + IFNULL(commission_pct, 0)) DESC;
-- 按年薪的高低显示员工的信息 (别名排序)
SELECT
  *,
  salary * 12 * (1 + IFNULL(commission_pct, 0)) 年 薪
FROM
  employees
ORDER BY
  年 薪 DESC;
-- 按姓名长度降序显示员工的姓和工资 (按函数排序)
SELECT
  LENGTH(last_name) 姓 的 长 度,
  last_name,
  salary
FROM
  employees
ORDER BY
  姓 的 长 度 DESC;
-- 查询员工信息, 要求先按工资升序, 再按员工编号降序 (按多个字段排序)
SELECT
  *
FROM
  employees
ORDER BY
  salary ASC,
  employee_id DESC;

-- 练习
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

-- 选择工资不在8000到17000的员工的姓名和工资, 按工资降序
SELECT
  CONCAT(first_name, ' ', last_name) AS `name`,
  salary
FROM
  employees
WHERE
  salary NOT BETWEEN 8000
  AND 17000
ORDER BY
  salary DESC;

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
