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

- 基于**内存**运行，性能高效

- 支持分布式，理论上可以无限扩展
- **key-value** 存储系统
- 开源的使用 ANSI C 语言编写、遵守 BSD 协议、支持网络、可基于内存亦可持久化的日志型、Key-Value 数据库，并提供多种语言的 API

相比于其他数据库类型，Redis 具备的特点是：

- C/S 通讯模型
- **单进程单线程**模型
- 丰富的数据类型
- 操作具有原子性
- **持久化**
- 高并发读写
- 支持 lua 脚本

Redis 的应用场景包括：

- 缓存系统（“热点” 数据：高频读、低频写）
- 计数器
- 消息队列（排行榜、社交网络和实时系统）
- 分布式锁

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

## 数据类型

Redis 提供的数据类型主要分为 5 种自有类型和一种自定义类型，这 5 种自有类型包括：String 类型、哈希类型、列表类型、集合类型和顺序集合类型

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/139239-20191126141006657-1969131669.png)

对每种数据类型，Redis 都提供了丰富的操作命令，如：

- GET/MGET
- SET/SETEX/MSET/MSETNX
- INCR/DECR
- GETSET
- DEL

### 总结

| 类型                  | 简介                                                   | 特性                                                         | 场景                                                         |
| :-------------------- | :----------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| String (字符串)       | 二进制安全                                             | 可以包含任何数据,比如 jpg 图片或者序列化的对象,一个键最大能存储 512M | ---                                                          |
| Hash (字典)           | 键值对集合,即编程语言中的Map类型                       | 适合存储对象,并且可以像数据库中update一个属性一样只修改某一项属性值 (Memcached中需要取出整个字符串反序列化成对象修改完再序列化存回去) | 存储、读取、修改用户属性                                     |
| List (列表)           | 链表(双向链表)                                         | 增删快,提供了操作某一段元素的API                             | 1. 最新消息排行等功能(比如朋友圈的时间线) 2. 消息队列        |
| Set (集合)            | 哈希表实现,元素不重复                                  | 1、添加、删除,查找的复杂度都是 O(1) 2、为集合提供了求交集、并集、差集等操作 | 1. 共同好友 2. 利用唯一性,统计访问网站的所有独立ip 3. 好友推荐时，根据tag求交集，大于某个阈值就可以推荐 |
| Sorted Set (有序集合) | 将Set中的元素增加一个权重参数score,元素按score有序排列 | 数据插入集合时,已经进行天然排序                              | 1. 排行榜 2. 带权重的消息队列                                |

### String

- string 是 redis 最基本的类型。你可以理解成与 Memcached 一模一样的类型，一个 key 对应一个 value
- string 类型是**二进制安全**的。它可以包含任何数据。比如 jpg 图片或者序列化的对象
- string 类型的值最大能存储 **512MB**

```shell
redis 127.0.0.1:6379> SET runoob "芜湖芜湖真的好满足"
OK
redis 127.0.0.1:6379> GET runoob
"芜湖芜湖真的好满足"
```

#### 操作命令

- SET 
- GET

#### 使用场景

一般我们用 String 类型用来存储商品数量、用户信息和分布式锁等应用场景

**存储商品数量**

```shell
set goods:count:1 1233
set goods:count:2 100
```

**用户信息**

```redis
set user:1 "{"id":1, "name":"张三", "age": 12}"
set user:2 "{"id":2, "name":"李四", "age": 12}"
```

**分布式锁**

```shell
# 设置一个不存在的键名为id:1值为10， 过期时间为10秒。
127.0.0.1:6379> set id:1 10 ex 10 nx
OK
127.0.0.1:6379> get id:1
"10"
# 当前的键还未过期，在次设置则不会设置成功。
127.0.0.1:6379> set id:1 10 ex 10 nx
(nil)
# 当10秒之后去获取，当前的键则为空。
127.0.0.1:6379> get id:1
(nil)
```

> 用 Redis 实现分布式锁的原理，当一个键存在则设置失败。

### Hash

- Redis hash 是一个 string 类型的 field 和 value 的映射表，hash 特别适合用于存储对象。

- 其中，field 和 value 都是字符串类型的

- 每个 hash 可以存储 232 -1 键值对（40 多亿）

```shell
redis 127.0.0.1:6379> DEL runoob
redis 127.0.0.1:6379> HMSET wuhu field1 "Hello" field2 "World"
"OK"
redis 127.0.0.1:6379> HGET wuhu field1
"Hello"
redis 127.0.0.1:6379> HGET wuhu field2
"World"
```

- **HMSET** 设置了两个 **field=>value** 对

- **HGET** 获取对应 **field** 对应的 **value**

#### 操作命令

- HGET/HMGET/HGETALL
- HSET/HMSET/HSETNX
- HEXISTS/HLEN
- HKEYS/HDEL
- HVALS

#### 使用场景

利用 hash 结构，我们可以用来存储用户信息、对象信息等业务场景。

**存用户信息**

```shell
127.0.0.1:6379> hset user:1 id 1 name zhangsan age 12 sex 1
(integer) 4
127.0.0.1:6379> hset user:2 id 2 name lisi age 14 sex 0
(integer) 4
127.0.0.1:6379> hmget user:1 id name age sex
1) "1"
2) "zhangsan"
3) "12"
4) "1"
```

**存储对象信息**

```shell
127.0.0.1:6379> hset object:user id public-1 name private-zhangsan
(integer) 2
127.0.0.1:6379> hmget object:uesr id name
1) (nil)
2) (nil)
127.0.0.1:6379> hget object:user id
"public-1"
127.0.0.1:6379>
```

### List

- 该类型是一个**按照插入顺序排序**的**字符串集合**，基于**双链表**实现。

- 你可以添加一个元素到列表的头部（左边）或者尾部（右边）
- 列表最多可存储 232 - 1 元素 (4294967295, 每个列表可存储 40 多亿)。

```shell
redis 127.0.0.1:6379> lpush wuhu redis
(integer) 1
redis 127.0.0.1:6379> lpush wuhu mongodb
(integer) 2
redis 127.0.0.1:6379> lpush wuhu rabbitmq
(integer) 3
redis 127.0.0.1:6379> lrange wuhu 0 10
1) "rabbitmq"
2) "mongodb"
3) "redis"
```

#### 操作命令

- LPUSH / LPUSHX/LPOP / RPUSH / RPUSHX / RPOP / LINSERT / LSET
- LINDEX / LRANGE
- LLEN / LTRIM

#### 使用场景

list 一般用在的场景是队列、栈和秒杀等场景

**队列**

```shell
127.0.0.1:6379> lpush list:1 0 1 2 3 4 5 6
(integer) 7
127.0.0.1:6379> rpop list:1 1
1) "0"
127.0.0.1:6379> rpop list:1 1
1) "1"
127.0.0.1:6379> rpop list:1 1
1) "2"
```

**栈**

```shell
127.0.0.1:6379> lpush list:1 3 4 5 6
(integer) 3
127.0.0.1:6379> lpop list:1
"6"
127.0.0.1:6379> lpop list:1
"5"
127.0.0.1:6379> lpop list:1
"4"
127.0.0.1:6379> lpop list:1
"3"
```

**秒杀**

```shell
127.0.0.1:6379> lpush order:user 11 12 14 15 16 17
(integer) 6
```

> 在秒杀场景下，我们可以将秒杀成功的用户先写进队列，后续的业务在根据队列中数据进行处理。

### Set

- Set 类型是一种**无顺序**的字符串集合，且元素是唯一的

- Set 类型的底层是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。

Set 类型主要应用于：在某些场景，如社交场景中，通过交集、并集和差集运算，通过 Set 类型可以非常方便地查找共同好友、共同关注和共同偏好等社交关系。

#### 操作命令

- SADD / SPOP / SMOVE / SCARD
- SINTER / SDIFF / SDIFFSTORE / SUNION

#### 使用场景

set 类型一般可以用在用户签到、网站访问统计、用户关注标签、好友推荐、猜奖、随机数生成等业务场景

**某日用户签到情况**

```shell
# 键为具体某日，存储的值则是签到用户的id。
127.0.0.1:6379> sadd sign:2020-01-16 1 2 3 4 5 6 7 8
(integer) 8
127.0.0.1:6379> smembers sign:2020-01-16
1) "1"
2) "2"
3) "3"
4) "4"
5) "5"
6) "6"
7) "7"
8) "8"
```

**用户关注标签（共同关注）**

```shell
127.0.0.1:6379> sadd user:1:friend 1 2 3 4 5 6
(integer) 6
127.0.0.1:6379> sadd user:2:friend 11 22 7 4 5 6
(integer) 6
127.0.0.1:6379> sinterstore user:relation user:1:friend user:2:friend
(integer) 3
127.0.0.1:6379> smembers user:relation
1) "4"
2) "5"
3) "6"
```

> 用户 1 关注了 id 为 1，2，3，4，5，6 的栏目。用户 2 关注了 id 为 11，22，7，4，5，6 的栏目。这里取两个用户共同关注的栏目。

**猜奖**

```shell
127.0.0.1:6379> spop user:2:friend 1
1) "5"
```

> 用 set 实现猜奖，主要是使用了随机抛出集合类的元素的特点。

### Zset

> sorted set：有序集合

- ZSet 是一种有序集合类型，**每个元素都会关联一个 double 类型的分数权值**，通过这个权值来为集合中的成员进行从小到大的**排序**。

- 与 Set 类型一样，其底层也是通过哈希表实现的。
- zset 的成员是唯一的,但**分数 (score) 却可以重复**

#### 实例

```shell
redis 127.0.0.1:6379> DEL runoob
redis 127.0.0.1:6379> zadd runoob 0 redis
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 mongodb
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 rabbitmq
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 rabbitmq
(integer) 0
redis 127.0.0.1:6379> ZRANGEBYSCORE runoob 0 1000
1) "mongodb"
2) "rabbitmq"
3) "redis"
```

#### 操作命令

- ZADD / ZPOP / ZMOVE / ZCARD / ZCOUNT
- ZINTER / ZDIFF / ZDIFFSTORE / ZUNION’

#### 使用场景

**签到排行榜**

```shell
127.0.0.1:6379> zadd goods:order 1610812987 1
(integer) 1
127.0.0.1:6379> zadd goods:order 1610812980 2
(integer) 1
127.0.0.1:6379> zadd goods:order 1610812950 3
(integer) 1
127.0.0.1:6379> zadd goods:order 1610814950 4
(integer) 1
127.0.0.1:6379> zcard goods:order
(integer) 4
127.0.0.1:6379> zrangebyscore goods:order 1610812950 1610812987
1) "3"
2) "2"
3) "1"
```

> 将用户的签到时间作为排行的分数，最后查询指定范围内签到用户的id

## 安装

### Ubuntu apt 命令安装

在 Ubuntu 系统安装 Redis 可以使用以下命令:

```shell
sudo apt update
sudo apt install redis-server
```

**启动 Redis**

```shell
redis-server
```

**查看 redis 是否启动**

```shell
redis-cli
```

以上命令将打开以下终端：

```shell
redis 127.0.0.1:6379>
```

127.0.0.1 是本机 IP ，6379 是 redis 服务端口。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220901143345782.png" alt="image-20220901143345782" style="zoom:67%;" />



### windows

启动服务

```shell
redis-server --service-start
```

停止服务

```shell
redis-server --service-stop
```

## 配置

Redis 的配置文件位于 Redis 安装目录下，文件名为 **redis.conf** (Windows 名为 redis.windows.conf)

你可以通过 **CONFIG** 命令查看或设置配置项（小写也可）

### 查看

```shell
CONFIG GET <CONFIG_SETTING_NAME>
```

例

```shell
redis 127.0.0.1:6379> CONFIG GET loglevel

1) "loglevel"
2) "notice"
```

使用 `*` 号获取全部配置项

```shell
redis 127.0.0.1:6379> CONFIG GET *

  1) "dbfilename"
  2) "dump.rdb"
  3) "requirepass"
  4) ""
  5) "masterauth"
  6) ""
  7) "unixsocket"
  8) ""
  9) "logfile"
 	...
  113) "notify-keyspace-events"
  114) ""
  115) "bind"
  116) ""
```

### 修改

你可以通过修改 redis.conf 文件或使用 **CONFIG SET** 命令来修改配置。

```
CONFIG SET CONFIG_SETTING_NAME NEW_CONFIG_VALUE
```

例

```shell
redis 127.0.0.1:6379> CONFIG SET loglevel "notice"
OK
redis 127.0.0.1:6379> CONFIG GET loglevel

1) "loglevel"
2) "notice"
```

### 参数说明

redis.conf 配置项说明如下：

| 序号 | 配置项                                                       | 说明                                                         |
| :--- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| 1    | `daemonize no`                                               | Redis 默认不是以守护进程的方式运行，可以通过该配置项修改，使用 yes 启用守护进程（Windows 不支持守护线程的配置为 no ） |
| 2    | `pidfile /var/run/redis.pid`                                 | 当 Redis 以守护进程方式运行时，Redis 默认会把 pid 写入 /var/run/redis.pid 文件，可以通过 pidfile 指定 |
| 3    | `port 6379`                                                  | 指定 Redis 监听端口，默认端口为 6379，作者在自己的一篇博文中解释了为什么选用 6379 作为默认端口，因为 6379 在手机按键上 MERZ 对应的号码，而 MERZ 取自意大利歌女 Alessia Merz 的名字 |
| 4    | `bind 127.0.0.1`                                             | 绑定的主机地址                                               |
| 5    | `timeout 300`                                                | 当客户端闲置多长秒后关闭连接，如果指定为 0 ，表示关闭该功能  |
| 6    | `loglevel notice`                                            | 指定日志记录级别，Redis 总共支持四个级别：debug、verbose、notice、warning，默认为 notice |
| 7    | `logfile stdout`                                             | 日志记录方式，默认为标准输出，如果配置 Redis 为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给 /dev/null |
| 8    | `databases 16`                                               | 设置数据库的数量，默认数据库为0，可以使用SELECT 命令在连接上指定数据库id |
| 9    | `save <seconds> <changes>`Redis 默认配置文件中提供了三个条件：**save 900 1****save 300 10****save 60 10000**分别表示 900 秒（15 分钟）内有 1 个更改，300 秒（5 分钟）内有 10 个更改以及 60 秒内有 10000 个更改。 | 指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合 |
| 10   | `rdbcompression yes`                                         | 指定存储至本地数据库时是否压缩数据，默认为 yes，Redis 采用 LZF 压缩，如果为了节省 CPU 时间，可以关闭该选项，但会导致数据库文件变的巨大 |
| 11   | `dbfilename dump.rdb`                                        | 指定本地数据库文件名，默认值为 dump.rdb                      |
| 12   | `dir ./`                                                     | 指定本地数据库存放目录                                       |
| 13   | `slaveof <masterip> <masterport>`                            | 设置当本机为 slave 服务时，设置 master 服务的 IP 地址及端口，在 Redis 启动时，它会自动从 master 进行数据同步 |
| 14   | `masterauth <master-password>`                               | 当 master 服务设置了密码保护时，slave 服务连接 master 的密码 |
| 15   | `requirepass foobared`                                       | 设置 Redis 连接密码，如果配置了连接密码，客户端在连接 Redis 时需要通过 AUTH <password> 命令提供密码，默认关闭 |
| 16   | ` maxclients 128`                                            | 设置同一时间最大客户端连接数，默认无限制，Redis 可以同时打开的客户端连接数为 Redis 进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis 会关闭新的连接并向客户端返回 max number of clients reached 错误信息 |
| 17   | `maxmemory <bytes>`                                          | 指定 Redis 最大内存限制，Redis 在启动时会把数据加载到内存中，达到最大内存后，Redis 会先尝试清除已到期或即将到期的 Key，当此方法处理 后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。Redis 新的 vm 机制，会把 Key 存放内存，Value 会存放在 swap 区 |
| 18   | `appendonly no`                                              | 指定是否在每次更新操作后进行日志记录，Redis 在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis 本身同步数据文件是按上面 save 条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为 no |
| 19   | `appendfilename appendonly.aof`                              | 指定更新日志文件名，默认为 appendonly.aof                    |
| 20   | `appendfsync everysec`                                       | 指定更新日志条件，共有 3 个可选值：**no**：表示等操作系统进行数据缓存同步到磁盘（快）**always**：表示每次更新操作后手动调用 fsync() 将数据写到磁盘（慢，安全）**everysec**：表示每秒同步一次（折中，默认值） |
| 21   | `vm-enabled no`                                              | 指定是否启用虚拟内存机制，默认值为 no，简单的介绍一下，VM 机制将数据分页存放，由 Redis 将访问量较少的页即冷数据 swap 到磁盘上，访问多的页面由磁盘自动换出到内存中（在后面的文章我会仔细分析 Redis 的 VM 机制） |
| 22   | `vm-swap-file /tmp/redis.swap`                               | 虚拟内存文件路径，默认值为 /tmp/redis.swap，不可多个 Redis 实例共享 |
| 23   | `vm-max-memory 0`                                            | 将所有大于 vm-max-memory 的数据存入虚拟内存，无论 vm-max-memory 设置多小，所有索引数据都是内存存储的(Redis 的索引数据 就是 keys)，也就是说，当 vm-max-memory 设置为 0 的时候，其实是所有 value 都存在于磁盘。默认值为 0 |
| 24   | `vm-page-size 32`                                            | Redis swap 文件分成了很多的 page，一个对象可以保存在多个 page 上面，但一个 page 上不能被多个对象共享，vm-page-size 是要根据存储的 数据大小来设定的，作者建议如果存储很多小对象，page 大小最好设置为 32 或者 64bytes；如果存储很大大对象，则可以使用更大的 page，如果不确定，就使用默认值 |
| 25   | `vm-pages 134217728`                                         | 设置 swap 文件中的 page 数量，由于页表（一种表示页面空闲或使用的 bitmap）是在放在内存中的，，在磁盘上每 8 个 pages 将消耗 1byte 的内存。 |
| 26   | `vm-max-threads 4`                                           | 设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4 |
| 27   | `glueoutputbuf yes`                                          | 设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启 |
| 28   | `hash-max-zipmap-entries 64 hash-max-zipmap-value 512`       | 指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法 |
| 29   | `activerehashing yes`                                        | 指定是否激活重置哈希，默认为开启（后面在介绍 Redis 的哈希算法时具体介绍） |
| 30   | `include /path/to/local.conf`                                | 指定包含其它的配置文件，可以在同一主机上多个Redis实例之间使用同一份配置文件，而同时各个实例又拥有自己的特定配置文件 |

## Redis 命令

> **cheatsheet**：http://doc.redisfans.com/

Redis 命令用于在 redis 服务上执行操作。

要在 redis 服务上执行命令需要一个 redis 客户端：

```shell
redis-cli
```

如果需要在远程 redis 服务上执行命令：

```shell
redis-cli -h host -p port -a password
```

例

```shell
$redis-cli -h 127.0.0.1 -p 6379 -a "mypass"
redis 127.0.0.1:6379>
redis 127.0.0.1:6379> PING

PONG
```

### 键 (key)

Redis 键命令用于管理 redis 的键。

```shell
COMMAND KEY_NAME
```

例

```shell
redis 127.0.0.1:6379> exists wuhu
(integer) 1
redis 127.0.0.1:6379> DEL runoobkey
(integer) 1 								# 1 代表键被删除成功
```

#### 基本命令

| 命令                                      | 描述                                                         |
| :---------------------------------------- | :----------------------------------------------------------- |
| DEL key                                   | 在 key 存在时删除 key                                        |
| DUMP key                                  | 序列化给定 key ，并返回被序列化的值                          |
| EXISTS key                                | 检查给定 key 是否存在                                        |
| EXPIRE key seconds                        | 为给定 key 设置过期时间，以秒计                              |
| EXPIREAT key timestamp                    | 为给定 key 设置过期时间，以 UNIX 时间戳 (unix timestamp) 计  |
| PEXPIRE key milliseconds                  | 为给定 key 设置过期时间，以毫秒计                            |
| KEYS pattern                              | 查找所有符合给定模式 (pattern) 的 key                        |
| MOVE key db                               | 将当前数据库的 key 移动到给定的数据库 db 当中                |
| PERSIST key                               | 移除 key 的过期时间，key 将持久保持                          |
| PTTL key                                  | 以毫秒为单位返回 key 的剩余的过期时间                        |
| TTL key                                   | 以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live)。 |
| RANDOMKEY                                 | 从当前数据库中随机返回一个 key                               |
| RENAME key newkey                         | 修改 key 的名称                                              |
| RENAMENX key newkey                       | 仅当 newkey 不存在时，将 key 改名为 newkey 。                |
| SCAN cursor [MATCH pattern] [COUNT count] | 迭代数据库中的数据库键                                       |
| TYPE key                                  | 返回 key 所储存的值的类型                                    |

### 字符串 (String)

Redis 字符串数据类型的相关命令用于管理 redis 字符串值

```shell
redis 127.0.0.1:6379> COMMAND KEY_NAME
```

例

```shell
redis 127.0.0.1:6379> SET runoobkey redis
OK
redis 127.0.0.1:6379> GET runoobkey
"redis"
```

#### 基本命令

