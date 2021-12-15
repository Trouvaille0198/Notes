# io

https://books.studygolang.com/The-Golang-Standard-Library-by-Example/chapter01/01.1.html

io 包为 I/O 原语提供了基本的接口。它主要包装了这些原语的已有实现。

由于这些被接口包装的I/O原语是由不同的低级操作实现，因此，在另有声明之前不该假定它们的并发执行是安全的。

在 io 包中最重要的两个接口：Reader 和 Writer 接口。

![图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/bVbdzja)

## Reader 接口

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}
```

Read 将 len(p) 个字节**读取到 p 中**。

它返回读取的字节数 n（0 <= n <= len(p)） 以及任何遇到的错误。

如果资源内容已全部读取完毕，应该返回 `io.EOF` 错误。

> 即使 Read 返回的 n < len(p)，它也会在调用过程中占用 len(p) 个字节作为暂存空间。
>
> 若可读取的数据不到 len(p) 个字节，Read 会返回可用数据，而不是等待更多数据。

### 例

所有实现了 Read 方法的类型都满足 io.Reader 接口，也就是说，在所有需要 io.Reader 的地方，都可以传递实现了 Read() 方法的类型的实例。

```go
func ReadFrom(reader io.Reader, num int) ([]byte, error) {
    p := make([]byte, num)
    n, err := reader.Read(p)
    if n > 0 {
        return p[:n], nil
    }
    return p, err
}
```

ReadFrom 函数将 io.Reader 作为参数，也就是说，ReadFrom 可以**从任意的地方读取数据**，只要来源实现了 io.Reader 接口。

比如，我们可以从标准输入、文件、字符串等读取数据，示例代码如下：

```go
// 从标准输入读取
data, err = ReadFrom(os.Stdin, 11)

// 从普通文件读取，其中 file 是 os.File 的实例
data, err = ReadFrom(file, 9)

