-- 进阶8: 分页查询

-- 查询前 5 条员工的信息
SELECT *
FROM employees
LIMIT 0, 5;

-- 查询第 11 条到第 25 条
SELECT *
FROM employees
LIMIT 10, 15;

-- 有奖金的员工信息, 并且工资较高的前 10 名
SELECT *
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC
LIMIT 10;


-- 练习

-- 查询工资最低的员工信息: last_name, salary
SELECT last_name, salary
FROM employees
WHERE salary = (
	SELECT MIN(salary)
	FROM employees
);

-- 查询平均工资最低的部门信息
SELECT d_avg.department_id, d_avg.avg_salary
FROM (
    SELECT department_id, AVG(salary) avg_salary
    FROM employees
    GROUP BY department_id
) d_avg
-- ! Invalid use of group function
-- ? 为什么不可以这样写
WHERE d_avg.avg_salary = MIN(d_avg.avg_salary);

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
)

SELECT d.*
FROM departments d
WHERE d.department_id = (
        SELECT department_id
        FROM employees
        GROUP BY department_id
        ORDER BY AVG(salary) ASC
        LIMIT 1
);

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

-- 查询平均工资高于公司平均工资的部门
SELECT department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);

-- 查询公司中所有 manager 的详细信息
SELECT e.*
FROM employees e
WHERE e.employee_id IN (
    SELECT DISTINCT manager_id
    FROM employees
);

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

-- 查询平均工资最高的部门的 manager 的 last_name, department_id, email, salary
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


-- 练习
-- 查询每个专业的学生人数
SELECT majorid, COUNT(*)
FROM student
GROUP BY majorid; 

-- 查询参加考试的学生中, 每个学生的平均分, 最高分
SELECT studentno, AVG(score), MAX(score)
FROM result
GROUP BY studentno;

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

-- 查询生日在 '1998-1-1' 后的学生姓名, 专业名称
SELECT s.studentname, m.majorname
FROM student s
    INNER JOIN major m ON s.majorid = m.majorid
WHERE DATEDIFF(borndate, '1998-1-1') > 0;

-- 查询每个专业的男生人数和女生人数分别是多少
-- 方法一
SELECT majorid, sex, COUNT(*)
FROM student
GROUP BY majorid, sex

-- 方法二
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

-- 按邮箱位数分组, 查询每组的学生个数
SELECT LENGTH(email), COUNT(*)
FROM student
GROUP BY LENGTH(email);

-- 查询学生名, 专业名, 分数
-- ! 因为 score 中有 NULL, 所以使用 LEFT 而不是 INNER
SELECT s.studentname, m.majorname, r.score
FROM student s
    LEFT JOIN major m ON s.majorid = m.majorid
    LEFT JOIN result r ON s.studentno = r.studentno;

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
