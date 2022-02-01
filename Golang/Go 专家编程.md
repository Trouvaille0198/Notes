# 进阶

## 编译原理

Token -> 语法树 AST -> 中间码 -> 机器码

- **词法与语法分析**

    - **词法分析**的作用就是解析源代码文件，它将文件中的字符串序列转换成 **Token 序列**，方便后面的处理和解析

    - **语法分析**器会按照顺序解析 Token 序列，并转换成**语法树**

        - 该过程会将词法分析生成的 Token 按照编程语言定义好的文法（Grammar）自下而上或者自上而下的规约，每一个 Go 的源代码文件最终会被归纳成一个 SourceFile 结构

        - ```go
            SourceFile = PackageClause ";" { ImportDecl ";" } { TopLevelDecl ";" } .
            ```

    - 词法分析会返回一个不包含空格、换行等字符的 Token 序列，例如：`package, json, import, (, io, ), …`，而语法分析会把 Token 序列转换成有意义的结构体，即语法树：

        ```go
        "json.go": SourceFile {
            PackageName: "json",
            ImportDecl: []Import{
                "io",
            },
            TopLevelDecl: ...
        }
        ```

    - 语法解析的过程中发生的任何语法错误都会被语法解析器发现并将消息打印到标准输出上，整个编译过程也会随着错误的出现而被中止。

- **类型检查**

    - Go 语言的编译器会对语法树中定义和使用的类型进行检查，类型检查会按照以下的顺序分别验证和处理不同类型的节点：

        1. 常量、类型和函数名及类型；
        2. 变量的赋值和初始化；
        3. 函数和闭包的主体；
        4. 哈希键值对的类型；
        5. 导入函数体；
        6. 外部的声明；

    - 通过对整棵抽象语法树的遍历，我们在每个节点上都会对当前子树的类型进行验证，以保证节点不存在类型错误，所有的类型错误和不匹配都会在这一个阶段被暴露出来，其中包括：结构体对接口的实现。

        类型检查阶段不止会对节点的类型进行验证，还会展开和改写一些内建的函数，例如 make 关键字在这个阶段会根据子树的结构被替换成 [`runtime.makeslice`](https://draveness.me/golang/tree/runtime.makeslice) 或者 [`runtime.makechan`](https://draveness.me/golang/tree/runtime.makechan) 等函数。

- **中间代码生成**

    - 当我们将源文件转换成了抽象语法树、对整棵树的语法进行解析并进行类型检查之后，就可以认为当前文件中的代码不存在语法错误和类型错误的问题了，Go 语言的编译器就会将输入的抽象语法树转换成中间代码。
    - 在类型检查之后，编译器会通过 [`cmd/compile/internal/gc.compileFunctions`](https://draveness.me/golang/tree/cmd/compile/internal/gc.compileFunctions) 编译整个 Go 语言项目中的全部函数，这些函数会在一个编译队列中等待几个 Goroutine 的消费，并发执行的 Goroutine 会将所有函数对应的抽象语法树转换成中间代码。
    - 由于 Go 语言编译器的中间代码使用了 SSA 的特性，所以在这一阶段我们能够分析出代码中的无用变量和片段并对代码进行优化

- **机器码生成**

    - Go 语言源代码的 [`src/cmd/compile/internal`](https://github.com/golang/go/tree/master/src/cmd/compile/internal) 目录中包含了很多机器码生成相关的包，不同类型的 CPU 分别使用了不同的包生成机器码，其中包括 amd64、arm、arm64、mips、mips64、ppc64、s390x、x86 和 wasm

## 数据结构

### chan

`src/runtime/chan.go:hchan`定义了 channel 的数据结构：

```go
type hchan struct {
    qcount   uint           // 当前队列中剩余元素个数
    dataqsiz uint           // 环形队列长度，即可以存放的元素个数
    buf      unsafe.Pointer // 环形队列指针
    elemsize uint16         // 每个元素的大小
    closed   uint32         // 标识关闭状态
    elemtype *_type         // 元素类型
    sendx    uint           // 队列下标，指示元素写入时存放到队列中的位置
    recvx    uint           // 队列下标，指示元素从队列的该位置读出
    recvq    waitq          // 等待读消息的goroutine队列
    sendq    waitq          // 等待写消息的goroutine队列
    lock mutex              // 互斥锁，chan不允许并发读写
}
```

#### 结构

##### 环形队列

chan 内部实现了一个环形队列作为其缓冲区，队列的长度是创建 chan 时指定的。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220126151305080.png" alt="image-20220126151305080" style="zoom:67%;" />

- `dataqsiz` 指示了队列长度为 6，即可缓存 6 个元素；
- `buf` 指向队列的内存，队列中还剩余两个元素；
- `qcount` 表示队列中还有两个元素；
- `sendx` 指示后续写入的数据存储的位置，取值 `[0, 6)`；
- `recvx` 指示从该位置读取数据, 取值 `[0, 6)`

##### 等待队列

从 channel 读数据，如果 channel 缓冲区为空或者没有缓冲区，当前 goroutine 会被阻塞。 

向 channel 写数据，如果 channel 缓冲区已满或者没有缓冲区，当前 goroutine 会被阻塞。

被阻塞的 goroutine 将会挂在 channel 的等待队列中：

- 因读阻塞的 goroutine 会被向 channel 写入数据的 goroutine 唤醒；
- 因写阻塞的 goroutine 会被从 channel 读数据的 goroutine 唤醒；

下图展示了一个没有缓冲区的 channel，有几个 goroutine 阻塞等待读数据：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220126151613928.png" alt="image-20220126151613928" style="zoom: 80%;" />

注意，一般情况下 `recvq` 和 `sendq ` **至少有一个为空**。只有一个例外，那就是同一个 goroutine 使用 select 语句向 channel 一边写数据，一边读数据。

##### 类型信息

一个 channel 只能传递一种类型的值，类型信息存储在 `hchan` 数据结构中。

- `elemtype` 代表类型，用于数据传递过程中的赋值；
- `elemsize` 代表类型大小，用于在 `buf` 中定位元素位置。

##### 锁

一个 channel 同时仅允许被一个 goroutine 读写，为简单起见，后续部分说明读写过程时不再涉及加锁和解锁。

#### channel 操作

##### 创建

创建 channel 的过程实际上是初始化 `hchan` 结构。其中类型信息和缓冲区长度由 `make` 语句传入，`buf` 的大小则与元素大小和缓冲区长度共同决定。

创建 channel 的伪代码如下所示：

```go
func makechan(t *chantype, size int) *hchan {
    var c *hchan
    c = new(hchan)
    c.buf = malloc(元素类型大小*size)
    c.elemsize = 元素类型大小
    c.elemtype = 元素类型
    c.dataqsiz = size

    return c
}
```

##### 向 channel 中写

向一个 channel 中写数据简单过程如下：

1. 如果等待接收队列 `recvq `不为空，说明缓冲区中没有数据或者没有缓冲区，此时直接从 `recvq `取出 G，并把数据写入，最后把该 G 唤醒，结束发送过程；
2. 如果缓冲区中有空余位置，将数据写入缓冲区，结束发送过程；
3. 如果缓冲区中没有空余位置，将待发送数据写入 G，将当前 G 加入 `sendq`，进入睡眠，等待被读goroutine 唤醒；

简单流程图如下：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220126153234475.png" alt="image-20220126153234475" style="zoom:67%;" />

##### 向 channel 中读

从一个 channel 读数据简单过程如下：

1. 如果等待发送队列 sendq 不为空，且没有缓冲区，直接从 sendq 中取出 G，把 G 中数据读出，最后把 G 唤醒，结束读取过程；
2. 如果等待发送队列 sendq 不为空，此时说明缓冲区已满，从缓冲区中首部读出数据，把 G 中数据写入缓冲区尾部，把 G 唤醒，结束读取过程；
3. 如果缓冲区中有数据，则从缓冲区取出数据，结束读取过程；
4. 将当前 goroutine 加入 `recvq`，进入睡眠，等待被写 goroutine 唤醒；

简单流程图如下：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/NeatReader-1643182471545.png" alt="NeatReader-1643182471545" style="zoom: 80%;" />

##### 关闭

关闭 channel 时会把 `recvq `中的 G 全部唤醒，本该写入 G 的数据位置为 nil。

把 `sendq` 中的 G 全部唤醒，但这些 G 会 panic。

除此之外，panic 出现的常见场景还有：

1. 关闭值为 nil 的 channel
2. 关闭已经被关闭的 channel
3. 向已经关闭的 channel 写数据

#### 常见用法

##### 单项 channel

顾名思义，单向 channel 指只能用于发送或接收数据，实际上也没有单向 channel。

我们知道 channel 可以通过参数传递，所谓单向 channel 只是对 channel 的一种使用限制，这跟 C 语言使用 const 修饰函数参数为只读是一个道理。

- `func readChan(chanName <-chan int)`： 通过形参限定函数内部只能从 channel 中读取数据
- `func writeChan(chanName chan<- int)`： 通过形参限定函数内部只能向 channel 中写入数据

一个简单的示例程序如下：

```go
func readChan(chanName <-chan int) {
    <- chanName
}

func writeChan(chanName chan<- int) {
    chanName <- 1
}

func main() {
    var mychan = make(chan int, 10)

    writeChan(mychan)
    readChan(mychan)
}
```

mychan 是个正常的 channel，而 `readChan()` 参数限制了传入的 channel 只能用来读，`writeChan()` 参数限制了传入的 channel 只能用来写。

##### select

使用 select 可以监控多 channel，比如监控多个 channel，当其中某一个 channel 有数据时，就从其读出数据。

一个简单的示例程序如下：

```go
package main

import (
    "fmt"
    "time"
)

func addNumberToChan(chanName chan int) {
    for {
        chanName <- 1
        time.Sleep(1 * time.Second)
    }
}

func main() {
    var chan1 = make(chan int, 10)
    var chan2 = make(chan int, 10)

    go addNumberToChan(chan1)
    go addNumberToChan(chan2)

    for {
        select {
        case e := <- chan1 :
            fmt.Printf("Get element from chan1: %d\n", e)
        case e := <- chan2 :
            fmt.Printf("Get element from chan2: %d\n", e)
        default:
            fmt.Printf("No element in chan1 and chan2.\n")
            time.Sleep(1 * time.Second)
        }
    }
}
```

程序中创建两个 channel： chan1 和 chan2。函数 `addNumberToChan()` 函数会向两个 channel 中周期性写入数据。通过 select 可以监控两个 channel，任意一个可读时就从其中读出数据。

程序输出如下：

```go
D:\SourceCode\GoExpert\src>go run main.go
Get element from chan1: 1
Get element from chan2: 1
No element in chan1 and chan2.
Get element from chan2: 1
Get element from chan1: 1
No element in chan1 and chan2.
Get element from chan2: 1
Get element from chan1: 1
No element in chan1 and chan2.
```

从输出可见，从 channel 中读出数据的顺序是随机的，事实上 select 语句的多个 case 执行顺序是随机的，关于select 的实现原理会有专门章节分析。

通过这个示例想说的是：select 的 case 语句读 channel 不会阻塞，尽管 channel 中没有数据。这是由于 case 语句编译后调用读 channel 时会明确传入不阻塞的参数，此时读不到数据时不会将当前 goroutine 加入到等待队列，而是直接返回。

##### range

通过 range 可以持续从 channel 中读出数据，好像在遍历一个数组一样，当 channel 中没有数据时会阻塞当前 goroutine，与读 channel 时阻塞处理机制一样。

```go
func chanRange(chanName chan int) {
    for e := range chanName {
        fmt.Printf("Get element from chan: %d\n", e)
    }
}
```

注意：如果向此 channel 写数据的 goroutine 退出时，系统检测到这种情况后会 panic，否则 range 将会永久阻塞。

### slice

Slice 依托数组实现，底层数组对用户屏蔽，在底层数组容量不足时可以实现自动重分配并生成新的 Slice。 

源码包中 `src/runtime/slice.go:slice` 定义了 Slice 的数据结构：

```go
type slice struct {
    array unsafe.Pointer
    len   int
    cap   int
}
```

从数据结构看 Slice 很清晰，array 指针指向底层数组，len 表示切片长度，cap 表示底层数组容量。

#### 使用 make 创建 Slice

使用 make 来创建 Slice 时，可以同时指定长度和容量，创建时底层会分配一个数组，数组的长度即容量。

例如，语句 `slice := make([]int, 5, 10)` 所创建的 Slice，结构如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/slice-01-make_slice.png)

该 Slice 长度为 5，即可以使用下标 slice[0] ~ slice[4] 来操作里面的元素，capacity 为 10，表示后续向 slice 添加新的元素时可以不必重新分配内存，直接使用预留内存即可。

#### 使用数组创建Slice

使用数组来创建 Slice 时，Slice 将与原数组**共用一部分内存**。

例如，语句 `slice := array[5:7]` 所创建的 Slice，结构如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/slice-02-create_slice_from_array.png)

切片从数组 array[5] 开始，到数组 array[7] 结束（不含 array[7]），即切片长度为 2，数组后面的内容都作为切片的预留内存，即 capacity 为 5。

数组和切片操作可能作用于同一块内存，这也是使用过程中需要注意的地方。

#### Slice 扩容

使用 append 向 Slice 追加元素时，如果 Slice 空间不足，将会触发 Slice 扩容

扩容实际上重新一配一块更大的内存，将原 Slice 数据拷贝进新 Slice，然后返回新 Slice，扩容后再将数据追加进去。

例如，当向一个 capacity 为 5，且 length 也为 5 的 Slice 再次追加 1 个元素时，就会发生扩容，如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/slice-03-slice_expand.png)

