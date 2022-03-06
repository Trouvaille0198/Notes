---
title: "Go 进阶"
date: 2022-03-03
draft: false
author: "MelonCholi"
tags: [进阶]
categories: [Golang]
---

# Go 进阶

## 内存对齐

### 引入

```go
type Part1 struct {
    a bool
    b int32
    c int8
    d int64
    e byte
}
```

在开始之前，希望你计算一下 `Part1` 共占用的大小是多少呢？

```go
func main() {
    fmt.Printf("bool size: %d\n", unsafe.Sizeof(bool(true)))
    fmt.Printf("int32 size: %d\n", unsafe.Sizeof(int32(0)))
    fmt.Printf("int8 size: %d\n", unsafe.Sizeof(int8(0)))
    fmt.Printf("int64 size: %d\n", unsafe.Sizeof(int64(0)))
    fmt.Printf("byte size: %d\n", unsafe.Sizeof(byte(0)))
    fmt.Printf("string size: %d\n", unsafe.Sizeof("EDDYCJY"))
}
```

输出结果：

```go
bool size: 1
int32 size: 4
int8 size: 1
int64 size: 8
byte size: 1
string size: 16
```

这么一算，`Part1` 这一个结构体的占用内存大小为 1+4+1+8+1 = 15 个字节。相信有的小伙伴是这么算的，看上去也没什么毛病

真实情况是怎么样的呢？我们实际调用看看，如下：

```go
type Part1 struct {
    a bool
    b int32
    c int8
    d int64
    e byte
}

func main() {
    part1 := Part1{}

    fmt.Printf("part1 size: %d, align: %d\n", unsafe.Sizeof(part1), unsafe.Alignof(part1))
}
```

输出结果：

```go
part1 size: 32, align: 8
```

最终输出为占用 32 个字节。这与前面所预期的结果完全不一样。

在这里要提到 “内存对齐” 这一概念，才能够用正确的姿势去计算。

### 定义

有的小伙伴可能会认为内存读取，就是一个简单的字节数组摆放

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/SZHQJK7.png)

上图表示一个坑一个萝卜的内存读取方式。但实际上 CPU 并不会以一个一个字节去读取和写入内存。

相反 CPU 读取内存是**一块一块读取**的，块的大小可以为 2、4、6、8、16 字节等大小。

块大小我们称其为**内存访问粒度**。如下图：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/mCFZWe8.png)

在样例中，假设访问粒度为 4。 CPU 是以每 4 个字节大小的访问粒度去读取和写入内存的。这才是正确的姿势

#### 例

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/g1RxUTz.png)

在上图中，假设从 Index1 开始读取，将会出现很崩溃的问题。因为它的内存访问边界是不对齐的。因此 CPU 会做一些额外的处理工作。如下：

1. CPU **首次**读取未对齐地址的第一个内存块，读取 0-3 字节。并移除不需要的字节 0
2. CPU **再次**读取未对齐地址的第二个内存块，读取 4-7 字节。并移除不需要的字节 5、6、7 字节
3. 合并 1-4 字节的数据
4. 合并后放入寄存器

从上述流程可得出，不做 “内存对齐” 是一件有点 "麻烦" 的事。因为它会增加许多耗费时间的动作。

而假设做了内存对齐，从 Index0 开始读取 4 个字节，只需要读取一次，也不需要额外的运算。这显然高效很多，是标准的**空间换时间**做法。

#### 为什么要关心对齐

- 你正在编写的代码在性能（CPU、Memory）方面有一定的要求
- 你正在处理向量方面的指令
- 某些硬件平台（ARM）体系不支持未对齐的内存访问

另外作为一个工程师，你也很有必要学习这块知识点哦 :)

#### 为什么要做对齐

- 平台（移植性）原因：不是所有的硬件平台都能够访问任意地址上的任意数据。例如：特定的硬件平台只允许在特定地址获取特定类型的数据，否则会导致异常情况
- 性能原因：若访问未对齐的内存，将会导致 CPU 进行两次内存访问，并且要花费额外的时钟周期来处理对齐及运算。而本身就对齐的内存仅需要一次访问就可以完成读取动作

