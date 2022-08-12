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

 