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

## Redis 命令

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

### Set

- Set 类型是一种**无顺序**的字符串集合，且元素是唯一的

- Set 类型的底层是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。

Set 类型主要应用于：在某些场景，如社交场景中，通过交集、并集和差集运算，通过 Set 类型可以非常方便地查找共同好友、共同关注和共同偏好等社交关系。

#### sadd 命令

添加一个 string 元素到 key 对应的 set 集合中，成功返回 1，如果元素已经在集合中返回 0。

```
sadd key member
```

例

```shell
redis 127.0.0.1:6379> sadd wuhu redis
(integer) 1
redis 127.0.0.1:6379> sadd wuhu mongodb
(integer) 1
redis 127.0.0.1:6379> sadd wuhu rabbitmq
(integer) 1
redis 127.0.0.1:6379> sadd wuhu rabbitmq
(integer) 0
redis 127.0.0.1:6379> smembers wuhu

1) "redis"
2) "rabbitmq"
3) "mongodb"
```

> 以上实例中 rabbitmq 添加了两次，但根据集合内元素的唯一性，第二次插入的元素将被忽略。

#### 操作命令

- SADD / SPOP / SMOVE / SCARD
- SINTER / SDIFF / SDIFFSTORE / SUNION

### Zset

> sorted set：有序集合

- ZSet 是一种有序集合类型，**每个元素都会关联一个 double 类型的分数权值**，通过这个权值来为集合中的成员进行从小到大的**排序**。

- 与 Set 类型一样，其底层也是通过哈希表实现的。
- zset 的成员是唯一的,但**分数 (score) 却可以重复**

#### zadd 命令

添加元素到集合，元素在集合中存在则更新对应 score

```shell
zadd key score member
```

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
- ZINTER / ZDIFF / ZDIFFSTORE / ZUNION

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

Redis Stream 主要用于**消息队列**（MQ，Message Queue），Redis 本身是有一个 Redis 发布订阅 (pub/sub) 来实现消息队列的功能，但它有个缺点就是消息无法持久化，如果出现网络断开、Redis 宕机等，消息就会被丢弃。

简单来说**发布订阅 (pub/sub) 可以分发消息，但无法记录历史消息**。

而 Redis Stream 提供了消息的**持久化**和**主备复制**功能，可以让任何客户端访问任何时刻的数据，并且能记住每一个客户端的访问位置，还能保证消息不丢失。

Redis Stream 的结构如下所示，它有一个消息链表，将所有加入的消息都串起来，每个消息都有一个唯一的 ID 和对应的内容：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/en-us_image_0167982791.png)

每个 Stream 都有唯一的名称，它就是 Redis 的 key，在我们首次使用 xadd 指令追加消息时自动创建。

上图解析：