| 命令                           | 描述                                                         |
| :----------------------------- | :----------------------------------------------------------- |
| SET key value                  | 设置指定 key 的值                                            |
| GET key                        | 获取指定 key 的值                                            |
| GETRANGE key start end         | 返回 key 中字符串值的子字符（包括 end）                      |
| GETSET key value               | 将给定 key 的值设为 value ，并返回 key 的**旧值** (old value) |
| GETBIT key offset              | 对 key 所储存的字符串值，获取指定偏移量上的位 (bit)          |
| MGET key1 [key2..]             | 获取所有(一个或多个)给定 key 的值                            |
| SETEX key seconds value        | 将值 value 关联到 key ，并将 key 的过期时间设为 seconds (以秒为单位) |
| SETNX key value                | 只有在 key 不存在时设置 key 的值                             |
| SETRANGE key offset value      | 用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始 |
| STRLEN key                     | 返回 key 所储存的字符串值的长度                              |
| MSET key value [key value ...] | 同时设置一个或多个 key-value 对                              |
| PSETEX key milliseconds value  | 将值 value 关联到 key ，并将 key 的过期时间设为 milliseconds (以毫秒为单位) |
| INCR key                       | 将 key 中储存的数字值增一                                    |
| INCRBY key increment           | 将 key 所储存的值加上给定的增量值（increment）               |
| DECR key                       | 将 key 中储存的数字值减一                                    |
| DECRBY key decrement           | key 所储存的值减去给定的减量值（decrement)                   |
| APPEND key value               | 如果 key 已经存在并且是一个字符串， 将指定的 value 追加到该 key 原值的末尾 |

### 哈希 (Hash)

例

```shell
127.0.0.1:6379>  HMSET wuhu name "redis tutorial" description "redis basic commands for caching" likes 20 visitors 23000
OK
127.0.0.1:6379>  HGETALL wuhu
1) "name"
2) "redis tutorial"
3) "description"
4) "redis basic commands for caching"
5) "likes"
6) "20"
7) "visitors"
8) "23000"
```

在以上实例中，我们设置了 redis 的一些描述信息(name, description, likes, visitors) 到哈希表的 wuhu 中

#### 基本命令

| 命令                                           | 描述                                                |
| :--------------------------------------------- | :-------------------------------------------------- |
| HDEL key field1 [field2]                       | 删除一个或多个哈希表字段                            |
| HEXISTS key field                              | 查看哈希表 key 中，指定的字段是否存在               |
| HGET key field                                 | 获取存储在哈希表中指定字段的值                      |
| HGETALL key                                    | 获取在哈希表中指定 key 的所有字段和值               |
| HINCRBY key field increment                    | 为哈希表 key 中的指定字段的整数值加上增量 increment |
| HKEYS key                                      | 获取所有哈希表中的字段                              |
| HLEN key                                       | 获取哈希表中字段的数量                              |
| HMGET key field1 [field2]                      | 获取所有给定字段的值                                |
| HMSET key field1 value1 [field2 value2 ]       | 同时将多个 field-value (域-值)对设置到哈希表 key 中 |
| HSET key field value                           | 将哈希表 key 中的字段 field 的值设为 value          |
| HSETNX key field value                         | 只有在字段 field 不存在时，设置哈希表字段的值       |
| HVALS key                                      | 获取哈希表中所有值                                  |
| HSCAN key cursor [MATCH pattern] [COUNT count] | 迭代哈希表中的键值对                                |

### 列表 (List)

例

```shell
redis 127.0.0.1:6379> LPUSH wuhu redis
(integer) 1
redis 127.0.0.1:6379> LPUSH wuhu mongodb
(integer) 2
redis 127.0.0.1:6379> LPUSH wuhu mysql
(integer) 3
redis 127.0.0.1:6379> LRANGE wuhu 0 10

1) "mysql"
2) "mongodb"
3) "redis"
```

在以上实例中我们使用了 **LPUSH** 将三个值插入了名为 **wuhu** 的列表当中。

#### 基本命令

| 命令                                   | 描述                                                         |
| :------------------------------------- | :----------------------------------------------------------- |
| BLPOP key1 [key2 ] timeout             | 移出并获取列表的第一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。 |
| BRPOP key1 [key2 ] timeout             | 移出并获取列表的最后一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止 |
| BRPOPLPUSH source destination timeout  | 从列表中弹出一个值，将弹出的元素插入到另外一个列表中并返回它； 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。 |
| LINDEX key index                       | 通过索引获取列表中的元素                                     |
| LINSERT key BEFORE / AFTER pivot value | 在列表的元素前 / 后插入元素                                  |
| LLEN key                               | 获取列表长度                                                 |
| **LPOP** key                           | 移出并获取列表的第一个元素                                   |
| **LPUSH** key value1 [value2]          | 将一个或多个值插入到列表头部                                 |
| LPUSHX key value                       | 将一个值插入到已存在的列表头部，列表不存在时操作无效         |
| **LRANGE** key start stop              | 获取列表指定范围内的元素                                     |
| LREM key count value                   | 移除列表元素  count > 0 : 从表头开始向表尾搜索，移除与 VALUE 相等的元素，数量为 COUNT 。 count < 0 : 从表尾开始向表头搜索，移除与 VALUE 相等的元素，数量为 COUNT 的绝对值。 count = 0 : 移除表中所有与 VALUE 相等的值。 |
| **LSET** key index value               | 通过索引设置列表元素的值                                     |
| LTRIM key start stop                   | 对一个列表进行修剪(trim)，就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除 |
| RPOP key                               | 移除列表的最后一个元素，返回值为移除的元素。                 |
| RPOPLPUSH source destination           | 移除列表的最后一个元素，并将该元素添加到另一个列表并返回     |
| RPUSH key value1 [value2]              | 在列表中添加一个或多个值                                     |
| RPUSHX key value                       | 为已存在的列表添加值，列表不存在时操作无效                   |

### 集合 (Set)

例

```shell
redis 127.0.0.1:6379> SADD wuhu redis
(integer) 1
redis 127.0.0.1:6379> SADD wuhu mongodb
(integer) 1
redis 127.0.0.1:6379> SADD wuhu mysql
(integer) 1
redis 127.0.0.1:6379> SADD wuhu mysql
(integer) 0
redis 127.0.0.1:6379> SMEMBERS wuhu

1) "mysql"
2) "mongodb"
3) "redis"
```

在以上实例中我们通过 **SADD** 命令向名为 **wuhu** 的集合插入的三个元素

#### 基本命令

| 命令                                           | 描述                                                |
| :--------------------------------------------- | :-------------------------------------------------- |
| **SADD** key member1 [member2]                 | 向集合添加一个或多个成员                            |
| SCARD key                                      | 获取集合的成员数                                    |
| SDIFF key1 [key2]                              | 返回第一个集合与其他集合之间的差异                  |
| SDIFFSTORE destination key1 [key2]             | 返回给定所有集合的差集并存储在 destination 中       |
| SINTER key1 [key2]                             | 返回给定所有集合的交集                              |
| SINTERSTORE destination key1 [key2]            | 返回给定所有集合的交集并存储在 destination 中       |
| **SISMEMBER** key member                       | 判断 member 元素是否是集合 key 的成员               |
| **SMEMBERS** key                               | 返回集合中的所有成员                                |
| SMOVE source destination member                | 将 member 元素从 source 集合移动到 destination 集合 |
| SPOP key                                       | 移除并返回集合中的一个随机元素                      |
| SRANDMEMBER key [count]                        | 返回集合中一个或多个随机数                          |
| **SREM** key member1 [member2]                 | 移除集合中一个或多个成员                            |
| SUNION key1 [key2]                             | 返回所有给定集合的并集                              |
| SUNIONSTORE destination key1 [key2]            | 所有给定集合的并集存储在 destination 集合中         |
| SSCAN key cursor [MATCH pattern] [COUNT count] | 迭代集合中的元素                                    |

### 有序集合 (Sorted set)

例

```shell
redis 127.0.0.1:6379> ZADD wuhu 1 redis
(integer) 1
redis 127.0.0.1:6379> ZADD wuhu 2 mongodb
(integer) 1
redis 127.0.0.1:6379> ZADD wuhu 3 mysql
(integer) 1
redis 127.0.0.1:6379> ZADD wuhu 3 mysql
(integer) 0
redis 127.0.0.1:6379> ZADD wuhu 4 mysql
(integer) 0
redis 127.0.0.1:6379> ZRANGE wuhu 0 10 WITHSCORES

1) "redis"
2) "1"
3) "mongodb"
4) "2"
5) "mysql"
6) "4"
```

在以上实例中我们通过命令 **ZADD** 向 redis 的有序集合中添加了三个值并关联上分数

#### 基本命令

| 命令                                           | 描述                                                         |
| :--------------------------------------------- | :----------------------------------------------------------- |
| **ZADD** key score1 member1 [score2 member2]   | 向有序集合添加一个或多个成员，或者更新已存在成员的分数       |
| ZCARD key                                      | 获取有序集合的成员数                                         |
| ZCOUNT key min max                             | 计算在有序集合中指定区间分数的成员数                         |
| ZINCRBY key increment member                   | 有序集合中对指定成员的分数加上增量 increment                 |
| ZINTERSTORE destination numkeys key [key ...]  | 计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 destination 中，其中给定 key 的数量必须以 numkeys 参数指定 |
| ZLEXCOUNT key min max                          | 在有序集合中计算指定字典区间内成员数量，详见 [这里](http://www.redis.cn/commands/zlexcount.html) |
| ZRANGE key start stop [WITHSCORES]             | 通过索引区间返回有序集合指定区间内的成员                     |
| ZRANGEBYLEX key min max [LIMIT offset count]   | 通过字典区间返回有序集合的成员                               |
| ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT] | 通过分数返回有序集合指定区间内的成员                         |
| **ZRANK** key member                           | 返回有序集合中指定成员的索引                                 |
| **ZREM** key member [member ...]               | 移除有序集合中的一个或多个成员                               |
| ZREMRANGEBYLEX key min max                     | 移除有序集合中给定的字典区间的所有成员                       |
| ZREMRANGEBYRANK key start stop                 | 移除有序集合中给定的排名区间的所有成员                       |
| ZREMRANGEBYSCORE key min max                   | 移除有序集合中给定的分数区间的所有成员                       |
| ZREVRANGE key start stop [WITHSCORES]          | 返回有序集中指定区间内的成员，通过索引，分数从高到低         |
| ZREVRANGEBYSCORE key max min [WITHSCORES]      | 返回有序集中指定分数区间内的成员，分数从高到低排序           |
| ZREVRANK key member                            | 返回有序集合中指定成员的排名，有序集成员按分数值递减 (从大到小) 排序 |
| **ZSCORE** key member                          | 返回有序集中，成员的分数值                                   |
| ZUNIONSTORE destination numkeys key [key ...]  | 计算给定的一个或多个有序集的并集，并存储在新的 key 中        |
| ZSCAN key cursor [MATCH pattern] [COUNT count] | 迭代有序集合中的元素（包括元素成员和元素分值）               |

### bitmap

Bitmaps 底层存储的是一种二进制格式的数据。在一些特定场景下，用该类型能够**极大的减少存储空间**，因为存储的数据只能是 0 和 1。为了便于理解，可以将这种数据格式理解为一个数组的形式存储。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/202206150046037.png)

#### 基本命令 

##### SETBIT

用来设置或者清除某一位上的值，其返回值是原来位上存储的值。key 在初始状态下所有的位都为 0 ，语法格式如下：

```shell
SETBIT key offset value
```

其中 offset 表示偏移量，从 0 开始。示例如下：

```shell
127.0.0.1:6379> SET user:1 a
OK
# 设置偏移量为0
127.0.0.1:6379> SETBIT user:1 0 1
(integer) 0
# 当对应位的字符是不可打印字符，redis会以16进制形式显示
127.0.0.1:6379> GET user:1
"\xe1"
```

##### GETBIT

用来获取某一位上的值。示例如下：

```shell
127.0.0.1:6379> GETBIT user:1 0
(integer) 1
```

当偏移量 offset 比字符串的长度大，或者当 key 不存在时，返回 0。

```shell
redis> EXISTS bits
(integer) 0
redis> GETBIT bits 100000
(integer) 0
```

##### BITCOUNT

统计指定位区间上，值为 1 的个数。语法格式如下：

```shell
BITCOUNT key [start end]
```

示例如下：

```shell
127.0.0.1:6379> BITCOUNT user:1
(integer) 8
```

> 通过指定的 start 和 end 参数，可以让计数只在特定的字节上进行。

#### 使用场景

bitmap 可以用在一些访问统计、签到统计等场景

**某个用户一个月的签到记录**

```shell
127.0.0.1:6379> setbit user:2020-01 0 1
(integer) 0
127.0.0.1:6379> setbit user:2020-01 1 1
(integer) 0
127.0.0.1:6379> setbit user:2020-01 2 1
(integer) 0
127.0.0.1:6379> bitcount user:2020-01 0 4
(integer) 3
```

统计出该用户这个月只有 3 天签到

**统计某一天网站的签到数量**

```shell
127.0.0.1:6379> setbit site:2020-01-17 1 1
(integer) 0
127.0.0.1:6379> setbit site:2020-01-17 3 1
(integer) 0
127.0.0.1:6379> setbit site:2020-01-17 4 1
(integer) 0
127.0.0.1:6379> setbit site:2020-01-17 6 1
(integer) 0
127.0.0.1:6379> bitcount site:2020-01-17 0 100
(integer) 4
127.0.0.1:6379> getbit site:2020-01-17 5
(integer) 0
```

这里将用户的 id 作为偏移量，签到就是 1。可以统计出具体访问的总数，同时可以根据某个用户的 id 查询是否在当前签到。如果根据偏移量重复设置一个值，此时不会被重复添加，只是 Redis 会返回 1 表示当前已经存在。

**计算某段时间内，都签到的用户数量**

```shell
127.0.0.1:6379> setbit site:2020-01-18 6 1
(integer) 0
127.0.0.1:6379> setbit site:2020-01-18 4 1
(integer) 0
127.0.0.1:6379> setbit site:2020-01-18 7 1
(integer) 0
127.0.0.1:6379> bitop and continue:site site:2020-01-18 site:2020-01-17
(integer) 1
```

使用该场景，是因为该数据类型可以计算出多个 key 的交集 (and)。同时可以取并集 (or)，或 (or)，异或 (xor)

### HyperLogLog

Redis 在 2.8.9 版本添加了 HyperLogLog 结构。

Redis HyperLogLog 是用来做**基数统计**的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定的、并且是很小的。

在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64^ 个不同元素的基 数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。

#### 什么是基数?

比如数据集 `{1, 3, 5, 7, 5, 7, 8}`， 那么这个数据集的基数集为 `{1, 3, 5 ,7, 8}`，基数 (不重复元素) 为 5。 基数估计就是在误差可接受的范围内，快速计算基数。

#### 例

以下实例演示了 HyperLogLog 的工作过程：

```shell
redis 127.0.0.1:6379> PFADD wuhu "redis"

1) (integer) 1

redis 127.0.0.1:6379> PFADD wuhu "mongodb"

1) (integer) 1

redis 127.0.0.1:6379> PFADD wuhu "mysql"

1) (integer) 1

redis 127.0.0.1:6379> PFCOUNT wuhu

(integer) 3
```

#### 基本命令

| 命令                                      | 描述                                      |
| :---------------------------------------- | :---------------------------------------- |
| **PFADD** key element [element ...]       | 添加指定元素到 HyperLogLog 中             |
| **PFCOUNT** key [key ...]                 | 返回给定 HyperLogLog 的基数估算值。       |
| PFMERGE destkey sourcekey [sourcekey ...] | 将多个 HyperLogLog 合并为一个 HyperLogLog |

#### 使用场景

HyperLogLog 一般用在一些不需要精确计算的统计类场景

**用户签到统计**

```shell
127.0.0.1:6379> pfadd 2020:01:sgin  1 2 3 4 5 6 7 8
(integer) 1
# 尝试重复添加
127.0.0.1:6379> pfadd 2020:02:sgin  1 2 3 4 5 6 7 8
(integer) 0
127.0.0.1:6379> pfadd 2020:02:sgin  9
(integer) 1
127.0.0.1:6379> pfadd 2020:02:sgin  10
(integer) 1
127.0.0.1:6379> pfadd 2020:02:sgin  11
(integer) 1
127.0.0.1:6379> pfcount 2020:02:sgin
(integer) 11
```



### 发布订阅

Redis 发布订阅 (pub/sub) 是一种消息通信模式：发送者 (pub) 发送消息，订阅者 (sub) 接收消息。

Redis 客户端可以订阅任意数量的频道。

下图展示了频道 channel1 ， 以及订阅这个频道的三个客户端 —— client2 、 client5 和 client1 之间的关系：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/pubsub1.png)

当有新消息通过 PUBLISH 命令发送给频道 channel1 时， 这个消息就会被发送给订阅它的三个客户端：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/pubsub2.png)

#### 例

以下实例演示了发布订阅是如何工作的，需要开启两个 redis-cli 客户端。

在我们实例中我们创建了订阅频道名为 **wuhuChat**:

```shell
# 第一个 redis-cli 客户端
redis 127.0.0.1:6379> SUBSCRIBE wuhuChat

Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "runoobChat"
3) (integer) 1
```

现在，我们先重新开启个 redis 客户端，然后在同一个频道 wuhuChat 发布两次消息，订阅者就能接收到消息。

```shell
# 第二个 redis-cli 客户端
redis 127.0.0.1:6379> PUBLISH wuhuChat "Redis PUBLISH test"

(integer) 1

redis 127.0.0.1:6379> PUBLISH wuhuChat "Learn redis by runoob.com"

(integer) 1

# 订阅者的客户端会显示如下消息
1) "message"
2) "runoobChat"
3) "Redis PUBLISH test"
1) "message"
2) "runoobChat"
3) "Learn redis by runoob.com"
```

gif 演示如下：

- 开启本地 Redis 服务，开启两个 redis-cli 客户端。
- 在第一个 redis-cli 客户端输入 `SUBSCRIBE runoobChat`，意思是订阅 `runoobChat` 频道。
- 在第二个 redis-cli 客户端输入 `PUBLISH runoobChat "Redis PUBLISH test"` 往 runoobChat 频道发送消息
- 这个时候在第一个 redis-cli 客户端就会看到由第二个 redis-cli 客户端发送的测试消息。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/redis-pub-sub.gif)

#### 基本命令

| 命令                                        | 描述                             |
| :------------------------------------------ | :------------------------------- |
| PSUBSCRIBE pattern [pattern ...]            | 订阅一个或多个符合给定模式的频道 |
| PUBSUB subcommand [argument [argument ...]] | 查看订阅与发布系统状态           |
| **PUBLISH** channel message                 | 将信息发送到指定的频道           |
| PUNSUBSCRIBE [pattern [pattern ...]]        | 退订所有给定模式的频道           |
| **SUBSCRIBE** channel [channel ...]         | 订阅给定的一个或多个频道的信息   |
| UNSUBSCRIBE [channel [channel ...]]         | 指退订给定的频道                 |

### 事务

Redis 事务可以一次执行多个命令， 并且带有以下三个重要的保证：

- 批量操作在发送 EXEC 命令前被放入队列缓存。
- 收到 EXEC 命令后进入事务执行，事务中任意命令执行失败，其余的命令依然被执行。
- 在事务执行过程，其他客户端提交的命令请求不会插入到事务执行命令序列中。

一个事务从开始到执行会经历以下三个阶段：

- 开始事务。
- 命令入队。
- 执行事务。

#### 例

以下是一个事务的例子， 它先以 **MULTI** 开始一个事务， 然后将多个命令入队到事务中， 最后由 **EXEC** 命令触发事务， 一并执行事务中的所有命令：

```shell
redis 127.0.0.1:6379> MULTI
OK

redis 127.0.0.1:6379> SET book-name "Mastering C++ in 21 days"
QUEUED

redis 127.0.0.1:6379> GET book-name
QUEUED

redis 127.0.0.1:6379> SADD tag "C++" "Programming" "Mastering Series"
QUEUED

redis 127.0.0.1:6379> SMEMBERS tag
QUEUED

redis 127.0.0.1:6379> EXEC
1) OK
2) "Mastering C++ in 21 days"
3) (integer) 3
4) 1) "Mastering Series"
   2) "C++"
   3) "Programming"
```

单个 Redis 命令的执行是原子性的，但 Redis 没有在事务上增加任何维持原子性的机制，所以 **Redis 事务的执行并不是原子性的**

事务可以理解为一个**打包的批量执行脚**本，但批量指令并非原子化的操作，中间某条指令的失败不会导致前面已做指令的回滚，也不会造成后续的指令不做。

> *It's important to note that even when a command fails, all the other commands in the queue are processed – Redis will not stop the processing of commands.*

#### 基本命令

| 命令                | 描述                                                         |
| :------------------ | :----------------------------------------------------------- |
| **DISCARD**         | 取消事务，放弃执行事务块内的所有命令                         |
| **EXEC**            | 执行所有事务块内的命令                                       |
| **MULTI**           | 标记一个事务块的开始                                         |
| WATCH key [key ...] | 监视一个 (或多个) key ，如果在事务执行之前这个 (或这些) key 被其他命令所改动，那么事务将被打断 |
| UNWATCH             | 取消 WATCH 命令对所有 key 的监视                             |

### 脚本

Redis 脚本使用 Lua 解释器来执行脚本。 Redis 2.6 版本通过内嵌支持 Lua 环境。执行脚本的常用命令为 **EVAL**。

```shell
redis 127.0.0.1:6379> EVAL script numkeys key [key ...] arg [arg ...]
```

#### 例

```shell
redis 127.0.0.1:6379> EVAL "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 first second

1) "key1"
2) "key2"
3) "first"
4) "second"
```

#### 基本命令

