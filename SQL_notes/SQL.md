# 数据库

## 数据库的好处

1. 可以持久化数据到本地
2. 结构化查询

## 数据库的常见概念 ⭐

1. DB: Database, 数据库, 存储数据的容器
2. DBMS: Database Management System, 数据库管理系统, 数据库软件或者数据库产品, 用于创建或管理DB
3. SQL: Structured Query Language, 结构化查询语言, 用于和数据库通信的语言, 不是某个数据库软件特有的, 而是几乎所有的主流数据库软件通用的语言

## 数据库存储数据的特点

1. 数据存放到表中, 然后表再放到库中
2. 一个库中可以有多张表, 每张表具有唯一的表名来标识自己
3. 表中有一个或多个列, 列又称为 "字段", 相当于 Java 中的 "属性"
4. 表中的每一行数据, 相当于 Java 中的 "对象"

## 常见的数据库管理系统

1. MySQL
2. Oracle
3. Microsoft SQL Server
4. DB2
5. MongoDB
6. PostgreSQL

## MySQL

### MySQL 的背景

瑞典公司
08年被 SUM 收购
09年被 Oracle 收购

### MySQL 优点

1. 开源, 免费, 成本低
2. 性能高, 移植性好
3. 体积小, 便于安装

### MySQL 介绍

属于 C/S 架构
两个版本: 社区版, 企业版



### MYSQL 服务的启动和关闭

命令行 (以管理员身份运行)

```shell
(base) PS C:\Users\CYLK_> net stop mysql80
MySQL80 服务正在停止.
MySQL80 服务已成功停止。

(base) PS C:\Users\CYLK_> net start mysql80
MySQL80 服务正在启动 .
MySQL80 服务已经启动成功。
```


### 服务端登录和退出

1. MySQL 8.0 command line client 窗口退出 `exit` (只适用 root 用户)

2. 命令行进入

```shell
# 两种写法都可以
(base) PS C:\Users\CYLK_> mysql -h localhost -P 3306 -u root -p
(base) PS C:\Users\CYLK_> mysql -h localhost -P 3306 -u root -pcylk
(base) PS C:\Users\CYLK_> mysql -u root -pcylk

# -h localhost <=> -hlocalhost  主机
# -P 3306 <=> -P3306  端口号
# -u root <=>  -uroot  用户名
# -pcylk 不能写成 -p cylk  密码
```

`exit` 退出


### 查看 SQL 版本

1. 命令行查看

```shell
(base) PS C:\Users\CYLK_> mysql --version
C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe  Ver 8.0.28 for Win64 on x86_64 (MySQL Community Server - GPL)

(base) PS C:\Users\CYLK_> mysql -V
C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe  Ver 8.0.28 for Win64 on x86_64 (MySQL Community Server - GPL)
```

2. 进入 MYSQL 之后查看

```sql
mysql> select version();
+-----------+
| version() |
+-----------+
| 8.0.28    |
+-----------+
1 row in set (0.00 sec)
```

## 常用命令

### 查看所有用户

```sql
mysql> select user, host from mysql.user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| CYLK             | %         |
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
| root             | localhost |
+------------------+-----------+
5 rows in set (0.00 sec)
```


### 查看数据库

```sql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sakila             |
| sys                |
| world              |
+--------------------+
6 rows in set (0.00 sec)
```

### 查看数据库的表

1. 进入数据库并查看表

```sql
mysql> use world;
Database changed
mysql> show tables;
+-----------------+
| Tables_in_world |
+-----------------+
| city            |
| country         |
| countrylanguage |
+-----------------+
3 rows in set (0.00 sec)
```

2. 未进入数据库, 只是查看表

```sql
mysql> show tables from mysql;
+------------------------------------------------------+
| Tables_in_mysql                                      |
+------------------------------------------------------+
| columns_priv                                         |
| component                                            |
| db                                                   |
| default_roles                                        |
| engine_cost                                          |
| func                                                 |
| general_log                                          |
| global_grants                                        |
| gtid_executed                                        |
| help_category                                        |
| help_keyword                                         |
| help_relation                                        |
| help_topic                                           |
| innodb_index_stats                                   |
| innodb_table_stats                                   |
| password_history                                     |
| plugin                                               |
| procs_priv                                           |
| proxies_priv                                         |
| replication_asynchronous_connection_failover         |
| replication_asynchronous_connection_failover_managed |
| replication_group_configuration_version              |
| replication_group_member_actions                     |
| role_edges                                           |
| server_cost                                          |
| servers                                              |
| slave_master_info                                    |
| slave_relay_log_info                                 |
| slave_worker_info                                    |
| slow_log                                             |
| tables_priv                                          |
| time_zone                                            |
| time_zone_leap_second                                |
| time_zone_name                                       |
| time_zone_transition                                 |
| time_zone_transition_type                            |
| user                                                 |
+------------------------------------------------------+
37 rows in set (0.00 sec)
```

3. 查看当前位置

```sql
mysql> select database();
+------------+
| database() |
+------------+
| world      |
+------------+
1 row in set (0.00 sec)
```

4. 显示表的结构

```sql
mysql> desc city;
+-------------+----------+------+-----+---------+----------------+
| Field       | Type     | Null | Key | Default | Extra          |
+-------------+----------+------+-----+---------+----------------+
| ID          | int      | NO   | PRI | NULL    | auto_increment |
| Name        | char(35) | NO   |     |         |                |
| CountryCode | char(3)  | NO   | MUL |         |                |
| District    | char(20) | NO   |     |         |                |
| Population  | int      | NO   |     | 0       |                |
+-------------+----------+------+-----+---------+----------------+
5 rows in set (0.03 sec)
```

5. 查看数据

```sql
mysql> select * from city;
```

7. 创建表

`varchar`: 字符串

```sql
mysql> create table newtable(
    -> id int,
    -> name varchar(20));
Query OK, 0 rows affected (0.07 sec)

mysql> show tables;
+-----------------+
| Tables_in_world |
+-----------------+
| city            |
| country         |
| countrylanguage |
| newtable        |
+-----------------+
4 rows in set (0.00 sec)

mysql> desc newtable;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

mysql> select * from newtable;
Empty set (0.00 sec)
```

8. 修改表名

```sql
alter table [oldname] rename to [newname];
```


## 语法规范

1. 不区分大小写 (关键字大写, 表明列名小写)
2. 每条命令分号结尾 (命令行中 `\g` 也可以)
3. 输入命令时, 建议关键字单独一行
4. 注释: 单行注释 `# XXX` 多行注释 `/* XXX */
