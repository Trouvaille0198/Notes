# 数据库原理一

## 结构化查询语言

（第四章）

### SQL 概述

**SQL**：结构化查询语言，一种介于关系代数和关系演算之间的语言。

**关键码**：

- **超键**：能唯一标识元组的属性组合（可能多余）
- **候选键**：能唯一标识元组的最小属性组合
- **主键**：候选键中的一个
- **外键**：若关系 R 包含关系 S 的主键对应的属性组 F，则 F 为 R 的外键。S 为参照关系，R 为依赖关系

**SQL 体系结构**（三级体系结构对应关系）：

- **内模式**：对应**存储文件**
- **模式**：对应**基本表**（元组称为行、属性称为列）
- **外模式**：对应**视图**

**SQL 体系结构的特征**

- SQL模式是表和约束的集合
- 表是行的集合
- 表可以是基本表，也可以是视图。视图只存放定义不存放数据
- 表可以存放在多个存储文件中，存储文件可以存放多个表
- 用户使用SQL语句对视图和表进行操作。表和视图对用户而言都是关系
- 用户可以是程序也可以是终端

**SQL的组成**：

- **数据定义**：定义 SQL模式、基本表、视图和索引
- **数据操纵**：数据查询、数据更新（插入删除修改）
- **数据控制** -> 第八章：对基本表和视图的授权、完整性规则描述、事务控制语句
- **嵌入式 SQL**：嵌入 SQL 的规则

### SQL 数据定义

**SQL 模式的创建和撤销**

- 创建

    ```mysql
    CREATE SCHEMA <模式名> AUTHORIZATION <拥有者>;
    ```

- 撤销

    ```mysql
    DROP SCHEMA <模式名> [CASECADE|RESTRICT];
    ```

    - `CASECADE`（级联）连锁式
    - `RESTRICT` 约束式：只有当模式中没有任何下属元素时允许撤销

**基本数据类型**：

- 数值型：`INTEGER`、`DOUBLE PRECISION` 双精度、`DECEMIAL(p,d)` p.d 位定点小数
- 字符串型：`CHAR(n)` 定长、`VACHAR(n)` 最大长度n
- 位串型：`BIT(n)` 定长、`BIT VARYING(n)` 最大长度n
- 时间型：`DATE(YYYY-MM-DD)`、`TIME(HH:MM:SS)`

**基本表创建 **☆

列级约束 + 表级约束

**三个子句**：主键子句、外键子句、检查子句

```sql
CREATE TABLE S (
    SNO CHAR(4) NOT NULL,
    PRIMARY KEY (SNO,PNO),             -- 主键子句
    FOREIGN KEY(JNO) REFERENCES J(JNO) -- 外键子句
    CHECK (QTY BETWEEN 0 AND 10000)    -- 检查子句
);
```

**基本表修改**：（增删属性）

增加属性：`ALTER TABLE S ADD NAME VACHAR(12)`;

删除属性：`ALTER TABLE S DROP NAME [CASCADE(连锁)|RESTRICT(约束)]`;

**基本表删除**：`DROP TABLE S [CASCADE(连锁)|RESTRICT(约束)];`

**视图创建**：

```sql
CREATE VIEW JSP_NAME(JNO,JNAME) AS
    SELECT (J.JNO,J.JNAME)
    FROM S,J
    WHERE …
```

**视图撤销**：`DROP VIEW JSP_NAME`

索引创建：

```sql
CREATE UNIQUE INDEX SPJ_INDEX ON SPJ(SNO ASC, PNO, ASC, JON DESC);
```

索引撤销：

```sql
DROP INDEX JNO_INDEX, SPJ_INDEX;
```

### SQL 数据查询 ☆

#### SQL 查询语句

select 投影、from 笛卡尔积、where 选择（条件）

