# 进阶二: 条件查询

语法:

```sql
SELECT
	查询列表
FROM
	表名
WHERE
	筛选条件
```

筛选条件:
1. 条件运算符: >, <, =, != 或 <>, <=, >=
2. 逻辑运算符: && 或 and, || 或 or, ! 或 not
3. 模糊查询: like, between and, in, is null


## 按条件表达式筛选

1. 查询工资>12000的员工信息

```sql
-- 查询工资>12000的员工信息
SELECT
    *
FROM
    employees
WHERE
    salary > 12000;
```

2. 查询部门编号不等于90号的员工名和部门编号

```sql
-- 查询部门编号不等于90号的员工名和部门编号
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id != 90;
```


## 按逻辑表达式筛选

1. 查询工资在10000到20000之间的员工名, 工资及奖金

```SQL
-- 查询工资在10000到20000之间的员工名, 工资及奖金
SELECT
    first_name,
    salary,
    commission_pct
FROM
    employees
WHERE
    salary >= 10000 AND salary <= 20000;
```

2. 查询部门编号不是在90到110之间, 或者工资高于15000的员工信息

```sql
-- 方法一
SELECT
    *
FROM
    employees
WHERE
    (department_id < 90 OR department_id > 110) OR salary > 15000;

-- 方法二
SELECT
    *
FROM
    employees
WHERE
    NOT(department_id >= 90 AND department_id <= 110) OR salary > 15000;
```


## 模糊查询

### LIKE

特点: 一般和通配符搭配使用
	- %: 任意多个字符, 包含0个字符
	- \_: 任意单个字符

1. 查询员工名中包含字符 a 的员工信息

```sql
-- 查询员工名中包含字符 a 的员工信息
SELECT *
FROM employees
WHERE department_id LIKE '1__';
```

2. 查询员工名中第三个字符为 n, 第五个字符为 l 的员工名和工资

```sql
-- 查询员工名中第三个字符为 n, 第五个字符为 l 的员工名和工资
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    first_name LIKE '__n_l%';
```

3. 查询员工名中第二个字符为 _ 的员工名

```sql
-- 查询员工名中第二个字符为 _ 的员工名
-- 方法一:
SELECT
    first_name
FROM
    employees
WHERE
    first_name LIKE '_\_%';

-- 方法二 (推荐使用):
SELECT
    first_name
FROM
    employees
WHERE
    first_name LIKE '_$_%' ESCAPE '$';
```


### BETWEEN AND

特点:
1. 可以提高语句简洁度
2. 包含临界值
3. 两个临界值不能调换顺序

查询员工编号在100到120之间的员工信息

```sql
-- 查询员工编号在100到120之间的员工信息
SELECT
    *
FROM
    employees
WHERE
    employee_id BETWEEN 100 AND 120;
-- 等价 employee_id >= 100 AND employee_id <= 120;
```


### IN

特点: 判断某字段的值是否属于列表中的某一项
1. 提高语句简洁度
2. 列表值类型统一
3. 不支持通配符

查询员工的工种编号式 IT_PROG, AD_VP, AD_PRES 中的一个员工名和工种编号

```sql
-- 查询员工的工种编号式 IT_PROG, AD_VP, AD_PRES 中的一个员工名和工种编号
SELECT
    first_name,
    job_id
FROM
    employees
WHERE
    job_id IN ('IT_PROG', 'AD_VP', 'AD_PRES');
-- 等价 job_id = 'IT_PROG' OR job_id = 'AD_VP' OR job_id = 'AD_PRES;
```


### IS NULL 和 安全等于 <=>

#### IS NULL

```sql
-- 查询没有奖金的员工名和奖金率
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    commission_pct IS NULL;
```

```sql
-- 查询有奖金的员工名和奖金率
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    commission_pct IS NOT NULL;
```


#### 安全等于 <=>

既可以判断 NULL, 也可以判断普通数值, 可读性差

```sql
-- 查询没有奖金的员工名和奖金率
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    commission_pct <=> NULL;
```

```sql
-- 查询工资为12000的员工名和奖金率
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    salary <=> 12000;
```


## 练习

```sql
-- 查询没有奖金, 且工资小于 18000 的 salary, last_name
SELECT
  salary,
  last_name
FROM
  employees
WHERE
  commission_pct IS NULL
  AND salary < 18000;
```

```sql
-- 查询 employees 表中, job_id 不为 'IT' 或者 工资为 12000 的员工信息
SELECT
    *
FROM
    employees
WHERE
    job_id != 'IT'
    OR salary = 12000;
```

```sql
-- 查看部门 departments 表的结构
DESC departments;
```

```sql
-- 查询部门 departments 表中涉及到了哪些位置编号
SELECT DISTINCT location_id
FROM departmentS;
```

```sql
-- 判断结果是否一样, 并说明原因
-- 不一样, 如果判断的字段有 NULL 值
SELECT * FROM employees;

SELECT *
FROM employees
WHERE commission_pct like '%%'
	AND last_name like '%%';
```

