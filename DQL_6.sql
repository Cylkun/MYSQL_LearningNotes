-- 进阶六: 连接查询

-- 引例: 查询女神名和对应的男神名
SELECT `name`, boyName
FROM beauty, boys
WHERE beauty.boyfriend_id = boys.id;

-- sql92标准
-- 查询员工名和对应的部门名
SELECT first_name, department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;

-- 为表起别名
-- 查询员工名, 工种号, 工种名
SELECT first_name, e.job_id, job_title
FROM employees AS e, jobs j
WHERE e.job_id = j.job_id;

SELECT first_name, employees.job_id, job_title
FROM employees AS e, jobs j
WHERE e.job_id = j.job_id;
-- Unknown column 'employees.job_id' in 'field list'


-- 两个表的顺序是否可互换
-- 查询员工名, 工种号, 工种名
SELECT first_name, e.job_id, job_title
FROM jobs j, employees AS e
WHERE e.job_id = j.job_id;

-- 是否可以加筛选
-- 查询有奖金的员工名, 部门名
SELECT first_name, department_name
FROM employees e, departments d
WHERE
    e.department_id = d.department_id
    AND e.commission_pct IS NOT NULL;

-- 查询城市名中第二个字符为 o 的部门名和城市名
SELECT department_name, city
FROM departments d, locations l
WHERE
    d.location_id = l.location_id
    AND city LIKE '_o%';

-- 是否可以加分组
-- 查询每个城市的部门个数
SELECT COUNT(*), city
FROM departments AS d, locations AS l
WHERE d.location_id = l.location_id
GROUP BY city;

-- 查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT department_name, d.manager_id, MIN(salary)
FROM departments AS d, employees AS e
WHERE
    d.department_id = e.department_id
    AND commission_pct IS NOT NULL
GROUP BY department_name, d.manager_id;
-- 需要写两个条件, 除非 department_name 和 d.manager_id 一一对应

-- 是否可以加排序
-- 查询每个工种的工种名和员工个数, 并且按员工个数降序
SELECT job_title, COUNT(*)
FROM employees AS e, jobs AS j
WHERE e.job_id = j.job_id
GROUP BY job_title
ORDER BY COUNT(*) DESC;

-- 三表连接
-- 查询员工名, 部门名和所在城市
SELECT e.first_name, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE
    e.department_id = d.department_id
    AND d.location_id = l.location_id;

-- 查询员工名, 部门名和所在城市, 城市名以 s 开头
SELECT e.first_name, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE
    e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND city LIKE 's%';


-- 查询员工名, 部门名和所在城市, 城市名以 s 开头, 部门名降序
SELECT e.first_name, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE
    e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND city LIKE 's%'
ORDER BY d.department_name DESC;


-- 非等值连接
/*
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  int,
 highest_sal int);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);
*/
-- 查询员工的工资和工资级别
SELECT e.salary, g.grade_level
FROM employees e, job_grades g
WHERE e.salary BETWEEN g.lowest_sal AND g.highest_sal;

-- 查询员工的工资和工资级别, 级别为A
SELECT e.salary, g.grade_level
FROM employees e, job_grades g
WHERE
    e.salary BETWEEN g.lowest_sal AND g.highest_sal
    AND g.grade_level = 'A';

-- 自连接
-- 查询 员工名和上级的名称
SELECT e.employee_id, e.last_name, e.manager_id, m.last_name
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;


-- 练习
-- 显示员工表的最大工资, 工资平均值
SELECT MAX(salary), AVG(salary)
FROM employees;

-- 查询员工表的 employee_id, job_id, last_name, 按 job_id 降序, 按 salary 升序
SELECT employee_id, job_id, last_name
FROM employees
ORDER BY job_id DESC, salary ASC;

-- 查询员工表的 job_id 中包含 a 和 e 的, 并且 a 在 e 的前面
SELECT job_id
FROM employees
WHERE job_id LIKE '%a%e%';

-- 已知表 student 里面有_id (学号), name, gradeId (年级编号), 
-- 已知表 grade 里面有_id (年级编号), name, 
-- 已知表 result 里面有_id, score, studentNo (学号)
-- 查询姓名, 年级名, 成绩
SELECT s.name, g.name, r.score
FROM student s, grade g, result r
WHERE
    s.gradeId = g.id
    AND s.id = r.studentNo;

-- 显示当前日期
SELECT NOW();

-- 去除前后空格
SELECT TRIM(str)

-- 截取子字符串的函数
SELECT SUBSTR(str, startIndex);
SELECT SUBSTR(str, startIndex, len);

-- 其他函数: 加密
SELECT MD5('string');

-- 练习
-- 显示所有员工的姓, 部门号和部门名称
SELECT e.last_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

-- 查询90号部门员工的job_id和90号部门的Location_id
SELECT e.job_id, d.location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id
    AND e.department_id = 90;

-- 选择所有有奖金的员工的 last_name, department_name, location_id, city
SELECT e.last_name, d.department_name, d.location_id, l.city
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND e.commission_pct IS NOT NULL;

-- 选择 city 在 Toronto 的员工的 last_name, job_id, department_id, department_name
SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND l.city = 'Toronto';