```sql
SELECT [DISTINCT] 列名序列
FROM 表名
[WHERE 行条件表达式]                       -- 行条件子句
[GROUP BY 列名序列 [HAVING 组条件表达式]]    -- 分组子句
[ORDER BY 列名[ASC|DESC]序列]              -- 排序子句
```

#### 多表查询与联接操作

`INNER JOIN`：内联接 -> 匹配行

`LEFT JOIN`：左外联接 -> 匹配行+左表；保证左边所有行都存在

`RIGHT JOIN`：右外联接 -> 匹配行+右表

`FULL JOIN`：完全外联接 -> 匹配行+左表+右表；左右不匹配的行也保留

`CROSS JOIN`：交叉联接 -> 笛卡尔积

以下五者等价：查询选修 2 号课程的学生姓名

##### **联接查询**

from 表1 联接类型 表2 on 联接条件

```sql
SELECT SNAME
FROM SC INNER JOIN S ON S.SNO=SC.SNO   -- 注意 ON
WHERE CNO=’2’;
```

##### **多表查询**

```sql
SELECT SNAME 
FROM S,SC 
WHERE S.SNO=SC.SNO AND CNO=’2’;
```

##### **嵌套操作**

- **不相关子查询**：子查询条件不依赖父查询，效率最高

    ```sql
    SELECT SNAME FROM S WHERE SNO IN (
        SELECT SNO FROM SC WHERE CNO=’2’
    );
    ```

- **相关子查询**：子查询条件依赖父查询

    ```sql
    SELECT SNAME FROM S WHERE ‘2’ IN (
        SELECT CNO FROM SC WHERE SNO=S.SNO
    );
    ```

- **EXISTS**：也是相关子查询

    ```sql
    SELECT SNAME FROM S WHERE EXISTS (
        SELECT * FROM SC WHERE SNO=S.SNO AND CNO=’2’
    );
    ```

#### ANY、ALL 谓词

ANY、ALL **用于单属性表前**以聚合，MAX、MIN 用于 SELECT 后以聚合。

*查询非信息系中比信息系至少某一个学生年龄小的学生姓名年龄*：

```sql
SELECT Sname, Sage
FROM S
WHERE Sdept!=’IS’ AND Sage < ANY (
    SELECT Sage FROM S WHERE Sdept=’IS’
);

SELECT Sname, Sage
FROM S
WHERE Sdept!=’IS’ AND Sage<(
    SELECT MAX(Sage)
    FROM S
    WHERE Sdept=’IS’
);
```

#### EXISTS 存在谓词

**存在表任意关系**：$\forall x \left( p \right) \equiv \neg \exists x \left( \neg p \right)$

*查询选修全部课程的学生姓名*：（也就是不存在一门课它没选）

```sql
SELECT Sname
FROM S
WHERE NOT EXISTS(
    SELECT Cno
    FROM C
    WHERE NOT EXISTS(
        SELECT Sno
        FROM SC
        WHERE Cno=C.Cno AND Sno=S.Sno
    )
);

SELECT Sname
FROM S
WHERE NOT EXISTS( /*查询S没选的课*/
    SELECT Cno 
    FROM C INNER JOIN SC
    ON C.Cno=SC.Cno
    WHERE NOT EXISTS Sno=S.sno
);
```

**存在表蕴含关系**： $ \forall y \left( p \rightarrow q \right) \equiv \neg \exists y \left( \neg \left( \neg p \vee q \right) \right) \equiv \neg \exists y \left( p \wedge \neg q \right) $

*查询选过学生 A（学号95002）选过的全部课程的学生B学号*：（不存在 A 选的课它没选）

```sql
SELECT DISTINCT Sno
FROM SC AS X
WHERE NOT EXISTS( /*不存在这样一个课程号*/
    SELECT Cno
    FROM SC AS Y
    WHERE Y.Sno=’95002’ /*95002选了*/
    AND NOT EXISTS( /*B没选*/
        SELECT *
        FROM SC AS Z
        WHERE Z.Cno=Y.Cno AND Z.Sno=X.Sno
    )
);
```