### 默认系数

在不同平台上的编译器都有自己默认的 “对齐系数”，可通过预编译命令 `#pragma pack(n)` 进行变更，n 就是代指 “对齐系数”。一般来讲，我们常用的平台的系数如下：

- 32 位：4
- 64 位：8

另外要注意，不同硬件平台占用的大小和对齐值都可能是不一样的。因此本文的值不是唯一的，调试的时候需按本机的实际情况考虑

#### 类型的对称系数

在 Go 中可以调用 `unsafe.Alignof` 来返回相应**类型的对齐系数**。

```go
func main() {
    fmt.Printf("bool align: %d\n", unsafe.Alignof(bool(true)))
    fmt.Printf("int32 align: %d\n", unsafe.Alignof(int32(0)))
    fmt.Printf("int8 align: %d\n", unsafe.Alignof(int8(0)))
    fmt.Printf("int64 align: %d\n", unsafe.Alignof(int64(0)))
    fmt.Printf("byte align: %d\n", unsafe.Alignof(byte(0)))
    fmt.Printf("string align: %d\n", unsafe.Alignof("EDDYCJY"))
    fmt.Printf("map align: %d\n", unsafe.Alignof(map[string]string{}))
}
```

```go
bool align: 1
int32 align: 4
int8 align: 1
int64 align: 8
byte align: 1
string align: 8
map align: 8
```

通过观察输出结果，可得知基本都是 `2^n`，最大也不会超过 8。这是因为当前测试（64 位）编译器默认对齐系数是 8，因此最大值不会超过这个数

### 结构体的整体对齐

在上小节中，提到了结构体中的成员变量要做字节对齐。那么想当然身为最终结果的结构体，也是需要做字节对齐的

#### 对齐规则

- 结构体的成员变量，第一个成员变量的偏移量为 0。往后的每个成员变量的对齐值必须为**编译器默认对齐长度**（`#pragma pack(n)`）或**当前成员变量类型的长度**（`unsafe.Sizeof`），取**最小值作为当前类型的对齐值**，其偏移量必须为对齐值的整数倍
- 结构体本身，对齐值必须为**编译器默认对齐长度**（`#pragma pack(n)`）或**结构体的所有成员变量类型中的最大长度**，取**最大数的最小整数倍**作为对齐值
- 结合以上两点，可得知若**编译器默认对齐长度**（`#pragma pack(n)`）超过结构体内成员变量的类型最大长度时，默认对齐长度是没有任何意义的

#### 分析流程

![image-20220303194913655](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303194913655.png)

##### 变量对齐

- 第一个成员 a

    - 类型为 bool

    - 大小/对齐值为 1 字节

    - 初始地址，偏移量为 0。占用了第 1 位

- 第二个成员 b

    - 类型为 int32

    - 大小/对齐值为 4 字节

    - 根据规则 1，其偏移量必须为 4 的整数倍。确定偏移量为 4，因此 2-4 位为 Padding。而当前数值从第 5 位开始填充，到第 8 位。如下：axxx|bbbb

- 第三个成员 c

    - 类型为 int8

    - 大小/对齐值为 1 字节

    - 根据规则1，其偏移量必须为 1 的整数倍。当前偏移量为 8。不需要额外对齐，填充 1 个字节到第 9 位。如下：axxx|bbbb|c...

- 第四个成员 d

    - 类型为 int64

    - 大小/对齐值为 8 字节

    - 根据规则 1，其偏移量必须为 8 的整数倍。确定偏移量为 16，因此

        9-16 位为 Padding。而当前数值从第 17 位开始写入，到第 24 位。如下：axxx|bbbb|cxxx|xxxx|dddd|dddd

- 第五个成员 e

    - 类型为 byte

    - 大小/对齐值为 1 字节

    - 根据规则 1，其偏移量必须为 1 的整数倍。当前偏移量为 24。不需要额外对齐，填充 1 个字节到第 25 位。如下：axxx|bbbb|cxxx|xxxx|dddd|dddd|e...