扩容操作只关心容量，会把原 Slice 数据拷贝到新 Slice，**追加数据由 `append() `在扩容结束后完成**。

上图可见，扩容后新的 Slice 长度仍然是 5，但容量由 5 提升到了 10，原 Slice 的数据也都拷贝到了新 Slice 指向的数组中。

扩容容量的选择遵循以下规则：

- 如果原 Slice 容量小于 1024，则新 Slice 容量将扩大为原来的 2 倍；
- 如果原 Slice 容量大于等于 1024，则新 Slice 容量将扩大为原来的 1.25 倍；

使用 `append()` 向 Slice 添加一个元素的实现步骤如下：

1. 假如 Slice 容量够用，则将新元素追加进去，`Slice.len++`，返回原 Slice
2. 原 Slice 容量不够，则
    1. 将 Slice 先扩容，扩容后得到新 Slice
    2. 将新元素追加进新 Slice，`Slice.len++`，返回新的Slice。

#### Slice Copy

使用 `copy()` 内置函数拷贝两个切片时，会将源切片的数据逐个拷贝到目的切片指向的数组中，**拷贝数量取两个切片长度的最小值。**

例如长度为 10 的切片拷贝到长度为 5 的切片时，将会拷贝 5 个元素。

也就是说，copy 过程中不会发生扩容。

#### 特殊切片

跟据数组或切片生成新的切片一般使用 `slice := array[start:end]` 方式，这种新生成的切片并没有指定切片的容量，实际上新切片的容量是从 start 开始直至 array 的结束。

比如下面两个切片，长度和容量都是一致的，使用共同的内存地址：

```go
sliceA := make([]int, 5, 10)
sliceB := sliceA[0:5]
```

根据数组或切片生成切片还有另一种写法，即切片同时也指定容量，即 `slice[start:end:cap]`, 其中 cap 即为新切片的容量，当然容量不能超过原切片实际值，如下所示：

```go
    sliceA := make([]int, 5, 10)  //length = 5; capacity = 10
    sliceB := sliceA[0:5]         //length = 5; capacity = 10
    sliceC := sliceA[0:5:5]       //length = 5; capacity = 5
```

这切片方法不常见，在 Golang 源码里能够见到，不过非常利于切片的理解。

#### Tips

- 创建切片时可跟据实际需要预分配容量，尽量避免追加过程中扩容操作，有利于提升性能；
- 切片拷贝时需要判断实际拷贝的元素个数
- 谨慎使用多个切片操作同一个数组，以防读写冲突

#### 总结

- 每个切片都指向一个底层数组
- 每个切片都保存了当前切片的长度、底层数组可用容量
- 使用 `len()` 计算切片长度时间复杂度为 O(1)，不需要遍历切片
- 使用 `cap()` 计算切片容量时间复杂度为 O(1)，不需要遍历切片
- 通过函数传递切片时，不会拷贝整个切片，因为切片本身只是个结构体而已
- 使用 `append()` 向切片追加元素时有可能触发扩容，扩容后将会生成新的切片

### map

Golang 的 map 使用哈希表作为底层实现，一个哈希表里可以有多个哈希表节点，也即 bucket，而每个 bucket 就保存了 map 中的一个或一组键值对。

map 数据结构由 `runtime/map.go/hmap` 定义:

```go
type hmap struct {
    count     int // 当前保存的元素个数
    ...
    B         uint8  // 指示bucket数组的大小
    ...
    buckets    unsafe.Pointer // bucket数组指针，数组的大小为2^B
    ...
}
```

下图展示一个拥有 4 个 bucket 的 map：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/map-01-struct.png)

本例中, `hmap.B=2`， 而 `hmap.buckets` 长度是 2^B^ 为 4。元素经过哈希运算后会落到某个 bucket 中进行存储。查找过程类似。

bucket 很多时候被翻译为桶，所谓的**哈希桶**实际上就是 bucket。

#### bucket 数据结构

bucket 数据结构由 `runtime/map.go/bmap` 定义：

```go
type bmap struct {
    tophash [8]uint8 // 存储哈希值的高8位
    data    byte[1]  // key value数据:key/key/key/.../value/value/value...
    overflow *bmap   // 溢出bucket的地址
}
```

每个 bucket 可以存储 8 个键值对。

- `tophash` 是个长度为 8 的数组，哈希值相同的键（准确的说是哈希值低位相同的键）存入当前 bucket 时会将哈希值的高位存储在该数组中，以方便后续匹配。
- data 区存放的是 key-value 数据，存放顺序是 key/key/key/...value/value/value，如此存放是为了节省字节对齐带来的空间浪费。
- overflow 指针指向的是下一个 bucket，据此将所有冲突的键连接起来。

注意：上述中 data 和 overflow 并不是在结构体中显示定义的，而是直接通过指针运算进行访问的。

下图展示 bucket 存放 8 个 key-value 对：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/map-03-struct_sketch.png)

#### 哈希冲突

当有两个或以上数量的键被哈希到了同一个 bucket 时，我们称这些键发生了冲突。Go 使用链地址法来解决键冲突。 由于每个 bucket 可以存放 8 个键值对，所以同一个 bucket 存放超过 8 个键值对时就会再创建一个键值对，用类似链表的方式将 bucket 连接起来。

下图展示产生冲突后的map：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/map-03-struct_sketch.png)

bucket 数据结构指示下一个 bucket 的指针称为 overflow bucket，意为当前 bucket 盛不下而溢出的部分。事实上哈希冲突并不是好事情，它降低了存取效率，好的哈希算法可以保证哈希值的随机性，但冲突过多也是要控制的，后面会再详细介绍。