#### 聚合函数

**逻辑：先用 where 筛选，再 having，最后运行聚合函数**

- `COUNT(*)` 元组个数
- `COUNT(列名)` 列中非空值个数
- `COUNT(DISTINCT 列名)` 列中元素种数
- `SUM(列)`、`AVG(列)`
- `MAX(列)`、`MIN(列)`
- `DISTINCT`

*查询每门课的选课人数*：

Group By 属性必须在 SELECT 后出现；

在 SELECT 中指定的字段要么就要**包含在 Group By 语句中**，作为分组的依据；要么就要被**包含在聚合函数**中

```sql
SELECT Cno, COUNT(Sno)
FROM SC
GROUP BY Cno;
```

*数据分组、集合操作*

### SQL 数据更新 ☆

#### 数据插入

- 插入单个元组：

    ```sql
    INSERT INTO table_name
    VALUES(‘…’,’…’)
    ```

- 插入子查询结果：

    ```sql
    INSERT INTO table_name 
    SELECT… FROM… WHERE…
    ```

#### 数据删除

```sql
DELETE FROM table_name
WHERE…
```

#### 数据修改

```sql
UPDATE table_name
SET 列名=值表达式[, 列名=值表达式…]
WHERE…
```

例：把课程名为”数据库原理”的成绩提高10%.

```sql
 UPDATE  SC 
  SET GRADE=1.1*GRADE
  WHERE CNO IN (SELECT CNO FROM C
                WHERE CNAME='数据库原理');
```

### 视图操作

**视图**：虚表，只存定义，不存数据。

在 SQL 中，外模式一级数据结构的基本单位是视图（View）

视图是从若干基本表和（或）其他视图构造出来的表。

在创建一个视图时，系统把视图的定义存放在数据字典中，而不存储视图对应的数据，在用户使用视图时才去求对应的数据。

视图被称为“虚表”

#### 创建

```sql
CREATE VIEW <视图名>(列名表)
AS  <SELECT  查询语句>
```

在基本表 SC 上，建立一个学生学习情况视图，内容包括：学号、选修课程门数、平均成绩。

```sql
CREATE VIEW  S_GRADE(SNO,C_NUM,AVG_GRADE)
	AS (SELECT SNO,COUNT(CNO),AVG(GRADE)
	    FROM SC
	    GROUP BY SNO);
```

#### 撤销

```sql
DROP VIEW <视图名>
```

#### 查询

系统会根据数据字典的定义将视图查询**转换为对基本表的查询**

HAVING：组条件

WHERE：行条件

```sql
CREATE VIEW S_GRADE(sno, c_num, avg_grade) AS (
    SELECT sno, COUNT(cno),AVG(grade)
    FROM SC
    GROUP BY sno
);

SELECT sno, avg_grade
FROM S_GRADE
WHERE c_num >(
    SELECT c_num
    FROM S_GRADE
    WHERE sno=’S4’
);
```

会转变成：

```sql
SELECT sno, AVG(grade) AS avg_grade
FROM SC
GROUP BY sno
HAVING COUNT(cno)>(
    SELECT COUNT(cno)
    FROM SC
    WHERE sno=’S4’
    GROUP BY sno
);
```

#### 更新

只有**行列子集视图**可以进行更新

**行列子集视图**：当视图是从单个基本表**仅**使用**选择**和**投影**导出，并包含了基本表的主键或某个**候选键**，则可以进行更新操作。

拒绝更新的视图：

- 视图从多个基本表**联结**导出
- 视图有**分组**或**聚合**操作

```sql
/* 以下更新会被拒绝：
** 因为视图包含分组聚合操作COUNT(cno), AVG(grade)
**/
UPDATE S_GRADE
SET sno=’S3’
WHERE sno=’S4’
```

### 嵌入式 SQL

为区分 SQL 语句与宿主语言语句，在所有的 SQL 语句前必须加上前缀标识 `EXEC  SQL`，并以 `END EXEC` 作为语句结束标志

