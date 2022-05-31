-- 进阶5: 分组查询

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
-- 按员工姓的长度分组, 查询每一组的员工个数, 筛选员工个数 >5 的
-- MYSQL 支持 GROUP BY 和 HAVING 后使用别名, 别的不一定支持
SELECT
    COUNT(*) AS num,
    LENGTH(last_name)
FROM employees
GROUP BY LENGTH(last_name)
HAVING num > 5;

-- 按多个字段分组
-- 查询每个部门每个工种的员工平均工资
-- GROUP BY 的顺序可以互换
SELECT AVG(salary), department_id, job_id
FROM employees
GROUP BY department_id, job_id;

-- 添加排序
-- 查询每个部门每个工种的员工平均工资, 并按平均工资的由高到低显示
SELECT AVG(salary), department_id, job_id
FROM employees
GROUP BY department_id, job_id
ORDER BY AVG(salary) DESC;

-- 在上一个的基础上添加筛选条件
SELECT AVG(salary), department_id, job_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id, job_id
HAVING AVG(salary) > 10000
ORDER BY AVG(salary) DESC;

-- 练习
-- 查询各 job_id 的员工工资的最大值, 最小值, 平均值, 总和, 并按 job_id 升序
SELECT MAX(salary), MIN(salary), AVG(salary), SUM(salary), job_id
FROM employees
GROUP BY job_id
ORDER BY job_id ASC;

-- 查询员工最高工资和最低工资的差距
SELECT MAX(salary) - MIN(salary) AS `DIFFERENCE`
FROM employees;

-- 查询各个管理者手下员工的最低工资, 其中最低工资不低于6000, 没有管理者的员工不计算在内
SELECT MIN(salary), manager_id
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 6000;

-- 查询所有部门的编号, 员工数量和工资平均值, 并按平均工资降序
SELECT department_id, COUNT(*), AVG(salary)
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) DESC;

-- 选择具有各个 job_id 的员工人数
SELECT COUNT(*), job_id
FROM employees
WHERE job_id IS NOT NULL
GROUP BY job_id;
