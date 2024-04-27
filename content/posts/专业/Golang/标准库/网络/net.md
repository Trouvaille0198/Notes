---
title: "Go net 标准库"
date: 2022-02-04
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# net

## net 包

### lookUp 地址信息查找

```go
//InterfaceAddrs 返回该系统的网络接口的地址列表。
addr, _ := net.InterfaceAddrs()
fmt.Println(addr)

//Interfaces 返回该系统的网络接口列表
interfaces, _ := net.Interfaces()
fmt.Println(interfaces)

//LookupAddr 查询某个地址，返回映射到该地址的主机名序列
lt, _ := net.LookupAddr("www.alibaba.com")
fmt.Println(lt)

//LookupCNAME函数查询name的规范DNS名（但该域名未必可以访问）。
cname, _ := net.LookupCNAME("www.baidu.com")
fmt.Println(cname)

//LookupHost函数查询主机的网络地址序列。
host, _ := net.LookupHost("www.baidu.com")
fmt.Println(host)

//LookupIP函数查询主机的ipv4和ipv6地址序列。
ip, _ := net.LookupIP("www.baidu.com")
fmt.Println(ip)
```

```
fe80::f443:30bc:69ae:c20c/64
26.26.26.1/29
fe80::2862:dc98:645c:ca9b/64
172.28.224.1/20
fe80::9560:74e7:713e:fce1/64
169.254.252.225/16

{13 1500 LetsTAP 00:ff:ca:db:b8:7d 0}
{56 1500 vEthernet (WSL) 00:15:5d:17:45:20 up|broadcast|multicast}
{19 1500 本地连接* 1 dc:71:96:6f:ba:59 broadcast|multicast}
{9 1500 本地连接* 2 de:71:96:6f:ba:58 broadcast|multicast}
{3 1500 WLAN dc:71:96:6f:ba:58 up|broadcast|multicast}


```

### 地址操作

```go
//函数将host和port合并为一个网络地址。一般格式为"host:port"；如果host含有冒号或百分号，格式为"[host]:port"。
//Ipv6的文字地址或者主机名必须用方括号括起来，如"[::1]:80"、"[ipv6-host]:http"、"[ipv6-host%zone]:80"。
hp := net.JoinHostPort("127.0.0.1", "8080")
fmt.Println(hp)

//函数将格式为"host:port"、"[host]:port"或"[ipv6-host%zone]:port"的网络地址分割为host或ipv6-host%zone和port两个部分。
shp,port,_ := net.SplitHostPort("127.0.0.1:8080")
fmt.Println(shp," _ ",port)
```

### 错误说明

接口定义：

```go
type Error interface {
    error
    Timeout() bool   // 错误是否为超时？
    Temporary() bool // 错误是否是临时的？
}
```
读取主机 DNS 配置时出现的错误。

```go
// DNSError represents a DNS lookup error.
type DNSError struct {
	Err         string // description of the error
	Name        string // name looked for
	Server      string // server used
	IsTimeout   bool   // if true, timed out; not all timeouts set this
	IsTemporary bool   // if true, error is temporary; not all errors set this
	IsNotFound  bool   // if true, host could not be found
}
```
DNS 查询的错误。

```go
// DNSError represents a DNS lookup error.
type DNSError struct {
	Err         string // description of the error
	Name        string // name looked for
	Server      string // server used
	IsTimeout   bool   // if true, timed out; not all timeouts set this
	IsTemporary bool   // if true, error is temporary; not all errors set this
	IsNotFound  bool   // if true, host could not be found
}
```
地址错误

```go
type AddrError struct {
	Err  string
	Addr string
}
```
返回该错误的操作、网络类型和网络地址。

```go
// OpError is the error type usually returned by functions in the net
// package. It describes the operation, network type, and address of
// an error.
type OpError struct 
```
### TCP 连接

#### 客户端

1. 和服务端建立一个链接
2. 进行数据的收发
3. 关闭链接 

