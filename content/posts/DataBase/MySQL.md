---
title: "关于 MySQL 的一些笔记"
date: 2021-12-23
author: MelonCholi
draft: false
tags: [数据库,快速入门,MySQL]
categories: [数据库]
---

# MySQL 学习笔记

## 登录和退出 MySQL 服务器

```shell
# 登录MySQL
mysql -u [username] -p[password]

# 远程连接
mysql -h [host] -P [port] -u [username] -p[password]

# 退出MySQL数据库服务器
exit;
```

## 基本语法

```mysql
-- 显示所有数据库
show databases;

-- 创建数据库
CREATE DATABASE test;

-- 切换数据库
use test;

-- 显示数据库中的所有表
show tables;

-- 创建数据表
CREATE TABLE pet (
    name VARCHAR(20),
    owner VARCHAR(20),
    species VARCHAR(20),
    sex CHAR(1),
    birth DATE,
    death DATE
);

-- 查看数据表结构
-- describe pet;
desc pet;

-- 查询表
SELECT * from pet;

-- 插入数据
INSERT INTO pet VALUES ('puffball', 'Diane', 'hamster', 'f', '1990-03-30', NULL);

-- 修改数据
UPDATE pet SET name = 'squirrel' WHERE owner = 'Diane';

-- 删除数据
DELETE FROM pet WHERE name = 'squirrel';

-- 删除表
DROP TABLE myorder;
```

## 建表约束

### 主键约束

```mysql
-- 主键约束
-- 使某个字段不重复且不得为空，确保表内所有数据的唯一性。
CREATE TABLE user (
    id INT PRIMARY KEY,
    name VARCHAR(20)
);

-- 联合主键
-- 联合主键中的每个字段都不能为空，并且加起来不能和已设置的联合主键重复。
CREATE TABLE user (
    id INT,
    name VARCHAR(20),
    password VARCHAR(20),
    PRIMARY KEY(id, name)
);

-- 自增约束
-- 自增约束的主键由系统自动递增分配。
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20)
);

-- 添加主键约束
-- 如果忘记设置主键，还可以通过SQL语句设置（两种方式）：
ALTER TABLE user ADD PRIMARY KEY(id);
ALTER TABLE user MODIFY id INT PRIMARY KEY;

-- 删除主键
ALTER TABLE user drop PRIMARY KEY;
```

### 唯一约束

```mysql
-- 建表时创建唯一约束
CREATE TABLE user (
    id INT,
    name VARCHAR(20),
    UNIQUE(name)
);

-- 添加唯一约束
-- 如果建表时没有设置唯一约束，还可以通过SQL语句设置（两种方式）：
ALTER TABLE user ADD UNIQUE(name);
ALTER TABLE user MODIFY name VARCHAR(20) UNIQUE;

-- 删除唯一约束
ALTER TABLE user DROP INDEX name;
```

### 非空约束

```mysql
-- 建表时添加非空约束
-- 约束某个字段不能为空
CREATE TABLE user (
    id INT,
    name VARCHAR(20) NOT NULL
);

-- 移除非空约束
ALTER TABLE user MODIFY name VARCHAR(20);
```

### 默认约束

```mysql
-- 建表时添加默认约束
-- 约束某个字段的默认值
CREATE TABLE user2 (
    id INT,
    name VARCHAR(20),
    age INT DEFAULT 10
);

-- 移除非空约束
ALTER TABLE user MODIFY age INT;
```

### 外键约束

```mysql
-- 班级
CREATE TABLE classes (
    id INT PRIMARY KEY,
    name VARCHAR(20)
);

-- 学生表
CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(20),
    -- 这里的 class_id 要和 classes 中的 id 字段相关联
    class_id INT,
    -- 表示 class_id 的值必须来自于 classes 中的 id 字段值
    FOREIGN KEY(class_id) REFERENCES classes(id)
);

-- 1. 主表（父表）classes 中没有的数据值，在副表（子表）students 中，是不可以使用的；
-- 2. 主表中的记录被副表引用时，主表不可以被删除。
```

## 数据库的三大设计范式

### 1NF

所有字段值都是不可再分的原子值

只要字段值还可以继续拆分，就不满足第一范式。

范式设计得越详细，对某些实际操作可能会更好，但并非都有好处，需要对项目的实际情况进行设定。

### 2NF

在满足第一范式的前提下，**其他列都必须完全依赖于主键列**。如果出现不完全依赖，只可能发生在联合主键的情况下：

```mysql
-- 订单表
CREATE TABLE myorder (
    product_id INT,
    customer_id INT,
    product_name VARCHAR(20),
    customer_name VARCHAR(20),
    PRIMARY KEY (product_id, customer_id)
);
```

实际上，在这张订单表中，`product_name` 只依赖于 `product_id` ，`customer_name` 只依赖于 `customer_id` 。也就是说，`product_name` 和 `customer_id` 是没用关系的，`customer_name` 和 `product_id` 也是没有关系的。

这就不满足第二范式：其他列都必须完全依赖于主键列！

```mysql
CREATE TABLE myorder (
    order_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT
);

CREATE TABLE product (
    id INT PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE customer (
    id INT PRIMARY KEY,
    name VARCHAR(20)
);
```

拆分之后，`myorder` 表中的 `product_id` 和 `customer_id` 完全依赖于 `order_id` 主键，而 `product` 和 `customer` 表中的其他字段又完全依赖于主键。满足了第二范式的设计！

### 3NF

在满足第二范式的前提下，**除了主键列之外，其他列之间不能有传递依赖关系**。

```mysql
CREATE TABLE myorder (
    order_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    customer_phone VARCHAR(15)
);
```

表中的 `customer_phone` 有可能依赖于 `order_id` 、 `customer_id` 两列，也就不满足了第三范式的设计：其他列之间不能有传递依赖关系。

```mysql
CREATE TABLE myorder (
    order_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT
);

CREATE TABLE customer (
    id INT PRIMARY KEY,
    name VARCHAR(20),
    phone VARCHAR(15)
);
```

修改后就不存在其他列之间的传递依赖关系，其他列都只依赖于主键列，满足了第三范式的设计！

## 查询练习

### 准备数据

```mysql
-- 创建数据库
CREATE DATABASE select_test;
-- 切换数据库
USE select_test;

-- 创建学生表
CREATE TABLE student (
    no VARCHAR(20) PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    sex VARCHAR(10) NOT NULL,
    birthday DATE, -- 生日
    class VARCHAR(20) -- 所在班级
);

-- 创建教师表
CREATE TABLE teacher (
    no VARCHAR(20) PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    sex VARCHAR(10) NOT NULL,
    birthday DATE,
    profession VARCHAR(20) NOT NULL, -- 职称
    department VARCHAR(20) NOT NULL -- 部门
);

-- 创建课程表
CREATE TABLE course (
    no VARCHAR(20) PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    t_no VARCHAR(20) NOT NULL, -- 教师编号
    -- 表示该 tno 来自于 teacher 表中的 no 字段值
    FOREIGN KEY(t_no) REFERENCES teacher(no) 
);

-- 成绩表
CREATE TABLE score (
    s_no VARCHAR(20) NOT NULL, -- 学生编号
    c_no VARCHAR(20) NOT NULL, -- 课程号
    degree DECIMAL,	-- 成绩
    -- 表示该 s_no, c_no 分别来自于 student, course 表中的 no 字段值
    FOREIGN KEY(s_no) REFERENCES student(no),	
    FOREIGN KEY(c_no) REFERENCES course(no),
    -- 设置 s_no, c_no 为联合主键
    PRIMARY KEY(s_no, c_no)
);

-- 查看所有表
SHOW TABLES;

-- 添加学生表数据
INSERT INTO student VALUES('101', '曾华', '男', '1977-09-01', '95033');
INSERT INTO student VALUES('102', '匡明', '男', '1975-10-02', '95031');
INSERT INTO student VALUES('103', '王丽', '女', '1976-01-23', '95033');
INSERT INTO student VALUES('104', '李军', '男', '1976-02-20', '95033');
INSERT INTO student VALUES('105', '王芳', '女', '1975-02-10', '95031');
INSERT INTO student VALUES('106', '陆军', '男', '1974-06-03', '95031');
INSERT INTO student VALUES('107', '王尼玛', '男', '1976-02-20', '95033');
INSERT INTO student VALUES('108', '张全蛋', '男', '1975-02-10', '95031');
INSERT INTO student VALUES('109', '赵铁柱', '男', '1974-06-03', '95031');

-- 添加教师表数据
INSERT INTO teacher VALUES('804', '李诚', '男', '1958-12-02', '副教授', '计算机系');
INSERT INTO teacher VALUES('856', '张旭', '男', '1969-03-12', '讲师', '电子工程系');
INSERT INTO teacher VALUES('825', '王萍', '女', '1972-05-05', '助教', '计算机系');
INSERT INTO teacher VALUES('831', '刘冰', '女', '1977-08-14', '助教', '电子工程系');

-- 添加课程表数据
INSERT INTO course VALUES('3-105', '计算机导论', '825');
INSERT INTO course VALUES('3-245', '操作系统', '804');
INSERT INTO course VALUES('6-166', '数字电路', '856');
INSERT INTO course VALUES('9-888', '高等数学', '831');

-- 添加添加成绩表数据
INSERT INTO score VALUES('103', '3-105', '92');
INSERT INTO score VALUES('103', '3-245', '86');
INSERT INTO score VALUES('103', '6-166', '85');
INSERT INTO score VALUES('105', '3-105', '88');
INSERT INTO score VALUES('105', '3-245', '75');
INSERT INTO score VALUES('105', '6-166', '79');
INSERT INTO score VALUES('109', '3-105', '76');
INSERT INTO score VALUES('109', '3-245', '68');
INSERT INTO score VALUES('109', '6-166', '81');

-- 查看表结构
SELECT * FROM course;
SELECT * FROM score;
SELECT * FROM student;
SELECT * FROM teacher;
```

### 1 到 10

```mysql
-- 查询 student 表的所有行
SELECT * FROM student;

-- 查询 student 表中的 name、sex 和 class 字段的所有行
SELECT name, sex, class FROM student;

-- 查询 teacher 表中不重复的 department 列
-- department: 去重查询
SELECT DISTINCT department FROM teacher;

-- 查询 score 表中成绩在60-80之间的所有行（区间查询和运算符查询）
-- BETWEEN xx AND xx: 查询区间, AND 表示 "并且"
SELECT * FROM score WHERE degree BETWEEN 60 AND 80;
SELECT * FROM score WHERE degree > 60 AND degree < 80;

-- 查询 score 表中成绩为 85, 86 或 88 的行
-- IN: 查询规定中的多个值
SELECT * FROM score WHERE degree IN (85, 86, 88);

-- 查询 student 表中 '95031' 班或性别为 '女' 的所有行
-- or: 表示或者关系
SELECT * FROM student WHERE class = '95031' or sex = '女';

-- 以 class 降序的方式查询 student 表的所有行
-- DESC: 降序，从高到低
-- ASC（默认）: 升序，从低到高
SELECT * FROM student ORDER BY class DESC;
SELECT * FROM student ORDER BY class ASC;

-- 以 c_no 升序、degree 降序查询 score 表的所有行
SELECT * FROM score ORDER BY c_no ASC, degree DESC;

-- 查询 "95031" 班的学生人数
-- COUNT: 统计
SELECT COUNT(*) FROM student WHERE class = '95031';

-- 查询 score 表中的最高分的学生学号和课程编号（子查询或排序查询）。
-- (SELECT MAX(degree) FROM score): 子查询，算出最高分
SELECT s_no, c_no FROM score WHERE degree = (SELECT MAX(degree) FROM score);

--  排序查询
-- LIMIT r, n: 表示从第r行开始，查询n条数据
SELECT s_no, c_no, degree FROM score ORDER BY degree DESC LIMIT 0, 1;
```

### 分组计算平均成绩

**查询每门课的平均成绩。**

```mysql
-- AVG: 平均值
SELECT AVG(degree) FROM score WHERE c_no = '3-105';
SELECT AVG(degree) FROM score WHERE c_no = '3-245';
SELECT AVG(degree) FROM score WHERE c_no = '6-166';

-- GROUP BY: 分组查询
SELECT c_no, AVG(degree) FROM score GROUP BY c_no;
```

### 分组条件与模糊查询

**查询 `score` 表中至少有 2 名学生选修，并以 3 开头的课程的平均分数。**

```mysql
SELECT * FROM score;
-- c_no 课程编号
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 103  | 3-105 |     92 |
| 103  | 3-245 |     86 |
| 103  | 6-166 |     85 |
| 105  | 3-105 |     88 |
| 105  | 3-245 |     75 |
| 105  | 6-166 |     79 |
| 109  | 3-105 |     76 |
| 109  | 3-245 |     68 |
| 109  | 6-166 |     81 |
+------+-------+--------+
```

分析表发现，至少有 2 名学生选修的课程是 `3-105` 、`3-245` 、`6-166` ，以 3 开头的课程是 `3-105` 、`3-245` 。也就是说，我们要查询所有 `3-105` 和 `3-245` 的 `degree` 平均分。

```mysql
-- 首先把 c_no, AVG(degree) 通过分组查询出来
SELECT c_no, AVG(degree) FROM score GROUP BY c_no
+-------+-------------+
| c_no  | AVG(degree) |
+-------+-------------+
| 3-105 |     85.3333 |
| 3-245 |     76.3333 |
| 6-166 |     81.6667 |
+-------+-------------+

-- 再查询出至少有 2 名学生选修的课程
-- HAVING: 表示持有
HAVING COUNT(c_no) >= 2

-- 并且是以 3 开头的课程
-- LIKE 表示模糊查询，"%" 是一个通配符，匹配 "3" 后面的任意字符。
AND c_no LIKE '3%';

-- 把前面的SQL语句拼接起来，
-- 后面加上一个 COUNT(*)，表示将每个分组的个数也查询出来。
SELECT c_no, AVG(degree), COUNT(*) FROM score GROUP BY c_no
HAVING COUNT(c_no) >= 2 AND c_no LIKE '3%';
+-------+-------------+----------+
| c_no  | AVG(degree) | COUNT(*) |
+-------+-------------+----------+
| 3-105 |     85.3333 |        3 |
| 3-245 |     76.3333 |        3 |
+-------+-------------+----------+
```

### 多表查询 - 1

**查询所有学生的 `name`，以及该学生在 `score` 表中对应的 `c_no` 和 `degree` 。**

```mysql
SELECT no, name FROM student;
+-----+-----------+
| no  | name      |
+-----+-----------+
| 101 | 曾华      |
| 102 | 匡明      |
| 103 | 王丽      |
| 104 | 李军      |
| 105 | 王芳      |
| 106 | 陆军      |
| 107 | 王尼玛    |
| 108 | 张全蛋    |
| 109 | 赵铁柱    |
+-----+-----------+

SELECT s_no, c_no, degree FROM score;
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 103  | 3-105 |     92 |
| 103  | 3-245 |     86 |
| 103  | 6-166 |     85 |
| 105  | 3-105 |     88 |
| 105  | 3-245 |     75 |
| 105  | 6-166 |     79 |
| 109  | 3-105 |     76 |
| 109  | 3-245 |     68 |
| 109  | 6-166 |     81 |
+------+-------+--------+
```

通过分析可以发现，只要把 `score` 表中的 `s_no` 字段值替换成 `student` 表中对应的 `name` 字段值就可以了，如何做呢？

```mysql
-- FROM...: 表示从 student, score 表中查询
-- WHERE 的条件表示为，只有在 student.no 和 score.s_no 相等时才显示出来。
SELECT name, c_no, degree FROM student, score 
WHERE student.no = score.s_no;
+-----------+-------+--------+
| name      | c_no  | degree |
+-----------+-------+--------+
| 王丽      | 3-105 |     92 |
| 王丽      | 3-245 |     86 |
| 王丽      | 6-166 |     85 |
| 王芳      | 3-105 |     88 |
| 王芳      | 3-245 |     75 |
| 王芳      | 6-166 |     79 |
| 赵铁柱    | 3-105 |     76 |
| 赵铁柱    | 3-245 |     68 |
| 赵铁柱    | 6-166 |     81 |
+-----------+-------+--------+
```

### 多表查询 - 2

**查询所有学生的 `no` 、课程名称 ( `course` 表中的 `name` ) 和成绩 ( `score` 表中的 `degree` ) 列。**

只有 `score` 关联学生的 `no` ，因此只要查询 `score` 表，就能找出所有和学生相关的 `no` 和 `degree` ：

```mysql
SELECT s_no, c_no, degree FROM score;
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 103  | 3-105 |     92 |
| 103  | 3-245 |     86 |
| 103  | 6-166 |     85 |
| 105  | 3-105 |     88 |
| 105  | 3-245 |     75 |
| 105  | 6-166 |     79 |
| 109  | 3-105 |     76 |
| 109  | 3-245 |     68 |
| 109  | 6-166 |     81 |
+------+-------+--------+
```

然后查询 `course` 表：

```mysql
+-------+-----------------+
| no    | name            |
+-------+-----------------+
| 3-105 | 计算机导论      |
| 3-245 | 操作系统        |
| 6-166 | 数字电路        |
| 9-888 | 高等数学        |
+-------+-----------------+
```

只要把 `score` 表中的 `c_no` 替换成 `course` 表中对应的 `name` 字段值就可以了。

```mysql
-- 增加一个查询字段 name，分别从 score、course 这两个表中查询。
-- as 表示取一个该字段的别名。
SELECT s_no, name as c_name, degree FROM score, course
WHERE score.c_no = course.no;
+------+-----------------+--------+
| s_no | c_name          | degree |
+------+-----------------+--------+
| 103  | 计算机导论      |     92 |
| 105  | 计算机导论      |     88 |
| 109  | 计算机导论      |     76 |
| 103  | 操作系统        |     86 |
| 105  | 操作系统        |     75 |
| 109  | 操作系统        |     68 |
| 103  | 数字电路        |     85 |
| 105  | 数字电路        |     79 |
| 109  | 数字电路        |     81 |
+------+-----------------+--------+
```

### 三表关联查询

**查询所有学生的 `name` 、课程名 ( `course` 表中的 `name` ) 和 `degree` 。**

只有 `score` 表中关联学生的学号和课堂号，我们只要围绕着 `score` 这张表查询就好了。

```mysql
SELECT * FROM score;
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 103  | 3-105 |     92 |
| 103  | 3-245 |     86 |
| 103  | 6-166 |     85 |
| 105  | 3-105 |     88 |
| 105  | 3-245 |     75 |
| 105  | 6-166 |     79 |
| 109  | 3-105 |     76 |
| 109  | 3-245 |     68 |
| 109  | 6-166 |     81 |
+------+-------+--------+
```

只要把 `s_no` 和 `c_no` 替换成 `student` 和 `srouse` 表中对应的 `name` 字段值就好了。

首先把 `s_no` 替换成 `student` 表中的 `name` 字段：

