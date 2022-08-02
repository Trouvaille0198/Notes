---
title: "Go amqp 库"
date: 2022-08-02
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# amqp

amqp 主要实现了 RabbitMQ 的相关 API

```shell
go get -v github.com/streadway/amqp
```

## 生产者流程

1. 连接 Connection
2. 创建 Channel
3. 创建或连接一个交换器
4. 创建或连接一个队列
5. 交换器绑定队列
6. 投递消息
7. 关闭 Channel
8. 关闭 Connection

### 创建连接 Connection

```go
// connection
connection, err := amqp.Dial("amqp://guest:guest@localhost:5672/")
```

### 创建信道 Channel

```go
// channel
channel, err := connection.Channel()
```

### 创建交换器 Exchange

```go
err = channel.ExchangeDeclare("e1", "direct", true, false, false, true, nil)
```

- 该通道可能由于错误而关闭。 可以添加一个 NotifyClose 侦听器应对任何异常。
- 创建交换器还有一个差不多的方法 (ExchangeDeclarePassive)，他主要是假定交换已存在，并尝试连接到不存在的交换将导致 RabbitMQ 引发异常，可用于检测交换器的存在。

#### 参数

- `name` 交换机名称
- `kind` 交换机类型
- `durable` 持久化标识
- `autoDelete` 是否自动删除
- `internal` 是否是内置交换机
- `noWait` 是否等待服务器确认
- `args` 其它配置

#### 参数要点

- `autoDelete`
  - 自动删除功能必须要在交换器曾经绑定过队列或者交换器的情况下，处于不再使用的时候才会自动删除
  - 如果是刚刚创建的尚未绑定队列或者交换器的交换器或者早已创建只是未进行队列或者交换器绑定的交换器是不会自动删除的。

- `internal `
  - 内置交换器是一种特殊的交换器，这种交换器不能直接接收生产者发送的消息，只能作为类似于队列的方式绑定到另一个交换器，来接收这个交换器中路由的消息
  - 内置交换器同样可以绑定队列和路由消息，只是其接收消息的来源与普通交换器不同。

- `noWait`
  - 当 noWait 为 true 时，声明时无需等待服务器的确认。

### 创建队列 Queue

```go
q, err := channel.QueueDeclare("q1", true, false, false, true, nil)
```

创建队列还有一个差不多的方法 (QueueDeclarePassive)，他主要是假定队列已存在，并尝试连接到不存在的队列将导致 RabbitMQ 引发异常，可用于检测队列的存在。

#### 参数

- `name` 队列名称
- `durable` 持久化
- `autoDelete` 自动删除
- `exclusive` 排他
- `noWait` 是否等待服务器确认
- `args Table`

#### 要点

- exclusive 排他
  - 排他队列只对首次创建它的连接可见，排他队列是基于连接（Connection）可见的，并且该连接内的所有信道（Channel）都可以访问这个排他队列，在这个连接断开之后，该队列自动删除
  - 由此可见这个队列可以说是绑到连接上的，对同一服务器的其他连接不可见。
  - 同一连接中不允许建立同名的排他队列的这种排他优先于持久化，即使设置了队列持久化，在连接断开后，该队列也会自动删除。
  - 非排他队列不依附于连接而存在，同一服务器上的多个连接都可以访问这个队列。

- autoDelete 设置是否自动删除。
  - 为 true 则设置队列为自动删除。
  - 自动删除的前提是：至少有一个消费者连接到这个队列，之后所有与这个队列连接的消费者都断开时，才会自动删除。
  - 不能把这个参数错误地理解为:“当连接到此队列的所有客户端断开时，这个队列自动删除”，因为生产者客户端创建这个队列，或者没有消费者客户端与这个队列连接时，都不会自动删除这个队列。

### 为信道绑定交换器(和队列)

```go
err = channel.QueueBind("q1", "q1Key", "e1", true, nil)
```

参数解析：

- `name` 队列名称
- `key BindingKey` 根据交换机类型来设定
- `exchange` 交换机名称
- `noWait` 是否等待服务器确认
- `args Table`

### 为信道绑定交换器（可选）

```go
err = channel.ExchangeBind("dest", "q1Key", "src", false, nil)
```

参数解析：

- `destination` 目的交换器
- `key RoutingKey` 路由键
- `source` 源交换器
- `noWait` 是否等待服务器确认
- `args Table` 　其它参数

生产者发送消息至交换器 source 中，交换器 source 根据路由键找到与其匹配的另一个交换器 destination ，井把消息转发到 destination 中，进而存储在 destination 绑定的队列 queue 中，某种程度上来说 destination 交换器可以看作一个队列。

### 投递消息

```go
err = channel.Publish("e1", "q1Key", true, false, amqp.Publishing{
    Timestamp:   time.Now(),
    DeliveryMode: amqp.Persistent, //Msg set as persistent
    ContentType: "text/plain",
    Body:        []byte("Hello Golang and AMQP(Rabbitmq)!"),
})
```

参数解析：

- `exchange` 交换器名称
- `key RouterKey`
- `mandatory` 是否为无法路由的消息进行返回处理
- `immediate` 是否对路由到无消费者队列的消息进行返回处理 RabbitMQ 3.0 废弃
- `msg` 消息体

参数说明要点：

- `mandatory`