| 命令                                             | 描述                                                         |
| :----------------------------------------------- | :----------------------------------------------------------- |
| EVAL script numkeys key [key ...] arg [arg ...]  | 执行 Lua 脚本                                                |
| EVALSHA sha1 numkeys key [key ...] arg [arg ...] | 根据给定的 sha1 校验码，执行缓存在服务器中的脚本             |
| SCRIPT LOAD script                               | 将脚本 script 添加到脚本缓存中，但并不立即执行这个脚本；返回 sha 值 |
| SCRIPT EXISTS sha1 [sha1 ...]                    | 查看指定的脚本是否已经被保存在缓存当中                       |
| SCRIPT FLUSH                                     | 从脚本缓存中移除所有脚本                                     |
| SCRIPT KILL                                      | 杀死当前正在运行的 Lua 脚本                                  |

**EVAL** 参数说明

参数说明

- **script**： 参数是一段 Lua 5.1 脚本程序。脚本不必(也不应该)定义为一个 Lua 函数。
- **numkeys**： 用于指定键名参数的个数。
- **key [key ...]**： 从 EVAL 的第三个参数开始算起，表示在脚本中所用到的那些 Redis 键(key)，这些键名参数可以在 Lua 中通过全局变量 KEYS 数组，用 1 为基址的形式访问( KEYS[1] ， KEYS[2] ，以此类推)。
- **arg [arg ...]**： 附加参数，在 Lua 中通过全局变量 ARGV 数组访问，访问的形式和 KEYS 变量类似( ARGV[1] 、 ARGV[2] ，诸如此类)。

### 连接

Redis 连接命令主要是用于连接 redis 服务

#### 例

以下实例演示了客户端如何通过密码验证连接到 redis 服务，并检测服务是否在运行

```shell
redis 127.0.0.1:6379> AUTH "password"
OK
redis 127.0.0.1:6379> PING
PONG
```

#### 基本命令

| 命令          | 描述               |
| :------------ | :----------------- |
| AUTH password | 验证密码是否正确   |
| ECHO message  | 打印字符串         |
| PIN           | 查看服务是否运行   |
| QUIT          | 关闭当前连接       |
| SELECT index  | 切换到指定的数据库 |

### 服务器

Redis 服务器命令主要是用于管理 redis 服务

#### 例

以下实例演示了如何获取 redis 服务器的统计信息

```shell
redis 127.0.0.1:6379> INFO

# Server
redis_version:2.8.13
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:c2238b38b1edb0e2
redis_mode:standalone
os:Linux 3.5.0-48-generic x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:4.7.2
process_id:3856
run_id:0e61abd297771de3fe812a3c21027732ac9f41fe
tcp_port:6379
uptime_in_seconds:11554
uptime_in_days:0
hz:10
lru_clock:16651447
config_file:

# Clients
connected_clients:1
client-longest_output_list:0
client-biggest_input_buf:0
blocked_clients:0

# Memory
used_memory:589016
used_memory_human:575.21K
used_memory_rss:2461696
used_memory_peak:667312
used_memory_peak_human:651.67K
used_memory_lua:33792
mem_fragmentation_ratio:4.18
mem_allocator:jemalloc-3.6.0

# Persistence
loading:0
rdb_changes_since_last_save:3
rdb_bgsave_in_progress:0
rdb_last_save_time:1409158561
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok

# Stats
total_connections_received:24
total_commands_processed:294
instantaneous_ops_per_sec:0
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
evicted_keys:0
keyspace_hits:41
keyspace_misses:82
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:264

# Replication
role:master
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:10.49
used_cpu_user:4.96
used_cpu_sys_children:0.00
used_cpu_user_children:0.01

# Keyspace
db0:keys=94,expires=1,avg_ttl=41638810
db1:keys=1,expires=0,avg_ttl=0
db3:keys=1,expires=0,avg_ttl=0
```

#### 基本命令

| 命令                                         | 描述                                                         |
| :------------------------------------------- | :----------------------------------------------------------- |
| BGREWRITEAOF                                 | 异步执行一个 AOF（AppendOnly File） 文件重写操作             |
| BGSAVE                                       | 在后台异步保存当前数据库的数据到磁盘                         |
| CLIENT KILL [ip:port] [ID client-id]         | 关闭客户端连接                                               |
| CLIENT LIST                                  | 获取连接到服务器的客户端连接列表                             |
| CLIENT GETNAME                               | 获取连接的名称                                               |
| CLIENT PAUSE timeout                         | 在指定时间内终止运行来自客户端的命令                         |
| CLIENT SETNAME connection-name               | 设置当前连接的名称                                           |
| CLUSTER SLOTS                                | 获取集群节点的映射数组                                       |
| COMMAND                                      | 获取 Redis 命令详情数组                                      |
| COMMAND COUNT                                | 获取 Redis 命令总数                                          |
| COMMAND GETKEYS                              | 获取给定命令的所有键                                         |
| TIME                                         | 返回当前服务器时间                                           |
| COMMAND INFO command-name [command-name ...] | 获取指定 Redis 命令描述的数组                                |
| CONFIG GET parameter                         | 获取指定配置参数的值                                         |
| CONFIG REWRITE                               | 对启动 Redis 服务器时所指定的 redis.conf 配置文件进行改写    |
| CONFIG SET parameter value                   | 修改 redis 配置参数，无需重启                                |
| CONFIG RESETSTAT                             | 重置 INFO 命令中的某些统计数据                               |
| DBSIZE                                       | 返回当前数据库的 key 的数量                                  |
| DEBUG OBJECT key                             | 获取 key 的调试信息                                          |
| DEBUG SEGFAULT                               | 让 Redis 服务崩溃                                            |
| FLUSHALL                                     | 删除所有数据库的所有key                                      |
| FLUSHDB                                      | 删除当前数据库的所有key                                      |
| INFO [section]                               | 获取 Redis 服务器的各种信息和统计数值                        |
| LASTSAVE                                     | 返回最近一次 Redis 成功将数据保存到磁盘上的时间，以 UNIX 时间戳格式表示 |
| MONITOR                                      | 实时打印出 Redis 服务器接收到的命令，调试用                  |
| ROLE                                         | 返回主从实例所属的角色                                       |
| SAVE                                         | 同步保存数据到磁盘                                           |
| SHUTDOWN [NOSAVE] [SAVE]                     | 异步保存数据到硬盘，并关闭服务器                             |
| **SLAVEOF** host port                        | 将当前服务器转变为指定服务器的从属服务器(slave server)       |
| SLOWLOG subcommand [argument]                | 管理 redis 的慢日志                                          |
| SYNC                                         | 用于复制功能 (replication) 的内部命令                        |

### GEO

Redis GEO 主要用于存储**地理位置信息**，并对存储的信息进行操作，该功能在 Redis 3.2 版本新增。

Redis GEO 操作方法有：

- geoadd：添加地理位置的坐标。
- geopos：获取地理位置的坐标。
- geodist：计算两个位置之间的距离。
- georadius：根据用户给定的经纬度坐标来获取指定范围内的地理位置集合。
- georadiusbymember：根据储存在位置集合里面的某个地点获取指定范围内的地理位置集合。
- geohash：返回一个或多个位置对象的 geohash 值。

#### geoadd

geoadd 用于存储指定的地理空间位置，可以将一个或多个经度 (longitude)、纬度 (latitude)、位置名称 (member) 添加到指定的 key 中

```shell
GEOADD key longitude latitude member [longitude latitude member ...]
```

例

```shell
redis> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
redis> GEODIST Sicily Palermo Catania
"166274.1516"
redis> GEORADIUS Sicily 15 37 100 km
1) "Catania"
redis> GEORADIUS Sicily 15 37 200 km
1) "Palermo"
2) "Catania"
redis>
```

#### geopos

geopos 用于从给定的 key 里返回所有指定名称 (member) 的位置（经度和纬度），不存在的返回 nil。

```shell
GEOPOS key member [member ...]
```

例

```shell
redis> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
redis> GEOPOS Sicily Palermo Catania NonExisting
1) 1) "13.36138933897018433"
   2) "38.11555639549629859"
2) 1) "15.08726745843887329"
   2) "37.50266842333162032"
3) (nil)
redis>
```

#### geodist

geodist 用于返回 key 中两个给定位置之间的距离

```shell
GEODIST key member1 member2 [m|km|ft|mi]
```

member1 member2 为两个地理位置。

最后一个距离单位参数说明：

- m ：米，默认单位。
- km ：千米。
- mi ：英里。
- ft ：英尺。

例

```shell
redis> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
redis> GEODIST Sicily Palermo Catania
"166274.1516"
redis> GEODIST Sicily Palermo Catania km
"166.2742"
redis> GEODIST Sicily Palermo Catania mi
"103.3182"
redis> GEODIST Sicily Foo Bar
(nil)
redis>
```

#### georadius、georadiusbymember

`georadius` 以给定的经纬度为中心， 返回键包含的位置元素当中， 与中心的距离不超过给定最大距离的所有位置元素。

`georadiusbymember` 和 GEORADIUS 命令一样， 都可以找出位于指定范围内的元素， 但是 `georadiusbymember` 的中心点是由给定的位置元素决定的， 而不是使用经度和纬度来决定中心点。

```shell
GEORADIUS key longitude latitude radius m|km|ft|mi [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count] [ASC|DESC] [STORE key] [STOREDIST key]
```

```shell
GEORADIUSBYMEMBER key member radius m|km|ft|mi [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count] [ASC|DESC] [STORE key] [STOREDIST key]
```

参数说明：

- m ：米，默认单位。
- km ：千米。
- mi ：英里。
- ft ：英尺。
- WITHDIST: 在返回位置元素的同时， 将位置元素与中心之间的距离也一并返回。
- WITHCOORD: 将位置元素的经度和纬度也一并返回。
- WITHHASH: 以 52 位有符号整数的形式， 返回位置元素经过原始 geohash 编码的有序集合分值。 这个选项主要用于底层应用或者调试， 实际中的作用并不大。
- COUNT 限定返回的记录数。
- ASC: 查找结果根据距离从近到远排序。
- DESC: 查找结果根据从远到近排序。

`georadius` 实例

```shell
redis> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
redis> GEORADIUS Sicily 15 37 200 km WITHDIST
1) 1) "Palermo"
   2) "190.4424"
2) 1) "Catania"
   2) "56.4413"
redis> GEORADIUS Sicily 15 37 200 km WITHCOORD
1) 1) "Palermo"
   2) 1) "13.36138933897018433"
      2) "38.11555639549629859"
2) 1) "Catania"
   2) 1) "15.08726745843887329"
      2) "37.50266842333162032"
redis> GEORADIUS Sicily 15 37 200 km WITHDIST WITHCOORD
1) 1) "Palermo"
   2) "190.4424"
   3) 1) "13.36138933897018433"
      2) "38.11555639549629859"
2) 1) "Catania"
   2) "56.4413"
   3) 1) "15.08726745843887329"
      2) "37.50266842333162032"
redis>
```

`georadiusbymember` 实例

```shell
redis> GEOADD Sicily 13.583333 37.316667 "Agrigento"
(integer) 1
redis> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
redis> GEORADIUSBYMEMBER Sicily Agrigento 100 km
1) "Agrigento"
2) "Palermo"
redis>
```

#### geohash

Redis GEO 使用 geohash 来保存地理位置的坐标。

geohash 用于获取一个或多个位置元素的 geohash 值。

```shell
GEOHASH key member [member ...]
```

例

```shell
redis> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
redis> GEOHASH Sicily Palermo Catania
1) "sqc8b49rny0"
2) "sqdtr74hyu0"
redis>
```

### Stream

Redis Stream 是 Redis 5.0 版本新增加的数据结构。

Redis Stream 主要用于**消息队列**（MQ，Message Queue），Redis 本身是有一个 Redis 发布订阅 (pub/sub) 来实现消息队列的功能，但它有个缺点就是消息无法持久化（无法记录历史消息），如果出现网络断开、Redis 宕机等，消息就会被丢弃。

而 Redis Stream 提供了消息的**持久化**和**主备复制**功能，可以让任何客户端访问任何时刻的数据，并且能记住每一个客户端的访问位置，还能保证消息不丢失。

Redis Stream 的结构如下所示，它有一个消息链表，将所有加入的消息都串起来，每个消息都有一个唯一的 ID 和对应的内容：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/202206051520866.png)

每个 Stream 都有唯一的名称，它就是 Redis 的 key，在我们首次使用 xadd 指令追加消息时自动创建。

上图解析：

- **Consumer Group** ：消费组，使用 XGROUP CREATE 命令创建，一个消费组有多个消费者 (Consumer)
- **last_delivered_id** ：游标，每个消费组会有个游标 last_delivered_id，其中任意一个消费者读取了消息都会使游标 last_delivered_id 往前移动
  - 组内消费者之间存在**竞争关系**。当某个消费者消费了一条消息时，同组消费者，都不会再次消费这条消息。

- **pending_ids** ：消费者 (Consumer) 的状态变量，作用是维护消费者的未确认的 id
  - pending_ids 记录了当前已经被客户端读取的消息，但是还没有 ack（Acknowledge character：确认字符）
  - 每一个消费者消费之后，严格需要 ack 进行确认，该消息才会被标识为真正消费。否则 `Pending_ids[]` 将记录未进行 ack 的消息


**消息队列相关命令：**

- **XADD** - 添加消息到末尾
- **XTRIM** - 对流进行修剪，限制长度
- **XDEL** - 删除消息
- **XLEN** - 获取流包含的元素数量，即消息长度
- **XRANGE** - 获取消息列表，会自动过滤已经删除的消息
- **XREVRANGE** - 反向获取消息列表，ID 从大到小
- **XREAD** - 以阻塞或非阻塞方式获取消息列表

**消费者组相关命令：**

- **XGROUP CREATE** - 创建消费者组
- **XREADGROUP GROUP** - 读取消费者组中的消息
- **XACK** - 将消息标记为"已处理"
- **XGROUP SETID** - 为消费者组设置新的最后递送消息 ID
- **XGROUP DELCONSUMER** - 删除消费者
- **XGROUP DESTROY** - 删除消费者组
- **XPENDING** - 显示待处理消息的相关信息
- **XCLAIM** - 转移消息的归属权
- **XINFO** - 查看流和消费者组的相关信息；
- **XINFO GROUPS** - 打印消费者组的信息；
- **XINFO STREAM** - 打印流信息

#### XADD

使用 XADD 向队列添加消息，如果指定的队列不存在，则创建一个队列

```shell
XADD key ID field value [field value ...]
```

- key ：队列名称，如果不存在就创建
- ID ：消息 id，我们使用 * 表示由 redis 生成，可以自定义，但是要自己保证递增性。
- field value ： 记录。

例

```shell
redis> XADD mystream * name Sara surname OConnor
"1601372323627-0"
redis> XADD mystream * field1 value1 field2 value2 field3 value3
"1601372323627-1"
redis> XLEN mystream
(integer) 2
redis> XRANGE mystream - +
1) 1) "1601372323627-0"
   2) 1) "name"
      2) "Sara"
      3) "surname"
      4) "OConnor"
2) 1) "1601372323627-1"
   2) 1) "field1"
      2) "value1"
      3) "field2"
      4) "value2"
      5) "field3"
      6) "value3"
redis>
```

#### XTRIM

使用 XTRIM 对流进行修剪，限制长度

```shell
XTRIM key MAXLEN [~] count
```

- **key** ：队列名称
- **MAXLEN** ：长度
- **count** ：数量
- `~` 使裁剪更高效

例

```shell
127.0.0.1:6379> XADD mystream * field1 A field2 B field3 C field4 D
"1601372434568-0"
127.0.0.1:6379> XTRIM mystream MAXLEN 2
(integer) 0
127.0.0.1:6379> XRANGE mystream - +
1) 1) "1601372434568-0"
   2) 1) "field1"
      2) "A"
      3) "field2"
      4) "B"
      5) "field3"
      6) "C"
      7) "field4"
      8) "D"
127.0.0.1:6379>

redis>
```

#### XDEL

使用 XDEL 删除消息

```shell
XDEL key ID [ID ...]
```

- **key**：队列名称
- **ID** ：消息 ID

例

```shell
> XADD mystream * a 1
1538561698944-0
> XADD mystream * b 2
1538561700640-0
> XADD mystream * c 3
1538561701744-0
> XDEL mystream 1538561700640-0
(integer) 1
127.0.0.1:6379> XRANGE mystream - +
1) 1) 1538561698944-0
   2) 1) "a"
      2) "1"
2) 1) 1538561701744-0
   2) 1) "c"
      2) "3"
```

#### XLEN

使用 XLEN 获取流包含的元素数量，即消息长度

```shell
XLEN key
```

- **key**：队列名称

例

```shell
redis> XADD mystream * item 1
"1601372563177-0"
redis> XADD mystream * item 2
"1601372563178-0"
redis> XADD mystream * item 3
"1601372563178-1"
redis> XLEN mystream
(integer) 3
redis>
```

#### XRANGE

使用 XRANGE 反向获取消息列表，会自动过滤已经删除的消息

```shell
XRANGE key start end [COUNT count]
```

- **key** ：队列名
- **start** ：开始值， **-** 表示最小值
- **end** ：结束值， **+** 表示最大值
- **count** ：数量

例

```shell
redis> XADD writers * name Virginia surname Woolf
"1601372577811-0"
redis> XADD writers * name Jane surname Austen
"1601372577811-1"
redis> XADD writers * name Toni surname Morrison
"1601372577811-2"
redis> XADD writers * name Agatha surname Christie
"1601372577812-0"
redis> XADD writers * name Ngozi surname Adichie
"1601372577812-1"
redis> XLEN writers
(integer) 5
redis> XRANGE writers - + COUNT 2
1) 1) "1601372577811-0"
   2) 1) "name"
      2) "Virginia"
      3) "surname"
      4) "Woolf"
2) 1) "1601372577811-1"
   2) 1) "name"
      2) "Jane"
      3) "surname"
      4) "Austen"
redis>
```

#### XREVRANGE

使用 XREVRANGE 获取消息列表，会自动过滤已经删除的消息

```shell
XREVRANGE key end start [COUNT count]
```

- **key** ：队列名
- **end** ：结束值， **+** 表示最大值
- **start** ：开始值， **-** 表示最小值
- **count** ：数量

例

```shell
redis> XADD writers * name Virginia surname Woolf
"1601372731458-0"
redis> XADD writers * name Jane surname Austen
"1601372731459-0"
redis> XADD writers * name Toni surname Morrison
"1601372731459-1"
redis> XADD writers * name Agatha surname Christie
"1601372731459-2"
redis> XADD writers * name Ngozi surname Adichie
"1601372731459-3"
redis> XLEN writers
(integer) 5
redis> XREVRANGE writers + - COUNT 1
1) 1) "1601372731459-3"
   2) 1) "name"
      2) "Ngozi"
      3) "surname"
      4) "Adichie"
redis>
```

#### XREAD

使用 XREAD 以阻塞或非阻塞方式获取消息列表

```shell
XREAD [COUNT count] [BLOCK milliseconds] STREAMS key [key ...] id [id ...]
```

- **count** ：数量
- **milliseconds** ：可选，阻塞毫秒数，没有设置就是非阻塞模式
- **key** ：队列名
- **id** ：消息 ID，仅返回 ID 大于调用者报告的最后接收 ID 的条目，可设置为 0-0

```shell
# 从 Stream 头部读取两条消息
> XREAD COUNT 2 STREAMS mystream writers 0-0 0-0
1) 1) "mystream"
   2) 1) 1) 1526984818136-0
         2) 1) "duration"
            2) "1532"
            3) "event-id"
            4) "5"
            5) "user-id"
            6) "7782813"
      2) 1) 1526999352406-0
         2) 1) "duration"
            2) "812"
            3) "event-id"
            4) "9"
            5) "user-id"
            6) "388234"
2) 1) "writers"
   2) 1) 1) 1526985676425-0
         2) 1) "name"
            2) "Virginia"
            3) "surname"
            4) "Woolf"
      2) 1) 1526985685298-0
         2) 1) "name"
            2) "Jane"
            3) "surname"
            4) "Austen"
```

#### XGROUP CREATE

使用 XGROUP CREATE 创建消费者组

```shell
xgroup create 队列名称 消费者组 消息ID开始位置-消息ID结束位置
```

```shell
XGROUP [CREATE key groupname id-or-$] [SETID key groupname id-or-$] [DESTROY key groupname] [DELCONSUMER key groupname consumername]
```

- **key** ：队列名称，如果不存在就创建
- **groupname** ：组名。
- **$** ： 表示从尾部开始消费，只接受新消息，当前 Stream 消息会全部忽略。

从头开始消费:

```shell
XGROUP CREATE mystream consumer-group-name 0-0
```

从尾部开始消费:

```shell
XGROUP CREATE mystream consumer-group-name $
```

#### XINFO GROUPS

查看消费者群组

```shell
xinfo groups key
```

key 为队列名称

#### XREADGROUP GROUP

使用 XREADGROUP GROUP 读取消费者组中的消息

```shell
xreadgroup group 消费者群组名 消费者名称 count 消费个数 streams 队列名称 消息消费ID
```

```shell
XREADGROUP GROUP group consumer [COUNT count] [BLOCK milliseconds] [NOACK] STREAMS key [key ...] ID [ID ...]
```

- **group** ：消费组名
- **consumer** ：消费者名
- **count** ： 读取数量
- **milliseconds** ： 阻塞毫秒数
- **key** ： 队列名
- **ID** ： 消息 ID
  - `>` 意味着消费者希望只接收从未发送给任何其他消费者的消息。这意思是说，请给我新的消息


例

```shell
XREADGROUP GROUP consumer-group-name consumer-name COUNT 1 STREAMS mystream >
```

### 数据备份与恢复

#### 备份

Redis **SAVE** 命令用于创建当前数据库的备份

```shell
redis 127.0.0.1:6379> SAVE
OK
```

