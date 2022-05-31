-- DML 语言
-- 插入语句
-- 经典方式
-- 插入的值的类型要与列的类型一直或兼容
INSERT INTO
    beauty(
        id,
        name,
        sex,
        borndate,
        phone,
        photo,
        boyfriend_id
    )
VALUES
    (13, '唐艺昕', '女', '1990-4-23', '18966668888', NULL, 2);

-- 不可以为 NULL 的列必须插入值, 可以为 NULL 的列如何插入值
-- 方式一
INSERT INTO
    beauty(
        id,
        name,
        sex,
        borndate,
        phone,
        photo,
        boyfriend_id
    )
VALUES
    (14, '金星', '女', NULL, '18966668888', NULL, NULL);

--方式二
INSERT INTO
    beauty( id, name, sex, phone)
VALUES
    (15, '娜扎', '女', '18966668888');

-- 列的顺序是否可以调换
INSERT INTO
    beauty(name, id, phone, sex)
VALUES
    ('蒋欣', 16, '18988889999', '女');

-- 列数和值的个数必须一致
INSERT INTO
    beauty(name, id, phone, sex)
VALUES
    ('关晓彤', 17, '18988889999', '女');

-- 可以省略类名, 默认所有列, 而且列的顺序和表中列的顺序一致
INSERT INTO beauty
VALUES
    (18, '张飞', '女', NULL, '18966668888', NULL, NULL);

-- 插入方式二
INSERT INTO beauty
SET id=19, name='刘涛', sex='女', phone='18966668888';


-- 两种方式大PK
-- 经典方式支持插入多行, 方式二不支持
INSERT INTO beauty
VALUES
    (23, '唐艺昕1', '女', '1990-4-23', '18966668888', NULL, 2),
    (24, '唐艺昕2', '女', '1990-4-23', '18966668888', NULL, 2),
    (25, '唐艺昕3', '女', '1990-4-23', '18966668888', NULL, 2);

-- 经典方式支持子查询, 方式二不支持
-- ! 没听懂, 跳过吧...
INSERT INTO beauty(id, name, phone)
SELECT 26, '宋茜', '18966668888';

INSERT INTO beauty(id, name, phone)
SELECT 26, '宋茜', '18966668888';

-- 修改语句
-- 修改单表数据
-- 修改 beauty 表中姓唐的女神的电话为 '13899888899'
UPDATE beauty
SET phone = '13899888899'
WHERE name LIKE '唐%';

-- 修改多表数据
-- 修改张无忌的女朋友的手机号为 '13811444411'
UPDATE boys bo
    INNER JOIN beauty b ON bo.id = b.boyfriend_id
SET b.phone = '13811444411'
WHERE bo.boyName = '张无忌';

-- 修改没有男朋友的女神的男朋友编号为 2
UPDATE beauty b
    LEFT JOIN boys bo ON b.boyfriend_id = bo.id
SET b.boyfriend_id = 2
WHERE bo.id IS NULL;

-- 删除
-- 方式一
-- 单表删除
-- 删除手机号以 9 结尾的女神信息
DELETE FROM beauty WHERE phone LIKE '%9';

-- 多表删除
-- 删除张无忌的女朋友的信息
DELETE b
FROM beauty b
    INNER JOIN boys bo ON b.boyfriend_id = bo.id
WHERE bo.boyName = '张无忌';

-- 删除黄晓明和他女朋友的信息
DELETE b, bo
FROM beauty b
    INNER JOIN boys bo ON b.boyfriend_id = bo.id
WHERE bo.boyName = '黄晓明';

-- 方式二: TRUNCATE
-- 删除 boys 表
TRUNCATE TABEL boys;

-- 练习
-- 运行以下脚本创建表 my_employees
USE myemployees;
CREATE TABLE my_employees(
	Id INT(10),
	First_name VARCHAR(10),
	Last_name VARCHAR(10),
	Userid VARCHAR(10),
	Salary DOUBLE(10,2)
);
CREATE TABLE users(
	id INT,
	userid VARCHAR(10),
	department_id INT

);
-- 显示表 my_employees的结构
DESC my_employees;
-- SELECT * FROM my_employees;

-- 向 my_employees 中插入下列数据
-- ID    FIRST_NAME    LAST_NAME    USERID    SALARY
-- 1     patel         Ralph        Rpatel    895
-- 2     Dancs         Betty        Bdancs    860
-- 3     Biri          Ben          Bbiri     1100
-- 4     Newman        Chad         Cnewman   750
-- 5     Ropeburn      Audrey       Aropebur  1550
-- 方式一:
INSERT INTO my_employees
VALUES
    (1, 'patel', 'Ralph', 'Rpatel', 895),
    (2, 'Dancs', 'Betty', 'Bdancs', 860),
    (3, 'Biri', 'Ben', 'Bbiri', 1100),
    (4, 'Newman', 'Chad', 'Cnewman', 750),
    (5, 'Ropeburn', 'Audrey', 'Aropebur', 1550);
-- DELETE FROM my_employees;

-- 方式二: 加入联合查询
INSERT INTO my_employees
SELECT 1, 'patel', 'Ralph', 'Rpatel', 895
UNION
SELECT 2, 'Dancs', 'Betty', 'Bdancs', 860
UNION
SELECT 3, 'Biri', 'Ben', 'Bbiri', 1100
UNION
SELECT 4, 'Newman', 'Chad', 'Cnewman', 750
UNION
SELECT 5, 'Ropeburn', 'Audrey', 'Aropebur', 1550;

-- 向 users 表中插入数据
-- 1    Rpatel      10
-- 2    Bdancs      10
-- 3    Bbiri       20
-- 4    Cnewman     30
-- 5    Aropebur    40
INSERT INTO users
VALUES
    (1, 'Rpatel', 10),
    (2, 'Bdancs', 10),
    (3, 'Bbiri', 20),
    (4, 'Cnewman', 30),
    (5, 'Aropebur', 40);

-- 将 3 号员工的 last_name 修改为 “drelxer”
UPDATE my_employees
SET Last_name = "drelxer"
WHERE Id = 3;

-- 将所有工资少于 900 的员工的工资修改为 1000
UPDATE my_employees
SET salary = 1000
WHERE salary < 900;

-- 将 users 中 userid 为 Bbiri 的记录从 users 表和 my_employees 表中删除
DELETE u, m
FROM users u
	INNER JOIN my_employees m ON u.userid = m.Userid
WHERE u.userid = 'Bbiri';

-- 删除所有数据
DELETE FROM my_employees;
DELETE FROM users;

-- 检查所作的修正 (查看表信息)
SELECT * FROM my_employees;
SELECT * FROM users;

-- 清空表 my_employees
TRUNCATE TABLE my_employees;
