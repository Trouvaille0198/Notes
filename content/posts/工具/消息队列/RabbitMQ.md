---
title: "RabbitMQ"
date: 2022-8-2
draft: false
author: "MelonCholi"
tags: [快速入门]
categories: [工具]
---

# RabbitMQ

## 消息队列

### what

**消息**指的是两个应用间传递的数据。数据的类型有很多种形式，可能只包含文本字符串，也可能包含嵌入对象。

**“消息队列(Message Queue)”是在消息的传输过程中保存消息的容器**。在消息队列中，通常有生产者和消费者两个角色。生产者只负责发送数据到消息队列，谁从消息队列中取出数据处理，他不管。消费者只负责从消息队列中取出数据处理，他不管这是谁发送的数据。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzE5LzE3MzY3NTNjNDc1M2M2Zjk)

### why

主要有三个作用：

- **解耦**
  - 假设有系统 B、C、D 都需要系统 A 的数据，于是系统 A 调用三个方法发送数据到 B、C、D。
  - 这时，系统 D 不需要了，那就需要在系统 A 把相关的代码删掉。
  - 假设这时有个新的系统 E 需要数据，这时系统 A 又要增加调用系统 E 的代码。
  - 为了降低这种强耦合，就可以使用 MQ，**系统 A 只需要把数据发送到 MQ，其他系统如果需要数据，则从 MQ 中获取即可**。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzE5LzE3MzY3OGM3YTgxY2MxYzA)

- **异步**。
  - 一个客户端请求发送进来，系统 A 会调用系统 B、C、D 三个系统，同步请求的话，响应时间就是系统 A、B、C、D 的总和，也就是 800ms。
  - **如果使用 MQ，系统 A 发送数据到 MQ，然后就可以返回响应给客户端，不需要再等待系统 B、C、D 的响应，可以大大地提高性能**。
  - 对于一些非必要的业务，比如发送短信，发送邮件等等，就可以采用 MQ

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzE5LzE3MzY3OTQ1YThjNGRmNzM)

- **削峰**
  - 这其实是 MQ 一个很重要的应用。假设系统 A 在某一段时间请求数暴增，有 5000 个请求发送过来，系统 A 这时就会发送 5000 条 SQL 进入 MySQL 进行执行，高并发的请求容易导致系统瘫痪。
  - **如果使用 MQ，系统 A 不再是直接发送 SQL 到数据库，而是把数据发送到 MQ，MQ 短时间积压数据是可以接受的，然后由消费者每次拉取 2000 条进行处理，防止在请求峰值时期大量的请求直接发送到 MySQL 导致系统崩溃**

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzE5LzE3MzY3YTlkOTAyY2NhNGY)

## RabbitMQ 介绍

RabbitMQ 是一款使用 Erlang 语言开发的，实现 **AMQP (高级消息队列协议)** 的开源消息中间件。它有如下特点：

- 可靠性（Reliablity）。支持持久化，传输确认，发布确认等保证了 MQ 的可靠性。
- 灵活的路由分发策略（Flexible Routing）。这应该是 RabbitMQ 的一大特点。在消息进入 MQ 前由 Exchange (交换机) 进行路由消息。
  - 分发消息策略有：简单模式、工作队列模式、发布订阅模式、路由模式、通配符模式。
- 支持集群（Clustering）。多台 RabbitMQ 服务器可以组成一个集群，形成一个逻辑 Broker。
- 高可用（Highly Avaliable Queues）。队列可以在集群中的机器上进行镜像，使得在部分节点出问题的情况下队列仍然可用。
- 多种协议（Multi-protocol）。RabbitMQ 支持多种消息队列协议，比如 STOMP、MQTT 等等。
- 支持多种语言客户端（Many Clients）。RabbitMQ 几乎支持所有常用编程语言，包括 Java、.NET、Ruby 等等。
- 可视化管理界面（Management UI）。RabbitMQ 提供了一个易用的用户界面，使得用户可以监控和管理消息 Broker。
- 跟踪机制（Tracing）：如果消息异常，RabbitMQ 提供了消息的跟踪机制，使用者可以找出发生了什么。
- 插件机制（Plugin System）。RabbitMQ 提供了许多插件，可以通过插件进行扩展，也可以编写自己的插件。

## 安装

#### Linux

如果您使用的是 Ubuntu 或 Debian ，可以通过以下命令进行安装 RabbitMQ：

```shell
$ sudo apt-get install rabbitmq-server
```

如果在 Docker 中运行 RabbitMQ ，可以使用以下命令：

```shell
$ docker run -d -p 5462:5462 rabbitmq
```

命令执行完毕之后，中间人（Broker）会在后台继续运行，准备输出一条 *Starting rabbitmq-server: SUCCESS* 的消息。

#### windows

##### 安装 erLang 语言，配置环境变量

erlang [官网](http://www.erlang.org/downloads)下载

装完之后，配置环境变量。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIxLzE3MzcxYjYzZTNkZDdmNzM)

使用 cmd 命令，输入 erl -version 验证：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIxLzE3MzcxYmFjNDk0MzgxZDY)

#### 安装 RabbitMQ 服务端

在 RabbitMQ 的 [gitHub 项目](https://github.com/rabbitmq/rabbitmq-server/releases/tag/v3.7.3)中，下载 window 版本的服务端安装包。

接着到双击安装，一直点下一步安装即可，安装完成后，找到安装目录：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIxLzE3MzcxYzViY2NmNGY5ZDU)