通过**共享变量**进行数据交互

通过**游标**统一 SQL 中一次一集合的和程序中一次一记录工作方式	

只有查询结果是多条记录、或需要对当前记录进行操作时才需要使用游标

使用嵌入式的目标：统一 SQL 中一次一集合的和程序中一次一记录工作方式

## 数据库发展史

（第一章）

### 数据管理技术发展三个阶段

- **人工管理阶段**：磁带、卡片、纸带
    - 数据**不保存在计算机**内
    - 没有专用软件管理数据（逻辑结构 = 物理结构，数据和程序不具有独立性）
    - 只有程序的概念，没有文件的概念
    - 数据**面向程序**
- **文件系统阶段**：
    - 数据以文件形式保存
    - 操作系统接管读写细节
    - 优点：
        - 数据以文件形式存在**磁盘**上
        - 逻辑结构和物理结构有简单区别，程序和数据间有设备独立性（程序只和文件打交道）
        - 文件组织多样化（索引、链接、直接存取文件）
        - 数据**面向应用**（且可复用）
        - 对数据操作**以记录为单位**
    - 文件系统三个缺点：
        - **数据冗余**：同样数据在多个文件中重复
        - **不一致性**：更新操作导致重复数据不统一
        - **数据联系弱**：文件相互独立，缺乏联系
- **倒排文件系统阶段**：
    - 推广索引文件，为每个字段提供单独索引
    - 优点：允许用户按字段的任何组合检索记录
    - 缺点：占用很多存储空间，数据更新复杂
- **数据库系统阶段**：
    - 数据库系统的**三个阶段：**层次、网状、关系 -> 1.2

### 数据库技术的产生和发展

#### 数据库技术的**三个阶段**

（三件大事）（又见 -> 2.2）

- IMS 系统：

    **层次模型**

    - **树形结构**
    - 表示**一对多**关系
    - **表达多对多**关系需要**冗余节点**
    - 通过**指针导航**
    - 查询速度快，但需要程序员掌握数据结构

- DBTG 报告：

    **网状模型**

    - **图形**结构
    - 表示**多对多**关系
    - 通过**指针导航**
    - 查询速度快，但需要程序员掌握数据结构

- E.F.Codd 文章：

    - **关系模型** -> 第三章

#### **数据库阶段的特点**

三级结构两级映像

- 面向全组织的复杂的数据结构，实现了数据的结构化（采用**数据模型**表示复杂的数据结构：存储数据和数据间的关系）
- 有较高的**数据独立性**：用户只操作逻辑结构，物理结构对用户透明
- 提供方便的**用户接口**：终端/程序方式
- 提供**数据控制**功能：并发控制、恢复、完整性、安全性
- 增加**系统灵活性**：可以以数据项而非记录为单位

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/G4XpctYNEWRfDyQ.png)

#### **数据库术语**

- **数据库 DB**：长期存储在计算机内，有组织的、统一管理的相关数据的组合。
    - 用户共享、冗余度小、数据联系紧密、独立性强
- **数据库管理系统 DBMS**：介于 OS 和用户之间，为用户提供数据管理的软件。
    - 层次型、网状型、关系型、面向对象型
- **数据库技术**：研究数据库结构、存储、设计、管理、使用的一门学科
- **数据库系统 DBS**：采用数据库技术的计算机系统

#### 数据库技术的发展

- 分布式数据库技术

- 面向对象数据库技术

*集中式 DB、C/S 架构、B/S 架构*

## 数据库系统结构

（第二章）

### 数据描述

#### **信息的三个领域**

- **现实世界（需求分析）**
- **信息世界（用概念设计描述数据库的概念结构）**
- **机器世界（在计算机中展示出来）**

#### **概念设计中的数据描述**：代表 **E-R 模型**

- 实体：客观存在，一个具体或抽象的对象
- 实体集：性质相同实体的集合
- 属性：实体的一个特性
- 实体标识符：唯一标识实体的属性或属性集

