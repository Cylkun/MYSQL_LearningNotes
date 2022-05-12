-- 进阶7: 子查询

-- WHERE / HAVING
-- 标量子查询
-- 谁的工资比 Abel 高
-- ① 查询 Abel 的工资
SELECT salary
FROM employees
WHERE last_name = 'Abel';
-- ② 查询员工的信息, 满足 salary > ①的结果
SELECT *
FROM employees
WHERE salary > 11000;  -- ①的结果

SELECT *
FROM employees
WHERE salary > (
    SELECT salary
    FROM employees
    WHERE last_name = 'Abel'
);

-- 查询 job_id 与 141 号员工相同, salary 比 143 号员工多的员工的 last_name, job_id, salary
SELECT last_name, job_id, salary
FROM employees
WHERE
	job_id = (
        SELECT job_id
        FROM employees
        WHERE employee_id = 141
	)
	AND salary > (
        SELECT salary
        FROM employees
        WHERE employee_id = 143
	);

-- 在子查询中使用分组函数
-- 查询公司工资最少的员工的 last_name, job_id, salary
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
);

-- 子查询中的 HAVING 子句
-- 查询最低工资大于 50 号部门最低工资的 department_id 和 最低工资
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 50
);

-- 非法使用标量子查询
-- Subquery returns more than 1 row
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (
    SELECT salary
    FROM employees
    WHERE department_id = 50
);

-- department_id = 250 不存在, 什么都没查到
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (
    SELECT salary
    FROM employees
    WHERE department_id = 250
);

-- 列子查询
-- 查询 lacation_id 是 1400 或 1700 的部门中的所有员工的 last_name
-- ① 查询 location_id 是 1400 或 1700 的部门编号
SELECT department_id
FROM departments
WHERE location_id IN (1400, 1700);

-- ② 查询员工的 last_name, 要求部门号是 ① 中的某一个
SELECT last_name
FROM employees
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM departments
    WHERE location_id IN(1400, 1700)
);

-- 等价替换 (效率更高)
SELECT last_name
FROM employees
WHERE department_id = ANY (
    SELECT DISTINCT department_id
    FROM departments
    WHERE location_id IN(1400, 1700)
);

-- 查询 lacation_id 不是 1400 或 1700 的部门中的所有员工的 last_name
SELECT last_name
FROM employees
WHERE department_id NOT IN (
    SELECT DISTINCT department_id
    FROM departments
    WHERE location_id IN(1400, 1700)
);

-- 等价替换 (效率更高)
SELECT last_name
FROM employees
WHERE department_id <> ALL (
    SELECT DISTINCT department_id
    FROM departments
    WHERE location_id IN(1400, 1700)
);

-- 查询在其他工种中, 员工的工资比 job_id 为 'IT_PROG' 的工种的任意一个员工的工资更低的员工的 employee_id, last_name, job_id, salary
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE
    salary < ANY(
        SELECT salary
        FROM employees
        WHERE job_id = 'IT_PROG'
    )
    AND job_id <> 'IT_PROG';

-- 使用标量查询等价替代
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE
    salary < (
        SELECT MAX(salary)
        FROM employees
        WHERE job_id = 'IT_PROG'
    )
    AND job_id <> 'IT_PROG';

-- 查询在其他工种中, 员工的工资比 job_id 为 'IT_PROG' 的工种的所有员工的工资都低的员工的 employee_id, last_name, job_id, salary
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE
    salary < ALL(
        SELECT salary
        FROM employees
        WHERE job_id = 'IT_PROG'
    )
    AND job_id <> 'IT_PROG';

-- 使用标量查询等价替代
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE
    salary < (
        SELECT MIN(salary)
        FROM employees
        WHERE job_id = 'IT_PROG'
    )
    AND job_id <> 'IT_PROG';


