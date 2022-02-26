---
title: "Go gopacket 库"
date: 2022-02-06
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# gopacket

```shell
go get github.com/google/gopacket
```

## pcap 处理

### 查看版本

```go
version := pcap.Version()
fmt.Println(version)
```

测试（Win10 x64）
`Npcap version 1.00, based on libpcap version 1.9.1`

### 网络接口

类型：`pcap.Interface`

```go
type Interface struct {
	Name        string
	Description string
	Flags       uint32
	Addresses   []InterfaceAddress
}
type InterfaceAddress struct {
	IP        net.IP
	Netmask   net.IPMask // Netmask may be nil if we were unable to retrieve it.
	Broadaddr net.IP     // Broadcast address for this IP may be nil
	P2P       net.IP     // P2P destination address for this IP may be nil
}
```

查找网络设备

```go
var devices []pcap.Interface
devices, _ = pcap.FindAllDevs()
fmt.Println(devices)
```

### 实时捕获

```go
handle, err := pcap.OpenLive("\\Device\\NPF_{5C9384EF-DEBA-43A6-AE6A-5D10C952C481}", int32(65535), true, -1 * time.Second)
if err != nil {
    log.Fatal(err)
}
defer handle.Close()
```

`pcap.OpenLive` 参数：

- 设备名：`pcap.FindAllDevs()` 返回的设备的 Name
- `snaplen`：捕获一个数据包的多少个字节，一般来说对任何情况 65535 是一个好的实践，如果不关注全部内容，只关注数据包头，可以设置成 1024
- `promisc`：设置网卡是否工作在混杂模式，即是否接收目的地址不为本机的包
- `timeout`：设置抓到包返回的超时。如果设置成 30s，那么每 30s 才会刷新一次数据包；设置成负数，会立刻刷新数据包，即不做等待

要记得释放掉 handle

### 打开 pcap

```go
handle, _ = pcap.OpenOffline("dump.pcap")
defer handle.Close()
```

### 创建一个数据包源

通过监听设备的实时流量或者来自文件的数据包，我们可以得到一个 handle，通过这个 handle 得到一个数据包源 packetSource。

```go
packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
```

利用 `handle.LinkType()` 就不用知道链路类型了。

### 读取数据包

读取一个数据包：`packet, _ := packetSource.NextPacket()`

获得一个可以读取数据包的 channel 来读取全部数据包

```go
packet := packetSource.Packets()
for packet := range packet{
    fmt.Println(packet)
}
```

### 设置过滤器

使用 BPF 语法即可。

```go
handle.SetBPFFilter("tcp and port 80")
```

### 创建一个 pcap 用于写入

```go
dumpFile, _ := os.Create("dump.pcap")
defer dumpFile.Close()
packetWriter := pcapgo.NewWriter(dumpFile)
packetWriter.WriteFileHeader(65535, layers.LinkTypeEthernet)
```

`packetWriter.WriteFileHeader` 的参数是 snaplen 和链路类型

### 写入数据包

```go
packet := packetSource.Packets()
for packet := range packet{
    packetWriter.WritePacket(packet.Metadata().CaptureInfo, packet.Data())
}
```

## packet 处理

### 列出所有层

```go
for _, layer := range packet.Layers() {
    fmt.Println(layer.LayerType())
    fmt.Println(layer.LayerContents())
    fmt.Println(layer.LayerPayload())
}
```

- `layer.LayerType()`：这层的类型
- `layer.LayerContents()`：当前层的内容
- `layer.LayerPayload()`：当前层承载的 payload（不包括当前层）

### 分析某层的数据

#### IPv4

```go
ipLayer := packet.Layer(layers.LayerTypeIPv4)
if ipLayer != nil {
    ip, _ := ipLayer.(*layers.IPv4)
    fmt.Println(ip.SrcIP, ip.DstIP)
    fmt.Println(ip.Protocol)
}
```

#### TCP

```go
tcpLayer := packet.Layer(layers.LayerTypeTCP)
if tcpLayer != nil {
    ip, _ := tcpLayer.(*layers.TCP)
    fmt.Println(ip.SrcPort, ip.DstPort)
}
```

这里有一些需要注意的：

