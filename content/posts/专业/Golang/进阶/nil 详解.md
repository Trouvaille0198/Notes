---
title: "Go nil 详解"
date: 2022-03-29
draft: false
author: "MelonCholi"
tags: [进阶]
categories: [Golang]
---

# Go nil 详解

```go
a0 := make(map[string][]int, 0)
var a1 []int
a2 := []int{}
a3 := make([]int, 0)

if a0["zero"] == nil {
    // yes
    fmt.Println("a0 is nil")
}
if a1 == nil {
    // yes
    fmt.Println("a1 is nil")
}
if a2 == nil {
    // no
    fmt.Println("a2 is nil")
}
if a3 == nil {
    // no
    fmt.Println("a3 is nil")
}

// won't panic
a0["zero"] = append(a0["zero"], 1)
a1 = append(a1, 1)
a2 = append(a2, 1)
a3 = append(a3, 1)
```

## nil 到底是什么

答案是**变量**

```go
// nil is a predeclared identifier representing the zero value for a
// pointer, channel, func, interface, map, or slice type.
var nil Type // Type must be a pointer, channel, func, interface, map, or slice type

// Type is here for the purposes of documentation only. It is a stand-in
// for any Go type, but represents the same type for any given function
// invocation.
type Type int
```

从类型定义得到**两个关键点**：

1. `nil` 本质上是一个 `Type` 类型的变量而已；
2. `Type` 类型仅仅是基于 `int` 定义出来的一个新类型；

而从 `nil` 官方的注释中，我们可以得到一个重要信息：

**划重点**：`nil` 适用于 **指针**，**函数**，`interface`，`map`，`slice`，`channel` 这 6 种类型

### Go 和 C 的变量定义异同

**相同点**：

Go 和 C 的变量定义回归最本质原理：分配变量指定大小的内存，确定一个变量名称。

**不同点**：

- Go 分配内存是置 0 分配的。置 0 分配的意思是：Go 确保分配出来的内存块里面是全 0 数据；
- C 默认分配的内存则仅仅是分配内存，里面的数据不能做任何假设，里面是未定义的数据，可能是全 0 ，可能是全 1，可能是 `0101` 等；

**Go 置 0 分配的原理**：

- 栈上变量的内存编译阶段由编译器就保证了置 0 分配，这种反汇编看下就知道了；
- 堆上变量的内存由 `runtime` 保证，可以仔细观察下 `mallocgc` 这个函数参数有一个 `needzero` 的参数，用户变量定义触发的入口（比如 `newobject` 等等 ）这个参数为 `true`，而该参数就是显式指定置 0 分配的。

```go
func mallocgc(size uintptr, typ *_type, needzero bool) unsafe.Pointer {
    // ...
}
```

思考一个小问题：Go 既然所用的类型定义都是置 0 分配的，那为什么 `mallocgc` 需要 `needzero` 这么一个参数来控制呢？

- 首先，Go 的类型定义一定确保是置 0 分配的，这个是 Go 语言给到 Go 程序员的语义。Go `runtime` 众多的内部的流程（对 Go 程序员不感知的层面）是没有这个规定的。 
- 其次，置 0 分配是有性能代价的，如果在确保语义的情况下，能不做自然是最好的。

总结下：Go 的变量定义由语言层面确保置 0 分配，**确保内存块全 0 数据**。请记住这个最本质的约定。所以这个本质上跟 `nil` 没有关系，也不存在说初始值赋 `nil` 的说法（虽然 nil 值本质上也仅仅是一个 0 int 大小的内存块）。

至于怎么跟 `nil` 搭上交道的，后面交代。

## 怎么理解 `nil`

通过上面，我们理解了几个东西：

1. Go 的类型定义仅比 C 多做了一件事，把分配的内存块置 0，而已；
2. 能够和 nil 值做判断的，仅仅有 6 个类型。如果你用来其他类型来和 nil 比较，那么在编译期间 `typecheck` 会报错检查到会报错；

就笔者理解，`nil` 这个概念是更高一层的概念，在语言级别，而这个概念是由编译器带给你的。

不是所有的类型都可以和 `nil` 进行比较或者赋值，只有这 6 种类型的变量才能和 nil 值比较，因为这是编译器决定的。

同样的，你不能赋值一个 `nil` 变量给一个整型，原理也很简单，仅仅是编译器不让，就这么简单。