该命令将在 redis 安装目录中创建 dump.rdb 文件

创建 redis 备份文件也可以使用命令 **BGSAVE**，该命令在后台执行

```shell
127.0.0.1:6379> BGSAVE

Background saving started
```

#### 恢复

如果需要恢复数据，只需将备份文件 (dump.rdb) 移动到 redis 安装目录并启动服务即可。获取 redis 目录可以使用 **CONFIG** 命令，如下所示：

```shell
redis 127.0.0.1:6379> CONFIG GET dir
1) "dir"
2) "/usr/local/redis/bin"
```

以上命令 **CONFIG GET dir** 输出的 redis 安装目录为 /usr/local/redis/bin

### 性能测试

Redis 性能测试是通过同时执行多个命令实现的

```shell
redis-benchmark [option] [option value]
```

该命令是**在 redis 的目录下执行**的，而不是 redis 客户端的内部指令

例：以下实例同时执行 10000 个请求来检测性能

```shell
$ redis-benchmark -n 10000  -q

PING_INLINE: 141043.72 requests per second
PING_BULK: 142857.14 requests per second
SET: 141442.72 requests per second
GET: 145348.83 requests per second
INCR: 137362.64 requests per second
LPUSH: 145348.83 requests per second
LPOP: 146198.83 requests per second
SADD: 146198.83 requests per second
SPOP: 149253.73 requests per second
LPUSH (needed to benchmark LRANGE): 148588.42 requests per second
LRANGE_100 (first 100 elements): 58411.21 requests per second
LRANGE_300 (first 300 elements): 21195.42 requests per second
LRANGE_500 (first 450 elements): 14539.11 requests per second
LRANGE_600 (first 600 elements): 10504.20 requests per second
MSET (10 keys): 93283.58 requests per second
```

redis 性能测试工具可选参数如下所示：

| 序号 | 选项                      | 描述                                       | 默认值    |
| :--- | :------------------------ | :----------------------------------------- | :-------- |
| 1    | **-h**                    | 指定服务器主机名                           | 127.0.0.1 |
| 2    | **-p**                    | 指定服务器端口                             | 6379      |
| 3    | **-s**                    | 指定服务器 socket                          |           |
| 4    | **-c**                    | 指定并发连接数                             | 50        |
| 5    | **-n**                    | 指定请求数                                 | 10000     |
| 6    | **-d**                    | 以字节的形式指定 SET/GET 值的数据大小      | 2         |
| 7    | **-k**                    | 1=keep alive 0=reconnect                   | 1         |
| 8    | **-r**                    | SET/GET/INCR 使用随机 key, SADD 使用随机值 |           |
| 9    | **-P**                    | 通过管道传输 <numreq> 请求                 | 1         |
| 10   | **-q**                    | 强制退出 redis。仅显示 query/sec 值        |           |
| 11   | **--csv**                 | 以 CSV 格式输出                            |           |
| 12   | ***-l\*（L 的小写字母）** | 生成循环，永久执行测试                     |           |
| 13   | **-t**                    | 仅运行以逗号分隔的测试命令列表。           |           |
| 14   | ***-I\*（i 的大写字母）** | Idle 模式。仅打开 N 个 idle 连接并等待。   |           |

例

```shell
$ redis-benchmark -h 127.0.0.1 -p 6379 -t set,lpush -n 10000 -q

SET: 146198.83 requests per second
LPUSH: 145560.41 requests per second
```

以上实例中主机为 127.0.0.1，端口号为 6379，执行的命令为 set,lpush，请求数为 10000，通过 -q 参数让结果只显示每秒执行的请求数

## 进阶

### 安全

我们可以通过 redis 的配置文件设置密码参数，这样客户端连接到 redis 服务就需要密码验证，让你的 redis 服务更安全

我们可以通过以下命令查看是否设置了密码验证：

```shell
127.0.0.1:6379> CONFIG get requirepass
1) "requirepass"
2) ""
```

默认情况下 requirepass 参数是空的，这就意味着你无需通过密码验证就可以连接到 redis 服务。

你可以通过以下命令来修改该参数：

```shell
127.0.0.1:6379> CONFIG set requirepass "psswd123"
OK
127.0.0.1:6379> CONFIG get requirepass
1) "requirepass"
2) "psswd123"
```

设置密码后，客户端连接 redis 服务就需要密码验证，否则无法执行命令。

### 客户端连接

Redis 通过监听一个 TCP 端口或者 Unix socket 的方式来接收来自客户端的连接，当一个连接建立后，Redis 内部会进行以下一些操作：

- 首先，客户端 socket 会被设置为非阻塞模式，因为 Redis 在网络事件处理上采用的是非阻塞多路复用模型。
- 然后为这个 socket 设置 TCP_NODELAY 属性，禁用 Nagle 算法
- 然后创建一个可读的文件事件用于监听这个客户端 socket 的数据发送

#### 最大连接数

在 Redis2.4 中，最大连接数是被直接硬编码在代码里面的，而在 2.6 版本中这个值变成可配置的。

maxclients 的默认值是 10000，你也可以在 redis.conf 中对这个值进行修改。

```shell
config get maxclients

1) "maxclients"
2) "10000"
```

我们可以在服务启动时设置最大连接数为 100000：

```
redis-server --maxclients 100000
```

### 管道技术

Redis 是一种基于客户端-服务端模型以及请求/响应协议的 TCP 服务。这意味着通常情况下一个请求会遵循以下步骤：

- 客户端向服务端发送一个查询请求，并监听 Socket 返回，通常是以阻塞模式，等待服务端响应。
- 服务端处理命令，并将结果返回给客户端。

**Redis 管道技术可以在服务端未响应时，客户端可以继续向服务端发送请求，并最终一次性读取所有服务端的响应。**提高了服务端性能。

### Redis 分区

分区是分割数据到多个 Redis 实例的处理过程，因此每个实例只保存 key 的一个子集。

#### 分区的特点

##### 优势

- 通过利用多台计算机内存的和值，允许我们构造更大的数据库。
- 通过多核和多台计算机，允许我们扩展计算能力；通过多台计算机和网络适配器，允许我们扩展网络带宽。

##### 不足

redis 的一些特性在分区方面表现的不是很好：

- 涉及多个 key 的操作通常是不被支持的。举例来说，当两个 set 在不同的 redis 实例上时，你就不能对这两个 set 执行交集操作。
- 涉及多个 key 的 redis 事务不能使用。
- 当使用分区时，数据处理较为复杂，比如你需要处理多个 rdb/aof 文件，并且从多个实例和主机备份持久化文件。
- 增加或删除容量也比较复杂。redis 集群大多数支持在运行时增加、删除节点的透明数据平衡的能力，但是类似于客户端分区、代理等其他系统则不支持这项特性。然而，一种叫做 presharding 的技术对此是有帮助的。

#### 分区类型

Redis 有两种类型分区。 假设有 4 个 Redis 实例 R0，R1，R2，R3，和类似 user:1，user:2 这样的表示用户的多个 key，对既定的 key 有多种不同方式来选择这个 key 存放在哪个实例中。也就是说，有不同的系统来分配某个 key 到某个 Redis 服务。

##### 范围分区

最简单的分区方式是按范围分区，就是映射一定范围的对象到特定的 Redis 实例。

比如，ID 从 0 到 10000 的用户会保存到实例 R0，ID 从 10001 到 20000 的用户会保存到 R1，以此类推。

这种方式是可行的，并且在实际中使用，不足就是要有一个区间范围到实例的映射表。这个表要被管理，同时还需要各 种对象的映射表，通常对 Redis 来说并非是好的方法。

##### 哈希分区

另外一种分区方法是 hash 分区。这对任何 key 都适用，也无需是 object_name:这种形式，像下面描述的一样简单：

- 用一个 hash 函数将 key 转换为一个数字，比如使用 crc32 hash 函数。对 key foobar 执行 crc32(foobar)会输出类似 93024922 的整数。
- 对这个整数取模，将其转化为 0-3 之间的数字，就可以将这个整数映射到 4 个 Redis 实例中的一个了。93024922 % 4 = 2，就是说 key foobar 应该被存到 R2 实例中。注意：取模操作是取除的余数，通常在多种编程语言中用%操作符实现。

## 持久化

### 为什么要做持久化存储

我们都知道 Redis 是一个基于内存的 nosql 数据库，内存存储很容易造成数据的丢失，因为当服务器关机等一些异常情况都会导致存储在内存中的数据丢失。

1. 持久化存储就是**将 Redis 存储在内存中的数据存储在硬盘中，实现数据的永久保存**（主要原因）
2. 数据的传输、拷贝（作用）
3. 开发、测试（作用）

在 Redis 中，持久化存储分为两种。一种是 aof 日志追加的方式，另外一种是 rdb 数据快照的方式

### RDB 持久化存储

RDB 持久化存储即是将 redis 存在内存中的数据以**快照的形式**保存在本地磁盘中。

#### 配置

```ini
# 设置 dump 的文件名
dbfilename dump.rdb

# 工作目录
# 例如上面的 dbfilename 只指定了文件名，
# 但是它会写入到这个目录下。这个配置项一定是个目录，而不能是文件名。
dir ./

# bgsave 持久化出现问题，Redis 是否停止写入命令
stop-writes-on-bgsave-error yes

# 是否开启文件压缩
rdbcompression yes

# 保存或者加载 rdb 文件时是否对进行校验
rdbchecksum yes

# 持久化频率
# save <seconds> <changes> 表示在 seconds 秒内，至少有 changes 次变化，就会自动触发 gbsave 命令
save 900 1
save 300 10
save 60 10000
```

#### 分类

RDB 持久化存储分为自动备份和手动备份

**1. 手动备份**

通过 save 命令和 bgsave 命令。

save 是同步阻塞，而 bgsave 是非阻塞（阻塞实际发生在 fork 的子进程中）

在我们实际过程中大多是使用 bgsave 命令实现备份。

```php
// 阻塞直到命令处理完毕响应OK
redis> save
OKCopy to clipboardErrorCopied
// fork 一个独立线程实现持久化
redis> bgsave
Background saving startedCopy to clipboardErrorCopied
```

save 与 bgsave 不同场景的使用

1. 当 Redis 从服务器项主服务器发送复制请求时，主服务器则会使用 bgsave 命令生成 rbd 文件，然后传输给从服务器。
2. 当执行 debug reload 命令时也会使用 save 命令生成 rdb 文件。
3. 当使用 shutdown 命令关掉服务时，如果没有启用 aof 方式实现持久化则会采用 bgsave 的方式做持久化。同时 shutdown 后面可以加备份参数 [nosave|save]。

**2. 自动备份**

修改配置项 `save m n`，即表示在 m 秒内执行了 n 次命令则进行备份。

实则是通过 bgsave 处理

#### bgsave 实现原理

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/16d1a887a8ba96ea~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)

![](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/19104827_6197107b8370442287.png)

1. 执行 bgsave 命令，Redis 父进程判断当前是否存在正在执行的子进程，如果存在则直接返回。

2. 父进程 fork 一个子进程（fork 的过程中会造成阻塞的情况），这个过程可以使用 `info stats` 命令查看 `latest_fork_usec` 选项，查看最近一次 fork 操作消耗的时间，单位是微秒

3. 父进程 fork 完之后，则会返回 Background saving started 信息提示，此时 fork 阻塞解除。

4. fork 出的子进程开始根据父进程内存数据生成临时的快照文件，然后进行原子操作替换原文件。使用 lastsave 命令可以查看最后一次生成 rdb 的时间，对应 info 的 `rdb_last_save_time` 选项。
5. 当备份完毕之后向父进程发送完成信息，此时父进程会更新最新的持久化统计信息。具体可以见 `info persistence` 下的 rbd 选项。

#### RDB 持久化的优势与劣势

##### 优势

1. 全量备份，便于数据的传输。
2. 压缩的二进制文件，重启服务加载快

##### 劣势

1. 加密的二进制格式存储文件，由于 Redis 各个版本之间的兼容性问题
2. **实时性差**，并不是完全的实时同步，容易造成数据的不完整性。
3. 加密处理，可读性差，无法直接读取 / 修改文件内容

#### 常见的问题

1. 当遇到磁盘写满情况，可以使用如下命令来切换存储磁盘

   ```php
   // dirName 则是新的存储目录名(该方式同样适用于aof格式)
   config set dir <dirName>
   ```

2. 文件压缩处理，虽然对 CPU 具有消耗，但是减少体积的暂用，同时做文件传输（主从复制）也减少消耗

   ```php
   // 修改压缩开启或关闭
   config set rdbcompression yes|no
   ```

3. rbd 备份文件损坏检测，可以使用 redis-check-rdb 工具检测 rdb 文件；该工具默认在 `/usr/local/bin/` 目录下面.

   ```php
   [root@syncd redis-data] # /usr/local/bin/redis-check-rdb ./6379-rdb.rdb
   [offset 0] Checking RDB file ./6379-rdb.rdb
   [offset 26] AUX FIELD redis-ver = '5.0.3'
   [offset 40] AUX FIELD redis-bits = '64'
   [offset 52] AUX FIELD ctime = '1552061947'
   [offset 67] AUX FIELD used-mem = '852984'
   [offset 83] AUX FIELD aof-preamble = '0'
   [offset 85] Selecting DB ID 0
   [offset 105] Checksum OK
   [offset 105] \o/ RDB looks OK! \o/
   [info] 1 keys read
   [info] 0 expires
   [info] 0 already expired
   ```

### AOF 持久化存储

1. 由于 RDB 持久化方式不能做到实时存储，而 AOF 可以更具不同的策略实现实时持久化。
2. AOF 持久化存储便是**以日志的形式将 aof_buf 缓冲区中的命令写入到磁盘中**。简而言之，就是记录 redis 的操作日志，将 redis 执行过的命令记录下来。
3. 当我们需要数据恢复时或者重启 Redis 服务时，Redis 再去重新执行一次日志文件中的命令，以达到数据重载的目的。

#### 配置

```php
# appendonly参数开启AOF持久化
appendonly no

# AOF持久化的文件名，默认是appendonly.aof，存储的目录便是 dir 配置项
appendfilename "appendonly.aof"

# AOF文件的保存位置和RDB文件的位置相同，都是通过dir参数设置的
dir ./

# 同步策略 (三者只需要开启以一个即可)
# appendfsync always  // 命令写入立即写入磁盘
appendfsync everysec  // 每秒实现文件的同步，写入磁盘
# appendfsync no	  // 随机进行文件的同步，同步操作则交给操作系统来负责，通常时间是最长 30s

# aof重写期间是否同步
no-appendfsync-on-rewrite no

# 重写触发配置
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# 加载aof出错如何处理
aof-load-truncated yes

# 文件重写策略
aof-rewrite-incremental-fsync yes
```

> 当命令写入到 AOF 缓冲区后，Redis 会根据持久化存储策略，单独开一个 AOF 线程来实现写入到磁盘操作。

#### 实现原理

aof 日志追加方式实现持久化存储，需要经历如下四个过程：命令写入 -> 文件同步 -> 文件重写 -> 文件重载。

![](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/1618152161472-3.png)

1. 命令追加（**append**），此时会将 redis 命令写入 aof_buf 缓冲区.。
2. 文件写入（**write**），缓冲区中数据根据备份策略实现写入日志文件。
3. 文件重写（**rewrite**），当 aof 的文件越来越庞大，会根据我们的配置策略来实现 aof 的重写，实现文件的压缩，减少体积。
4. 当 redis 重新启动时，在去重写加载 aof 文件，达到数据恢复的目的。

#### 文件写入策略

文件写入是将 aof_buf 缓冲区的命令写入到文件中。文件写入的策略有如下三种方式：

| 配置项   | 配置说明                                                     |
| -------- | ------------------------------------------------------------ |
| always   | 命令写入到 aof_buf 缓冲区中之后立即调用系统的 `fsync` 操作同步到 aof 文件中，fsync 完成后线程返回. |
| everysec | 命令写入到 aof_buf 缓冲区后每隔一秒调用系统的 `write` 操作，`write` 完成后线程返回. |
| no       | 命令写入 aof_bug 缓冲区后调用系统 `write` 操作，不对 aof 文件做 `fsync` 同步，同步硬盘操作由系统操作完成，时间一般最长为 30s. |

##### 系统调用 write 和 fsync 说明

1. write 操作会触发延迟写（delayed write）机制。
   - Linux 在内核提供页缓冲区用来提高硬盘 IO 性能。write 操作在写入系统缓冲区后直接返回。同步硬盘操作依赖于系统调度机制，例如：缓冲区页空间写满或达到特定时间周期。同步文件之前，如果此时系统故障宕机，缓冲区内数据将丢失
2. fsync 针对单个文件操作（比如 AOF 文件），做**强制硬盘同步**
   - fsync 将阻塞直到写入硬盘完成后返回，保证了数据持久化

##### 文件写入策略分析

- 配置为 always 时， 每次写入都要同步 AOF 文件， 在一般的 SATA 硬盘上， Redis 只能支持大约几百 TPS 写入， 显然跟 Redis 高性能特性背道而驰，不建议配置。

- 配置为 no。由于操作系统每次同步 AOF 文件的周期不可控， 而且会加大每次同步硬盘的数据量， 虽然提升了性能， 但数据安全性无法保证。

- 配置为 everysec。是建议的同步策略， 也是默认配置， 做到兼顾性能和数据安全性。 理论上只有在系统突然宕机的情况下丢失 1 秒的数据。

#### 文件重写

在了解 AOF 重写之前，我们先来看看 AOF 文件中存储的内容是啥，先执行两个写操作：

```
127.0.0.1:6379> set s1 hello
OK
127.0.0.1:6379> set s2 world
OK
```

然后我们打开`appendonly.aof`文件，可以看到如下内容：

```shell
*3
$3
set
$2
s1
$5
hello
*3
$3
set
$2
s2
$5
world
```

> 该命令格式为Redis的序列化协议（RESP）。`*3`代表这个命令有三个参数，`$3`表示该参数长度为3

随着时间的推移，Redis 执行的写命令会越来越多，AOF 文件也会越来越大，过大的 AOF 文件可能会对 Redis 服务器造成影响，如果使用 AOF 文件来进行数据还原所需时间也会越长。

时间长了，AOF 文件中通常会有一些冗余命令，比如：过期数据的命令、无效的命令（重复设置、删除）、多个命令可合并为一个命令（批处理命令）。所以 AOF 文件是有精简压缩的空间的。

**AOF 重写的目的就是减小 AOF 文件的体积**

aof 文件重写是把 redis 进程内的数据转换为写命令同步到新的 aof 文件的过程。

##### 文件重载主要优化的地方

1. **减少无效数据**。将一些在进程内无效的数据不在写入新的文件。如过期的键
2. **去掉一些无效的命令**。如 `del key1`
3. **简化操作**。如 `lpush list a`，`lpush list b`，直接可以简化为 `lpush list a b`

##### 文件重载触发机制

1. **手动触发机制**。 

   - 直接使用 bgrewriteaof 命令即可。该命令在 fork 子进程的时候会发生阻塞。

2. **自动触发机制**

   - ```shell
     # 表示当 AOF 文件的体积大于 64MB，且 AOF 文件的体积比上一次重写后的体积大了一倍（100%）时，会执行 bgrewriteaof 命令
     auto-aof-rewrite-percentage 100
     auto-aof-rewrite-min-size 64mb
     ```

   - 其中 aof_current_size 和 aof_base_size 可以在 `info Persistence` 统计信息中查看。

##### 重写步骤

![1618152177852-4](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/1618152177852-4.png) 

1. 执行重写命令，判断是否存在子进程。 

   - 如果已经有子进程在进行 aof 重写，则会提示如下信息。

       ```php
       ERR Background append only file rewriting already in progress
       ```

   - 如果已经存在子进程在进行 bgsave 操作，重写命令会延迟到 bgsave 命令完成之后进行，会返回如下信息。

       ```php
       Background append only file rewriting scheduled
       ```

2. 父进程会 fork 一个子进程，在 fork 子进程的过程中会造成阻塞。

3. fork 子进程结束后，父进程阻塞解除，进行其他新的命令操作；新的命令依旧根据文件写入策略同步数据，保证 aof 机制正确进行

4. 子进程在进行写的过程中，由于 fork 操作运用的是**写时复制**技术，子进程只能共享 fork 操作时内存保留的数据，新的数据是无法操作的。父进程在这过程中仍然在响应其他的命令，于是 Redis 会使用 **aof-rewrite-buffer** 来保存这部分新的数据。

5. 子进程进行根据重写规则将数据写入到新的 aof 文件中

   - 每次写入有大小限制，通过 `aof-rewrite-incremental-fsync` 配置项来控制，默认是 32M，这样可以见减少单次刷盘（I/O 写）造成硬盘阻塞。

6. 子进程在完成重写之后，会向父进程发送信息，父进程更新统计信息

   - 可参看 `info persistence` 下的 aof_*相关统计。

7. 父进程会把新写入存在 aof-rewrite-buffer 的数据写入到 aof 文件中

   - 此时 Redis 是一个阻塞过程，直到 aof 文件替换完毕，这样保证了数据的一致性

8. 父进程将新的 aof 文件替换掉旧的 aof 文件


##### 步骤中的重点

![2021-7-11193557.png](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/2021-7-11193557.png)

- 重写会有大量的写入操作，所以服务器进程会`fork`一个子进程来创建一个新的 AOF 文件；
- 在重写期间，服务器进程继续处理命令请求，如果有写入的命令，追加到`aof_buf`的同时，还会追加到`aof_rewrite_buf`，也就是 AOF 重写缓冲区；
- 当子进程完成重写之后，会给父进程一个信号，然后父进程会把 AOF 重写缓冲区的内容写进新的 AOF 临时文件中，再对新的 AOF 文件改名完成替换，这样可以保证新的 AOF 文件与当前数据库数据的一致性。