- `tcpLayer` 是通过接口 `packet.Layer` 返回的一个 `Layer`，一个指向 `layers.TCP` 的指针
- `tcp` 是 `layers.TCP` 这个具体类型的指针，也可以说 `tcp` 是真实的 tcp 层数据

#### 单独的解码器

可以从多个起点对数据包进行解码。可以解码没有完整数据的数据包。

```go
// Decode an ethernet packet
ethP := gopacket.NewPacket(packet, layers.LayerTypeEthernet, gopacket.Default)
// Decode an IPv6 header and everything it contains
ipP := gopacket.NewPacket(packet, layers.LayerTypeIPv6, gopacket.Default)
// Decode a TCP header and its payload
tcpP := gopacket.NewPacket(packet, layers.LayerTypeTCP, gopacket.Default)
```

#### 懒惰解码（Lazy Decoding）

创建一个 packet 包，但是不立刻解码，只有后面需要用的时候再解码。

比如第二行解码 IPv4 层，如果有的话，就解码 IPv4 层，然后不做进一步处理（不解码后续的层）；如果没有会解码整个 packet 来寻找 IPv4 层。
`packet.Layers()` 会解码所有层并且返回，已经解码的层不会再次做解码。

注意：这种方式并不是并发安全的，对 Layers 的每次调用可能会改变数据包。

```go
packet := gopacket.NewPacket(myPacketData, layers.LayerTypeEthernet, gopacket.Lazy)
ip4 := packet.Layer(layers.LayerTypeIPv4)
// Decode all layers and return them.  The layers up to the first IPv4 layer
// are already decoded, and will not require decoding a second time.
layers := packet.Layers()
```

#### NoCopy 解码

上述两种解码方式会复制切片，对切片的字节进行更改不会影响数据包本身。如果可以保证不修改切片，可以使用 NoCopy。

```go
for data := range myByteSliceChannel { 
	p := gopacket.NewPacket(data, layers.LayerTypeEthernet, gopacket.NoCopy)
	doSomethingWithPacket(p)
}
```

#### 快速解码

不会创建新的内存结构。会重用内存结构，所以只能用于预定义好层的结构。

```go
for packet := range packetSource.Packets() {
    var eth layers.Ethernet
    var ip4 layers.IPv4
    var tcp layers.TCP
    parser := gopacket.NewDecodingLayerParser(layers.LayerTypeEthernet, &eth, &ip4, &tcp)
    var decodedLayers []gopacket.LayerType
    parser.DecodeLayers(packet.Data(), &decodedLayers)
    for _, layerType := range decodedLayers {
        fmt.Println(layerType)
    }
}
```

## 自定义层数据

### 注册自定义的层

`gopacket.RegisterLayerType()`：传入一个独有的 id，和层类型对应的 Metadata，包括有名字和对应的解码器。

```go
var MyLayerType = gopacket.RegisterLayerType(12345, gopacket.LayerTypeMetadata{Name: "MyLayerType", Decoder: gopacket.DecodeFunc(decodeMyLayer)})
```

### 定义层的结构

要实现三个方法。

```go
type MyLayer struct {
	MyHeader  []byte
	MyPayload []byte
}
func (m MyLayer) LayerType() gopacket.LayerType {
    return MyLayerType
}
func (m MyLayer) LayerContents() []byte {
    return m.MyHeader
}
func (m MyLayer) LayerPayload() []byte {
    return m.MyPayload
}
```

### 定义解码器

```go
func decodeMyLayer(data []byte, p gopacket.PacketBuilder) error {
	p.AddLayer(&MyLayer{data[:4], data[4:]})
	return p.NextDecoder(layers.LayerTypeEthernet)
}
```

### 对自定义的层进行解码

```go
pkt := gopacket.NewPacket(packet.Data(), MyLayerType, gopacket.Default)
```

## 创建与发送

### 创建

创建一个新的序列化缓冲区；然后把所有层序列化到缓冲区中。

```go
buffer := gopacket.NewSerializeBuffer()
options := gopacket.SerializeOptions{}
gopacket.SerializeLayers(buffer, options, &layers.Ethernet{}, &layers.IPv4{}, &layers.TCP{}, gopacket.Payload([]byte{65, 66, 67}))
```

### 发送数据包

```go
handle.WritePacketData(buffer.Bytes())
```

### 流和端点（Flow and Endpoint）