#### **逻辑设计中的数据描述**：代表关系模型等

- 字段（数据项）：标记实体属性的命名单位 -> 属性
- 记录：字段的有序集合 -> 实体
- 文件：同一类记录的集合 -> 实体集
- 关键码：唯一确定文件中每个记录的字段或字段集 -> 实体标识符

#### **数据联系的描述**：

- 联系：实体间的相互关系。
- 联系的元数：一元、二元、多元
- 二元联系：两个不同实体集实体之间的联系
    - 一对一联系（1:1）、一对多联系（1:n）、多对多联系（m:n）

### 数据模型

定义：表示**实体类型**和**实体间联系**的模型

分类

- **概念模型**（实体联系模型）
- **逻辑模型**（结构数据模型）

#### 概念数据模型——实体联系模型（ER 模型）

**独立于计算机系统**的模型，用于建立信息世界的数据模型，**语义表达能力丰富**

- **矩形**表示**实体**类型
- **菱形**表示实体间**联系**
- **椭圆形**表示实体或联系的**属性**
- 优点：
    - 简单、容易理解，真实反映用户需求
    - 与计算机无关，用户容易接受
- 缺点：只能说明实体间的语义联系，不能说明数据结构

#### **逻辑数据模型**——面向数据库逻辑结构的模型

包含

- 数据结构：对实体类型和实体间联系的表达和实现
- 数据操作：对数据库的检索和更新（包括插入、删除、 
            修改）两类操作的实现
- 完整性约束：数据及其联系应具有的制约和依赖  
            规则

##### **层次模型**

- 用树型结构表示实体类型及实体之间联系的模型
- 使用有根树型结构、记录间联系通过指针、只能表示 1:n 联系

- **优点**
    - 记录之间通过指针实现，查询效率高
    - 逻辑和数据转换由 DBMS 完成

- **缺点**

    - 只能表示 1:n 联系，M:N 联系表示复杂
        - 层次顺序的严格和复杂引起查询更新很复杂，程序编写困难

    <img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211130201305384.png" alt="image-20211130201305384" style="zoom: 33%;" />

##### **网状模型**

- 用有向图结构表示实体类型及实体间联系的模型

- 使用有向图结构、记录间联系通过指针、能表示 m:n 联系

- **优点**

    - 容易实现M：N联系，查询效率高。

- **缺点**

    - 程序员必须熟悉数据库的逻辑结构才能编写相应的应用程序

    <img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211130201536914.png" alt="image-20211130201536914" style="zoom:33%;" />

##### **关系模型**

- 用二维表格结构来表示实体集，用外键表示实体间联系的模型
    - 关系模型是由若干个关系模式组成的集合，关系模式相当于记录类型，它的每一个实例称为关系。每个关系实际上就是一张二维表格。
    - 关系模型和层次、网络模型的最大差别是用关键码而不是用指针导航数据，表格简单，用户易懂，编写程序是并不涉及存储结构、访问技术等问题。
- 特征 -> 3.1：**每列不可分**、**没有两行完全相同**、**没有行序**、**没有列序**
- 关系模式三要素：数据结构、数据操纵、完整性约束
    - 完整性约束 -> 3.1：**实体完整性**、**参照完整性**、**用户自定义完整性**

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211130202008707.png" alt="image-20211130202008707" style="zoom:40%;" />

##### 面向对象模型

- 完整地描述现实世界的数据结构，具有丰富的表达力，但需要的知识较多
- 解决现实中更复杂的联系（嵌套、递归）

### 数据库的体系结构

（三级结构两级映像）

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211130203738425.png" alt="image-20211130203738425" style="zoom: 33%;" />

#### **三级模式结构**

##### **外模式**

（可以有很多）用户与数据库系统的接口，外模式可以有很多

##### **（概念）模式**

（只有一个）数据库中**全部数据的整体逻辑结构描述**，模式只有一个

