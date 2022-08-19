---
title: "kafka"
date: 2022-08-19
draft: false
author: "MelonCholi"
tags: [快速入门]
categories: [工具]
---

# kafka

Kafka 是一种高吞吐量的分布式发布订阅消息系统，它可以处理消费者规模的网站中的所有动作流数据，具有高性能、持久化、多副本备份、横向扩展能力

## 基础架构

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-4692429e9184ed4a93911fa3a1361d28_1440w.jpg)

- **Producer**：生产者，消息的产生者，是消息的入口。

- **kafka cluster**：
  - **Broker**：Broker 是 kafka**实例**，每个服务器上有一个或多个 kafka 的实例，我们姑且认为每个 broker 对应一台服务器。
    - 每个 kafka 集群内的 broker 都有一个**不重复**的编号，如图中的 broker-0、broker-1 等……
  - **Topic**：消息的主题，可以理解为**消息的分类**，kafka 的数据就保存在 topic。在每个 broker 上都可以创建多个 topic。
  - **Partition**：Topic 的**分区**，每个 topic 可以有多个分区，分区的作用是做负载，提高 kafka 的吞吐量。
    - 同一个 topic 在不同的分区的数据是不重复的，partition 的表现形式就是一个一个的文件夹！
  - **Replication**:每一个分区都有多个**副本**，副本的作用是做备胎。
    - 当主分区（Leader）故障的时候会选择一个备胎（Follower）上位，成为 Leader。
    - 在 kafka 中默认副本的最大数量是 10 个，且副本的数量不能大于 Broker 的数量，
    - follower 和 leader 绝对是在不同的机器，同一机器对同一个分区也只可能存放一个副本（包括自己）。

**Message**：每一条发送的消息主体。

**Consumer**：消费者，即消息的消费方，是消息的出口。

**Consumer Group**：我们可以将多个消费组组成一个消费者组，在 kafka 的设计中同一个分区的数据只能被消费者组中的某一个消费者消费。同一个消费者组的消费者可以消费同一个 topic 的不同分区的数据，这也是为了提高 kafka 的吞吐量！

**Zookeeper**：kafka 集群依赖 zookeeper 来保存集群的的元信息，来保证系统的可用性。

## 工作流程分析

### **发送数据**

我们看上面的架构图中，producer 就是生产者，是数据的入口。注意看图中的红色箭头，Producer 在写入数据的时候**永远的找leader**，不会直接将数据写入 follower！那 leader 怎么找呢？写入的流程又是什么样的呢？我们看下图：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-b7e72e9c5b9971e89ec174a2c2201ed9_1440w.jpg)

发送的流程就在图中已经说明了；需要注意的一点是，消息写入 leader 后，follower 是**主动**的去 leader 进行同步的

producer 采用 push 模式将数据发布到 broker，每条消息追加到分区中，顺序写入磁盘，所以保证**同一分区**内的数据是有序的！写入示意图如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-87d558aaa349bf920711b9c157e11f6a_1440w.jpg)

#### 分区的目的

上面说到数据会写入到不同的分区，那 kafka 为什么要做分区呢？分区的主要目的是：

1. **方便扩展**。因为一个 topic 可以有多个 partition，所以我们可以通过扩展机器去轻松的应对日益增长的数据量。
2. **提高并发**。以 partition 为读写单位，可以多个消费者同时消费数据，提高了消息的处理效率。

#### 分区的寻找

熟悉负载均衡的朋友应该知道，当我们向某个服务器发送请求的时候，服务端可能会对请求做一个负载，将流量分发到不同的服务器，那在 kafka 中，如果某个 topic 有多个 partition，producer 又怎么知道该将数据发往哪个 partition 呢？kafka 中有几个原则：

1. partition 在写入的时候可以指定需要写入的 partition，如果有指定，则写入对应的 partition。

2. 如果没有指定 partition，但是设置了数据的 key，则会根据 key 的值 hash 出一个 partition。

3. 如果既没指定 partition，又没有设置 key，则会轮询选出一个 partition。

#### 保证消息不丢失

保证消息不丢失是一个消息队列中间件的基本保证，那 producer 在向 kafka 写入消息的时候，怎么保证消息不丢失呢？通过**ACK应答机制**！

在 producer 向队列写入数据的时候可以设置参数来确定是否确认 kafka 接收到数据，这个参数可设置的值为 `0`，`1`，`all`

- 0 代表 producer 往集群发送数据不需要等到集群的返回，不确保消息发送成功。安全性最低但是效率最高。
- 1 代表 producer 往集群发送数据只要 leader 应答就可以发送下一条，只确保 leader 发送成功。
- all 代表 producer 往集群发送数据需要所有的 follower 都完成从 leader 的同步才会发送下一条，确保 leader 发送成功和所有的副本都完成备份。安全性最高，但是效率最低。

最后要注意的是，如果往不存在的 topic 写数据，能不能写入成功呢？kafka 会自动创建 topic，分区和副本的数量根据默认配置都是 1。

### **保存数据**

Producer 将数据写入 kafka 后，集群就需要对数据进行保存了！kafka 将数据保存在磁盘，可能在我们的一般的认知里，写入磁盘是比较耗时的操作，不适合这种高并发的组件。Kafka 初始会单独开辟一块磁盘空间，顺序写入数据（效率比随机写入高）。