注意：这个地方官方文档感觉有坑

- `pkt.NetworkLayer().NetworkFlow()`：取网络层，网络流，IP 地址
- `pkt.TransportLayer().TransportFlow()`：取传输层，传输端点，端口
- `interestingFlow`：定义好端点，对网络数据做匹配

```go
pkt := gopacket.NewPacket(packet.Data(), layers.LayerTypeEthernet, gopacket.Lazy)
netFlow := pkt.NetworkLayer().NetworkFlow()
src, dst := netFlow.Endpoints()
fmt.Println(src, dst)
fmt.Println("Done.")

tcpFlow := pkt.TransportLayer().TransportFlow()
fmt.Println(tcpFlow.Endpoints())
interestingFlow, _ := gopacket.FlowFromEndpoints(layers.NewUDPPortEndpoint(1000), layers.NewUDPPortEndpoint(500))
if t := pkt.TransportLayer(); t != nil && t.TransportFlow() == interestingFlow {
    fmt.Println("Found that UDP flow I was looking for!")
}
```

## 例子

### 枚举本地网络设备

```go
package main

import (
    "fmt"
    "log"
    "github.com/google/gopacket/pcap"
)

func main() {
    // 得到所有的(网络)设备
    devices, err := pcap.FindAllDevs()
    if err != nil {
        log.Fatal(err)
    }

    // 打印设备信息
    fmt.Println("Devices found:")
    for _, device := range devices {
        fmt.Println("\nName: ", device.Name)
        fmt.Println("Description: ", device.Description)
        fmt.Println("Devices addresses: ", device.Description)
        for _, address := range device.Addresses {
            fmt.Println("- IP address: ", address.IP)
            fmt.Println("- Subnet mask: ", address.Netmask)
        }
    }
}
```

### 打开一个设备进行实时捕获

```go
package main

import (
    "fmt"
    "github.com/google/gopacket"
    "github.com/google/gopacket/pcap"
    "log"
    "time"
)

var (
    device       string = "eth0"
    snapshot_len int32  = 1024
    promiscuous  bool   = false
    err          error
    timeout      time.Duration = 30 * time.Second
    handle       *pcap.Handle
)

func main() {
    // Open device
    handle, err = pcap.OpenLive(device, snapshot_len, promiscuous, timeout)
    if err != nil {log.Fatal(err) }
    defer handle.Close()

    // Use the handle as a packet source to process all packets
    packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
    for packet := range packetSource.Packets() {
        // Process packet here
        fmt.Println(packet)
    }
}
```

### 写入到 pcap 文件

为了写入到 pcap 格式的文件中，我们需要 `gopacket/pcapgo`，它包含一个 `Writer`，还有两个有用的辅助函数：`WriteFileHeader()` 和  `WritePacket()`。

```go
package main

import (
	"fmt"
	"os"
	"time"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
	"github.com/google/gopacket/pcapgo"
)

var (
	deviceName  string = "eth0"
	snapshotLen int32  = 1024
	promiscuous bool   = false
	err         error
	timeout     time.Duration = -1 * time.Second
	handle      *pcap.Handle
	packetCount int = 0
)

func main() {
	// Open output pcap file and write header 
	f, _ := os.Create("test.pcap")
	w := pcapgo.NewWriter(f)
	w.WriteFileHeader(snapshotLen, layers.LinkTypeEthernet)
	defer f.Close()

	// Open the device for capturing
	handle, err = pcap.OpenLive(deviceName, snapshotLen, promiscuous, timeout)
	if err != nil {
		fmt.Printf("Error opening device %s: %v", deviceName, err)
		os.Exit(1)
	}
	defer handle.Close()

	// Start processing packets
	packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
	for packet := range packetSource.Packets() {
		// Process packet here
		fmt.Println(packet)
		w.WritePacket(packet.Metadata().CaptureInfo, packet.Data())
		packetCount++
		
		// Only capture 100 and then stop
		if packetCount > 100 {
			break
		}
	}
}
```

### 打开 pcap 文件

除了打开一个设备实时捕获以外，我们还可以读取 pcap 文件进行离线分析。你可以通过 tcpdump 捕获一个文件来测试。

```shell
# Capture packets to test.pcap file
sudo tcpdump -w test.pcap
```

打开这个文件，遍历其中的 packet

