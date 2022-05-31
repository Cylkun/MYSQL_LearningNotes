# 进阶七: 子查询

含义:

- 嵌套在其他语句内部的 SELECT 语句, 称为子查询或内查询
- 外面的语句可以是 `INSERT`, `UPDATE`, `DELETE`, `SELECT` 等, 一般 `SELECT` 作为外面语句较多
- 内部嵌套其他 SELECT 语句的查询, 称为主查询或外查询

语法

```sql
SELECT ...
FROM ...
WHERE
	...
		IN(
			SELECT ...
			FROM ...
			WHERE ...)
```

分类

- 按结果集的行列数不同
	- ⭐标量子查询: 结果集只有一行一列
	- ⭐列子查询: 结果集只有多行一列
	- 行子查询: 结果集可以有一行多列 (或多行多列)
	- 表子查询/嵌套子查询: 结果集一般为多行多列
- 按子查询出现的位置
	- SELECT
		- 标量子查询
	- FROM表子
		- 查询
	- ⭐WHERE / HAVING
		- ⭐标量子查询
		- ⭐列子查询
		- 行子查询
	- EXISTS (相关自查询): 
		- 标量子查询
		- 列子查询
		- 行子查询
		- 表子查询


## WHERE 或 HAVING 后面

1. 标量子查询 (单行子查询)
2. 列子查询 (多行子查询)
3. 行子查询 (多列多行)

特点

1. 子查询放在小括号内
2. 子查询一般放在条件的右侧
3. 标量子查询, 一般搭配着单行操作符使用 (>, <, >=, <=, =, <>)
4. 列子查询, 一般搭配多行操作符使用 (IN, ANY/SOME, ALL)
5. 子查询的执行优先于主查询的执行, 主查询的条件用到了子查询的结果


### 标量子查询

#### 分步实现

谁的工资比 Abel 高 (分步骤)

```sql
-- 谁的工资比 Abel 高

-- ① 查询 Abel 的工资
SELECT salary
FROM employees
WHERE last_name = 'Abel';

-- ② 查询员工的信息, 满足 salary > ①的结果
SELECT *
FROM employees
WHERE salary > 11000;  -- ①的结果
```

谁的工资比 Abel 高

```sql
-- 谁的工资比 Abel 高
SELECT *
FROM employees
WHERE salary > (
    SELECT salary
    FROM employees
    WHERE last_name = 'Abel'
);
```

查询 job_id 与 141 号员工相同, salary 比 143 号员工多的员工的 last_name, job_id, salary

```sql
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
```

#### 在子查询中使用分组函数

查询公司工资最少的员工的 last_name, job_id, salary

```sql
-- 在子查询中使用分组函数
-- 查询公司工资最少的员工的 last_name, job_id, salary
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
);
```

#### 子查询中的 HAVING 子句

查询最低工资大于 50 号部门最低工资的 department_id 和 最低工资

```sql
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
```

#### 非法使用标量子查询

```sql
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
```

### 列子查询 (一列多行子查询)

返回多行
使用多行操作符

| 操作符      | 含义                       |
| ----------- | -------------------------- |
| IN / NOT IN | 等于列表中的任意一个       |
| ANY / SOME  | 和子查询返回的某一个值比较 |
| ALL         | 和子查询返回的所有值比较   |


查询 lacation_id 是 1400 或 1700 的部门中的所有员工的 last_name

```sql
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
```

查询 lacation_id 不是 1400 或 1700 的部门中的所有员工的 last_name

```sql
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
```

查询在其他工种中, 员工的工资比 job_id 为 'IT_PROG' 的工种的任意一个员工的工资更低的员工的 employee_id, last_name, job_id, salary

```sql
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
```

查询在其他工种中, 员工的工资比 job_id 为 'IT_PROG' 的工种的所有员工的工资都低的员工的 employee_id, last_name, job_id, salary

```sql
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
```


### 行子查询

结果集是一行多列或多行多列



查询员工编号最小且工资最高的员工信息

```sql
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
```

## SELECT 后面

特点: 只能是标量子查询


查询每个部门的员工个数

```sql
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
```

查询员工号等于 102 的部门名

```sql
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
```



## FROM 后面

将子查询结果充当一张表, 要求必须起别名

查询每个部门的平均工资的工资等级

```sql
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
```

## EXISTS 后面 (相关子查询)

语法: `EXISTS(完整的查询语句)`
结果: 1 或 0

```sql
-- 示例
SELECT EXISTS(SELECT employee_id FROM employees);
-- 结果 1
SELECT EXISTS(SELECT employee_id FROM employees WHERE salary=30000);
-- 结果 0
```

