-- 进阶五: 分组查询

-- 查询每个部门的平均工资
SELECT AVG(salary)
FROM employees;

-- 查询每个工种的最高工资
SELECT MAX(salary), job_id
FROM employees
GROUP BY job_id;

-- 每个位置上的部门个数
SELECT COUNT(*), location_id
FROM departments
GROUP BY location_id;

-- 添加筛选条件
-- 查询邮箱中包含 a 字符的每个部门的平均工资
SELECT AVG(salary), department_id, email
FROM employees
WHERE email LIKE "%a%"
GROUP BY department_id;

-- 查询有奖金的每个领导手下员工的最高工资
SELECT MAX(salary), manager_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY manager_id;

-- 添加复杂筛选条件
-- 查询哪个部门的员工个数 >2
SELECT COUNT(*), department_id
FROM employees
GROUP BY department_id
-- COUNT(*) 要根据上一步结果获得, 不能用 WHERE
HAVING COUNT(*) > 2;

-- 查询每个工种有奖金的员工的最高工资 >12000 的工种编号和最高工资
SELECT MAX(salary), job_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING MAX(salary) > 12000;

-- 查询领导编号 >102 的每个领导手下的最低工资 >5000 的领导编号
SELECT MIN(salary), manager_id
FROM employees
WHERE manager_id > 102
GROUP BY manager_id
HAVING MIN(salary) > 5000;

-- 按表达式或函数分组
-- 按员工姓名的长度分组, 查询每一组的员工个数, 筛选员工个数 >5 的
