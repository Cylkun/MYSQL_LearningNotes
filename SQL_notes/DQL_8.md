# 进阶八: 分页查询

应用场景: 要查询的数据太多, 一页显示不全, 需要分页提交 sql 请求

语法: 

```sql
SELECT 查询列表
FROM 表1
[JOIN <type> 表2 ON 连接条件]
[WHERE 筛选条件]
[GROUP BY 分组字段]
[HAVING 分组后筛选]
[ORDER BY 排序的字段]
LIMIT [offset, ]size;
```

`offset`: 要显示条目的起始索引 (起始索引从 0 开始), 可以省略, 若省略则默认为 0
`size`: 要显示的条目个数

特点: 

1. LIMIT 语句放在查询语句的最后
2. 要显示的页号 page, 每页的条目数 size, 该页的起始索引 = (page - 1) * size

## 案例

查询前 5 条员工的信息

```sql
-- 查询前 5 条员工的信息
SELECT *
FROM employees
LIMIT 0, 5;
```

查询第 11 条到第 25 条

```sql
-- 查询第 11 条到第 25 条
SELECT *
FROM employees
LIMIT 10, 15;
```

有奖金的员工信息, 并且工资较高的前 10 名

```sql
-- 有奖金的员工信息, 并且工资较高的前 10 名
SELECT *
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC
LIMIT 10;
```


## 练习1

已知 `表 stuinfo` 和 `表 grade`
`表 stuinfo` 包含: 学号 id, 姓名 name, 邮箱 email, 年级编号 gradeId, 性别 sex : 男, 女, 年龄 age
`表 grade` 包含: 年级编号 id, 年级名称 gradeName


查询所有学员的邮箱的用户名 (注: 邮箱中 @ 前面的部分)

```sql
-- 查询所有学员的邮箱的用户名 (注: 邮箱中 @ 前面的部分)
SELECT SUBSTR(email, 1, INSTR(email, '@') - 1) AS `name`
FROM stuinfo;
```

查询男生和女生的个数

```sql
-- 查询男生和女生的个数
SELECT sex, COUNT(*)
FROM stuinfo
GROUP BY sex;
```

查询年龄 >18 岁的所有学生的姓名和年级名称

```sql
-- 查询年龄 >18 岁的所有学生的姓名和年级名称
SELECT s.name, g.gradeName
FROM stuinfo s
	INNER JOIN grade g ON s.gradeId = g.id
WHERE s.age > 18;
```

查询哪个年级的学生最小年龄 >20 岁

```sql
-- 查询哪个年级的学生最小年龄 >20 岁
SELECT gradeId
FROM stuinfo
GROUP BY gradeId
HAVING MIN(age) > 20

-- 不知道我自己写的对不对
SELECT g.gradeName
FROM grade g
	INNER JOIN stuinfo s ON g.id = s.gradeId
GROUP BY g.gradeName
HAVING MIN(s.age) > 20
```

试说出查询语句中涉及到的所有的关键字, 以及执行先后顺序

```sql
-- 试说出查询语句中涉及到的所有的关键字, 以及执行先后顺序
-- 执行顺序 ①②③④⑤⑥⑦⑧⑨
SELECT 查询列表          ⑦ 选需要查看的列
FROM 表1                ① 生成虚拟表, 锁定数据源
	连接类型 JOIN 表2     ② 两表连接, 形成了一个笛卡尔乘积的大表
	ON 连接条件          ③ 在大表的基础上进行筛选, 将满足条件的筛选出来, 形成新的虚拟表
WHERE 筛选条件           ④ 筛选
GROUP BY 分组列表        ⑤ 分组
HAVING 分组后的筛选       ⑥ 筛选
ORDER BY 排序列表        ⑧ 在 ⑦ 的基础上排序
LIMIT 偏移, 条目数       ⑨ 分页显示

-- 自己写的
SELECT ...
FROM ...
	INNER/LEFT/RIGHT/FULL/CROSS JOIN ... ON ...
WHERE ...
GROUP BY ...
HAVING ... 
ORDER BY ...
LIMIT ...
```


## 练习2

查询每个专业的学生人数

```sql
-- 查询每个专业的学生人数
SELECT majorid, COUNT(*)
FROM student
GROUP BY majorid; 
```

查询参加考试的学生中, 每个学生的平均分, 最高分

```sql
-- 查询参加考试的学生中, 每个学生的平均分, 最高分
SELECT studentno, AVG(score), MAX(score)
FROM result
GROUP BY studentno;
```