##### 实现原理

我们来看下 AOF 重写的具体过程，考虑这样一个情况， 如果服务器对键 `list` 执行了以下四条命令：

```
RPUSH list 1 2 3 4      // [1, 2, 3, 4]
RPOP list               // [1, 2, 3]
LPOP list               // [2, 3]
LPUSH list 1            // [1, 2, 3]
```

那么当前列表键 `list` 在数据库中的值就为 `[1, 2, 3]` 。

如果我们要保存这个列表的当前状态， 并且尽量减少所使用的命令数， 那么最简单的方式不是去 AOF 文件上分析前面执行的四条命令， 而是直接读取 `list` 键在数据库的当前值， 然后用一条 `RPUSH 1 2 3` 命令来代替前面的四条命令。

再考虑这样一个例子， 如果服务器对集合键 `animal` 执行了以下命令：

```
SADD animal cat                 // {cat}
SADD animal dog panda tiger     // {cat, dog, panda, tiger}
SREM animal cat                 // {dog, panda, tiger}
SADD animal cat lion            // {cat, lion, dog, panda, tiger}
```

那么使用一条 `SADD animal cat lion dog panda tiger` 命令， 就可以还原 `animal` 集合的状态， 这比之前的四条命令调用要大大减少。

除了列表和集合之外， 字符串、有序集、哈希表等键也可以用类似的方法来保存状态， 并且保存这些状态所使用的命令数量， 比起之前建立这些键的状态所使用命令的数量要大大减少。

根据键的类型， 使用适当的写入命令来重现键的当前值， 这就是 AOF 重写的实现原理。 整个重写过程可以用伪代码表示如下：

```py
def AOF_REWRITE(tmp_tile_name):
  f = create(tmp_tile_name)
  # 遍历所有数据库
  for db in redisServer.db:
    # 如果数据库为空，那么跳过这个数据库
    if db.is_empty(): continue
    # 写入 SELECT 命令，用于切换数据库
    f.write_command("SELECT " + db.number)
    # 遍历所有键
    for key in db:
      # 如果键带有过期时间，并且已经过期，那么跳过这个键
      if key.have_expire_time() and key.is_expired(): continue
      if key.type == String:
        # 用 SET key value 命令来保存字符串键
        value = get_value_from_string(key)
        f.write_command("SET " + key + value)
      elif key.type == List:
        # 用 RPUSH key item1 item2 ... itemN 命令来保存列表键
        item1, item2, ..., itemN = get_item_from_list(key)
        f.write_command("RPUSH " + key + item1 + item2 + ... + itemN)
      elif key.type == Set:
        # 用 SADD key member1 member2 ... memberN 命令来保存集合键
        member1, member2, ..., memberN = get_member_from_set(key)
        f.write_command("SADD " + key + member1 + member2 + ... + memberN)
      elif key.type == Hash:
        # 用 HMSET key field1 value1 field2 value2 ... fieldN valueN 命令来保存哈希键
        field1, value1, field2, value2, ..., fieldN, valueN = get_field_and_value_from_hash(key)
        f.write_command("HMSET " + key + field1 + value1 + field2 + value2 + ... + fieldN + valueN)
      elif key.type == SortedSet:
        # 用 ZADD key score1 member1 score2 member2 ... scoreN memberN
        # 命令来保存有序集键
        score1, member1, score2, member2, ..., scoreN, memberN = get_score_and_member_from_sorted_set(key)
        f.write_command("ZADD " + key + score1 + member1 + score2 + member2 + ... + scoreN + memberN)
      else:
        raise_type_error()
      # 如果键带有过期时间，那么用 EXPIREAT key time 命令来保存键的过期时间
      if key.have_expire_time():
        f.write_command("EXPIREAT " + key + key.expire_time_in_unix_timestamp())
    # 关闭文件
    f.close()
```

#### 数据恢复

Redis4.0 开始支持 RDB 和 AOF 的混合持久化（可以通过配置项 `aof-use-rdb-preamble` 开启）

- 如果是 redis 进程挂掉，那么重启 redis 进程即可，直接基于 AOF 日志文件恢复数据；
- 如果是 redis 进程所在机器挂掉，那么重启机器后，尝试重启 redis 进程，尝试直接基于 AOF 日志文件进行数据恢复，如果 AOF 文件破损，那么用`redis-check-aof fix`命令修复；
- 如果没有 AOF 文件，会去加载 RDB 文件；
- 如果 redis 当前最新的 AOF 和 RDB 文件出现了丢失/损坏，那么可以尝试基于该机器上当前的某个最新的 RDB 数据副本进行数据恢复。

#### AOF的优缺点

- 优点
  - 多种文件写入（fsync）策略
  - 数据**实时**保存，数据**完整性**强。即使丢失某些数据，制定好策略最多也是一秒内的数据丢失.
  - **可读性强**，由于使用的是文本协议格式来存储的数据，可有直接查看操作的命令，同时也可以手动改写命令.
- 缺点
  - **文件体积过大**，加载速度比 rbd 慢
    - 由于 aof 记录的是 redis 操作的日志，一些无效的，可简化的操作也会被记录下来，造成 aof 文件过大
    - 但该方式可以通过文件重写策略进行优化

## 主从复制

Redis 复制功能主要的作用，是集群、分片功能实现的基础；同时也是 Redis 实现高可用的一种策略，例如解决单机并发问题、数据安全性等等问题。

### 示例

在本文环境演示中，有一台主机，启动了两个 Redis 示例。

| 角色   | IP            | 端口号 | 密码  |
| ------ | ------------- | ------ | ----- |
| 从服务 | 192.168.2.102 | 6380   | p6380 |
| 主服务 | 192.168.2.102 | 6379   | p6379 |

#### 实现方式

Redis 复制实现方式分为下面三种方式

##### 服务启动时配置

该方式通过在启动 Redis 服务时，通过**命令行参数**，进行启动主从复制功能。

该方式的弊端是不能实现配置持久化，当服务停掉之后，启动服务时，需要添加相同的命令参数。

master 服务器事先在 redis.confg 增加 requirepass 项

```shell
requirepass p6379
```

启动从服务器

```shell
redis-server --port 6380 --replicaof 192.168.2.102 6379
```

##### 命令行配置

该方式通过使用 redis-cli 进入操作行界面，进行配置。

该方式的弊端是不能实现配置持久化，当服务停掉之后，启动服务需要执行同样的命令。

master 服务器执行

```shell
127.0.0.1:6379> config set requirepass p6379
OK
```

从服务器执行

```shell
127.0.0.1:6380> replicaof 192.168.2.102 6379
OK
127.0.0.1:6380> config set masterauth p6379
OK
```

##### 配置文件配置

该方式是通过 redis.conf 配置文件进行设置，能够实现配置的持久化，是一种推荐使用的方式。

配置主服务器，redis.config

```shell
requirepass p6379
```

配置从服务器，redis.config

```shell
masterauth p6379
replicaof 192.168.2.102 6379
```

##### 配置说明

- masterauth：设置 redis.config 连接密码，如果设置了该值。其他客户端在连接该服务器时，需要添加密码才可以访问

- requirepass：设置主服务器的连接密码，和 1 中 masterauth 一致
- replicaof：从服务器连接到服务器的 IP 地址 + 端口号

### 实现原理

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/2021519112001174.jpg" alt="img" style="zoom:150%;" />

```uml
// uml图
@startuml
从服务器->主服务器: 1.保存配置
从服务器->主服务器: 2.建立socket连接
从服务器->主服务器: 3.发送ping命令
从服务器->主服务器: 4.权限验证
从服务器->主服务器: 5.同步数据
从服务器->主服务器: 6.持续复制数据
@enduml
```

主从复制主要实现的一个流程如上图：

1. 第一步，从服务器保存主服务器的配置信息，保存之后待从服务器内部的定时器执行时，就会触发复制的流程。

2. 第二步，从服务器首先会与主服务器建立一个 **socket 套接字连接**，用作主从通信使用。后面主服务器发送数据给从服务器也是通过该套字节进行。

3. 第三步，socket 套接字连接成功之后，接着发送鉴权 **ping 命令**，正常的情况下，主服务器会发送对应的响应。ping 命令的作用是为了，保证 socket 套字节是否可以用，同时也是为了验证主服务器是否接受操作命令。

4. 第四步，接着就是**鉴权**验证，判断从节点配置的主节点连接密码是否正确。

5. 第五步，鉴权成功之后，就可以开始复制数据了。主服务器此时会进行**全量复制**，将主服务的数据全部发给从服务器，从服务器保存主服务器发送的数据。

6. 接下来就是持续复制操作。主服务器会进行**异步复制**，一边将写的数据写入自身，同时会将新的写命令发送给从服务器。

### 策略

Redis 主从复制主要分为三种策略方式，不同的策略方式都是针对不同的场景下进行使用。

#### 全量复制

全量复制用在**主从复制刚建立**时或者**从切主服务器**时，从服务器没有主服务器的数据，主服务器会将自身的数据通过 rdb 文件方式发送给从服务器，从服务器会清空自身数据，接着将主服务器发送的数据加载到自身中。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/vn4mine017.png" alt="img" style="zoom:150%;" />

```uml
// uml图
@startuml
从服务器->主服务器: 1.psync ? -1
主服务器->从服务器: 2.fullsync runid offset
从服务器: 3.保存 runid offset
主服务器: 4.执行bgsave生成rdb
主服务器->从服务器: 5.发送rdb
从服务器: 6.清空自身老数据
从服务器: 7.加载主服务器数据
@enduml
```

主节点在将 rdb 发送给从节点，到从节点接收完成之间，如果出现新的命令，主节点会写在复制客户端缓冲区中。

当从节点加载 rdb 文件完成之后，主节点就会把这段时间写的数据下发给从节点。

如果在发送 rdb 的过程中，比较耗时，导致复制客户端缓冲区溢出，此时就会导致全量复制失败。

```redis
clientoutput-buffer-limit slave 256MB 64MB 60
```

> 60 秒内超过 64M 或者 256M，就表示溢出，主从复制则失败

如果在进行全量复制的过程中，从节点在响应客户端命令，这样就会存在客户端读取到的数据不是最新的。这样就可以通过配置，只有全量复制完成之后才响应客户端的请求命令。

```redis
slave-serve-stale-data no
```

下面的日志文件为从节点启动服务时，发起的复制请求到响应的整个流程记录。

```shell
35:C 02 Nov 2021 18:57:41.052 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
35:C 02 Nov 2021 18:57:41.055 # Redis version=6.2.6, bits=64, commit=00000000, modified=0, pid=35, just started
35:C 02 Nov 2021 18:57:41.058 # Configuration loaded
35:S 02 Nov 2021 18:57:41.062 * monotonic clock: POSIX clock_gettime
35:S 02 Nov 2021 18:57:41.065 * Running mode=standalone, port=6383.
35:S 02 Nov 2021 18:57:41.069 # Server initialized
35:S 02 Nov 2021 18:57:41.075 * Ready to accept connections
35:S 02 Nov 2021 18:57:41.077 * Connecting to MASTER 127.0.0.1:6380 # 开始进行主从复制操作。
35:S 02 Nov 2021 18:57:41.080 * MASTER <-> REPLICA sync started
35:S 02 Nov 2021 18:57:41.083 * Non blocking connect for SYNC fired the event.
35:S 02 Nov 2021 18:57:41.087 * Master replied to PING, replication can continue... # 发送ping请求，确保能够进行复制操作。
35:S 02 Nov 2021 18:57:41.092 * Partial resynchronization not possible (no cached master) # 发送部分复制请求，不符合部分复制条件。
35:S 02 Nov 2021 18:57:41.121 * Full resync from master: 51792991a027de84a6670959443e77f862a00bb9:0 # 接着发送全量请求，并携带master的runid。
35:S 02 Nov 2021 18:57:41.170 * MASTER <-> REPLICA sync: receiving 175 bytes from master to disk
35:S 02 Nov 2021 18:57:41.175 * MASTER <-> REPLICA sync: Flushing old data
35:S 02 Nov 2021 18:57:41.178 * MASTER <-> REPLICA sync: Loading DB in memory
35:S 02 Nov 2021 18:57:41.221 * Loading RDB produced by version 6.2.6
35:S 02 Nov 2021 18:57:41.223 * RDB age 0 seconds
35:S 02 Nov 2021 18:57:41.226 * RDB memory usage when created 1.85 Mb
35:S 02 Nov 2021 18:57:41.228 # Done loading RDB, keys loaded: 0, keys expired: 0.
35:S 02 Nov 2021 18:57:41.230 * MASTER <-> REPLICA sync: Finished with success # 最终完整主从复制操作。
```

### 部分复制

部分复制用在一些异常情况下，例如主从延迟、从服务宕机之后重新启动接收主服务器发送的部分数据。

部分复制的实现主要依赖于复制缓存区、主服务的 runid、主从服务器各自的复制偏移量 (offset)

- 复制缓存区
  - 主服务在接收写命令时，会将命令写入缓存区，以便从服务器在异常情况下，减少数据的丢失。
  - 当从服务器正常连接之后，主服务器会将缓存区内的数据发送给从服务器。这里的缓存区是一个长队列。
  - 复制缓冲区的大小是有限制的，当超过这个大小，之前的老数据将会被移除来保存新的数据。

- 主服务器 runid

  - 主服务器会在每次服务启动之后，会生成一个唯一的 ID，作为自身标识。

  - 从服务器会将该标识保存起来，发送部分复制命令时，会使用该 runid。

  - ```shell
    psync runid offset
    ```

- 主从复制各自偏移量
  - 主从服务在建立复制之后，都会有自身的偏移量。
  - 从节点会每秒钟发送自身复制的偏移量给主节点，主节点在发送写命令之后，从节点也会增加自身的复制偏移量。
  - 主节点在每次进行了写命令之后，也会增加自身的偏移量。
  - 这里的偏移量是通过命令的字节长度累加计算。

### 异步复制

异步复制是针对主从建立复制关系之后，主节点在响应客户端写的请求会立即把对应的结果返给客户端，接着在去把新的数据下发给从节点。

这样就有可能主从延迟导致、主服务突然宕机了还没来得及同步数据，出现数据不一致的情况。

## 哨兵机制

### 主从复制弊端

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/1618556721550-Snipaste_2021-04-16_15-04-45.png" alt="1618556721550-Snipaste_2021-04-16_15-04-45" style="zoom:50%;" />

上面的图形结构，大致的可以理解为 Redis 的主从复制拓扑图。

1. 其中 1 个主节点负责应用系统的写数据，另外的 4 个从节点负责应用系统的读数据。
2. 同时 4 个从节点向其中的 1 个一个主节点发起复制请求操作。

在 Redis 服务运行正常的情况下，该拓扑结结构不会出现什么问题。试想一下这样的一个场景。如果主节点服务发生了异常，不能正常处理服务（如写入数据、主从复制操作）。**这时候，Redis 服务能正常响应应用系统的读操作，但是没法进行写操作。** 出现该情况就会严重影响到系统的业务数据。那该如何解决呢？

可以大致想到下面的几种情况来解决。

1. 当主节点发生异常情况时，手动的从部分从节点中选择一个节点作为主节点。然后改变其他从节点的主从复制关系。
2. 我们也可以写一套自动处理该情况的服务，避免依赖于人为的操作。

上面的方案在一定程度上是能帮助我们解决问题。但是过多的人为干预。例如第 1 点，我们需要考虑人工处理的实时性和正确性。第 2 点，自动化处理是能够很好的解决第 1 点中的问题，但是自动处理存在如何选择新主节点的问题，因此这也是个难题

Redis 的哨兵机制就是针对这些问题出现的

### 什么是哨兵

可以把 Redis 的哨兵理解为一种 **Redis 分布式架构**。 该架构中主要存在两种角色，一种是哨兵，另外一种是数据节点（主从复制节点）

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/1618558716540-Snipaste_2021-04-16_15-38-08.png" alt="1618558716540-Snipaste_2021-04-16_15-38-08" style="zoom:50%;" />

哨兵主要负责的任务是：

1. 每一个哨兵都会监控数据节点以及其他的哨兵节点。
2. 当其中的一个哨兵监控到节点不可达时，会给对应的节点做**下线标识**。如果下线的节点为主节点。这时候会通知其他的哨兵节点。
3. 哨兵节点**通过 “协商” 推举**出从节点中的某一个节点为主节点。
4. 接着将其他的从节点断开与旧主节点的复制关系，将推举出来的新主节点作为从节点的主节点。
5. 将切换的结果通知给应用系统。

![1618558995604-Snipaste_2021-04-16_15-43-04](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/1618558995604-Snipaste_2021-04-16_15-43-04.png)

### 配置哨兵

在演示环境中，配置了三台数据节点（1 主 2 从），三台哨兵节点。演示中用到的 Redis 为 6.0.8 版本。

| 角色              | IP        | 端口号 |
| ----------------- | --------- | ------ |
| (数据节点) master | 127.0.0.1 | 8002   |
| (数据节点) slave  | 127.0.0.1 | 8003   |
| (数据节点) slave  | 127.0.0.1 | 8004   |
| 哨兵节点          | 127.0.0.1 | 8005   |
| 哨兵节点          | 127.0.0.1 | 8006   |
| 哨兵节点          | 127.0.0.1 | 8007   |

(数据节点) master 配置

```ini
# 服务配置
daemonize yes

# 端口号
port 8002

# 数据目录
dir "/Users/kert/config/redis/8002"

# 日志文件名称
logfile "8002.log"

# 设置密码
bind 0.0.0.0
# requirepass 8002

# 多线程
# 1.开启线程数。
io-threads 2
# 2.开启读线程。
io-threads-do-reads yes

# 持久化存储(RDB)
# 1.每多少秒至少有多少个key发生变化，则执行save命令。
save 10 1
save 20 1
save 30 1
# 2.当bgsave命令发生错误时，停止写入操作。
stop-writes-on-bgsave-error yes
# 3.是否开启rbd文件压缩
rdbcompression yes
```

(数据节点) slave 配置

```ini
# 服务配置
daemonize yes

port 8004

dir "/Users/kert/config/redis/8004"

logfile "8004.log"

# 多线程
# 1.开启线程数。
io-threads 2
# 2.开启读线程。
io-threads-do-reads yes

# 持久化存储(RDB)
# 1.每多少秒至少有多少个key发生变化，则执行save命令。
save 10 1
save 20 1
save 30 1
# 2.当bgsave命令发生错误时，停止写入操作。
stop-writes-on-bgsave-error yes
# 3.是否开启rbd文件压缩
rdbcompression yes

# 配置主节点信息
replicaof 127.0.0.1 8002
```

哨兵节点配置。

```ini
# 端口号
port 8006
# 运行模式
daemonize yes
# 数据目录
dir "/Users/kert/config/redis/sentinel/8006"
# 日志文件
logfile "8006.log"
# 监听数据节点
sentinel monitor mymaster 127.0.0.1 8002 2(判定主节点下线状态的票数)
# 设置主节点连接权限信息
sentinel auth-pass mymaster 8002
# 判断数据节点和sentinel节点多少毫秒数内没有响应ping，则处理为下线状态
sentinel down-after-milliseconds mymaster 30000
# 主节点下线后，从节点向新的主节点发起复制的个数限制(指的一次同时允许几个从节点)。
sentinel parallel-syncs mymaster 1
# 故障转移超时时间
sentinel failover-timeout mymaster 180000Copy to clipboardErrorCopied
```

> 所有的哨兵节点直接将 port、dir 和 logfile 修改为对应的具体哨兵信息即可。

接着启动对应的服务 Redis 服务

```shell
# 启动master节点
kert@kertdeMacBook-Pro-2 [ ~/config/redis/8002 ] redis-server ./redis.conf

# 启动slave节点
kert@kertdeMacBook-Pro-2 [ ~/config/redis/8003 ] redis-server ./redis.conf
kert@kertdeMacBook-Pro-2 [ ~/config/redis/8004 ] redis-server ./redis.conf

# 启动哨兵节点
kert@kertdeMacBook-Pro-2 [ ~/config/redis/sentinel ] redis-sentinel 8007.conf
kert@kertdeMacBook-Pro-2 [ ~/config/redis/sentinel ] redis-sentinel 8006.conf
kert@kertdeMacBook-Pro-2 [ ~/config/redis/sentinel ] redis-sentinel 8005.conf
```

> 哨兵启动，需要用到 Redis 安装完之后自带的 redis-sentinel 命令。

查看 Redis 服务运行状态

```shell
 kert@kertdeMacBook-Pro-2 [ ~/config/redis/sentinel ] ps -ef | grep redis
  501 99742     1   0  3:53PM ??         0:00.47 redis-server 0.0.0.0:8002
  501 99776     1   0  3:53PM ??         0:00.36 redis-server 0.0.0.0:8003
  501 99799     1   0  3:53PM ??         0:00.10 redis-server *:8004
  501 99849     1   0  3:53PM ??         0:00.06 redis-sentinel *:8007 [sentinel]
  501 99858     1   0  3:53PM ??         0:00.04 redis-sentinel *:8006 [sentinel]
  501 99867     1   0  3:53PM ??         0:00.03 redis-sentinel *:8005 [sentinel]
```

> 看到上面的结果，则表示我们的 Redis 服务已经正常启动。

### 演示故障切换

我们先打开三个终端，分配时 master 节点和两个 slave 节点。检测是否能够正常进行主从复制。