所以，`nil` 其实更准确的理解是一个触发条件，编译器看到和 `nil` 值比较的写法，那么就要确认类型在这 6 种类型以内，如果是赋值 `nil`，那么也要确认在这 6 种类型以内，并且对应的结构内存为全 0 数据。

所以，记住这句话，`nil` 是编译器识别行为的一个触发点而已，看到这个 `nil` 会触发编译器的一些特殊判断和操作。

## 和 `nil` 打交道的 6 大类型

### slice

#### 变量定义

创建 `slice` 有两种方法

1. `var` 关键字定义；
2. `make` 关键字创建；

```go
// 方式一
var slice1 []byte
var slice2 []byte = []byte{0x1, 0x2, 0x3}

// 方式二
var slice3 = make([]byte, 0)
var slice4 = make([]byte, 3)
```

首先，slice 变量本身占多少个字节？

答案是：24 个字节。1 个指针字段，2 个 8 字节的整形字段。

**思考：`var` 和 `make` 这两种方式有什么区别？**

- 第一种 `var` 的方式定义变量纯粹真的是变量定义，如果逃逸分析之后，确认可以分配在栈上，那就在栈上分配这 24 个字节，如果逃逸到堆上去，那么调用 `newobject` 函数进行类型分配。
- 第二种 `make` 方式则略有不同，如果逃逸分析之后，确认分配在栈上，那么也是直接在栈上分配 24 字节，如果逃逸到堆上则会导致调用 `makeslice` 函数来分配变量。

#### 变量本身

定义的变量本身分配了多少内存？

上面已经说过了，无论多大的 slice ，变量本身占用 24 字节。这 24 个字节其实是动态数组的管理结构，如下：

```go
type slice struct {
	array unsafe.Pointer    // 管理的内存块首地址
	len   int                    // 动态数组实际使用大小
	cap   int                    // 动态数组内存大小
}
```

该结构体定义在 `src/runtime/slice.go` 里。

划重点：我们看到无论是 `var` 声明定义的 `slice` 变量，还是 `make(xxx，num)` 创建的 `slice` 变量，`slice` 管理结构是已经分配出来了的（也就是 `struct slice` 结构 ）。

所以， 对于 `slice` 来说，其实并不需要 `make` 创建的才能使用，直接用 `var` 定义出来的 `slice` 也能直接使用。如下：

```go
// 定义一个 slice
var slice1 []byte
// 使用这个 slice
slice1 = append(slice1, 0x1)
```

定义的时候，`slice` 结构本身就已经置 0 分配了，这个 24 字节的 `slice` 结构就是管理动态数组的核心。有这个在 `append` 函数就能正常处理 `slice` 变量。

**思考：`append` 又是怎么处理的呢？**

本质是调用 `runtime.growslice` 函数来处理。

#### `nil` 赋值

如果把一个已经存在的 `slice` 结构赋值 `nil` ，会发生什么事情？

```go
var slice2 []byte = []byte{0x1, 0x2, 0x3}

// slice 赋值 nil
slice2 = nil
```

发生什么事？

事情在编译期间就确定了，就是把 slice2 变量**本身**内存块置 0 ，也就是说 slice2 本身的 24 字节的内存块被置 0。

#### `nil` 值判断

编译器认为 `slice` 做可以做 `nil` 判断，那么什么样的 `slice` 认为是 `nil` 的？

**指针值为 0 的，也就是说这个动态数组没有实际数据的时候。**

思考：仅判断指针？对 len 和 cap 两个字段不做判断吗？

- 只对首字段 `array` 做非 0 判断，len，cap 字段不做判断。

如下：

```go
var a []byte = []byte{0x1, 0x2, 0x3}
if a != nil {
}
```

对应的部分汇编代码如下：

```assembly
// 赋值 array 的值
0x00000000004587cd <+93>:	mov    %rax,0x20(%rsp)
// 赋值 len 的值
0x00000000004587d2 <+98>:	movq   $0x3,0x28(%rsp)
// 赋值 cap 的值
0x00000000004587db <+107>:	movq   $0x3,0x30(%rsp)
// 判断 slice 是否是 nil
=> 0x00000000004587e4 <+116>:	test   %rax,%rax
```

不信 Go 只判断首字段？为了验证，自己思考下一下的程序的输出：