#### 负载因子

负载因子用于衡量一个哈希表冲突情况，公式为：

```go
负载因子 = 键数量/bucket数量
```

例如，对于一个 bucket 数量为 4，包含 4 个键值对的哈希表来说，这个哈希表的负载因子为 1.

哈希表需要将负载因子控制在合适的大小，超过其阀值需要进行 rehash，也即键值对重新组织：

- 哈希因子过小，说明空间利用率低
- 哈希因子过大，说明冲突严重，存取效率低

每个哈希表的实现对负载因子容忍程度不同

- 比如 Redis 实现中负载因子大于 1 时就会触发 rehash，而 Go 则在在负载因子达到 6.5 时才会触发 rehash，
- 因为 Redis 的每个 bucket 只能存 1 个键值对，而 Go 的 bucket 可能存 8 个键值对，所以 Go 可以容忍更高的负载因子。

#### 渐进式扩容

##### 扩容的前提条件

为了保证访问效率，当新元素将要添加进 map 时，都会检查是否需要扩容，扩容实际上是以空间换时间的手段。 触发扩容的条件有二个：

1. 负载因子 > 6.5 时，也即平均每个 bucket 存储的键值对达到 6.5 个。
2. overflow 数量 > 2^15^ 时，也即 overflow 数量超过 32768 时。

##### 增量扩容

当负载因子过大时，就新建一个 bucket，新的 bucket 长度是原来的 2 倍，然后旧 bucket 数据搬迁到新的 bucket。 考虑到如果 map 存储了数以亿计的 key-value，一次性搬迁将会造成比较大的延时，Go 采用逐步搬迁策略，即每次访问 map 时都会触发一次搬迁，每次搬迁 2 个键值对。

下图展示了包含一个 bucket 满载的 map (为了描述方便，图中 bucket 省略了 value 区域):

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/map-04-struct_sketch.png)

当前 map 存储了 7 个键值对，只有 1 个 bucket。此时负载因子为 7。再次插入数据时将会触发扩容操作，扩容之后再将新插入键写入新的 bucket。

当第 8 个键值对插入时，将会触发扩容，扩容后示意图如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/map-05-struct_sketch.png)

hmap 数据结构中 oldbuckets 成员指身原 bucket，而 buckets 指向了新申请的 bucket。新的键值对被插入新的bucket 中。 后续对 map 的访问操作会触发迁移，将 oldbuckets 中的键值对逐步的搬迁过来。当 oldbuckets 中的键值对全部搬迁完毕后，删除 oldbuckets。

搬迁完成后的示意图如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/map-06-struct_sketch.png)

数据搬迁过程中原 bucket 中的键值对将存在于新 bucket 的前面，新插入的键值对将存在于新 bucket 的后面。 实际搬迁过程中比较复杂，将在后续源码分析中详细介绍。

##### 等量扩容

所谓等量扩容，实际上并不是扩大容量，buckets数量不变，重新做一遍类似增量扩容的搬迁动作，把松散的键值对重新排列一次，以使 bucket 的使用率更高，进而保证更快的存取。 

在极端场景下，比如不断的增删，而键值对正好集中在一小部分的 bucket，这样会造成 overflow 的 bucket 数量增多，但负载因子又不高，从而无法执行增量搬迁的情况，如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/map-07-struct_sketch.png)

上图可见，overflow 的 buckt 中大部分是空的，访问效率会很差。此时进行一次等量扩容，即 buckets 数量不变，经过重新组织后 overflow 的 bucket 数量会减少，即节省了空间又会提高访问效率。

#### 查找过程

查找过程如下：

1. 跟据 key 值算出哈希值
2. 取哈希值低位与 hmpa.B 取模确定 bucket 位置
3. 取哈希值高位在 tophash 数组中查询
4. 如果 tophash[i] 中存储值也哈希值相等，则去找到该 bucket 中的 key 值进行比较
5. 当前 bucket 没有找到，则继续从下个 overflow 的 bucket 中查找。
6. 如果当前处于搬迁过程，则优先从 oldbuckets 查找

注：如果查找不到，也不会返回空值，而是返回相应类型的 0 值。

#### 插入过程

新员素插入过程如下：

1. 跟据 key 值算出哈希值
2. 取哈希值低位与 hmap.B 取模确定 bucket 位置
3. 查找该 key 是否已经存在，如果存在则直接更新值
4. 如果没找到将 key，将 key 插入

### struct

Go 的 struct 声明允许字段附带 `Tag` 来对字段做一些标记。

该 `Tag` 不仅仅是一个字符串那么简单，因为其主要用于反射场景，`reflect` 包中提供了操作 `Tag` 的方法，所以 `Tag` 写法也要遵循一定的规则。

常见的tag用法，主要是JSON数据解析、ORM映射等。

#### Tag的本质

##### Tag 规则

`Tag` 本身是一个字符串，但字符串中却是：`以空格分隔的 key:value 对`。

- `key`：必须是非空字符串，字符串不能包含控制字符、空格、引号、冒号。
- `value`：以双引号标记的字符串
- 注意：冒号前后不能有空格

如下代码所示，如此写没有实际意义，仅用于说明`Tag`规则

```go
type Server struct {
    ServerName string `key1: "value1" key11:"value11"`
    ServerIP   string `key2: "value2"`
}
```

上述代码 `ServerName` 字段的 `Tag` 包含两个 key-value 对。`ServerIP` 字段的 `Tag` 只包含一个 key-value 对。

##### Tag 是 Struct 的一部分

前面说过，`Tag` 只有在反射场景中才有用，而反射包中提供了操作 `Tag` 的方法。在说方法前，有必要先了解一下 Go 是如何管理 struct 字段的。

以下是 `reflect` 包中的类型声明，省略了部分与本文无关的字段。

```go
// A StructField describes a single field in a struct.
type StructField struct {
    // Name is the field name.
    Name string
    ...
    Type      Type      // field type
    Tag       StructTag // field tag string
    ...
}

type StructTag string
```

可见，描述一个结构体成员的结构中包含了 `StructTag`，而其本身是一个 `string`。也就是说 `Tag` 其实是结构体字段的一个组成部分。

##### 获取 Tag

`StructTag` 提供了 `Get(key string) string` 方法来获取 `Tag`，示例如下：

```go
package main

import (
    "reflect"
    "fmt"
)

type Server struct {
    ServerName string `key1:"value1" key11:"value11"`
    ServerIP   string `key2:"value2"`
}

func main() {
    s := Server{}
    st := reflect.TypeOf(s)

    field1 := st.Field(0)
    fmt.Printf("key1:%v\n", field1.Tag.Get("key1"))
    fmt.Printf("key11:%v\n", field1.Tag.Get("key11"))

    filed2 := st.Field(1)
    fmt.Printf("key2:%v\n", filed2.Tag.Get("key2"))
}
```

程序输出如下：

```go
key1:value1
key11:value11
key2:value2
```

#### Tag 存在的意义

本文示例中 tag 没有任何实际意义，这是为了阐述 tag 的定义与操作方法，也为了避免与你之前见过的诸如 `json:xxx` 混淆。

使用反射可以动态的给结构体成员赋值，正是因为有 tag，在赋值前可以使用 tag 来决定赋值的动作。 比如，官方的 `encoding/json` 包，可以将一个JSON数据 `Unmarshal` 进一个结构体，此过程中就使用了 Tag。该包定义一些规则，只要参考该规则设置 tag 就可以将不同的 JSON 数据转换成结构体。

总之：正是基于 struct 的 tag 特性，才有了诸如 json、orm 等等的应用。理解这个关系是至关重要的。或许，你可以定义另一种 tag 规则，来处理你特有的数据。

### iota

我们知道 iota 常用于 const 表达式中，我们还知道其值是从零开始，const 声明块中每增加一行 iota 值自增 1。

使用 iota 可以简化常量定义，但其规则必须要牢牢掌握，否则在阅读别人源码时可能会造成误解或障碍。

#### 规则

很多书上或博客描述的规则是这样的：

1. iota 在 const 关键字出现时被重置为 0
2. const 声明块中每新增一行 iota 值自增 1

其实规则只有一条：

- **iota 代表了 const 声明块的行索引（下标从 0 开始）**

下面再来根据这个规则看下这段代码：

```go
const (
    bit0, mask0 = 1 << iota, 1<<iota - 1   // const声明第0行，即iota==0
    bit1, mask1                            // const声明第1行，即iota==1, 表达式继承上面的语句
    _, _                                   // const声明第2行，即iota==2
    bit3, mask3                            // const声明第3行，即iota==3
)
```

- 第 0 行的表达式展开即 `bit0, mask0 = 1 << 0, 1<<0 - 1`，所以 bit0 == 1，mask0 == 0；
- 第 1 行没有指定表达式，则继承第一行，即 `bit1, mask1 = 1 << 1, 1<<1 - 1`，所以 bit1 == 2，mask1 == 1；
- 第 2 行没有定义常量
- 第 3 行没有指定表达式，则继承第一行，即 `bit3, mask3 = 1 << 3, 1<<3 - 1`，所以 bit0 == 8，mask0 == 7；

#### 编译原理

const 块中每一行在 GO 中使用 spec 数据结构描述，spec 声明如下：

```go
    // A ValueSpec node represents a constant or variable declaration
    // (ConstSpec or VarSpec production).
    //
    ValueSpec struct {
        Doc     *CommentGroup // associated documentation; or nil
        Names   []*Ident      // value names (len(Names) > 0)
        Type    Expr          // value type; or nil
        Values  []Expr        // initial values; or nil
        Comment *CommentGroup // line comments; or nil
    }
```

