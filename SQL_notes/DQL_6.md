# 进阶六: 连接查询

含义: 又称多表查询, 当查询的字段来自多个表时, 就会用到连接查询

笛卡尔乘积现象: 表1 m行, 表2 n行, 结果 = m\*n 行

发生原因: 没有有效的连接条件
如何避免: 添加有效的连接条件

分类:

1. 按年代分类:
	1. SQL92标准: 仅支持内连接 (mysql), 不能很好支持外连接 (mysql完全不支持, sqlserver 和 oracle)
	2. SQL99标准 (推荐): 支持 内连接 + 外连接 (左外和右外) + 交叉连接
2. 按功能分类
	1. 内连接:
		1. 等值连接
		2. 非等值连接
		3. 自连接
	2. 外连接
		1. 左外连接
		2. 右外连接
		3. 全外连接
	3. 交叉连接

## SQL92 标准

### 等值连接

引例: 查询女神名和对应的男神名

```sql
-- 引例: 查询女神名和对应的男神名
SELECT `name`, boyName
FROM beauty, boys
WHERE beauty.boyfriend_id = boys.id;
```

查询员工名和对应的部门名

```sql
-- 查询员工名和对应的部门名
SELECT first_name, department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;
```

#### 为表起别名

好处: 

1. 提高语句的简洁度
2. 区分多个重名字段

注意: 如果为表起了别名, 则查询字段就不能使用原来的表名去限定


查询员工名, 工种号, 工种名

```sql
-- 查询员工名, 工种号, 工种名
SELECT first_name, e.job_id, job_title
FROM employees AS e, jobs j
WHERE e.job_id = j.job_id;
```

报错: `Unknown column 'employees.job_id' in 'field list'`

```sql
SELECT first_name, employees.job_id, job_title
FROM employees AS e, jobs j
WHERE e.job_id = j.job_id;
```

#### 两个表的顺序是否可互换

查询员工名, 工种号, 工种名

```sql
-- 查询员工名, 工种号, 工种名
SELECT first_name, e.job_id, job_title
FROM jobs j, employees AS e
WHERE e.job_id = j.job_id;
```

#### 添加筛选

查询有奖金的员工名, 部门名

```sql
-- 查询有奖金的员工名, 部门名
SELECT first_name, department_name
FROM employees e, departments d
WHERE
    e.department_id = d.department_id
    AND e.commission_pct IS NOT NULL;
```

查询城市名中第二个字符为 o 的部门名和城市名

```sql
-- 查询城市名中第二个字符为 o 的部门名和城市名
SELECT department_name, city
FROM departments d, locations l
WHERE
    d.location_id = l.location_id
    AND city LIKE '_o%';
```

#### 添加分组

查询每个城市的部门个数

```sql
-- 查询每个城市的部门个数
SELECT COUNT(*), city
FROM departments AS d, locations AS l
WHERE d.location_id = l.location_id
GROUP BY city;
```

查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资

```sql
-- 查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT department_name, d.manager_id, MIN(salary)
FROM departments AS d, employees AS e
WHERE
    d.department_id = e.department_id
    AND commission_pct IS NOT NULL
GROUP BY department_name, d.manager_id;
```

需要写两个条件, 除非 department_name 和 d.manager_id 一一对应

#### 添加排序

查询每个工种的工种名和员工个数, 并且按员工个数降序

```sql
-- 查询每个工种的工种名和员工个数, 并且按员工个数降序
SELECT job_title, COUNT(*)
FROM employees AS e, jobs AS j
WHERE e.job_id = j.job_id
GROUP BY job_title
ORDER BY COUNT(*) DESC;
```

#### 三表连接

查询员工名, 部门名和所在城市

```sql
-- 查询员工名, 部门名和所在城市
SELECT e.first_name, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE
    e.department_id = d.department_id
    AND d.location_id = l.location_id;
```

查询员工名, 部门名和所在城市, 城市名以 s 开头