```mysql
SELECT name, c_no, degree FROM student, score WHERE student.no = score.s_no;
+-----------+-------+--------+
| name      | c_no  | degree |
+-----------+-------+--------+
| 王丽      | 3-105 |     92 |
| 王丽      | 3-245 |     86 |
| 王丽      | 6-166 |     85 |
| 王芳      | 3-105 |     88 |
| 王芳      | 3-245 |     75 |
| 王芳      | 6-166 |     79 |
| 赵铁柱    | 3-105 |     76 |
| 赵铁柱    | 3-245 |     68 |
| 赵铁柱    | 6-166 |     81 |
+-----------+-------+--------+
```

再把 `c_no` 替换成 `course` 表中的 `name` 字段：

```mysql
-- 课程表
SELECT no, name FROM course;
+-------+-----------------+
| no    | name            |
+-------+-----------------+
| 3-105 | 计算机导论      |
| 3-245 | 操作系统        |
| 6-166 | 数字电路        |
| 9-888 | 高等数学        |
+-------+-----------------+

-- 由于字段名存在重复，使用 "表名.字段名 as 别名" 代替。
SELECT student.name as s_name, course.name as c_name, degree 
FROM student, score, course
WHERE student.NO = score.s_no
AND score.c_no = course.no;
```

### 子查询加分组求平均分

**查询 `95031` 班学生每门课程的平均成绩。**

在 `score` 表中根据 `student`  表的学生编号筛选出学生的课堂号和成绩：

```mysql
-- IN (..): 将筛选出的学生号当做 s_no 的条件查询
SELECT s_no, c_no, degree FROM score
WHERE s_no IN (SELECT no FROM student WHERE class = '95031');
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 105  | 3-105 |     88 |
| 105  | 3-245 |     75 |
| 105  | 6-166 |     79 |
| 109  | 3-105 |     76 |
| 109  | 3-245 |     68 |
| 109  | 6-166 |     81 |
+------+-------+--------+
```

这时只要将 `c_no` 分组一下就能得出 `95031` 班学生每门课的平均成绩：

```mysql
SELECT c_no, AVG(degree) FROM score
WHERE s_no IN (SELECT no FROM student WHERE class = '95031')
GROUP BY c_no;
+-------+-------------+
| c_no  | AVG(degree) |
+-------+-------------+
| 3-105 |     82.0000 |
| 3-245 |     71.5000 |
| 6-166 |     80.0000 |
+-------+-------------+
```

### 子查询 - 1

**查询在 `3-105` 课程中，所有成绩高于 `109` 号同学的记录。**

首先筛选出课堂号为 `3-105` ，在找出所有成绩高于 `109` 号同学的的行。

```mysql
SELECT * FROM score 
WHERE c_no = '3-105'
AND degree > (SELECT degree FROM score WHERE s_no = '109' AND c_no = '3-105');
```

### 子查询 - 2

**查询所有成绩高于 `109` 号同学的 `3-105` 课程成绩记录。**

```mysql
-- 不限制课程号，只要成绩大于109号同学的3-105课程成绩就可以。
SELECT * FROM score
WHERE degree > (SELECT degree FROM score WHERE s_no = '109' AND c_no = '3-105');
```

### YEAR 函数与带 IN 关键字查询

**查询所有和 `101` 、`108` 号学生同年出生的 `no` 、`name` 、`birthday` 列。**

```mysql
-- YEAR(..): 取出日期中的年份
SELECT no, name, birthday FROM student
WHERE YEAR(birthday) IN (SELECT YEAR(birthday) FROM student WHERE no IN (101, 108));
```

### 多层嵌套子查询

**查询 `'张旭'` 教师任课的学生成绩表。**

首先找到教师编号：

```mysql
SELECT NO FROM teacher WHERE NAME = '张旭'
```

通过 `sourse` 表找到该教师课程号：

```mysql
SELECT NO FROM course WHERE t_no = ( SELECT NO FROM teacher WHERE NAME = '张旭' );
```

通过筛选出的课程号查询成绩表：

```mysql
SELECT * FROM score WHERE c_no = (
    SELECT no FROM course WHERE t_no = ( 
        SELECT no FROM teacher WHERE NAME = '张旭' 
    )
);
```

### 多表查询

**查询某选修课程多于5个同学的教师姓名。**

首先在 `teacher` 表中，根据 `no` 字段来判断该教师的同一门课程是否有至少 5 名学员选修：

```mysql
-- 查询 teacher 表
SELECT no, name FROM teacher;
+-----+--------+
| no  | name   |
+-----+--------+
| 804 | 李诚   |
| 825 | 王萍   |
| 831 | 刘冰   |
| 856 | 张旭   |
+-----+--------+

SELECT name FROM teacher WHERE no IN (
    -- 在这里找到对应的条件
);
```

查看和教师编号有有关的表的信息：

```mysql
SELECT * FROM course;
-- t_no: 教师编号
+-------+-----------------+------+
| no    | name            | t_no |
+-------+-----------------+------+
| 3-105 | 计算机导论      | 825  |
| 3-245 | 操作系统        | 804  |
| 6-166 | 数字电路        | 856  |
| 9-888 | 高等数学        | 831  |
+-------+-----------------+------+
```

我们已经找到和教师编号有关的字段就在 `course` 表中，但是还无法知道哪门课程至少有 5 名学生选修，所以还需要根据 `score` 表来查询：

```mysql
-- 在此之前向 score 插入一些数据，以便丰富查询条件。
INSERT INTO score VALUES ('101', '3-105', '90');
INSERT INTO score VALUES ('102', '3-105', '91');
INSERT INTO score VALUES ('104', '3-105', '89');

-- 查询 score 表
SELECT * FROM score;
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 101  | 3-105 |     90 |
| 102  | 3-105 |     91 |
| 103  | 3-105 |     92 |
| 103  | 3-245 |     86 |
| 103  | 6-166 |     85 |
| 104  | 3-105 |     89 |
| 105  | 3-105 |     88 |
| 105  | 3-245 |     75 |
| 105  | 6-166 |     79 |
| 109  | 3-105 |     76 |
| 109  | 3-245 |     68 |
| 109  | 6-166 |     81 |
+------+-------+--------+

-- 在 score 表中将 c_no 作为分组，并且限制 c_no 持有至少 5 条数据。
SELECT c_no FROM score GROUP BY c_no HAVING COUNT(*) > 5;
+-------+
| c_no  |
+-------+
| 3-105 |
+-------+
```

根据筛选出来的课程号，找出在某课程中，拥有至少 5 名学员的教师编号：

```mysql
SELECT t_no FROM course WHERE no IN (
    SELECT c_no FROM score GROUP BY c_no HAVING COUNT(*) > 5
);
+------+
| t_no |
+------+
| 825  |
+------+
```

在 `teacher` 表中，根据筛选出来的教师编号找到教师姓名：

```mysql
SELECT name FROM teacher WHERE no IN (
    -- 最终条件
    SELECT t_no FROM course WHERE no IN (
        SELECT c_no FROM score GROUP BY c_no HAVING COUNT(*) > 5
    )
);
```

### 子查询 - 3

**查询 “计算机系” 课程的成绩表。**

思路是，先找出 `course` 表中所有 `计算机系` 课程的编号，然后根据这个编号查询 `score` 表。

```mysql
-- 通过 teacher 表查询所有 `计算机系` 的教师编号
SELECT no, name, department FROM teacher WHERE department = '计算机系'
+-----+--------+--------------+
| no  | name   | department   |
+-----+--------+--------------+
| 804 | 李诚   | 计算机系     |
| 825 | 王萍   | 计算机系     |
+-----+--------+--------------+

-- 通过 course 表查询该教师的课程编号
SELECT no FROM course WHERE t_no IN (
    SELECT no FROM teacher WHERE department = '计算机系'
);
+-------+
| no    |
+-------+
| 3-245 |
| 3-105 |
+-------+

-- 根据筛选出来的课程号查询成绩表
SELECT * FROM score WHERE c_no IN (
    SELECT no FROM course WHERE t_no IN (
        SELECT no FROM teacher WHERE department = '计算机系'
    )
);
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 103  | 3-245 |     86 |
| 105  | 3-245 |     75 |
| 109  | 3-245 |     68 |
| 101  | 3-105 |     90 |
| 102  | 3-105 |     91 |
| 103  | 3-105 |     92 |
| 104  | 3-105 |     89 |
| 105  | 3-105 |     88 |
| 109  | 3-105 |     76 |
+------+-------+--------+
```

### UNION 和 NOTIN 的使用

**查询 `计算机系` 与 `电子工程系` 中的不同职称的教师。**

```mysql
-- NOT: 代表逻辑非
SELECT * FROM teacher WHERE department = '计算机系' AND profession NOT IN (
    SELECT profession FROM teacher WHERE department = '电子工程系'
)
-- 合并两个集
UNION
SELECT * FROM teacher WHERE department = '电子工程系' AND profession NOT IN (
    SELECT profession FROM teacher WHERE department = '计算机系'
);
```

### ANY 表示至少一个 - DESC ( 降序 )

**查询课程 `3-105` 且成绩 <u>至少</u> 高于 `3-245` 的 `score` 表。**

```mysql
SELECT * FROM score WHERE c_no = '3-105';
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 101  | 3-105 |     90 |
| 102  | 3-105 |     91 |
| 103  | 3-105 |     92 |
| 104  | 3-105 |     89 |
| 105  | 3-105 |     88 |
| 109  | 3-105 |     76 |
+------+-------+--------+

SELECT * FROM score WHERE c_no = '3-245';
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 103  | 3-245 |     86 |
| 105  | 3-245 |     75 |
| 109  | 3-245 |     68 |
+------+-------+--------+

-- ANY: 符合SQL语句中的任意条件。
-- 也就是说，在 3-105 成绩中，只要有一个大于从 3-245 筛选出来的任意行就符合条件，
-- 最后根据降序查询结果。
SELECT * FROM score WHERE c_no = '3-105' AND degree > ANY(
    SELECT degree FROM score WHERE c_no = '3-245'
) ORDER BY degree DESC;
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 103  | 3-105 |     92 |
| 102  | 3-105 |     91 |
| 101  | 3-105 |     90 |
| 104  | 3-105 |     89 |
| 105  | 3-105 |     88 |
| 109  | 3-105 |     76 |
+------+-------+--------+
```

### 表示所有的 ALL

**查询课程 `3-105` 且成绩高于 `3-245` 的 `score` 表。**

```mysql
-- 只需对上一道题稍作修改。
-- ALL: 符合SQL语句中的所有条件。
-- 也就是说，在 3-105 每一行成绩中，都要大于从 3-245 筛选出来全部行才算符合条件。
SELECT * FROM score WHERE c_no = '3-105' AND degree > ALL(
    SELECT degree FROM score WHERE c_no = '3-245'
);
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 101  | 3-105 |     90 |
| 102  | 3-105 |     91 |
| 103  | 3-105 |     92 |
| 104  | 3-105 |     89 |
| 105  | 3-105 |     88 |
+------+-------+--------+
```

### 复制表的数据作为条件查询

**查询某课程成绩比该课程平均成绩低的 `score` 表。**

```mysql
-- 查询平均分
SELECT c_no, AVG(degree) FROM score GROUP BY c_no;
+-------+-------------+
| c_no  | AVG(degree) |
+-------+-------------+
| 3-105 |     87.6667 |
| 3-245 |     76.3333 |
| 6-166 |     81.6667 |
+-------+-------------+

-- 查询 score 表
SELECT degree FROM score;
+--------+
| degree |
+--------+
|     90 |
|     91 |
|     92 |
|     86 |
|     85 |
|     89 |
|     88 |
|     75 |
|     79 |
|     76 |
|     68 |
|     81 |
+--------+

-- 将表 b 作用于表 a 中查询数据
-- score a (b): 将表声明为 a (b)，
-- 如此就能用 a.c_no = b.c_no 作为条件执行查询了。
SELECT * FROM score a WHERE degree < (
    (SELECT AVG(degree) FROM score b WHERE a.c_no = b.c_no)
);
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 105  | 3-245 |     75 |
| 105  | 6-166 |     79 |
| 109  | 3-105 |     76 |
| 109  | 3-245 |     68 |
| 109  | 6-166 |     81 |
+------+-------+--------+
```

### 子查询 - 4

**查询所有任课 ( 在 `course` 表里有课程 ) 教师的 `name` 和 `department`** 。

```mysql
SELECT name, department FROM teacher WHERE no IN (SELECT t_no FROM course);
+--------+-----------------+
| name   | department      |
+--------+-----------------+
| 李诚   | 计算机系        |
| 王萍   | 计算机系        |
| 刘冰   | 电子工程系      |
| 张旭   | 电子工程系      |
+--------+-----------------+
```

### 条件加组筛选

**查询 `student` 表中至少有 2 名男生的 `class` 。**

```mysql
-- 查看学生表信息
SELECT * FROM student;
+-----+-----------+-----+------------+-------+
| no  | name      | sex | birthday   | class |
+-----+-----------+-----+------------+-------+
| 101 | 曾华      | 男  | 1977-09-01 | 95033 |
| 102 | 匡明      | 男  | 1975-10-02 | 95031 |
| 103 | 王丽      | 女  | 1976-01-23 | 95033 |
| 104 | 李军      | 男  | 1976-02-20 | 95033 |
| 105 | 王芳      | 女  | 1975-02-10 | 95031 |
| 106 | 陆军      | 男  | 1974-06-03 | 95031 |
| 107 | 王尼玛    | 男  | 1976-02-20 | 95033 |
| 108 | 张全蛋    | 男  | 1975-02-10 | 95031 |
| 109 | 赵铁柱    | 男  | 1974-06-03 | 95031 |
| 110 | 张飞      | 男  | 1974-06-03 | 95038 |
+-----+-----------+-----+------------+-------+

-- 只查询性别为男，然后按 class 分组，并限制 class 行大于 1。
SELECT class FROM student WHERE sex = '男' GROUP BY class HAVING COUNT(*) > 1;
+-------+
| class |
+-------+
| 95033 |
| 95031 |
+-------+
```

### NOTLIKE 模糊查询取反

**查询 `student` 表中不姓 "王" 的同学记录。**

```mysql
-- NOT: 取反
-- LIKE: 模糊查询
mysql> SELECT * FROM student WHERE name NOT LIKE '王%';
+-----+-----------+-----+------------+-------+
| no  | name      | sex | birthday   | class |
+-----+-----------+-----+------------+-------+
| 101 | 曾华      | 男  | 1977-09-01 | 95033 |
| 102 | 匡明      | 男  | 1975-10-02 | 95031 |
| 104 | 李军      | 男  | 1976-02-20 | 95033 |
| 106 | 陆军      | 男  | 1974-06-03 | 95031 |
| 108 | 张全蛋    | 男  | 1975-02-10 | 95031 |
| 109 | 赵铁柱    | 男  | 1974-06-03 | 95031 |
| 110 | 张飞      | 男  | 1974-06-03 | 95038 |
+-----+-----------+-----+------------+-------+
```

### YEAR 与 NOW 函数

**查询 `student` 表中每个学生的姓名和年龄。**

```mysql
-- 使用函数 YEAR(NOW()) 计算出当前年份，减去出生年份后得出年龄。
SELECT name, YEAR(NOW()) - YEAR(birthday) as age FROM student;
+-----------+------+
| name      | age  |
+-----------+------+
| 曾华      |   42 |
| 匡明      |   44 |
| 王丽      |   43 |
| 李军      |   43 |
| 王芳      |   44 |
| 陆军      |   45 |
| 王尼玛    |   43 |
| 张全蛋    |   44 |
| 赵铁柱    |   45 |
| 张飞      |   45 |
+-----------+------+
```

### MAX 与 MIN 函数

**查询 `student` 表中最大和最小的 `birthday` 值。**

```mysql
SELECT MAX(birthday), MIN(birthday) FROM student;
+---------------+---------------+
| MAX(birthday) | MIN(birthday) |
+---------------+---------------+
| 1977-09-01    | 1974-06-03    |
+---------------+---------------+
```

### 多段排序

**以 `class` 和 `birthday` 从大到小的顺序查询 `student` 表。**

```mysql
SELECT * FROM student ORDER BY class DESC, birthday;
+-----+-----------+-----+------------+-------+
| no  | name      | sex | birthday   | class |
+-----+-----------+-----+------------+-------+
| 110 | 张飞      | 男  | 1974-06-03 | 95038 |
| 103 | 王丽      | 女  | 1976-01-23 | 95033 |
| 104 | 李军      | 男  | 1976-02-20 | 95033 |
| 107 | 王尼玛    | 男  | 1976-02-20 | 95033 |
| 101 | 曾华      | 男  | 1977-09-01 | 95033 |
| 106 | 陆军      | 男  | 1974-06-03 | 95031 |
| 109 | 赵铁柱    | 男  | 1974-06-03 | 95031 |
| 105 | 王芳      | 女  | 1975-02-10 | 95031 |
| 108 | 张全蛋    | 男  | 1975-02-10 | 95031 |
| 102 | 匡明      | 男  | 1975-10-02 | 95031 |
+-----+-----------+-----+------------+-------+
```

### 子查询 - 5

**查询 "男" 教师及其所上的课程。**

```mysql
SELECT * FROM course WHERE t_no in (SELECT no FROM teacher WHERE sex = '男');
+-------+--------------+------+
| no    | name         | t_no |
+-------+--------------+------+
| 3-245 | 操作系统     | 804  |
| 6-166 | 数字电路     | 856  |
+-------+--------------+------+
```

### MAX 函数与子查询

**查询最高分同学的 `score` 表。**

```mysql
-- 找出最高成绩（该查询只能有一个结果）
SELECT MAX(degree) FROM score;

-- 根据上面的条件筛选出所有最高成绩表，
-- 该查询可能有多个结果，假设 degree 值多次符合条件。
SELECT * FROM score WHERE degree = (SELECT MAX(degree) FROM score);
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 103  | 3-105 |     92 |
+------+-------+--------+
```

### 子查询 - 6

**查询和 "李军" 同性别的所有同学 `name` 。**

```mysql
-- 首先将李军的性别作为条件取出来
SELECT sex FROM student WHERE name = '李军';
+-----+
| sex |
+-----+
| 男  |
+-----+

-- 根据性别查询 name 和 sex
SELECT name, sex FROM student WHERE sex = (
    SELECT sex FROM student WHERE name = '李军'
);
+-----------+-----+
| name      | sex |
+-----------+-----+
| 曾华      | 男  |
| 匡明      | 男  |
| 李军      | 男  |
| 陆军      | 男  |
| 王尼玛    | 男  |
| 张全蛋    | 男  |
| 赵铁柱    | 男  |
| 张飞      | 男  |
+-----------+-----+
```

### 子查询 - 7

**查询和 "李军" 同性别且同班的同学 `name` 。**

```mysql
SELECT name, sex, class FROM student WHERE sex = (
    SELECT sex FROM student WHERE name = '李军'
) AND class = (
    SELECT class FROM student WHERE name = '李军'
);
+-----------+-----+-------+
| name      | sex | class |
+-----------+-----+-------+
| 曾华      | 男  | 95033 |
| 李军      | 男  | 95033 |
| 王尼玛    | 男  | 95033 |
+-----------+-----+-------+
```

### 子查询 - 8

**查询所有选修 "计算机导论" 课程的 "男" 同学成绩表。**

