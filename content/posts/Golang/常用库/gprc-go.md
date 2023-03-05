---
title: "Go grpc-go 库"
date: 2023-02-24
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# grpc-go

## gRPC 简介

gRPC 是一个现代的开源高性能远程过程调用 (RPC) 框架，可以在任何环境中运行。它可以有效地连接数据中心内和跨数据中心的服务，支持负载均衡、跟踪、健康检查和身份验证。它也适用于分布式计算，将设备、移动应用程序和浏览器连接到后端服务

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5a989f6672b34f1791f3684883ac776f~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?" alt="image.png" style="zoom:50%;" />

gRPC 的特点

- 一个高性能 RPC 框架，一个跨语言平台的 RPC 框架。
- 使用 Protocol Buffers 作为二进制序列化
- 使用 HTTP/2 进行数据传输

<img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f0990d1d71544a5281797b26b806e877~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?" alt="image.png" style="zoom: 67%;" />

gRPC 客户机和服务器可以在各种环境中彼此运行和通信。服务端使用的 C++ 实现，而客户端可以是 Ruby、Java、Go 等其他的语言。这就体现了 gRPC 的跨平台优势。

### gPRC 与 protobuf

Protocol Buffer 是一个由 Google 定义的一个与语言和平台无关的、可拓展的、用于序列化 / 结构化数据的协议。

> Akka 的节点之间的数据传输可以自定义基于 Protocol Buffers 序列化的处理。

gRPC 使用 Protocol Buffers 序列化结构化数据

```protobuf
// The greeter service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
复制代码
```

通过定义 *proto* 文件，来定义 **`service`** 和 **`message`** 。 service 负责提供服务， message 提供结构化数据的序列化。

### gRPC 与 HTTP2

gRPC 引入了三个新概念：channel、RPC 和 Message。三者之间的关系很简单：每个 Channel 可能有许多 RPC，而每个 RPC 可能有许多 Message。

<img src="https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/840f84b13ab84ab1a5043a9f99f62c27~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?" alt="image.png" style="zoom: 33%;" />

HTTP/2 中的流在一个连接上允许多个并发会话，而 gRPC 通过**支持多个并发连接上的多个流**扩展了这个概念。

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bc303677bd0d4981b2a167d3e27873e9~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?" alt="image.png" style="zoom: 27%;" />

> Channel 表示和终端的一个虚拟链接

`Channel` 背后实际上可能有多个 HTTP/2 连接。从上面关系图来看，一个 RPC 和一个 HTTP/2 连接相关联，rpc 实际上是纯 HTTP/2 流。Message 与 rpc 关联，并以 HTTP/2 数据帧的形式发送。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d2773fd36e4c456eb0cd8c42db5c3209~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

> 消息是在数据帧之上分层的。一个数据帧可能有许多 gRPC 消息，或者如果一个 gRPC 消息非常大，它可能跨越多个数据帧。

### 解析器和负载均衡

为了保持连接的 alive、Healthy 和利用，gRPC 使用了许多组件，其中最重要的是名称解析器和负载平衡器。

- 解析器将名称转换为地址，然后将这些地址交给负载均衡器。

- 负载均衡器负责从这些地址创建连接，并在连接之间对 rpc 进行负载均衡。

<img src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8462f5c9154b4f9db9ee27d88ae4aa22~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?" alt="image.png" style="zoom: 33%;" />

### 连接的管理

配置完成后，gRPC 将保持连接池（解析器和平衡器定义的）处于正常状态、处于活动状态和已使用状态。

当连接失败时，负载均衡器将开始使用最后已知的地址列表重新连接。同时，解析器将开始尝试重新解析主机名列表。这在许多场景中都很有用。例如，如果代理不再可达，我们希望解析器更新地址列表，使其不包含该代理的地址。再举一个例子：DNS 条目可能会随着时间的推移而改变，因此可能需要定期更新地址列表。通过这种方式和其他方式，gRPC 旨在实现长期弹性。

一旦解析完成，负载均衡器就会被告知新的地址。如果地址发生了变化，负载均衡器可能会关闭到新列表中不存在的地址的连接，或者创建到以前不存在的地址的连接。

> 连接也使用了池化

### 失效连接识别

gRPC 连接管理的有效性取决于它识别失败连接的能力。失效连接分为两种：

- 可清除的失效连接（通讯失败，如连接失败）

    当端点有意终止连接时，可能会发生清除故障。例如，端点可能已经优雅地关闭，或者可能超时，从而提示端点关闭连接。当连接干净地关闭时，TCP 语义就足够了：关闭连接会导致 FIN 握手。这将结束 HTTP/2 连接，从而结束 gRPC 连接。gRPC 将立即开始重新连接。不需要额外的 HTTP/2 或 gRPC 语义。

- 不可清除的失效连接（复杂的网络环境）

    endpoint 死亡或挂起而不通知客户端。在这种情况下，TCP 可能会在认为连接失败之前进行长达 10 分钟的重试。当然，没有意识到连接已死 10 分钟是不可接受的。gRPC 使用 HTTP/2 语义解决了这个问题：当配置 KeepAlive 时，gRPC 会定期发送 HTTP/2 PING 帧。这些帧绕过流量控制，用来建立连接是否有效。如果 PING 响应没有及时返回，gRPC 将认为连接失败，关闭连接，并开始重新连接

通过这种方式，gRPC 保持连接池的健康状态，并定期使用 HTTP/2 来确定连接的健康状态。

### Alive 保持

通过发送 HTTP/2 PING 来定期检查连接的健康状况，以确定连接是否仍然活着

> gRPC 与 HTTP/2 的关系：HTTP/2 为长连接、实时的通信流提供了基础。gRPC 建立在这个基础之上，具有连接池、健康语义、高效使用数据帧和多路复用以及 KeepAlive，gRPC 的通讯基石就是 HTTP/2

## 快速入门

> https://mp.weixin.qq.com/s/1Xbca4Dv0akonAZerrChgA
