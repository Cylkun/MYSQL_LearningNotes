-- 进阶9: 联合查询

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