需要的 "计算机导论" 和性别为 "男" 的编号可以在 `course` 和 `student` 表中找到。

```mysql
SELECT * FROM score WHERE c_no = (
    SELECT no FROM course WHERE name = '计算机导论'
) AND s_no IN (
    SELECT no FROM student WHERE sex = '男'
);
+------+-------+--------+
| s_no | c_no  | degree |
+------+-------+--------+
| 101  | 3-105 |     90 |
| 102  | 3-105 |     91 |
| 104  | 3-105 |     89 |
| 109  | 3-105 |     76 |
+------+-------+--------+
```

### 按等级查询

建立一个 `grade` 表代表学生的成绩等级，并插入数据：

```mysql
CREATE TABLE grade (
    low INT(3),
    upp INT(3),
    grade char(1)
);

INSERT INTO grade VALUES (90, 100, 'A');
INSERT INTO grade VALUES (80, 89, 'B');
INSERT INTO grade VALUES (70, 79, 'C');
INSERT INTO grade VALUES (60, 69, 'D');
INSERT INTO grade VALUES (0, 59, 'E');

SELECT * FROM grade;
+------+------+-------+
| low  | upp  | grade |
+------+------+-------+
|   90 |  100 | A     |
|   80 |   89 | B     |
|   70 |   79 | C     |
|   60 |   69 | D     |
|    0 |   59 | E     |
+------+------+-------+
```

**查询所有学生的 `s_no` 、`c_no` 和 `grade` 列。**

思路是，使用区间 ( `BETWEEN` ) 查询，判断学生的成绩 ( `degree` )  在 `grade` 表的 `low` 和 `upp` 之间。

```mysql
SELECT s_no, c_no, grade FROM score, grade 
WHERE degree BETWEEN low AND upp;
+------+-------+-------+
| s_no | c_no  | grade |
+------+-------+-------+
| 101  | 3-105 | A     |
| 102  | 3-105 | A     |
| 103  | 3-105 | A     |
| 103  | 3-245 | B     |
| 103  | 6-166 | B     |
| 104  | 3-105 | B     |
| 105  | 3-105 | B     |
| 105  | 3-245 | C     |
| 105  | 6-166 | C     |
| 109  | 3-105 | C     |
| 109  | 3-245 | D     |
| 109  | 6-166 | B     |
+------+-------+-------+
```

### 连接查询

准备用于测试连接查询的数据：

```mysql
CREATE DATABASE testJoin;

CREATE TABLE person (
    id INT,
    name VARCHAR(20),
    cardId INT
);

CREATE TABLE card (
    id INT,
    name VARCHAR(20)
);

INSERT INTO card VALUES (1, '饭卡'), (2, '建行卡'), (3, '农行卡'), (4, '工商卡'), (5, '邮政卡');
SELECT * FROM card;
+------+-----------+
| id   | name      |
+------+-----------+
|    1 | 饭卡      |
|    2 | 建行卡    |
|    3 | 农行卡    |
|    4 | 工商卡    |
|    5 | 邮政卡    |
+------+-----------+

INSERT INTO person VALUES (1, '张三', 1), (2, '李四', 3), (3, '王五', 6);
SELECT * FROM person;
+------+--------+--------+
| id   | name   | cardId |
+------+--------+--------+
|    1 | 张三   |      1 |
|    2 | 李四   |      3 |
|    3 | 王五   |      6 |
+------+--------+--------+
```

分析两张表发现，`person` 表并没有为 `cardId` 字段设置一个在 `card` 表中对应的 `id` 外键。如果设置了的话，`person` 中 `cardId` 字段值为 `6` 的行就插不进去，因为该 `cardId` 值在 `card` 表中并没有。

#### 内连接

要查询这两张表中有关系的数据，可以使用 `INNER JOIN` ( 内连接 ) 将它们连接在一起。

```mysql
-- INNER JOIN: 表示为内连接，将两张表拼接在一起。
-- on: 表示要执行某个条件。
SELECT * FROM person INNER JOIN card on person.cardId = card.id;
+------+--------+--------+------+-----------+
| id   | name   | cardId | id   | name      |
+------+--------+--------+------+-----------+
|    1 | 张三   |      1 |    1 | 饭卡      |
|    2 | 李四   |      3 |    3 | 农行卡    |
+------+--------+--------+------+-----------+

-- 将 INNER 关键字省略掉，结果也是一样的。
-- SELECT * FROM person JOIN card on person.cardId = card.id;
```

> 注意：`card` 的整张表被连接到了右边。

#### 左外连接

完整显示左边的表 ( `person` ) ，右边的表如果符合条件就显示，不符合则补 `NULL` 。

```mysql
-- LEFT JOIN 也叫做 LEFT OUTER JOIN，用这两种方式的查询结果是一样的。
SELECT * FROM person LEFT JOIN card on person.cardId = card.id;
+------+--------+--------+------+-----------+
| id   | name   | cardId | id   | name      |
+------+--------+--------+------+-----------+
|    1 | 张三   |      1 |    1 | 饭卡      |
|    2 | 李四   |      3 |    3 | 农行卡    |
|    3 | 王五   |      6 | NULL | NULL      |
+------+--------+--------+------+-----------+
```

#### 右外链接

完整显示右边的表 ( `card` ) ，左边的表如果符合条件就显示，不符合则补 `NULL` 。

```mysql
SELECT * FROM person RIGHT JOIN card on person.cardId = card.id;
+------+--------+--------+------+-----------+
| id   | name   | cardId | id   | name      |
+------+--------+--------+------+-----------+
|    1 | 张三   |      1 |    1 | 饭卡      |
|    2 | 李四   |      3 |    3 | 农行卡    |
| NULL | NULL   |   NULL |    2 | 建行卡    |
| NULL | NULL   |   NULL |    4 | 工商卡    |
| NULL | NULL   |   NULL |    5 | 邮政卡    |
+------+--------+--------+------+-----------+
```

#### 全外链接

完整显示两张表的全部数据。

```mysql
-- MySQL 不支持这种语法的全外连接
-- SELECT * FROM person FULL JOIN card on person.cardId = card.id;
-- 出现错误：
-- ERROR 1054 (42S22): Unknown column 'person.cardId' in 'on clause'

-- MySQL全连接语法，使用 UNION 将两张表合并在一起。
SELECT * FROM person LEFT JOIN card on person.cardId = card.id
UNION
SELECT * FROM person RIGHT JOIN card on person.cardId = card.id;
+------+--------+--------+------+-----------+
| id   | name   | cardId | id   | name      |
+------+--------+--------+------+-----------+
|    1 | 张三   |      1 |    1 | 饭卡      |
|    2 | 李四   |      3 |    3 | 农行卡    |
|    3 | 王五   |      6 | NULL | NULL      |
| NULL | NULL   |   NULL |    2 | 建行卡    |
| NULL | NULL   |   NULL |    4 | 工商卡    |
| NULL | NULL   |   NULL |    5 | 邮政卡    |
+------+--------+--------+------+-----------+
```

## 事务

在 MySQL 中，事务其实是一个最小的不可分割的工作单元。事务能够**保证一个业务的完整性**。

比如我们的银行转账：

```mysql
-- a -> -100
UPDATE user set money = money - 100 WHERE name = 'a';

-- b -> +100
UPDATE user set money = money + 100 WHERE name = 'b';
```

在实际项目中，假设只有一条 SQL 语句执行成功，而另外一条执行失败了，就会出现数据前后不一致。

因此，在执行多条有关联 SQL 语句时，**事务**可能会要求这些 SQL 语句要么同时执行成功，要么就都执行失败。

### 如何控制事务 - COMMIT / ROLLBACK

在 MySQL 中，事务的**自动提交**状态默认是开启的。

```mysql
-- 查询事务的自动提交状态
SELECT @@AUTOCOMMIT;
+--------------+
| @@AUTOCOMMIT |
+--------------+
|            1 |
+--------------+
```

**自动提交的作用**：当我们执行一条 SQL 语句的时候，其产生的效果就会立即体现出来，且不能**回滚**。

什么是回滚？举个例子：

```mysql
CREATE DATABASE bank;

USE bank;

CREATE TABLE user (
    id INT PRIMARY KEY,
    name VARCHAR(20),
    money INT
);

INSERT INTO user VALUES (1, 'a', 1000);

SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
+----+------+-------+
```

可以看到，在执行插入语句后数据立刻生效，原因是 MySQL 中的事务自动将它**提交**到了数据库中。那么所谓**回滚**的意思就是，撤销执行过的所有 SQL 语句，使其回滚到**最后一次提交**数据时的状态。

在 MySQL 中使用 `ROLLBACK` 执行回滚：

```mysql
-- 回滚到最后一次提交
ROLLBACK;

SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
+----+------+-------+
```

由于所有执行过的 SQL 语句都已经被提交过了，所以数据并没有发生回滚。那如何让数据可以发生回滚？

```mysql
-- 关闭自动提交
SET AUTOCOMMIT = 0;

-- 查询自动提交状态
SELECT @@AUTOCOMMIT;
+--------------+
| @@AUTOCOMMIT |
+--------------+
|            0 |
+--------------+
```

将自动提交关闭后，测试数据回滚：

```mysql
INSERT INTO user VALUES (2, 'b', 1000);

-- 关闭 AUTOCOMMIT 后，数据的变化是在一张虚拟的临时数据表中展示，
-- 发生变化的数据并没有真正插入到数据表中。
SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+

-- 数据表中的真实数据其实还是：
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
+----+------+-------+

-- 由于数据还没有真正提交，可以使用回滚
ROLLBACK;

-- 再次查询
SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
+----+------+-------+
```

那如何将虚拟的数据真正提交到数据库中？使用 `COMMIT` : 

```mysql
INSERT INTO user VALUES (2, 'b', 1000);
-- 手动提交数据（持久性），
-- 将数据真正提交到数据库中，执行后不能再回滚提交过的数据。
COMMIT;

-- 提交后测试回滚
ROLLBACK;

-- 再次查询（回滚无效了）
SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
```

> **总结**
>
> 1. **自动提交**
>
>    - 查看自动提交状态：`SELECT @@AUTOCOMMIT` ；
>
>    - 设置自动提交状态：`SET AUTOCOMMIT = 0` 。
>
> 2. **手动提交**
>
>    `@@AUTOCOMMIT = 0` 时，使用 `COMMIT` 命令提交事务。
>
> 3. **事务回滚**
>
>    `@@AUTOCOMMIT = 0` 时，使用 `ROLLBACK` 命令回滚事务。

**事务的实际应用**，让我们再回到银行转账项目：

```mysql
-- 转账
UPDATE user set money = money - 100 WHERE name = 'a';

-- 到账
UPDATE user set money = money + 100 WHERE name = 'b';

SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   900 |
|  2 | b    |  1100 |
+----+------+-------+
```

这时假设在转账时发生了意外，就可以使用 `ROLLBACK` 回滚到最后一次提交的状态：

```mysql
-- 假设转账发生了意外，需要回滚。
ROLLBACK;

SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
```

这时我们又回到了发生意外之前的状态，也就是说，事务给我们提供了一个可以反悔的机会。假设数据没有发生意外，这时可以手动将数据真正提交到数据表中：`COMMIT` 。

### 手动开启事务 - BEGIN / START TRANSACTION

事务的默认提交被开启 ( `@@AUTOCOMMIT = 1` ) 后，此时就不能使用事务回滚了。但是我们还可以手动开启一个事务处理事件，使其可以发生回滚：

```mysql
-- 使用 BEGIN 或者 START TRANSACTION 手动开启一个事务
-- START TRANSACTION;
BEGIN;
UPDATE user set money = money - 100 WHERE name = 'a';
UPDATE user set money = money + 100 WHERE name = 'b';

-- 由于手动开启的事务没有开启自动提交，
-- 此时发生变化的数据仍然是被保存在一张临时表中。
SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   900 |
|  2 | b    |  1100 |
+----+------+-------+

-- 测试回滚
ROLLBACK;

SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
```

仍然使用 `COMMIT` 提交数据，提交后无法再发生本次事务的回滚。

```mysql
BEGIN;
UPDATE user set money = money - 100 WHERE name = 'a';
UPDATE user set money = money + 100 WHERE name = 'b';

SELECT * FROM user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   900 |
|  2 | b    |  1100 |
+----+------+-------+

-- 提交数据
COMMIT;

-- 测试回滚（无效，因为表的数据已经被提交）
ROLLBACK;
```

### 事务的 ACID 特征与使用

**事务的四大特征：**

- **A 原子性**：事务是最小的单位，不可以再分割；
- **C 一致性**：要求同一事务中的 SQL 语句，必须保证同时成功或者失败；
- **I 隔离性**：事务 1 和 事务 2 之间是具有隔离性的；
- **D 持久性**：事务一旦结束 ( `COMMIT` ) ，就不可以再返回了 ( `ROLLBACK` ) 。

### 事务的隔离性

**事务的隔离性可分为四种 ( 性能从低到高 )** ：

1. **READ UNCOMMITTED ( 读取未提交 )**

   如果有多个事务，那么任意事务都可以看见其他事务的**未提交数据**。

2. **READ COMMITTED ( 读取已提交 )**

   只能读取到其他事务**已经提交的数据**。

3. **REPEATABLE READ ( 可被重复读 )**

   如果有多个连接都开启了事务，那么事务之间不能共享数据记录，否则只能共享已提交的记录。

4. **SERIALIZABLE ( 串行化 )**

   所有的事务都会按照**固定顺序执行**，执行完一个事务后再继续执行下一个事务的**写入操作**。

查看当前数据库的默认隔离级别：

```mysql
-- MySQL 8.x, GLOBAL 表示系统级别，不加表示会话级别。
SELECT @@GLOBAL.TRANSACTION_ISOLATION;
SELECT @@TRANSACTION_ISOLATION;
+--------------------------------+
| @@GLOBAL.TRANSACTION_ISOLATION |
+--------------------------------+
| REPEATABLE-READ                | -- MySQL的默认隔离级别，可重复读。
+--------------------------------+

-- MySQL 5.x
SELECT @@GLOBAL.TX_ISOLATION;
SELECT @@TX_ISOLATION;
```

修改隔离级别：

```mysql
-- 设置系统隔离级别，LEVEL 后面表示要设置的隔离级别 (READ UNCOMMITTED)。
SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- 查询系统隔离级别，发现已经被修改。
SELECT @@GLOBAL.TRANSACTION_ISOLATION;
+--------------------------------+
| @@GLOBAL.TRANSACTION_ISOLATION |
+--------------------------------+
| READ-UNCOMMITTED               |
+--------------------------------+
```

#### 脏读

测试 **READ UNCOMMITTED ( 读取未提交 )** 的隔离性：

```mysql
INSERT INTO user VALUES (3, '小明', 1000);
INSERT INTO user VALUES (4, '淘宝店', 1000);

SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
+----+-----------+-------+

-- 开启一个事务操作数据
-- 假设小明在淘宝店买了一双800块钱的鞋子：
START TRANSACTION;
UPDATE user SET money = money - 800 WHERE name = '小明';
UPDATE user SET money = money + 800 WHERE name = '淘宝店';

-- 然后淘宝店在另一方查询结果，发现钱已到账。
SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
+----+-----------+-------+
```

由于小明的转账是在新开启的事务上进行操作的，而该操作的结果是可以被其他事务（另一方的淘宝店）看见的，因此淘宝店的查询结果是正确的，淘宝店确认到账。但就在这时，如果小明在它所处的事务上又执行了 `ROLLBACK` 命令，会发生什么？

```mysql
-- 小明所处的事务
ROLLBACK;

-- 此时无论对方是谁，如果再去查询结果就会发现：
SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
+----+-----------+-------+
```

这就是所谓的**脏读**，一个事务读取到另外一个事务还未提交的数据。这在实际开发中是不允许出现的。

#### 读取已提交

把隔离级别设置为 **READ COMMITTED** ：

```mysql
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT @@GLOBAL.TRANSACTION_ISOLATION;
+--------------------------------+
| @@GLOBAL.TRANSACTION_ISOLATION |
+--------------------------------+
| READ-COMMITTED                 |
+--------------------------------+
```

这样，再有新的事务连接进来时，它们就只能查询到已经提交过的事务数据了。但是对于当前事务来说，它们看到的还是未提交的数据，例如：

```mysql
-- 正在操作数据事务（当前事务）
START TRANSACTION;
UPDATE user SET money = money - 800 WHERE name = '小明';
UPDATE user SET money = money + 800 WHERE name = '淘宝店';

-- 虽然隔离级别被设置为了 READ COMMITTED，但在当前事务中，
-- 它看到的仍然是数据表中临时改变数据，而不是真正提交过的数据。
SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
+----+-----------+-------+


-- 假设此时在远程开启了一个新事务，连接到数据库。
$ mysql -u root -p12345612

-- 此时远程连接查询到的数据只能是已经提交过的
SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
+----+-----------+-------+
```

但是这样还有问题，那就是假设一个事务在操作数据时，其他事务干扰了这个事务的数据。例如：

```mysql
-- 小张在查询数据的时候发现：
SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
+----+-----------+-------+

-- 在小张求表的 money 平均值之前，小王做了一个操作：
START TRANSACTION;
INSERT INTO user VALUES (5, 'c', 100);
COMMIT;

-- 此时表的真实数据是：
SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
|  5 | c         |   100 |
+----+-----------+-------+

-- 这时小张再求平均值的时候，就会出现计算不相符合的情况：
SELECT AVG(money) FROM user;
+------------+
| AVG(money) |
+------------+
|  820.0000  |
+------------+
```

虽然 **READ COMMITTED** 让我们只能读取到其他事务已经提交的数据，但还是会出现问题，就是**在读取同一个表的数据时，可能会发生前后不一致的情况。**这被称为**不可重复读现象 ( READ UNCOMMITTED )** 。

#### 幻读

将隔离级别设置为 **REPEATABLE READ ( 可被重复读取 )** :

```mysql
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT @@GLOBAL.TRANSACTION_ISOLATION;
+--------------------------------+
| @@GLOBAL.TRANSACTION_ISOLATION |
+--------------------------------+
| REPEATABLE-READ                |
+--------------------------------+
```

测试 **REPEATABLE READ** ，假设在两个不同的连接上分别执行 `START TRANSACTION` :

```sql
-- 小张 - 成都
START TRANSACTION;
INSERT INTO user VALUES (6, 'd', 1000);

-- 小王 - 北京
START TRANSACTION;

-- 小张 - 成都
COMMIT;
```

当前事务开启后，没提交之前，查询不到，提交后可以被查询到。但是，在提交之前其他事务被开启了，那么在这条事务线上，就不会查询到当前有操作事务的连接。相当于开辟出一条单独的线程。

无论小张是否执行过 `COMMIT` ，在小王这边，都不会查询到小张的事务记录，而是只会查询到自己所处事务的记录：

```sql
SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
|  5 | c         |   100 |
+----+-----------+-------+
```

这是**因为小王在此之前开启了一个新的事务 ( `START TRANSACTION` ) **，那么**在他的这条新事务的线上，跟其他事务是没有联系的**，也就是说，此时如果其他事务正在操作数据，它是不知道的。