```sql
-- 查询员工名, 部门名和所在城市, 城市名以 s 开头
SELECT e.first_name, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE
    e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND city LIKE 's%';
```

查询员工名, 部门名和所在城市, 城市名以 s 开头, 部门名降序

```sql
-- 查询员工名, 部门名和所在城市, 城市名以 s 开头, 部门名降序
SELECT e.first_name, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE
    e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND city LIKE 's%'
ORDER BY d.department_name DESC;
```


#### 总结

语法

```sql
SELECT 查询列表
FROM 表1 别名, 表2 别名
WHERE 表1.key = 表2.key
	[AND 筛选条件]
[GROUP BY 分组字段]
[HAVING 分组后的筛选]
[ORDER BY 排序字段]
```

特点: 

1. 多表等值连接的结果为多表的交集部分
2. n表连接, 至少需要 n-1 个连接条件
3. 多表的顺序没有要求
4. 一般需要为表起别名
5. 可以搭配前门介绍的所有子句使用, 比如排序, 分组, 筛选


### 非等值连接

语法

```sql
SELECT 查询列表
FROM 表1 别名, 表2 别名
WHERE 非等值连接条件
	[AND 筛选条件]
[GROUP BY 分组字段]
[HAVIGN 分组后的筛选]
[ORDER BY 排序字段]
```

新建表

```sql
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
```

查询员工的工资和工资级别

```sql
-- 查询员工的工资和工资级别
SELECT e.salary, g.grade_level
FROM employees e, job_grades g
WHERE e.salary BETWEEN g.lowest_sal AND g.highest_sal;
```

查询员工的工资和工资级别, 级别为A

```sql
-- 查询员工的工资和工资级别, 级别为A
SELECT e.salary, g.grade_level
FROM employees e, job_grades g
WHERE
    e.salary BETWEEN g.lowest_sal AND g.highest_sal
    AND g.grade_level = 'A';
```



### 练习

显示所有员工的姓, 部门号和部门名称

```sql
-- 显示所有员工的姓, 部门号和部门名称
SELECT e.last_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;
```

查询90号部门员工的job_id和90号部门的Location_id

```sql
-- 查询90号部门员工的job_id和90号部门的Location_id
SELECT e.job_id, d.location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id
    AND e.department_id = 90;
```

选择所有有奖金的员工的 last_name, department_name, location_id, city

```sql
-- 选择所有有奖金的员工的 last_name, department_name, location_id, city
SELECT e.last_name, d.department_name, d.location_id, l.city
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND e.commission_pct IS NOT NULL;
```

选择 city 在 Toronto 的员工的 last_name, job_id, department_id, department_name

```sql
-- 选择 city 在 Toronto 的员工的 last_name, job_id, department_id, department_name
SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
    AND d.location_id = l.location_id
    AND l.city = 'Toronto';
```

查询每个工种, 每个部门的部门名, 工种名和最低工资

```sql
-- 查询每个工种, 每个部门的部门名, 工种名和最低工资
SELECT d.department_name, j.job_title, MIN(salary)  -- 不是 j.min_salary
FROM departments d, employees e, jobs j
WHERE e.department_id = d.department_id
    AND e.job_id = j.job_id
GROUP BY j.job_title, d.department_name;
```

查询每个国家下的部门个数 >2 的国家编号

```sql
-- 查询每个国家下的部门个数 >2 的国家编号
SELECT l.country_id, COUNT(*)
FROM departments d, locations l
WHERE d.location_id = l.location_id
GROUP BY l.country_id
HAVING COUNT(*) > 2;
```

选择指定员工的姓, 员工号, 以及他的管理者的姓名和员工号, 结果类似于下面的格式
employees    emp    manager    mgr
kochhar      101    k_ing       100

```sql
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
```

## sql99 语法

语法

```sql
SELECT 查询列表
FROM 表1 别名 [连接类型]
JOIN 表2 别名
ON 连接条件
[WHERE 筛选条件]
[GROUP BY 分组]
[HAVING 筛选条件]
[ORDER BY 排序列表];
```