这里我们只关注 `ValueSpec.Names`， 这个切片中保存了一行中定义的常量，如果一行定义 N 个常量，那么`ValueSpec.Names` 切片长度即为N。

const 块实际上是 spec 类型的切片，用于表示 const 中的多行。

所以编译期间构造常量时的伪算法如下：

```go
    for iota, spec := range ValueSpecs {
        for i, name := range spec.Names {
            obj := NewConst(name, iota...) //此处将iota传入，用于构造常量
            ...
        }
    }
```

从上面可以更清晰的看出 iota 实际上是遍历 const 块的索引，每行中即便多次使用 iota，其值也不会递增。

### string

#### string 标准概念

Go 标准库 `builtin` 给出了所有内置类型的定义。 源代码位于 `src/builtin/builtin.go`，其中关于 string 的描述如下:

```go
// string is the set of all strings of 8-bit bytes, conventionally but not
// necessarily representing UTF-8-encoded text. A string may be empty, but
// not nil. Values of string type are immutable.
type string string
```

所以 string 是 8 比特字节的集合，通常但并不一定是 UTF-8 编码的文本。

另外，还提到了两点，非常重要：

- string 可以为空（长度为 0），但不会是 nil；
- string 对象不可以修改。

#### string 数据结构

源码包 `src/runtime/string.go:stringStruct` 定义了 string 的数据结构：

```go
type stringStruct struct {
    str unsafe.Pointer
    len int
}
```

其数据结构很简单：

- `stringStruct.str`：字符串的首地址；
- `stringStruct.len`：字符串的长度；

string 数据结构跟切片有些类似，只不过切片还有一个表示容量的成员，事实上 string 和切片，准确的说是 byte 切片经常发生转换。

#### string 操作

##### 声明

如下代码所示，可以声明一个 string 变量变赋予初值：

```go
var str string
str = "Hello World"
```

字符串构建过程是先跟据字符串构建 stringStruct，再转换成 string。转换的源码如下：

```go
func gostringnocopy(str *byte) string { // 跟据字符串地址构建string
    ss := stringStruct{str: unsafe.Pointer(str), len: findnull(str)} // 先构造stringStruct
    s := *(*string)(unsafe.Pointer(&ss))                             // 再将stringStruct转换成string
    return s
}
```

string 在 runtime 包中就是 stringStruct，对外呈现叫做 string。

##### []byte 转 string

byte 切片可以很方便的转换成 string，如下所示：

```go
func GetStringBySlice(s []byte) string {
    return string(s)
}
```

需要注意的是这种转换**需要一次内存拷贝**。

转换过程如下：

1. 跟据切片的长度申请内存空间，假设内存地址为 p，切片长度为 len(b)；
2. 构建 string（`string.str = p；string.len = len；`）
3. 拷贝数据 (切片中数据拷贝到新申请的内存空间)

转换示意图：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/string-01-slice2string.png)

##### string 转 []byte

string 也可以方便的转成 byte 切片，如下所示：

```go
func GetSliceByString(str string) []byte {
    return []byte(str)
}
```

string 转换成 byte 切片，也**需要一次内存拷贝**，其过程如下：

- 申请切片内存空间
- 将 string 拷贝到切片

转换示意图：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/string-02-string2slice.png)

##### 字符串拼接

字符串可以很方便的拼接，像下面这样：

```go
str := "Str1" + "Str2" + "Str3"
```

**即便有非常多的字符串需要拼接，性能上也有比较好的保证**，因为新字符串的内存空间是一次分配完成的，所以性能消耗主要在拷贝数据上。

一个拼接语句的字符串编译时都会被存放到一个切片中，拼接过程需要遍历两次切片，第一次遍历获取总的字符串长度，据此申请内存，第二次遍历会把字符串逐个拷贝过去。

字符串拼接伪代码如下：

```go
func concatstrings(a []string) string { // 字符串拼接
    length := 0        // 拼接后总的字符串长度

    for _, str := range a {
        length += length(str)
    }

    s, b := rawstring(length) // 生成指定大小的字符串，返回一个string和切片，二者共享内存空间

    for _, str := range a {
        copy(b, str)    // string无法修改，只能通过切片修改
        b = b[len(str):]
    }

    return s
}
```

因为 string 是无法直接修改的，所以这里使用 `rawstring()` 方法初始化一个指定大小的 string，同时返回一个切片，二者共享同一块内存空间，后面向切片中拷贝数据，也就间接修改了 string。

`rawstring()` 源代码如下：

```go
func rawstring(size int) (s string, b []byte) { // 生成一个新的string，返回的string和切片共享相同的空间
    p := mallocgc(uintptr(size), nil, false)

    stringStructOf(&s).str = p
    stringStructOf(&s).len = size

    *(*slice)(unsafe.Pointer(&b)) = slice{p, size, size}

    return
}
```

#### 思考

##### 为什么字符串不允许修改？

像 C++ 语言中的 string，其本身拥有内存空间，修改 string 是支持的。但 Go 的实现中，string 不包含内存空间，只有一个内存的指针，这样做的好处是 string 变得非常轻量，可以很方便的进行传递而不用担心内存拷贝。

因为 string 通常指向字符串字面量，而字符串字面量存储位置是只读段，而不是堆或栈上，所以才有了 string 不可修改的约定。

##### []byte 转换成 string 一定会拷贝内存吗？

byte 切片转换成 string 的场景很多，为了性能上的考虑，有时候只是临时需要字符串的场景下，byte 切片转换成string 时并不会拷贝内存，而是直接返回一个 string，这个 string 的指针 (`string.str`) 指向切片的内存。

比如，编译器会识别如下临时场景：

- 使用 `m[string(b)]` 来查找 map（map 是 string 为 key，临时把切片 b 转成 string）；
- 字符串拼接，如 `"<" + "string(b)" + ">"`；
- 字符串比较：`string(b) == "foo"`

因为是临时把 byte 切片转换成 string，也就避免了因 byte 切片扩容改成而导致 string 引用失败的情况，所以此时可以不必拷贝内存新建一个 string。

##### string 和 []byte 如何取舍

string 和 []byte 都可以表示字符串，但因数据结构不同，其衍生出来的方法也不同，要跟据实际应用场景来选择。

string 擅长的场景：

- 需要字符串比较的场景；
- 不需要 nil 字符串的场景；

[]byte 擅长的场景：

- 修改字符串的场景，尤其是修改粒度为1个字节；
- 函数返回值，需要用 nil 表示含义的场景；
- 需要切片操作的场景；

虽然看起来 string 适用的场景不如 []byte 多，但因为 string 直观，在实际应用中还是大量存在，在偏底层的实现中 []byte 使用更多。

## 常用控制结构实现原理

本章主要介绍常见的控制结构，比如 defer、select、range 等，通过对其底层实现原理的分析，来加深认识，以此避免一些使用过程中的误区。

### defer

defer 语句用于**延迟函数**的调用，每次 defer 都会把一个函数压入栈中，函数返回前再把延迟的函数取出并执行。

为了方便描述，我们把创建 defer 的函数称为主函数，defer 语句后面的函数称为延迟函数。

延迟函数可能有输入参数，这些参数可能来源于定义 defer 的函数，延迟函数也可能引用主函数用于返回的变量，也就是说延迟函数可能会影响主函数的一些行为，这些场景下，如果不了解 defer 的规则很容易出错。

其实官方说明的 defer 的三个原则很清楚，本节试图汇总 defer 的使用场景并做简单说明。

#### 例子

##### 例一

下面函数输出结果是什么？

```go
func deferFuncParameter() {
    var aInt = 1

    defer fmt.Println(aInt)

    aInt = 2
    return
}
```

输出 1。

> 延迟函数 `fmt.Println(aInt)` 的**参数在 defer 语句出现时就已经确定了**，所以无论后面如何修改 aInt 变量都不会影响延迟函数。

##### 例二

```go
package main

import "fmt"

func printArray(array *[3]int) {
    for i := range array {
        fmt.Println(array[i])
    }
}

func deferFuncParameter() {
    var aArray = [3]int{1, 2, 3}

    defer printArray(&aArray)

    aArray[0] = 10
    return
}

func main() {
    deferFuncParameter()
}
```

输出 10、2、3 三个值。

> 延迟函数 `printArray()` 的参数在defer语句出现时就已经确定了，即数组的地址，由于延迟函数执行时机是在 return 语句之前，所以对数组的最终修改值会被打印出来。

##### 例三

下面函数输出什么？

```go
func deferFuncReturn() (result int) {
    i := 1

    defer func() {
       result++
    }()

    return i
}
```

输出 2。

> 函数的 return 语句并不是原子的，实际执行分为
>
> - 设置返回值
> - ret
>
> defer 语句实际执行在返回前，即拥有 defer 的函数返回过程是：
>
> - 设置返回值
>
> - 执行 defer
> - ret。
>
> 所以 return 语句先把 result 设置为 i 的值，即 1，defer 语句中又把 result 递增 1，所以最终返回 2。

#### defer 规则

Golang 官方博客里总结了 defer 的行为规则，只有三条，我们围绕这三条进行说明。

##### 规则一

**延迟函数的参数在 defer 语句出现时就已经确定下来了**

官方给出一个例子，如下所示：

```go
func a() {
    i := 0
    defer fmt.Println(i)
    i++
    return
}
```

defer 语句中的 `fmt.Println()` 参数 i 值在 defer 出现时就已经确定下来，实际上是拷贝了一份。后面对变量i的修改不会影响 `fmt.Println()` 函数的执行，仍然打印 "0"。

注意：对于指针类型参数，规则仍然适用，只不过延迟函数的参数是一个地址值，这种情况下，defer后面的语句对变量的修改可能会影响延迟函数。

