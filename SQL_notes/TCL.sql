-- TCL

-- 显示 mysql 支持的存储引擎/表类型
SHOW ENGINES;

-- 查看 `autocommit`
SHOW VARIABLES LIKE 'autocommit';

-- 关闭 `autocommit` (只对当前会话有效)
SET autocommit = 0;


CREATE TABLE account(
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(20),
    balance DOUBLE
);

INSERT INTO
    account(username, balance)
VALUES
    ('张无忌', 1000),
    ('赵敏', 1000);

SELECT * FROM `account`;

-- 开启事务
SET autocommit = 0;
START TRANSACTION;

-- 编写一组事务的语句
UPDATE `account` 
SET balance = 500 
WHERE username = '张无忌';

UPDATE `account` 
SET balance = 1500 
WHERE username = '赵敏';

-- 结束事务: 提交
COMMIT;


-- 编写一组事务的语句
UPDATE `account` 
SET balance = 1000 
WHERE username = '张无忌';

UPDATE `account` 
SET balance = 1000 
WHERE username = '赵敏';

-- 结束事务: 回滚
ROLLBACK;


-- 保存点
SELECT * FROM `account`;
UPDATE account SET username = 'john' WHERE id = 3;
SAVEPOINT a;  -- 设置保存点
UPDATE account SET username = 'lily' WHERE id = 4;
ROLLBACK TO a;  -- 回滚到 a
SELECT * FROM `account`;

SET autocommit = 1;
SHOW VARIABLES LIKE 'autocommit';



-- 视图
-- 查询姓张的学生名和专业名
CREATE VIEW v1 AS
    SELECT stuname, majorname
    FROM stuinfo s
        INNER JOIN major m ON s.majorid = m.id;

SELECT * FROM v1 WHERE stuname LIKE '张%';

-- 创建视图
-- 查询 last_name 中包含 a 字符的 last_nmae, 部门名, 工种信息
CREATE VIEW myv1 AS
    SELECT e.last_name, d.department_name, j.job_title
    FROM employees e
        INNER JOIN departments d ON e.department_id = d.department_id
        INNER JOIN jobs j ON e.job_id = j.job_id;

SELECT *
FROM myv1
WHERE last_name LIKE '%a%';

-- 查询各部门的平均工资级别
CREATE VIEW myv2 AS
    SELECT d.department_id, d.department_name, AVG(e.salary) avg_salary
    FROM employees e
        INNER JOIN departments d ON e.department_id = d.department_id
    GROUP BY e.department_id;
-- ! 如果不使用连接, 直接使用 department_id 而不是 department_name, 则会多一行 department_id 为 NULL

SELECT v2.department_name, g.grade_level
FROM myv2 v2
    INNER JOIN job_grades g ON v2.avg_salary BETWEEN g.lowest_sal AND g.highest_sal;

--- 查询平均工资最低的部门信息
SELECT *
FROM departments d
WHERE d.department_id IN (
    SELECT department_id
    FROM myv2
    WHERE avg_salary = (
        SELECT MIN(avg_salary)
        FROM myv2
    )
);

-- 使用排序和限查找制最低平均工资
SELECT avg_salary
FROM myv2
ORDER BY avg_salary
LIMIT 1;
-- ! 除非最值行唯一, 不然不可用


-- 查询平均工资最低的部门名和工资
CREATE VIEW myv3 AS
    SELECT *
    FROM myv2
    WHERE avg_salary = (
        SELECT MIN(avg_salary)
        FROM myv2
    );

SELECT department_name, avg_salary
FROM myv3;

-- 视图的修改
-- 方式一
CREATE OR REPLACE VIEW myv3 AS
    SELECT job_id, AVG(salary)
    FROM employees
    GROUP BY job_id;

-- 方式二
ALTER VIEW myv3 AS
    SELECT job_id, AVG(salary) avg_salary
    FROM employees
    GROUP BY job_id;

-- 查看视图结构
DESC myv3;

-- 查看视图创建细节 (在命令行使用会显示更多细节)
SHOW CREATE VIEW myv3;

-- 删除视图
DROP VIEW myv1, myv2, myv3;


-- 练习
-- 创建视图 emp_v1,要求查询电话号码以‘011’开头的员工姓名和工资、邮箱
CREATE VIEW emp_v1 AS  -- CREATE OR REPLACE VIEW emp_v1 AS
    SELECT last_name, salary, email
    FROM employees
    WHERE phone_number LIKE '011%';


-- 创建视图 emp_v2, 要求查询部门的最高工资高于 12000 的部门信息
CREATE VIEW emp_v2 AS
    SELECT d.*
    FROM departments d
    WHERE d.department_id IN(
        SELECT e.department_id
        FROM employees e
        GROUP BY e.department_id
        HAVING MAX(e.salary) > 12000
    );

-- 方法二 (老师的方法)
CREATE OR REPLACE VIEW emp_v2 AS
    SELECT department_id, MAX(salary) mx_dep
    FROM employees
    GROUP BY department_id
    HAVING MAX(salary) > 12000;

SELECT d.*, m.mx_dep
FROM departments d
    JOIN emp_v2 m ON m.department_id = d.`department_id`;


-- 视图的更新
CREATE OR REPLACE VIEW myv1 AS 
	SELECT
	    last_name,
	    email,
	    salary * 12 *(1 + IFNULL(commission_pct, 0)) "annual salary"
	FROM employees; 

SELECT * FROM myv1;

-- ! 
-- 插入
INSERT INTO myv1 VALUES('张飞', 'zf@xx.com', 100000);
INSERT INTO myv1 VALUES('张飞', 'zf@xx.com');

-- 修改
UPDATE myv1 SET last_name = '张无忌'
WHERE last_name = '张飞';

-- 删除
DELETE FROM myv1 WHERE last_name = '张无忌';

select version();

-- 练习