// 从字符串读取
data, err = ReadFrom(strings.NewReader("from string"), 12)
```

> io.EOF 变量的定义：`var EOF = errors.New("EOF")`，是 error 类型。
>
> 根据 reader 接口的说明，在 n > 0 且数据被读完了的情况下，返回的 error 有可能是 EOF 也有可能是 nil。

## Writer 接口

```go
type Writer interface {
    Write(p []byte) (n int, err error)
}
```

Write 将 len(p) 个字节**从 p 中写入到基本数据流中**。

它返回从 p 中被写入的字节数 n（0 <= n <= len(p)）以及任何遇到的引起写入提前停止的错误。若 Write 返回的 `n < len(p)`，它就必须返回一个非 nil 的错误

同样的，所有实现了Write方法的类型都实现了 io.Writer 接口。

### 例

这里，我们通过标准库的例子来学习。

在 fmt 标准库中，有一组函数：Fprint/Fprintf/Fprintln，它们接收一个 io.Wrtier 类型参数（第一个参数），也就是说它们将数据格式化输出到 io.Writer 中。

我们以 fmt.Fprintln 为例

```go
func Println(a ...interface{}) (n int, err error) {
    return Fprintln(os.Stdout, a...) //os.Stdout实现了Writer
}
```

很显然，fmt.Println 会将内容输出到标准输出中。

### 实现了 io.Reader 接口或 io.Writer 接口的类型

> 实现了 io.Reader 或 io.Writer 接口的函数参数是一个接口类型

- os.File 同时实现了 io.Reader 和 io.Writer
- strings.Reader 实现了 io.Reader
- bufio.Reader/Writer 分别实现了 io.Reader 和 io.Writer
- bytes.Buffer 同时实现了 io.Reader 和 io.Writer
- bytes.Reader 实现了 io.Reader
- compress/gzip.Reader/Writer 分别实现了 io.Reader 和 io.Writer
- crypto/cipher.StreamReader/StreamWriter 分别实现了 io.Reader 和 io.Writer
- crypto/tls.Conn 同时实现了 io.Reader 和 io.Writer
- encoding/csv.Reader/Writer 分别实现了 io.Reader 和 io.Writer
- mime/multipart.Part 实现了 io.Reader
- net/conn 分别实现了 io.Reader 和 io.Writer(Conn接口定义了Read/Write)

以上类型中，常用的类型有：os.File、strings.Reader、bufio.Reader/Writer、bytes.Buffer、bytes.Reader

### 关于 os.Stdin 与 os.Stdout

我们还看到 os.Stdin/Stdout 这样的代码，它们似乎分别实现了 io.Reader/io.Writer 接口。实际上在 os 包中有这样的代码：

```go
var (
    Stdin  = NewFile(uintptr(syscall.Stdin), "/dev/stdin")
    Stdout = NewFile(uintptr(syscall.Stdout), "/dev/stdout")
    Stderr = NewFile(uintptr(syscall.Stderr), "/dev/stderr")
)
```

也就是说，Stdin/Stdout/Stderr 只是三个特殊的文件类型的标识（即都是 os.File 的实例），自然也实现了 io.Reader 和 io.Writer。

## ReaderAt 接口

可以通过该接口从指定偏移量处开始读取数据。

```go
type ReaderAt interface {
    ReadAt(p []byte, off int64) (n int, err error)
}
```

ReadAt 从基本输入源的**偏移量 off** 处开始，将 len(p) 个字节读取到 p 中。

它返回读取的字节数 n（0 <= n <= len(p)）以及任何遇到的错误。

> 当 ReadAt 返回的 n < len(p) 时，它就会返回一个 非nil 的错误来解释 为什么没有返回更多的字节。在这一点上，ReadAt 比 Read 更严格。
>
> 即使 ReadAt 返回的 n < len(p)，它也会在调用过程中使用 p 的全部作为暂存空间。若可读取的数据不到 len(p) 字节，ReadAt 就会阻塞,直到所有数据都可用或一个错误发生。 在这一点上 ReadAt 不同于 Read。

### 例

```go
reader := strings.NewReader("Go语言中文网")
p := make([]byte, 6)
n, err := reader.ReadAt(p, 2)
if err != nil {
    panic(err)
}
fmt.Printf("%s, %d\n", p, n)
```

输出：

```
语言, 6
```

## WriterAt 接口

可以通过该接口将数据写入到数据流的特定偏移量之后。

```go
type WriterAt interface {
    WriteAt(p []byte, off int64) (n int, err error)
}
```

WriteAt 从 p 中将 len(p) 个字节写入到偏移量 off 处的基本数据流中。

它返回从 p 中被写入的字节数 n（0 <= n <= len(p)）以及任何遇到的引起写入提前停止的错误。

若 WriteAt 返回的 n < len(p)，它就必须返回一个 非nil 的错误。

### 例

通过简单示例来演示 WriteAt 方法的使用（os.File 实现了 WriterAt 接口）：

```go
file, err := os.Create("writeAt.txt")
if err != nil {
    panic(err)
}
defer file.Close()
file.WriteString("Golang中文社区——这里是多余")
n, err := file.WriteAt([]byte("Go语言中文网"), 24)
if err != nil {
    panic(err)
}
fmt.Println(n)
```

打开文件 WriteAt.txt，内容将是：`Golang中文社区——Go语言中文网`。

**分析**：

`file.WriteString("Golang中文社区——这里是多余")` 往文件中写入 `Golang中文社区——这里是多余`，之后 `file.WriteAt([]byte("Go语言中文网"), 24)` 在文件流的 offset=24 处写入 `Go语言中文网`（会覆盖该位置的内容）。

## ReaderFrom 接口

```go
type ReaderFrom interface {
    ReadFrom(r Reader) (n int64, err error)
}
```

ReadFrom 从 r 中读取数据，直到 EOF 或发生错误。其返回值 n 为读取的字节数。除 io.EOF 之外，在读取过程中遇到的任何错误也将被返回。

如果 ReaderFrom 可用，Copy 函数就会使用它。

### 例

下面的例子简单的实现将文件中的数据全部读取（显示在标准输出）：

```go
file, err := os.Open("writeAt.txt") // file实现了Reader
if err != nil {
    panic(err)
}
defer file.Close()
writer := bufio.NewWriter(os.Stdout) // writer实现了ReaderFrom
writer.ReadFrom(file)
writer.Flush()
```

当然，我们可以通过 ioutil 包的 ReadFile 函数获取文件全部内容。其实，跟踪一下 ioutil.ReadFile 的源码，会发现其实也是通过 ReadFrom 方法实现（用的是 bytes.Buffer，它实现了 ReaderFrom 接口）。

> 如果不通过 ReadFrom 接口来做这件事，而是使用 io.Reader 接口，我们有两种思路：
>
> 1. 先获取文件的大小（File 的 Stat 方法），之后定义一个该大小的 []byte，通过 Read 一次性读取
> 2. 定义一个小的 []byte，不断的调用 Read 方法直到遇到 EOF，将所有读取到的 []byte 连接到一起

## WriterTo 接口

```go
type WriterTo interface {
    WriteTo(w Writer) (n int64, err error)
}
```

WriteTo 将数据写入 w 中，直到没有数据可写或发生错误。其返回值 n 为写入的字节数。 在写入过程中遇到的任何错误也将被返回。

如果 WriterTo 可用，Copy 函数就会使用它。

### 例

```go
reader := bytes.NewReader([]byte("Go语言中文网")) // reader实现了WriterTo
reader.WriteTo(os.Stdout)
```

> ReaderFrom 和 WriterTo 接口实质上传递了 Reader 和 Writer 的数据
>
> 数据源 -> Reader (写入到 p) -> ReaderFrom
>
> WriterTo -> Writer (从 p 中写出) -> 数据流

## Seeker 接口

Seek 方法是用于设置偏移量的，这样可以从某个特定位置开始操作数据流

```go
type Seeker interface {
    Seek(offset int64, whence int) (ret int64, err error)
}
```

Seek 设置下一次 Read 或 Write 的偏移量为 offset

它的解释取决于 whence

- 0 表示相对于文件的起始处
- 1 表示相对于当前的偏移
- 2 表示相对于其结尾处。

Seek 返回新的偏移量和一个错误，如果有的话。

听起来和 ReaderAt/WriteAt 接口有些类似，不过 Seeker 接口更灵活，可以更好的控制读写数据流的位置。

### 例

获取倒数第二个字符（需要考虑 UTF-8 编码，这里的代码只是一个示例）

```go
reader := strings.NewReader("Go语言中文网")
reader.Seek(-6, io.SeekEnd)
r, _, _ := reader.ReadRune()
fmt.Printf("%c\n", r)
```

### 关于 whence

whence 的值，在 io 包中定义了相应的常量，应该使用这些常量

```go
const (
  SeekStart   = 0 // seek relative to the origin of the file
  SeekCurrent = 1 // seek relative to the current offset
  SeekEnd     = 2 // seek relative to the end
)
```

而原先 os 包中的常量已经被标注为Deprecated

```go
// Deprecated: Use io.SeekStart, io.SeekCurrent, and io.SeekEnd.
const (
  SEEK_SET int = 0 // seek relative to the origin of the file
  SEEK_CUR int = 1 // seek relative to the current offset
  SEEK_END int = 2 // seek relative to the end
)
```

## Closer 接口

```go
type Closer interface {
    Close() error
}
```

该接口比较简单，只有一个 Close() 方法，用于关闭数据流。

文件 (os.File)、归档（压缩包）、数据库连接、Socket 等需要手动关闭的资源都实现了 Closer 接口。

实际编程中，经常将 Close 方法的调用放在 defer 语句中。

## 其他接口

### 一些复合接口

ReadCloser、ReadSeeker、ReadWriteCloser、ReadWriteSeeker、ReadWriter、WriteCloser 和 WriteSeeker 接口

这些接口是上面介绍的接口的两个或三个组合而成的新接口。例如 ReadWriter 接口：

```go
type ReadWriter interface {
    Reader
    Writer
}
```

这是 Reader 接口和 Writer 接口的简单组合（内嵌）。

这些接口的作用是：有些时候同时需要某两个接口的所有功能，即必须同时实现了某两个接口的类型才能够被传入使用。可见，io 包中有大量的“小接口”，这样方便组合为“大接口”。

## SectionReader 类型

SectionReader 是一个 struct（没有任何导出的字段），实现了 Read, Seek 和 ReadAt，同时，内嵌了 ReaderAt 接口。结构定义如下：

```go
type SectionReader struct {
    r     ReaderAt    // 该类型最终的 Read/ReadAt 最终都是通过 r 的 ReadAt 实现
    base  int64        // NewSectionReader 会将 base 设置为 off
    off   int64        // 从 r 中的 off 偏移处开始读取数据
    limit int64        // limit - off = SectionReader 流的长度
}
```

该类型读取数据流中部分数据。看一下

```go
func NewSectionReader(r ReaderAt, off int64, n int64) *SectionReader
```

的文档说明就知道了：NewSectionReader 返回一个 SectionReader，它从 r 中的偏移量 off 处读取 n 个字节后以 EOF 停止。

也就是说，SectionReader 只是内部（内嵌）ReaderAt 表示的数据流的一部分：从 off 开始后的 n 个字节。

这个类型的作用是：方便重复操作某一段 (section) 数据流；或者同时需要 ReadAt 和 Seek 的功能。

## LimitedReader 类型

```go
type LimitedReader struct {
    R Reader // underlying reader，最终的读取操作通过 R.Read 完成
    N int64  // max bytes remaining
}
```

从 R 读取但将返回的数据量限制为 N 字节。每调用一次 Read 都将更新 N 来反应新的剩余数量。

也就是说，最多只能返回 N 字节数据。

LimitedReader 只实现了 Read 方法（Reader 接口）。

### 例

使用示例如下：

```go
content := "This Is LimitReader Example"
reader := strings.NewReader(content) //reader实现了Reader
limitReader := &io.LimitedReader{R: reader, N: 8}
for limitReader.N > 0 {
    tmp := make([]byte, 2)
    limitReader.Read(tmp)
    fmt.Printf("%s", tmp)
}
```

输出：

```
This Is
```

可见，通过该类型可以达到 *只允许读取一定长度数据* 的目的。

在 io 包中，LimitReader 函数的实现其实就是调用 LimitedReader：

```go
func LimitReader(r Reader, n int64) Reader { return &LimitedReader{r, n} }
```

## Copy 函数

Copy 函数的签名：

```go
func Copy(dst Writer, src Reader) (written int64, err error)
```

Copy 将 src 复制到 dst，直到在 src 上到达 EOF 或发生错误。它返回复制的字节数，如果有错误的话，还会返回在复制时遇到的第一个错误。

成功的 Copy 返回 err == nil，而非 err == EOF。由于 Copy 被定义为从 src 读取直到 EOF 为止，因此它不会将来自 Read 的 EOF 当做错误来报告。

若 dst 实现了 ReaderFrom 接口，其复制操作可通过调用 dst.ReadFrom(src) 实现。此外，若 src 实现了 WriterTo 接口，其复制操作可通过调用 src.WriteTo(dst) 实现。

### 例

代码：

```go
io.Copy(os.Stdout, strings.NewReader("Go语言中文网"))
```

直接将内容输出（写入 Stdout 中）。

我们甚至可以这么做：

```go
package main

import (
    "fmt"
    "io"
    "os"
)

func main() {
    io.Copy(os.Stdout, os.Stdin)
    fmt.Println("Got EOF -- bye")
}
```

执行：`echo "Hello, World" | go run main.go`

## CopyN 函数

```go
func CopyN(dst Writer, src Reader, n int64) (written int64, err error)
```

CopyN 将 n 个字节 (或到一个error) 从 src 复制到 dst。 它返回复制的字节数以及在复制时遇到的最早的错误。当且仅当 err == nil 时，written == n 。

若 dst 实现了 ReaderFrom 接口，复制操作也就会使用它来实现。

### 例

```go
io.CopyN(os.Stdout, strings.NewReader("Go语言中文网"), 8)
```

会输出：

```
Go语言
```

## WriteString 函数

这是为了方便写入 string 类型提供的函数

```go
func WriteString(w Writer, s string) (n int, err error)
```

WriteString 将 s 的内容写入 w 中，当 w 实现了 WriteString 方法时，会直接调用该方法，否则执行 w.Write([]byte(s))。