##### 规则二

**延迟函数执行按后进先出顺序执行，即先出现的 defer 最后执行**

这个规则很好理解，定义 defer 类似于入栈操作，执行 defer 类似于出栈操作。

设计 defer 的初衷是简化函数返回时资源清理的动作，资源往往有依赖顺序，比如先申请 A 资源，再跟据 A 资源申请 B 资源，跟据 B 资源申请 C 资源，即申请顺序是：A-->B-->C，释放时往往又要反向进行。

**每申请到一个用完需要释放的资源时，立即定义一个 defer 来释放资源是个很好的习惯。**

##### 规则三

**延迟函数可能操作主函数的具名返回值**

定义 defer 的函数，即主函数可能有返回值，返回值有没有名字没有关系，defer 所作用的函数，即延迟函数可能会影响到返回值。

若要理解延迟函数是如何影响主函数返回值的，只要明白函数是如何返回的就足够了。

#### 函数返回过程

有一个事实必须要了解，关键字 `return` 不是一个原子操作，实际上 `return` 只代理汇编指令 `ret`，即将跳转程序执行。

比如语句 `return i`，实际上分两步进行，即

1. 将 i 值存入栈中作为返回值
2. 执行跳转

而 defer 的执行时机正是跳转前，所以说 defer 执行时还是有机会操作返回值的。

举个实际的例子进行说明这个过程：

```go
func deferFuncReturn() (result int) {
    i := 1

    defer func() {
       result++
    }()

    return i
}
```

该函数的return语句可以拆分成下面两行：

```go
result = i
return
```

而延迟函数的执行正是在return之前，即加入defer后的执行过程如下：

```go
result = i
result++
return
```

所以上面函数实际返回 `i++` 值。

关于主函数有不同的返回方式，但返回机制就如上机介绍所说，只要把 return 语句拆开都可以很好的理解，下面分别举例说明

##### 主函数拥有匿名返回值，返回字面值

一个主函数拥有一个匿名的返回值，返回时使用字面值，比如返回 "1"、"2"、"Hello" 这样的值，这种情况下 defer 语句是无法操作返回值的。

一个返回字面值的函数，如下所示：

```go
func foo() int {
    var i int

    defer func() {
        i++
    }()

    return 1
}
```

上面的 return 语句，直接把 1 写入栈中作为返回值，延迟函数无法操作该返回值，所以就无法影响返回值。

##### 主函数拥有匿名返回值，返回变量

一个主函数拥有一个匿名的返回值，返回使用本地或全局变量，这种情况下 defer 语句可以引用到返回值，但不会改变返回值。

一个返回本地变量的函数，如下所示：

```go
func foo() int {
    var i int

    defer func() {
        i++
    }()

    return i
}
```

上面的函数，返回一个局部变量，同时 defer 函数也会操作这个局部变量。

对于匿名返回值来说，可以假定仍然有一个变量存储返回值，假定返回值变量为 "anony"，上面的返回语句可以拆分成以下过程：

```go
anony = i
i++
return
```

由于 i 是整型，会将值拷贝给 anony，所以 defer 语句中修改i值，对函数返回值不造成影响。

##### 主函数拥有具名返回值

主函声明语句中带名字的返回值，会被初始化成一个局部变量，函数内部可以像使用局部变量一样使用该返回值。如果defer 语句操作该返回值，可能会改变返回结果。

一个影响函返回值的例子：

```go
func foo() (ret int) {
    defer func() {
        ret++
    }()

    return 0
}
```

上面的函数拆解出来，如下所示：

```go
ret = 0
ret++
return
```

函数真正返回前，在 defer 中对返回值做了 +1 操作，所以函数最终返回 1

### defer 实现原理

本节我们尝试了解一些 defer 的实现机制。

#### defer 数据结构

源码包 `src/src/runtime/runtime2.go:_defer` 定义了 defer 的数据结构：

```go
type _defer struct {
    sp      uintptr   //函数栈指针
    pc      uintptr   //程序计数器
    fn      *funcval  //函数地址
    link    *_defer   //指向自身结构的指针，用于链接多个defer
}
```

我们知道 defer 后面一定要接一个函数的，所以defer的数据结构跟一般函数类似，也有栈地址、程序计数器、函数地址等等。

与函数不同的一点是它含有一个指针，可用于指向另一个 defer

每个 goroutine 数据结构中实际上也有一个 defer 指针，该指针指向一个 defer 的单链表

- 每次声明一个 defer 时就将 defer 插入到单链表表头
- 每次执行 defer 时就从单链表表头取出一个 defer 执行。

函数返回前执行 defer 则是从链表首部依次取出执行，不再赘述。

一个 goroutine 可能连续调用多个函数，defer 添加过程跟上述流程一致，进入函数时添加 defer，离开函数时取出 defer，所以即便调用多个函数，也总是能保证 defh后进先出方式执行的。

#### defer 的创建和执行

源码包 `src/runtime/panic.go` 定义了两个方法分别用于创建 defer 和执行 defer。

- `deferproc()`： 在声明 defer 处调用，其将 defer 函数存入 goroutine 的链表中；
- `deferreturn()`：在 return 指令，准确的讲是在 ret 指令前调用，其将 defer 从 goroutine 链表中取出并执行。

可以简单这么理解：在编译阶段，声明 defer 处插入了函数 `deferproc()`；在函数 return 前插入了函数 `deferreturn()`

### 总结

- defer 定义的延迟函数参数在 defer 语句出时就已经确定下来了
- defer 定义顺序与实际执行顺序相反
- return 不是原子操作，执行过程是：保存返回值(若有) --> 执行 defer（若有）--> 执行 ret 跳转
- 申请资源后立即使用 defer 关闭资源是好习惯

### recover

项目中，有时为了让程序更健壮，也即不 `panic`，我们或许会使用 `recover()` 来接收异常并处理。

比如以下代码：

```go
func NoPanic() {
    if err := recover(); err != nil {
        fmt.Println("Recover success...")
    }
}

func Dived(n int) {
    defer NoPanic()

    fmt.Println(1/n)
}
```

`func NoPanic()` 会自动接收异常，并打印相关日志，算是一个通用的异常处理函数。

业务处理函数中只要使用了 `defer NoPanic()`，那么就不会再有 `panic` 发生。

关于是否应该使用 recover 接收异常，以及什么场景下使用等问题不在本节讨论范围内。 本节关注的是这种用法的一个变体，在该变体下，recover 再也无法接收异常。

#### recover 使用误区

在项目中，有众多的数据库更新操作，正常的更新操作需要提交，而失败的就需要回滚，如果异常分支比较多， 就会有很多重复的回滚代码，所以有人尝试了一个做法：即在 defer 中判断是否出现异常，有异常则回滚，否则提交。

简化代码如下所示：

```go
func IsPanic() bool {
    if err := recover(); err != nil {
        fmt.Println("Recover success...")
        return true
    }

    return false
}

func UpdateTable() {
    // defer中决定提交还是回滚
    defer func() {
        if IsPanic() {
            // Rollback transaction
        } else {
            // Commit transaction
        }
    }()

    // Database update operation...
}
```

`func IsPanic() bool` 用来接收异常，返回值用来说明是否发生了异常。`func UpdateTable()` 函数中，使用 defer 来判断最终应该提交还是回滚。

上面代码初步看起来还算合理，但是此处的 `IsPanic()` 再也不会返回 `true`，不是 `IsPanic()` 函数的问题，而是其调用的位置不对。

#### recover 失效的条件

上面代码 `IsPanic()` 失效了，其原因是违反了 recover 的一个限制，导致 `recover()` 失效（永远返回 `nil`）。

以下三个条件会让 `recover()` 返回 `nil`:

1. panic 时指定的参数为 `nil`；（一般 panic 语句如`panic("xxx failed...")`）
2. 当前协程没有发生 panic；
3. recover 没有被 defer 方法**直接调用**；

前两条都比较容易理解，上述例子正是匹配第3个条件。

本例中，`recover()` 调用栈为 `“defer （匿名）函数” --> IsPanic() --> recover()`。也就是说，recover 并没有被defer 方法直接调用。符合第 3 个条件，所以 `recover()` 永远返回 nil

### select

select 是 Golang 在语言层面提供的多路 IO 复用的机制，其可以检测多个 channel 是否 ready (即是否可读或可写)，使用起来非常方便。

#### 实现原理

Golang 实现 select 时，定义了一个数据结构表示每个 case 语句 (含 defaut，default 实际上是一种特殊的 case)，select 执行过程可以类比成一个函数，函数输入 case 数组，输出选中的 case，然后程序流程转到选中的 case 块。

##### case 数据结构

源码包 `src/runtime/select.go:scase` 定义了表示 case 语句的数据结构：

```go
type scase struct {
    c           *hchan         // chan
    kind        uint16
    elem        unsafe.Pointer // data element
}
```

`scase.c` 为当前 case 语句所操作的 `channel` 指针，这也说明了一个 case 语句只能操作一个 channel。
`scase.kind` 表示该 case 的类型，分为读 channel、写 channel 和 default，三种类型分别由常量定义：

- `caseRecv`：case 语句中尝试读取 `scase.c` 中的数据；
- `caseSend`：case 语句中尝试向 `scase.c` 中写入数据；
- `caseDefault`： default 语句

`scase.elem` 表示缓冲区地址，跟据 `scase.kind` 不同，有不同的用途：

- `scase.kind == caseRecv` ： `scase.elem` 表示读出 channel 的数据存放地址；
- `scase.kind == caseSend` ： `scase.elem` 表示将要写入 channel 的数据存放地址；

##### select 实现逻辑

