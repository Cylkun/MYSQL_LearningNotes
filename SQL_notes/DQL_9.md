# 进阶九: 联合查询

UNION: 将多条查询语句的结果合并成一个结果

应用场景

要查询的结果来自多个表, 且多个表没有直接的连接关系, 但查询的信息一致 (查询的信息一致指的是 `SELECT` 后面的东西即使名字不一样但是是同一种东西, 相互对应)

意义:

1. 将一条比较复杂的查询语句拆分成多条语句
2. 适用于查询多个表的时候, 查询的列基本一致

特点

1. 要求多条查询语句的查询列表数是一致的
2. 要求多条查询语句的查询的每一列的类型和顺序最好一致
3. `UNION` 关键字默认去重, `UNION ALL` 可以包含重复项

## 案例

引例: 查询部门编号 > 90 或邮箱包含 a 的员工信息

```sql
-- 引例: 查询部门编号 > 90 或邮箱包含 a 的员工信息
SELECT *
FROM employees
WHERE department_id > 90
    OR email LIKE '%a%';

SELECT *
FROM employees
WHERE department_id > 90
UNION
SELECT *
FROM employees
WHERE email LIKE '%a%';
```

查询中国用户中男性的信息以及外国用户中年男性的用户信息

t_ca: 

- id, int (11)
- cname, varchar (20), Nullable
- csex, varchar (1), Nullable

t_ua: 

- t_id, int (11)
- tName, varchar (20), Nullable
- tGender, varchar (10), Nullable

```sql
-- 查询中国用户中男性的信息以及外国用户中年男性的用户信息
SELECT id, cname FROM t_ca WHERE csex = '男'
UNION
SELECT t_id, tname FROM t_ua WHERE csex = 'male'
```



## 语法

```sql
查询语句 1
UNION
查询语句 2
UNION
...
```
