# 进阶四-1: 常见函数

好处: 

1. 隐藏实现细节
2. 提高代码重用性

调用

```sql
SELECT 函数名(实参列表)
[FROM 表]
```

特点: 

1. 函数名
2. 函数功能

分类: 

1. 单行函数 (做处理)
	1. CONCAT
	2. LENGTH
	3. IFNULL
2. 分组函数/统计函数/聚合函数/组函数 (做统计)
	1. 字符函数
	2. 数学函数
	3. 日期函数
	4. 其他函数
	5. 流程控制函数

## 常见函数 (单行函数)

### 字符函数

#### LENGTH

获取参数值的字节个数

```sql
-- LENGTH: 获取参数值的字节个数
SELECT LENGTH('john');
SELECT LENGTH('张三丰');
```

查看字符集

```sql
mysql> SHOW VARIABLES LIKE '%char%';
+--------------------------+---------------------------------------------------------+
| Variable_name            | Value                                                   |
+--------------------------+---------------------------------------------------------+
| character_set_client     | gbk                                                     |
| character_set_connection | gbk                                                     |
| character_set_database   | utf8mb4                                                 |
| character_set_filesystem | binary                                                  |
| character_set_results    | gbk                                                     |
| character_set_server     | utf8mb4                                                 |
| character_set_system     | utf8mb3                                                 |
| character_sets_dir       | C:\Program Files\MySQL\MySQL Server 8.0\share\charsets\ |
+--------------------------+---------------------------------------------------------+
8 rows in set, 1 warning (0.00 sec)
```


#### CONCAT

```sql
-- CONCAT: 拼接字符串
SELECT
  CONCAT(first_name, '_', last_name) AS `name`
FROM
  employees;
```

#### UPPER, LOWER

UPPER: 大写
LOWER: 小写

```sql
-- UPPER, LOWER
SELECT
  UPPER('john');
SELECT
  LOWER('JOHN');
```

将姓变大写, 名变小写, 然后拼接

```sql
-- 将姓变大写, 名变小写, 然后拼接
SELECT
  CONCAT(LOWER(first_name), ' ', UPPER(last_name)) AS `name`
FROM
  employees;
```

#### SUBSTR/SUBSTRING

SUBSTR/SUBSTRING: 截取字符, 计数从1开始计数

> 注意: `LIMIT` 后计数从 0 开始


截取从指定索引处后面的所有字符

```sql
-- 截取从指定索引处后面的所有字符
SELECT
  SUBSTR('李莫愁爱上了陆展元', 7) AS `substring`;
```

截取从指定索引处指定字符长度的字符 (注意式字符长度, 不是字节长度)

```sql
-- 截取从指定索引处指定字符长度的字符 (注意是字符长度, 不是字节长度)
SELECT
  SUBSTR('李莫愁爱上了陆展元', 1, 3) AS `substring`;
```

姓名首字符大写, 其他字符小写, 然后用下划线拼接

```sql
-- 姓名首字符大写, 其他字符小写, 然后用下划线拼接
SELECT
  CONCAT(
    UPPER(SUBSTR(first_name, 1, 1)),
    LOWER(SUBSTR(first_name, 2)),
    '_',
    UPPER(SUBSTR(last_name, 1, 1)),
    LOWER(SUBSTR(last_name, 2))
  ) AS `name`
FROM
  employees;
```

#### INSTR

INSTR: 返回字串第一次出现的起始索引, 找不到则返回0

```sql
-- INSTR: 返回字串第一次出现的起始索引, 找不到则返回0
SELECT INSTR('杨不悔爱上了殷六侠', '殷六侠') AS `instr`;
SELECT INSTR('杨不悔殷六侠爱上了殷六侠', '殷六侠') AS `instr`;
SELECT INSTR('杨不悔爱上了殷六侠', '殷八侠') AS `instr`;
```

#### TRIM

TRIM: 除去前后字符

```sql
-- TRIM: 除去前后字符
SELECT LENGTH(TRIM('     张翠山      ')) AS `trim`;
SELECT TRIM('a' FROM 'aaaaaaaa张aaa翠aaa山aaaaaaaaaa') AS `trim`;
SELECT TRIM('ab' FROM 'ababa张翠山babab') AS `trim`;
```

#### LPAD

LPAD: 用指定的字符实现左填充使总字符数达到指定长度, 或者截断为指定长度

```sql
-- LPAD: 用指定的字符实现左填充使总字符数达到指定长度, 或者截断为指定长度
SELECT LPAD('殷素素', 10, '*') AS `lpad`;
SELECT LPAD('殷素素', 2, '*') AS `lpad`;
```

#### RLAD

RLAD: 右填充

```sql
-- RLAD: 右填充
SELECT RPAD('殷素素', 12, 'ab') AS `rpad`;
```

#### REPLACE

REPLACE: 替换

