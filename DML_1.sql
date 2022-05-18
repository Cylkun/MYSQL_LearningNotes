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