##### 整体对齐

在每个成员变量进行对齐后，根据规则 2，整个结构体本身也要进行字节对齐，因为可发现它可能并不是 `2^n`，不是偶数倍。显然不符合对齐的规则

根据规则 2，可得出对齐值为 8。现在的偏移量为 25，不是 8 的整倍数。因此确定偏移量为 32。对结构体进行对齐

axxx|bbbb|cxxx|xxxx|dddd|dddd|exxx|xxxx

### 调整字段顺序来优化内存

在上一小节，可得知根据成员变量的类型不同，其结构体的内存会产生对齐等动作。那假设字段顺序不同，会不会有什么变化呢？我们一起来试试吧 :-)

```go
type Part1 struct {
    a bool
    b int32
    c int8
    d int64
    e byte
}

type Part2 struct {
    e byte
    c int8
    a bool
    b int32
    d int64
}

func main() {
    part1 := Part1{}
    part2 := Part2{}

    fmt.Printf("part1 size: %d, align: %d\n", unsafe.Sizeof(part1), unsafe.Alignof(part1))
    fmt.Printf("part2 size: %d, align: %d\n", unsafe.Sizeof(part2), unsafe.Alignof(part2))
}
```

```go
part1 size: 32, align: 8
part2 size: 16, align: 8
```

通过结果可以惊喜的发现，只是 “简单” 对成员变量的字段顺序进行改变，就改变了结构体占用大小

Part1 内存布局：axxx|bbbb|cxxx|xxxx|dddd|dddd|exxx|xxxx

Part2 内存布局：ecax|bbbb|dddd|dddd

通过**调整结构体内成员变量的字段顺序**可以达到缩小结构体占用大小的的效果，因为它巧妙地减少了 Padding 的存在，让它们更 “紧凑” 了。这一点对于加深 Go 的内存布局印象和大对象的优化非常有帮助。

## 边界检查消除

Go 是一个内存安全的语言。在数组和切片的索引和子切片操作中，Go 运行时将检查操作中使用的下标是否越界。 如果下标越界，一个恐慌将产生，以防止这样的操作破坏内存安全。这样的检查称为**边界检查**。 

边界检查使得我们的代码能够安全地运行；但是另一方面，也使得我们的代码运行效率略微降低。