**Partition 结构**

前面说过了每个 topic 都可以分为一个或多个 partition，如果你觉得 topic 比较抽象，那 partition 就是比较具体的东西了！Partition 在服务器上的表现形式就是一个一个的文件夹，每个 partition 的文件夹下面会有多组 segment 文件，每组 segment 文件又包含.index 文件、.log 文件、.timeindex 文件（早期版本中没有）三个文件， log 文件就实际是存储 message 的地方，而 index 和 timeindex 文件为索引文件，用于检索消息。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-72e50c12fd9c6fbf58d3b5ca14c90623_1440w.jpg)

如上图，这个 partition 有三组 segment 文件，每个 log 文件的大小是一样的，但是存储的 message 数量是不一定相等的（每条的 message 大小不一致）。文件的命名是以该 segment 最小 offset 来命名的，如 000.index 存储 offset 为 0~368795 的消息，kafka 就是利用分段+索引的方式来解决查找效率的问题。

**Message结构**

上面说到 log 文件就实际是存储 message 的地方，我们在 producer 往 kafka 写入的也是一条一条的 message，那存储在 log 中的 message 是什么样子的呢？消息主要包含消息体、消息大小、offset、压缩类型……等等！我们重点需要知道的是下面三个：

1、 offset：offset 是一个占 8byte 的有序 id 号，它可以唯一确定每条消息在 parition 内的位置！

2、 消息大小：消息大小占用 4byte，用于描述消息的大小。

3、 消息体：消息体存放的是实际的消息数据（被压缩过），占用的空间根据具体的消息而不一样。

**存储策略**

无论消息是否被消费，kafka 都会保存所有的消息。那对于旧数据有什么删除策略呢？

1、 基于时间，默认配置是 168 小时（7 天）。

2、 基于大小，默认配置是 1073741824。

需要注意的是，kafka 读取特定消息的时间复杂度是 O(1)，所以这里删除过期的文件并不会提高 kafka 的性能！

### **消费数据**

消息存储在 log 文件后，消费者就可以进行消费了。在讲消息队列通信的两种模式的时候讲到过点对点模式和发布订阅模式。Kafka 采用的是点对点的模式，消费者主动的去 kafka 集群拉取消息，与 producer 相同的是，消费者在拉取消息的时候也是**找leader**去拉取。

多个消费者可以组成一个消费者组（consumer group），每个消费者组都有一个组 id！同一个消费组者的消费者可以消费同一 topic 下不同分区的数据，但是不会组内多个消费者消费同一分区的数据！！！是不是有点绕。我们看下图：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-75a79cba9cfafe5c2f4d5349acb72207_1440w.jpg)

图示是消费者组内的消费者小于 partition 数量的情况，所以会出现某个消费者消费多个 partition 数据的情况，消费的速度也就不及只处理一个 partition 的消费者的处理速度！如果是消费者组的消费者多于 partition 的数量，那会不会出现多个消费者消费同一个 partition 的数据呢？上面已经提到过不会出现这种情况！多出来的消费者不消费任何 partition 的数据。所以在实际的应用中，建议**消费者组的consumer的数量与partition的数量一致**！

在保存数据的小节里面，我们聊到了 partition 划分为多组 segment，每个 segment 又包含.log、.index、.timeindex 文件，存放的每条 message 包含 offset、消息大小、消息体……我们多次提到 segment 和 offset，查找消息的时候是怎么利用 segment+offset 配合查找的呢？假如现在需要查找一个 offset 为 368801 的 message 是什么样的过程呢？我们先看看下面的图：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-87051d884344edf9f8fd97a3dacb32d0_1440w.jpg)

1、 先找到 offset 的 368801message 所在的 segment 文件（利用二分法查找），这里找到的就是在第二个 segment 文件。

2、 打开找到的 segment 中的.index 文件（也就是 368796.index 文件，该文件起始偏移量为 368796+1，我们要查找的 offset 为 368801 的 message 在该 index 内的偏移量为 368796+5=368801，所以这里要查找的**相对offset**为 5）。由于该文件采用的是稀疏索引的方式存储着相对 offset 及对应 message 物理偏移量的关系，所以直接找相对 offset 为 5 的索引找不到，这里同样利用二分法查找相对 offset 小于或者等于指定的相对 offset 的索引条目中最大的那个相对 offset，所以找到的是相对 offset 为 4 的这个索引。

3、 根据找到的相对 offset 为 4 的索引确定 message 存储的物理偏移位置为 256。打开数据文件，从位置为 256 的那个地方开始顺序扫描直到找到 offset 为 368801 的那条 Message。

这套机制是建立在 offset 为有序的基础上，利用**segment**+**有序offset**+**稀疏索引**+**二分查找**+**顺序查找**等多种手段来高效的查找数据！至此，消费者就能拿到需要处理的数据进行处理了。那每个消费者又是怎么记录自己消费的位置呢？在早期的版本中，消费者将消费到的 offset 维护 zookeeper 中，consumer 每间隔一段时间上报一次，这里容易导致重复消费，且性能不好！在新的版本中消费者消费到的 offset 已经直接维护在 kafk 集群的__consumer_offsets 这个 topic 中！