```go
package main

// Use tcpdump to create a test file
// tcpdump -w test.pcap
// or use the example above for writing pcap files

import (
    "fmt"
    "github.com/google/gopacket"
    "github.com/google/gopacket/pcap"
    "log"
)

var (
    pcapFile string = "test.pcap"
    handle   *pcap.Handle
    err      error
)

func main() {
    // Open file instead of device
    handle, err = pcap.OpenOffline(pcapFile)
    if err != nil { log.Fatal(err) }
    defer handle.Close()

    // Loop through packets in file
    packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
    for packet := range packetSource.Packets() {
        fmt.Println(packet)
    }
}
```

### 设置过滤器

下面的代码仅仅返回端口 80 上的 packet

```go
package main

import (
    "fmt"
    "github.com/google/gopacket"
    "github.com/google/gopacket/pcap"
    "log"
    "time"
)

var (
    device       string = "eth0"
    snapshot_len int32  = 1024
    promiscuous  bool   = false
    err          error
    timeout      time.Duration = 30 * time.Second
    handle       *pcap.Handle
)

func main() {
    // Open device
    handle, err = pcap.OpenLive(device, snapshot_len, promiscuous, timeout)
    if err != nil {
        log.Fatal(err)
    }
    defer handle.Close()

    // Set filter
    var filter string = "tcp and port 80"
    err = handle.SetBPFFilter(filter)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println("Only capturing TCP port 80 packets.")

    packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
    for packet := range packetSource.Packets() {
        // Do something with a packet here.
        fmt.Println(packet)
    }

}
```

### 解码 packet 的各层

我们可以获取原始数据包，并尝试将其强制转换为已知格式。它与不同的层兼容，因此我们可以轻松访问ethernet、IP 和 TCP 层。

`layers` 包是 gopacket 的 Go 库中的新功能，在底层 libpcap 库中不存在。它是 gopacket 库的非常有用的一部分。它允许我们轻松地识别数据包是否包含特定类型的层。这个代码示例将演示如何使用 layers 包来查看包是否是 ethernet、IP 和 TCP，以及如何轻松访问这些头中的元素。

找到 `payload` (有效载荷) 取决于涉及的所有层。每个协议都是不同的，必须相应地进行处理。这就是 layers 包的强大之处。gopacket 的作者花了很多时间为许多已知层（ethernet、IP、UDP和TCP）创建 layer 类型。其中`payload` (有效负载) 是应用程序层的一部分。

