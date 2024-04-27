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

### 在信道上创建交换器 Exchange

```go
func (ch *Channel) ExchangeDeclare(name, kind string, durable, autoDelete, internal, noWait bool, args Table) error

err = channel.ExchangeDeclare("e1", "direct", true, false, false, true, nil)
```

- 该通道可能由于错误而关闭。 可以添加一个 NotifyClose 侦听器应对任何异常。
- 创建交换器还有一个差不多的方法 (ExchangeDeclarePassive)，他主要是假定交换已存在，并尝试连接到不存在的交换将导致 RabbitMQ 引发异常，可用于检测交换器的存在。

#### 参数

- `name` 交换机名称
- `kind` 交换机类型，direct、fanout、topic、headers
- `durable` 是否持久化
  - 持久化表示会把交换器的配置存盘，当 RMQ Server 重启后，会自动加载交换器。

- `autoDelete` 是否自动删除
  - 至少有一条 channel 绑定才可以触发自动删除，当所有绑定都与交换器解绑后，会自动删除此交换器
  - 如果是刚刚创建的尚未绑定队列或者交换器的交换器或者早已创建只是未进行队列或者交换器绑定的交换器是不会自动删除的。

- `internal` 是否是内置交换机
  - 内置交换器是一种特殊的交换器，这种交换器不能直接接收生产者发送的消息，只能作为类似于队列的方式绑定到另一个交换器，来接收这个交换器中路由的消息
  - 换句话来说，客户端无法直接发送 msg 到内部交换器，只有交换器可以发送 msg 到内部交换器。

- `noWait` 是否等待服务器确认（是否非阻塞）
  - 阻塞：表示创建交换器的请求发送后，阻塞等待 RMQ Server 返回信息。
  - 非阻塞：不会阻塞等待 RMQ Server 的返回信息，而 RMQ Server 也不会返回信息。（不推荐使用）

- `args` 其它配置

### 在信道上创建队列 Queue

```go
func (ch *Channel) QueueDeclare(name string, durable, autoDelete, exclusive, noWait bool, args Table) (Queue, error)

q, err := channel.QueueDeclare("q1", true, false, false, true, nil)
```

创建队列还有一个差不多的方法 (QueueDeclarePassive)，他主要是假定队列已存在，并尝试连接到不存在的队列将导致 RabbitMQ 引发异常，可用于检测队列的存在。

#### 参数

- `name` 队列名称
- `durable` 持久化
  - 持久化会把队列存盘，服务器重启后，不会丢失队列以及队列内的信息。
  - 不丢失是相对的，如果宕机时有消息没来得及存盘，还是会丢失的。
  - 存盘影响性能。

- `autoDelete` 自动删除
  - 至少有一个消费者连接到队列时才可以触发。**之后**当所有消费者都断开时，队列会自动删除。。
  - 不能把这个参数错误地理解为：“当连接到此队列的所有客户端断开时，这个队列自动删除”，因为生产者客户端创建这个队列，或者没有消费者客户端与这个队列连接时，都不会自动删除这个队列。

- `exclusive` 排他
  - 如果设置为排他，则队列仅对首次声明他的连接可见，并在连接断开时自动删除。
  - 排他队列是基于连接（Connection）可见的，并且该连接内的所有信道（Channel）都可以访问这个排他队列，在这个连接断开之后，该队列自动删除
  - 注意，这里说的是连接不是信道 channel，相同连接不同信道是可见的
  - 非排他队列不依附于连接而存在，同一服务器上的多个连接都可以访问这个队列

- `noWait` 是否等待服务器确认（是否非阻塞）
  - 阻塞：表示创建交换器的请求发送后，阻塞等待 RMQ Server 返回信息。
  - 非阻塞：不会阻塞等待 RMQ Server 的返回信息，而 RMQ Server 也不会返回信息。（不推荐使用）

- `args Table`

### 为信道绑定队列

```go
func (ch *Channel) QueueBind(name, key, exchange string, noWait bool, args Table) error

err = channel.QueueBind("q1", "q1Key", "e1", true, nil)
```

参数解析：

- `name` 队列名称
- `key` BindingKey，表示要绑定的键，根据交换机类型来设定
- `exchange` 交换机名称
- `noWait` 是否等待服务器确认（是否非阻塞）
- `args Table`

### 为信道绑定交换器（可选）

```go
func (ch *Channel) ExchangeBind(destination, key, source string, noWait bool, args Table) error

err = channel.ExchangeBind("dest", "q1Key", "src", false, nil)
```

源交换器根据路由键 / 绑定键把 msg 转发到目的交换器。

参数解析：

- `destination` 目的交换器，通常是内部交换器
- `key` RoutingKey 路由键
- `source` 源交换器
- `noWait` 是否等待服务器确认（是否非阻塞）
- `args Table` 　其它参数

生产者发送消息至交换器 source 中，交换器 source 根据路由键找到与其匹配的另一个交换器 destination ，井把消息转发到 destination 中，进而存储在 destination 绑定的队列 queue 中，某种程度上来说 destination 交换器可以看作一个队列。