源码包 `src/runtime/select.go:selectgo()` 定义了 select 选择 case 的函数：

```go
func selectgo(cas0 *scase, order0 *uint16, ncases int) (int, bool)
```

函数参数：

- `cas0` 为 scase 数组的首地址，`selectgo()` 就是从这些 scase 中找出一个返回。
- `order0 `为一个两倍 `cas0` 数组长度的 buffer，保存 scase 随机序列 `pollorder `和 scase 中 channel 地址序列 `lockorder`
    - `pollorder`：每次 selectgo 执行都会把 scase 序列打乱，以达到随机检测 case 的目的。
    - `lockorder`：所有 case 语句中 channel 序列，以达到去重防止对 channel 加锁时重复加锁的目的。
- `ncases` 表示 scase 数组的长度

函数返回值：

1. `int`： 选中 case 的编号，这个 case 编号跟代码一致
2. `bool`: 是否成功从 channle 中读取了数据，如果选中的 case 是从 channel 中读数据，则该返回值表示是否读取成功。

`selectgo() `实现伪代码如下：

```go
func selectgo(cas0 *scase, order0 *uint16, ncases int) (int, bool) {
    //1. 锁定scase语句中所有的channel
    //2. 按照随机顺序检测scase中的channel是否ready
    //   2.1 如果case可读，则读取channel中数据，解锁所有的channel，然后返回(case index, true)
    //   2.2 如果case可写，则将数据写入channel，解锁所有的channel，然后返回(case index, false)
    //   2.3 所有case都未ready，则解锁所有的channel，然后返回（default index, false）
    //3. 所有case都未ready，且没有default语句
    //   3.1 将当前协程加入到所有channel的等待队列
    //   3.2 当将协程转入阻塞，等待被唤醒
    //4. 唤醒后返回channel对应的case index
    //   4.1 如果是读操作，解锁所有的channel，然后返回(case index, true)
    //   4.2 如果是写操作，解锁所有的channel，然后返回(case index, false)
}
```

特别说明：对于读 channel 的 case 来说，如 `case elem, ok := <-chan1:`，如果 channel 有可能被其他协程关闭的情况下，一定要检测读取是否成功，因为 close 的 channel 也有可能返回，此时 `ok == false`。

#### 总结

- select 语句中除 default 外，每个 case 操作一个 channel，要么读要么写
- select 语句中除 default 外，各 case 执行顺序是随机的
- select 语句中如果没有 default 语句，则会阻塞等待任一 case
- select 语句中**读操作要判断是否成功读取**，关闭的 channel 也可以读取

### range

range 是 Golang 提供的一种迭代遍历手段，可操作的类型有数组、切片、Map、channel 等，实际使用频率非常高。

探索 range 的实现机制是很有意思的事情，这可能会改变你使用 range 的习惯。

#### 例子

##### 切片遍历

下面函数通过遍历切片，打印切片的下标和元素值，请问性能上有没有可优化的空间？

```go
func RangeSlice(slice []int) {
    for index, value := range slice {
        _, _ = index, value
    }
}
```

遍历过程中每次迭代会对 index 和 value 进行赋值

如果数据量大或者 value 类型为 string 时，对 value 的赋值操作可能是多余的

可以在 for-range 中忽略 value 值，使用 slice[index] 引用 value 值。

##### Map 遍历

下面函数通过遍历 Map，打印 Map 的 key 和 value，请问性能上有没有可优化的空间？

```go
func RangeMap(myMap map[int]string) {
    for key, _ := range myMap {
        _, _ = key, myMap[key]
    }
}
```

函数中 for-range 语句中只获取 key 值，然后跟据 key 值获取 value 值

虽然看似减少了一次赋值，但通过 key 值查找 value 值的性能消耗可能高于赋值消耗。能否优化取决于 map 所存储数据结构特征、结合实际情况进行。

##### 动态遍历

请问如下程序是否能正常结束？

```go
func main() {
    v := []int{1, 2, 3}
    for i:= range v {
        v = append(v, i)
    }
}
```

能够正常结束。循环内改变切片的长度，不影响循环次数，循环次效在循环开始前就已经确定了。

#### 实现原理

对于 for-range 语句的实现，可以从编译器源码中找到答案。
编译器源码 `gofrontend/go/statements.cc/For_range_statement::do_lower()` 方法中有如下注释。

```go
// Arrange to do a loop appropriate for the type.  We will produce
//   for INIT ; COND ; POST {
//           ITER_INIT
//           INDEX = INDEX_TEMP
//           VALUE = VALUE_TEMP // If there is a value
//           original statements
//   }
```

可见 range 实际上是一个 C 风格的循环结构。range 支持数组、数组指针、切片、map 和 channel 类型，对于不同类型有些细节上的差异。

##### range for slice

下面的注释解释了遍历 slice 的过程：

```go
// The loop we generate:
//   for_temp := range
//   len_temp := len(for_temp)
//   for index_temp = 0; index_temp < len_temp; index_temp++ {
//           value_temp = for_temp[index_temp]
//           index = index_temp
//           value = value_temp
//           original body
//   }
```

遍历 slice 前会**先**获取以 slice 的长度 len_temp 作为循环次数，循环体中，每次循环会先获取元素值，如果 for-range 中接收 index 和 value 的话，则会对 index 和 value 进行一次赋值。

由于循环开始前循环次数就已经确定了，所以循环过程中新添加的元素是没办法遍历到的。

另外，数组与数组指针的遍历过程与 slice 基本一致，不再赘述。

##### range for map

下面的注释解释了遍历 map 的过程：

```go
// The loop we generate:
//   var hiter map_iteration_struct
//   for mapiterinit(type, range, &hiter); hiter.key != nil; mapiternext(&hiter) {
//           index_temp = *hiter.key
//           value_temp = *hiter.val
//           index = index_temp
//           value = value_temp
//           original body
//   }
```

遍历 map 时没有指定循环次数，循环体与遍历 slice 类似。由于 map 底层实现与 slice 不同，map 底层使用 hash 表实现，插入数据位置是随机的，所以**遍历过程中新插入的数据不能保证遍历到**。

##### range for channel

遍历 channel 是最特殊的，这是由 channel 的实现机制决定的：

```go
// The loop we generate:
//   for {
//           index_temp, ok_temp = <-range
//           if !ok_temp {
//                   break
//           }
//           index = index_temp
//           original body
//   }
```

channel 遍历是依次从 channel 中读取数据；读取前是不知道里面有多少个元素的。如果 channel 中没有元素，则会阻塞等待，如果 channel 已被关闭，则会解除阻塞并退出循环。

注：

- 上述注释中 index_temp 实际上描述是有误的，应该为 value_temp，因为 index 对于 channel 是没有意义的。
- 使用 for-range 遍历 channel 时只能获取一个返回值。

#### 编程 Tips

- 遍历过程中可以适情况放弃接收 index 或 value，可以一定程度上提升性能
- 遍历 channel 时，如果 channel 中没有数据，可能会阻塞
- 尽量避免遍历过程中修改原数据

#### 总结

- for-range 的实现实际上是 C 风格的 for 循环
- 使用 index, value 接收 range 返回值会发生一次数据拷贝

### mutex

互斥锁是并发程序中对共享资源进行访问控制的主要手段，对此 Go 语言提供了非常简单易用的 Mutex，Mutex 为一结构体类型，对外暴露两个方法 `Lock()` 和 `Unlock()` 分别用于加锁和解锁。

Mutex 使用起来非常方便，但其内部实现却复杂得多，这包括 Mutex 的几种状态。另外，我们也想探究一下 Mutex 重复解锁引起 panic 的原因。

按照惯例，本节内容从源码入手，提取出实现原理，又不会过分纠结于实现细节。

#### Mutex 数据结构

##### Mutex 结构体

源码包 `src/sync/mutex.go:Mutex` 定义了互斥锁的数据结构：

```go
type Mutex struct {
    state int32
    sema  uint32
}
```

- `Mutex.state` 表示互斥锁的状态，比如是否被锁定等。
- `Mutex.sema` 表示信号量，协程阻塞等待该信号量，解锁的协程释放信号量从而唤醒等待信号量的协程。

我们看到 `Mutex.state` 是 32 位的整型变量，内部实现时把该变量分成四份，用于记录 Mutex 的四种状态。

下图展示 Mutex 的内存布局：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/mutex-01-structure.png)

- Locked: 表示该 Mutex 是否已被锁定
    - 0：没有锁定
    - 1：已被锁定。
- Woken: 表示是否有协程已被唤醒
    - 0：没有协程唤醒
    - 1：已有协程唤醒，正在加锁过程中。
- Starving：表示该 Mutex 是否处理饥饿状态
    - 0：没有饥饿
    - 1：饥饿状态，说明有协程阻塞了超过 1ms。
- Waiter: 表示阻塞等待锁的协程个数，协程解锁时根据此值来判断是否需要释放信号量。

**协程之间抢锁实际上是抢给 Locked 赋值的权利**

- 能给 Locked 域置 1，就说明抢锁成功。
- 抢不到的话就阻塞等待Mutex.sema 信号量
- 一旦持有锁的协程解锁，等待的协程会依次被唤醒。

Woken 和 Starving 主要用于控制协程间的抢锁过程，后面再进行了解。

##### Mutex 方法

Mutext 对外提供两个方法，实际上也只有这两个方法：

- `Lock()`：加锁方法
- `Unlock()`：解锁方法

下面我们分析一下加锁和解锁的过程，加锁分成功和失败两种情况，成功的话直接获取锁，失败后当前协程被阻塞，同样，解锁时跟据是否有阻塞协程也有两种处理。

#### 加解锁过程

##### 简单加锁