从 Go 官方工具链 1.7 开始，官方标准编译器使用了一个新的基于 SSA（single-assignment form，静态单赋值形式）的后端。 SSA 使得 Go 编译器可以有效利用诸如 [BCE](https://en.wikipedia.org/wiki/Bounds-checking_elimination)（bounds check elimination，边界检查消除）和 [CSE](https://en.wikipedia.org/wiki/Common_subexpression_elimination)（common subexpression elimination，公共子表达式消除）等优化：

-  BCE 可以避免很多不必要的边界检查
- CSE 可以避免很多重复表达式的计算，从而使得编译器编译出的程序执行效率更高。

有时候这些优化的效果非常明显。

本文将展示一些例子来解释边界检查消除在官方标准编译器 1.7+ 中的表现。

对于 Go 官方工具链 1.7+，我们可以使用编译器选项 `-gcflags="-d=ssa/check_bce/debug=1"` 来列出哪些代码行仍然需要边界检查。

### 例子 1

```go
// example1.go
package main

func f1(s []int) {
	_ = s[0] // 第5行： 需要边界检查
	_ = s[1] // 第6行： 需要边界检查
	_ = s[2] // 第7行： 需要边界检查
}

func f2(s []int) {
	_ = s[2] // 第11行： 需要边界检查
	_ = s[1] // 第12行： 边界检查消除了！
	_ = s[0] // 第13行： 边界检查消除了！
}

func f3(s []int, index int) {
	_ = s[index] // 第17行： 需要边界检查
	_ = s[index] // 第18行： 边界检查消除了！
}

func f4(a [5]int) {
	_ = a[4] // 第22行： 边界检查消除了！
}

func main() {}
```

```shell
$ go run -gcflags="-d=ssa/check_bce/debug=1" example1.go
./example1.go:5: Found IsInBounds
./example1.go:6: Found IsInBounds
./example1.go:7: Found IsInBounds
./example1.go:11: Found IsInBounds
./example1.go:17: Found IsInBounds
```

我们可以看到函数 `f2` 中的第 *12* 行和第 *13* 行不再需要边界检查了，因为第 *11* 行的检查确保了第 *12* 行和第 *13* 行中使用的下标肯定不会越界。

但是，函数 `f1` 中的三行仍然都需要边界检查，因为第 *5* 行中的边界检查不能保证第 *6* 行和第 *7* 行中的下标没有越界，第 *6* 行中的边界检查也不能保证第第 *7* 行中的下标没有越界。

在函数 `f3` 中，编译器知道如果第一个 `s[index]` 是安全的，则第二个 `s[index]` 是无需边界检查的。

编译器也正确地认为函数 `f4` 中的唯一一行（第 *22* 行）是无需边界检查的。

### 例子 2

```go
// example2.go
package main

func f5(s []int) {
	for i := range s {
		_ = s[i]
		_ = s[i:len(s)]
		_ = s[:i+1]
	}
}

func f6(s []int) {
	for i := 0; i < len(s); i++ {
		_ = s[i]
		_ = s[i:len(s)]
		_ = s[:i+1]
	}
}

func f7(s []int) {
	for i := len(s) - 1; i >= 0; i-- {
		_ = s[i] // line22
		_ = s[i:len(s)]
	}
}

func f8(s []int, index int) {
	if index >= 0 && index < len(s) {
		_ = s[index]
		_ = s[index:len(s)]
	}
}

func f9(s []int) {
	if len(s) > 2 {
	    _, _, _ = s[0], s[1], s[2]
	}
}

func main() {}
$ go run -gcflags="-d=ssa/check_bce/debug=1" example2.go
```

官方标准编译器消除了上例程序中的所有边界检查。

> 注意：在 Go 官方工具链 1.11 之前，官方标准编译器没有足够聪明到认为第 *22* 行是不需要边界检查的。

### 例子 3

```go
// example3.go
package main

import "math/rand"

func fa() {
	s := []int{0, 1, 2, 3, 4, 5, 6}
	index := rand.Intn(7)
	_ = s[:index] // 第9行： 需要边界检查
	_ = s[index:] // 第10行： 边界检查消除了！
}

func fb(s []int, index int) {
	_ = s[:index] // 第14行： 需要边界检查
	_ = s[index:] // 第15行： 需要边界检查（不够智能？）
}

func fc() {
	s := []int{0, 1, 2, 3, 4, 5, 6}
	s = s[:4]
	index := rand.Intn(7)
	_ = s[:index] // 第22行： 需要边界检查
	_ = s[index:] // 第23行： 需要边界检查（不够智能？）
}

func main() {}
```

```shell
$ go run -gcflags="-d=ssa/check_bce/debug=1" example3.go
./example3.go:9: Found IsSliceInBounds
./example3.go:14: Found IsSliceInBounds
./example3.go:15: Found IsSliceInBounds
./example3.go:22: Found IsSliceInBounds
./example3.go:23: Found IsSliceInBounds
```

噢，仍然有这么多的边界检查！

但是等等，为什么官方标准编译器认为第 *10* 行不需要边界检查，却认为第 *15* 和第 *23* 行仍旧需要边界检查呢？ 是标准编译器不够智能吗？

事实上，这里标准编译器做得对。原因是**一个子切片表达式中的起始下标可能会大于基础切片的长度**。 

让我们先看一个简单的使用了子切片的例子：

```go
package main

func main() {
	s0 := make([]int, 5, 10)
	// len(s0) == 5, cap(s0) == 10

	index := 8

	// 在Go中，对于一个子切片表达式s[a:b]，a和b须满足
	// 0 <= a <= b <= cap(s);否则，将产生一个恐慌。

	_ = s0[:index]
	// 上一行是安全的不能保证下一行是无需边界检查的。
	// 事实上，下一行将产生一个恐慌，因为起始下标
	// index大于终止下标（即切片s0的长度）。
	_ = s0[index:] // panic
}
```

所以 **如果`s[:index]`是安全的，则`s[index:]`是无需边界检查的** 这条论述只有在 `len(s)` 和 `cap(s)` 相等的情况下才正确。这就是函数 `fb` 和 `fc` 中的代码仍旧需要边界检查的原因。

而在例子 3 中，标准编译器成功地检测到在函数 `fa` 中 `len(s)` 和 `cap(s)` 是相等的。

### 例子 4

```go
// example4.go
package main

import "math/rand"

func fb2(s []int, index int) {
	_ = s[index:] // 第7行： 需要边界检查
	_ = s[:index] // 第8行： 边界检查消除了！
}

func fc2() {
	s := []int{0, 1, 2, 3, 4, 5, 6}
	s = s[:4]
	index := rand.Intn(7)
	_ = s[index:] // 第15行： 需要边界检查
	_ = s[:index] // 第16行： 边界检查消除了！
}

func main() {}
$ go run -gcflags="-d=ssa/check_bce/debug=1" example4.go
./example4.go:7:7: Found IsSliceInBounds
./example4.go:15:7: Found IsSliceInBounds
```

在此例子中，标准编译器成功推断出：

- 在函数 `fb2` 中，如果第 *7* 行是安全的，则第 *8* 行是无需边界检查的；
- 在函数 `fc2` 中，如果第 *15* 行是安全的，则第 *16* 行是无需边界检查的。

注意：Go 官方工具链 1.9 之前中的标准编译器没有出推断出第 *8* 行不需要边界检查。

### 例子 5

当前版本的标准编译器并非足够智能到可以消除到一切应该消除的边界检查。 有时候，我们需要给标准编译器一些暗示来帮助标准编译器将这些不必要的边界检查消除掉。

```go
// example5.go
package main

func fd(is []int, bs []byte) {
	if len(is) >= 256 {
		for _, n := range bs {
			_ = is[n] // 第7行： 需要边界检查
		}
	}
}

func fd2(is []int, bs []byte) {
	if len(is) >= 256 {
		is = is[:256] // 第14行： 一个暗示
		for _, n := range bs {
			_ = is[n] // 第16行： 边界检查消除了！
		}
	}
}

func fe(isa []int, isb []int) {
	if len(isa) > 0xFFF {
		for _, n := range isb {
			_ = isa[n & 0xFFF] // 第24行： 需要边界检查
		}
	}
}

func fe2(isa []int, isb []int) {
	if len(isa) > 0xFFF {
		isa = isa[:0xFFF+1] // 第31行： 一个暗示
		for _, n := range isb {
			_ = isa[n & 0xFFF] // 第33行： 边界检查消除了！
		}
	}
}

func main() {}
$ go run -gcflags="-d=ssa/check_bce/debug=1" example5.go
./example5.go:7: Found IsInBounds
./example5.go:24: Found IsInBounds
```

### 总结

本文上面列出的例子并没有涵盖标准编译器支持的所有边界检查消除的情形。本文列出的仅仅是一些常见的情形。

尽管标准编译器中的边界检查消除特性依然不是 100% 完美，但是对很多常见的情形，它确实很有效。 自从标准编译器支持此特性以来，在每个版本更新中，此特性都在不断地改进增强。 无需质疑，在以后的版本中，标准编译器会更加得智能，以至于上面第 5 个例子中提供给编译器的暗示有可能将变得不再必要。 

## 延迟函数调用

> deferred function call

在Go中，一个函数调用可以跟在一个 `defer` 关键字后面，形成一个延迟函数调用。 和协程调用类似，**被延迟的函数调用的所有返回值必须全部被舍弃。**

当一个函数调用被延迟后，它不会立即被执行。它将被推入由当前协程维护的一个延迟调用堆栈。 当一个函数调用（可能是也可能不是一个延迟调用）返回并进入它的[退出阶段](https://gfw.go101.org/article/function-declarations-and-calls.html#exiting-phase)后，所有在此函数调用中已经被推入的延迟调用将被按照它们被推入堆栈的顺序逆序执行。 当所有这些延迟调用执行完毕后，此函数调用也就真正退出了。

下面这个例子展示了如何使用延迟调用函数。

```go
package main

import "fmt"

func main() {
	defer fmt.Println("The third line.")
	defer fmt.Println("The second line.")
	fmt.Println("The first line.")
}
```

输出结果：

```
The first line.
The second line.
The third line.
```

事实上，每个协程维护着两个调用堆栈。

- 一个是正常的函数调用堆栈。在此堆栈中，相邻的两个调用存在着调用关系。晚进入堆栈的调用被早进入堆栈的调用所调用。 此堆栈中最早被推入的调用是对应协程的启动调用。
- 另一个堆栈是上面提到的延迟调用堆栈。处于延迟调用堆栈中的任意两个调用之间不存在调用关系。

下面是另一个略微复杂一点的使用了延迟调用的例子程序。此程序将按照自然数的顺序打印出 0 到 9 十个数字。

```go
package main

import "fmt"

func main() {
	defer fmt.Println("9")
	fmt.Println("0")
	defer fmt.Println("8")
	fmt.Println("1")
	if false {
		defer fmt.Println("not reachable")
	}
	defer func() {
		defer fmt.Println("7")
		fmt.Println("3")
		defer func() {
			fmt.Println("5")
			fmt.Println("6")
		}()
		fmt.Println("4")
	}()
	fmt.Println("2")
	return
	defer fmt.Println("not reachable")
}
```

### 一个延迟调用可以修改包含此延迟调用的最内层函数的返回值

一个例子：

```go
package main

import "fmt"

func Triple(n int) (r int) {
	defer func() {
		r += n // 修改返回值
	}()

	return n + n // <=> r = n + n; return
}

func main() {
	fmt.Println(Triple(5)) // 15
}
```

### 延迟函数调用的必要性和好处

事实上，上面的几个使用了延迟函数调用的例子中的延迟函数调用并非绝对必要。 但是延迟调用对于下面将要介绍的恐慌 / 恢复特性是必要的。

另外延迟函数调用可以帮助我们写出更整洁和更鲁棒的代码。

### :star: 协程和延迟调用的实参的估值时刻 

一个协程调用或者延迟调用的实参是在此调用发生时被估值的。更具体地说，

- 对于一个**延迟函数调用**，它的实参是在此调用**被推入延迟调用堆栈**的时候被估值的。
- 对于一个**协程调用**，它的实参是在此协程**被创建**的时候估值的。

- 一个**匿名函数**体内的表达式是在此函数被**执行**的时候才会被逐个估值的，不管此函数是被普通调用还是延迟 / 协程调用。

一个例子：

```go
package main

import "fmt"

func main() {
	func() {
		for i := 0; i < 3; i++ {
			defer fmt.Println("a:", i) // 推入堆栈时被估值
		}
	}()
	fmt.Println()
	func() {
		for i := 0; i < 3; i++ {
			defer func() {
				fmt.Println("b:", i) // 执行时被估值
			}()
		}
	}()
}
```

运行之，将得到如下结果：

```
a: 2
a: 1
a: 0

b: 3
b: 3
b: 3
```

第一个匿名函数中的循环打印出 `2`、`1` 和 `0` 这个序列，但是第二个匿名函数中的循环打印出三个 `3`。 因为第一个循环中的 `i` 是在 `fmt.Println` 函数调用被推入延迟调用堆栈的时候估的值，而第二个循环中的 `i` 是在第二个匿名函数调用的退出阶段估的值（此时循环变量 `i` 的值已经变为 `3`）。

我们可以对第二个循环略加修改（使用两种方法），使得它和第一个循环打印出相同的结果。

```go
for i := 0; i < 3; i++ {
    defer func(i int) {
        // 此i为形参i，非实参循环变量i。
        fmt.Println("b:", i)
    }(i)
}
```

或者

```go
for i := 0; i < 3; i++ {
    i := i // 在下面的调用中，左i遮挡了右i。
    // <=> var i = i
    defer func() {
        // 此i为上面的左i，非循环变量i。
        fmt.Println("b:", i)
    }()
}
```

同样的估值时刻规则也**适用于协程调用**。下面这个例子程序将打印出 `123 789`。

```go
package main

import "fmt"
import "time"

func main() {
	var a = 123
	go func(x int) { // x在创建时被估值
		time.Sleep(time.Second)
		fmt.Println(x, a) // 123 789
	}(a)

	a = 789

	time.Sleep(2 * time.Second)
}
```

> ###### 顺便说一句，使用 `time.Sleep` 调用来做并发同步不是一个好的方法。 如果上面这个程序运行在一个满负荷运行的电脑上，此程序可能在新启动的协程可能还未得到执行机会的时候就已经退出了。

## 恐慌（panic）和恢复（recover）

Go 不支持异常抛出和捕获，而是**推荐使用返回值显式返回错误**。 不过，Go 支持一套和异常抛出 / 捕获类似的机制。此机制称为恐慌 / 恢复（panic/recover）机制。

我们可以调用内置函数 `panic` 来产生一个恐慌以使当前协程进入恐慌状况。

进入恐慌状况是另一种使当前函数调用开始返回的途径。 **一旦一个函数调用产生一个恐慌，此函数调用将立即进入它的退出阶段，在此函数调用中被推入堆栈的延迟调用将按照它们被推入的顺序逆序执行。**

通过在一个延迟函数调用之中调用内置函数 `recover`，当前协程中的一个恐慌可以被消除，从而使得当前协程重新进入正常状况。

**在一个处于恐慌状况的协程退出之前，其中的恐慌不会蔓延到其它协程；如果一个协程在恐慌状况下退出，它将使整个程序崩溃。**

内置函数 `panic` 和 `recover` 的声明原型如下：

```go
func panic(v interface{})
func recover() interface{}
```

在一个 `panic` 函数调用中，我们可以传任何实参值。

一个 `recover` 函数的返回值为其所恢复的恐慌在产生时被一个 `panic` 函数调用所消费的参数。

下面这个例子展示了如何产生一个恐慌和如何消除一个恐慌。

```go
package main

import "fmt"

func main() {
	defer func() {
		fmt.Println("正常退出")
	}()
	fmt.Println("嗨！")
	defer func() {
		v := recover()
		fmt.Println("恐慌被恢复了：", v)
	}()
	panic("拜拜！") // 产生一个恐慌
	fmt.Println("执行不到这里")
}
```

它的输出结果：

```
嗨！
恐慌被恢复了： 拜拜！
正常退出
```

下面的例子在一个新协程里面产生了一个恐慌，并且此协程在恐慌状况下退出，所以整个程序崩溃了。

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("hi!")

	go func() {
		time.Sleep(time.Second)
		panic(123)
	}()

	for {
		time.Sleep(time.Second)
	}
}
```

运行之，输出如下：

```
hi!
panic: 123

goroutine 5 [running]:
...
```

Go运行时（runtime）会在若干情形下产生恐慌，比如一个整数被 0 除的时候。下面这个程序将崩溃退出。

```go
package main

func main() {
	a, b := 1, 0
	_ = a/b
}
```

它的输出：

```
panic: runtime error: integer divide by zero

goroutine 1 [running]:
...
```

一般说来，**恐慌用来表示正常情况下不应该发生的逻辑错误**。 如果这样的一个错误在运行时刻发生了，则它肯定是由于某个 bug 引起的。 另一方面，非逻辑错误是现实中难以避免的错误，它们不应该导致恐慌。 我们必须正确地对待和处理非逻辑错误。

> ###### 对于官方标准编译器来说，很多致命性错误（比如堆栈溢出和内存不足）不能被恢复。它们一旦产生，程序将崩溃。

### 一些恐慌/恢复用例

### 详解恐慌和恢复原理