### 投递消息

```go
func (ch *Channel) Publish(exchange, key string, mandatory, immediate bool, msg Publishing) error

err = channel.Publish("e1", "q1Key", true, false, amqp.Publishing{
    Timestamp:   time.Now(),
    DeliveryMode: amqp.Persistent, // Msg set as persistent
    ContentType: "text/plain",
    Body:        []byte("Hello Golang and AMQP(Rabbitmq)!"),
})
```

其中 amqp.Publishing 的 DeliveryMode 如果设为 amqp.Persistent 则消息会持久化。需要注意的是如果需要消息持久化 Queue 也是需要设定为持久化才有效。

参数解析：

- `exchange` 交换器名称
- `key` RouterKey 路由键
- `mandatory` 是否为无法路由的消息进行返回处理

  - 设置消息在发送到交换器之后无法路由到队列的情况对消息的处理方式
  - 设置为 `true` 表示将消息返回到生产者，`false` 直接丢弃消息
  - 建议 false

- `immediate` 是否对路由到无消费者队列的消息进行返回处理

  - 参数告诉服务器，如果该消息关联的队列上有消费者，则立刻投递
  - 如果所有匹配的队列上都没有消费者，则直接将消息返还给生产者，不用将消息存入队列而等待消费者了。
  - RabbitMQ 3.0 废弃，建议 false

- `msg` 消息体，msg 对应一个 Publishing 结构：

  ```go
  # cat $(find ./amqp) | grep -rin type.*Publishing
  type Publishing struct {
          Headers Table
          // Properties
          ContentType     string    // 消息的类型，通常为“text/plain” ⭐
          ContentEncoding string    // 消息的编码，一般默认不用写
          DeliveryMode    uint8     // 消息是否持久化，2表示持久化，0或1表示非持久化。
          Body []byte               // 消息主体 ⭐
          Priority        uint8 	  // 消息的优先级 0 to 9
          CorrelationId   string    // correlation identifier
          ReplyTo         string    // address to to reply to (ex: RPC)
          Expiration      string    // message expiration spec
          MessageId       string    // message identifier
          Timestamp       time.Time // message timestamp
          Type            string    // message type name
          UserId          string    // creating user id - ex: "guest"
          AppId           string    // creating application id
  }
  ```

## 消费者流程

消费者的步骤和生产者流程基本类似，只是将生产者流程中的投递消息变为消费消息。

`Rabbitmq` 消费方式共有 2 种，分别是推模式（push）和拉模式（pull）。

### 推模式

RMQ Server 主动把消息推给消费者

推模式是通过持续订阅的方式来消费信息， `Consume` 将信道 `Channel` 设置为接收模式，直到取消队列的订阅为止。在接收模式期间， `RabbitMQ` 会不断地推送消息给消费者。推送消息的个数还是会受到 `channel.Qos` 的限制。

```go
func (ch *Channel) Consume(queue, consumer string, autoAck, exclusive, noLocal, noWait bool, args Table) (<-chan Delivery, error)

deliveries, err := channel.Consume("q1", "any", false, false, false, true, nil)
```

参数说明：

- `queue` 队列名称
- `consumer` 消息者名称
- `autoAck` 是否确认消费
- `exclusive` 排他
- `noLocal` 设置为 true 表示不能将同一个 Connection 中生产者发送的消息传送给这个 Connection 中的消费者
- `noWait` 是否非阻塞
- `args Table`

`autoAck`

- - 如果设为 true 则消费者一接收到就从 queue 中去除了，如果消费者处理消息中发生意外该消息就丢失了。

  - 如果设为 false 则表示需要手动进行 ack 消费

    - 消费者在处理完消息后，调用 `msg.Ack(false)` 后消息才从 queue 中去除。
    - 即便当前消费者处理该消息发生意外，只要没有执行 `msg.Ack(false)` 那该消息就仍然在 queue 中，不会丢失。

    ```go
    v, ok := <-deliveries
    if ok {
        // 手动ack确认
        // 注意： 这里只要调用了ack就是手动确认模式，
        // v.Ack的参数 multiple 表示的是在此channel中先前所有未确认的deliveries都将被确认
        // 并不是表示设置为false就不进行当前ack确认
        if err := v.Ack(true); err != nil {
            fmt.Println(err.Error())
        }
    } else {
        fmt.Println("Channel close")
    }
    ```

#### 手动回复消息

```go
func (ch *Channel) Ack(tag uint64, multiple bool) error

func (me Delivery) Ack(multiple bool) error {
        if me.Acknowledger == nil {
                return errDeliveryNotInitialized
        }
        return me.Acknowledger.Ack(me.DeliveryTag, multiple)
}

func (d Delivery) Reject(requeue bool) error
```

### 拉模式

消费者主动从 RMQ Server 拉消息

相对来说比较简单，是由消费者主动拉取信息来消费，每次只消费一条消息，同样也需要进行 `ack` 确认消费。

```go
func (ch *Channel) Get(queue string, autoAck bool) (msg Delivery, ok bool, err error)

channel.Get(queue string, autoAck bool)
```