![1618560150817-Snipaste_2021-04-16_16-01-40](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/1618560150817-Snipaste_2021-04-16_16-01-40.png)

我们在主节点任意写入一些数据，然后在从节点进行查询数据。为了方便，后面将 master 称作 1 号终端，两个 slave 分配叫做 2 号和 3 号终端。

我们在 1 号终端写入数据。

```shell
127.0.0.1:8002> set name tony
OK
127.0.0.1:8002> set age 1
OK
127.0.0.1:8002> set score 1
OK
```

接着在 2 号和 3 号终端下面执行如下的查询操作。

```shell
127.0.0.1:8003> get name
"tony"
127.0.0.1:8003> get age
"1"
127.0.0.1:8003> get score
"1"
```

> 事实证明我们的主从复制是成功的，接下来我们就停掉 master 节点的服务。

我们实现查看一下哨兵节点的一个状态信息。

查看哨兵端口为 8005 的节点。

```shell
kert@kertdeMacBook-Pro-2 [ ~ ] redis-cli -p 8005 info
# Sentinel
sentinel_masters:1
sentinel_tilt:0
sentinel_running_scripts:0
sentinel_scripts_queue_length:0
sentinel_simulate_failure_flags:0
master0:name=mymaster,status=ok,address=127.0.0.1:8002,slaves=2,sentinels=3
```

查看哨兵端口为 8006 的节点。

```shell
kert@kertdeMacBook-Pro-2 [ ~ ] redis-cli -p 8006 info
# Sentinel
sentinel_masters:1
sentinel_tilt:0
sentinel_running_scripts:0
sentinel_scripts_queue_length:0
sentinel_simulate_failure_flags:0
master0:name=mymaster,status=ok,address=127.0.0.1:8002,slaves=2,sentinels=3
```

查看哨兵端口为 8007 的节点。

```shell
kert@kertdeMacBook-Pro-2 [ ~ ] redis-cli -p 8007 info
# Sentinel
sentinel_masters:1
sentinel_tilt:0
sentinel_running_scripts:0
sentinel_scripts_queue_length:0
sentinel_simulate_failure_flags:0
master0:name=mymaster,status=ok,address=127.0.0.1:8002,slaves=2,sentinels=3
```

> 通过上面的几个状态信息，我们可以看到哨兵检测的主节点信息，主节点下面有几个从节点，同时哨兵节点有几个。

我们杀掉 master 的进程。可以看到 1 号端口自动断开了连接。

![1618560942345-Snipaste_2021-04-16_16-15-12](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/1618560942345-Snipaste_2021-04-16_16-15-12.png)

接着我们通过哨兵机制查看一下数据节点状态信息。

```shell
kert@kertdeMacBook-Pro-2 [ ~ ] redis-cli -p 8005 info
# Sentinel
sentinel_masters:1
sentinel_tilt:0
sentinel_running_scripts:0
sentinel_scripts_queue_length:0
sentinel_simulate_failure_flags:0
master0:name=mymaster,status=ok,address=127.0.0.1:8004,slaves=2,sentinels=3
```

> 通过上面的查询结果，我们可以看到 address 的值变成了 8004 端口了，其他的信息没有发生改变，说明哨兵已经完成切换工作。

接下来我们在新的主节点执行操作命令，查看在从节点是否能够完成主从复制。

在 3 号端口（新的 master）执行一个 del 命令

```shell
127.0.0.1:8004> del age
(integer) 1
127.0.0.1:8004> keys *
1) "name"
2) "socre"
```

在 2 号端口执行读命令

```shell
127.0.0.1:8003> keys *
1) "socre"
2) "name"
```

> 此时可以发现我们的主从复制也是正常的。 

启动旧的 master，并执行读命令

```shell
kert@kertdeMacBook-Pro-2 [ ~/config/redis/8002 ] redis-server ./redis.conf
kert@kertdeMacBook-Pro-2 [ ~/config/redis/8002 ] redis-cli -p 8002
127.0.0.1:8002> keys *
1) "name"
2) "socre"
```

> 此时你也会发现，原来的 master 节点变成了 slave 节点，并且能够正常复制新 master 节点的数据。

### 配置文件对比

在我们启动了哨兵模式之后，我们的哨兵配置文件和数据节点配置文件的内容都会自动的生成一个特定的内容。

#### 数据节点 (master)

变化前

```shell
# 服务配置
daemonize yes

# 端口号
port 8002

# 数据目录
dir "/Users/kert/config/redis/8002"

# 日志文件名称
logfile "8002.log"

# 设置密码
bind 0.0.0.0
# requirepass 8002

# 多线程
# 1.开启线程数。
io-threads 2
# 2.开启读线程。
io-threads-do-reads yes
# 持久化存储(RDB)
# 1.每多少秒至少有多少个key发生变化，则执行save命令。
save 10 1
save 20 1
save 30 1
# 2.当bgsave命令发生错误时，停止写入操作。
stop-writes-on-bgsave-error yes
# 3.是否开启rbd文件压缩
rdbcompression yesCopy to clipboardErrorCopied
```

变化后

```shell
# 服务配置
daemonize yes

# 端口号
port 8002

# 数据目录
dir "/Users/kert/config/redis/8002"

# 日志文件名称
logfile "8002.log"

# 设置密码
bind 0.0.0.0
# requirepass 8002

# 多线程
# 1.开启线程数。
io-threads 2
# 2.开启读线程。
io-threads-do-reads yes

# 持久化存储(RDB)
# 1.每多少秒至少有多少个key发生变化，则执行save命令。
save 10 1
save 20 1
save 30 1
# 2.当bgsave命令发生错误时，停止写入操作。
stop-writes-on-bgsave-error yes
# 3.是否开启rbd文件压缩
rdbcompression yes
# Generated by CONFIG REWRITE
pidfile "/var/run/redis.pid"
user default on nopass ~* +@all

replicaof 127.0.0.1 8004
```

#### 哨兵节点

变化前

```shell
# 端口号
port 8006
# 运行模式
daemonize yes
# 数据目录
dir "/Users/kert/config/redis/sentinel/8006"
# 日志文件
logfile "8006.log"
# 监听数据节点
sentinel monitor mymaster 127.0.0.1 8002 2(判定主节点下线状态的票数)
# 设置主节点连接权限信息
sentinel auth-pass mymaster 8002
# 判断数据节点和sentinel节点多少毫秒数内没有响应ping，则处理为下线状态
sentinel down-after-milliseconds mymaster 30000
# 主节点下线后，从节点向新的主节点发起复制的个数限制(指的一次同时允许几个从节点)。
sentinel parallel-syncs mymaster 1
# 故障转移超时时间
sentinel failover-timeout mymaster 180000Copy to clipboardErrorCopied
```

变化后

```shell
# 端口号
port 8005
# 运行模式
daemonize yes
# 数据目录
dir "/Users/kert/config/redis/sentinel/8005"
# 日志文件
logfile "8005.log"
# 监听数据节点
sentinel myid 5724fd60af87e728e6f8f03ded693960c983e156
# 判断数据节点和sentinel节点多少毫秒数内没有响应ping，则处理为下线状态
sentinel deny-scripts-reconfig yes
# 主节点下线后，从节点向新的主节点发起复制的个数限制(指的一次同时允许几个从节点)。
sentinel monitor mymaster 127.0.0.1 8004 2
# 故障转移超时时间
sentinel config-epoch mymaster 3
# Generated by CONFIG REWRITE
protected-mode no
user default on nopass ~* +@all
sentinel leader-epoch mymaster 3
sentinel known-replica mymaster 127.0.0.1 8002
sentinel known-replica mymaster 127.0.0.1 8003
sentinel known-sentinel mymaster 127.0.0.1 8006 8fbd2cce642c881f752775afee9b3591e0d90dc6
sentinel known-sentinel mymaster 127.0.0.1 8007 69530c74791e5f32db1c2a006c826a6463bc6496
sentinel current-epoch 3
pidfile "/var/run/redis.pid"
```

### 哨兵选主机制

- 从从节点中选择 slave-priority 配置最小值的那一天作为从节点，如果设置为 0，表示该从节点不参与从节点换主节点。

- 如果不存在 slave-priority 配置，则选择集群中同步数据最多，偏移量最大的节点作为主节点。

- 如果还是不存在，则选择 runid 最小的从节点为主节点。

## 内存管理

### 内存过期策略

过期策略是指数据在过期之后，还会占用这内容，这时候 Redis 是如何处理的

#### 分类

##### 定时策略

Redis 在对设置了过期时间的 key，在创建时都会增加一个**定时器**。定时器定时去处理该 key。

- 优点：保证内存被尽快释放，减少无效的缓存暂用内存。

- 缺点：若过期 key 很多，删除这些 key 会占用很多的 CPU 时间，在 CPU 时间紧张的情况下，CPU 不能把所有的时间用来做要紧的事儿，还需要去花时间删除这些 key。定时器的创建耗时，若为每一个设置过期时间的 key 创建一个定时器（将会有大量的定时器产生），性能影响严重。

一般来说不会选择该策略模式。

##### 惰性策略

在客户端向 Redis 读数据时，Redis 会检测该 key 是否过期，过期了就返回空值。

- 优点：删除操作只发生在从数据库取出 key 的时候发生，而且只删除当前 key，所以对 CPU 时间的占用是比较少的，而且此时的删除是已经到了非做不可的地步（如果此时还不删除的话，我们就会获取到了已经过期的 key 了）。

- 缺点：若大量的 key 在超出超时时间后，很久一段时间内，都没有被获取过，此时的无效缓存是永久暂用在内存中的，那么可能发生内存泄露（无用的垃圾占用了大量的内存）。

##### 定期策略

Redis 会定期去检测设置了过期时间的 key，当该 key 已经失效了，则会从内存中剔除；如果未失效，则不作任何处理。

该方式不是去遍历所有的 ky，而是**随机**抽取一些 key 做过期检测

- 优点：通过限制删除操作的时长和频率，来缓解定时策略、惰性策略的缺点

- 缺点
  - 在内存友好方面，不如"定时删除"，因为是随机遍历一些 key，因此存在部分 key 过期，但遍历 key 时，没有被遍历到，过期的 key 仍在内存中。
  - 在 CPU 时间友好方面，不如"惰性删除"，定期删除也会暂用 CPU 性能消耗。

- 难点：合理设置删除操作的执行时长（每次删除执行多长时间）和执行频率（每隔多长时间做一次删除）（这个要根据服务器运行情况来定了）


#### 过期策略对持久化存储的影响

##### RDB 持久化

持久化 key 之前，会检查是否过期，过期的 key 不进入 RDB 文件。

数据载入数据库之前，会对 key 先进行过期检查，如果过期，不导入数据库（主库情况）

##### AOF 持久化

- 当 key 过期后，还没有被删除，此时进行执行持久化操作（该 key 是不会进入 aof 文件的，因为没有发生修改命令）。

- 当 key 过期后，在发生删除操作时，程序会向 aof 文件追加一条 del 命令（在将来的以 aof 文件恢复数据的时候该过期的键就会被删掉）。

- 重写时，会先判断 key 是否过期，已过期的 key 不会重写到 aof 文件。

> 即使在重写时，不验证是否过期，然而追加了del命令，测试无效的key同样会被删除。判断的情况是为了防止没有加入del命令的key。

#### 配置过期策略

1. 惰性过期策略为内置策略，无需配置

2. 定期删除策略
   - 配置 redis.conf 的 hz 选项，默认为 10，即 1 秒执行 10 次，100ms 一次，值越大说明刷新频率越快，最 Redis 性能损耗也越大
   - 配置 redis.conf 的 maxmemory 最大值，当已用内存超过 maxmemory 限定时，就会触发主动清理策略

#### 主从复制对过期策略的影响

1. 默认情况下，从节点是不做数据过期处理的，可以通过 `replica-ignore-maxmemory yes` 决定开启是否在从节点处理过期处理策略。

2. 主从复制默认的情况下，都是在主节点实现，主节点将对应的 del 命令发送给从节点实现，从节点执行 del 命令。

### 内存淘汰机制

内存淘汰机制针对是内存不足的情况下的一种 Redis 处理机制。例如，当前的 Redis 存储已经超过内存限制了，然而我们的业务还在继续往 Redis 里面追加缓存内容，这时候 Redis 的淘汰机制就起到作用了。

#### 淘汰机制分类

根据 redis.conf 的配置文件中，我们可以得出，主要分为如下六种淘汰机制。

```
# volatile-lru -> Evict using approximated LRU among the keys with an expire set.
# allkeys-lru -> Evict any key using approximated LRU.
# volatile-lfu -> Evict using approximated LFU among the keys with an expire set.
# allkeys-lfu -> Evict any key using approximated LFU.
# volatile-random -> Remove a random key among the ones with an expire set.
# allkeys-random -> Remove a random key, any key.
# volatile-ttl -> Remove the key with the nearest expire time (minor TTL)
# noeviction -> Don't evict anything, just return an error on write operations.Copy to clipboardErrorCopied
```

这六种机制主要是什么意思内，下面是分别针对上面的几种机制做一个说明。

- volatile-lru：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，移除最近最少使用的 key。
- allkeys-lru：当内存不足以容纳新写入数据时，在键空间中，移除最近最少使用的 key（这个是最常用的）。
- volatile-lfu：当内存不足以容纳新写入数据时，在过期密集的键中，使用 LFU 算法进行删除 key。
- allkeys-lfu：当内存不足以容纳新写入数据时，使用 LFU 算法移除所有的 key。
- volatile-random：当内存不足以容纳新写入数据时，在设置了过期的键中，随机删除一个 key。
- allkeys-random：当内存不足以容纳新写入数据时，随机删除一个或者多个 key。
- volatile-ttl：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，有更早过期时间的 key 优先移除。
- noeviction：当内存不足以容纳新写入数据时，新写入操作会报错。

## 缓存穿透、缓存击穿、缓存雪崩

1. 缓存穿透是因为数据库本身没有该数据。
2. 缓存击穿和缓存雪崩是数据库中存在该数据，只是缓存中的数据失效了，导致重新要查询一次数据库再添加到缓存中去。
3. 缓存击穿是针对部分热点 key，而缓存雪崩是大面积缓存失效。两则原理上其实是一样的，无非就是针对缓存的 key 的划分不同而已。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/202205152311108.png)

### 三者比较

1. 缓存穿透、缓存击穿和缓存雪崩都是因为缓存中数据不存在，导致走数据库去查询数据。
2. 由于缓存数据不存在，所有的请求都会走到数据库，因此会导致数据库的压力过大甚至出现服务崩溃，导致整个系统无法使用。

### 缓存穿透

#### 定义

缓存穿透是由于客户端求的数据在缓存中不存在，然后去查询数据库，然而数据库没有客户端要查询的数据，导致每一次请求都会走数据库查询操作。真正的问题在于**该数据本身就是不存在的**。

#### 举例

客户端请求商品详情信息时，携带一个商品 ID，此时该商品 ID 是不存在的（不管是缓存中还是数据库中）。导致每一次请求该 ID 商品的数据信息都会走数据库。

#### 危害

由于请求的参数对应的数据根本不存在，会导致每一次都会请求数据库，增加数据库的压力或者服务崩溃，更有甚至影响到其他的业务模块。经常发生在用户**恶意请求**的情况下会发生。

#### 解决方案

- 根据请求的参数**缓存一个 null 值**。并且为该值设置一个过期时间，可以将时间设置短暂一点。

- 使用**布隆过滤器**，首先通过布隆过滤器进行筛选，如果在过滤器中存在则去查询数据库，然后添加到缓存中。如果不存在则直接返回客户端数据不存在。

- 由于缓存穿透可能是用户发起恶意请求，可以将用户 ip 给记录下来，针对**恶意的ip请求进行封禁**。

#### 方案分析

第一种方案，针对不存在的 key，会缓存一个空的值。假设这样的请求特别多，是否都会一一去设置一个空值的缓存，此时 Redis 中就存在大量无效的缓存空值。假设这样的 key 是商品或者文章类的 ID，我们在设置空值之后，如果后台添加数据应该去更新 ID 对应的缓存值，并设置一个合理的过期时间。

第二种方案，也是业界使用最多的一种方案。布隆过滤器的优点在于基于 Redis 实现，内存操作并且底层的实现也是非常节约内存。当后台添加数据成功时，将该数据的 ID 添加到布隆过滤器中，前端在请求时先走布隆过滤器进行验证是否存在。但布隆过滤器也存在一个弊端，就是 hash 冲突问题。这里的 hash 冲突是什么意思呢？就是说多个 ID 在进行 hash 计算时，得到的 hash 位都是同一个值，这就导致在验证是否存在时误判。

第三种方案，针对同一用户一段时间内发起大量的请求，触发缓存穿透机制，此时我们可以显示该客户端的访问。但攻击者如果是发起 DDOS 这样的攻击，是没法完全的避免此类攻击，因此这种方案不是一个很好的解决方案。

#### 方案总结

我们首先在请求层面增加第 3 中方案，做一个限流机制、IP 黑名单机制，控制一些恶意的请求，如果是误判我们可以实现 IP 解封这样的操作。在缓存层则使用第 1 中方案实现。设置一个合理的缓存时间。

对于能容忍误判的业务场景，可以直接才用第 2 中方案实现。完全基于 Redis，减少了系统的复杂度。

### 缓存击穿

#### 定义

缓存击穿是因为某个**热点 key** 不存在，导致走数据库查询。增加了数据库的压力。这种压力可能是瞬间的，也可能是比较持久的。真正的问题在于**该 key 是存在，只是缓存中不存在**，导致走数据库操作。

#### 举例

有一个热门的商品，用户查看商品详情时携带商品的 ID 以获取到商品的详情信息。此时缓存中的数据已经过期了，因此来的所有请求都要走数据库去查询。

#### 危害

相对缓存穿透而言，该数据在数据库中是存在的，只是因为缓存过期了，导致要走一次数据库，然后在添加到缓存中，下次请求就能正常走缓存。所谓的危害同样的还是针对数据库层面的危害。

#### 解决方案

1. **加互斥锁**。针对第一个请求，发现缓存中没有数据，此时查询数据库添加到缓存里面。这样后面的请求就不需要走数据库查询。
2. **增加业务逻辑过期时间**。在设置缓存时，我们可以添加一个缓存过期时间。每次去读取的时候，做一个判断，如果这个过期时间与当前时间小于一个范围，触发一个后台线程，去数据库拉取一下数据，接着更新一下缓存数据和缓存的过期时间。其实原理就是代码层面给缓存延长缓存时长。
3. **数据预热**。实现通过后台把数据添加到缓存里面。例如秒杀场景开始前，就把商品的库存添加到缓存里面，这样用户请求来了之后，就直接走缓存。
4. **永久不过期**。在给缓存设置过期时间时，让它永久不过期。后台单独开启一个线程，来维护这些缓存的过期时间和数据更新。

#### 方案分析

1. 互斥锁保证了只有一个请求走数据库，这是一个优点。但是对于分布式的系统，得才用**分布式锁**实现，分布式锁的实现本身就有一定的难点，这样提升了系统的复杂度。
2. 第 2 种方案，利用 Redis 不过期，业务过期的方案实现。保证了每一次请求都能拿到数据，同时也可以做到一个后台线程去更新数据。缺点在于后台线程没有更新完数据，此时请求拿到的数据是旧数据，可能对应实时性要求高的业务场景存在弊端。
3. 第 3 种方案，使用缓存预热每次加载都走缓存，与第 2 种方案差不多。不过也存在热点数据更新问题，因此该方案适合数据实时性要求不高的数据。
4. 第 4 中方案，和第 2、3 种方案类似，在此基础上进行了一定优化，使用后台异步线程主动去更新缓存数据。难点在于更新的频率控制。

#### 方案总结

1. 对于实时性要求高的数据，推荐使用第 1 种方案，虽然在技术上有一定的难度但是能做到数据的实时性处理。如果发生某些请求等待时间久，可以返回异常，让客户端重新发送一次请求。
2. 对于实时性要求不高的数据，可以使用第 4 种方案。

### 缓存雪崩

#### 定义

前面在说到缓存击穿，是因为缓存中的某个热点 key 失效，导致大量请求走数据库。然而缓存雪崩其实也是同样的道理，只不过这个更严重而已，是**大部分缓存的 key 失效**，而不是一个或者两个 key 失效。

#### 举例

在一个电商系统中，某一个分类下的商品数据在缓存中都失效了。然而当前系统的很多请求都是该分类下面的商品数据。这样就导致所有的请求都走数据库查询。

#### 危害

由于一瞬间大量的请求涌入，每一个请求都要走数据库进行查询。数据库瞬间流量涌入，严重增加数据库负担，很容易导致数据库直接瘫痪。

#### 解决方案

- **缓存时间随机**。因为某一时间，大量的缓存失效，说明缓存的过期时间比较集中。我们直接将过期的时间设置为不集中，随机打乱。这样缓存过期时间相对不会很集中，就不会出现同一时刻大量请求走数据库进行查询操作。

- **多级缓存**。不单纯的靠 Redis 来做缓存，我们也可以使用 memcached 来做缓存（这里只是举一个例子，其他的缓存服务也可以）。缓存数据时，对 Redis 做一个缓存，对 memcached 做一个缓存。如果 Redis 失效了，我们可以走 memcached。

- **互斥锁**。缓存击穿中我们提到了使用互斥锁来实现，同样我们也可以用在雪崩的情况下。

- **设置过期标志**。其实也可以用到缓存击穿中讲到的增加过期时间。当请求时，判断过期时间，如果临近过期时间则设置一个过期标志，触发一个独立的线程去对这个缓存进行更新。

#### 方案分析