```go
package main

import (
    "fmt"
    "github.com/google/gopacket"
    "github.com/google/gopacket/layers"
    "github.com/google/gopacket/pcap"
    "log"
    "strings"
    "time"
)

var (
    device      string = "eth0"
    snapshotLen int32  = 1024
    promiscuous bool   = false
    err         error
    timeout     time.Duration = 30 * time.Second
    handle      *pcap.Handle
)

func main() {
    // Open device
    handle, err = pcap.OpenLive(device, snapshotLen, promiscuous, timeout)
    if err != nil {log.Fatal(err) }
    defer handle.Close()

    packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
    for packet := range packetSource.Packets() {
        printPacketInfo(packet)
    }
}

func printPacketInfo(packet gopacket.Packet) {
    // Let's see if the packet is an ethernet packet
    ethernetLayer := packet.Layer(layers.LayerTypeEthernet)
    if ethernetLayer != nil {
        fmt.Println("Ethernet layer detected.")
        ethernetPacket, _ := ethernetLayer.(*layers.Ethernet)
        fmt.Println("Source MAC: ", ethernetPacket.SrcMAC)
        fmt.Println("Destination MAC: ", ethernetPacket.DstMAC)
        // Ethernet type is typically IPv4 but could be ARP or other
        fmt.Println("Ethernet type: ", ethernetPacket.EthernetType)
        fmt.Println()
    }

    // Let's see if the packet is IP (even though the ether type told us)
    ipLayer := packet.Layer(layers.LayerTypeIPv4)
    if ipLayer != nil {
        fmt.Println("IPv4 layer detected.")
        ip, _ := ipLayer.(*layers.IPv4)

        // IP layer variables:
        // Version (Either 4 or 6)
        // IHL (IP Header Length in 32-bit words)
        // TOS, Length, Id, Flags, FragOffset, TTL, Protocol (TCP?),
        // Checksum, SrcIP, DstIP
        fmt.Printf("From %s to %s\n", ip.SrcIP, ip.DstIP)
        fmt.Println("Protocol: ", ip.Protocol)
        fmt.Println()
    }

    // Let's see if the packet is TCP
    tcpLayer := packet.Layer(layers.LayerTypeTCP)
    if tcpLayer != nil {
        fmt.Println("TCP layer detected.")
        tcp, _ := tcpLayer.(*layers.TCP)

        // TCP layer variables:
        // SrcPort, DstPort, Seq, Ack, DataOffset, Window, Checksum, Urgent
        // Bool flags: FIN, SYN, RST, PSH, ACK, URG, ECE, CWR, NS
        fmt.Printf("From port %d to %d\n", tcp.SrcPort, tcp.DstPort)
        fmt.Println("Sequence number: ", tcp.Seq)
        fmt.Println()
    }

    // Iterate over all layers, printing out each layer type
    fmt.Println("All packet layers:")
    for _, layer := range packet.Layers() {
        fmt.Println("- ", layer.LayerType())
    }

    // When iterating through packet.Layers() above,
    // if it lists Payload layer then that is the same as
    // this applicationLayer. applicationLayer contains the payload
    applicationLayer := packet.ApplicationLayer()
    if applicationLayer != nil {
        fmt.Println("Application layer/Payload found.")
        fmt.Printf("%s\n", applicationLayer.Payload())

        // Search for a string inside the payload
        if strings.Contains(string(applicationLayer.Payload()), "HTTP") {
            fmt.Println("HTTP found!")
        }
    }

    // Check for errors
    if err := packet.ErrorLayer(); err != nil {
        fmt.Println("Error decoding some part of the packet:", err)
    }
}
```

### 创建和发送 packet

下面这个例子做了几个事情。首先，它将演示如何使用网络设备发送原始字节。这样，您就可以像串行连接(`serial connection`) 一样使用它来发送数据。这对于真正的低层的数据传输很有用，但是如果你想与一个应用程序交互，你可能想建立硬件和软件都能识别的包。

接下来，它将演示如何使用 ethernet、IP 和 TCP 层创建数据包。所有的东西都是默认的和空的，所以它实际上不做任何事情。

为了完成它，我们创建了另一个数据包，但实际上为 ethernet 层填充了一些 MAC 地址，为 IPv4 填充了一些 IP 地址，为 TCP 层填充了一些端口号。您应该看到如何用它伪造数据包和模拟设备。

TCP 层结构具有可读取或设置的 SYN, FIN, and ACK 布尔标志。这有利于控制和模糊 TCP 握手、会话和端口扫描。

pcap 库提供了一个发送字节的简单方法，但是 gopacket 中的 layers 包帮助我们为各个层创建字节结构。

```go
package main

import (
    "github.com/google/gopacket"
    "github.com/google/gopacket/layers"
    "github.com/google/gopacket/pcap"
    "log"
    "net"
    "time"
)

var (
    device       string = "eth0"
    snapshot_len int32  = 1024
    promiscuous  bool   = false
    err          error
    timeout      time.Duration = 30 * time.Second
    handle       *pcap.Handle
    buffer       gopacket.SerializeBuffer
    options      gopacket.SerializeOptions
)

func main() {
    // Open device
    handle, err = pcap.OpenLive(device, snapshot_len, promiscuous, timeout)
    if err != nil {log.Fatal(err) }
    defer handle.Close()

    // Send raw bytes over wire
    rawBytes := []byte{10, 20, 30}
    err = handle.WritePacketData(rawBytes)
    if err != nil {
        log.Fatal(err)
    }

    // Create a properly formed packet, just with
    // empty details. Should fill out MAC addresses,
    // IP addresses, etc.
    buffer = gopacket.NewSerializeBuffer()
    gopacket.SerializeLayers(buffer, options,
        &layers.Ethernet{},
        &layers.IPv4{},
        &layers.TCP{},
        gopacket.Payload(rawBytes),
    )
    outgoingPacket := buffer.Bytes()
    // Send our packet
    err = handle.WritePacketData(outgoingPacket)
    if err != nil {
        log.Fatal(err)
    }

    // This time lets fill out some information
    ipLayer := &layers.IPv4{
        SrcIP: net.IP{127, 0, 0, 1},
        DstIP: net.IP{8, 8, 8, 8},
    }
    ethernetLayer := &layers.Ethernet{
        SrcMAC: net.HardwareAddr{0xFF, 0xAA, 0xFA, 0xAA, 0xFF, 0xAA},
        DstMAC: net.HardwareAddr{0xBD, 0xBD, 0xBD, 0xBD, 0xBD, 0xBD},
    }
    tcpLayer := &layers.TCP{
        SrcPort: layers.TCPPort(4321),
        DstPort: layers.TCPPort(80),
    }
    // And create the packet with the layers
    buffer = gopacket.NewSerializeBuffer()
    gopacket.SerializeLayers(buffer, options,
        ethernetLayer,
        ipLayer,
        tcpLayer,
        gopacket.Payload(rawBytes),
    )
    outgoingPacket = buffer.Bytes()
}
```