- **Consumer Group** ：消费组，使用 XGROUP CREATE 命令创建，一个消费组有多个消费者 (Consumer)。
- **last_delivered_id** ：游标，每个消费组会有个游标 last_delivered_id，任意一个消费者读取了消息都会使游标 last_delivered_id 往前移动。
- **pending_ids** ：消费者 (Consumer) 的状态变量，作用是维护消费者的未确认的 id。 pending_ids 记录了当前已经被客户端读取的消息，但是还没有 ack (Acknowledge character：确认字符）。

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

#### XREADGROUP GROUP

使用 XREADGROUP GROUP 读取消费者组中的消息

```shell
XREADGROUP GROUP group consumer [COUNT count] [BLOCK milliseconds] [NOACK] STREAMS key [key ...] ID [ID ...]
```

- **group** ：消费组名
- **consumer** ：消费者名
- **count** ： 读取数量
- **milliseconds** ： 阻塞毫秒数
- **key** ： 队列名
- **ID** ： 消息 ID

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

### Redis 使用场景

1. 数据缓存 (用户信息、商品数量、文章阅读数量)

2. 消息推送 (站点的订阅)

3. 队列 (削峰、解耦、异步)

4. 排行榜 (积分排行)

5. 社交网络 (共同好友、互踩、下拉刷新)

6. 计数器 (商品库存，站点在线人数、文章阅读、点赞)

7. 基数计算

8. GEO 计算

### Redis 功能特点

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

### Redis 各种数据类型的底层数据结构

1. string 底层数据结构为简单字符串。
2. list 底层数据结构为 ziplist 和 linkedlist
3. hash 底层数据结构为 ziplist 和 hashtable
4. set 底层数据结构为 intset 和 hashtable
5. sorted set 底层数据结构为 ziplist 和 skiplist

### 如何使用Redis实现队列功能

1. 可以使用 list 实现普通队列，lpush 添加到嘟列，lpop 从队列中读取数据。
2. 可以使用 zset 定期轮询数据，实现延迟队列。
3. 可以使用发布订阅实现多个消费者队列。
4. 可以使用 stream 实现队列。(推荐使用该方式实现)。

### 你是怎么用 Redis 做异步队列的

1. 一般使用 list 结构作为队列，rpush 生产消息，lpop 消费消息。当 lpop 没有消息的时候，要适当 sleep 一会再重试。
2. 如果对方追问可不可以不用 sleep 呢？
   - list 还有个指令叫 blpop，在没有消息的时候，它会阻塞住直到消息到来。
3. 如果对方追问能不能生产一次消费多次呢？
   - 使用 pub/sub 主题订阅者模式，可以实现 1:N 的消息队列。
4. 如果对方追问 pub/sub 有什么缺点？
   - 在消费者下线的情况下，**生产的消息会丢失**，可以使用 Redis6 增加的 **stream 数据类型**，也可以使用专业的**消息队列如 rabbitmq 等**。
5. 如果对方追问 redis 如何实现延时队列
   - **使用sortedset，拿时间戳作为score**，消息内容作为 key 调用 zadd 来生产消息，消费者用 zrangebyscore 指令获取 N 秒之前的数据轮询进行处理。

### 使用 Redis Stream 做队列，比list，zset和发布订阅有什么区别

1. list 可以使用 lpush 向队列中添加数据，lpop 可以向队列中读取数据。list 作为消息队列无法实现一个消息多个消费者。如果出现消息处理失败，需要手动回滚消息。
2. zset 在添加数据时，需要添加一个分值，可以根据该分值对数据进行排序，实现延迟消息队列的功能。消息是否消费需要额外的处理。
3. 发布订阅可以实现多个消费者功能，但是发布订阅无法实现数据持久化，容易导致数据丢失。并且开启一个订阅者无法获取到之前的数据。
4. stream 借鉴了常用的 MQ 服务，添加一个消息就会产生一个消息 ID，每一个消息 ID 下可以对应多个消费组，每一个消费组下可以对应多个消费者。可以实现多个消费者功能，同时支持 ack 机制，减少数据的丢失情况。也是支持数据值持久化和主从复制功能。

### 设计一个网站每日、每月和每天的 PV、UV 该怎么设计

实现这样的功能，如果只是统计一个汇总数据，推荐使用 **HyperLogLog** 数据类型。

Redis HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小的。

在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64^ 个不同元素的基 数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

### 如何使用 Redis 实现附近距离检索功能

实现距离检索，可以使用 Redis 中的 **GEO 数据类型**。

GEO 主要用于存储地理位置信息，并对存储的信息进行操作，该功能在 Redis 3.2 版本新增。

但是 GEO 适合精度不是很高的场景。

由于 GEO 是在内存中进行计算，具备计算速度快的特点。

### 如何使用 Redis 实现一个分布式锁功能

使用 Redis 实现分布式锁，可以使用 `set key value` + `expire ttl` 实现，但是这两个命令分开执行不是一个原子操作，因此推荐使用 `set key vale nx ttl`，该命令属于原子操作。

### 使用 Redis 解决秒杀超卖，该选择什么数据类型，为什么选择该数据类型

1. 在秒杀场景下，超卖是一个非常严重的问题。常规的逻辑是先查询库存在减少库存。但在秒杀场景中，无法保证减少库存的过程中有其他的请求读取了未减少的库存数据。
2. 由于 Redis 是单线程的执行，同一时刻只有一个线程进行操作。因此可以使用 Redis 来实现秒杀减少库存。
3. 在 Redis 的数据类型中，可以使用 lpush，decr 命令实现秒杀减少库存。该命令属于原子操作。

**具体的步骤是**

1. 在系统**初始化**时，将商品的**库存数量加载到Redis缓存中**；
2. 接收到**秒杀请求**时，在**Redis中进行预减库存**，当 Redis 中的库存不足时，直接返回秒杀失败，否则继续进行第 3 步；
3. 将请求放入**异步队列**中，返回正在排队中；
4. 服务端异步队列将请求出队，出队成功的请求可以生成秒杀订单，减少数据库库存，返回秒杀订单详情。
5. 用户在客户端申请秒杀请求后，进行**轮询**，查看是否秒杀成功，秒杀成功则进入秒杀订单详情，否则秒杀失败。

### 如何使用 Redis 实现系统用户签到功能

1. 使用 Redis 实现用户签到可以使用 **bitmap** 实现。bitmap 底层数据存储的是 1 否者 0，占用内存小。
2. Redis 提供的数据类型 BitMap（位图），每个 bit 位对应 0 和 1 两个状态。虽然内部还是采用 String 类型存储，但 Redis 提供了一些指令用于直接操作 BitMap，可以把它看作一个 bit 数组，数组的下标就是偏移量。
3. 它的优点是内存开销小，效率高且操作简单，很适合用于签到这类场景。
4. 缺点在于位计算和位表示数值的局限。如果要用位来做业务数据记录，就不要在意 value 的值。

### 如何使用 Redis 实现一个积分排行功能

1. 使用 Redis 实现积分排行，可以使用 **zset** 数据类型。
2. zset 在添加数据时，需要添加一个分值，将积分作为分值，值作为用户 ID，根据该分值对数据进行排序。

### Redis 如何解决事务之间的冲突

1. 使用 watch 监听 key 变化，当 key 发生变化，事务中的所有操作都会被取消。
2. 使用乐观锁，通过版本号实现。
3. 使用悲观锁，每次开启事务时，都添加一个锁，事务执行结束之后释放锁。

悲观锁

- 悲观锁(Pessimistic Lock)，顾名思义，就是很悲观，每次去拿数据的时候都认为别人会修改，所以每 次在拿数据的时候都会上锁，这样别人拿到这个数据就会 block 直到它拿到锁。传统的关系型数据库里面 就用到了很多这种锁机制，比如行锁、表锁、读锁、写锁等，都是在做操作之前先上锁。

乐观锁

- 乐观锁(Optimistic Lock)，顾名思义，就是很乐观，每次去那数据的时候都认为别人不会修改，所以不会上锁；但是在**修改**的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号等机 制。乐观锁适用于多读的应用类型，这样可以提高吞吐量。redis 就是使用这种 check-and-set 机制实现 事务的。

watch 监听

- 在执行 multi 之前，先执行` watch key1 [key2 ...]`，可以监视一个或者多个 key，若在事务的 exec 命令之前，这些 key 对应的值被其他命令所改动了，那么事务中所有命令都将被打断，即事务所有操作将被取消执行。