然而事实是，在真实的数据表中，小张已经插入了一条数据。但是小王此时并不知道，也插入了同一条数据，会发生什么呢？

```sql
INSERT INTO user VALUES (6, 'd', 1000);
-- ERROR 1062 (23000): Duplicate entry '6' for key 'PRIMARY'
```

报错了，操作被告知已存在主键为 `6` 的字段。这种现象也被称为**幻读，一个事务提交的数据，不能被其他事务读取到**。

#### 串行化

顾名思义，就是所有事务的**写入操作**全都是串行化的。什么意思？把隔离级别修改成 **SERIALIZABLE** :

```mysql
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT @@GLOBAL.TRANSACTION_ISOLATION;
+--------------------------------+
| @@GLOBAL.TRANSACTION_ISOLATION |
+--------------------------------+
| SERIALIZABLE                   |
+--------------------------------+
```

还是拿小张和小王来举例：

```mysql
-- 小张 - 成都
START TRANSACTION;

-- 小王 - 北京
START TRANSACTION;

-- 开启事务之前先查询表，准备操作数据。
SELECT * FROM user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
|  5 | c         |   100 |
|  6 | d         |  1000 |
+----+-----------+-------+

-- 发现没有 7 号王小花，于是插入一条数据：
INSERT INTO user VALUES (7, '王小花', 1000);
```

此时会发生什么呢？由于现在的隔离级别是 **SERIALIZABLE ( 串行化 )** ，串行化的意思就是：假设把所有的事务都放在一个串行的队列中，那么所有的事务都会按照**固定顺序执行**，执行完一个事务后再继续执行下一个事务的**写入操作** ( **这意味着队列中同时只能执行一个事务的写入操作** ) 。

根据这个解释，小王在插入数据时，会出现等待状态，直到小张执行 `COMMIT` 结束它所处的事务，或者出现等待超时。

## 索引

索引是存储引擎用于提高数据库表的访问速度的一种**数据结构**，它为特定的 mysql 字段进行一些**特定的算法排序**，比如二叉树的算法和哈希算法

- 哈希算法是通过建立特征值，然后根据特征值来快速查找。
- 而用的最多，并且是 mysql 默认的就是二叉树算法 BTREE，通过 BTREE 算法建立索引的字段，比如扫描 20 行就能得到未使用 BTREE 前扫描了 2^20^ 行的结果。

### 索引的优缺点

优点

- **加快数据查找的速度**
- 为用来**排序**或者是**分组**的字段添加索引，可以加快分组和排序的速度
- 加快表与表之间的**连接**

缺点

- 建立索引需要**占用物理空间**
- 会降低表的增删改的效率，因为每次对表记录进行增删改，需要进行**动态维护索引**，导致增删改时间变长

### 什么情况下需要建索引

1. 经常用于**查询**的字段
2. 经常用于**连接**的字段建立索引，可以加快连接的速度
3. 经常需要**排序**的字段建立索引，因为索引已经排好序，可以加快排序查询速度

### 什么情况下不建索引

1. `where` 条件中用不到的字段不适合建立索引
2. **表记录较少**。比如只有几百条数据，没必要加索引。
3. 需要**经常增删改**。需要评估是否适合加索引
4. **参与列计算**的列不适合建索引
5. **区分度不高**的字段不适合建立索引，如性别，只有男/女/未知三个值。加了索引，查询效率也不会提高。

### 索引的数据结构

#### B+ 树索引

B+ 树是**基于 B 树和叶子节点顺序访问指针**进行实现，它具有 B 树的平衡性，并且通过顺序访问指针来提高区间查询的性能。

在 B+ 树中，节点中的 `key` 从左到右递增排列，如果某个指针的左右相邻 `key` 分别是 key~i~ 和 key~i+1~，则该指针指向节点的所有 `key` 大于等于 key~i~ 且小于等于 key~i+1~。



![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-2b6d28e258f4fe43acd500f32331fcd3_1440w.jpg)



进行查找操作时，首先在根节点进行**二分查找**，找到 `key` 所在的指针，然后递归地在指针所指向的节点进行查找。直到查找到叶子节点，然后在叶子节点上进行二分查找，找出 `key` 所对应的数据项。

MySQL 数据库使用最多的索引类型是 `BTREE` 索引，底层基于 B+ 树数据结构来实现。

```mysql
mysql> show index from blog\G;
*************************** 1. row ***************************
        Table: blog
   Non_unique: 0
     Key_name: PRIMARY
 Seq_in_index: 1
  Column_name: blog_id
    Collation: A
  Cardinality: 4
     Sub_part: NULL
       Packed: NULL
         Null:
   Index_type: BTREE
      Comment:
Index_comment:
      Visible: YES
   Expression: NULL
```

#### 哈希索引

哈希索引是基于哈希表实现的，对于每一行数据，存储引擎会对索引列进行哈希计算得到哈希码，并且哈希算法要尽量保证不同的列值计算出的哈希码值是不同的

将哈希码的值作为哈希表的 key 值，将指向数据行的指针	作为哈希表的 value 值。这样查找一个数据的时间复杂度就是 O(1)，一般多用于精确查找。

#### Hash 索引和 B+ 树索引的区别？

- 哈希索引**不支持排序**，因为哈希表是无序的。
- 哈希索引**不支持范围查找**。
- 哈希索引**不支持模糊查询**及多列索引的最左前缀匹配。
- 因为哈希表中会**存在哈希冲突**，所以哈希索引的性能是不稳定的，而 B+ 树索引的性能是相对稳定的，每次查询都是从根节点到叶子节点。

#### 为什么 B+ 树比 B 树更适合实现数据库索引？

- 由于 B+ 树的数据都存储在叶子结点中，叶子结点均为索引，**方便扫库**，只需要扫一遍叶子结点即可，
  - 但是 B 树因为其分支结点同样存储着数据，我们要找到具体的数据，需要进行一次中序遍历按序来扫
  - 所以 B+ 树**更加适合在区间查询的情况**，而在数据库中基于范围的查询是非常频繁的，所以通常 B+ 树用于数据库索引。
- B+ 树的节点只存储索引 key 值，具体信息的地址存在于叶子节点的地址中。这就使以页为单位的索引中可以存放更多的节点。减少更多的 I/O 支出。
- B+ 树的**查询效率更加稳定**，任何关键字的查找必须走一条从根结点到叶子结点的路。所有关键字查询的路径长度相同，导致每一个数据的查询效率相当。

### 索引的类型

**INDEX 普通索引**

- 允许出现相同的索引内容。

**UNIQUE KEY 唯一索引**

- 唯一，允许出现空值
- 用途：唯一标识数据库表中的每条记录，主要是用来防止数据重复插入。

```sql
ALTER TABLE table_name
ADD CONSTRAINT constraint_name UNIQUE KEY(column_1,column_2,...);
```

**PRIMARY KEY 主键索引**

- 唯一，非空

**组合索引**

- 在表中的多个字段组合上创建的索引
- 只有在查询条件中使用了这些字段的左边字段时，索引才会被使用，使用组合索引时需遵循**最左前缀原则**。

**fulltext index 全文索引**

- 上述三种索引都是针对列的值发挥作用，但全文索引，可以针对值中的某个单词，比如一篇文章中的某个词
- 只能在`CHAR`、`VARCHAR` 和 `TEXT` 类型字段上使用全文索引
- 然而并没有什么卵用，因为只有 MYISAM 以及英文支持，并且效率让人不敢恭维

### 索引的设计原则

- 索引列的**区分度越高**，索引的效果越好。比如使用性别这种区分度很低的列作为索引，效果就会很差。
  - 话句话说，在维度高的列创建索引。
- 尽量使用**短索引**，因为较小的索引涉及到的磁盘 I/O 较少，查询速度更快。
  - 对于较长的字符串进行索引时应该指定一个较短的前缀长度（**前缀索引**）
- 索引不是越多越好，每个索引都需要额外的物理空间，维护也需要花费时间。
  - 对 where, on, group by, order by 中频繁出现的列使用索引。
- 使用组合索引，可以减少文件索引大小，在使用时速度要优于多个单列索引。
  - 利用**最左前缀原则**。

### 索引什么时候会失效

导致索引失效的情况：

- **条件中有 `or`**
  - 例如` select * from table_name where a = 1 or b = 3`

- **在索引上进行计算**会导致索引失效
  - 例如 `select * from table_name where a + 1 = 2`

- 在索引的类型上进行数据类型的**隐式转换**，会导致索引失效，
  - 例如字符串一定要加引号，假设 `select * from table_name where a = '1'` 会使用到索引，如果写成 `select * from table_name where a = 1` 则会导致索引失效。

- 在索引中使用**函数**会导致索引失效
  - 例如 `select * from table_name where abs(a) = 1`

- 在使用 like 查询时**以 % 开头**会导致索引失效
- 索引上使用 !=、<> 进行判断时会导致索引失效
  - 例如 `select * from table_name where a != 1`

- 索引字段上使用 is null/is not null 判断时会导致索引失效
  - 例如 `select * from table_name where a is null`


### 索引的相关操作

#### **索引的创建**

##### `ALTER TABLE`

适用于表创建完毕之后再添加。

`ALTER TABLE 表名 ADD 索引类型 (unique,primary key,fulltext,index)[索引名](字段名)`

```sql
ALTER TABLE `table_name` ADD INDEX `index_name` (`column_list`) -- 索引名，可要可不要；如果不要，当前的索引名就是该字段名。 
ALTER TABLE `table_name` ADD UNIQUE (`column_list`) 
ALTER TABLE `table_name` ADD PRIMARY KEY (`column_list`) 
ALTER TABLE `table_name` ADD FULLTEXT KEY (`column_list`)
```

##### `CREATE INDEX`

CREATE INDEX 可对表增加**普通**索引或 **UNIQUE** 索引。

```sql
--例：只能添加这两种索引 
CREATE INDEX index_name ON table_name (column_list) 
CREATE UNIQUE INDEX index_name ON table_name (column_list)
```

**另外，还可以在建表时添加：**

```sql
CREATE TABLE `test1` ( 
  `id` smallint(5) UNSIGNED AUTO_INCREMENT NOT NULL, -- 注意，下面创建了主键索引，这里就不用创建了 
  `username` varchar(64) NOT NULL COMMENT '用户名', 
  `nickname` varchar(50) NOT NULL COMMENT '昵称/姓名', 
  `intro` text, 
  PRIMARY KEY (`id`),  
  UNIQUE KEY `unique1` (`username`), -- 索引名称，可要可不要，不要就是和列名一样 
  KEY `index1` (`nickname`), 
  FULLTEXT KEY `intro` (`intro`) 
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='后台用户表';
```

#### 索引的删除

```sql
DROP INDEX `index_name` ON `talbe_name`  
ALTER TABLE `table_name` DROP INDEX `index_name` 
-- 这两句都是等价的,都是删除掉table_name中的索引index_name; 

ALTER TABLE `table_name` DROP PRIMARY KEY -- 删除主键索引，注意主键索引只能用这种方式删除
```

#### 索引的查看

```sql
show index from tablename;
```

#### 索引的更改

更改个毛线，删掉重建一个既可

### 组合索引

```sql
ALTER TABLE `myIndex` ADD INDEX `name_city_age` (vc_Name(10),vc_City,i_Age);
```

上述的步骤就是将 vc_Name，vc_City，i_Age 建到一个索引里

这样一来，在执行这条 SQL 查询语句时：

```sql
SELECT `i_testID` FROM `myIndex` WHERE `vc_Name`='erquan' AND `vc_City`='郑州' AND `i_Age`=25; -- 关联搜索;
```

查询速度会比只建立某一个字段的单独索引要快得多

> 如果分别在 vc_Name，vc_City，i_Age 上建立单列索引，让该表有 3 个单列索引，查询的速度将远远低于组合索引。
>
> 虽然此时有了三个索引，但 MySQL 只能用到其中的那个它认为似乎是**最有效率**的单列索引，另外两个是用不到的，也就是说还是一个全表扫描的过程。

#### 最左匹配原则

建立这样的组合索引，其实是相当于分别建立了：

- `vc_Name, vc_City, i_Age`
- `vc_Name, vc_City`
- `vc_Name`

为什么没有 `vc_City, i_Age` 等这样的组合索引呢？这是因为 mysql 组合索引 “最左前缀” 的结果。简单的理解就是**只从最左面的开始组合**。并不是只要包含这三列的查询都会用到该组合索引，下面的几个 T-SQL 会用到：

```sql
SELECT * FROM myIndex WHREE vc_Name=”erquan” AND vc_City=”郑州” 
SELECT * FROM myIndex WHREE vc_Name=”erquan”
```

而下面几个则不会用到：

```sql
SELECT * FROM myIndex WHREE i_Age=20 AND vc_City=”郑州” 
SELECT * FROM myIndex WHREE vc_City=”郑州”
```

也就是，`name_city_age(vc_Name(10),vc_City,i_Age)` 会**从左到右**进行索引，如果没有左前索引，Mysql 不执行索引查询。

##### 范围查询后停止匹配

如果 SQL 语句中用到了组合索引中的最左边的索引，那么这条 SQL 语句就可以利用这个组合索引去进行匹配。

**当遇到范围查询 (`>`、`<`、`between`、`like`) 后就会停止匹配，后面的字段不会用到索引**。

例

- 对`(a,b,c)`建立索引，查询条件使用 a/ab/abc 会走索引，使用 bc 不会走索引。

- 对`(a,b,c,d)`建立索引，查询条件为`a = 1 and b = 2 and c > 3 and d = 4`，那么 a、b 和 c 三个字段能用到索引，而 d 无法使用索引。因为遇到了范围查询。

如下图，对 (a, b) 建立索引，a 在索引树中是全局有序的，而 b 是全局无序，局部有序（当 a 相等时，会根据 b 进行排序）。直接执行 `b = 2` 这种查询条件无法使用索引。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-abcd73c11c1b363a704299fb0366a8a8_1440w.jpg)

当 a 的值确定的时候，b 是有序的。例如 `a = 1` 时，b 值为 1，2 是有序的状态。当 `a = 2` 时候，b 的值为 1，4 也是有序状态。 当执行 `a = 1 and b = 2` 时 a 和 b 字段能用到索引。而执行 `a > 1 and b = 2` 时，a 字段能用到索引，b 字段用不到索引。因为 a 的值此时是一个范围，不是固定的，在这个范围内 b 值不是有序的，因此 b 字段无法使用索引。

##### 例

例如建立索引 (a,b,c)

第一种

```sql
select * from table_name where a = 1 and b = 2 and c = 3 
select * from table_name where b = 2 and a = 1 and c = 3
```

上面两次查询过程中所有值都用到了索引，:star: **where 后面字段调换不会影响查询结果**，因为 MySQL 中的优化器会自动优化查询顺序。

第二种

```sql
select * from table_name where a = 1
select * from table_name where a = 1 and b = 2  
select * from table_name where a = 1 and b = 2 and c = 3
```

答案是三个查询语句都用到了索引，因为三个语句都是从最左开始匹配的。

第三种

```sql
select * from table_name where  b = 1 
select * from table_name where  b = 1 and c = 2 
```

答案是这两个查询语句都没有用到索引，因为不是从最左边开始匹配的

第四种

```sql
select * from table_name where a = 1 and c = 2
```


这个查询语句只有 a 列用到了索引，c 列没有用到索引，因为中间跳过了 b 列，不是从最左开始连续匹配的。

第五种

```sql
select * from table_name where  a = 1 and b < 3 and c < 1
```

这个查询中只有 a 列和 b 列使用到了索引，而 c 列没有使用索引，因为根据最左匹配查询原则，遇到范围查询会停止。

第六种

```sql
select * from table_name where a like 'ab%'; 
select * from table_name where  a like '%ab'
select * from table_name where  a like '%ab%'
```

对于列为字符串的情况，只有前缀匹配可以使用索引，中缀匹配和后缀匹配只能进行全表扫描。

### 聚集索引

`InnoDB` 使用表的主键构造主键索引树，同时叶子节点中存放的即为整张表的记录数据，这就是聚集索引 / 聚簇索引（Cluster Index）

聚集索引叶子节点的存储是逻辑上连续的，使用双向链表连接，叶子节点按照主键的顺序排序，因此对于主键的排序查找和范围查找速度比较快。

**聚集索引的叶子节点就是整张表的行记录**。InnoDB 主键使用的就是聚集索引。聚集索引要比非聚集索引查询效率高很多。

对于 `InnoDB` 来说，**聚集索引一般是表中的主键索引**

- 如果表中没有显式地指定主键，则会选择表中的第一个不允许为 `NULL` 的唯一索引。
- 如果没有主键也没有合适的唯一索引，那么 `InnoDB` 内部会生成一个**隐藏的主键**作为聚集索引，这个隐藏的主键长度为 6 个字节，它的值会随着数据的插入自增。

除了 Cluster Index 外的索引是 **Secondary Index (辅助索引或二级索引)**。**辅助索引中的叶子节点保存的是聚簇索引的叶子节点的值。**

### 覆盖索引

**如果一个索引包含（或者说覆盖）所有需要查询的字段的值，我们就称之为“覆盖索引”。**

换句话说，**覆盖索引即需要查询的字段正好是索引的字段，那么直接根据该索引，就可以查到数据了， 而无需回表查询。**

对于 `innodb` 表的二级索引，如果索引能覆盖到查询的列，那么就可以避免对主键索引的二次查询。

> 不是所有类型的索引都可以成为覆盖索引。覆盖索引要存储索引列的值，而哈希索引、全文索引不存储索引列的值，所以 MySQL 使用 b+ 树索引做覆盖索引。

#### 语法

对于使用了覆盖索引的查询，在查询前面使用 `explain`，输出的 extra 列会显示为 `using index`。

比如 `user_like` 用户点赞表，组合索引为 `(user_id, blog_id)`，`user_id` 和 `blog_id` 都不为 `null`。

```mysql
explain select blog_id from user_like where user_id = 13;
```

`explain` 结果的 `Extra` 列为 `Using index`，**查询的列被索引覆盖**，并且 where 筛选条件符合最左前缀原则，通过**索引查找**就能直接找到符合条件的数据，不需要回表查询数据。

```mysql
explain select user_id from user_like where blog_id = 1;
```

`explain` 结果的 `Extra` 列为 `Using where; Using index`， 查询的列被索引覆盖，where 筛选条件不符合最左前缀原则，无法通过索引查找找到符合条件的数据，但可以通过**索引扫描**找到符合条件的数据，也不需要回表查询数据。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-7eb2565360584ef8dda13da503f96137_1440w.jpg)

### **前缀索引**

前缀索引是指对文本或者字符串的前几个字符建立索引，这样索引的长度更短，查询速度更快。

如果索引列长度过长，这种列索引时将会产生很大的索引文件，不便于操作，可以使用前缀索引方式进行索引前缀索引应该控制在一个合适的点，控制在 0.31 黄金值即可（大于这个值就可以创建）。

```sql
SELECT COUNT(DISTINCT(LEFT(`title`,10)))/COUNT(*) FROM Arctic;
```

这个值大于 0.31 就可以创建前缀索引，Distinct 去重复