### 更多创建和解码 packet 的例子

```go
package main

import (
    "fmt"
    "github.com/google/gopacket"
    "github.com/google/gopacket/layers"
)

func main() {
    // If we don't have a handle to a device or a file, but we have a bunch
    // of raw bytes, we can try to decode them in to packet information

    // NewPacket() takes the raw bytes that make up the packet as the first parameter
    // The second parameter is the lowest level layer you want to decode. It will
    // decode that layer and all layers on top of it. The third layer
    // is the type of decoding: default(all at once), lazy(on demand), and NoCopy
    // which will not create a copy of the buffer

    // Create an packet with ethernet, IP, TCP, and payload layers
    // We are creating one we know will be decoded properly but
    // your byte source could be anything. If any of the packets
    // come back as nil, that means it could not decode it in to
    // the proper layer (malformed or incorrect packet type)
    payload := []byte{2, 4, 6}
    options := gopacket.SerializeOptions{}
    buffer := gopacket.NewSerializeBuffer()
    gopacket.SerializeLayers(buffer, options,
        &layers.Ethernet{},
        &layers.IPv4{},
        &layers.TCP{},
        gopacket.Payload(payload),
    )
    rawBytes := buffer.Bytes()

    // Decode an ethernet packet
    ethPacket :=
        gopacket.NewPacket(
            rawBytes,
            layers.LayerTypeEthernet,
            gopacket.Default,
        )

    // with Lazy decoding it will only decode what it needs when it needs it
    // This is not concurrency safe. If using concurrency, use default
    ipPacket :=
        gopacket.NewPacket(
            rawBytes,
            layers.LayerTypeIPv4,
            gopacket.Lazy,
        )

    // With the NoCopy option, the underlying slices are referenced
    // directly and not copied. If the underlying bytes change so will
    // the packet
    tcpPacket :=
        gopacket.NewPacket(
            rawBytes,
            layers.LayerTypeTCP,
            gopacket.NoCopy,
        )

    fmt.Println(ethPacket)
    fmt.Println(ipPacket)
    fmt.Println(tcpPacket)
}
```

### 定制层

下一个程序将演示如何创建您自己的层。这有助于实现当前不包含在 gopacket layers 包中的协议。如果您想创建自己的 `l33t` 协议，甚至不使用 TCP/IP 或 ethernet，那么它也很有用。

