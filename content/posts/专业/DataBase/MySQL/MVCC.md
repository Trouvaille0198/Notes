---
title: "MySQL 多版本并发控制 MVCC"
date: 2022-11-17
author: MelonCholi
draft: false
tags: [数据库, MySQL]
categories: [数据库]
---

# MVCC

> 这里讨论的事务，在其生命周期中只会提交（commit）一次，并且其总是最后一个步骤，故可以把提交视为事务的结束

**多版本并发控制** MVCC (`Multiversion concurrency control`) 就是**同一份数据保留多个版本**的一种方式，进而实现并发控制。在查询的时候，通过**快照**和**版本链**找到对应版本的数据。

为什么需要 MVCC 呢？

- 数据库通常使用锁来实现隔离性。最原生的锁，锁住一个资源后会禁止其他任何线程访问同一个资源。
    - 但是很多应用的一个特点都是读多写少的场景，很多数据的读取次数远大于修改的次数，而读取数据间互相排斥显得不是很必要。
    - 所以就使用了一种读写锁的方法，读锁和读锁之间不互斥，而写锁和写锁、读锁都互斥。这样就很大提升了系统的并发能力（体现在**并发读**上）。
- 之后人们发现并发读还是不够，又提出了能不能让读写之间也不冲突的方法，就是读取数据时通过一种类似**快照**的方式将数据保存下来，这样读锁就和写锁不冲突了，不同的事务 session 会看到自己特定版本的数据。
    - 当然快照是一种概念模型，不同的数据库可能用不同的方式来实现这种功能。

## 作用

- **在不加锁的情况下，解决数据库读写冲突问题**，并且解决脏读、不可重复读、幻读（快照读条件下能解决）等问题，但是不能解决丢失修改问题。
- **提升并发性能**。对于高并发场景，MVCC 比行级锁开销更小

## InnoDB 与 MVCC

**MVCC 只在 READ COMMITTED 和 REPEATABLE READ 两个隔离级别下工作。**其他两个隔离级别够和 MVCC 不兼容，因为 READ UNCOMMITTED 总是读取最新的数据行, 而不是符合当前事务版本的数据行。而 SERIALIZABLE 则会对所有读取的行都加锁。

## MVCC 实现原理

### 版本链

MVCC 的实现依赖于**版本链**，版本链是通过表的三个隐藏字段实现。

- `DB_TRX_ID`：当前事务 id，通过事务 id 的大小判断事务的时间顺序。
- `DB_ROLL_PTR`：回滚指针，指向当前行记录的上一个版本，通过这个指针将数据的多个版本连接在一起构成 `undo log` 版本链。
- `DB_ROW_ID`：主键，如果数据表没有主键，InnoDB 会自动生成主键。

每条记录都会拥有这三个字段，大概是这样的：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-3f2f8eaa0fc8e9b04300f0510fd729dd_1440w.png)

MVCC 使用到的**快照会存储在 Undo log 中**，该日志通过回滚指针将一个一个数据行的所有快照连接起来，即版本链。

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

### 快照 Read View

快照 `read view` 可以理解成将数据在每个时刻的状态拍成 “照片” 记录下来。在获取某时刻 t 的数据时，到 t 时间点拍的 “照片” 上取数据。

`read view` 中主要就是**有个列表来存储我们系统中当前活跃着的读写事务**，也就是 `begin` 了还未 `commit` 的事务。通过这个列表来判断记录的某个版本是否对当前事务可见。

在 `read view` 内部维护一个活跃事务链表，表示生成 `read view` 的时候还在活跃的事务。这个链表包含在创建 `read view` 之前还未提交的事务，不包含创建 `read view` 之后提交的事务。

:star: 不同隔离级别创建 read view 的时机不同。

- **read committed**：每次执行 select 都会创建新的 read_view，保证能读取到其他事务已经提交的修改。
- **repeatable read**：在一个事务范围内，第一次 select 时更新这个 read_view，以后不会再更新，后续所有的 select 都是复用之前的 read_view。这样可以保证事务范围内每次读取的内容都一样，即可重复读。

#### read view 的记录筛选方式

- `trx_ids`: 当前系统活跃 (`未提交`) 事务版本号集合
- `up_limit_id`：表示创建当前快照中的最先开始的事务；
- `low_limit_id` 表示当前快照中的最慢开始的事务，即最后一个事务。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-fef7954f5e3c7713f48b35597e7f9fb8_1440w.jpg)

### 举例

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

- 如果是**读已提交**隔离级别 READ_COMMITED，这时候你会重新一个 ReadView，那你的活动事务列表中的值就变了，变成了 [110]。按照上的说法，你去版本链通过 trx_id 对比查找到合适的结果就是强哥 2。

- 如果是**可重复读**隔离级别 REPEATABLE_READ，这时候你的 ReadView 还是第一次 select 时候生成的 ReadView，也就是列表的值还是 [100]。所以 select 的结果是强哥 1。所以第二次 select 结果和第一次一样。

也就是说已提交读隔离级别下的事务在每次查询的开始都会生成一个独立的 ReadView，而可重复读隔离级别则在第一次读的时候生成一个 ReadView，之后的读都复用之前的 ReadView。

这就是 Mysql 的 MVCC；通过版本链，实现多版本，可并发读写 / 写读。通过 ReadView 生成策略的不同实现不同的隔离级别。

**总结**：InnoDB 的 `MVCC` 是通过 `read view` 和版本链实现的，版本链保存有历史版本记录，通过 `read view` 判断当前版本的数据是否可见，如果不可见，再从版本链中找到上一个版本，继续进行判断，直到找到一个可见的版本。

## 快照读和当前读

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