```sql
ALTER TABLE `user` ADD INDEX `uname`(title(10));
```

增加前缀索引 SQL，将人名的索引建立在 10，这样可以减少索引文件大小，加快索引查询速度。

建立前缀索引的方式：

```sql
# email列创建前缀索引
ALTER TABLE table_name ADD KEY(column_name(prefix_length));
```

## 常见的存储引擎

MySQL 中常用的四种存储引擎分别是： **MyISAM**、**InnoDB**、**MEMORY**、**ARCHIVE**。MySQL 5.5 版本后默认的存储引擎为 `InnoDB`。

### InnoDB 存储引擎

InnoDB 是 MySQL **默认的事务型存储引擎**，使用最广泛，基于聚簇索引建立的。InnoDB 内部做了很多优化，如能够自动在内存中创建自适应 hash 索引，以加速读操作。

**优点**：支持事务和崩溃修复能力；引入了行级锁和外键约束。

**缺点**：占用的数据空间相对较大。

**适用场景**：需要事务支持，并且有较高的并发读写频率。

### MyISAM 存储引擎

数据以紧密格式存储。对于只读数据，或者表比较小、可以容忍修复操作，可以使用 MyISAM 引擎。MyISAM 会将表存储在两个文件中，数据文件 `.MYD` 和索引文件 `.MYI`。

**优点**：访问速度快。

**缺点**：MyISAM 不支持事务和行级锁，不支持崩溃后的安全恢复，也不支持外键。

**适用场景**：对事务完整性没有要求；表的数据都会只读的。

### MEMORY 存储引擎

MEMORY 引擎将数据全部放在内存中，访问速度较快，但是一旦系统奔溃的话，数据都会丢失。

MEMORY 引擎默认使用哈希索引，将键的哈希值和指向数据行的指针保存在哈希索引中。

**优点**：访问速度较快。

**缺点**：

1. 哈希索引数据不是按照索引值顺序存储，无法用于排序。
2. 不支持部分索引匹配查找，因为哈希索引是使用索引列的全部内容来计算哈希值的。
3. 只支持等值比较，不支持范围查询。
4. 当出现哈希冲突时，存储引擎需要遍历链表中所有的行指针，逐行进行比较，直到找到符合条件的行。

### ARCHIVE 存储引擎

ARCHIVE 存储引擎非常适合存储大量独立的、作为历史记录的数据。ARCHIVE 提供了压缩功能，拥有高效的插入速度，但是这种引擎不支持索引，所以查询性能较差。

### MyISAM 和 InnoDB 的区别

1. **是否支持行级锁** : `MyISAM` 只有表级锁，而 `InnoDB` 支持行级锁和表级锁，默认为行级锁。
2. **是否支持事务和崩溃后的安全恢复**： `MyISAM` 不提供事务支持。而 `InnoDB` 提供事务支持，具有事务、回滚和崩溃修复能力。
3. **是否支持外键：**`MyISAM` 不支持，而 `InnoDB` 支持。
4. **是否支持MVCC** ：`MyISAM` 不支持，`InnoDB` 支持。应对高并发事务，MVCC 比单纯的加锁更高效。
5. `MyISAM` 不支持聚集索引，`InnoDB` 支持聚集索引。

## MVCC

**多版本并发控制** MVCC (`Multiversion concurrency control`) 就是同一份数据保留多版本的一种方式，进而实现并发控制。在查询的时候，通过**快照**和**版本链**找到对应版本的数据。

为什么需要 MVCC 呢？

- 数据库通常使用锁来实现隔离性。最原生的锁，锁住一个资源后会禁止其他任何线程访问同一个资源。
  - 但是很多应用的一个特点都是读多写少的场景，很多数据的读取次数远大于修改的次数，而读取数据间互相排斥显得不是很必要。
  - 所以就使用了一种读写锁的方法，读锁和读锁之间不互斥，而写锁和写锁、读锁都互斥。这样就很大提升了系统的并发能力。
- 之后人们发现并发读还是不够，又提出了能不能让读写之间也不冲突的方法，就是读取数据时通过一种类似**快照**的方式将数据保存下来，这样读锁就和写锁不冲突了，不同的事务 session 会看到自己特定版本的数据。
  - 当然快照是一种概念模型，不同的数据库可能用不同的方式来实现这种功能。

### 作用

- 在不加锁的情况下，**解决数据库读写冲突问题**，并且解决脏读、幻读（快照读条件下能解决）、不可重复读等问题，但是不能解决丢失修改问题。
- **提升并发性能**。对于高并发场景，MVCC 比行级锁开销更小

### InnoDB 与 MVCC

**MVCC 只在 READ COMMITTED 和 REPEATABLE READ 两个隔离级别下工作。**其他两个隔离级别够和 MVCC 不兼容，因为 READ UNCOMMITTED 总是读取最新的数据行, 而不是符合当前事务版本的数据行。而 SERIALIZABLE 则会对所有读取的行都加锁。

### MVCC 实现原理

#### 版本链

MVCC 的实现依赖于**版本链**，版本链是通过表的三个隐藏字段实现。

- `DB_TRX_ID`：当前事务 id，通过事务 id 的大小判断事务的时间顺序。
- `DB_ROLL_PTR`：回滚指针，指向当前行记录的上一个版本，通过这个指针将数据的多个版本连接在一起构成 `undo log` 版本链。
- `DB_ROW_ID`：主键，如果数据表没有主键，InnoDB 会自动生成主键。

每条记录都会拥有这三个字段，大概是这样的：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-3f2f8eaa0fc8e9b04300f0510fd729dd_1440w.png)

MVCC 做使用到的**快照会存储在 Undo log 中**，该日志通过回滚指针将一个一个数据行的所有快照连接起来，即版本链。

**使用事务更新行记录**的时候，就会生成版本链，执行过程如下：

1. 用排他锁锁住该行；
2. 将该行原本的值拷贝到 `undo log`，作为旧版本用于回滚；
3. 修改当前行的值，生成一个新版本
4. 更新事务 id
5. 使回滚指针指向旧版本的记录，这样就形成一条版本链。

下面举个例子方便大家理解。

1. 初始数据如下，其中 `DB_ROW_ID` 和 `DB_ROLL_PTR` 为空。

![img](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-d2b36b948324e799ad4aebb500b67bf5_1440w.png)

2. 事务 A 对该行数据做了修改，将 `age` 修改为 12，效果如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-6d0a605471a5b9352e45fa30283c8b18_1440w.jpg)

3. 之后事务 B 也对该行记录做了修改，将 `age` 修改为 8，效果如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-66a5a2a01161dc3a8e34ca8629606b71_1440w.jpg)

4. 此时 undo log 有两行记录，并且通过回滚指针连在一起。

#### 快照

快照 `read view` 可以理解成将数据在每个时刻的状态拍成 “照片” 记录下来。在获取某时刻 t 的数据时，到 t 时间点拍的 “照片” 上取数据。

`read view` 中主要就是**有个列表来存储我们系统中当前活跃着的读写事务**，也就是 `begin` 了还未 `commit` 的事务。通过这个列表来判断记录的某个版本是否对当前事务可见。

在 `read view` 内部维护一个活跃事务链表，表示生成 `read view` 的时候还在活跃的事务。这个链表包含在创建 `read view` 之前还未提交的事务，不包含创建 `read view` 之后提交的事务。

:star: 不同隔离级别创建 read view 的时机不同。

- read committed：每次执行 select 都会创建新的 read_view，保证能读取到其他事务已经提交的修改。
- repeatable read：在一个事务范围内，第一次 select 时更新这个 read_view，以后不会再更新，后续所有的 select 都是复用之前的 read_view。这样可以保证事务范围内每次读取的内容都一样，即可重复读。

##### read view 的记录筛选方式

- `trx_ids`: 当前系统活跃 (`未提交`) 事务版本号集合
- `up_limit_id`：表示创建当前快照中的最先开始的事务；
- `low_limit_id` 表示当前快照中的最慢开始的事务，即最后一个事务。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-fef7954f5e3c7713f48b35597e7f9fb8_1440w.jpg)

#### 举例

比如我们有如下表：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-9fa606c971981ff9986534f957172972_1440w.png)

现在有一个事务 id 是 60 的执行如下语句并提交：

```sql
update user set name = '强哥1' where id = 1;
```

此时 undo log 存在版本链如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-1bede18add6acd88fbc4fb0c50db2606_1440w.jpg)

提交事务 id 是 60 的记录后，接着有一个事务 id 为 100 的事务，修改 name=强哥 2，但是事务还没提交。则此时的版本链是：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-cd43dd12a224c36984bd4c12188a2835_1440w.jpg)

此时另一个事务发起 select 语句查询 id=1 的记录，因为 trx_ids 当前只有事务 id 为 100 的，所以该条记录不可见，继续查询下一条，发现 trx_id=60 的事务号小于 up_limit_id，则可见，直接返回结果强哥 1。

那这时候我们把事务 id 为 100 的事务提交了，并且新建了一个事务 id 为 110 也修改 id 为 1 的记录 name=强哥 3，并且不提交事务。这时候版本链就是：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-dc6fa9d9b0db63312160fb61ca464dfd_1440w.jpg)

这时候之前那个 select 事务又执行了一次查询,要查询 id 为 1 的记录。

- 如果你是已提交读隔离级别 READ_COMMITED，这时候你会重新一个 ReadView，那你的活动事务列表中的值就变了，变成了 [110]。按照上的说法，你去版本链通过 trx_id 对比查找到合适的结果就是强哥 2。

- 如果你是可重复读隔离级别 REPEATABLE_READ，这时候你的 ReadView 还是第一次 select 时候生成的 ReadView,也就是列表的值还是 [100]。所以 select 的结果是强哥 1。所以第二次 select 结果和第一次一样，所以叫可重复读！

也就是说已提交读隔离级别下的事务在每次查询的开始都会生成一个独立的 ReadView,而可重复读隔离级别则在第一次读的时候生成一个 ReadView，之后的读都复用之前的 ReadView。

这就是 Mysql 的 MVCC；通过版本链，实现多版本，可并发读 - 写，写 - 读。通过 ReadView 生成策略的不同实现不同的隔离级别。

**总结**：InnoDB 的 `MVCC` 是通过 `read view` 和版本链实现的，版本链保存有历史版本记录，通过 `read view` 判断当前版本的数据是否可见，如果不可见，再从版本链中找到上一个版本，继续进行判断，直到找到一个可见的版本。

### 快照读和当前读

表记录有两种读取方式。

- 快照读：读取的是快照版本。通过 mvcc 来进行并发控制的，不用加锁。
  - **普通的 `SELECT` 就是快照读**。

- 当前读：读取的是最新版本。需要加锁
  - **`UPDATE、DELETE、INSERT、SELECT … LOCK IN SHARE MODE、SELECT … FOR UPDATE` 是当前读**。


快照读情况下，InnoDB 通过 `mvcc` 机制避免了幻读现象。而 `mvcc` 机制无法避免当前读情况下出现的幻读现象。因为当前读每次读取的都是最新数据，这时如果两次查询中间有其它事务插入数据，就会产生幻读。

下面举个例子说明下：

1. 首先，user 表只有两条记录，具体如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-0a1b094961545351dab266afc9771490_1440w.png)

2. 事务 a 和事务 b 同时开启事务 `start transaction`；

3. 事务 b 先进行一次查询（以生成快照）

4. 事务 a 插入数据然后提交；

```mysql
insert into user(user_name, user_password, user_mail, user_state) values('tyson', 'a', 'a', 0);
```

5. 事务 b 执行全表的 update；（这时事务 a 插入的记录也会被更新，因为这是一次当前读）

```mysql
update user set user_name = 'a';
```

6. 事务 b 然后执行查询，查到了事务 a 中插入的数据。因为所有的记录（包括事务 a 插入的记录）的 `db_trx_id` 都变成了事务 b 的 id，所以全部查得到，产生了幻读。（下图左边是事务 b，右边是事务 a。事务开始之前只有两条记录，事务 a 插入一条数据之后，事务 b 查询出来是三条数据）

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-d29cd6193625c5f0691ce921c47822b1_1440w.jpg)

以上就是当前读出现的幻读现象。

**那么 MySQL 是如何避免幻读的？**

- 在快照读情况下，MySQL 通过 `mvcc` 来避免幻读。
- 在当前读情况下，MySQL 通过 `next-key` 来避免幻读（加行锁和间隙锁来实现的）。

next-key 包括两部分：行锁和间隙锁。行锁是加在索引上的锁，间隙锁是加在索引之间的。

`Serializable` 隔离级别也可以避免幻读，会锁住整张表，并发性极低，一般不会使用。

## 锁机制

### 数据库锁与隔离级别的关系、

| 隔离级别 | 实现方式                                 |
| -------- | ---------------------------------------- |
| 读未提交 | 总是读取最新的数据，无需加锁             |
| 读已提交 | 读取数据时加共享锁，读取数据后释放共享锁 |
| 可重复读 | 读取数据时加共享锁，事务结束后释放共享锁 |
| 串行化   | 锁定整个范围的键，一直持有锁直到事务结束 |

### 数据库锁的类型

按照锁的粒度可以将 MySQL 锁分为三种：

![image-20220819134320945](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220819134320945.png)

MyISAM 默认采用表级锁，InnoDB 默认采用行级锁。

从锁的类别上区别可以分为共享锁和排他锁

- 共享锁：**共享锁又称读锁**，简写为 S 锁
  - 一个事务对一个数据对象加了 S 锁，可以对这个数据对象进行读取操作，但不能进行更新操作。
  - 并且在加锁期间其他事务只能对这个数据对象加 S 锁，不能加 X 锁。

- 排他锁：**排他锁又称为写锁**，简写为 X 锁
  - 一个事务对一个数据对象加了 X 锁，可以对这个对象进行读取和更新操作
  - 加锁期间，其他事务不能对该数据对象进行加 X 锁或 S 锁。

### InnoDB 的行锁实现

行锁实现方式：InnoDB 的行锁是通过给索引上的索引项加锁实现的，如果没有索引，InnoDB 将通过隐藏的聚簇索引来对记录进行加锁。

InnoDB 行锁主要分三种情况：

- Record lock：对索引项加锁
- Grap lock：对索引之间的“间隙”、第一条记录前的“间隙”或最后一条后的间隙加锁。
- Next-key lock：前两种放入组合，对记录及前面的间隙加锁。

InnoDB 行锁的特性：如果不通过索引条件检索数据，那么 InnoDB 将对表中所有记录加锁，实际产生的效果和表锁是一样的。

MVCC 不能解决幻读问题，在可重复读隔离级别下，使用 MVCC + Next-Key Locks 可以解决幻读问题。

## bin log / redo log / undo log

MySQL 日志主要包括查询日志、慢查询日志、事务日志、错误日志、二进制日志等。其中比较重要的是 `bin log`（二进制日志）和 `redo log`（重做日志）和 `undo log`（回滚日志）。

### **bin log**

`bin log` 是 MySQL **数据库级别**的文件，记录对 MySQL 数据库执行修改的所有操作，不会记录 select 和 show 语句，主要用于恢复数据库和同步数据库。

### **redo log**

`redo log` 是 innodb **引擎级别**，用来记录 innodb 存储引擎的事务日志，不管事务是否提交都会记录下来，用于数据恢复。

当数据库发生故障，innoDB 存储引擎会使用 `redo log` 恢复到发生故障前的时刻，以此来保证数据的完整性。将参数 `innodb_flush_log_at_tx_commit` 设置为 1，那么在执行 commit 时会将 `redo log` 同步写到磁盘。

### **undo log**

除了记录 `redo log` 外，当进行数据修改时还会记录 `undo log`，`undo log` 用于数据的**撤回**操作，它保留了记录修改前的内容。

通过 `undo log` 可以**实现事务回滚**，并且可以根据 `undo log` 回溯到某个特定的版本的数据，**实现 MVCC**。

### bin log 和 redo log 有什么区别？

1. `bin log` 会记录所有日志记录，包括 InnoDB、MyISAM 等存储引擎的日志；`redo log` 只记录 innoDB 自身的事务日志。
2. `bin log` 只在事务提交前写入到磁盘，一个事务只写一次；而在事务进行过程，会有 `redo log` 不断写入磁盘。
3. `bin log` 是逻辑日志，记录的是 SQL 语句的原始逻辑；`redo log` 是物理日志，记录的是在某个数据页上做了什么修改。

## MySQL 架构

MySQL 主要分为 Server 层和存储引擎层：

- **Server 层**：主要包括连接器、查询缓存、分析器、优化器、执行器等，所有跨存储引擎的功能都在这一层实现，比如存储过程、触发器、视图，函数等，还有一个通用的日志模块 binglog 日志模块。
  - **连接器：** 当客户端连接 MySQL 时，server 层会对其进行身份认证和权限校验。
  - **查询缓存:** 执行查询语句的时候，会先查询缓存，先校验这个 sql 是否执行过，如果有缓存这个 sql，就会直接返回给客户端，如果没有命中，就会执行后续的操作。
  - **分析器：**没有命中缓存的话，SQL 语句就会经过分析器，主要分为两步，词法分析和语法分析，先看 SQL 语句要做什么，再检查 SQL 语句语法是否正确。
  - **优化器：** 优化器对查询进行优化，包括重写查询、决定表的读写顺序以及选择合适的索引等，生成执行计划。
  - **执行器：** 首先执行前会校验该用户有没有权限，如果没有权限，就会返回错误信息，如果有权限，就会根据执行计划去调用引擎的接口，返回结果。
- **存储引擎层**： 主要负责数据的存储和读取。server 层通过 api 与存储引擎进行通信。

## 分库分表

当单表的数据量达到 1000W 或 100G 以后，优化索引、添加从库等可能对数据库性能提升效果不明显，此时就要考虑对其进行切分了。切分的目的就在于减少数据库的负担，缩短查询的时间。

数据切分可以分为两种方式：垂直划分和水平划分。

### 两种方式

#### 垂直划分

垂直划分数据库是根据业务进行划分，例如购物场景，可以将库中涉及商品、订单、用户的表分别划分出成一个库，通过降低单库的大小来提高性能。同样的，分表的情况就是将一个大表根据业务功能拆分成一个个子表，例如商品基本信息和商品描述，商品基本信息一般会展示在商品列表，商品描述在商品详情页，可以将商品基本信息和商品描述拆分成两张表。



![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-1a3cfa1645cb5c1812e1d2d0a713835e_1440w.jpg)



**优点**：行记录变小，数据页可以存放更多记录，在查询时减少 I/O 次数。

**缺点**：

- 主键出现冗余，需要管理冗余列；
- 会引起表连接 JOIN 操作，可以通过在业务服务器上进行 join 来减少数据库压力；
- 依然存在单表数据量过大的问题。

#### 水平划分

水平划分是根据一定规则，例如时间或 id 序列值等进行数据的拆分。比如根据年份来拆分不同的数据库。每个数据库结构一致，但是数据得以拆分，从而提升性能。



![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-406d883a97128e9e4b1ea6f97afd1108_1440w.jpg)



**优点**：单库（表）的数据量得以减少，提高性能；切分出的表结构相同，程序改动较少。

**缺点**：

