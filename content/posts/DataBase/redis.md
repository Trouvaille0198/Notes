---
title: "Redis"
date: 2022-08-10
author: MelonCholi
draft: false
tags: [数据库, 快速入门, Redis]
categories: [数据库]
---

# Redis

## 介绍

### Redis 是什么

Redis 是现在最受欢迎的 NoSQL 数据库之一，Redis 是一个使用 ANSI C 编写的开源、包含多种数据结构、支持网络、基于内存、可选持久性的键值对存储数据库，其具备如下特性：

- 基于内存运行，性能高效
- 支持分布式，理论上可以无限扩展
- key-value 存储系统
- 开源的使用 ANSI C 语言编写、遵守 BSD 协议、支持网络、可基于内存亦可持久化的日志型、Key-Value 数据库，并提供多种语言的 API

相比于其他数据库类型，Redis 具备的特点是：

- C/S 通讯模型
- 单进程单线程模型
- 丰富的数据类型
- 操作具有原子性
- 持久化
- 高并发读写
- 支持 lua 脚本

Redis 的应用场景包括：缓存系统（“热点” 数据：高频读、低频写）、计数器、消息队列系统、排行榜、社交网络和实时系统。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126140856469-550683605.png)

### Redis 的数据类型及主要特性

Redis 提供的数据类型主要分为 5 种自有类型和一种自定义类型，这 5 种自有类型包括：String 类型、哈希类型、列表类型、集合类型和顺序集合类型。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141006657-1969131669.png)

#### String 类型：

它是一个二进制安全的字符串，意味着它不仅能够存储字符串、还能存储图片、视频等多种类型, 最大长度支持 512M。

对每种数据类型，Redis 都提供了丰富的操作命令，如：

- GET/MGET
- SET/SETEX/MSET/MSETNX
- INCR/DECR
- GETSET
- DEL

#### 哈希类型：

该类型是由 field 和关联的 value 组成的 map。其中，field 和 value 都是字符串类型的。

Hash 的操作命令如下：

- HGET/HMGET/HGETALL
- HSET/HMSET/HSETNX
- HEXISTS/HLEN
- HKEYS/HDEL
- HVALS

#### 列表类型：

该类型是一个插入顺序排序的字符串元素集合, 基于双链表实现。

List 的操作命令如下：

- LPUSH/LPUSHX/LPOP/RPUSH/RPUSHX/RPOP/LINSERT/LSET
- LINDEX/LRANGE
- LLEN/LTRIM

#### 集合类型：

Set 类型是一种无顺序集合, 它和 List 类型最大的区别是：集合中的元素没有顺序, 且元素是唯一的。

Set 类型的底层是通过哈希表实现的，其操作命令为：

- SADD/SPOP/SMOVE/SCARD
- SINTER/SDIFF/SDIFFSTORE/SUNION

Set 类型主要应用于：在某些场景，如社交场景中，通过交集、并集和差集运算，通过 Set 类型可以非常方便地查找共同好友、共同关注和共同偏好等社交关系。

#### 顺序集合类型：

ZSet 是一种有序集合类型，每个元素都会关联一个 double 类型的分数权值，通过这个权值来为集合中的成员进行从小到大的排序。与 Set 类型一样，其底层也是通过哈希表实现的。

ZSet 命令：

- ZADD/ZPOP/ZMOVE/ZCARD/ZCOUNT
- ZINTER/ZDIFF/ZDIFFSTORE/ZUNION

### Redis 的数据结构

Redis 的数据结构如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141027346-984159572.png)

关于上表中的部分释义：

1. 压缩列表是列表键和哈希键的底层实现之一。当一个列表键只包含少量列表项，并且每个列表项要么就是小整数，要么就是长度比较短的字符串，Redis 就会使用压缩列表来做列表键的底层实现
2. 整数集合是集合键的底层实现之一，当一个集合只包含整数值元素，并且这个集合的元素数量不多时，Redis 就会使用整数集合作为集合键的底层实现

#### 简单动态字符串 SDS (Simple Dynamic String)

基于 C 语言中传统字符串的缺陷，Redis 自己构建了一种名为简单动态字符串的抽象类型，简称 SDS，其结构如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141052157-436992972.png)

SDS 几乎贯穿了 Redis 的所有数据结构，应用十分广泛。

##### SDS 的特点