第 1 种方案采用随机数缓存时间，能保证 key 的失效时间分散。难点在于如何设置缓存时间，如果对于一些需要设置短缓存时间并数据量非常大的数据，该方案就需要合理的控制时间。

第 2 种方案使用多级缓存，可以保证请求全部走缓存数据。但这样增加了系统的架构难度，以及其他的各种问题，例如缓存多级更新。

第 3 种方案使用互斥锁，在缓存击穿中我们提到了互斥锁，在雪崩的场景中我们虽然能使用，但是这样会产生大量的分布式锁。

第 4 种方案使用逻辑缓存时间，很好的保证了系统的缓存压力。

#### 方案总结

在实际的项目中推荐使用第 1、2 和 4 种方案试下会更好一些。

## Redis 与 MySQL 的配合

在 web 服务端开发的过程中，redis + mysql 是最常用的存储解决方案，mysql 存储着所有的业务数据，根据业务规模会采用相应的分库分表、读写分离、主备容灾、数据库集群等手段。但是由于 mysql 是基于磁盘的 IO，基于服务响应性能考虑，将业务热数据利用 redis 缓存，使得高频业务数据可以直接从内存读取，提高系统整体响应速度。

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

读取缓存一般没有什么问题，但是一旦涉及到数据更新：数据库和缓存更新，就容易出现缓存（Redis）和数据库（MySQL）间的数据一致性问题。不管是先写数据库，再删除缓存；还是先删除缓存，再写数据库，都有可能出现数据不一致的情况。

比如：

1. 如果先删除缓存，还没有来得及写库，另一个线程就来读取，发现缓存为空，则去数据库中读取数据写入缓存，此时缓存中为脏数据。
2. 如果先写了库，在删除缓存前，写库的线程宕机了，没有删除掉缓存，则也会出现数据不一致情况。因为写和读是并发的，无法保证顺序，就会出现缓存和数据库的数据不一致的问题。

### 缓存和数据库一致性解决方案

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-8af327bf4c805ff3ba42dc073d6b712d_1440w.jpg)

#### 采用延时双删策略

在写库前后都进行 `redis.del(key)` 操作，并且设定合理的超时时间。伪代码如下：

```java
// 具体的步骤：先删除缓存；再写数据库；休眠500毫秒；再次删除缓存。
public void write(String key,Object data){
    redis.delKey(key);
    db.updateData(data); 
    Thread.sleep(500); // 不休眠的话，读请求还有可能未结束，造成脏数据
    redis.delKey(key);
}
```

这个 500 毫秒怎么确定的，具体该休眠多久呢？

需要评估具体项目的读数据业务逻辑的耗时。目的就是确保读请求结束，写请求可以删除读请求造成的缓存脏数据。

当然这种策略还要考虑 Redis 和数据库主从同步的耗时。最后的写数据的休眠时间：在读数据业务逻辑的耗时基础上，加几百毫秒即可。比如：休眠 1 秒。

##### 设置缓存过期时间

从理论上来说，给缓存设置过期时间，是保证最终一致性的解决方案。所有的写操作以数据库为准，只要到达缓存过期时间，则后面的读请求自然会从数据库中读取新值然后回填缓存。

##### 该方案的弊端

结合双删策略 + 缓存超时设置，这样最差的情况就是在超时时间内数据存在不一致，而且又增加了写请求的耗时。

#### 异步更新缓存（基于订阅 binlog 的同步机制）

##### 技术整体思路：

- MySQL binlog 增量订阅消费 + 消息队列 + 增量数据更新到 Redis

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

## 如何用 Redis 实现分布式锁？

分布式锁是用于分布式环境下并发控制的一种机制，用于控制某个资源在同一时刻只能被一个应用所使用。如下图所示：