- 分片事务一致性难以解决
- 跨节点 `join` 性能差，逻辑复杂
- 数据分片在扩容时需要迁移

### 分区表

分区是把一张表的数据分成 N 多个区块。**分区表是一个独立的逻辑表，但是底层由多个物理子表组成。**

当查询条件的数据分布在某一个分区的时候，查询引擎只会去某一个分区查询，而不是遍历整个表。在管理层面，如果需要删除某一个分区的数据，只需要删除对应的分区即可。

分区一般都是放在单机里的，用的比较多的是时间范围分区，方便归档。只不过**分库分表需要代码实现，分区则是 mysql 内部实现。分库分表和分区并不冲突，可以结合使用。**

### 分区表类型

#### range 分区

按照范围分区。比如按照时间范围分区	

```sql
CREATE TABLE test_range_partition(
       id INT auto_increment,
       createdate DATETIME,
       primary key (id,createdate)
   ) 
   PARTITION BY RANGE (TO_DAYS(createdate) ) (
      PARTITION p201801 VALUES LESS THAN ( TO_DAYS('20180201') ),
      PARTITION p201802 VALUES LESS THAN ( TO_DAYS('20180301') ),
      PARTITION p201803 VALUES LESS THAN ( TO_DAYS('20180401') ),
      PARTITION p201804 VALUES LESS THAN ( TO_DAYS('20180501') ),
      PARTITION p201805 VALUES LESS THAN ( TO_DAYS('20180601') ),
      PARTITION p201806 VALUES LESS THAN ( TO_DAYS('20180701') ),
      PARTITION p201807 VALUES LESS THAN ( TO_DAYS('20180801') ),
      PARTITION p201808 VALUES LESS THAN ( TO_DAYS('20180901') ),
      PARTITION p201809 VALUES LESS THAN ( TO_DAYS('20181001') ),
      PARTITION p201810 VALUES LESS THAN ( TO_DAYS('20181101') ),
      PARTITION p201811 VALUES LESS THAN ( TO_DAYS('20181201') ),
      PARTITION p201812 VALUES LESS THAN ( TO_DAYS('20190101') )
   );
```

在 `/var/lib/mysql/data/` 可以找到对应的数据文件，每个分区表都有一个使用 `#` 分隔命名的表文件：

```sql
   -rw-r----- 1 MySQL MySQL    65 Mar 14 21:47 db.opt
   -rw-r----- 1 MySQL MySQL  8598 Mar 14 21:50 test_range_partition.frm
   -rw-r----- 1 MySQL MySQL 98304 Mar 14 21:50 test_range_partition#P#p201801.ibd
   -rw-r----- 1 MySQL MySQL 98304 Mar 14 21:50 test_range_partition#P#p201802.ibd
   -rw-r----- 1 MySQL MySQL 98304 Mar 14 21:50 test_range_partition#P#p201803.ibd
...
```

#### list 分区

list 分区和 range 分区相似，主要区别在于 list 是枚举值（离散）列表的集合，range 是连续的区间值的集合。

对于 list 分区，分区字段必须是**已知**的，如果插入的字段不在分区时的枚举值中，将无法插入。

```sql
create table test_list_partiotion
   (
       id int auto_increment,
       data_type tinyint,
       primary key(id,data_type)
   )partition by list(data_type)
   (
       partition p0 values in (0,1,2,3,4,5,6),
       partition p1 values in (7,8,9,10,11,12),
       partition p2 values in (13,14,15,16,17)
   );
```

#### hash 分区

可以将数据均匀地分布到预先定义的分区中。

```sql
create table test_hash_partiotion
   (
       id int auto_increment,
       create_date datetime,
       primary key(id,create_date)
   )partition by hash(year(create_date)) partitions 10;
```

### 分区的问题

1. 打开和锁住所有底层表的成本可能很高。当查询访问分区表时，MySQL 需要打开并锁住所有的底层表，这个操作在分区过滤之前发生，所以无法通过分区过滤来降低此开销，会影响到查询速度。可以通过批量操作来降低此类开销，比如批量插入、`LOAD DATA INFILE` 和一次删除多行数据。
2. 维护分区的成本可能很高。例如重组分区，会先创建一个临时分区，然后将数据复制到其中，最后再删除原分区。
3. 所有分区必须使用相同的存储引擎。

## 主从同步

### 定义

#### 什么是主从同步

主从同步 / 主从复制使得**数据可以从一个数据库服务器复制到其他服务器上**，在复制数据时，一个服务器充当主服务器（`master`），其余的服务器充当从服务器（`slave`）。

因为复制是异步进行的，所以从服务器不需要一直连接着主服务器，从服务器甚至可以通过拨号断断续续地连接主服务器。通过配置文件，可以指定复制所有的数据库，某个数据库，甚至是某个数据库上的某个表。

#### 为什么要做主从同步

1. **读写分离**，使数据库能支撑更大的并发。
2. 在主服务器上生成实时数据，而在从服务器上分析这些数据，从而提高主服务器的性能。
3. **数据备份**，保证数据的安全。

#### 读写分离

读写分离主要依赖于主从复制，主从复制为读写分离服务。

读写分离的优势：

- 主服务器负责写，从服务器负责读，**缓解了锁的竞争**
- **从服务器可以使用 MyISAM**，提升查询性能及节约系统开销
- **增加冗余**，提高可用性

### 主从复制的实现

为保证主服务器和从服务器的数据一致性，在向主服务器插入数据后，从服务器会自动将主服务器中修改的数据同步过来。

主从复制主要有三个线程：binlog 线程，I/O 线程，SQL 线程。

- binlog 线程：负责将主服务器上的数据更改写入到二进制日志（Binary log）中
- I/O 线程：负责从主服务器上读取 bin log，并写入从服务器的中继日志（Relay log）中
- SQL 线程：负责读取中继日志，解析出主服务器中已经执行的数据更改并在从服务器中重放

![图片](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/cfc5c1bd741803f8ce6208cb8666657a.png)

- Master 在每个事务更新数据完成之前，将操作记录写入到 bin log 中。
- Slave 从库连接 Master 主库，并且 Master 有多少个 Slave 就会创建多少个 binlog dump 线程。当 Master 节点的 binlog 发生变化时，binlog dump 会通知所有的 Slave，并将相应的 binlog 发送给 Slave。

- I/O 线程接收到 bin log 内容后，将其写入到中继日志（Relay log）中。
- SQL 线程读取中继日志，并在从服务器中重放。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/092506ce418ae6bc3bcccc9e34739092.png" alt="图片" style="zoom:50%;" />

### 乐观锁和悲观锁

数据库中的并发控制是确保在多个事务同时存取数据库中同一数据时不破坏事务的隔离性和统一性以及数据库的统一性。乐观锁和悲观锁是并发控制主要采用的技术手段。

- **悲观锁**
  - 假定会发生并发冲突，会对操作的数据进行加锁，直到提交事务，才会释放锁，其他事务才能进行修改。实现方式：使用数据库中的锁机制。
- **乐观锁**
  - 假设不会发生并发冲突，只在提交操作时检查是否数据是否被修改过。给表增加`version`字段，在修改提交之前检查`version`与原来取到的`version`值是否相等，若相等，表示数据没有被修改，可以更新，否则，数据为脏数据，不能更新。实现方式：乐观锁一般使用版本号机制或`CAS`算法实现。

## 执行一条 select 语句，期间发生了什么

### MySQL 执行流程

下面就是 MySQL 执行一条 SQL 查询语句的流程，也从图中可以看到 MySQL 内部架构里的各个功能模块。

![mysql查询流程](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/mysql%E6%9F%A5%E8%AF%A2%E6%B5%81%E7%A8%8B.webp)

可以看到， MySQL 的架构共分为两层：**Server 层和存储引擎层**，

- **Server 层负责建立连接、分析和执行 SQL**。
  - MySQL 大多数的核心功能模块都在这实现，主要包括连接器，查询缓存、解析器、预处理器、优化器、执行器等。
  - 另外，所有的内置函数（如日期、时间、数学和加密函数等）和所有跨存储引擎的功能（如存储过程、触发器、视图等）都在 Server 层实现。
- **存储引擎层负责数据的存储和提取**。
  - 支持 InnoDB、MyISAM、Memory 等多个存储引擎，不同的存储引擎共用一个 Server 层。
  - 现在最常用的存储引擎是 InnoDB，从 MySQL 5.5 版本开始， InnoDB 成为了 MySQL 的默认存储引擎。
  - 我们常说的索引数据结构，就是由存储引擎层实现的，不同的存储引擎支持的索引类型也不相同，比如 InnoDB 支持索引类型是 B+树 ，且是默认使用，也就是说在数据表中创建的主键索引和二级索引默认使用的是 B+ 树索引。

好了，现在我们对 Server 层和存储引擎层有了一个简单认识，接下来，就详细说一条 SQL 查询语句的执行流程，依次看看每一个功能模块的作用

### 第一步：连接器

> - 与客户端进行 TCP 三次握手建立连接；
> - 校验客户端的用户名和密码，如果用户名或密码不对，则会报错；
> - 如果用户名和密码都对了，会读取该用户的权限，然后后面的权限逻辑判断都基于此时读取到的权限；

如果你在 Linux 操作系统里要使用 MySQL，那你第一步肯定是要先连接 MySQL 服务，然后才能执行 SQL 语句，普遍我们都是使用下面这条命令进行连接：

```shell
# -h 指定 MySQL 服务得 IP 地址，如果是连接本地的 MySQL服务，可以不用这个参数；
# -u 指定用户名，管理员角色名为 root；
# -p 指定密码，如果命令行中不填写密码（为了密码安全，建议不要在命令行写密码），就需要在交互对话里面输入密码
mysql -h$ip -u$user -p
```

连接的过程需要先经过 TCP 三次握手，因为 MySQL 是基于 TCP 协议进行传输的，如果 MySQL 服务并没有启动，则会收到如下的报错：

![image-20220907164625911](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907164625911.png)

如果 MySQL 服务正常运行，完成 TCP 连接的建立后，连接器就要开始验证你的用户名和密码，如果用户名或密码不对，就收到一个 "Access denied for user" 的错误，然后客户端程序结束执行。

![image-20220907164613666](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907164613666.png)

如果用户密码都没有问题，连接器就会获取该用户的权限，然后保存起来，后续该用户在此连接里的任何操作，都会基于连接开始时读到的权限进行权限逻辑的判断。

所以，如果一个用户已经建立了连接，**即使管理员中途修改了该用户的权限，也不会影响已经存在连接的权限**。修改完成后，只有再新建的连接才会使用新的权限设置。

#### 查看客户端连接数量

如果你想知道当前 MySQL 服务被多少个客户端连接了，你可以执行 `show processlist` 命令进行查看。

![image-20220907165326669](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907165326669.png)

比如上图的显示结果，共有两个用户名为 root 的用户连接了 MySQL 服务，其中 id 为 6 的用户的 Command 列的状态为 `Sleep` ，这意味着该用户连接完 MySQL 服务就没有再执行过任何命令，也就是说这是一个空闲的连接，并且空闲的时长是 736 秒（ Time 列）

#### 空闲连接

MySQL 定义了空闲连接的最大空闲时长，由 `wait_timeout` 参数控制的，默认值是 8 小时（28880 秒），如果空闲连接超过了这个时间，连接器就会自动将它断开。

```sql
mysql> show variables like 'wait_timeout';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| wait_timeout  | 28800 |
+---------------+-------+
1 row in set (0.00 sec)
```

当然，我们自己也可以手动断开空闲的连接，使用的是 `kill connection + id` 的命令。

```sql
mysql> kill connection +6;
Query OK, 0 rows affected (0.00 sec)
```

一个处于空闲状态的连接被服务端主动断开后，这个客户端并不会马上知道，等到客户端在发起下一个请求的时候，才会收到这样的报错 “ERROR 2013 (HY000): Lost connection to MySQL server during query”。

#### 最大连接数

MySQL 服务支持的最大连接数由 max_connections 参数控制，比如我的 MySQL 服务默认是 151 个，超过这个值，系统就会拒绝接下来的连接请求，并报错提示 “Too many connections”。

```sql
mysql> show variables like 'max_connections';
+-----------------+-------+
| Variable_name   | Value |
+-----------------+-------+
| max_connections | 151   |
+-----------------+-------+
1 row in set (0.00 sec)
```

#### 短连接和长连接

MySQL 的连接也跟 HTTP 一样，有短连接和长连接的概念，它们的区别如下：

```c
// 短连接
连接 mysql 服务（TCP 三次握手）
执行sql
断开 mysql 服务（TCP 四次挥手）

// 长连接
连接 mysql 服务（TCP 三次握手）
执行sql
执行sql
执行sql
....
断开 mysql 服务（TCP 四次挥手）
```

可以看到，使用长连接的好处就是可以减少建立连接和断开连接的过程，所以一般是推荐使用长连接。

但是，使用长连接后可能会占用内存增多，因为 MySQL 在执行查询过程中临时使用内存管理连接对象，这些连接对象资源只有在连接断开时才会释放。如果长连接累计很多，将导致 MySQL 服务占用内存太大，有可能会被系统强制杀掉，这样会发生 MySQL 服务异常重启的现象。

#### 解决长连接占用内存的问题

有两种解决方式。

第一种，**定期断开长连接**。既然断开连接后就会释放连接占用的内存资源，那么我们可以定期断开长连接。

第二种，**客户端主动重置连接**。MySQL 5.7 版本实现了 `mysql_reset_connection()` 函数的接口，注意这是接口函数不是命令，那么当客户端执行了一个很大的操作后，在代码里调用 mysql_reset_connection 函数来重置连接，达到释放内存的效果。这个过程不需要重连和重新做权限验证，但是会将连接恢复到刚刚创建完时的状态。

### 第二步：查询缓存

连接器完成工作后，客户端就可以向 MySQL 服务发送 SQL 语句了，MySQL 服务收到 SQL 语句后，就会解析出 SQL 语句的第一个字段，看看是什么类型的语句。

如果 SQL 是查询语句（select 语句），MySQL 就会先去查询缓存（Query Cache）里查找缓存数据，看看之前有没有执行过这一条命令，这个查询缓存是以 key-value 形式保存在内存中的，key 为 SQL 查询语句，value 为 SQL 语句查询的结果。

- 如果查询的语句命中查询缓存，那么就会直接返回 value 给客户端。
- 如果查询的语句没有命中查询缓存中，那么就要往下继续执行，等执行完后，查询的结果就会被存入查询缓存中。

这么看，查询缓存还挺有用，但是其实**查询缓存挺鸡肋**的。

对于更新比较频繁的表，查询缓存的命中率很低的，因为只要一个表有更新操作，那么这个表的查询缓存就会被清空。如果刚缓存了一个查询结果很大的数据，还没被使用的时候，刚好这个表有更新操作，查询缓冲就被清空了，相当于缓存了个寂寞。

所以，**MySQL 8.0 版本直接将查询缓存删掉了**，也就是说 MySQL 8.0 开始，执行一条 SQL 查询语句，不会再走到查询缓存这个阶段了。

对于 MySQL 8.0 之前的版本，如果想关闭查询缓存，我们可以通过将参数 query_cache_type 设置成 DEMAND。

> 这里说的查询缓存是 server 层的，也就是 MySQL 8.0 版本移除的是 server 层的查询缓存，并不是 Innodb 存储引擎中的 buffer poll

### 第三步：解析 SQL

在正式执行 SQL 查询语句之前， MySQL 会先对 SQL 语句做解析，这个工作交由由「解析器」来完成。

#### 解析器

解析器会做如下两件事情。

第一件事情，**词法分析**。MySQL 会根据你输入的字符串识别出关键字出来，构建出 SQL 语法树，这样方便后面模块获取 SQL 类型、表名、字段名、 where 条件等等。

第二件事情，**语法分析**。根据词法分析的结果，语法解析器会根据语法规则，判断你输入的这个 SQL 语句是否满足 MySQL 语法。

如果我们输入的 SQL 语句语法不对，就会在解析器这个阶段报错。比如，我下面这条查询语句，把 from 写成了 form，这时 MySQL 解析器就会给报错。

![image-20220907170914385](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907170914385.png)

但是注意，表不存在或者字段不存在，并不是在解析器里做的

那到底谁来做检测表和字段是否存在的工作呢？别急，接下来就是了

### 第四步：执行 SQL

经过解析器后，接着就要进入执行 SQL 查询语句的流程了，每条 `SELECT` 查询语句流程主要可以分为下面这三个阶段：

- prepare 阶段，也就是**预处理**阶段；
- optimize 阶段，也就是**优化**阶段；
- execute 阶段，也就是**执行**阶段；

#### 预处理器

我们先来说说预处理阶段做了什么事情。

- 检查 SQL 查询语句中的表或者字段是否存在；
- 将 `select *` 中的 `*` 符号，扩展为表上的所有列；

我下面这条查询语句，test 这张表是不存在的，这时 MySQL 就会在执行 SQL 查询语句的 prepare 阶段中报错。

```sql
mysql> select * from test;
ERROR 1146 (42S02): Table 'mysql.test' doesn't exist
```

#### 优化器

经过预处理阶段后，还需要为 SQL 查询语句先制定一个执行计划，这个工作交由「优化器」来完成的。

**优化器主要负责将 SQL 查询语句的执行方案确定下来**，比如在表里面有多个索引的时候，优化器会基于查询成本的考虑，来决定选择使用哪个索引。

当然，我们本次的查询语句（select * from product where id = 1）很简单，就是选择使用主键索引。

要想知道优化器选择了哪个索引，我们可以在查询语句最前面加个 `explain` 命令，这样就会输出这条 SQL 语句的执行计划，然后执行计划中的 key 就表示执行过程中使用了哪个索引，比如下图的 key 为 `PRIMARY` 就是使用了主键索引。

![image-20220907171242556](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907171242556.png)

如果查询语句的执行计划里的 key 为 null 说明没有使用索引，那就会全表扫描（type = ALL），这种查询扫描的方式是效率最低档次的，如下图：

![image-20220907171526456](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907171526456.png)

这张 product 表只有一个索引就是主键，现在我在表中将 name 设置为普通索引（二级索引）

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907171632634.png" alt="image-20220907171632634" style="zoom:50%;" />



这时 product 表就有主键索引（id）和普通索引（name）。假设执行了这条查询语句：

```sql
select id from product where id > 1  and name like 'i%';
```

这条查询语句的结果既可以使用主键索引，也可以使用普通索引，但是执行的效率会不同。这时，就需要优化器来决定使用哪个索引了。

很显然这条查询语句是**覆盖索引**，直接在二级索引就能查找到结果（因为二级索引的 B+ 树的叶子节点的数据存储的是主键值），就没必要在主键索引查找了，因为查询主键索引的 B+ 树的成本会比查询二级索引的 B+ 的成本大，优化器基于查询成本的考虑，会选择查询代价小的普通索引。

在下图中执行计划，我们可以看到，执行过程中使用了普通索引（name），Exta 为 Using index，这就是表明使用了覆盖索引优化。

![image-20220908223202640](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220908223202640.png)

#### 执行器

经历完优化器后，就确定了执行方案，接下来 MySQL 就真正开始执行语句了，这个工作是由「执行器」完成的。在执行的过程中，执行器就会和存储引擎交互了，交互是以记录为单位的。