查询姓张的每个学生的最低分大于 60 的学号, 姓名

```sql
-- 查询每个姓张的学生的最低分大于 60 的学号, 姓名
-- 方法一
SELECT studentno, studentname
FROM student
WHERE studentname LIKE '张%'
    AND studentno IN (
        SELECT studentno
        FROM result
        GROUP BY studentno
        HAVING MIN(score) > 60
);

-- 方法二
SELECT s.studentno, s.studentname, MIN(r.score)
FROM student s
    INNER JOIN result r ON s.studentno = r.studentno
WHERE s.studentname LIKE '张%'
GROUP BY s.studentno
HAVING MIN(r.score) > 60;
```

查询生日在 '1998-1-1' 后的学生姓名, 专业名称

```sql
-- 查询生日在 '1998-1-1' 后的学生姓名, 专业名称
SELECT s.studentname, m.majorname
FROM student s
    INNER JOIN major m ON s.majorid = m.majorid
WHERE DATEDIFF(borndate, '1998-1-1') > 0;
```

查询每个专业的男生人数和女生人数分别是多少

```sql
SELECT
    majorid,
    (
        SELECT COUNT(*)
        FROM student
        WHERE sex = '男'
            AND majorid = s.majorid
    ) 男,
    (
        SELECT COUNT(*)
        FROM student
        WHERE sex = '女'
            AND majorid = s.majorid
    ) 女
FROM student s
GROUP BY majorid;
```

查询专业和张翠山一样的学生的最低分

```sql
-- 查询专业和张翠山一样的学生的最低分
-- 方法一
SELECT MIN(r.score)
FROM student s
    INNER JOIN result r ON s.studentno = r.studentno
WHERE majorid = (
    SELECT majorid
    FROM student
    WHERE studentname = '张翠山'
);

-- 方法二 ()
SELECT MIN(score)
FROM result
WHERE studentno IN (
    SELECT studentno
    FROM student
    WHERE majorid IN (
        SELECT majorid
        FROM student
        WHERE studentname = '张翠山'
    )
);
```

查询大于 60 分的学生的姓名, 密码, 专业名

```sql
-- 查询大于 60 分的学生的姓名, 密码, 专业名
-- 方法一
SELECT s.studentname, s.loginpwd, m.majorname
FROM student s
    INNER JOIN major m ON s.majorid = m.majorid
WHERE studentno IN (
    SELECT studentno
    FROM result
    WHERE score > 60;
)

-- 方法二
SELECT s.studentname, s.loginpwd, m.majorname
FROM student s
    INNER JOIN major m ON s.majorid = m.majorid
    INNER JOIN result r ON s.studentno = r.studentno
WHERE r.score > 60;
```

按邮箱位数分组, 查询每组的学生个数

```sql
-- 按邮箱位数分组, 查询每组的学生个数
SELECT LENGTH(email), COUNT(*)
FROM student
GROUP BY LENGTH(email);
```

查询学生名, 专业名, 分数

```sql
-- 查询学生名, 专业名, 分数
-- ! 因为 score 中有 NULL, 所以使用 LEFT 而不是 INNER
SELECT s.studentname, m.majorname, r.score
FROM student s
    LEFT JOIN major m ON s.majorid = m.majorid
    LEFT JOIN result r ON s.studentno = r.studentno;
```

查询哪个专业没有学生, 分别用左外连接和右外连接实现

```sql
-- 查询哪个专业没有学生, 分别用左外连接和右外连接实现
SELECT m.majorname
FROM major m
    LEFT JOIN student s ON m.majorid = s.majorid
GROUP BY m.majorid
HAVING COUNT(*) = 0;
-- 查不到, 因为所有专业都有学生

-- 方法二
SELECT m.majorname
FROM student s
    RIGHT JOIN major m ON m.majorid = s.majorid
WHERE s.studentno IS NULL;
```

查询没有成绩的学生人数

```sql
-- 查询没有成绩的学生人数
-- ! 下面的是错误的, 因为 result 中只包含有成绩的 studentno
SELECT COUNT(*)
FROM student
WHERE studentno IN (
    SELECT studentno
    FROM result
    WHERE score IS NULL
);

-- * 正确方法
SELECT COUNT(*)
FROM student s
    LEFT JOIN result r ON s.studentno = r.studentno
WHERE r.score IS NULL;
```