##### **内模式**

数据库在物理存储方面的描述，最贴近物理结构

- 记录的存储方式
- 索引的组织方式
- 文件的组织方式

#### 两级映像

**两级映像：确保数据独立性**

- 外模式/模式映像：体现**逻辑**数据独立性（数据的逻辑独立性）
- 模式/内模式映像：体现**物理**数据独立性（数据的物理独立性）

#### 两级数据的独立性

- 物理数据独立性：修改内模式不影响模式
- 逻辑数据独立性：修改模式不影响外模式

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211130203620873.png" alt="image-20211130203620873" style="zoom:33%;" />

*DML*：*数据操纵语言（用户使用）*

*DDL*：*外模式、模式、内模式中数据定义语言*

### 数据库管理系统 DBMS

DMBS 是 DBS 的核心，一切对 DB 的操作都通过 DBMS 进行

事物是 DBMS 的基本工作单位，是由用户定义的一个操作序列，这些操作要么全做要么全不做，是不可分割的

**工作模式**：接受用户请求，转换，对数据库操作，接受结果，转换，返回用户

**主要功能**：数据库的定义、操纵、保护、维护，管理数据字典（DD）

**模块组成**：

- **查询处理器**：DML 编译器、DDL 编译器、嵌入式 DML 预编译器、查询运行核心程序
- **存储处理器**：权限和完整性管理器、事务管理器、文件管理器、缓冲区管理器

**数据库系统 DBS：**

**组成：**数据库、硬件、软件、数据库管理员 DBA

分类：集中式 DBS、客户服务器式 DBS、分布式 DBS

## 关系运算

第三章

### 关系模型

关系(数据)模型

**定义**：用二维表格表示实体集，用关键码（外键）表示实体间联系的数据模型

**形式定义**：关系是域的笛卡尔积的子集，元组的集合

- **属性**：表格中的列
- **域**：值的集合，即属性的取值范围
- **元组**：表格中的行，域的笛卡尔积的元素
- **关系**：二维表格，**域的笛卡尔积的子集**，（集合论）**元组的集合**，表示一个实体集

**关系模型特征：**

- 可以看做二维表格
- 表中的一行成为一个元组
- 列为属性
- 列的取值范围为域
- 任意两行不相同

**关系模式性质**：

- 本质是一个二维表格
- 属性值是原子的，不可分解
- 没有重复的元组
- 没有行序
- 理论上没有列序（为方便设置列序）

**关键码**：**超键**、**候选键**、**主键**、**外键** -> 4.1

主键使用下划线、外键使用下划波浪线

**关系模式的三级体系结构**：

- 关系子模式 -> 外模式：从若干关系中抽出满足一定条件的数据
- 关系模式 -> 概念模式：定义模式名、属性名、值域名、模式的主键
- 存储模式 -> 内模式：描述了关系如何在物理设备上存储

**完整性规则**：

- **实体完整性**：主键非空
- **参照完整性**：外键为空或为对应关系的某个主键值
- **用户定义完整性**：由应用环境决定数据需要符合的约束条件

关系模型的**形式定义**：（关系模型三个组成）

关系模型由**数据结构、数据操作、完整性规则**组成

### 关系代数 ☆

数据操纵语言 DML：查询语句、更新语句

**关系查询语言**：**非过程性**语言

- **关系代数**语言：查询操作以**集合操作**为基础
- **关系演算**语言：查询操作以**谓词演算**（一阶逻辑）为基础，非过程性更强一些

#### 关系代数的基本运算

要求参与运算的两个集合是同种性质

并 $ \bigcup $ 、差 — 、笛卡尔积 $ \times $、投影$ \pi $ 、选择 $ \sigma $