接下来，用三种方式执行过程，跟大家说一下执行器和存储引擎的交互过程

- 主键索引查询
- 全表扫描
- 索引下推

##### 主键索引查询

以本文开头查询语句为例，看看执行器是怎么工作的。

```sql
select * from product where id = 1;
```

这条查询语句的查询条件用到了主键索引，而且是等值查询，同时主键 id 是唯一，不会有 id 相同的记录，所以优化器决定选用访问类型为 const 进行查询，也就是使用主键索引查询一条记录，那么执行器与存储引擎的执行流程是这样的：

- 执行器第一次查询，会调用 `read_first_record` 函数指针指向的函数，因为优化器选择的访问类型为 `const`，这个函数指针被指向为 InnoDB 引擎索引查询的接口，把条件 `id = 1` 交给存储引擎，**让存储引擎定位符合条件的第一条记录**。
- 存储引擎通过主键索引的 B+ 树结构定位到 id = 1 的第一条记录
  - 如果记录是不存在的，就会向执行器上报记录找不到的错误，然后查询结束
  - 如果记录是存在的，就会将记录返回给执行器
- 执行器从存储引擎读到记录后，接着判断记录是否符合查询条件，如果符合则发送给客户端，如果不符合则跳过该记录。
- 执行器查询的过程是一个 while 循环，所以还会再查一次，但是这次因为不是第一次查询了，所以会调用 read_record 函数指针指向的函数，因为优化器选择的访问类型为 const，这个函数指针被指向为一个永远返回 -1 的函数，所以当调用该函数的时候，执行器就退出循环，也就是结束查询了。

至此，这个语句就执行完成了。

##### 全表扫描

举个全表扫描的例子：

```sql
select * from product where name = 'iphone';
```

这条查询语句的查询条件没有用到索引，所以优化器决定选用访问类型为 ALL 进行查询，也就是全表扫描的方式查询，那么这时执行器与存储引擎的执行流程是这样的：

- 执行器第一次查询，会调用 `read_first_record` 函数指针指向的函数，因为优化器选择的访问类型为 all，这个函数指针被指向为 InnoDB 引擎全扫描的接口，**让存储引擎读取表中的第一条记录**；
- 执行器会判断读到的这条记录的 name 是不是 iphone，
  - 如果不是则跳过；
  - 如果是则将记录发给客户的（是的没错，Server 层每从存储引擎读到一条记录就会发送给客户端，之所以客户端显示的时候是直接显示所有记录的，是因为客户端是等查询语句查询完成后，才会显示出所有的记录）
- 执行器查询的过程是一个 while 循环，所以还会再查一次，会调用 read_record 函数指针指向的函数，因为优化器选择的访问类型为 all，read_record 函数指针指向的还是 InnoDB 引擎全扫描的接口，所以接着向存储引擎层要求继续读刚才那条记录的下一条记录，存储引擎把下一条记录取出后就将其返回给执行器（Server 层），执行器继续判断条件，不符合查询条件即跳过该记录，否则发送到客户端；
- 一直重复上述过程，直到存储引擎把表中的所有记录读完，然后向执行器（Server 层） 返回了读取完毕的信息；
- 执行器收到存储引擎报告的查询完毕的信息，退出循环，停止查询。

至此，这个语句就执行完成了

##### 索引下推

在这部分非常适合讲索引下推（MySQL 5.6 推出的查询优化策略），这样大家能清楚的知道，「下推」这个动作，下推到了哪里。

**索引下推能够减少二级索引在查询时的回表操作，提高查询的效率**，因为它将 Server 层部分负责的事情，交给存储引擎层去处理了。

举一个具体的例子，方便大家理解，这里一张用户表如下，我对 age 和 reward 字段建立了联合索引（age，reward）：

![image-20220908223931127](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220908223931127.png)

现在有下面这条查询语句：

```sql
select * from t_user  where age > 20 and reward = 100000;
```

联合索引当遇到范围查询 (>、<、between、like) 就会停止匹配，也就是 **age 字段能用到联合索引，但是 reward 字段则无法利用到索引**。

那么，不使用索引下推（MySQL 5.6 之前的版本）时，执行器与存储引擎的执行流程是这样的：

- Server 层首先调用存储引擎的接口定位到满足查询条件的第一条二级索引记录，也就是定位到 age > 20 的第一条记录；
- 存储引擎根据二级索引的 B+ 树快速定位到这条记录后，获取主键值，然后**进行回表操作**，将完整的记录返回给 Server 层；
- Server 层在判断该记录的 reward 是否等于 100000，如果成立则将其发送给客户端；否则跳过该记录；
- 接着，继续向存储引擎索要下一条记录，存储引擎在二级索引定位到记录后，获取主键值，然后回表操作，将完整的记录返回给 Server 层；
- 如此往复，直到存储引擎把表中的所有记录读完。

可以看到，没有索引下推的时候，每查询到一条二级索引记录，都要进行回表操作，然后将记录返回给 Server，接着 Server 再判断该记录的 reward 是否等于 100000。

而使用索引下推后，判断记录的 reward 是否等于 100000 的工作交给了存储引擎层，过程如下 ：

- Server 层首先调用存储引擎的接口定位到满足查询条件的第一条二级索引记录，也就是定位到 age > 20 的第一条记录；
- 存储引擎定位到二级索引后，**先不执行回表**操作，而是先判断一下该索引中包含的列（reward 列）的条件（reward 是否等于 100000）是否成立。
  - 如果条件不成立，则直接**跳过该二级索引**。
  - 如果成立，则**执行回表**操作，将完成记录返回给 Server 层。
- Server 层在判断其他的查询条件（本次查询没有其他条件）是否成立，如果成立则将其发送给客户端；否则跳过该记录，然后向存储引擎索要下一条记录。
- 如此往复，直到存储引擎把表中的所有记录读完。

可以看到，使用了索引下推后，虽然 reward 列无法使用到联合索引，但是因为它包含在联合索引（age，reward）里，所以直接在存储引擎过滤出满足 reward = 100000 的记录后，才去执行回表操作获取整个记录。相比于没有使用索引下推，节省了很多回表操作。

当你发现执行计划里的 Extr 部分显示了 “Using index condition”，说明使用了索引下推。

![image-20220908224241807](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220908224241807.png)

### 总结

执行一条 SQL 查询语句，期间发生了什么？

- 连接器：建立连接，管理连接、校验用户身份；
- 查询缓存：查询语句如果命中查询缓存则直接返回，否则继续往下执行。MySQL 8.0 已删除该模块；
- 解析 SQL，通过解析器对 SQL 查询语句进行词法分析、语法分析，然后构建语法树，方便后续模块读取表名、字段、语句类型；
- 执行 SQL：执行 SQL 共有三个阶段：
  - 预处理阶段：检查表或字段是否存在；将 `select *` 中的 `*` 符号扩展为表上的所有列。
  - 优化阶段：基于查询成本的考虑， 选择查询成本最小的执行计划；
  - 执行阶段：根据执行计划执行 SQL 查询语句，从存储引擎读取记录，返回给客户端；

## 其他八股

### 事务的四大特性 ACID

**事务特性 ACID**：**原子性**（`Atomicity`）、**一致性**（`Consistency`）、**隔离性**（`Isolation`）、**持久性**（`Durability`）。

- **原子性**是指事务是最小的单位，不可以再分割；同一事务中的 SQL 语句，必须保证同时完成
- **一致性**是指一个事务执行之前和执行之后都必须处于一致性状态。比如 a 与 b 账户共有 1000 块，两人之间转账之后无论成功还是失败，它们的账户总和还是 1000。
- **隔离性**。跟隔离级别相关，如 `read committed`，一个事务只能读到已经提交的修改。
- **持久性**是指一个事务一旦被提交了，那么对数据库中的数据的改变就是永久性的，即便是在数据库系统遇到故障的情况下也不会丢失提交事务的操作。

### 数据库的三大范式

**第一范式 1NF**

确保数据库表字段的原子性。

比如字段 `userInfo`: `广东省 10086'` ，依照第一范式必须拆分成 `userInfo`: `广东省` `userTel`:`10086`两个字段。

**第二范式 2NF**

首先要满足第一范式，另外包含两部分内容：

- 表必须有一个主键；
- 非主键列必须**完全依赖**于主键，而不能只依赖于主键的一部分。

举个例子。假定选课关系表为 `student_course`(student_no, student_name, age, course_name, grade, credit)，主键为 (student_no, course_name)。其中学分完全依赖于课程名称，姓名年龄完全依赖学号，不符合第二范式，会导致**数据冗余**（学生选 n 门课，姓名年龄有 n 条记录）、**插入异常**（插入一门新课，因为没有学号，无法保存新课记录）等问题。

应该拆分成三个表：学生：`student`(stuent_no, student_name, 年龄)；课程：`course`(course_name, credit)；选课关系：`student_course_relation`(student_no, course_name, grade)。

**第三范式 3NF**

首先要满足第二范式，另外**非主键列必须直接依赖于主键，不能存在传递依赖**。

即不能存在：非主键列 A 依赖于非主键列 B，非主键列 B 依赖于主键的情况。

假定学生关系表为 Student(student_no, student_name, age, academy_id, academy_telephone)，主键为"学号"，其中学院 id 依赖于学号，而学院地点和学院电话依赖于学院 id，存在传递依赖，不符合第三范式。

可以把学生关系表分为如下两个表：学生：(student_no, student_name, age, academy_id)；学院：(academy_id, academy_telephone)。

**2NF 和 3NF的区别？**

- 2NF 依据是非主键列是否**完全依赖**于主键，还是依赖于主键的一部分。
- 3NF 依据是非主键列是否直接依赖于主键，即有无**传递依赖**的情况发生

### 事务隔离级别

先了解下几个概念：脏读、不可重复读、幻读。

- **脏读**：在一个事务处理过程里读取了另一个**未提交**的事务中的数据。
- **不可重复读**：在对于数据库中的某行记录，**一个事务范围内多次查询却返回了不同的数据值**，这是由于在查询间隔，**另一个事务修改了数据并提交了**。
- **幻读**：某个事务 A 在读取某个范围内的记录时，另外一个事务 B 又在该范围内插入了新的记录，但是当事务 A 再次查询时却感受不到这种变化
  - 对幻读的正确理解是**一个事务范围内的读取操作的结论不能支撑之后业务的执行**。（因为有并发写的情况出现）
    - 假设事务要新增一条记录，主键为 id，在新增之前执行了 select，没有发现 id 为 xxx 的记录，但插入时出现主键冲突，这就属于幻读
    - 读取不到记录却发现主键冲突是因为记录实际上已经被其他的事务插入了，但当前事务不可见。

不可重复读和脏读的区别是，脏读是某一事务读取了另一个事务未提交的脏数据，而不可重复读则是读取了前一事务提交的数据。

不可重复度和幻读的区别是：在不可重复读中，发现数据不一致主要是数据被**更新**了。在幻读中，发现数据不一致主要是数据**增多或者减少**了

事务隔离就是为了解决上面提到的脏读、不可重复读、幻读这几个问题。

MySQL 数据库为我们提供的**四种隔离级别**：

- **Read uncommitted** (**读未提交**)
  - 所有事务都可以看到其他未提交事务的执行结果。
- **Read committed** (**读已提交**)
  - 一个事务只能看见已经提交事务所做的改变。
  - 解决了脏读的问题。
- **Repeatable read** (**可重复读**)
  - 在同一个事务中多次读取到的数据是一致的。
  - MySQL 的**默认**事务隔离级别，它确保同一事务的多个实例在并发读取数据时，会看到同样的数据行
  - 事务 A 只能在事务 B 修改过数据并提交后，自己也提交事务后，才能读取到事务 B 修改的数据。
  - 解决了不可重复读的问题。
  - 可以通过间隙锁来解决幻读问题
  
- **Serializable** (**串行化**)
  - 通过**强制事务串行执行**，使之不可能相互冲突
  - 通过加锁实现（读锁和写锁）
  - 解决了幻读的问题。

查看隔离级别：

```mysql
select @@transaction_isolation;
```

设置隔离级别：

```mysql
set session transaction isolation level read uncommitted;
```

事务的隔离机制主要是依靠**锁机制**和 **MVCC** (多版本并发控制)实现的，提交读和可重复读可以通过 MVCC 实现，串行化可以通过锁机制实现。

### 生产环境数据库一般用的什么隔离级别

**生产环境大多使用 RC**。为什么不是 RR 呢？

> 可重复读 (Repeatable Read)，简称为 RR
>
> 读已提交 (Read Commited)，简称为 RC

缘由一：在 RR 隔离级别下，存在**间隙锁**，导致出现死锁的几率比 RC 大的多

缘由二：在 RR 隔离级别下，条件列未命中索引会**锁表**！而在 RC 隔离级别下，只**锁行**!

也就是说，**RC 的并发性高于 RR**。

并且大部分场景下，不可重复读问题是可以接受的。毕竟数据都已经提交了，读出来本身就没有太大问题！