假定当前只有一个协程在加锁，没有其他协程干扰，那么过程如下图所示：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/mutex-02-lock_without_block.png)

加锁过程会去判断 Locked 标志位是否为 0，如果是 0 则把 Locked 位置 1，代表加锁成功。

从上图可见，加锁成功后，只是 Locked 位置 1，其他状态位没发生变化。

##### 加锁被阻塞

假定加锁时，锁已被其他协程占用了，此时加锁过程如下图所示：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/mutex-03-lock_with_block.png)

从上图可看到，当协程 B 对一个已被占用的锁再次加锁时，Waiter 计数器增加了 1，此时协程 B 将被阻塞，直到Locked 值变为 0 后才会被唤醒。

##### 简单解锁

假定解锁时，没有其他协程阻塞，此时解锁过程如下图所示：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/mutex-04-unlock_without_waiter.png)

由于没有其他协程阻塞等待加锁，所以此时解锁时只需要把 Locked 位置为 0 即可，不需要释放信号量。

##### 解锁并唤醒协程

假定解锁时，有 1 个或多个协程阻塞，此时解锁过程如下图所示：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/mutex-05-unlock_with_waiter.png)

协程 A 解锁过程分为两个步骤

- Locked 位置 0
- 查看到 Waiter>0，所以释放一个信号量，唤醒一个阻塞的协程，被唤醒的协程 B 把 Locked 位置 1，于是协程 B 获得锁。

### 自旋过程

加锁时，如果当前 Locked 位为 1，说明该锁当前由其他协程持有，尝试加锁的协程并**不是马上转入阻塞**，而是会**持续地探测** Locked 位是否变为 0，这个过程即为自旋过程。

自旋时间很短，但如果在自旋过程中发现锁已被释放，那么协程可以立即获取锁。此时即便有协程被唤醒也无法获取锁，只能再次阻塞。

自旋的好处是，当加锁失败时不必立即转入阻塞，有一定机会获取到锁，这样可以避免协程的切换。

#### 什么是自旋

自旋对应于 CPU 的 "PAUSE" 指令，CPU 对该指令什么都不做，相当于 CPU 空转，对程序而言相当于 sleep 了一小段时间，时间非常短，当前实现是 30 个时钟周期。

自旋过程中会持续探测 Locked 是否变为 0，连续两次探测间隔就是执行这些 PAUSE 指令，它不同于 sleep，不需要将协程转为睡眠状态。

#### 自旋条件

加锁时程序会自动判断是否可以自旋，无限制的自旋将会给 CPU 带来巨大压力，所以判断是否可以自旋就很重要了。

自旋必须满足以下所有条件：

- 自旋次数要足够小，通常为 4，即自旋最多 4 次
- CPU 核数要大于 1，否则自旋没有意义，因为此时不可能有其他协程释放锁
- 协程调度机制中的 Process 数量要大于 1，比如使用 `GOMAXPROCS()` 将处理器设置为 1 就不能启用自旋
- 协程调度机制中的可运行队列必须为空，否则会延迟协程调度

可见，自旋的条件是很苛刻的，总而言之就是不忙的时候才会启用自旋。

#### 自旋的优势

自旋的优势是**更充分地利用 CPU，尽量避免协程切换**。

因为当前申请加锁的协程拥有 CPU，如果经过短时间的自旋可以获得锁，当前协程可以继续运行，不必进入阻塞状态。

#### 自旋的问题

如果自旋过程中获得锁，那么之前被阻塞的协程将无法获得锁，如果加锁的协程特别多，每次都通过自旋获得锁，那么之前被阻塞的进程将很难获得锁，从而进入饥饿状态。

为了避免协程长时间无法获取锁，自 1.8 版本以来增加了一个状态，即 Mutex 的 Starving 状态。这个状态下不会自旋，一旦有协程释放锁，那么一定会唤醒一个协程并成功加锁。

### Mutex 模式

前面分析加锁和解锁过程中只关注了 Waiter 和 Locked 位的变化，现在我们看一下 Starving 位的作用。

每个 Mutex 都有两个模式，称为 Normal 和 Starving。下面分别说明这两个模式。

#### normal 模式

默认情况下，Mutex 的模式为 normal。

该模式下，协程如果加锁不成功不会立即转入阻塞排队，而是判断是否满足自旋的条件，如果满足则会启动自旋过程，尝试抢锁。

#### starvation 模式

自旋过程中能抢到锁，一定意味着同一时刻有协程释放了锁，我们知道释放锁时如果发现有阻塞等待的协程，还会释放一个信号量来唤醒一个等待协程，被唤醒的协程得到 CPU 后开始运行，此时发现锁已被抢占了，自己只好再次阻塞，不过阻塞前会判断自上次阻塞到本次阻塞经过了多长时间，如果超过 1ms 的话，会将 Mutex 标记为"饥饿"模式，然后再阻塞。

处于饥饿模式下，不会启动自旋过程，也即一旦有协程释放了锁，那么一定会唤醒协程，被唤醒的协程将会成功获取锁，同时也会把等待计数减 1。

#### Woken 状态

Woken 状态用于加锁和解锁过程的通信，举个例子，同一时刻，两个协程一个在加锁，一个在解锁，在加锁的协程可能在自旋过程中，此时把 Woken 标记为 1，用于通知解锁协程不必释放信号量了，好比在说：你只管解锁好了，不必释放信号量，我马上就拿到锁了。

### 为什么重复解锁要 panic

可能你会想，为什么 Go 不能实现得更健壮些，多次执行 `Unlock()` 也不要 panic？

仔细想想 Unlock 的逻辑就可以理解，这实际上很难做到。Unlock 过程分为将 Locked 置为 0，然后判断 Waiter 值，如果值 >0，则释放信号量。

如果多次 `Unlock()`，那么可能每次都释放一个信号量，这样会唤醒多个协程，多个协程唤醒后会继续在 `Lock()` 的逻辑里抢锁，势必会增加 `Lock()` 实现的复杂度，也会引起不必要的协程切换。

### 编程 Tips

#### 使用 defer 避免死锁

加锁后立即使用 defer 对其解锁，可以有效的避免死锁。

#### 加锁和解锁应该成对出现

加锁和解锁最好出现在同一个层次的代码块中，比如同一个函数。

重复解锁会引起 panic，应避免这种操作的可能性。

### rwmutex

所谓读写锁 RWMutex，完整的表述应该是读写互斥锁，可以说是 Mutex 的一个改进版，在某些场景下可以发挥更加灵活的控制能力，比如：读取数据频率远远大于写数据频率的场景。

例如，程序中写操作少而读操作多，简单的说，如果执行过程是 1 次写然后 N 次读的话，使用 Mutex，这个过程将是串行的，因为即便 N 次读操作互相之间并不影响，但也都需要持有 Mutex 后才可以操作。如果使用读写锁，多个读操作可以同时持有锁，并发能力将大大提升。

实现读写锁需要解决如下几个问题：

1. 写锁需要阻塞写锁：一个协程拥有写锁时，其他协程写锁定需要阻塞
2. 写锁需要阻塞读锁：一个协程拥有写锁时，其他协程读锁定需要阻塞
3. 读锁需要阻塞写锁：一个协程拥有读锁时，其他协程写锁定需要阻塞
4. 读锁不能阻塞读锁：一个协程拥有读锁时，其他协程也可以拥有读锁

下面我们将按照这个思路，即读写锁如何解决这些问题的，来分析读写锁的实现。

读写锁基于 Mutex 实现，实现源码非常简单和简洁，又有一定的技巧在里面。

#### 读写锁数据结构

##### 类型定义

源码包 `src/sync/rwmutex.go:RWMutex` 定义了读写锁数据结构：

```go
type RWMutex struct {
    w           Mutex  //用于控制多个写锁，获得写锁首先要获取该锁，如果有一个写锁在进行，那么再到来的写锁将会阻塞于此
    writerSem   uint32 //写阻塞等待的信号量，最后一个读者释放锁时会释放信号量
    readerSem   uint32 //读阻塞的协程等待的信号量，持有写锁的协程释放锁后会释放信号量
    readerCount int32  //记录读者个数
    readerWait  int32  //记录写阻塞时读者个数
}
```

由以上数据结构可见，读写锁内部仍有一个互斥锁，用于将两个写操作隔离开来，其他的几个都用于隔离读操作和写操作。

下面我们简单看下 RWMutex 提供的 4 个接口，后面再跟据使用场景具体分析这几个成员是如何配合工作的。

##### 接口定义

RWMutex 提供 4 个简单的接口来提供服务：

- `RLock()`：读锁定
- `RUnlock()`：解除读锁定
- `Lock()`：写锁定，与 Mutex 完全一致
- `Unlock()`：解除写锁定，与 Mutex 完全一致

#### `Lock()` 实现逻辑

写锁定操作需要做两件事：

- 获取互斥锁
- 阻塞等待所有读操作结束（如果有的话）

所以 `func (rw *RWMutex) Lock()` 接口实现流程如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/rwmutex-01-lock.png)

#### `Unlock()` 实现逻辑

解除写锁定要做两件事：

- 唤醒因读锁定而被阻塞的协程（如果有的话）
- 解除互斥锁

所以 `func (rw *RWMutex) Unlock()` 接口实现流程如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/rwmutex-02-unlock.png)

#### `RLock()` 实现逻辑

读锁定需要做两件事：

- 增加读操作计数，即 `readerCount++`
- 阻塞等待写操作结束（如果有的话）

所以 `func (rw *RWMutex) RLock()` 接口实现流程如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/rwmutex-03-rlock.png)

#### `RUnlock()` 实现逻辑

解除读锁定需要做两件事：

