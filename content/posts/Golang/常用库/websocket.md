---
title: "websocket"
date: 2023-02-16
draft: true
author: "MelonCholi"
tags: []
categories: [Golang]
---

# websocket

WebSocket 是一种在单个 TCP 连接上进行全双工通信的协议。

WebSocket 使得客户端和服务器之间的数据交换变得更加简单，允许服务端主动向客户端推送数据。在 WebSocket API 中，浏览器和服务器只需要完成一次握手，两者之间就直接可以创建持久性的连接，并进行双向数据传输。

```shell
go get github.com/gorilla/websocket
```

已经停止维护了，悲

## 总览

官方文档：https://pkg.go.dev/github.com/gorilla/websocket

官方的 echo 示例：https://github.com/gorilla/websocket/tree/master/examples/echo

官方的聊天室示例：https://github.com/gorilla/websocket/tree/master/examples/chat

### Conn

websocket 是个二进制协议，需要先通过 Http 协议进行握手，从而协商完成从 Http 协议向 websocket 协议的转换。一旦握手结束，当前的 TCP 连接后续将采用二进制 websocket 协议进行双向双工交互，自此与 Http 协议无关。

The Conn type represents a WebSocket connection. A server application calls the Upgrader.Upgrade method from an HTTP request handler to get a *Conn:

```go
var upgrader = websocket.Upgrader{
    ReadBufferSize:  1024,
    WriteBufferSize: 1024,
}

func handler(w http.ResponseWriter, r *http.Request) {
    conn, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        log.Println(err)
        return
    }
    // ... Use conn to send and receive messages.
}
```

### Read and Write

Call the connection's WriteMessage and ReadMessage methods to send and receive messages as a slice of bytes. This snippet of code shows how to echo messages using these methods:

```go
for {
    messageType, p, err := conn.ReadMessage()
    if err != nil {
        log.Println(err)
        return
    }
    if err := conn.WriteMessage(messageType, p); err != nil {
        log.Println(err)
        return
    }
}
```

- p is a []byte
- messageType is an int with value websocket.BinaryMessage or websocket.TextMessage.

### io read and write

An application can also send and receive messages using the io.WriteCloser and io.Reader interfaces. To send a message, call the connection NextWriter method to get an io.WriteCloser, write the message to the writer and close the writer when done. To receive a message, call the connection NextReader method to get an io.Reader and read until io.EOF is returned. This snippet shows how to echo messages using the NextWriter and NextReader methods:

```go
for {
    messageType, r, err := conn.NextReader()
    if err != nil {
        return
    }
    w, err := conn.NextWriter(messageType)
    if err != nil {
        return err
    }
    if _, err := io.Copy(w, r); err != nil {
        return err
    }
    if err := w.Close(); err != nil {
        return err
    }
}
```

### Data Messages

The WebSocket protocol distinguishes between text and binary data messages. Text messages are interpreted as UTF-8 encoded text. The interpretation of binary messages is left to the application.

This package uses the TextMessage and BinaryMessage integer constants to identify the two data message types. The ReadMessage and NextReader methods return the type of the received message. The messageType argument to the WriteMessage and NextWriter methods specifies the type of a sent message.

It is the application's responsibility to ensure that text messages are valid UTF-8 encoded text.