|   连接类型   | 关键字 |
| ---- | ---- |
| 内连接 | INNER |
| 外连接  左外 | LEFT [OUTER] |
| 外连接  右外 | RIGHT [OUTER] |
| 外连接  全外 | FULL [OUTER] |
| 交叉连接 | CROSS |




###  内连接

语法

```sql
SELECT 查询列表
FROM 表1 [AS] 别名
[INNER] JOIN 表2 AS 别名 ON 连接条件
WHERE 筛选条件
GROUP BY 分组列表
HAVING 分组后筛选
ORDER BY 排序列表
LIMIT 子句
```

特点: 

1. 表的顺序可以调换
2. 内连接的结果 = 多表的交集
3. n 表连接至少需要 n-1 个连接条件

分类:

1. 等值连接
2. 非等值连接
3. 自连接


#### 等值连接

特点:

1. 可以添加排序, 分组, 筛选
2. `INNER` 可以省略
3. 筛选条件放在 `WHERE` 后面, 连接条件放在 `ON` 后面, 提高分离性, 便于阅读
4. `INNER JOIN` 和 SQL 中的等值连接效果是一样的, 都是查询多表的交集


查询员工名, 部门名

```sql
-- 查询员工名, 部门名
SELECT
	last_name,
	department_name
FROM
	employees e
	INNER JOIN departments d ON e.department_id = d.department_id;
```

添加筛选
查询名字中包含e的员工姓和工种名

```sql
-- 添加筛选
-- 查询名字中包含e的员工姓和工种名
SELECT e.last_name, j.job_title
FROM employees e
    INNER JOIN jobs j ON e.job_id = j.job_id
WHERE e.last_name LIKE '%e%';
```

添加分组和筛选
查询部门个数 >3 的城市名和部门个数

```sql
-- 添加分组和筛选
--查询部门个数 >3 的城市名和部门个数
SELECT l.city, COUNT(department_id)  -- 使用 count(*) 也可以
FROM departments d
    INNER JOIN locations l ON d.location_id = l.location_id
GROUP BY l.city
HAVING COUNT(department_id) > 3;
```

添加排序
查询部门的部门员工个数 >3 的部门名和员工个数, 并按个数降序排序

```sql
-- 添加排序
-- 查询部门的部门员工个数 >3 的部门名和员工个数, 并按个数降序排序
SELECT d.department_name, COUNT(*)
FROM departments d
    INNER JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id
HAVING COUNT(*) > 3
ORDER BY COUNT(*) DESC;
```

三表连接
查询员工名, 部门名, 工种名, 并按部门名降序

```sql
-- 三表连接
-- 查询员工名, 部门名, 工种名, 并按部门名降序
SELECT e.last_name, d.department_name, j.job_title
FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    INNER JOIN jobs j ON e.job_id = j.job_id
ORDER BY d.department_name DESC;
```


#### 非等值连接

查询员工的工资和工资级别

```sql
-- 查询员工的工资和工资级别
SELECT e.salary, g.grade_level
FROM employees e
    JOIN job_grades g ON e.salary BETWEEN g.lowest_sal AND g.highest_sal;
```

查询工资级别个数 >2 的, 并按工资级别降序

```sql
-- 查询工资级别个数 >2 的, 并按工资级别降序
SELECT g.grade_level, COUNT(*)
FROM employees e
    JOIN job_grades g ON e.salary BETWEEN g.lowest_sal AND g.highest_sal
GROUP BY g.grade_level
HAVING COUNT(*) > 20
ORDER BY g.grade_level DESC;
```

#### 自连接

查询员工的姓和上级的姓

```sql
-- 查询员工的姓和上级的姓
SELECT e.last_name, m.last_name
FROM employees e
    INNER JOIN employees m ON e.manager_id = m.employee_id;
```

查询员工的姓和上级的姓, 员工的姓中要包含字符 k