- **并**：$ R\bigcup S = \left\{ t|t \in R \vee t \in S \right \} $ 列要一样 `or`
- **差**： $ R-S=\left \{ t|t \in R \wedge t \notin S \right \} $ 列要一样 `not exists`
- **笛卡尔积**：$ R \times S = \left \{ t|t=\left\langle t^r, t^s \right\rangle \wedge t^r \in R \wedge t^s\in S \right \} $ `from A, B`
- **投影**：$ {\pi_{i_1,\cdots ,i_m}}\left( R \right)=\left\{ t|t=\left\langle t_{i_1},\cdots ,t_{i_m} \right\rangle \wedge \left\langle t_1,\cdots ,t_k \right\rangle \in R \right\} $ ，自动去重 `select distinct`
- **选择**： $ \sigma_f\left( R \right)=\left\{ t|t\in R\wedge f\left( t \right)=\text{true} \right\} $ ，如 $\sigma _{\text{age=18}}\left( S \right)$ `where`

#### 关系代数的组合运算

交 $\bigcap$ 、联接 $\triangleright \triangleleft $ 、自然联接 $\triangleright \triangleleft $ 、除 $\div$

- **交**： $R\bigcap S=R-\left( R-S \right)=S-\left( S-R \right)$ `and`
- **联接**：$R\underset{i\ \theta \ j}{\mathop \triangleright \triangleleft }\,S={\sigma }_{i\ \theta \ \left( r+j \right)}\left( R\times S \right)$ 其中 i，j 为下标，i，j 列都保留（笛卡尔积后选择）
- **自然联接**：$R\triangleright \triangleleft S=\pi \left( \sigma \left( R\times S \right) \right)$ 先笛卡尔积，再选择，再投影掉重复的列 `inner join`
- **除**：$R\div S=\pi \left( R \right)-\pi \left( \pi \left( R \right)\times S-R \right)$ R中满足S中所有条件的元组的剩余信息 `not exists(not exists)`

**扩充的关系代数操作**：

- **外联接**：（左、右、全）（级联左右带双横线=）哪边有=哪边有表对面有空
- **外部并**：把两表并起来，并填上null（普通并要求属性一致）
- *半联接*：⋉自然联接的投影左表属性 S⋉SC为选了课的学生

## 3.3 关系演算

**关系代数和关系演算的区别**：

**关系代数**以**集合操作**为基础，**关系演算**以**谓词演算**为基础（谓词即离散数学中的一阶逻辑）

**关系演算分类**：

- **元组**关系演算：$\left\{ t|P\left( t \right) \right\}$ ，$t$ 代表一个元组（一行）
- **域**关系演算： $\left\{ t_1\cdots t_k|P\left( t_1\cdots t_k \right) \right\}$ ，$t_1\cdots t_k$ 代表一个元组

**关系运算的安全性**：

关系代数操作结果不应包括**无限关系**和**无穷验证**

**关系运算的等价性**：

**关系代数** = **安全的元组关系演算** = **安全的域关系演算**

## 3.4 查询优化

**等价变换规则**：书P58

- 投影串联： $\pi _{L_1}\left( \pi _{L_2}\left( E \right) \right)=\pi _{L_1}\left( E \right)$
- 选择串联：$\sigma _{F_1}\left( \sigma _{F_2}\left( E \right) \right)=\sigma _{F_1\wedge F_2}\left( E \right)$
- 选择投影交换：$\pi _{L}\left( \sigma _{F}\left( E \right) \right)=\sigma _{F}\left( \pi _{L}\left( E \right) \right)$ 前提是后者依然可执行
- 选择对笛卡尔积分配： $\sigma _F\left( E_1\times E_2 \right)=\sigma _{F_1}\left( E_1\times \sigma _{F_2}\left( E_2 \right) \right)$
- 选择对并分配： $\sigma _F\left( E_1\bigcup E_2 \right)=\sigma _F\left( E_1 \right)\bigcup \sigma _F\left( E_2 \right)$
- 选择对差分配： $\sigma _F\left( E_1-E_2 \right)=\sigma _F\left( E_1 \right)-\sigma _F\left( E_2 \right)=\sigma _F\left( E_1 \right)-E_2$
- 投影对笛卡尔积分配： $\pi _L\left( E_1\times E_2 \right)=\pi _{L_1}\left( E_1 \right)\times \pi _{L_2}\left( E_2 \right)$
- 投影对并分配： $\pi _L\left( E_1\bigcup E_2 \right)=\pi _L\left( E_1 \right)\bigcup \pi _L\left( E_2 \right)$