查询有员工的部门的部门名

```sql
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
```

```sql
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
```

## 练习

查询和 Zoltkey 相同部门的员工的 last_name 和 salary

```sql
-- 查询和 Zoltkey 相同部门的员工的 last_name 和 salary
SELECT last_name, salary
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE last_name = 'Zlotkey'
);
```

查询工资比公司平均工资高的员工的 employee_id, last_name, salary

```sql
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

查询各部门中工资比本部门平均工资高的员工的 employee_id, last_name, salary

```sql
SELECT e.employee_id, e.last_name, e.salary
FROM employees e
    INNER JOIN (
        SELECT department_id, AVG(salary) avg_sal
        FROM employees
        GROUP BY department_id
    ) avg_dep
    ON avg_dep.department_id = e.department_id
WHERE e.salary > avg_dep.avg_sal;
```

查询和 last_name 中包含字母 u 的员工在相同部门的员工的 employee_id 和 last_name

```sql
SELECT employee_id, last_name
FROM employees
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM employees
    WHERE last_name LIKE '%u%'
);
```

查询在部门的 location_id = 1700 的部门工作的员工的 employee_id

```sql
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
```

查询管理者是 K_ing 的员工的 last_name 和工资

```sql
SELECT last_name, salary
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'K_ing'
);
```

查询工资最高的员工的 first_name 和 last_name, 要求 first_name 和 last_name 显示为一列, 列名为 name

```sql
SELECT CONCAT(first_name, ' ', last_name) AS `name`
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);
```

查询工资最低的员工信息: last_name, salary

```sql
-- 查询工资最低的员工信息: last_name, salary
SELECT last_name, salary
FROM employees
WHERE salary = (
	SELECT MIN(salary)
	FROM employees
);
```

查询平均工资最低的部门信息

```sql
-- 查询平均工资最低的部门信息

-- 方法一
SELECT d.*
FROM departments d
WHERE d.department_id = (
    SELECT e.department_id
    FROM employees e
    GROUP BY e.department_id
    HAVING AVG(e.salary) = (
        SELECT MIN(d_avg.avg_salary)
        FROM (
            SELECT department_id, AVG(salary) avg_salary
            FROM employees
            GROUP BY department_id
        ) d_avg
    )
);

-- 方法二
SELECT d.*
FROM departments d
WHERE d.department_id = (
        SELECT department_id
        FROM employees
        GROUP BY department_id
        ORDER BY AVG(salary) ASC
        LIMIT 1
);

-- 错误
SELECT d_avg.department_id, d_avg.avg_salary
FROM (
    SELECT department_id, AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
) d_avg
-- ! Invalid use of group function
-- ? 为什么不可以这样写
WHERE d_avg.avg_salary = MIN(d_avg.avg_salary);
```

查询平均工资最低的部门信息和该部门的平均工资

```sql
-- 查询平均工资最低的部门信息和该部门的平均工资

SELECT d.*, d_avg.avg_salary
FROM departments d
    INNER JOIN (
        SELECT department_id, AVG(salary) avg_salary
        FROM employees
        GROUP BY department_id
        ORDER BY avg_salary ASC
        LIMIT 1
    ) d_avg ON d.department_id = d_avg.department_id;
```

查询平均工资最高的 job 信息

```sql
-- 查询平均工资最高的 job 信息
SELECT j.*
FROM jobs j
WHERE j.job_id = (
    SELECT job_id
    FROM employees
    GROUP BY job_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);
```

查询平均工资高于公司平均工资的部门

```sql
-- 查询平均工资高于公司平均工资的部门
SELECT department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);
```

查询公司中所有 manager 的详细信息

```sql
-- 查询公司中所有 manager 的详细信息
SELECT e.*
FROM employees e
WHERE e.employee_id IN (
    SELECT DISTINCT manager_id
    FROM employees
);
```

在所有部门中, 部门的最高工资中最低的那个部门的最低工资

```sql
-- 在所有部门中, 部门的最高工资中最低的那个部门的最低工资
SELECT MIN(salary)
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY MAX(salary) ASC
    LIMIT 1
);
```

查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary

```sql
-- 查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id = (
    SELECT manager_id
    FROM departments
    WHERE department_id = ( 
        SELECT department_id
        FROM employees
        GROUP BY department_id
        ORDER BY AVG(salary) DESC
        LIMIT 1
    )
);

SELECT e.last_name, e.department_id, e.email, e.salary
FROM employees e
    INNER JOIN departments d ON e.employee_id = d.manager_id
WHERE d.department_id = ( 
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);
```