```go
package main

import (
	"unsafe"
)

type sliceType struct {
	pdata unsafe.Pointer
	len   int
	cap   int
}

func main() {
	var a []byte

	((*sliceType)(unsafe.Pointer(&a))).len = 0x3
	((*sliceType)(unsafe.Pointer(&a))).cap = 0x4

	if a != nil {
		println("not nil")
	} else {
		println("nil")
	}
}
```

答案是：输出 `nil`。

### map

#### 变量定义

```go
// 变量定义
var m1 map[string]int
// 定义 & 初始化
var m2 = make(map[string]int)
```

和 slice 类似，上面也是两种差别的方式：

- 第一种方式仅仅定义了 m1 变量本身；
- 第二种方式则是分配 m2 的内存，还会调用 `makehmap` 函数（不一定是这个函数，要看逃逸分析的结果，如果是可以栈上分配的，会有一些优化）来创建某个结构，并且把这个函数的返回值赋给 m2；

#### 变量本身

`map` 的变量本身究竟是什么？比如上面的 `m1`，`m2` ?

**m1, m2 变量本身是一个指针，内存占用 8 字节**。这个指针指向的结构才大有来头，指向一个 `struct hmap` 结构。

```go
type hmap struct {
	count     int // # live cells == size of map.  Must be first (used by len() builtin)
	flags     uint8
	B         uint8  // log_2 of # of buckets (can hold up to loadFactor * 2^B items)
	noverflow uint16 // approximate number of overflow buckets; see incrnoverflow for details
	hash0     uint32 // hash seed

	buckets    unsafe.Pointer // array of 2^B Buckets. may be nil if count==0.
	oldbuckets unsafe.Pointer // previous bucket array of half the size, non-nil only when growing
	nevacuate  uintptr        // progress counter for evacuation (buckets less than this have been evacuated)

	extra *mapextra // optional fields
}
```

所以，回到思考问题：为什么 `map` 结构却光定义还不行，一定要 `make(XXMap)` 才能使用？

因为，`map` 结构的核心在于 `struct hmap` 结构体，这个结构体是很大的一个结构体。`map` 的操作核心都是基于这个结构体之上的。而 `var` 定义一个 `map` 结构的时候，只是分配了一个 8 字节的指针，**只有调用 `make` 的时候，才触发调用 `makemap` ，在这个函数里面分配出一个庞大的 `struct hmap` 结构体。**

#### `nil` 赋值

如果把一个 `map` 变量赋值 `nil` 那就很容易理解了，仅仅是把这个变量本身置 0 而已，也就是这个指针变量置 0 ，`hmap` 结构体本身是不会动的。

当然考虑垃圾回收的话，如果这个 `m1` 是唯一的指向这个 `hmap` 结构，那么 `m1` 赋值 `nil` 之后，那么这个 `hmap` 结构体之后就可能被回收。

#### `nil` 值判断

搞懂了变量本身和管理结构的区别就很简单了，这里的 `nil` 值判断也仅仅是针对变量本身的判断，**只要是非 0 指针，那么就是非 `nil`** 。也就是说 `m1` 只要是一个非 0 的指针，就不会是非 `nil` 的。

```go
package main

func main() {
	var m1 map[string]int
	var m2 = make(map[string]int)
	if m1 != nil {
		println("m1 not nil")
	} else {
		println("m1 nil") // bingo
	}
    
	if m2 != nil {
		println("m2 not nil") // bingo
	} else {
		println("m2 nil")
	}
}
```

如上示例程序，m1 是一个 0 指针，m2 被赋值了的。

### interface

#### 变量定义

```go
// 定义一个接口
type Reader interface {
	Read(p []byte) (n int, err error)
}

// 定义一个接口变量
var reader Reader
// 或者一个空接口
var empty interface{}
```

#### 变量本身

interface 稍微有点特殊，有两种对应的结构体，如下：

```go
type iface struct {
    tab  *itab
    data unsafe.Pointer
}

type eface struct {
    _type *_type
    data  unsafe.Pointer
}
```

其中，`iface` 就是通常定义的 interface 类型，`eface` 则是通常人们常说的 `空接口` 对应的数据结构。

不管内部怎么样，这两个结构体占用内存是一样的，都是**一个正常的指针类型和一个无类型的指针类型**（ `Pointer` ），总共占用 16 个字节。

也就是说，如果你声明定义一个 `interface` 类型，无论是空接口，还是具体的接口类型，都只是分配了一个 16 字节的内存块给你，注意是置 0 分配哦。

#### `nil` 赋值