**优化的一般策略**：

- 尽早执行选择操作
- 笛卡尔积和其后的选择、投影合并运算
- 同时计算选择和投影
- 预处理多次出现的子表达式
- 预处理建立合理的索引方式
- 优化表达式的计算方法，如 选择哪个作为外层循环

**优化算法**☆：由DBMS中的DML编译器完成

- 将自然联接转为笛卡尔积 + 选择 + 投影
- 逆用选择串联，将选择拆开
- 将每个选择和投影尽可能移向树叶
- 将相邻的投影和选择转化为(0/1个)选择 + (0/1个)投影
- 按二元运算分组，每组只有一个二元运算

# 第六章 实体联系模型

## 6.1 ER模型的基本元素

**基本元素**：实体、联系、属性

- **实体**：一个数据对象 -> 方框
- **联系**：表示实体间的关系 -> 菱形框，用线段和实体相连
- **属性**：表示实体的特性 -> 椭圆形框，实体标识符加下划线，用线段和实体相连

## 6.2 属性的分类

- 基本属性

    和

    复合属性

    ：地址包含邮政编码、街道

    - 属性连向属性（双圆圈），产生属性的层次结构

- 单值属性

    和

    多值属性（双线椭圆）

    ：产品的多个价格

    - 添加新的属性：将多值属性展开成多个单值属性
    - 添加弱实体：通过双菱形连双方框，属性为销售性质和价格

- 导出属性

    ：可由其他信息推导的属性，出生日期推算年龄

    - 用虚线和虚椭圆连接

**空值的三种意义**：

- 占位空值：表示无意义（未婚则配偶名无意义）
- 未知空值：表示未知（已婚但配偶名未知）
- 员工是否已婚未知

## 6.3 联系的设计

**联系的元数**：

- 一元联系：员工管理员工，零件使用零件
    - 一对一、一对多做外键
    - 多对多单独建表
- 二元联系：零件构成产品
    - 一对一：双方表选一个建对方的外键
    - 一对多：多的一方加入外键
    - 多对多：单独建表（SC）
- 三元联系：学生选老师开设的课，单独建表（SPJ）

**联系的联通词**：1:1, 1:N, M:N, M:N:P等

**联系的基数**：写在联系两侧，格式为 $\left( \min ,\max \right)$ ，靠近一侧做主语

## 6.4 ER模型的扩充

**依赖联系**：一个实体的存在以另一个实体的存在为前提

**弱实体**：两个实体依赖联系，且主键全部由父实体中获得

**子类、超类**：有继承性，且实体标识符相同。超类用两端双线的矩形框表示，联系中间加圈

子类继承超类的所有属性，但可以包含更多属性

通过子类实体和超类实体有相同的实体标识符实现（即子类和超类主键相同）

------

填空题 TLB：

> SQL 三个阶段：人工管理、文件系统、数据库系统
> 数据库技术三个阶段：层次模型、网状模型、关系模型
> 数据控制四功能：并发控制、恢复、完整性、安全性
> 三个世界：现实世界、信息世界、机器世界
> 数据模型分类：概念模型、逻辑模型
> 数据模型三要素：数据结构、数据操纵、完整性约束
> 完整性约束：实体完整性、参照完整性、用户自定义完整性
> 三级模式：外模式、模式、内模式
> 两级映像：外模式模式映像、模式内模式映像
> 完整性规则：实体完整性、参照完整性、用户自定义完整性
> 空值三个意义：占位空值、未知空值、未知