```sql
-- REPLACE: 替换
SELECT REPLACE('张无忌周芷若周芷若爱上了周芷若', '周芷若', '赵敏') AS `replace`;
```

### 数学函数

#### ROUND

ROUND: 四舍五入

```sql
-- ROUND: 四舍五入
SELECT ROUND(1.65);
SELECT ROUND(1.45);
```


```sql
-- 先取绝对值再四舍五入, 然后加正负号
SELECT ROUND(-1.65);
SELECT ROUND(-1.45);
```


```sql
-- 四舍五入保留2位小数
SELECT ROUND(1.567, 2);
```

#### CEIL

CEIL: 向上取整, 返回 >= 该参数的最小整数

```sql
-- CEIL: 向上取整, 返回 >= 该参数的最小整数
SELECT CEIL(1.002);
SELECT CEIL(1.00);
SELECT CEIL(-1.002);
```

#### FLOOR

FLOOR: 向下取整, 返回 <= 该参数的最大整数

```sql
-- FLOOR: 向下取整, 返回 <= 该参数的最大整数
SELECT FLOOR(-9.99);
```

#### TRUNCATE

TRUNCATE: 截断

```sql
-- TRUNCATE: 截断
-- 截断, 保留1位小数
SELECT TRUNCATE(1.65, 1);
```

#### MOD

MOD: 取余, 第一个参数为正, 结果为正, 第一个参数wei

```sql
-- MOD: 取余, 第一个参数为正, 结果为正, 第一个参数wei
SELECT MOD(10, 3);
SELECT MOD(-10, 3);
```

### 日期函数

| 格式符 | 功能               |
| ------ | ------------------ |
| %Y     | 4位年份            |
| %y     | 2位年份            |
| %m     | 月份 (01, 02, ...) |
| %c     | 月份 (1, 2, ...)   |
| %d     | 日 (01, 02, ...)   |
| %H     | 小时 (24小时制)    |
| %h     | 小时 (12小时制)    |
| %i     | 分钟 (00, 01, ...) |
| %s     | 秒 (00, 01, ...)   |


#### NOW

```sql
-- NOW: 当前系统的日期和时间
SELECT NOW();
```

#### CURDATE

CURDATE: 返回当前系统的日期, 不包含时间

```sql
-- CURDATA: 返回当前系统的日期, 不包含时间
SELECT CURDATE();
-- CURDATA: 返回当前系统的时间, 不包含日期
SELECT CURTIME();
```

获取指定年月日小时分钟秒

```sql
-- 获取指定年
SELECT YEAR(NOW());
SELECT YEAR(1998-1-1);
SELECT DISTINCT YEAR(hiredate) AS 年 FROM employees;
```

不以数字显示, 显示英文全称

```sql
SELECT MONTH(NOW());

-- 不以数字显示, 显示英文全称
SELECT MONTHNAME(NOW());
```


```sql
SELECT DAY(NOW());
SELECT HOUR(NOW());
SELECT SECOND(NOW());
```

#### STR_TO_DATE

STR_TO_DATE: 将日期格式的字符转换成指定格式的日期

```sql
-- STR_TO_DATE: 将字符串转换为指定日期格式
SELECT STR_TO_DATE('1998-3-2', '%Y-%c-%d') AS `date`;
-- 查询入职日期为 1992-4-3 的员工信息
SELECT * FROM employees WHERE hiredate = '1992-4-3';
SELECT * FROM employees WHERE hiredate = STR_TO_DATE('4-3 1992', '%c-%d %Y');
```

#### DATE_FORMAT

DATE_FORMAT: 将日期转换成字符

```sql
-- DATE_FORMAT: 将日期转换成字符
SELECT DATE_FORMAT(NOW(), '%Y年%m月%d日') AS `data`;
```


### 其他函数

```sql
-- 查看版本
SELECT VERSION();

-- 查看当前库
SELECT DATABASE();

-- 查看用户
SELECT USER();

-- 加密
SELECT MD5('string');
```


### 流程控制函数

#### IF

```sql
-- IF(条件, 条件成立, 条件不成立)
SELECT
  IF(10 > 5, '大', '小');
```

查询员工是否有奖金, 有奖金时提示有, 否则提示没有

```sql
-- 查询员工是否有奖金, 有奖金时提示有, 否则提示没有
SELECT
  last_name,
  commission_pct,
  IF(commission_pct IS NOT NULL, '有奖金, 嘻嘻', '无奖金, 呵呵') AS '备注'
FROM
  employees;
```

#### CASE

##### 使用一: switch case

java:
switch (变量表达式){
case 常量1: 语句1; break;
...
case 常量n: 语句n; break;
}

mysql:
CASE 要判断的值/表达式或语句 (当前全为表达式)
WHEN 常量1 THEN 要显示的值1或语句1; (语句需要加分号, 字段不需要加分号)
WHEN 常量2 THEN 要显示的值2或语句2;
...
ELSE 要显示的值n或语句n;
END