![img](https://cdn.xiaolincoding.com/gh/xiaolincoder/redis/八股文/分布式锁.jpg)

Redis 本身可以被多个客户端共享访问，正好就是一个共享存储系统，可以用来保存分布式锁，而且 Redis 的读写性能高，可以应对高并发的锁操作场景。

Redis 的 SET 命令有个 NX 参数可以实现「key 不存在才插入」，所以可以用它来实现分布式锁：

- 如果 key 不存在，则显示插入成功，可以用来表示加锁成功；
- 如果 key 存在，则会显示插入失败，可以用来表示加锁失败。

基于 Redis 节点实现分布式锁时，对于加锁操作，我们需要满足三个条件。

- 加锁包括了读取锁变量、检查锁变量值和设置锁变量值三个操作，但需要以原子操作的方式完成，所以，我们使用 SET 命令带上 NX 选项来实现加锁；
- 锁变量需要设置过期时间，以免客户端拿到锁后发生异常，导致锁一直无法释放，所以，我们在 SET 命令执行时加上 EX/PX 选项，设置其过期时间；
- 锁变量的值需要能区分来自不同客户端的加锁操作，以免在释放锁时，出现误释放操作，所以，我们使用 SET 命令设置锁变量值时，每个客户端设置的值是一个唯一值，用于标识客户端；

满足这三个条件的分布式命令如下：

```sql
SET lock_key unique_value NX PX 10000 
```

- lock_key 就是 key 键；
- unique_value 是客户端生成的唯一的标识，区分来自不同客户端的锁操作；
- NX 代表只在 lock_key 不存在时，才对 lock_key 进行设置操作；
- PX 10000 表示设置 lock_key 的过期时间为 10s，这是为了避免客户端发生异常而无法释放锁。

而解锁的过程就是将 lock_key 键删除（del lock_key），但不能乱删，要保证执行操作的客户端就是加锁的客户端。所以，解锁的时候，我们要先判断锁的 unique_value 是否为加锁客户端，是的话，才将 lock_key 键删除。

可以看到，解锁是有两个操作，这时就需要 Lua 脚本来保证解锁的原子性，因为 Redis 在执行 Lua 脚本时，可以以原子性的方式执行，保证了锁释放操作的原子性。

```kotlin
// 释放锁时，先比较 unique_value 是否相等，避免锁的误释放
if redis.call("get",KEYS[1]) == ARGV[1] then
    return redis.call("del",KEYS[1])
else
    return 0
end
```

这样一来，就通过使用 SET 命令和 Lua 脚本在 Redis 单节点上完成了分布式锁的加锁和解锁。

### 基于 Redis 实现分布式锁的优点

1. 性能高效（这是选择缓存实现分布式锁最核心的出发点）。
2. 实现方便。很多研发工程师选择使用 Redis 来实现分布式锁，很大成分上是因为 Redis 提供了 setnx 方法，实现分布式锁很方便。
3. 避免单点故障（因为 Redis 是跨集群部署的，自然就避免了单点故障）。

### 基于 Redis 实现分布式锁的缺点

- **超时时间不好设置**。如果锁的超时时间设置过长，会影响性能，如果设置的超时时间过短会保护不到共享资源。比如在有些场景中，一个线程 A 获取到了锁之后，由于业务代码执行时间可能比较长，导致超过了锁的超时时间，自动失效，注意 A 线程没执行完，后续线程 B 又意外的持有了锁，意味着可以操作共享资源，那么两个线程之间的共享资源就没办法进行保护了。
  - **那么如何合理设置超时时间呢？** 我们可以基于续约的方式设置超时时间：先给锁设置一个超时时间，然后启动一个守护线程，让守护线程在一段时间后，重新设置这个锁的超时时间。实现方式就是：写一个守护线程，然后去判断锁的情况，当锁快失效的时候，再次进行续约加锁，当主线程执行完成后，销毁续约锁即可，不过这种方式实现起来相对复杂。
- **Redis 主从复制模式中的数据是异步复制的，这样导致分布式锁的不可靠性**。如果在 Redis 主节点获取到锁后，在没有同步到其他节点时，Redis 主节点宕机了，此时新的 Redis 主节点依然可以获取锁，所以多个应用服务就可以同时获取到锁。

### Redis 如何解决集群情况下分布式锁的可靠性

为了保证集群环境下分布式锁的可靠性，Redis 官方已经设计了一个分布式锁算法 **Redlock**（红锁）。

它是基于多个 Redis 节点的分布式锁，即使有节点发生了故障，锁变量仍然是存在的，客户端还是可以完成锁操作。

Redlock 算法的基本思路，**是让客户端和多个独立的 Redis 节点依次请求申请加锁，如果客户端能够和半数以上的节点成功地完成加锁操作，那么我们就认为，客户端成功地获得分布式锁，否则加锁失败**。

这样一来，即使有某个 Redis 节点发生故障，因为锁的数据在其他节点上也有保存，所以客户端仍然可以正常地进行锁操作，锁的数据也不会丢失。

Redlock 算法加锁三个过程：

- 第一步是，客户端获取当前时间。
- 第二步是，客户端按顺序依次向 N 个 Redis 节点执行加锁操作：
  - 加锁操作使用 SET 命令，带上 NX，EX/PX 选项，以及带上客户端的唯一标识。
  - 如果某个 Redis 节点发生故障了，为了保证在这种情况下，Redlock 算法能够继续运行，我们需要给「加锁操作」设置一个超时时间（不是对「锁」设置超时时间，而是对「加锁操作」设置超时时间）。
- 第三步是，一旦客户端完成了和所有 Redis 节点的加锁操作，客户端就要计算整个加锁过程的总耗时（t1）。

加锁成功要同时满足两个条件（*简述：如果有超过半数的 Redis 节点成功的获取到了锁，并且总耗时没有超过锁的有效时间，那么就是加锁成功*）：

- 条件一：客户端从超过半数（大于等于 N/2+1）的 Redis 节点上成功获取到了锁；
- 条件二：客户端获取锁的总耗时（t1）没有超过锁的有效时间。

加锁成功后，客户端需要重新计算这把锁的有效时间，计算的结果是「锁的最初有效时间」减去「客户端为获取锁的总耗时（t1）」。

加锁失败后，客户端向所有 Redis 节点发起释放锁的操作，释放锁的操作和在单节点上释放锁的操作一样，只要执行释放锁的 Lua 脚本就可以了。

## 其他

### 多数据库

Redis 支持多个数据库，并且每个数据库的数据是隔离的不能共享，并且基于单机才有，如果是集群就没有数据库的概念。

Redis 是一个字典结构的存储服务器，而实际上一个 Redis 实例提供了多个用来存储数据的字典，客户端可以指定将数据存储在哪个字典中。这与我们熟知的在一个关系数据库实例中可以创建多个数据库类似，所以可以将其中的每个字典都理解成一个独立的数据库。

每个数据库对外都是一个从 0 开始的递增数字命名，Redis 默认支持 16 个数据库（可以通过配置文件支持更多，无上限），可以通过配置 databases 来修改这一数字。客户端与 Redis 建立连接后会自动选择 0 号数据库，不过可以随时使用 SELECT 命令更换数据库，如要选择 1 号数据库：

```shell
redis> SELECT 1
OK
redis [1] > GET foo
(nil)
```

然而这些以数字命名的数据库又与我们理解的数据库有所区别。首先 Redis 不支持自定义数据库的名字，每个数据库都以编号命名，开发者必须自己记录哪些数据库存储了哪些数据。另外 Redis 也不支持为每个数据库设置不同的访问密码，所以一个客户端要么可以访问全部数据库，要么连一个数据库也没有权限访问。最重要的一点是多个数据库之间并不是完全隔离的，比如 FLUSHALL 命令可以清空一个 Redis 实例中所有数据库中的数据。综上所述，这些数据库更像是一种命名空间，而不适宜存储不同应用程序的数据。比如可以使用 0 号数据库存储某个应用生产环境中的数据，使用 1 号数据库存储测试环境中的数据，但不适宜使用 0 号数据库存储 A 应用的数据而使用 1 号数据库 B 应用的数据，不同的应用应该使用不同的 Redis 实例存储数据。由于 Redis 非常轻量级，一个空 Redis 实例占用的内存只有 1M 左右，所以不用担心多个 Redis 实例会额外占用很多内存。

## 八股

### 数据类型

#### Redis 使用场景

1. 数据缓存 (用户信息、商品数量、文章阅读数量)

2. 消息推送 (站点的订阅)

3. 队列 (削峰、解耦、异步)

4. 排行榜 (积分排行)

5. 社交网络 (共同好友、互踩、下拉刷新)

6. 计数器 (商品库存，站点在线人数、文章阅读、点赞)

7. 基数计算

8. GEO 计算

#### Redis 功能特点

1. 持久化
2. 丰富的数据类型 (string、list、hash、set、zset、发布订阅等)
3. 高可用方案 (哨兵、集群、主从)
4. 事务
5. 丰富的客户端
6. 提供事务
7. 消息发布订阅
8. Geo
9. HyperLogLog
10. 事务

#### Redis 各种数据类型的底层数据结构

1. string 底层数据结构为简单字符串。
2. list 底层数据结构为 ziplist 和 linkedlist
3. hash 底层数据结构为 ziplist 和 hashtable
4. set 底层数据结构为 intset 和 hashtable
5. sorted set 底层数据结构为 ziplist 和 skiplist

#### 如何使用 Redis 实现队列功能

1. 可以使用 list 实现普通队列，lpush 添加到嘟列，lpop 从队列中读取数据。
2. 可以使用 zset 定期轮询数据，实现延迟队列。
3. 可以使用发布订阅实现多个消费者队列。
4. 可以使用 stream 实现队列。(推荐使用该方式实现)。

#### 你是怎么用 Redis 做异步队列的

1. 一般使用 list 结构作为队列，rpush 生产消息，lpop 消费消息。当 lpop 没有消息的时候，要适当 sleep 一会再重试。
2. 如果对方追问可不可以不用 sleep 呢？
   - list 还有个指令叫 blpop，在没有消息的时候，它会阻塞住直到消息到来。
3. 如果对方追问能不能生产一次消费多次呢？
   - 使用 pub/sub 主题订阅者模式，可以实现 1:N 的消息队列。
4. 如果对方追问 pub/sub 有什么缺点？
   - 在消费者下线的情况下，**生产的消息会丢失**，可以使用 Redis6 增加的 **stream 数据类型**，也可以使用专业的**消息队列如 rabbitmq 等**。
5. 如果对方追问 redis 如何实现延时队列
   - **使用sortedset，拿时间戳作为score**，消息内容作为 key 调用 zadd 来生产消息，消费者用 zrangebyscore 指令获取 N 秒之前的数据轮询进行处理。

#### 使用 Redis Stream 做队列，比 list，zset 和发布订阅有什么区别

1. list 可以使用 lpush 向队列中添加数据，lpop 可以向队列中读取数据。list 作为消息队列无法实现一个消息多个消费者。如果出现消息处理失败，需要手动回滚消息。
2. zset 在添加数据时，需要添加一个分值，可以根据该分值对数据进行排序，实现延迟消息队列的功能。消息是否消费需要额外的处理。
3. 发布订阅可以实现多个消费者功能，但是发布订阅无法实现数据持久化，容易导致数据丢失。并且开启一个订阅者无法获取到之前的数据。
4. stream 借鉴了常用的 MQ 服务，添加一个消息就会产生一个消息 ID，每一个消息 ID 下可以对应多个消费组，每一个消费组下可以对应多个消费者。可以实现多个消费者功能，同时支持 ack 机制，减少数据的丢失情况。也是支持数据值持久化和主从复制功能。

#### 设计一个网站每日、每月和每天的 PV、UV 该怎么设计

实现这样的功能，如果只是统计一个汇总数据，推荐使用 **HyperLogLog** 数据类型。

Redis HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小的。

在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64^ 个不同元素的基 数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

#### 如何使用 Redis 实现附近距离检索功能

实现距离检索，可以使用 Redis 中的 **GEO 数据类型**。

GEO 主要用于存储地理位置信息，并对存储的信息进行操作，该功能在 Redis 3.2 版本新增。

但是 GEO 适合精度不是很高的场景。

由于 GEO 是在内存中进行计算，具备计算速度快的特点。

#### 如何使用 Redis 实现一个分布式锁功能

使用 Redis 实现分布式锁，可以使用 `set key value` + `expire ttl` 实现，但是这两个命令分开执行不是一个原子操作，因此推荐使用 `set key vale nx ttl`，该命令属于原子操作。

#### 使用 Redis 解决秒杀超卖，该选择什么数据类型，为什么选择该数据类型

1. 在秒杀场景下，超卖是一个非常严重的问题。常规的逻辑是先查询库存在减少库存。但在秒杀场景中，无法保证减少库存的过程中有其他的请求读取了未减少的库存数据。
2. 由于 Redis 是单线程的执行，同一时刻只有一个线程进行操作。因此可以使用 Redis 来实现秒杀减少库存。
3. 在 Redis 的数据类型中，可以使用 lpush，decr 命令实现秒杀减少库存。该命令属于原子操作。

**具体的步骤是**

1. 在系统**初始化**时，将商品的**库存数量加载到Redis缓存中**；
2. 接收到**秒杀请求**时，在**Redis中进行预减库存**，当 Redis 中的库存不足时，直接返回秒杀失败，否则继续进行第 3 步；
3. 将请求放入**异步队列**中，返回正在排队中；
4. 服务端异步队列将请求出队，出队成功的请求可以生成秒杀订单，减少数据库库存，返回秒杀订单详情。
5. 用户在客户端申请秒杀请求后，进行**轮询**，查看是否秒杀成功，秒杀成功则进入秒杀订单详情，否则秒杀失败。

#### 如何使用 Redis 实现系统用户签到功能

1. 使用 Redis 实现用户签到可以使用 **bitmap** 实现。bitmap 底层数据存储的是 1 否者 0，占用内存小。
2. Redis 提供的数据类型 BitMap（位图），每个 bit 位对应 0 和 1 两个状态。虽然内部还是采用 String 类型存储，但 Redis 提供了一些指令用于直接操作 BitMap，可以把它看作一个 bit 数组，数组的下标就是偏移量。
3. 它的优点是内存开销小，效率高且操作简单，很适合用于签到这类场景。
4. 缺点在于位计算和位表示数值的局限。如果要用位来做业务数据记录，就不要在意 value 的值。

#### 如何使用 Redis 实现一个积分排行功能

1. 使用 Redis 实现积分排行，可以使用 **zset** 数据类型。
2. zset 在添加数据时，需要添加一个分值，将积分作为分值，值作为用户 ID，根据该分值对数据进行排序。

#### Redis 如何解决事务之间的冲突

1. 使用 watch 监听 key 变化，当 key 发生变化，事务中的所有操作都会被取消。
2. 使用乐观锁，通过版本号实现。
3. 使用悲观锁，每次开启事务时，都添加一个锁，事务执行结束之后释放锁。

悲观锁

- 悲观锁 (Pessimistic Lock)，顾名思义，就是很悲观，每次去拿数据的时候都认为别人会修改，所以每 次在拿数据的时候都会上锁，这样别人拿到这个数据就会 block 直到它拿到锁。传统的关系型数据库里面 就用到了很多这种锁机制，比如行锁、表锁、读锁、写锁等，都是在做操作之前先上锁。

乐观锁

- 乐观锁 (Optimistic Lock)，顾名思义，就是很乐观，每次去那数据的时候都认为别人不会修改，所以不会上锁；但是在**修改**的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号等机 制。乐观锁适用于多读的应用类型，这样可以提高吞吐量。redis 就是使用这种 check-and-set 机制实现 事务的。

watch 监听

- 在执行 multi 之前，先执行 ` watch key1 [key2 ...]`，可以监视一个或者多个 key，若在事务的 exec 命令之前，这些 key 对应的值被其他命令所改动了，那么事务中所有命令都将被打断，即事务所有操作将被取消执行。

#### Redis 事务的三大特性

1. 事务中的所有命令都会序列化、按顺序地执行，事务在执行过程中，不会被其他客户端发送来的命令请求所打断。
2. 队列中的命令没有提交 (exec) 之前，都不会实际被执行，因为事务提交前任何指令都不会被实际执行。
3. 事务中如果有一条命令执行失败，后续的命令仍然会被执行，没有回滚。
   - 如果在组队阶段，有 1 个失败了，后面都不会成功；
   - 如果在组队阶段成功了，在执行阶段有命令失败，就这条失败，其他的命令则正常执行，不保证都成功或都失败。

### 持久化

#### Redis 持久化都有哪些方式

1. 快照全量备份的方式 (RDB)，使用 bgsave 或者 save 命令
   - bgsave 是通过 fork 一个子进程，异步持久化；
   - save 使用同步阻塞的模式进行持久化。
2. 增量日志快照的方式 (AOF)，将 Redis 写**命令**写入到缓冲区，然后在将缓冲区的命令写入到磁盘中。

#### 使用 AOF 方式做持久化，会遇到什么问题？如何解决？

1. AOF 记录的是 Redis 的**写操作命令**，当命令数量多时，就会导致文件过大。同时有些缓存数据本身应该是**过期**了，但对应的写命令还是被保留在文件中。这就出现 **AOF 文件过大**的问题。
2. 针对这种情况，Redis 采用了**重写机制**，定期 fork 一个子进程对 AOF 文件进行重写，用来减少文件体积并剔除一些过期的命令。
3. AOF 重写可以通过自动方式和手动的方式触发，手动可以使用 `bgrewriteaof` 和自动通过配置文件体积大小时触发。

#### 什么是写时复制技术

1. Redis 使用 AOF 做持久化时，会做重写操作，此时用到了写时复制技术。
2. 在触发重写时，主进程会 fork 一个子进程，该子进程来负责做重写。在 fork 之后，子进程和主进程会共享物理内存地址，当有新的操作发生时，会单独复制一块内存空间用作重写操作。

#### AOF 持久化会保证数据的不丢失吗

1. 采用 AOF 持久化，首先写的命令是放在缓冲区中，通过同步策略持久化到磁盘中。可以通过 `appendfsync` 配置进行操作。具体可配置的值有：
   - always：命令写入到 aof_buf 缓冲区中之后立即调用系统的 fsync 操作同步到 aof 文件中，fsync 完成后线程返回。
   - everysec：命令写入到 aof_buf 缓冲区后每隔一秒调用系统的 write 操作，write 完成后线程返回。
   - no：命令写入 aof_bug 缓冲区后调用系统 write 操作，不对 aof 文件做 fsync 同步，同步硬盘操作由系统操作完成，时间一般最长为 30s。

2. fork 出来的子进程在做文件重写后，父进程此时会将就的重写文件替换掉。在这个过程中，父进程是一个阻塞的过程，不接受客户端的写命令。这个过程中容易导致数据的丢失。

#### RDB 和 AOF 做持久化的区别

##### RDB 优缺点

- 优点
  - 文件实现的数据快照，**全量备份**，便于数据的传输。
    - 比如我们需要把 A 服务器上的备份文件传输到 B 服务器上面，直接将 rdb 文件拷贝即可。
  - 文件采用**压缩的二进制文件**，当重启服务时加载数据文件，比 aof 方式更快（aof 是重新去执行一次命令）

- 缺点
  - rbd 采用加密的二进制格式存储文件，由于 **Redis 各个版本之间的兼容性问题**也导致 rdb 由版本兼容问题导致无法再其他的 Redis 版本中使用。
  - **实时性差**，并不是完全的实时同步，容易造成数据的**不完整性**。
    - 因为 rdb 并不是实时备份，当某个时间段 Redis 服务出现异常，内存数据丢失，这段时间的数据是无法恢复的，因此易导致数据的丢失。
  - **可读性差**
    - 由于文件内容采用二进制加密处理，我们无法直接读取，不能修改文件内容
    - 但一般情况下是不会去查看或修改持久化的内容

##### AOF 优缺点

- 优点
  - 多种文件写入（fsync）策略，数据实时保存，数据**完整性强**；即使丢失某些数据，制定好策略最多也是一秒内的数据丢失
  - **可读性强**，由于使用的是文本协议格式来存储的数据，可有直接查看操作的命令，同时也可以手动改写命令。

- 缺点
  - 文件**体积过大**，加载速度比 rbd **慢**
  - 由于 aof 记录的是 redis 操作的日志，一些无效的，可简化的操作也会被记录下来，造成 aof 文件过大；但该方式可以通过文件重写策略进行优化.

### 主从复制

#### Redis 的同步机制

主从同步。

- 第一次同步时，主节点做一次 bgsave，并同时将后续修改操作记录到内存 buffer

- 待完成后将 rdb 文件**全量同步**到复制节点，复制节点接受完成后将 rdb 镜像加载到内存。

- 加载完成后，再通知主节点将期间修改的操作记录同步到复制节点进行重放就完成了同步过程。

#### 如何防止 Redis 脑裂导致数据库丢失情况

##### 什么是脑裂

所谓的脑裂，就是指在主从集群中，**同时有两个主节点**，它们都能接收写请求。

而脑裂最直接的影响，就是客户端不知道应该往哪个主节点写入数据，结果就是不同的客户端会往不同的主节点上写入数据。而且，严重的话，脑裂会进一步导致数据丢失。

##### 脑裂发生原因

1. 确认是不是**数据同步**出现了问题。
   - 在主从集群中发生数据丢失，最常见的原因就是主库的数据还没有同步到从库，结果主库发生了故障，等从库升级为主库后，未同步的数据就丢失了。
   - 如果是这种情况的数据丢失，我们可以通过比对**主从库上的复制进度差值**来进行判断，也就是计算`master_repl_offset` 和 `slave_repl_offset` 的差值。
     - 如果从库上的 `slave_repl_offset` 小于原主库的 `master_repl_offset`，那么，我们就可以认定数据丢失是由数据同步未完成导致的。

2. 排查客户端的操作日志，发现脑裂现象
   - 在排查客户端的操作日志时，我们发现，在主从切换后的一段时间内，有一个客户端仍然在和原主库通信，并没有和升级的新主库进行交互。
   - 这就相当于主从集群中同时有了两个主库。根据这个迹象，我们就想到了在分布式主从集群发生故障时会出现的一个问题：脑裂。
   - 但是，不同客户端同时给两个主库发送数据写操作，按道理来说，只会导致新数据会分布在不同的主库上，并不会造成数据丢失。那么，为什么我们的数据仍然丢失了呢？

3. 发现是原主库假故障导致的脑裂。
   - 我们是采用哨兵机制进行主从切换的，当主从切换发生时，一定是有超过预设数量（quorum 配置项）的哨兵实例和主库的心跳都超时了，才会把主库判断为客观下线，然后，哨兵开始执行切换操作。哨兵切换完成后，客户端会和新主库进行通信，发送请求操作。
   - 但是，在切换过程中，既然客户端仍然和原主库通信，这就表明，原主库并没有真的发生故障（例如主库进程挂掉）

##### 为什么脑裂会导致数据丢失

主从切换后，从库一旦升级为新主库，哨兵就会让原主库执行 `slave of` 命令，和新主库重新进行全量同步。

而在全量同步执行的最后阶段，原主库需要清空本地的数据，加载新主库发送的 RDB 文件，这样一来，原主库在主从切换期间保存的新写数据就丢失了。

##### 解决方案

Redis 已经提供了两个配置项来限制主库的请求处理，分别是 `min-slaves-to-write` 和 `min-slaves-max-lag`。

- `min-slaves-to-write`：这个配置项设置了主库能进行数据同步的最少从库数量；

- `min-slaves-max-lag`：这个配置项设置了主从库间进行数据复制时，从库给主库发送 ACK 消息的最大延迟（以秒为单位）。

我们可以把 `min-slaves-to-write` 和 `min-slaves-max-lag` 这两个配置项搭配起来使用，分别给它们设置一定的阈值，假设为 N 和 T。这两个配置项组合后的要求是，主库连接的从库中至少有 N 个从库，和主库进行数据复制时的 ACK 消息延迟不能超过 T 秒，否则，主库就不会再接收客户端的请求了。

即使原主库是假故障，它在假故障期间也无法响应哨兵心跳，也不能和从库进行同步，自然也就无法和从库进行 ACK 确认了。这样一来，`min-slaves-to-write` 和 `min-slaves-max-lag` 的组合要求就无法得到满足，原主库就会被限制接收客户端请求，客户端也就不能在原主库中写入新数据了。

### 内存管理

#### Redis 存储大 key 有什么优化的解决方案

1. 应用层对存储的数据进行压缩，在存储到 Redis 中，从 Redis 中获取数据后再解压数据。
2. 可以拆分存储内容，将大 key 中的存储信息进行拆分。例如一个存储一个很大的对象，可以将对象的方法和属性给拆分开进行存储，这样检索的时候也会很快。也可以采用数据切片处理。
3. 制定合理的内存淘汰策略，例如 lru、lfu 等内存淘汰策略方案。
4. 上面几种方案如不能解决，也可以使用集群、扩容等操作。进行横向扩展。

> 针对大 key，一般会出现两种情况。一种是数据检索慢，另外一种是内存占用大。因此优化的策略可以从这两个方面入手。

#### Redis 的数据过期策略有哪些

过期策略是指数据在过期之后，还会占用这内容，这时候 Redis 是如何处理的？分别有下面三种方式:

##### 定时策略

Redis 在对设置了过期时间的 key，在创建时都会增加一个**定时器**。定时器定时去处理该 key。

- 优点：保证内存被尽快释放，减少无效的缓存暂用内存。

- 缺点：若过期 key 很多，删除这些 key 会占用很多的 CPU 时间，在 CPU 时间紧张的情况下，CPU 不能把所有的时间用来做要紧的事儿，还需要去花时间删除这些 key。定时器的创建耗时，若为每一个设置过期时间的 key 创建一个定时器（将会有大量的定时器产生），性能影响严重。

一般来说不会选择该策略模式。

##### 惰性策略

在客户端向 Redis 读数据时，Redis 会检测该 key 是否过期，过期了就返回空值。

- 优点：删除操作只发生在从数据库取出 key 的时候发生，而且只删除当前 key，所以对 CPU 时间的占用是比较少的，而且此时的删除是已经到了非做不可的地步（如果此时还不删除的话，我们就会获取到了已经过期的 key 了）。

- 缺点：若大量的 key 在超出超时时间后，很久一段时间内，都没有被获取过，此时的无效缓存是永久暂用在内存中的，那么可能发生内存泄露（无用的垃圾占用了大量的内存）。

##### 定期策略

Redis 会定期去检测设置了过期时间的 key，当该 key 已经失效了，则会从内存中剔除；如果未失效，则不作任何处理。

该方式不是去遍历所有的 ky，而是**随机**抽取一些 key 做过期检测

- 优点：通过限制删除操作的时长和频率，来缓解定时策略、惰性策略的缺点

- 缺点
  - 在内存友好方面，不如"定时删除"，因为是随机遍历一些 key，因此存在部分 key 过期，但遍历 key 时，没有被遍历到，过期的 key 仍在内存中。
  - 在 CPU 时间友好方面，不如"惰性删除"，定期删除也会暂用 CPU 性能消耗。

- 难点：合理设置删除操作的执行时长（每次删除执行多长时间）和执行频率（每隔多长时间做一次删除）（这个要根据服务器运行情况来定了）

#### Redis 的数据淘汰策略

淘汰策略主要是针对数据一直存在内存中，导致内存无法接纳新的数据。重点是了解 lru 算法、lfu 算法。

1. `volatile-lru` 当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，移除最近最少使用的 key。
2. `allkeys-lru` 当内存不足以容纳新写入数据时，在键空间中，移除最近最少使用的 key（这个是最常用的）。
3. `volatile-lfu` 当内存不足以容纳新写入数据时，在过期密集的键中，使用 LFU 算法进行删除 key。
4. `allkeys-lfu` 当内存不足以容纳新写入数据时，使用 LFU 算法移除所有的 key。
5. `volatile-random` 当内存不足以容纳新写入数据时，在设置了过期的键中，随机删除一个 key。
6. `allkeys-random` 当内存不足以容纳新写入数据时，随机删除一个或者多个 key。
7. `volatile-ttl` 当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，有更早过期时间的 key 优先移除。
8. `noeviction` 当内存不足以容纳新写入数据时，新写入操作会报错。(默认的方式)

#### 什么是缓存穿透、雪崩、击穿，如该如何解决这几个问题

##### 缓存穿透

**缓存穿透**是指，请求数据库或者缓存都**不存在**的数据，导致每一个请求都访问数据库。

1. 可以针对**请求参数**过滤，减少无效的请求。

2. 将**缓存内容设置为 null**，并制定一个合理的过期时间。
3. 第 2 点中的方案会浪费无效的内存，可以使用**布隆过滤器**解决。[示例方案](https://mp.weixin.qq.com/s/6rK72BoiNGbto8WIeLQuoA)

##### 缓存击穿

**缓存击穿**是指，请求某一个**热点数据**在不存在，导致大量请求访问数据库。

1. 设置数据**缓存时间永不过期**，可以根据物理过期时间和逻辑过期时间来控制。
2. 可以将热点数据通过**多种方式缓存**，Redis 不存在还可以通过其他的缓存方式读取。

##### 缓存雪崩

**缓存雪崩**是指，某一个时刻请求的缓存大面积失效，导致大量请求访问数据库。有可能是缓存过期时间设置比较集中导致。

1. 将**缓存的时间均匀分布**，避免缓存时间过于集中。
2. 针对热点数据可以不用设置过期时间，可以根据物理过期时间和逻辑过期时间来控制。
3. **多级缓存**，一级缓存和二级缓存都设置不同的缓存时间。

#### 什么是缓存预热，如何做缓存预热，什么是服务降级，如何做服务降级?

**缓存预热**是指系统上线后，**提前**将相关的缓存数据**加载**到缓存系统。避免在用户请求的时候，先查询数据库，然后再将数据缓存的问题，用户直接查询事先被预热的缓存数据。

如果不进行预热，那么 Redis 初始状态数据为空，系统上线初期，对于高并发的流量，都会访问到数据库中， 对数据库造成流量的压力。

1. 数据量不大的时候，工程启动的时候进行加载缓存动作。
2. 数据量大的时候，设置一个定时任务脚本，进行缓存的刷新。
3. 数据量太大的时候，优先保证热点数据进行提前加载到缓存。

**缓存降级**是指缓存失效或缓存服务器挂掉的情况下，不去访问数据库，直接返回默认数据或访问服务的内存数据。

降级一般是有损的操作，所以尽量减少降级对于业务的影响程度。在项目实战中通常会将部分热点数据缓存到服务的内存中，这样一旦缓存出现异常，可以直接使用服务的内存数据，从而避免数据库遭受巨大压力。

### 原理

#### Redis 为什么读写数据快

1. 数据的读写都是基于**内存**操作。
2. **IO 多路复用**

3. **单线程**模式。
   - Redis 的瓶颈不在线程，不在获取 CPU 的资源，所以如果使用多线程就会带来多余的资源占用。比如上下文切换、资源竞争、锁的操作。
   - **上下文的切换**：上下文其实不难理解，它就是 **CPU 寄存器**和**程序计数器**。主要的作用就是存放没有被分配到资源的线程。
     - 多线程操作的时候，总有线程获取到资源，也总有线程需要等待获取资源，这个时候，等待获取资源的线程就需要被挂起，也就是我们的寄存。这个时候我们的上下文就产生了，当我们的上下文再次被唤起，得到资源的时候，就是我们上下文的切换。
   - **竞争资源**：竞争资源相对来说比较好理解，CPU 对上下文的切换其实就是一种资源分批，但是在切换之前，到底切换到哪一个上下文，就是资源竞争的开始。在 redis 中由于是单线程的，所以所有的操作都不会涉及到资源的竞争。
   - **锁的消耗**：对于多线程的情况来讲，不能回避的就是锁的问题。如果说多线程操作出现并发，有可能导致数据不一致，或者操作达不到预期的效果。这个时候我们就需要锁来解决这些问题。当我们的线程很多的时候，就需要不断的加锁，释放锁，该操作就会消耗掉我们很多的时间。

### 线程模型

####  Redis 是单线程吗？

Redis 单线程指的是「**接收客户端请求 -> 解析请求 -> 进行数据读写等操作 -> 发送数据给客户端」这个过程是由一个线程（主线程）来完成的**，这也是我们常说 Redis 是单线程的原因。

但是，**Redis 程序并不是单线程的**，Redis 在启动的时候，是会**启动后台线程**（BIO）的：

- Redis 在 2.6 版本，会启动 2 个后台线程，分别处理关闭文件、AOF 刷盘这两个任务；
- Redis 在 4.0 版本之后，新增了一个新的后台线程，用来异步释放 Redis 内存，也就是 lazyfree 线程。
  - 例如执行 `unlink key` / `flushdb async` / `flushall async` 等命令，会把这些删除操作交给后台线程来执行，好处是不会导致 Redis 主线程卡顿。
  - 因此，当我们要删除一个大 key 的时候，不要使用 del 命令删除，因为 del 是在主线程处理的，这样会导致 Redis 主线程卡顿，因此**我们应该使用 unlink 命令来异步删除大 key**。

之所以 Redis 为「关闭文件、AOF 刷盘、释放内存」这些任务创建单独的线程来处理，是因为这些任务的操作都是很耗时的，如果把这些任务都放在主线程来处理，那么 Redis 主线程就很容易发生阻塞，这样就无法处理后续的请求了。

后台线程相当于一个消费者，生产者把耗时任务丢到任务队列中，消费者（BIO）不停轮询这个队列，拿出任务就去执行对应的方法即可。

![image-20220907160719297](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907160719297.png)

关闭文件、AOF 刷盘、释放内存这三个任务都有各自的任务队列：

- BIO_CLOSE_FILE，关闭文件任务队列：当队列有任务后，后台线程会调用 `close(fd)` ，将文件关闭；
- BIO_AOF_FSYNC，AOF 刷盘任务队列：当 AOF 日志配置成 everysec 选项后，主线程会把 AOF 写日志操作封装成一个任务，也放到队列中。当发现队列有任务后，后台线程会调用 `fsync(fd)`，将 AOF 文件刷盘，
- BIO_LAZY_FREE，lazy free 任务队列：当队列有任务后，后台线程会 `free(obj)` 释放对象 / `free(dict)` 删除数据库所有对象 / `free(skiplist)` 释放跳表对象；

#### Redis 单线程模式是怎样的？

Redis 6.0 版本之前的单线模式如下图：

![redis单线程模型.drawio](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/redis%E5%8D%95%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B.drawio.webp)

图中的蓝色部分是一个事件循环，是由主线程负责的，可以看到网络 I/O 和命令处理都是单线程。 Redis 初始化的时候，会做下面这几件事情：

- 首先，调用 `epoll_create()` 创建一个 epoll 对象和调用 `socket()` 一个服务端 socket
- 然后，调用 `bind()` 绑定端口和调用 `listen()` 监听该 socket；
- 然后，将调用 `epoll_ctl()` 将 listen socket 加入到 epoll，同时注册「连接事件」处理函数。

初始化完后，主线程就进入到一个**事件循环函数**，主要会做以下事情：

- 首先，先调用**处理发送队列函数**，看是发送队列里是否有任务，如果有发送任务，则通过 write 函数将客户端发送缓存区里的数据发送出去，如果这一轮数据没有发送完，就会注册写事件处理函数，等待 epoll_wait 发现可写后再处理 。
- 接着，调用 epoll_wait 函数等待事件的到来：
  - 如果是**连接事件**到来，则会调用**连接事件处理函数**，该函数会做这些事情：调用 accpet 获取已连接的 socket -> 调用 epoll_ctl 将已连接的 socket 加入到 epoll -> 注册「读事件」处理函数；
  - 如果是**读事件**到来，则会调用**读事件处理函数**，该函数会做这些事情：调用 read 获取客户端发送的数据 -> 解析命令 -> 处理命令 -> 将客户端对象添加到发送队列 -> 将执行结果写到发送缓存区等待发送；
  - 如果是**写事件**到来，则会调用**写事件处理函数**，该函数会做这些事情：通过 write 函数将客户端发送缓存区里的数据发送出去，如果这一轮数据没有发送完，就会继续注册写事件处理函数，等待 epoll_wait 发现可写后再处理 。

####  Redis 采用单线程为什么还这么快？

官方使用基准测试的结果是，**单线程的 Redis 吞吐量可以达到 10W/每秒**，如下图所示：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220907161202011.png" alt="image-20220907161202011" style="zoom: 50%;" />

之所以 Redis 采用单线程（网络 I/O 和执行命令）那么快，有如下几个原因：

- Redis 的大部分操作**都在内存中完成**，并且采用了高效的数据结构，因此 Redis 瓶颈可能是机器的内存或者网络带宽，而并非 CPU，既然 CPU 不是瓶颈，那么自然就采用单线程的解决方案了；
- Redis 采用单线程模型可以**避免了多线程之间的竞争**，省去了多线程切换带来的时间和性能上的开销，而且也不会导致死锁问题。
- Redis 采用了 **I/O 多路复用机制**处理大量的客户端 Socket 请求，IO 多路复用机制是指一个线程处理多个 IO 流，就是我们经常听到的 select/epoll 机制。简单来说，在 Redis 只运行单线程的情况下，该机制允许内核中，同时存在多个监听 Socket 和已连接 Socket。内核会一直监听这些 Socket 上的连接请求或数据请求。一旦有请求到达，就会交给 Redis 线程处理，这就实现了一个 Redis 线程处理多个 IO 流的效果。

#### Redis 6.0 之后为什么引入了多线程？

虽然 Redis 的主要工作（网络 I/O 和执行命令）一直是单线程模型，但是**在 Redis 6.0 版本之后，也采用了多个 I/O 线程来处理网络请求**，这是因为随着网络硬件的性能提升，Redis 的性能瓶颈有时会出现在网络 I/O 的处理上。

所以为了提高网络 I/O 的并行度，Redis 6.0 **对于网络 I/O 采用多线程来处理**。**但是对于命令的执行，Redis 仍然使用单线程来处理。**

> Redis 官方表示，Redis 6.0 版本引入的多线程 I/O 特性对性能提升至少是一倍以上。

Redis 6.0 版本支持的 I/O 多线程特性，默认情况下 I/O 多线程只针对发送响应数据（write client socket），并不会以多线程的方式处理读请求（read client socket）。要想开启多线程处理客户端读请求，就需要把 redis.conf 配置文件中的 io-threads-do-reads 配置项设为 yes。

```c
//读请求也使用io多线程
io-threads-do-reads yes 
```

同时， redis.conf 配置文件中提供了 IO 多线程个数的配置项。

```c
// io-threads N，表示启用 N-1 个 I/O 多线程（主线程也算一个 I/O 线程）
io-threads 4 
```

关于线程数的设置，官方的建议是如果为 4 核的 CPU，建议线程数设置为 2 或 3，如果为 8 核 CPU 建议线程数设置为 6，线程数一定要小于机器核数，线程数并不是越大越好。

因此， Redis 6.0 版本之后，Redis 在启动的时候，默认情况下会创建 6 个线程：

- Redis-server ： Redis 的主线程，主要负责执行命令；
- bio_close_file、bio_aof_fsync、bio_lazy_free：三个后台线程，分别异步处理关闭文件任务、AOF 刷盘任务、释放内存任务；
- io_thd_1、io_thd_2、io_thd_3：三个 I/O 线程，io-threads 默认是 4 ，所以会启动 3（4 - 1）个 I/O 多线程，用来分担 Redis 网络 I/O 的压力。