-- 行子查询
-- 查询员工编号最小且工资最高的员工信息
-- 标量子查询实现
SELECT *
FROM employees
WHERE
    employee_id = (
        SELECT MIN(employee_id)
        FROM employees
    )
    AND salary = (
        SELECT MAX(salary)
        FROM employees
    );

-- 行子查询实现 (效率不高)
SELECT *
FROM employees
WHERE (employee_id, salary) = (
        SELECT MIN(employee_id), MAX(salary)
        FROM employees
    );

-- SELECT 后面
-- 查询每个部门的员工个数
SELECT
	d.*,
	(
        SELECT COUNT(*)
        FROM employees e
        WHERE d.department_id = e.department_id
	) 个 数
FROM
	departments d;

-- 查询员工号等于 102 的部门名
SELECT (
    SELECT department_name
    FROM departments d
        INNER JOIN employees e ON e.department_id = d.department_id
    WHERE e.employee_id = 102
) 部门名;

-- 效率更低
SELECT d.department_name 部门名
FROM departments d
    INNER JOIN employees e ON e.department_id = d.department_id
WHERE e.employee_id = 102;

-- FROM 后面
-- 查询每个部门的平均工资的工资等级
-- ① 查询平均工资
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id;
-- ② 连接 的结果集和 job_grades 表
SELECT department_id, AVG(salary)
FROM(
    SELECT department_id, AVG(salary)
    FROM employees
    GROUP BY department_id;
) avg_salary

-- EXISTS 后面
-- 示例
SELECT EXISTS(SELECT employee_id FROM employees);
-- 结果 1
SELECT EXISTS(SELECT employee_id FROM employees WHERE salary=30000);
-- 结果 0

-- 查询有员工的部门的部门名
SELECT d.department_name
FROM departments d
WHERE EXISTS(
    SELECT *
    FROM employees e
    WHERE d.department_id = e.department_id
);

-- 使用 IN 的等价写法
SELECT d.department_name
FROM departments d
WHERE d.department_id IN(
    SELECT DISTINCT e.department_id
    FROM employees e
);

-- 查询没有女朋友的男神信息
SELECT bo.*
FROM boys bo
WHERE bo.id NOT IN(
    SELECT DISTINCT b.boyfriend_id
    FROM beauty b
);

SELECT bo.*
FROM boys bo
WHERE NOT EXISTS(
    SELECT *
    FROM beauty b
    WHERE b.boyfriend_id = bo.id
);

-- 查询和 Zlotkey 相同部门的员工的 last_name 和 salary
SELECT last_name, salary
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE last_name = 'Zlotkey'
);

-- 查询工资比公司平均工资高的员工的 employee_id, last_name, salary
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- 查询各部门中工资比本部门平均工资高的员工的 employee_id, last_name, salary
SELECT e.employee_id, e.last_name, e.salary
FROM employees e
    INNER JOIN (
        SELECT department_id, AVG(salary) avg_sal
        FROM employees
        GROUP BY department_id
    ) avg_dep
    ON avg_dep.department_id = e.department_id
WHERE e.salary > avg_dep.avg_sal;

-- 查询和 last_name 中包含字母 u 的员工在相同部门的员工的 employee_id, last_name
SELECT employee_id, last_name
FROM employees
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM employees
    WHERE last_name LIKE '%u%'
);

-- 查询在部门 location_id = 1700 的部门工作的员工的 employee_id
SELECT employee_id
FROM employees
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM departments
    WHERE location_id = 1700
);

SELECT employee_id
FROM employees
WHERE department_id = ANY (
    SELECT DISTINCT department_id
    FROM departments
    WHERE location_id = 1700
);

-- 查询管理者是 K_ing 的员工的 last_name, salary
SELECT last_name, salary
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'K_ing'
);

-- 查询工资最高的员工的 first_name, last_name, 要求 first_name 和 last_name 显示为一列, 列名为 name
SELECT CONCAT(first_name, ' ', last_name) AS `name`
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);
