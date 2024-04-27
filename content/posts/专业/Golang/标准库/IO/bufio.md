---
title: "bufio"
date: 2022-03-10
draft: false
author: "MelonCholi"
tags: [Go 库,io]
categories: [Golang]
---

# bufio

Go 语言在 io 操作中，还提供了一个 bufio 的包，使用这个包可以大幅提高文件读写的效率。

参考：https://www.cnblogs.com/ricklz/p/13188188.html

## 原理

bufio 是通过缓冲来提高效率。

io 操作本身的效率并不低，低的是频繁的访问本地磁盘的文件。所以 bufio 就提供了缓冲区（分配一块内存），读和写都先在缓冲区中，最后再读写文件，来降低访问本地磁盘的次数，从而提高效率。

![image-20220310153950373](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220310153950373.png)

bufio 封装了 io.Reader 或 io.Writer 接口对象，并创建另一个也实现了该接口的对象。

## Reader

`bufio.Reader` 是 bufio 中对 `io.Reader` 的封装

```go
// Reader implements buffering for an io.Reader object.
type Reader struct {
    buf          []byte
    rd           io.Reader // reader provided by the client
    r, w         int       // buf read and write positions
    err          error
    lastByte     int // last byte read for UnreadByte; -1 means invalid
    lastRuneSize int // size of last rune read for UnreadRune; -1 means invalid
}
```

`bufio.Read(p []byte)` 相当于读取大小 `len(p)` 的内容，思路如下：

1. 当缓存区有内容的时，将缓存区内容全部填入 p 并清空缓存区
2. 当缓存区没有内容的时候且 `len(p)>len(buf)`，即要读取的内容比缓存区还要大，直接去文件读取即可
3. 当缓存区没有内容的时候且 `len(p)<len(buf)`，即要读取的内容比缓存区小，缓存区从文件读取内容充满缓存区，并将 p 填满（此时缓存区有剩余内容）
4. 以后再次读取时缓存区有内容，将缓存区内容全部填入 p 并清空缓存区（此时和情况 1 一样）

### 实例化

`bufio` 包提供了两个实例化 `bufio.Reader` 对象的函数：`NewReader` 和 `NewReaderSize`。其中，`NewReader` 函数是调用 `NewReaderSize` 函数实现的：

```go
// NewReader returns a new Reader whose buffer has the default size.
func NewReader(rd io.Reader) *Reader {
    // defaultBufSize = 4096,默认的大小
	return NewReaderSize(rd, defaultBufSize)
}
```

调用的 `NewReaderSize`

```go
// NewReaderSize returns a new Reader whose buffer has at least the specified
// size. If the argument io.Reader is already a Reader with large enough
// size, it returns the underlying Reader.
func NewReaderSize(rd io.Reader, size int) *Reader {
	// Is it already a Reader?
	b, ok := rd.(*Reader)
	if ok && len(b.buf) >= size {
		return b
	}
	if size < minReadBufferSize {
		size = minReadBufferSize
	}
	r := new(Reader)
	r.reset(make([]byte, size), rd)
	return r
}
```

## Writer

`bufio.Writer` 是 bufio 中对 `io.Writer` 的封装

```go
// Writer implements buffering for an io.Writer object.
// If an error occurs writing to a Writer, no more data will be
// accepted and all subsequent writes, and Flush, will return the error.
// After all data has been written, the client should call the
// Flush method to guarantee all data has been forwarded to
// the underlying io.Writer.
type Writer struct {
    err error
    buf []byte
    n   int
    wr  io.Writer
}
```

`bufio.Write(p []byte)` 的思路如下

1. 判断 buf 中可用容量是否可以放下 p
2. 如果能放下，直接把 p 拼接到 buf 后面，即把内容放到缓冲区
3. 如果缓冲区的可用容量不足以放下，且此时缓冲区是空的，直接把 p 写入文件即可
4. 如果缓冲区的可用容量不足以放下，且此时缓冲区有内容，则用 p 把缓冲区填满，把缓冲区所有内容写入文件，并清空缓冲区
5. 判断 p 的剩余内容大小能否放到缓冲区，如果能放下（此时和步骤 1 情况一样）则把内容放到缓冲区
6. 如果 p 的剩余内容依旧大于缓冲区，（注意此时缓冲区是空的，情况和步骤 3 一样）则把 p 的剩余内容直接写入文件

## Scanner

`bufio.Reader` 结构体中所有读取数据的方法，都包含了 `delim` 分隔符，这个用起来很不方便，所以 `Google` 对此在 go1.1 版本中加入了 `bufio.Scanner` 结构体，用于读取数据。

```go
type Scanner struct {
    // 内含隐藏或非导出字段
}
```

Scanner 类型提供了方便的读取数据的接口，如从换行符分隔的文本里读取每一行。

`Scanner.Scan` 方法默认是以换行符 `\n`，作为分隔符。如果你想指定分隔符，`Go` 语言提供了四种方法：

- `ScanBytes` (返回单个字节作为一个 `token`)
- `ScanLines` (返回一行文本)
- `ScanRunes` (返回单个 `UTF-8` 编码的 `rune` 作为一个 `token`
- `ScanWords`(返回通过“空格”分词的单词)。

除了这几个预定的，我们也可以自定义分割函数。

扫描会在抵达输入流结尾、遇到的第一个 `I/O` 错误、`token` 过大不能保存进缓冲时，不可恢复地停止。

当扫描停止后，当前读取位置可能会远在最后一个获得的 `token` 后面。需要更多对错误管理的控制或 `token` 很大，或必须从 `reader` 连续扫描的程序，应使用 `bufio.Reader` 代替。

```go
input := "hello world"
scanner := bufio.NewScanner(strings.NewReader(input))
scanner.Split(bufio.ScanWords)
for scanner.Scan() {
    fmt.Println(scanner.Text())
}
if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "reading input:", err)
}
```