```go
package main

import (
    "fmt"
    "github.com/google/gopacket"
)

// Create custom layer structure
type CustomLayer struct {
    // This layer just has two bytes at the front
    SomeByte    byte
    AnotherByte byte
    restOfData  []byte
}

// Register the layer type so we can use it
// The first argument is an ID. Use negative
// or 2000+ for custom layers. It must be unique
var CustomLayerType = gopacket.RegisterLayerType(
    2001,
    gopacket.LayerTypeMetadata{
        "CustomLayerType",
        gopacket.DecodeFunc(decodeCustomLayer),
    },
)

// When we inquire about the type, what type of layer should
// we say it is? We want it to return our custom layer type
func (l CustomLayer) LayerType() gopacket.LayerType {
    return CustomLayerType
}

// LayerContents returns the information that our layer
// provides. In this case it is a header layer so
// we return the header information
func (l CustomLayer) LayerContents() []byte {
    return []byte{l.SomeByte, l.AnotherByte}
}

// LayerPayload returns the subsequent layer built
// on top of our layer or raw payload
func (l CustomLayer) LayerPayload() []byte {
    return l.restOfData
}

// Custom decode function. We can name it whatever we want
// but it should have the same arguments and return value
// When the layer is registered we tell it to use this decode function
func decodeCustomLayer(data []byte, p gopacket.PacketBuilder) error {
    // AddLayer appends to the list of layers that the packet has
    p.AddLayer(&CustomLayer{data[0], data[1], data[2:]})

    // The return value tells the packet what layer to expect
    // with the rest of the data. It could be another header layer,
    // nothing, or a payload layer.

    // nil means this is the last layer. No more decoding
    // return nil

    // Returning another layer type tells it to decode
    // the next layer with that layer's decoder function
    // return p.NextDecoder(layers.LayerTypeEthernet)

    // Returning payload type means the rest of the data
    // is raw payload. It will set the application layer
    // contents with the payload
    return p.NextDecoder(gopacket.LayerTypePayload)
}

func main() {
    // If you create your own encoding and decoding you can essentially
    // create your own protocol or implement a protocol that is not
    // already defined in the layers package. In our example we are just
    // wrapping a normal ethernet packet with our own layer.
    // Creating your own protocol is good if you want to create
    // some obfuscated binary data type that was difficult for others
    // to decode

    // Finally, decode your packets:
    rawBytes := []byte{0xF0, 0x0F, 65, 65, 66, 67, 68}
    packet := gopacket.NewPacket(
        rawBytes,
        CustomLayerType,
        gopacket.Default,
    )
    fmt.Println("Created packet out of raw bytes.")
    fmt.Println(packet)

    // Decode the packet as our custom layer
    customLayer := packet.Layer(CustomLayerType)
    if customLayer != nil {
        fmt.Println("Packet was successfully decoded with custom layer decoder.")
        customLayerContent, _ := customLayer.(*CustomLayer)
        // Now we can access the elements of the custom struct
        fmt.Println("Payload: ", customLayerContent.LayerPayload())
        fmt.Println("SomeByte element:", customLayerContent.SomeByte)
        fmt.Println("AnotherByte element:", customLayerContent.AnotherByte)
    }
}
```

### 更快地解码 packet

如果我们知道需要什么层，我们可以使用已有的结构来存储 packet 信息，而不是为每个 packet 创建新的结构，既浪费内存又浪费时间。使用 `DecodingLayerParser` 可以更快一点。这就像 marshalling/unmarshalling 数据一样。

```go
package main

import (
    "fmt"
    "github.com/google/gopacket"
    "github.com/google/gopacket/layers"
    "github.com/google/gopacket/pcap"
    "log"
    "time"
)

var (
    device       string = "eth0"
    snapshot_len int32  = 1024
    promiscuous  bool   = false
    err          error
    timeout      time.Duration = 30 * time.Second
    handle       *pcap.Handle
    // Will reuse these for each packet
    ethLayer layers.Ethernet
    ipLayer  layers.IPv4
    tcpLayer layers.TCP
)

func main() {
    // Open device
    handle, err = pcap.OpenLive(device, snapshot_len, promiscuous, timeout)
    if err != nil {
        log.Fatal(err)
    }
    defer handle.Close()

    packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
    for packet := range packetSource.Packets() {
        parser := gopacket.NewDecodingLayerParser(
            layers.LayerTypeEthernet,
            &ethLayer,
            &ipLayer,
            &tcpLayer,
        )
        foundLayerTypes := []gopacket.LayerType{}

        err := parser.DecodeLayers(packet.Data(), &foundLayerTypes)
        if err != nil {
            fmt.Println("Trouble decoding layers: ", err)
        }

        for _, layerType := range foundLayerTypes {
            if layerType == layers.LayerTypeIPv4 {
                fmt.Println("IPv4: ", ipLayer.SrcIP, "->", ipLayer.DstIP)
            }
            if layerType == layers.LayerTypeTCP {
                fmt.Println("TCP Port: ", tcpLayer.SrcPort, "->", tcpLayer.DstPort)
                fmt.Println("TCP SYN:", tcpLayer.SYN, " | ACK:", tcpLayer.ACK)
            }
        }
    }
}
```