和 C 字符串相比，SDS 的特点如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141103927-1852926069.png)

  　　1. 常数复杂度获取字符串长度
       - Redis 中利用 SDS 字符串的 len 属性可以直接获取到所保存的字符串的长
         　　　　度，直接将获取字符串长度所需的复杂度从 C 字符串的 O(N) 降低到了 O(1)。

        　　2. 减少修改字符串时导致的内存重新分配次数
       - 通过 C 字符串的特性，我们知道对于一个包含了 N 个字符的C字符串来说，其底层实现总是 N+1 个字符长的数组（额外一个空字符结尾）
       - 那么如果这个时候需要对字符串进行修改，程序就需要提前对这个 C 字符串数组进行一次内存重分配（可能是扩展或者释放），而内存重分配就意味着是一个耗时的操作。
       - 而在 SDS 中，buf 数组的长度不一定就是字符串的字符数量加一，buf 数组里面可以包含未使用的字节，而这些未使用的字节由 free 属性记录。
       - 与此同时，SDS 采用了**空间预分配**的策略，避免 C 字符串每一次修改时都需要进行内存重分配的耗时操作，将内存重分配从原来的每修改 N 次就分配 N 次——>降低到了修改 N 次最多分配 N 次。

如下是 Redis 对 SDS 的简单定义：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141239967-123973180.png) 

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141253196-1200501061.png)

### Redis 特性

#### 事务

- 命令序列化，按顺序执行
- 原子性
- 三阶段: 开始事务 - 命令入队 - 执行事务
- 命令：MULTI/EXEC/DISCARD

#### 发布订阅 (Pub/Sub)

- Pub/sub 是一种消息通讯模式
- Pub 发送消息, Sub 接受消息
- Redis 客户端可以订阅任意数量的频道
- “fire and forgot”, 发送即遗忘
- 命令：Publish/Subscribe/Psubscribe/UnSub

　　![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141305188-1053413990.png)

#### Stream

- Redis 5.0 新增
- 等待消费
- 消费组 (组内竞争)
- 消费历史数据
- FIFO

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141321299-1993625807.png)

### Redis 常见问题解析

#### 击穿

概念：在 Redis 获取某一 key 时, 由于 key 不存在, 而必须向 DB 发起一次请求的行为, 称为 “Redis 击穿”。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141408402-1663049240.png)

引发击穿的原因：

- 第一次访问
- 恶意访问不存在的 key
- Key 过期

合理的规避方案：

- 服务器启动时, 提前写入
- 规范 key 的命名, 通过中间件拦截
- 对某些高频访问的 Key，设置合理的 TTL 或永不过期

#### 雪崩

概念：Redis 缓存层由于某种原因宕机后，所有的请求会涌向存储层，短时间内的高并发请求可能会导致存储层挂机，称之为 “Redis 雪崩”。

合理的规避方案：

- 使用 Redis 集群
- 限流

### Redis 协议简介

Redis 客户端通讯协议：RESP (Redis Serialization Protocol)，其特点是：

- 简单
- 解析速度快
- 可读性好

Redis 集群内部通讯协议：RECP (Redis Cluster Protocol ) ，其特点是：

- 每一个 node 两个 tcp 连接
- 一个负责 client-server 通讯 (P: 6379)
- 一个负责 node 之间通讯 (P: 10000 + 6379)

 ![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141512967-813141543.png)

Redis 协议支持的数据类型：

- 简单字符 (首字节: “+”)

   　　“+OK\r\n”

- 错误 (首字节: “-”)

   　　“-error msg\r\n”

- 数字 (首字节: “:”)

   　　“:123\r\n”

- 批量字符 (首字节: “$”)

   　　“&hello\r\nWhoa re you\r\n”

- 数组 (首字节: “*”)

   　　“*0\r\n”*

   “*-1\r\n”

 

## Redis 与 MySQL 的配合

在 web 服务端开发的过程中，redis+mysql 是最常用的存储解决方案，mysql 存储着所有的业务数据，根据业务规模会采用相应的分库分表、读写分离、主备容灾、数据库集群等手段。但是由于 mysql 是基于磁盘的 IO，基于服务响应性能考虑，将业务热数据利用 redis 缓存，使得高频业务数据可以直接从内存读取，提高系统整体响应速度。

利用 redis+mysql 进行数据的 CRUD 时需要考虑的核心问题是**数据的一致性**。下面对读写场景的技术方案做个简单说明：

业务数据**读**操作流程：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-c437add6b1501aeb39ff554d7edd7127_1440w.jpg" alt="img" style="zoom:150%;" />

业务数据**更新**操作流程：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-02e18d5df7452f2d60e0704ff530065a_1440w.jpg" alt="img" style="zoom:150%;" />

这里采用了 mysql 数据更新成功后，直接删除 redis 中对应项的方式。目的是在保证一致性的过程中以 mysql 中数据为准，redis 中的数据始终保持和 mysql 的同步。

有的方案在这里采用的是更新完 mysql 成功后，然后进行相应的更新 redis 中数据的操作。这里的问题是，要考虑到更新的操作可能是并发的，而写 mysql 和写 redis 是两个步骤，不是原子性的。

例如有线程 1 和线程 2 同时进行写操作，执行顺序可能是如下的情况：