```sql
-- 查询员工的姓和上级的姓, 员工的姓中要包含字符 k
SELECT e.last_name, m.last_name
FROM employees e
    INNER JOIN employees m ON e.manager_id = m.employee_id
WHERE e.last_name LIKE '%k%';
```


### 外连接

应用场景: 用于查询除了交集部分的剩余的不匹配的行 (一个表中有, 另一个表没有)

语法

```sql
SELECT 查询列表
FROM 表1 [AS] 别名
RIGHT [OUTER] JOIN 表2 AS 别名 ON 连接条件
WHERE 筛选条件
GROUP BY 分组列表
HAVING 分组后筛选
ORDER BY 排序列表
LIMIT 子句
```

特点:

1. 外连接的查询结果为主表中的所行, 如果从表中有和它匹配的, 则显示匹配的值, 如果从表中没有和它匹配的, 则显示 NULL. 外连接查询结果 = 内连接查询结果 + 主表中有而从表中没有的记录
2. 左外连接中 `LEFT OUTER JOIN` 左边的是主表, 右外连接中 `RIGHT OUTER JOIN` 右边的是主表, `FULL JOIN` 两边都是主表
3. 左外和右外交换两个表的顺序, 可以实现相同的效果
4. 全外连接 = 内连接的结果 + 表1中有但表2中没有的 + 表2中有但表1中没有的


#### 左外连接右外连接

引例: 查询男朋友不在 boys 表中的女神名

左外连接实现

```sql
-- 查询男朋友不在 boys 表中的女神名
-- 左外连接实现
SELECT b.name, bo.*  -- `bo.*` 可以去掉
FROM beauty b
    LEFT OUTER JOIN boys bo ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;
```

右外连接实现

```sql
-- 右外连接实现
SELECT b.name, bo.*
FROM boys bo
    RIGHT OUTER JOIN beauty b ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;
```

主表从表对比

```sql
SELECT b.name, bo.*
FROM beauty b
    LEFT OUTER JOIN boys bo ON b.boyfriend_id = bo.id;
```

```sql
SELECT b.*, bo.*
FROM boys bo
    LEFT OUTER JOIN beauty b ON b.boyfriend_id = bo.id;
```

查询哪个部门没有员工

使用左外连接

```sql
-- 查询哪个部门没有员工
-- 使用左外连接
SELECT d.*, e.employee_id
FROM departments d
    LEFT OUTER JOIN employees e ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;
```

使用右外连接

```sql
-- 使用右外连接
SELECT d.*, e.employee_id
FROM employees e
    RIGHT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;
```


### 交叉连接

语法

```sql
SELECT 查询列表
FROM 表1 别名
	CROSS JOIN 表2 别名;
```

```sql
-- 交叉连接
SELECT b.*, bo.*
FROM beauty b
	CROSS JOIN boys bo;
```


## 总结

SQL92 VS SQL99

- 功能: SQL99支持的更多
- 可读性: SQL99中连接条件和筛选条件相分离, 可读性较高


## 练习

查询编号 >3 的女神的男朋友信息, 如果有则列出详细信息, 如果没有用null填充

```sql
-- 练习
-- 查询编号 >3 的女神的男朋友信息, 如果有则列出详细信息, 如果没有用null填充
SELECT b.id, bo.*
FROM beauty b
	LEFT OUTER JOIN boys bo ON b.boyfriend_id = bo.id
WHERE b.id > 3;
```

查询哪个城市没有部门

```sql
-- 查询哪个城市没有部门
SELECT l.city
FROM locations l
    LEFT OUTER JOIN departments d ON d.location_id = l.location_id
WHERE d.department_id IS NULL;
```

查询部门名为SAL或IT的员工信息

```sql
-- 查询部门名为 SAL 或 IT 的员工信息
SELECT e.*, d.department_name
FROM employees e
    LEFT OUTER JOIN departments d ON d.department_id = e.department_id
WHERE d.department_name = 'SAL'
    OR d.department_name = 'IT';
-- WHERE d.department_name IN('SAL', 'IT');
```