-- 查询每个工种, 每个部门的部门名, 工种名和最低工资
SELECT d.department_name, j.job_title, MIN(salary)  -- 不是 j.min_salary
FROM departments d, employees e, jobs j
WHERE e.department_id = d.department_id
    AND e.job_id = j.job_id
GROUP BY j.job_title, d.department_name;

-- 查询每个国家下的部门个数 >2 的国家编号
SELECT l.country_id, COUNT(*)
FROM departments d, locations l
WHERE d.location_id = l.location_id
GROUP BY l.country_id
HAVING COUNT(*) > 2;

-- 选择指定员工的姓, 员工号, 以及他的管理者的姓名和员工号, 结果类似于下面的格式
-- employees    emp    manager    mgr
-- kochhar      101    k_ing       100
SELECT
	e.last_name employees, 
	e.employee_id 'emp#',
	m.last_name manager,
	e.manager_id 'mgr#'
FROM
	employees e,
	employees m
WHERE
	e.manager_id = m.employee_id
	AND e.last_name = 'kochhar';


-- sql99语法
-- 内连接
-- 等值连接
-- 查询员工名, 部门名
SELECT
	last_name,
	department_name
FROM
	employees e
	INNER JOIN departments d ON e.department_id = d.department_id;

-- 添加筛选
-- 查询名字中包含e的员工姓和工种名
SELECT e.last_name, j.job_title
FROM employees e
    INNER JOIN jobs j ON e.job_id = j.job_id
WHERE e.last_name LIKE '%e%';

-- 添加分组和筛选
--查询部门个数 >3 的城市名和部门个数
SELECT l.city, COUNT(department_id)  -- 使用 count(*) 也可以
FROM departments d
    INNER JOIN locations l ON d.location_id = l.location_id
GROUP BY l.city
HAVING COUNT(department_id) > 3;

-- 添加排序
-- 查询部门的部门员工个数 >3 的部门名和员工个数, 并按个数降序排序
SELECT d.department_name, COUNT(*)
FROM departments d
    INNER JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id
HAVING COUNT(*) > 3
ORDER BY COUNT(*) DESC;

-- 三表连接
-- 查询员工名, 部门名, 工种名, 并按部门名降序
SELECT e.last_name, d.department_name, j.job_title
FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    INNER JOIN jobs j ON e.job_id = j.job_id
ORDER BY d.department_name DESC;

-- 非等值连接
-- 查询员工的工资和工资级别
SELECT e.salary, g.grade_level
FROM employees e
    JOIN job_grades g ON e.salary BETWEEN g.lowest_sal AND g.highest_sal;

-- 查询工资级别个数 >2 的, 并按工资级别降序
SELECT g.grade_level, COUNT(*)
FROM employees e
    JOIN job_grades g ON e.salary BETWEEN g.lowest_sal AND g.highest_sal
GROUP BY g.grade_level
HAVING COUNT(*) > 20
ORDER BY g.grade_level DESC;

-- 自连接
-- 查询员工的姓和上级的姓
SELECT e.last_name, m.last_name
FROM employees e
    INNER JOIN employees m ON e.manager_id = m.employee_id;

-- 查询员工的姓和上级的姓, 员工的姓中要包含字符 k
SELECT e.last_name, m.last_name
FROM employees e
    INNER JOIN employees m ON e.manager_id = m.employee_id
WHERE e.last_name LIKE '%k%';


-- 外连接
-- 引例
-- 查询男朋友不在 boys 表中的女神名
-- 左外连接实现
SELECT b.name, bo.*  -- `bo.*` 可以去掉
FROM beauty b
    LEFT OUTER JOIN boys bo ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;

-- 右外连接实现
SELECT b.name, bo.*  -- `bo.*` 可以去掉
FROM boys bo
    RIGHT OUTER JOIN beauty b ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;

SELECT b.*, bo.*  -- `bo.*` 可以去掉
FROM boys bo
    LEFT OUTER JOIN beauty b ON b.boyfriend_id = bo.id;


-- 查询哪个部门没有员工
-- 使用左外连接
SELECT d.*, e.employee_id
FROM departments d
    LEFT OUTER JOIN employees e ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;

-- 使用右外连接
SELECT d.*, e.employee_id
FROM employees e
    RIGHT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;


-- 交叉连接
SELECT b.*, bo.*
FROM beauty b
	CROSS JOIN boys bo;


-- 练习
-- 查询编号 >3 的女神的男朋友信息, 如果有则列出详细信息, 如果没有用null填充
SELECT b.id, bo.*
FROM beauty b
	LEFT OUTER JOIN boys bo ON b.boyfriend_id = bo.id
WHERE b.id > 3;

-- 查询哪个城市没有部门
SELECT l.city
FROM locations l
    LEFT OUTER JOIN departments d ON d.location_id = l.location_id
WHERE d.department_id IS NULL;

-- 查询部门名为 SAL 或 IT 的员工信息
SELECT e.*, d.department_name
FROM employees e
    LEFT OUTER JOIN departments d ON d.department_id = e.department_id
WHERE d.department_name = 'SAL'
    OR d.department_name = 'IT';
-- WHERE d.department_name IN('SAL', 'IT');