线程 1 写 mysql -> 线程 2 写 mysql -> 线程 2 写 redis -> 线程 1 写 redis

这样的话，结果变成了 mysql 的内容是线程 2 写入的，而 redis 的内容是线程 1 写入的，mysql 和 redis 中的数据就不一致了，后续的数据读取都是错的。

而采用每次写完 mysql 后就清除 redis 的方式，就保证了写完后的读取必然会重新从 mysql 读取数据，然后写入 redis。这样就保证了 redis 里的数据最终和 mysql 中是一致的，保证了数据的最终一致性。

### 用于高并发

高并发业务场景，数据库通常都是用户并发访问最薄弱的环节。所以，就需要使用 Redis 做一个缓冲操作，让请求先访问到 Redis，而不是直接访问 MySQL 等数据库。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-7fd82ea4776a78bdc5a4d2a906f01705_1440w.jpg)

从 Redis 读数据，一般都是按照下图的流程来进行业务操作：

![](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-428389417aace1f3739748d73d6c6c1a_1440w.jpg)

读取缓存一般没有什么问题，但是一旦涉及到数据更新：数据库和缓存更新，就容易出现缓存(Redis)和数据库(MySQL)间的数据一致性问题。不管是先写数据库，再删除缓存；还是先删除缓存，再写数据库，都有可能出现数据不一致的情况。

比如：

1. 如果先删除缓存，还没有来得及写库，另一个线程就来读取，发现缓存为空，则去数据库中读取数据写入缓存，此时缓存中为脏数据。
2. 如果先写了库，在删除缓存前，写库的线程宕机了，没有删除掉缓存，则也会出现数据不一致情况。因为写和读是并发的，无法保证顺序，就会出现缓存和数据库的数据不一致的问题。如何解决

### 缓存和数据库一致性解决方案

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-8af327bf4c805ff3ba42dc073d6b712d_1440w.jpg)

#### 采用延时双删策略

在写库前后都进行 `redis.del(key)` 操作，并且设定合理的超时时间。伪代码如下：

```java
//具体的步骤：先删除缓存；再写数据库；休眠500毫秒；再次删除缓存。 
public void write(String key,Object data){   
    redis.delKey(key);   
    db.updateData(data); //不休眠的话，读请求还有可能未结束，造成脏数据   
    Thread.sleep(500);   
    redis.delKey(key); 
}
```

这个 500 毫秒怎么确定的，具体该休眠多久呢？

需要评估具体项目的读数据业务逻辑的耗时。目的就是确保读请求结束，写请求可以删除读请求造成的缓存脏数据。

当然这种策略还要考虑 Redis 和[数据库主从](https://www.zhihu.com/search?q=数据库主从&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A2525588327})同步的耗时。最后的写数据的休眠时间：在读数据业务逻辑的耗时基础上，加几百毫秒即可。比如：休眠 1 秒。

##### 设置缓存过期时间

从理论上来说，给缓存设置过期时间，是保证最终一致性的解决方案。所有的写操作以数据库为准，只要到达缓存过期时间，则后面的读请求自然会从数据库中读取新值然后回填缓存。

##### 该方案的弊端

结合双删策略 + 缓存超时设置，这样最差的情况就是在超时时间内数据存在不一致，而且又增加了写请求的耗时。

#### 异步更新缓存 (基于订阅binlog的同步机制)

##### 技术整体思路：

- MySQL binlog 增量订阅消费+[消息队列](https://link.zhihu.com/?target=https%3A//blog.csdn.net/ChineseSoftware/article/details/123269119)+增量数据更新到 Redis

- 读 Redis：热点数据基本都在 Redis

- 写 MySQL：增删改都是操作 MySQL
- 更新 Redis 数据：MySQL 的数据操作 binlog，来更新到 Redis

##### Redis 更新

数据操作主要分为两大块：

- 全量 (将全部数据一次写入到 Redis)
- 增量 (实时更新)

这里说的增量，指的是 MySQL 的 update、insert、delate 变更数据。

读取 binlog 后分析，利用消息队列，推送更新各台的 Redis 缓存数据。

这样一旦 MySQL 中产生了写入、更新、删除等操作，就可以把 binlog 相关的消息推送至 Redis，Redis 再根据 binlog 中的记录，对 Redis 进行更新。

其实这种机制，很类似 MySQL 的主从备份机制，因为 MySQL 的主备也是通过 binlog 来实现的数据一致性。

这里可以结合使用 canal（阿里的一款开源框架），通过该框架可以对 MySQL 的 binlog 进行订阅，而 canal 正是模仿了 MySQL 的 slave 数据库的备份请求，使得 Redis 的数据更新达到了相同的效果。

当然，这里的消息推送工具也可以采用别的第三方：kafka、RabbitMQ 等来实现推送更新 Redis