```sql
-- 使用一: switch case
-- 查询员工的工资, 要求:
-- 部门号 = 30, 显示的工资为 1.1 倍
-- 部门号 = 40, 显示的工资为 1.2 倍
-- 部门号 = 50, 显示的工资为 1.3 倍
-- 其他部门, 显示的工资为原工资
SELECT
  salary AS `原始工资`,
  department_id,
  CASE
    department_id
    WHEN 30 THEN salary * 1.1
    WHEN 40 THEN salary * 1.2
    WHEN 50 THEN salary * 1.3
    ELSE salary
  END AS `新工资`
FROM
  employees
ORDER BY
  department_id ASC;
```

##### 使用二: 多重if

java:
if(条件1){
语句1;
}else if(条件2){
语句2;
}else{
语句3;
}

mysql:
CASE
WHEN 条件1 THEN 要显示的值1或语句1 (语句要加分号)
WHEN 条件2 THEN 要显示的值2或语句2 (语句要加分号)
...
ELSE 要显示的值1或语句n
END

```sql
-- 使用二: 多重if
-- 查询员工的工资情况
-- 如果工资>20000, 显示A级别
-- 如果工资>15000, 显示B级别
-- 如果工资>10000, 显示C级别
-- 否则, 显示B级别
SELECT
  salary,
  CASE
    WHEN salary > 20000 THEN 'A'
    WHEN salary > 15000 THEN 'B'
    WHEN salary > 10000 THEN 'C'
    ELSE 'D'
  END AS `grade`
FROM
  employees;
```

### 常见函数总结 (单行函数)

1. 字符函数
	1. length
	2. concat
	3. substr
	4. instr
	5. trim
	6. upper
	7. lower
	8. lpad
	9. rpad
	10. replace
2. 数学函数
	1. round
	2. ceil
	3. floor
	4. truncate
	5. mod
3. 日期函数
	1. now
	2. curdata
	3. curtime
	4. year
	5. month
	6. monthname
	7. day
	8. hour
	9. minute
	10. second
	11. str_to_date
	12. date_format
4. 其他函数
	1. version
	2. database
	3. user
5. 流程控制函数
	1. if
	2. case


### 练习

显示系统时间 (注: 日期 + 时间)

```sql
-- 显示系统时间 (注: 日期 + 时间)
SELECT
  NOW();
```

查询员工号, 姓名, 工资, 以及工资提高 20% 之后的结果 (new salary)

```sql
-- 查询员工号, 姓名, 工资, 以及工资提高 20% 之后的结果 (new salary)
SELECT
  employee_id,
  CONCAT(first_name, ' ', last_name) AS 'name',
  salary,
  salary * 1.2 AS "new salary"
FROM
  employees;
```

将员工的姓名按首字母排序, 并写出姓名的长度 (length)

```sql
-- 将员工的姓名按首字母排序, 并写出姓名的长度 (length)
SELECT
  CONCAT(first_name, ' ', last_name) AS `name`,
  SUBSTR(first_name, 1, 1) AS `首字符`,
  LENGTH(CONCAT(first_name, ' ', last_name)) AS 'len'
FROM
  employees
ORDER BY
  `首字符` ASC;
-- 这里不能使用 'name', 必须使用 `name`, ORDER BY 无法使用 'name'
```

查询, 产生下面的结果

Dream max_salary
K_ing earns 24000 monthly but wants 72000
``<last name> earns <salary> monthly but wants<salary*3>`

```sql
-- 查询, 产生下面的结果
-- Dream max_salary
-- K_ing earns 24000 monthly but wants 72000
SELECT
  CONCAT(
    last_name,
    ' earns ',
    CEIL(salary),
    ' monthly but wants ',
    CEIL(salary * 3)
  ) AS "Dream Salary"
FROM
  employees
WHERE
  last_name = 'K_ing'  -- last_name = 'K_ing' 有两个结果
  AND salary = 24000;
```


使用 CASE-WHEN, 按照条件产生下面的结果

job        grade
AD_PRES    A
ST_MAN     B
IT_PROG    C
SA_REP     D
ST_CLERK   E

last_name    job_id    grade
k_ing        AD_PRES     A

```sql
-- 使用 CASE-WHEN, 按照条件产生下面的结果
-- last_name    job_id    grade
-- k_ing        AD_PRES     A
SELECT
  last_name,
  job_id,
  CASE
    job_id
    WHEN 'AD_PRES' THEN 'A'
    WHEN 'ST_MAN' THEN 'B'
    WHEN 'IT_PROG' THEN 'C'
    WHEN 'SA_REP' THEN 'D'
    WHEN 'ST_CLERK' THEN 'E'
  END AS `grade`
FROM
  employees
WHERE
  last_name = 'k_ing'
  AND job_id = 'AD_PRES';
```