```go
package main
 
import (
    "bufio"
    "fmt"
    "net"
    "os"
    "strings"
)
 
func main() {
    //1.建立一个链接（Dial拨号）
    conn, err := net.Dial("tcp", "0.0.0.0:20000")
    if err != nil {
        fmt.Printf("dial failed, err:%v\n", err)
        return
    }
 
    fmt.Println("Conn Established...:")
 
    //读入输入的信息
    reader := bufio.NewReader(os.Stdin)
    for {
        data, err := reader.ReadString('\n')
        if err != nil {
            fmt.Printf("read from console failed, err:%v\n", err)
            break
        }
 
        data = strings.TrimSpace(data)
        //传输数据到服务端
        _, err = conn.Write([]byte(data))
        if err != nil {
            fmt.Printf("write failed, err:%v\n", err)
            break
        }
    }
}
```

#### 服务端

1. 监听端口
2. 接受客户端的链接
3. 创建 Goroutine，处理这个链接 (一个服务端要链接多个客户端，所以使用 Goroutine 非常简单)

```go
package main
 
import (
    "fmt"
    "net"
)
 
func main() {
    //1.建立监听端口
    listen, err := net.Listen("tcp", "0.0.0.0:20000")
    if err != nil {
        fmt.Println("listen failed, err:", err)
        return
    }
 
    fmt.Println("listen Start...:")
 
    for {
        //2.接收客户端的链接
        conn, err := listen.Accept()
        if err != nil {
            fmt.Printf("accept failed, err:%v\n", err)
            continue
        }
        //3.开启一个Goroutine，处理链接
        go process(conn)
    }
}
 
//处理请求，类型就是net.Conn
func process(conn net.Conn) {
 
    //处理结束后关闭链接
    defer conn.Close()
    for {
        var buf [128]byte
        n, err := conn.Read(buf[:])
        if err != nil {
            fmt.Printf("read from conn failed, err:%v", err)
            break
        }
        fmt.Printf("recv from client, content:%v\n", string(buf[:n]))
    }
 
}
```

## net/http 包

### 连接、监听

```go
//get方法调用
resp, err := http.Get("http://example.com/")

//post方法调用
resp, err := http.Post("http://example.com/upload", "image/jpeg", &buf)

//表单方式调用
resp, err := http.PostForm("http://example.com/form", url.Values{"key": {"Value"}, "id": {"123"}})

//服务端进行监听端口
func (srv *Server) ListenAndServe() error 
```

### 管理 HTTP 客户端的头域、重定向策略和其他设置

创建 Client，发送设置好的 request

```go
client := &http.Client{CheckRedirect: redirectPolicyFunc,}
resp, err := client.Get("http://example.com")

req, err := http.NewRequest("GET", "http://example.com", nil)  //创建一个request
req.Header.Add("If-None-Match", `W/"wyzzy"`) //设置头部
resp, err := client.Do(req)
```

### 管理代理、TLS 配置、keep-alive、压缩和其他设置

创建一个携带设置好的 Transport 信息的 Client，并进行通信

```go
tr := &http.Transport{
	TLSClientConfig:    &tls.Config{RootCAs: pool},
	DisableCompression: true,
}
client := &http.Client{Transport: tr}
resp, err := client.Get("https://example.com")
```

### 完整例子

客户端

```go
package test

import (
    "fmt"
    "io/ioutil"
    "net/http"
)

func main() {
    response, _ := http.Get("http://localhost:80/hello")
    defer response.Body.Close()

    body, _ := ioutil.ReadAll(response.Body)
    fmt.Println(string(body))
}
```

服务端

```go
package test

import (
    "flag"
    "fmt"
    "io/ioutil"
    "net/http"
)

func main() {
    host := flag.String("host", "127.0.0.1", "listen host")
    port := flag.String("port", "80", "listen port")

    http.HandleFunc("/hello", Hello)

    err := http.ListenAndServe(*host+":"+*port, nil)

    if err != nil {
        panic(err)
    }
}

func Hello(w http.ResponseWriter, req *http.Request) {
    _, _ = w.Write([]byte("Hello World"))
}
```