- 减少读操作计数，即 `readerCount--`
- 唤醒等待写操作的协程（如果有的话）

所以`func (rw *RWMutex) RUnlock()`接口实现流程如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/rwmutex-04-runlock.png)

注意：即便有协程阻塞等待写操作，并不是所有的解除读锁定操作都会唤醒该协程，而是最后一个解除读锁定的协程才会释放信号量将该协程唤醒，因为只有当所有读操作的协程释放锁后才可以唤醒协程。

#### 场景分析

上面我们简单看了下 4 个接口实现原理，接下来我们看一下是如何解决前面提到的几个问题的。

##### 写操作是如何阻止写操作的

读写锁包含一个互斥锁 (Mutex)，写锁定必须要先获取该互斥锁，如果互斥锁已被协程 A 获取（或者协程 A 在阻塞等待读结束），意味着协程 A 获取了互斥锁，那么协程 B 只能阻塞等待该互斥锁。

所以，写操作依赖互斥锁阻止其他的写操作。

##### 写操作是如何阻止读操作的

这个是读写锁实现中最精华的技巧。

我们知道 `RWMutex.readerCount` 是个整型值，用于表示读者数量，不考虑写操作的情况下，每次读锁定将该值 +1，每次解除读锁定将该值 -1，所以 `readerCount `取值为 [0, N]，N 为读者个数，实际上最大可支持 2^30^ 个并发读者。

当写锁定进行时，会先将 `readerCount `减去 2^30^，从而 `readerCount `变成了负值，此时再有读锁定到来时检测到`readerCount `为负值，便知道有写操作在进行，只好阻塞等待。而真实的读操作个数并不会丢失，只需要将`readerCount` 加上 2^30^ 即可获得。

所以，写操作将 `readerCount `变成负值来阻止读操作的。

##### 读操作是如何阻止写操作的

读锁定会先将 `RWMutext.readerCount` 加 1，此时写操作到来时发现读者数量不为 0，会阻塞等待所有读操作结束。

所以，读操作通过 `readerCount` 来将来阻止写操作的。

##### 为什么写锁定不会被饿死

我们知道，写操作要等待读操作结束后才可以获得锁，写操作等待期间可能还有新的读操作持续到来，如果写操作等待所有读操作结束，很可能被饿死。然而，通过 `RWMutex.readerWait` 可完美解决这个问题。

写操作到来时，会把 `RWMutex.readerCount` 值拷贝到 `RWMutex.readerWait` 中，用于标记排在写操作前面的读者个数。

前面的读操作结束后，除了会递减 RWMutex.readerCount，还会递减 RWMutex.readerWait 值，当 RWMutex.readerWait 值变为 0 时唤醒写操作。

所以以，写操作就相当于把一段连续的读操作划分成两部分，前面的读操作结束后唤醒写操作，写操作结束后唤醒后面的读操作。如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/rwmutex-05-lock_not_starving.png)

#### 关于源码

源码地址注解：https://github.com/RainbowMango/GoComments

## Goroutine

本章主要介绍协程及其调度机制。

协程是 GO 语言最大的特色之一，本章我们从协程的概念、GO 协程的实现、GO 协程调度机制等角度来分析。

Goroutine 调度是一个很复杂的机制，尽管 Go 源码中提供了大量的注释，但对其原理没有一个好的理解的情况下去读源码收获不会很大。下面尝试用简单的语言描述一下 Goroutine 调度机制，在此基础上再去研读源码效果可能更好一些。

### 线程池的缺陷

我们知道，在高并发应用中频繁创建线程会造成不必要的开销，所以有了线程池。线程池中预先保存一定数量的线程，而新任务将不再以创建线程的方式去执行，而是将任务发布到任务队列，线程池中的线程不断的从任务队列中取出任务并执行，可以有效的减少线程创建和销毁所带来的开销。

下图展示一个典型的线程池：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/goroutine-01-threadpool.png)

为了方便下面的叙述，我们把任务队列中的每一个任务称作G，而G往往代表一个函数。 线程池中的worker线程不断的从任务队列中取出任务并执行。而worker线程的调度则交给操作系统进行调度。

如果worker线程执行的G任务中发生系统调用，则操作系统会将该线程置为阻塞状态，也意味着该线程在怠工，也意味着消费任务队列的worker线程变少了，也就是说线程池消费任务队列的能力变弱了。

如果任务队列中的大部分任务都会进行系统调用，则会让这种状态恶化，大部分worker线程进入阻塞状态，从而任务队列中的任务产生堆积。

解决这个问题的一个思路就是重新审视线程池中线程的数量，增加线程池中线程数量可以一定程度上提高消费能力，但随着线程数量增多，由于过多线程争抢CPU，消费能力会有上限，甚至出现消费能力下降。 如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/goroutine-02-threadpoolcapacity.png)

# 2. Goroutine调度器

线程数过多，意味着操作系统会不断的切换线程，频繁的上下文切换就成了性能瓶颈。 Go提供一种机制，可以在线程中自己实现调度，上下文切换更轻量，从而达到了线程数少，而并发数并不少的效果。而线程中调度的就是Goroutine.

早期Go版本，比如1.9.2版本的源码注释中有关于调度器的解释。 Goroutine 调度器的工作就是把“ready-to-run”的goroutine分发到线程中。

Goroutine主要概念如下：

- G（Goroutine）: 即Go协程，每个go关键字都会创建一个协程。
- M（Machine）： 工作线程，在Go中称为Machine。
- P(Processor): 处理器（Go中定义的一个摡念，不是指CPU），包含运行Go代码的必要资源，也有调度goroutine的能力。

M必须拥有P才可以执行G中的代码，P含有一个包含多个G的队列，P可以调度G交由M执行。其关系如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/goroutine-03-goroutine_m_p_g.png)

图中M是交给操作系统调度的线程，M持有一个P，P将G调度进M中执行。P同时还维护着一个包含G的队列（图中灰色部分），可以按照一定的策略将G调度到M中执行。

P的个数在程序启动时决定，默认情况下等同于CPU的核数，由于M必须持有一个P才可以运行Go代码，所以同时运行的M个数，也即线程数一般等同于CPU的个数，以达到尽可能的使用CPU而又不至于产生过多的线程切换开销。

程序中可以使用`runtime.GOMAXPROCS()`设置P的个数，在某些IO密集型的场景下可以在一定程度上提高性能。这个后面再详细介绍。

# 3. Goroutine调度策略

## 3.1 队列轮转

上图中可见每个P维护着一个包含G的队列，不考虑G进入系统调用或IO操作的情况下，P周期性的将G调度到M中执行，执行一小段时间，将上下文保存下来，然后将G放到队列尾部，然后从队列中重新取出一个G进行调度。

除了每个P维护的G队列以外，还有一个全局的队列，每个P会周期性的查看全局队列中是否有G待运行并将期调度到M中执行，全局队列中G的来源，主要有从系统调用中恢复的G。之所以P会周期性的查看全局队列，也是为了防止全局队列中的G被饿死。

## 3.2 系统调用

上面说到P的个数默认等于CPU核数，每个M必须持有一个P才可以执行G，一般情况下M的个数会略大于P的个数，这多出来的M将会在G产生系统调用时发挥作用。类似线程池，Go也提供一个M的池子，需要时从池子中获取，用完放回池子，不够用时就再创建一个。

当M运行的某个G产生系统调用时，如下图所示：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/goroutine-04-goroutine_syscall.png)

如图所示，当G0即将进入系统调用时，M0将释放P，进而某个空闲的M1获取P，继续执行P队列中剩下的G。而M0由于陷入系统调用而进被阻塞，M1接替M0的工作，只要P不空闲，就可以保证充分利用CPU。

M1的来源有可能是M的缓存池，也可能是新建的。当G0系统调用结束后，跟据M0是否能获取到P，将会将G0做不同的处理：

1. 如果有空闲的P，则获取一个P，继续执行G0。
2. 如果没有空闲的P，则将G0放入全局队列，等待被其他的P调度。然后M0将进入缓存池睡眠。

## 3.3 工作量窃取

多个P中维护的G队列有可能是不均衡的，比如下图：

![img](http://localhost:8000/0b129d36-10be-4d13-96e7-2d90ed32fbdf/goroutine-05-goroutine_steal.png)

竖线左侧中右边的P已经将G全部执行完，然后去查询全局队列，全局队列中也没有G，而另一个M中除了正在运行的G外，队列中还有3个G待运行。此时，空闲的P会将其他P中的G偷取一部分过来，一般每次偷取一半。偷取完如右图所示。

## 4. GOMAXPROCS设置对性能的影响

一般来讲，程序运行时就将GOMAXPROCS大小设置为CPU核数，可让Go程序充分利用CPU。 在某些IO密集型的应用里，这个值可能并不意味着性能最好。 理论上当某个Goroutine进入系统调用时，会有一个新的M被启用或创建，继续占满CPU。 但由于Go调度器检测到M被阻塞是有一定延迟的，也即旧的M被阻塞和新的M得到运行之间是有一定间隔的，所以在IO密集型应用中不妨把GOMAXPROCS设置的大一些，或许会有好的效果。

# 5.参考文章

## 5.1 《The Go scheduler》http://morsmachine.dk/go-scheduler





本章主要介绍GO语言的自动垃圾回收机制。

自动垃圾回收是GO语言最大的特色之一，也是很有争议的话题。因为自动垃圾回收解放了程序员，使其不用担心内存泄露的问题，争议在于垃圾回收的性能，在某些应用场景下垃圾回收会暂时停止程序运行。

本章从内存分配原理讲起，然后再看垃圾回收原理，最后再聊一些与垃圾回收性能优化相关的话题。