[互联网项目中 mysql 应该选什么事务隔离级别](https://zhuanlan.zhihu.com/p/59061106)

### 可重复读隔离下为什么会产生幻读

**在可重复读隔离级别下，普通的查询是快照读**，是不会看到别的事务插入的数据的。因此，**幻读在当前读下才会出现**。

什么是快照读，什么是当前读？

快照读读取的是快照数据。不加锁的简单的 `SELECT` 都属于快照读，比如这样：

```sql
SELECT * FROM player WHERE ...
```

当前读就是读取最新数据，而不是历史版本的数据。加锁的 SELECT，或者对数据进行增删改都会进行当前读。

这有点像是 Java 中的 volatile 关键字，被 volatile 修饰的变量，进行修改时，JVM 会强制将其写回内存，而不是放在 CPU 缓存中，进行读取时，JVM 会强制从内存读取，而不是放在 CPU 缓存中。

这样就能保证其可见行，保证每次读取到的都是最新的值。

继续来看，如下的操作都会进行当前读。

```sql
SELECT * FROM player LOCK IN SHARE MODE;
SELECT * FROM player FOR UPDATE;
INSERT INTO player values ...
DELETE FROM player WHERE ...
UPDATE player SET ...
```

说白了，**快照读就是普通的读操作，而当前读包括了加锁的读取和 DML**（DML，Data Manipulation Language，数据操纵语言，只是对表内部的数据操作，不涉及表的定义，结构的修改。主要包括 insert、update、deletet） 

> 比如在可重复读的隔离条件下，我开启了两个事务，在事务 B 中进行了插入操作，事务 A 如果使用当前读是可以读到事务 B 插入的最新数据的。

### MySQL 中如何实现可重复读（涉及 MVCC 的通俗解释）

当隔离级别为可重复读的时候，事务只在第一次 SELECT 的时候会获取一次 Read View，而后面所有的 SELECT 都会复用这个 Read View。也就是说：对于A事务而言，不管其他事务怎么修改数据，对于A事务而言，它能看到的数据永远都是第一次SELECT时看到的数据。这显然不合理，如果其它事务插入了数据，A事务却只能看到过去的数据，读取不了当前的数据。

既然都说到 Read View 了，就不得不说 MVCC (多版本并发控制) 机制了。MVCC 其实字面意思还比较好理解，为了防止数据产生冲突，我们可以使用时间戳之类的来进行标识，不同的时间戳对应着不同的版本。比如你现在有1000元，你借给了张三 500 元， 之后李四给了你 500 元，虽然你的钱的总额都是 1000元，但是其实已经和最开始的 1000元不一样了，为了判断中途是否有修改，我们就可以采用版本号来区分你的钱的变动。

如下，在数据库的数据表中，id，name，type 这三个字段是我自己建立的，但是除了这些字段，其实还有些隐藏字段是 MySQL 偷偷为我们添加的，我们通常是看不到这样的隐藏字段的。


我们重点关注这两个隐藏的字段：

db_trx_id：操作这行数据的事务 ID，也就是最后一个对该数据进行插入或更新的事务 ID。我们每开启一个事务，都会从数据库中获得一个事务 ID（也就是事务版本号），这个事务 ID 是自增长的，通过 ID 大小，我们就可以判断事务的时间顺序。

db_roll_ptr：回滚指针，指向这个记录的 Undo Log 信息。什么是 Undo Log 呢？可以这么理解，当我们需要修改某条记录时，MySQL 担心以后可能会撤销该修改，回退到之前的状态，所以在修改之前，先把当前的数据存个档，然后再进行修改，Undo Log 就可以理解为是这个存档文件。这就像是我们打游戏一样，打到某个关卡先存个档，然后继续往下一关挑战，如果下一关挑战失败，就回到之前的存档点，不至于从头开始。

在 MVCC（多版本并发控制） 机制中，多个事务对同一个行记录进行更新会产生多个历史快照，这些历史快照保存在 Undo Log 里。如下图所示，当前行记录的 回滚指针 指向的是它的上一个状态，它的上一个状态的 回滚指针 又指向了上一个状态的上一个状态。这样，理论上我们通过遍历 回滚指针，就能找到该行数据的任意一个状态。

Undo Log 示意图

我们没有想到，我们看到的或许只是一条数据，但是MySQL却在背后为该条数据存储多个版本，为这条数据存了非常多的档。那问题来了，当我们开启事务时，我们在事务中想要查询某条数据，但是每一条数据，都对应了非常多的版本，这时，我们需要读取哪个版本的行记录呢？

这时就需要用到 Read View 机制了，它帮我们解决了行的可见性问题。Read View 保存了当前事务开启时所有活跃（还没有提交）的事务列表。

在 Read VIew 中有几个重要的属性：

- trx_ids，系统当前正在活跃的事务 ID 集合
- low_limit_id，活跃的事务中最大的事务 ID
- up_limit_id，活跃的事务中最小的事务 ID
- creator_trx_id，创建这个 Read View 的事务 ID

在前面我们说过了，在每一行记录中有一个隐藏字段 db_trx_id，表示操作这行数据的事务 ID ，而且 事务 ID 是自增长的，通过 ID 大小，我们就可以判断事务的时间顺序。

当我们开启事务以后，准备查询某条记录，发现该条记录的 db_trx_id < up_limit_id，这说明什么呢？说明该条记录一定是在本次事务开启之前就已经提交的，对于当前事务而言，这属于历史数据，可见，因此，我们通过 select 一定能查出这一条记录。

但是如果发现，要查询的这条记录的 db_trx_id > up_limit_id。这说明什么呢，说明我在开启事务的时候，这条记录肯定是还没有的，是在之后这条记录才被创建的，不应该被当前事务看见，这时候我们就可以通过 回滚指针 + Undo Log 去找一下该记录的历史版本，返回给当前事务。在本文 什么是幻读 ？ 这一章节中举的一个例子。A 事务开启时，数据库中还没有（30, 30, 30）这条记录。A事务开启以后，B事务往数据库中插入了（30, 30, 30）这条记录，这时候，A事务使用 不加锁 的 select 进行 快照读 时是查询不出这条新插入的记录的，这符合我们的预期。对于 A事务而言，（30, 30, 30）这条记录的 db_trx_id 一定大于 A事务开启时的 up_limit_id，所以这条记录不应该被A事务看见。

如果需要查询的这条记录的 trx_id 满足 up_limit_id < trx_id < low_limit_id 这个条件，说明该行记录所在的事务 trx_id 在目前 creator_trx_id 这个事务创建的时候，可能还处于活跃的状态，因此我们需要在 trx_ids 集合中进行遍历，如果 trx_id 存在于 trx_ids 集合中，证明这个事务 trx_id 还处于活跃状态，不可见，如果该记录有 Undo Log，我们可以通过回滚指针进行遍历，查询该记录的历史版本数据。如果 trx_id 不存在于 trx_ids 集合中，证明事务 trx_id 已经提交了，该行记录可见。

从图中你能看到回滚指针将数据行的所有快照记录都通过链表的结构串联了起来，每个快照的记录都保存了当时的 db_trx_id，也是那个时间点操作这个数据的事务 ID。这样如果我们想要找历史快照，就可以通过遍历回滚指针的方式进行查找。

最后，再来强调一遍：事务只在第一次 SELECT 的时候会获取一次 Read View

因此，如下图所示，在 可重复读 的隔离条件下，在该事务中不管进行多少次 以WHERE heigh > 2.08为条件 的查询，最终结果得到都是一样的，尽管可能会有其它事务对这个结果集进行了更改。

### 查询语句执行流程

查询语句的执行流程如下：权限校验、查询缓存、分析器、优化器、权限校验、执行器、引擎。

举个例子，查询语句如下：

```mysql
select * from user where id > 1 and name = '大彬';
```

1. 首先检查权限，没有权限则返回错误；
2. MySQL8.0 以前会查询缓存，缓存命中则直接返回，没有则执行下一步；
3. 词法分析和语法分析。提取表名、查询条件，检查语法是否有错误；
4. 两种执行方案，先查 `id > 1` 还是 `name = '大彬'`，优化器根据自己的优化算法选择执行效率最好的方案；
5. 校验权限，有权限就调用数据库引擎接口，返回引擎的执行结果。

### 更新语句执行过程

更新语句执行流程如下：分析器、权限校验、执行器、引擎、`redo log`（`prepare` 状态）、`bin log`、`redo log`（`commit` 状态）

举个例子，更新语句如下：

```mysql
update user set name = '大彬' where id = 1;
```

1. 先查询到 id 为 1 的记录，有缓存会使用缓存。
2. 拿到查询结果，将 name 更新为大彬，然后调用引擎接口，写入更新数据，innodb 引擎将数据保存在内存中，同时记录 `redo log`，此时 `redo log`进入 `prepare` 状态。
3. 执行器收到通知后记录 `bin log`，然后调用引擎接口，提交 `redo log` 为 `commit` 状态。
4. 更新完成。

为什么记录完 `redo log`，不直接提交，而是先进入 `prepare` 状态？

假设先写 `redo log` 直接提交，然后写 `bin log`，写完`redo log`后，机器挂了，`bin log` 日志没有被写入，那么机器重启后，这台机器会通过 `redo log` 恢复数据，但是这个时候 `bin log` 并没有记录该数据，后续进行机器备份的时候，就会丢失这一条数据，同时主从同步也会丢失这一条数据。

### exists 和 in 的区别

`exists` 用于对外表记录做筛选。`exists` 会**遍历外表**，将外查询表的每一行，代入内查询进行判断。

- 当 `exists` 里的条件语句能够返回记录行时，条件就为真，返回外表当前记录。
- 反之如果 `exists` 里的条件语句不能返回记录行，条件为假，则外表当前记录被丢弃。

```mysql
select a.* from A where exists (select 1 from B b where a.id=b.id)
```

`in` 是**先把后边的语句查出来**放到临时表中，然后**遍历临时表**，将临时表的每一行，代入外查询去查找。

```mysql
select * from A where id in (select id from B)
```

**子查询的表比较大的时候**，使用 `exists` 可以有效减少总的循环次数来提升速度；**当外查询的表比较大的时候**，使用 `in` 可以有效减少对外查询表循环遍历来提升速度。

总结：`exists` 遍历外表，`in` 遍历子表

### MySQL 中 int(10) 和 char(10) 的区别

int(10) 中的 10 表示的是显示数据的长度，而 char(10) 表示的是存储数据的长度

### truncate、delete 与 drop 区别？

**相同点：**

1. `truncate` 和不带 `where` 子句的 `delete`、以及 `drop` 都会删除表内的数据。
2. `drop`、`truncate` 都是 `DDL` 语句（数据定义语言），执行后会自动提交。

**不同点：**

1. truncate 和 delete 只删除数据不删除表的结构；drop 语句将删除表的结构被依赖的约束、触发器、索引；
2. 一般来说，执行速度: drop > truncate > delete。

### having 和 where 区别？

- 二者**作用的对象不同**，`where` 子句作用于表和视图，`having` 作用于组。
- `where` 在数据分组前进行过滤，`having` 在数据分组后进行过滤。

### 查询 `limit 1000,10` 和 `limit 10` 速度一样快吗？

两种查询方式。对应 `limit offset, size` 和 `limit size` 两种方式。

而其实 `limit size` ，相当于 `limit 0, size`。也就是从 0 开始取 size 条数据。

也就是说，两种方式的**区别在于 offset 是否为 0。**

先来看下 limit sql 的内部执行逻辑。

MySQL 内部分为 **server 层**和**存储引擎层**。一般情况下存储引擎都用 innodb。

server 层有很多模块，其中需要关注的是**执行器**是用于跟存储引擎打交道的组件。

执行器可以通过调用存储引擎提供的接口，将一行行数据取出，当这些数据完全符合要求（比如满足其他 where 条件），则会放到**结果集**中，最后返回给调用 mysql 的**客户端**。

以主键索引的 limit 执行过程为例：

- 执行 `select * from xxx order by id limit 0, 10;`，select 后面带的是**星号**，也就是要求获得行数据的**所有字段信息。**
  - server 层会调用 innodb 的接口，在 innodb 里的主键索引中获取到第 0 到 10 条**完整行数据**，依次返回给 server 层，并放到 server 层的结果集中，返回给客户端。
- 把 offset 搞大点，比如执行的是：`select * from xxx order by id limit 500000, 10;`
  - server 层会调用 innodb 的接口，由于这次的 offset=500000，会在 innodb 里的主键索引中获取到第 0 到（500000 + 10）条**完整行数据**，**返回给 server 层之后根据 offset 的值挨个抛弃，最后只留下最后面的 size 条**，也就是 10 条数据，放到 server 层的结果集中，返回给客户端。

可以看出，当 offset 非 0 时，server 层会从引擎层获取到**很多无用的数据**，而获取的这些无用数据都是要耗时的。

因此，mysql 查询中 `limit 1000,10` 会比 `limit 10` 更慢。原因是 **`limit 1000,10` 会取出 1000+10 条数据，并抛弃前 1000 条，这部分耗时更大。**

好笨

### 深分页怎么优化？

还是以上面的 SQL 为空：`select * from xxx order by id limit 500000, 10;`

**方法一**：

从上面的分析可以看出，当 offset 非常大时，server 层会从引擎层获取到很多无用的数据，而当 select 后面是 * 号时，就需要拷贝完整的行信息，**拷贝完整数据相比只拷贝行数据里的其中一两个列字段更耗费时间**。

因为前面的 offset 条数据最后都是不要的，没有必要拷贝完整字段，所以可以将 sql 语句修改成：

```sql
select * from xxx  where id >= (select id from xxx order by id limit 500000, 1) order by id limit 10;
```

先执行子查询 `select id from xxx by id limit 500000, 1`, 这个操作，其实也是将在 innodb 中的主键索引中获取到 `500000+1` 条数据，然后 server 层会抛弃前 500000 条，只保留最后一条数据的 id。

但不同的地方在于，在返回 server 层的过程中，只会拷贝数据行内的 id 这一列，而不会拷贝数据行的所有列，当数据量较大时，这部分的耗时还是比较明显的。

在拿到了上面的 id 之后，假设这个 id 正好等于 500000，那 sql 就变成了

```sql
select * from xxx  where id >=500000 order by id limit 10;
```

这样 innodb 再走一次**主键索引**，通过 B+ 树快速定位到 id=500000 的行数据，时间复杂度是 lg(n)，然后向后取 10 条数据。

**方法二：**

将所有的数据**根据 id 主键进行排序**，然后分批次取，将当前批次的最大 id 作为下次筛选的条件进行查询。

```sql
select * from xxx where id > start_id order by id limit 10;
```

通过主键索引，每次定位到 start_id 的位置，然后往后遍历 10 个数据，这样不管数据多大，查询性能都较为稳定。

### 高度为 3 的 B+ 树，可以存放多少数据

InnoDB 存储引擎有自己的最小储存单元——页（Page）。

查询 InnoDB 页大小的命令如下：

```mysql
mysql> show global status like 'innodb_page_size';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| Innodb_page_size | 16384 |
+------------------+-------+
```

可以看出 innodb 默认的一页大小为 16384B = 16384/1024 = 16kb。

在 MySQL 中，B+ 树一个节点的大小设为一页或页的倍数最为合适。因为如果一个节点的大小 < 1 页，那么读取这个节点的时候其实读取的还是一页，这样就造成了资源的浪费。

B+ 树中**非叶子节点存的是 key + 指针**；**叶子节点存的是数据行**。

对于叶子节点，如果一行数据大小为 1k，那么一页就能存 16 条数据。

对于非叶子节点，如果 key 使用的是 bigint，则为 8 字节，指针在 MySQL 中为 6 字节，一共是 14 字节，则 16k 能存放 16 * 1024 / 14 = 1170 个索引指针。

于是可以算出，对于一颗高度为 2 的 B+ 树，根节点存储索引指针节点，那么它有 1170 个叶子节点存储数据，每个叶子节点可以存储 16 条数据，一共 1170 x 16 = 18720 条数据。而对于高度为 3 的 B+ 树，就可以存放 1170 x 1170 x 16 = 21902400 条数据（**两千多万条数据**），也就是对于两千多万条的数据，我们只需要**高度为 3** 的 B+ 树就可以完成，通过主键查询只需要 3 次 IO 操作就能查到对应数据。

所以在 InnoDB 中 B+ 树高度一般为 3 层时，就能满足千万级的数据存储。

### 单表多大进行分库分表

目前主流的有两种说法：

1. MySQL 单表数据量大于 2000 万行，性能会明显下降，考虑进行分库分表。
2. 阿里巴巴《Java 开发手册》提出单表行数超过 500 万行或者单表容量超过 2GB，才推荐进行分库分表。

事实上，这个数值和实际记录的条数无关，而**与 MySQL 的配置以及机器的硬件有关**。因为 MySQL 为了提高性能，会将表的索引装载到内存中。在 InnoDB buffer size 足够的情况下，其能完成全加载进内存，查询不会有问题。但是，当单表数据库到达某个量级的上限时，导致内存无法存储其索引，使得之后的 SQL 查询会产生磁盘 IO，从而导致性能下降。当然，这个还有具体的表结构的设计有关，最终导致的问题都是内存限制。

因此，对于分库分表，需要结合实际需求，不宜过度设计，在项目一开始不采用分库与分表设计，而是随着业务的增长，在无法继续优化的情况下，再考虑分库与分表提高系统的性能。对此，阿里巴巴《Java 开发手册》补充到：如果预计三年后的数据量根本达不到这个级别，请不要在创建表时就分库分表。

至于 MySQL 单表多大进行分库分表，应当根据机器资源进行评估。

### 大表查询慢怎么优化

某个表有近千万数据，查询比较慢，如何优化？

当 MySQL 单表记录数过大时，数据库的性能会明显下降，一些常见的优化措施如下：

- **建立索引**。在合适的字段上建立索引，例如在 WHERE 和 ORDER BY 命令上涉及的列建立索引，可根据 EXPLAIN 来查看是否用了索引还是全表扫描
- **建立分区**。对关键字段建立水平分区，比如时间字段，若查询条件往往通过时间范围来进行查询，能提升不少性能
- **利用缓存**。利用 Redis 等缓存热点数据，提高查询效率
- **限定数据的范围**。比如：用户在查询历史信息的时候，可以控制在一个月的时间范围内
- **读写分离**。经典的数据库拆分方案，主库负责写，从库负责读
- **分库分表**，主要有垂直拆分和水平拆分

### 什么是临时表

MySQL 在执行 SQL 语句的时候会临时创建一些存储中间结果集的表，这种表被称为临时表，临时表只对当前连接可见，在连接关闭后，临时表会被删除并释放空间。

临时表主要分为内存临时表和磁盘临时表两种

- 内存临时表使用的是 MEMORY 存储引擎
- 磁盘临时表使用的是 MyISAM 存储引擎。

一般在以下几种情况中会使用到临时表：

- FROM 中的子查询
- DISTINCT 查询并加上 ORDER BY
- ORDER BY 和 GROUP BY 的子句不一样时会产生临时表
- 使用 UNION 查询会产生临时表

### 主键一般用自增 ID 还是 UUID

使用自增 ID 的好处：

- 字段长度较 uuid 会小很多。

- 数据库自动编号，按顺序存放，利于检索

- 无需担心主键重复问题

使用自增 ID 的缺点：

- 因为是自增，在某些业务场景下，容易被其他人查到业务量。

- 发生数据迁移时，或者表合并时会非常麻烦

- 在高并发的场景下，竞争自增锁会降低数据库的吞吐能力

UUID：通用唯一标识码，UUID 是基于当前时间、计数器和硬件标识等数据计算生成的。

使用 UUID 的优点：

- 唯一标识，不会考虑重复问题，在数据拆分、合并时也能达到全局的唯一性。

- **可以在应用层生成**，提高数据库的吞吐能力。

- 无需担心业务量泄露的问题。

使用 UUID 的缺点：

- 因为 UUID 是随机生成的，所以会发生**随机 IO**，影响插入速度，并且会造成硬盘的使用率较低。

- UUID 占用空间较大，建立的索引越多，造成的影响越大。

- UUID 之间比较大小较自增 ID 慢不少，影响查询速度。

最后说下结论，一般情况 MySQL 推荐使用自增 ID。因为在 MySQL 的 InnoDB 存储引擎中，主键索引是一种聚簇索引，主键索引的 B+ 树的叶子节点按照顺序存储了主键值及数据

- 如果主键索引是自增 ID，只需要按顺序往后排列即可，

- 如果是 UUID，ID 是随机生成的，**在数据插入时会造成大量的数据移动**，产生大量的内存碎片，造成插入性能的下降。

### 字段为什么要设置成 not null

首先说一点，NULL 和空值是不一样的，空值是不占用空间的，而 **NULL 是占用空间的**，所以字段设为 NOT NULL 后仍然可以插入空值。

字段设置成 not null 主要有以下几点原因：

NULL 值会影响一些函数的统计，如 count，遇到 NULL 值，这条记录不会统计在内。

B 树不存储 NULL，所以索引用不到 NULL，会造成第一点中说的统计不到的问题。

**NOT IN 子查询在有 NULL 值的情况下返回的结果都是空值**。

例如 user 表如下

| id   | username |
| ---- | -------- |
| 0    | zhangsan |
| 1    | lisi     |
| 2    | null     |

```sql
select * from `user` where username NOT IN (select username from `user` where id != 0)
```

这条查询语句应该查到 zhangsan 这条数据，但是结果显示为 null

MySQL 在进行比较的时候，NULL 会参与字段的比较，因为 NULL 是一种比较特殊的数据类型，数据库在处理时需要进行特殊处理，增加了数据库处理记录的复杂性。

### 如何优化 WHERE 子句

- 不要在 where 子句中使用 != 和 <> 进行**不等于判断**，这样会导致**放弃索引进行全表扫描**。

- 不要在 where 子句中使用 null 或空值判断，尽量设置字段为 not null

- 尽量使用 union all 代替 or

- 在 where 和 order by 涉及的列建立索引

- 尽量减少使用 in 或者 not in，会进行全表扫描

- 在 where 子句中使用参数会导致全表扫描

- 避免在 where 子句中对字段及进行表达式或者函数操作会导致存储引擎放弃索引进而全表扫描

### SQL 语句的执行顺序

```sql
SELECT DISTINCT 
	select_list 
FROM 
	left_table 
LEFT JOIN 
	right_table ON join_condition 
WHERE 
	where_condition 
GROUP BY 
	group_by_list 
HAVING 
	having_condition 
ORDER BY 
	order_by_condition
```

![图片](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/11d8f5cf351d7387c01a2759b65f5609.png)	

- FROM：对 SQL 语句执行查询时，首先对关键字两边的表以笛卡尔积的形式执行连接，并产生一个虚表 V1。虚表就是视图，数据会来自多张表的执行结果。

- ON：对 FROM 连接的结果进行 ON 过滤,并创建虚表 V2

- JOIN：将 ON 过滤后的左表添加进来，并创建新的虚拟表 V3

- WHERE：对虚拟表 V3 进行 WHERE 筛选，创建虚拟表 V4

- GROUP BY：对 V4 中的记录进行分组操作，创建虚拟表 V5

- HAVING：对 V5 进行过滤，创建虚拟表 V6

- SELECT：将 V6 中的结果按照 SELECT 进行筛选，创建虚拟表 V7

- DISTINCT：对 V7 表中的结果进行去重操作，创建虚拟表 V8
  - 如果使用了 GROUP BY 子句则无需使用 DISTINCT，因为分组的时候是将列中唯一的值分成一组，并且每组只返回一行记录，所以所有的记录都是不同的。

- ORDER BY：对 V8 表中的结果进行排序。

### 分库分表后，ID 键如何处理

分库分表后不能每个表的 ID 都是从 1 开始，所以需要一个全局 ID

设置全局 ID 主要有以下几种方法：

- UUID
  - 优点：本地生成 ID，不需要远程调用；全局唯一不重复
  - 缺点：占用空间大；不适合作为索引。

- 数据库自增 ID：在分库分表表后使用数据库自增 ID，需要一个**专门用于生成主键的库**，每次服务接收到请求，先向这个库中插入一条没有意义的数据，获取一个数据库自增的 ID，利用这个 ID 去分库分表中写数据。
  - 优点：简单易实现。
  - 缺点：在高并发下存在瓶颈。）

![图片](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/3ce2984ba84782dd28e80c70bb008871.png)

- Redis 生成 ID
  - 优点：不依赖数据库，性能比较好。
  - 缺点：引入新的组件会使得系统复杂度增加

- Twitter 的 snowflake 算法：是一个 64 位的 long 型的 ID，其中有 1bit 是不用的，41bit 作为毫秒数，10bit 作为工作机器 ID，12bit 作为序列号。

  - 1bit：第一个 bit 默认为 0，因为二进制中第一个 bit 为 1 的话为负数，但是 ID 不能为负数.
  - 41bit：表示的是时间戳，单位是毫秒。

  - 10bit：记录工作机器 ID，其中 5 个 bit 表示机房 ID，5 个 bit 表示机器 ID。
  - 12bit：用来记录同一毫秒内产生的不同 ID。

- 美团的 Leaf 分布式 ID 生成系统，美团点评分布式 ID 生成系统