在此目录下打开 cmd 命令，输入 `rabbitmq-plugins enable rabbitmq_management` 命令安装管理页面的插件：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIxLzE3MzcxYzc5ODk4OTk2NTc)

然后双击 rabbitmq-server.bat 启动脚本，然后打开服务管理可以看到 RabbitMQ 正在运行：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIxLzE3MzcxY2E1ZjQ3ZmNlOGI)

这时，打开浏览器输入 [http://localhost:15672](http://localhost:15672/)，账号密码默认是：guest/guest

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIxLzE3MzcxY2I2NDJhZmMzMDY)

到这一步，安装就大功告成了！

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIxLzE3MzcxY2M2MjAwNjM2OGE)



## RabbitMQ 中的组成部分

- Broker：消息队列服务进程。此进程包括两个部分：Exchange 和 Queue。
  - Exchange：消息队列交换机。**按一定的规则将消息路由转发到某个队列**。
  - Queue：消息队列，存储消息的队列。
  - Banding：绑定，用于 Queue 和 Exchange 之间的关联。一个绑定就是基于路由键将交换机和消息队列连接起来的路由规则，所以可以将交换器理解成一个由绑定构成的路由表。
- Producer：消息生产者。生产方客户端将消息同交换机路由发送到队列中。
- Consumer：消息消费者。消费队列中存储的消息。
- Connect：连接，生产者与 RMQ Server 之间建立的 TCP 连接。
- Channel：信道，一条连接可包含多条信道，不同信道之间通信互不干扰。考虑下多线程应用场景，每个线程对应一条信道，而不是对应一条连接，这样可以提高性能。
- body：消息主体，要传递的数据。

这些组成部分是如何协同工作的呢，大概的流程如下，请看下图：

![RMQ工作原理图](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20180723131624312)

## Exchange 的类型

从上面的工作流程可以看出，实际上有个关键的组件 Exchange，因为**消息发送到 RabbitMQ 后首先要经过 Exchange 路由才能找到对应的 Queue**

实际上 Exchange 类型有四种，根据不同的类型工作的方式也有所不同：Direct Exchange、Fanout exchange、Topic exchange、Headers exchange

### Direct Exchange

> 直接匹配，用于支持路由模式（Routing）

直接匹配交换器会**对比路由键和绑定键**，如果路由键和绑定键完全相同，则把消息转发到绑定键所对应的队列中。

简单点说就是**一对一的，点对点的**发送。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIyLzE3Mzc3M2ZlNDU1Njk4ODU)

![直接匹配交换器](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/2018072314080058)

### Fanout exchange

> 扇出，用于支持发布、订阅模式（pub/sub）

这种类型的交换机需要将队列绑定到交换机上。**交换器把消息转发到所有与之绑定的队列中。**

很像子网广播，每台子网内的主机都获得了一份复制的消息。

扇出类型交换器会屏蔽掉路由键、绑定键的作用。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzIzLzE3Mzc3NDIwM2VlNWFmZDM)

![扇出交换器](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20180723140239113)

### Topic Exchange

> 模式匹配

直接翻译的话叫做主题交换机，如果从用法上面翻译可能叫**通配符交换机**会更加贴切。

这种交换机是使用通配符去匹配，路由到对应的队列。通配符有两种："*" 、 "#"。需要注意的是**通配符前面必须要加上 "." 符号。**

- `*` 符号：有且只匹配一个词。比如 `a.*`可以匹配到 "a.b"、"a.c"，但是匹配不了 "a.b.c"。

- `#` 符号：匹配一个或多个词。比如 "rabbit.#" 既可以匹配到 "rabbit.a.b"、"rabbit.a"，也可以匹配到 "rabbit.a.b.c"。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzI0LzE3MzdjYzJlMzVhYmIwYzI)

![模式匹配交换器](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/2018072314150187)

比较常用的就是以上三种：直连 (DirectExchange)，发布订阅 (FanoutExchange)，通配符 (TopicExchange)。熟练运用这三种交换机类型，基本上可以解决大部分的业务场景。

实际上稍微思考一下，可以发现通配符 (TopicExchange) 这种模式其实是可以达到直连 (DirectExchange) 和发布订阅 (FanoutExchange) 这两种的效果的。

FanoutExchange 不需要绑定 routingKey，所以性能相对 TopicExchange 会好一点。

### Headers Exchange

这种交换机用的相对没这么多。**它跟上面三种有点区别，它的路由不是用 routingKey 进行路由匹配，而是在匹配请求头中所带的键值进行路由**。如图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzI1LzE3Mzg0OTk2NzFlMTk1NWU)

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly91c2VyLWdvbGQtY2RuLnhpdHUuaW8vMjAyMC83LzI1LzE3Mzg0OWEwMTRkNTc2ZTU)

创建队列需要设置绑定的头部信息，有两种模式：**全部匹配和部分匹配**。如上图所示，交换机会根据生产者发送过来的头部信息携带的键值去匹配队列绑定的键值，路由到对应的队列。

### 默认 exchange

当交换器名称为空时，表示使用默认交换器（空的意思是空字符串）

默认交换器是一个特殊的交换器，他无需进行绑定操作，可以以直接匹配的形式直接把消息发送到任何队列中。

下图两种模式均采用了默认交换器：

![点到多点](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20180723143901493)

两个消费者从一个队列取数据时，会产生竞争条件。此时消息只能给其中的一个消费者。

如果两个消费者均没有在收到消息后做应答操作，则消息会平均发送给两个消费者。如果收到消息后做了应答操作，则会采取能者多劳的模式。