和上面类似，如果对一个 `interface` 变量赋值 `nil` 的话，发生的事情也仅仅是把变量本身这 16 个字节的内存块置 0 而已。

#### `nil` 值判断

判断 `interface` 是否是 `nil` ？这个跟 `slice` 类似，也仅仅是判断首字段（指针类型）是否为 0 即可。因为如果是初始化过的，首字段一定是非 0 的。

:star: 关于 interface 判断 nil 的坑：https://www.cnblogs.com/cnxkey/articles/10096934.html

### channel

#### 变量定义

```go
// 变量本身定义
var c1 chan struct{}
// 变量定义和初始化
var c2 = make(chan struct{})
```

区别：

- 第一种方式仅仅定义了 c1 变量本身；
- 第二种方式则是分配 c2 的内存，还会调用 `makechan` 函数来创建某个结构，并且把这个函数的返回值赋给 c2；

#### 变量本身

定义的 `channel` 变量本身是什么一个表现？

答案是：一个 8 字节的指针而已，意图指向一个 `channel` 管理结构，也就是 `struct hchan` 的指针。

程序员定义的 `channel` 变量本身内存仅仅是一个指针，`channel` 所有的逻辑都在 `hchan` 这个管理结构体上，所以，`channel` 也是必须 `make(chan Xtype)` 之后才能使用，就是这个道理。

#### `nil` 赋值

赋值 nil 之后，仅仅是把这 8 字节的指针置 0 。

#### `nil` 值判断

简单，仅仅是判断这 channel 指针是否非 0 而已。

### 指针

指针和函数类型比较好理解，因为之前的 4 种类型 `slice`，`map`，`channel`，`interface` 是复合结构。

指针本身来说也只是一个 8 字节的整型，函数变量类型则本身就是个指针。

#### 变量定义

```go
var ptr *int
```

#### 变量本身

变量本身就是一个 8 字节的内存块，这个没啥好讲的，因为指针都不是复合类型。

#### `nil` 赋值

```go
ptr = nil
```

这 8 字节的指针置 0。

#### `nil` 值判断

判断这 8 字节的指针是否为 0 。

### 函数

#### 变量定义

```go
var f func(int) error
```

#### 变量本身

变量本身是一个 8 字节的指针。

#### `nil` 赋值

本身就是指针，只不过指向的是函数而已。所以赋值也仅仅是这 8 字节置 0 。

#### `nil` 值判断

判断这 8 字节是否为 0 。

## 总结

下面总结一些上述分享：

1. 请撇开死记硬背的语法和玄学，变量仅仅是绑定到一个指定内存块的名字；
2. Go 从语言层面对程序员做了承诺，变量定义分配的内存一定是置 0 分配的；
3. 并不是所有的类型能够赋值 `nil`，并且和 `nil` 进行对比判断。只有 `slice`、`map`、`channel`、`interface`、指针、函数 这 6 种类型；
4. 不要把 `nil` 理解成一个特殊的值，而要理解成一个触发条件，编译器识别到代码里有 `nil` 之后，会对应做出处理和判断；
5. `channel`，`map` 类型的变量必须要 `make `才能使用的原因（否则会出现空指针的 panic ）在于 var 定义的变量仅仅是分配了一个指向 `hchan` 和 `hmap` 的指针变量而已，并且还是置 0 分配的。真正的管理结构只有 make 调用才能分配出来，对应的函数分别是 `makechan` 和 `makemap` 等；
6. `slice` 变量为什么 `var` 就能用是因为 `struct slice` 核心结构是定义的时候就分配出来了；
7. 以上 6 种变量赋值 `nil` 的行为都是把变量本身置 0 ，仅此而已。`slice` 的 24 字节管理结构，`map` 的 8 字节指针，`channel` 的 8 字节指针，`interface` 的 16 字节，8 字节指针和函数指针也是如此；
8. 以上 6 种类型和 `nil` 进行比较判断本质上都是和变量本身做判断，`slice` 是判断管理结构的第一个指针字段，`map`，`channel` 本身就是指针，`interface` 也是判断管理结构的第一个指针字段，指针和函数变量本身就是指针；

## 后记

推荐使用 gdb 进行对上面的 demo 程序进行调试，加深自己理解。重点关注内存分配和内部代码的生成（反汇编），比如类似 makechan 这样的函数，如果你不调试，你根本不会知道竟然还有这个，我明明没有写过这函数呀？这个是编译器帮你生成的。