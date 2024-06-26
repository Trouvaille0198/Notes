---
title: "Go 类型系统"
date: 2022-03-07
draft: false
author: "MelonCholi"
tags: []
categories: [Golang]
---

# Go 类型系统

> 太难了根本看不懂 T T

## 概述

本文将介绍 Go 中的各个类型种类。Go 类型系统中的各种概念也将被介绍。

### 概念：基本类型（basic type）

- 内置字符串类型：`string`.
- 内置布尔类型：`bool`.
- 内置数值类型：
    - `int8`、`uint8`（`byte`）、`int16`、`uint16`、`int32`（`rune`）、`uint32`、`int64`、`uint64`、`int`、`uint`、`uintptr`。
    - `float32`、`float64`。
    - `complex64`、`complex128`。

> 注意，`byte` 是 `uint8` 的一个内置别名，`rune` 是 `int32` 的一个内置别名。 

### 概念：组合类型（composite type）

Go 支持下列组合类型：

- 指针类型 - 类 C 指针
- 结构体类型 - 类 C 结构体
- 函数类型 - 函数类型在 Go 中是一种**一等公民**类别
- 容器类型，包括:
    - 数组类型 - 定长容器类型
    - 切片类型 - 动态长度和容量容器类型
    - 映射类型（map）- 也常称为字典类型。在标准编译器中映射是使用哈希表实现的。
- 通道类型 - 通道用来同步并发的协程
- 接口类型 - 接口在反射和多态中发挥着重要角色

非定义组合类型可以用它们各自的字面表示形式来表示。 下面是一些各种不同种类的非定义组合类型字面表示形式的例子（非定义类型将在下面解释）：

```go
// 假设T为任意一个类型，Tkey为一个支持比较的类型。

*T         // 一个指针类型
[5]T       // 一个元素类型为T、元素个数为5的数组类型
[]T        // 一个元素类型为T的切片类型
map[Tkey]T // 一个键值类型为Tkey、元素类型为T的映射类型

// 一个结构体类型
struct {
	name string
	age  int
}

// 一个函数类型
func(int) (bool, string)

// 一个接口类型
interface {
	Method0(string) int
	Method1() (int, bool)
}

// 几个通道类型
chan T
chan<- T
<-chan T
```

### 事实：类型的种类

每种上面提到的基本类型和组合类型都对应着一个类型种类（kind）。除了这些种类，今后将要介绍的非类型安全指针类型属于另外一个新的类型种类。

所以，目前（Go 1.17），Go 有 26 个类型种类。

### :heavy_check_mark: 语法：类型定义

> type definition declaration

在 Go 中，我们可以用如下形式来定义新的类型。在此语法中，`type`为一个关键字。

```go
// 定义单个类型。
type NewTypeName SourceType

// 定义多个类型。
type (
	NewTypeName1 SourceType1
	NewTypeName2 SourceType2
)
```

新的类型名必须为标识符。但是请注意：包级类型（以及类型别名）的名称不能为 [`init`](https://gfw.go101.org/article/packages-and-imports.html#init)。

上例中的第二个类型声明中包含两个类型描述（type specification）。 如果一个类型声明包含多于一个的类型描述，这些类型描述必须用一对小括号 `()` 括起来。

注意：

- 一个新定义的类型和它的源类型为两个**不同**的类型。
- 在两个不同的类型定义中定义的两个类型肯定为两个不同的类型。
- 一个新定义的类型和它的源类型的底层类型一致并且它们的值可以相互**显式转换**。
- 类型定义可以出现在函数体内。

一些类型定义的例子：

```go
// 下面这些新定义的类型和它们的源类型都是基本类型。
type (
	MyInt int
	Age   int
	Text  string
)

// 下面这些新定义的类型和它们的源类型都是组合类型。
type IntPtr *int
type Book struct{author, title string; pages int}
type Convert func(in0 int, in1 bool)(out0 int, out1 string)
type StringArray [5]string
type StringSlice []string

func f() {
	// 这三个新定义的类型名称只能在此函数内使用。
	type PersonAge map[string]int
	type MessageQueue chan string
	type Reader interface{Read([]byte) int}
}
```

### :heavy_check_mark: 语法：类型别名声明

> type alias declaration

从 Go 1.9 开始，我们可以使用下面的语法来声明自定义类型别名。此语法和类型定义类似，但是请注意每个类型描述中多了一个等号 `=`。

```go
type (
	Name = string
	Age  = int
)

type table = map[string]int
type Table = map[Name]Age
```

类型别名也必须为标识符。同样地，类型别名可以被声明在函数体内。

在上面的类型别名声明的例子中，`Name` 是内置类型 `string` 的一个别名，它们表示同一个类型。 

事实上，文字表示形式 `map[string]int` 和 `map[Name]Age` 也表示同一类型。 所以，`table` 和 `Table` 一样表示同一个类型。

> 注意，尽管两个别名 `table` 和 `Table` 表示同一个类型，但 `Table` 是导出的，所以它可以被其它包引入使用，而`table` 却不可以。

类型别名声明在重构一些大的 Go 项目等场合很有用。 在通常编程中，类型定义声明使用得更广泛。

### 概念：定义类型和非定义类型

> defined type and undefined type

一个定义类型是一个在某个类型定义声明中定义的类型。

所有的基本类型都是定义类型。一个非定义类型一定是一个组合类型。

在下面的例子中，别名 `C` 和类型字面表示 `[]string` 都表示同一个非定义类型。 类型 `A` 和别名 `B` 均表示同一个定义类型。

```go
type A []string
type B = A
type C = []string
```

### 概念：有名类型和无名类型

> named type and unnamed type

在 Go 1.9 之前，**有名类型**这一术语准确地定义在 Go 白皮本中。它曾被定义为一个有名字的类型。 随着 Go 1.9 中引入的类型别名新特性，此术语被从白皮书中删除了，原因是它可能会造成一些理解上的困惑。 比如，一些类型字面表示（比如上一节出现中的别名 `C`）是一个标识符（即一个名称），但是它们所表示的类型（比如 `[]string`）在 Go 1.9 之前却被称为无名类型。

为了避免出现这样的困惑，从 Go 1.9 开始，一个新的术语**定义类型**被引入来填补移除**有名类型**后的空白。 然而此举也给一些概念解释造成了[新的](https://github.com/golang/go/issues/22005)[障碍](https://github.com/golang/go/issues/32496)，或者形成了一些[尴尬的局面](https://github.com/golang/example/tree/master/gotypes#named-types)。 为了避免这些尴尬的此文将遵守如下原则：

- 一个类型别名将不会被称为一个类型，尽管我们常说它表示着一个类型。
- 术语**有名类型**和**定义类型**将被视为完全相同的概念。（同样地，**无名类型**和**非定义类型**亦为同一概念。） 换句话说，当提到 “一个类型别名 `T` 是一个有名类型”，其实际意义是类型别名 `T` 表示着一个有名类型。 如果 `T` 表示着一个无名类型，则我们不应该说 `T` 是一个有名类型，即使别名 `T` 它本身拥有一个名字。
- 当我们提及一个类型名（称），它可能是一个定义类型的名称，也可能是一个类型别名的名称。

### :heavy_check_mark: 概念：底层类型

> underlying type

在 Go 中，**每个类型都有一个底层类型**。规则：

- 一个内置类型的底层类型为它自己。
- `unsafe` 标准库包中定义的 `Pointer` 类型的底层类型是它自己。
    - 至少我们可以认为是这样。事实上，关于`unsafe.Pointer` 类型的底层类型，官方文档中并没有清晰的说明。我们也可以认为 `unsafe.Pointer` 类型的底层类型为 `*T`，其中 `T` 表示一个任意类型。
- 一个非定义类型（必为一个组合类型）的底层类型为它自己。
- 在一个类型声明中，新声明的类型和源类型共享底层类型。

一个例子：

```go
// 这四个类型的底层类型均为内置类型int。
type (
	MyInt int
	Age   MyInt
)

// 下面这三个新声明的类型的底层类型各不相同。
type (
	IntSlice   []int   // 底层类型为[]int
	MyIntSlice []MyInt // 底层类型为[]MyInt
	AgeSlice   []Age   // 底层类型为[]Age
)

// 类型[]Age、Ages和AgeSlice的底层类型均为[]Age。
type Ages AgeSlice
```

如何溯源一个声明的类型的底层类型？规则很简单，**在溯源过程中，当遇到一个内置类型或者非定义类型时，溯源结束。** 以上面这几个声明的类型为例，下面是它们的底层类型的溯源过程：

```
MyInt → int
Age → MyInt → int
IntSlice → []int
MyIntSlice → []MyInt → []int
AgeSlice → []Age → []MyInt → []int
Ages → AgeSlice → []Age → []MyInt → []int
```

在 Go 中，

- 底层类型为内置类型 `bool` 的类型称为**布尔类型**；
- 底层类型为任一内置整数类型的类型称为**整数类型**；
- 底层类型为内置类型 `float32` 或者 `float64` 的类型称为**浮点数类型**；
- 底层类型为内置类型 `complex64` 或 `complex128` 的类型称为**复数类型**；
- 整数类型、浮点数类型和复数类型统称为**数字值类型**；
- 底层类型为内置类型 `string` 的类型称为**字符串类型**。

### 事实：可比较类型和不可比较类型

目前（Go 1.17），下面这些类型的值不支持（使用 `==` 和 `!=` 运算标识符）比较。这些类型称为不可比较类型。

- 切片类型
- 映射类型
- 函数类型
- 任何包含有不可比较类型的字段的结构体类型
- 任何元素类型为不可比较类型的数组类型。

其它类型称为可比较类型。

**映射类型的键值类型必须为可比较类型。**

## 基本类型的字面量表示

> 这一节不是很重要。。

一个值的字面形式称为一个字面量，它表示此值在代码中文字体现形式（和内存中的表现形式相对应）。一个值可能会有很多种字面量形式。

### 布尔值的字面量形式

Go 白皮书没有定义布尔类型值字面量形式。 我们可以将 `false` 和 `true` 这两个预声明的有名常量当作布尔类型的字面量形式。 但是，我们应该知道，从严格意义上说，它们不属于字面量。有名常量声明将在下一篇文章中介绍和详细解释。

布尔类型的零值可以使用预声明的 `false` 来表示。

### 整数类型值的字面量形式

整数类型值有四种字面量形式：十进制形式（decimal）、八进制形式（octal）、十六进制形式（hex）和二进制形式（binary）。 比如，下面的三个字面量均表示十进制的 15：

```go
0xF // 十六进制表示（必须使用0x或者0X开头）
0XF

017 // 八进制表示（必须使用0、0o或者0O开头）
0o17
0O17

0b1111 // 二进制表示（必须使用0b或者0B开头）
0B1111

15  // 十进制表示（必须不能用0开头）
```

（注意：二进制形式和以 `0o` 或 `0O` 开头的八进制形式从 Go 1.13 开始才支持。）

下面的程序打印出两个 `true`。

```go
package main

func main() {
	println(15 == 017) // true
	println(15 == 0xF) // true
}
```

整数类型的零值的字面量一般使用 `0` 表示。 当然，`00` 和 `0x0` 等也是合法的整数类型零值的字面量形式。

### 浮点数类型值的字面量形式

一个浮点数的完整十进制字面量形式可能包含一个十进制整数部分、一个小数点、一个十进制小数部分和一个以 10 为 底数的整数指数部分。

整数指数部分由字母 `e` 或者 `E` 带一个十进制的整数字面量组成（`xEn` 表示 `x` 乘以 `10n` 的意思，而 `xE-n` 表示 `x` 除以 `10n` 的意思）。 常常地，某些部分可以根据情况省略掉。一些例子：

```go
1.23
01.23 // == 1.23
.23
1.
// 一个e或者E随后的数值是指数值（底数为10）。
// 指数值必须为一个可以带符号的十进制整数字面量。
1.23e2  // == 123.0
123E2   // == 12300.0
123.E+2 // == 12300.0
1e-1    // == 0.1
.1e0    // == 0.1
0010e-2 // == 0.1
0e+5    // == 0.0
```

从 Go 1.13 开始，Go 也支持另一种浮点数字面量形式：十六进制浮点数字面量。 在一个十六进制浮点数字面量中

- 一个十六进制浮点数字面量必须以一个以 2 为底数的整数指数部分。 这样的一个整数指数部分由字母 `p` 或者 `P` 带一个十进制的整数字面量组成（`yPn` 表示 `y` 乘以 `2n` 的意思，而 `yP-n` 表示 `y` 除以 `2n` 的意思）。
- 和整数的十六进制字面量一样，一个十六进制浮点数字面量也必须使用 `0x` 或者 `0X` 开头。 和整数的十六进制字面量不同的是，一个十六进制浮点数字面量可以包括一个小数点和一个十六进制小数部分。

一些合法的浮点数的十六进制字面量例子：

```go
0x1p-2     // == 1.0/4 = 0.25
0x2.p10    // == 2.0 * 1024 == 2048.0
0x1.Fp+0   // == 1+15.0/16 == 1.9375
0X.8p1     // == 8.0/16 * 2 == 1.0
0X1FFFP-16 // == 0.1249847412109375
```

而下面这几个均是不合法的浮点数的十六进制字面量。

```go
0x.p1    // 整数部分表示必须包含至少一个数字
1p-2     // p指数形式只能出现在浮点数的十六进制字面量中
0x1.5e-2 // e和E不能出现在十六进制浮点数字面量的指数部分中
```

注意：下面这个表示是合法的，但是它不是浮点数的十六进制字面量。事实上，它是一个减法算术表达式。其中的 `e` 为是十进制中的 `14`，`0x15e` 为一个整数十六进制字面量，`-2` 并不是此整数十六进制字面量的一部分。

```go
0x15e-2 // == 0x15e - 2 (整数相减表达式)
```

浮点类型的零值的标准字面量形式为 `0.0`。 当然其它很多形式也是合法的，比如 `0.`、`.0`、`0e0` 和 `0x0p0` 等。

### 虚部字面量形式

一个虚部值的字面量形式由一个浮点数字面量或者一个整数字面量和其后跟随的一个小写的字母 `i` 组成。 在 Go1.13 之前，如果虚部中 `i` 前的部分为一个整数字面量，则其必须为并且总是被视为十进制形式。 一些例子：

```go
1.23i
1.i
.23i
123i
0123i   // == 123i（兼容性使然。见下）
1.23E2i // == 123i
1e-1i
011i   // == 11i（兼容性使然。见下）
00011i // == 11i（兼容性使然。见下）
// 下面这几行从Go 1.13开始才能编译通过。
0o11i    // == 9i
0x11i    // == 17i
0b11i    // == 3i
0X.8p-0i // == 0.5i
```

注意：在 Go 1.13 之前，虚部字面量中字母 `i` 前的部分只能为浮点数字面量。 为了兼容老的 Go 版本，从 Go 1.13 开始，一些虚部字面量中表现为（不以 `0o` 和 `0O` 开头的）八进制形式的整数字面量仍被视为浮点数字面量。 比如上例中的 `011i`、`0123i` 和 `00011i`。

虚部字面量用来表示复数的虚部。下面是一些复数值的字面量形式：

```go
1 + 2i       // == 1.0 + 2.0i
1. - .1i     // == 1.0 + -0.1i
1.23i - 7.89 // == -7.89 + 1.23i
1.23i        // == 0.0 + 1.23i
```

复数零值的标准字面表示为 `0.0+0.0i`。 当然 `0i`、`.0i`、`0+0i` 等表示也是合法的。

### 数值字面表示中使用下划线分段来增强可读性

从 Go 1.13 开始，**下划线 `_` 可以出现在整数、浮点数和虚部数字面量中，以用做分段符以增强可读性。** 

但是要注意，在一个数值字面表示中，一个下划线 `_` 不能出现在此字面表示的首尾，并且其两侧的字符必须为（相应进制的）数字字符或者进制表示头。

一些合法和不合法使用下划线的例子：

```go
// 合法的使用下划线的例子
6_9          // == 69
0_33_77_22   // == 0337722
0x_Bad_Face  // == 0xBadFace
0X_1F_FFP-16 // == 0X1FFFP-16
0b1011_0111 + 0xA_B.Fp2i

// 非法的使用下划线的例子
_69        // 下划线不能出现在首尾
69_        // 下划线不能出现在首尾
6__9       // 下划线不能相连
0_xBadFace // x不是一个合法的八进制数字
1_.5       // .不是一个合法的十进制数字
1._5       // .不是一个合法的十进制数字
```

### rune 值的字面量形式

上面已经提到，`rune` 类型是 `int32` 类型的别名。 因此，rune 类型（泛指）是特殊的整数类型。 一个 rune 值可以用上面已经介绍的整数类型的字面量形式表示。 另一方面，很多各种整数类型的值也可以用本小节介绍的 rune 字面量形式来表示。

在 Go 中，一个 rune 值表示一个 Unicode 码点。 一般说来，我们可以将一个 Unicode 码点看作是一个 Unicode 字符。 但是，我们也应该知道，有些 Unicode 字符由多个 Unicode 码点组成。 每个英文或中文 Unicode 字符值含有一个 Unicode 码点。

一个 rune 字面量由若干包在一对单引号中的字符组成。 包在单引号中的字符序列表示一个 Unicode 码点值。 rune 字面量形式有几个变种，其中最常用的一种变种是将一个 rune 值对应的 Unicode 字符直接包在一对单引号中。比如：

```go
'a' // 一个英文字符
'π'
'众' // 一个中文字符
```

下面这些 rune 字面量形式的变种和 `'a'` 是等价的 （字符 `a` 的 Unicode 值是 97）。

```go
'\141'   // 141是97的八进制表示
'\x61'   // 61是97的十六进制表示
'\u0061'
'\U00000061'
```

注意：`\` 之后必须跟随三个八进制数字字符（0-7）表示一个 byte 值， `\x` 之后必须跟随两个十六进制数字字符（0-9，a-f 和 A-F）表示一个 byte 值， `\u` 之后必须跟随四个十六进制数字字符表示一个 rune 值（此 run 值的高四位都为 0）， `\U` 之后必须跟随八个十六进制数字字符表示一个 rune 值。 这些八进制和十六进制的数字字符序列表示的整数必须是一个合法的 Unicode 码点值，否则编译将失败。

下面这些 `println` 函数调用都将打印出 `true`。

```go
package main

func main() {
	println('a' == 97)
	println('a' == '\141')
	println('a' == '\x61')
	println('a' == '\u0061')
	println('a' == '\U00000061')
	println(0x61 == '\x61')
	println('\u4f17' == '众')
}
```

事实上，在日常编程中，这四种 rune 字面量形式的变种很少用来表示 rune 值。 它们多用做字符串的双引号字面量形式中的转义字符（详见下一小节）。

如果一个 rune 字面量中被单引号包起来的部分含有两个字符， 并且第一个字符是 `\`，第二个字符不是 `x`、 `u` 和 `U`，那么这两个字符将被转义为一个特殊字符。 目前支持的转义组合为：

```
\a   (rune值：0x07) 铃声字符
\b   (rune值：0x08) 退格字符（backspace）
\f   (rune值：0x0C) 换页符（form feed）
\n   (rune值：0x0A) 换行符（line feed or newline）
\r   (rune值：0x0D) 回车符（carriage return）
\t   (rune值：0x09) 水平制表符（horizontal tab）
\v   (rune值：0x0b) 竖直制表符（vertical tab）
\\   (rune值：0x5c) 一个反斜杠（backslash）
\'   (rune值：0x27) 一个单引号（single quote）
```

其中，`\n` 在日常编程中用得最多。

一个例子：

```go
println('\n') // 10
println('\r') // 13
println('\'') // 39

println('\n' == 10)     // true
println('\n' == '\x0A') // true
```

rune 类型的零值常用 `'\000'`、`'\x00'` 或 `'\u0000'` 等来表示。

### 字符串值的字面量形式

在 Go 中，字符串值是 UTF-8 编码的， 甚至所有的 Go 源代码都必须是 UTF-8 编码的。

Go 字符串的字面量形式有两种。 一种是解释型字面表示（interpreted string literal，双引号风格）。 另一种是直白字面表示（raw string literal，反引号风格）。 下面的两个字符串表示形式是等价的：

```go
// 解释形式
"Hello\nworld!\n\"你好世界\""

// 直白形式
`Hello
world!
"你好世界"`
```

在上面的解释形式（双引号风格）的字符串字面量中，每个 `\n` 将被转义为一个换行符，每个 `\"` 将被转义为一个双引号字符。 双引号风格的字符串字面量中支持的转义字符和 rune 字面量基本一致，除了一个例外：双引号风格的字符串字面量中支持 `\"` 转义，但不支持 `\'` 转义；而 rune 字面量则刚好相反。

以 `\`、`\x`、`\u` 和 `\U` 开头的 rune 字面量（不包括两个单引号）也可以出现在双引号风格的字符串字面量中。比如：

```go
// 这几个字符串字面量是等价的。
"\141\142\143"
"\x61\x62\x63"
"\x61b\x63"
"abc"

// 这几个字符串字面量是等价的。
"\u4f17\xe4\xba\xba"
      // “众”的Unicode值为4f17，它的UTF-8
      // 编码为三个字节：0xe4 0xbc 0x97。
"\xe4\xbc\x97\u4eba"
      // “人”的Unicode值为4eba，它的UTF-8
      // 编码为三个字节：0xe4 0xba 0xba。
"\xe4\xbc\x97\xe4\xba\xba"
"众人"
```

在 UTF-8 编码中，一个 Unicode 码点（rune）可能由 1 到 4 个字节组成。 每个英文字母的 UTF-8 编码只需要一个字节；每个中文字符的 UTF-8 编码需要三个字节。

直白反引号风格的字面表示中是不支持转义字符的。 除了首尾两个反引号，直白反引号风格的字面表示中不能包含反引号。 为了跨平台兼容性，直白反引号风格的字面表示中的回车符（Unicode 码点为 `0x0D`） 将被忽略掉。

字符串类型的零值在代码里用 `""` 或 `` 表示。

### 基本数值类型字面量的适用范围

一个数值型的字面量只有在不需要舍入时，才能用来表示一个整数基本类型的值。 比如，`1.0` 可以表示任何基本整数类型的值，但 `1.01` 却不可以。 当一个数值型的字面量用来表示一个非整数基本类型的值时，舍入（或者精度丢失）是允许的。

每种数值类型有一个能够表示的数值范围。 如果一个字面量超出了一个类型能够表示的数值范围（溢出），则在编译时刻，此字面量不能用来表示此类型的值。

下表是一些例子：

|             字面表示             |         此字面表示可以表示哪些类型的值（在编译时刻）         |
| :------------------------------: | :----------------------------------------------------------: |
|              `256`               |       除了 int8 和 uint8 类型外的所有的基本数值类型。        |
|              `255`               |            除了 int8 类型外的所有的基本数值类型。            |
|              `-123`              |          除了无符号整数类型外的所有的基本数值类型。          |
|              `123`               |                     所有的基本数值类型。                     |
|            `123.000`             |                                                              |
|             `1.23e2`             |                                                              |
|              `'a'`               |                                                              |
|             `1.0+0i`             |                                                              |
|              `1.23`              |                所有浮点数和复数基本数值类型。                |
| `0x10000000000000000` (16 zeros) |                                                              |
|             `3.5e38`             | 除了 float32 和 complex64 类型外的所有浮点数和复数基本数值类型。 |
|              `1+2i`              |                    所有复数基本数值类型。                    |
|             `2e+308`             |                             无。                             |

注意几个溢出的例子：

- 字面量 `0x10000000000000000` 需要 65 个比特才能表示，所以在运行时刻，任何基本整数类型都不能精确表示此字面量。
- 在 IEEE-754 标准中，最大的可以精确表示的 float32 类型数值为 `3.40282346638528859811704183484516925440e+38`，所以 `3.5e38` 不能表示任何 float32 和 complex64 类型的值。
- 在 IEEE-754 标准中，最大的可以精确表示的 float64 类型数值为 `1.797693134862315708145274237317043567981e+308`，因此 `2e+308` 不能表示任何基本数值类型的值。
- 尽管 `0x10000000000000000` 可以用来表示 float32 类型的值，但是它不能被任何 float32 类型的值所精确表示。上面已经提到了，当使用字面量来表示非整数基本数值类型的时候，精度丢失是允许的（但溢出是不允许的）。

## 字符串

和很多其它编程语言一样，字符串类型是 Go 中的一种重要类型。本文将列举出关于字符串的各种事实。

### 字符串类型的内部结构定义

对于标准编译器，字符串类型的内部结构声明如下：

```go
type _string struct {
	elements *byte // 引用着底层的字节
	len      int   // 字符串中的字节数
}
```

从这个声明来看，我们可以将一个字符串的内部定义看作为一个字节序列。 事实上，我们确实可以把一个字符串看作是一个元素类型为 `byte` 的（且元素不可修改的）切片。

注意，前面的文章已经提到过多次，`byte` 是内置类型 `uint8` 的一个别名。

### 关于字符串的一些简单事实

从前面的若干文章，我们已经了解到下列关于字符串的一些事实：

- 字符串值（和布尔以及各种数值类型的值）可以被用做常量。
- Go 支持两种风格的字符串字面量表示形式：双引号风格（解释型字面表示）和反引号风格（直白字面表示）。
- 字符串类型的零值为空字符串。一个空字符串在字面上可以用 `""` 或者 \`\` 来表示。
- 我们可以用运算符 `+` 和 `+=` 来衔接字符串。
- 字符串类型都是可比较类型。
    - 同一个字符串类型的值可以用 `==` 和 `!=` 比较运算符来比较，也可以用 `>`、`<`、`>=` 和 `<=` 比较运算符来比较。 
    - 当比较两个字符串值的时候，**它们的底层字节将逐一进行比较**。
    - **如果一个字符串是另一个字符串的前缀，并且另一个字符串较长，则另一个字符串为两者中的较大者。**


一个例子：

```go
package main

import "fmt"

func main() {
	const World = "world"
	var hello = "hello"

	// 衔接字符串。
	var helloWorld = hello + " " + World
	helloWorld += "!"
	fmt.Println(helloWorld) // hello world!

	// 比较字符串。
	fmt.Println(hello == "hello")   // true
	fmt.Println(hello > helloWorld) // false
}
```

更多关于字符串类型和值的事实：

- 字符串值的内容（即底层字节）是不可更改的。 字符串值的长度也是不可独立被更改的。 一个可寻址的字符串只能通过将另一个字符串赋值给它来整体修改它。
- 表达式 `aString[i]` 是不可寻址的。换句话说，`aString[i]` 不可被修改。
- 对于标准编译器来说，一个字符串的赋值完成之后，此赋值中的目标值和源值将共享底层字节。 一个子切片表达式 `aString[start:end]` 的估值结果也将和基础字符串 `aString` 共享一部分底层字节。

一个例子：

```go
package main

import (
	"fmt"
	"strings"
)

func main() {
	var helloWorld = "hello world!"

	var hello = helloWorld[:5] // 取子字符串
	// 104是英文字符h的ASCII（和Unicode）码。
	fmt.Println(hello[0])         // 104
	fmt.Printf("%T \n", hello[0]) // uint8

	// hello[0]是不可寻址和不可修改的，所以下面
	// 两行编译不通过。
	/*
	hello[0] = 'H'         // error
	fmt.Println(&hello[0]) // error
	*/

	// 下一条语句将打印出：5 12 true
	fmt.Println(len(hello), len(helloWorld),
			strings.HasPrefix(helloWorld, hello))
}
```

### 字符串编码和 Unicode 码点

Unicode 标准为全球各种人类语言中的每个字符制定了一个独一无二的值。 但 Unicode 标准中的基本单位不是字符，而是**码点**（code point）。大多数的码点实际上就对应着一个字符。 但也有少数一些字符是由多个码点组成的。

码点值在 Go 中用 rune 值来表示。 

在 UTF-8 编码中，一个码点值可能由 1 到 4 个字节组成。 比如，每个英语码点值（均对应一个英语字符）均由一个字节组成，而每个中文字符（均对应一个中文字符）均由三个字节组成。

### 字符串相关的类型转换

我们已经了解到整数可以被显式转换为字符串类型（但是反之不行）。

这里介绍两种新的字符串相关的类型转换规则：

1. 一个字符串值可以被显式转换为一个字节切片（byte slice），反之亦然。 
2. 一个字符串值可以被显式转换为一个码点切片（rune slice），反之亦然。 

#### 码点切片到字符串的转换

- 码点切片中的每个码点值将被 UTF-8 编码为一到四个字节至结果字符串中。 
- 如果一个码点值是一个不合法的 Unicode 码点值
    - 则它将被视为 Unicode 替换字符（码点）值 `0xFFFD`（Unicode replacement character）。 
    - 替换字符值 `0xFFFD` 将被 UTF-8 编码为三个字节 `0xef 0xbf 0xbd`。

#### 字符串到码点切片的转换

- 此字符串中存储的字节序列将被解读为一个一个码点的 UTF-8 编码序列。 
- 非法的 UTF-8 编码字节序列将被转化为 Unicode 替换字符值 `0xFFFD`。

#### 字符串到字节切片的转换

- 结果切片中的底层字节序列是此字符串中存储的字节序列的一份**深复制**。 即 Go 运行时将为结果切片开辟一块足够大的内存来容纳被复制过来的所有字节。
- 当此字符串的长度较长时，此转换开销是比较大的。 

#### 字节切片到字符串的转换

同样

- 此字节切片中的字节序列也将被深复制到结果字符串中。 
- 当此字节切片的长度较长时，此转换开销同样是比较大的。 

> 在这两种转换中，必须使用深复制的原因是字节切片中的字节元素是可修改的，但是字符串中的字节是不可修改的，所以一个字节切片和一个字符串是不能共享底层字节序列的。

请注意，在字符串和字节切片之间的转换中，

- 非法的 UTF-8 编码字节序列将被保持原样不变。
- 标准编译器做了一些优化，从而使得这些转换在某些情形下将不用深复制。 这样的情形将在下一节中介绍。

Go 并不支持字节切片和码点切片之间的直接转换。我们可以用下面列出的方法来实现这样的转换：

- 利用字符串做为中间过渡。这种方法相对方便但效率较低，因为需要做两次深复制。
- 使用 unicode/utf8 标准库包中的函数来实现这些转换。 这种方法效率较高，但使用起来不太方便。
- 使用 `bytes` 标准库包中的 `Runes` 函数来将一个字节切片转换为码点切片。 但此包中没有将码点切片转换为字节切片的函数。

一个展示了上述各种转换的例子：

```go
package main

import (
	"bytes"
	"unicode/utf8"
)

func Runes2Bytes(rs []rune) []byte {
	n := 0
	for _, r := range rs {
		n += utf8.RuneLen(r)
	}
	n, bs := 0, make([]byte, n)
	for _, r := range rs {
		n += utf8.EncodeRune(bs[n:], r)
	}
	return bs
}

func main() {
	s := "颜色感染是一个有趣的游戏。"
	bs := []byte(s) // string -> []byte
	s = string(bs)  // []byte -> string
	rs := []rune(s) // string -> []rune
	s = string(rs)  // []rune -> string
	rs = bytes.Runes(bs) // []byte -> []rune
	bs = Runes2Bytes(rs) // []rune -> []byte
}
```

### 字符串和字节切片之间的转换的编译器优化

上面已经提到了字符串和字节切片之间的转换将深复制它们的底层字节序列。 标准编译器做了一些优化，从而在某些情形下避免了深复制。 至少这些优化在当前（Go 官方工具链 1.17）是存在的。 这样的情形包括：

- 一个 `for-range` 循环中跟随 `range` 关键字的从字符串到字节切片的转换；
- 一个在映射元素**读取**索引语法中被用做键值的从字节切片到字符串的转换（注意：对修改写入索引语法无效）；
- 一个字符串比较表达式中被用做比较值的从字节切片到字符串的转换；
- 一个（至少有一个被衔接的字符串值为非空字符串常量的）字符串衔接表达式中的从字节切片到字符串的转换。

一个例子：

```go
package main

import "fmt"

func main() {
	var str = "world"
	// 这里，转换[]byte(str)将不需要一个深复制。
	for i, b := range []byte(str) {
		fmt.Println(i, ":", b)
	}

	key := []byte{'k', 'e', 'y'}
	m := map[string]string{}
	// 这个string(key)转换仍然需要深复制。
	m[string(key)] = "value"
	// 这里的转换string(key)将不需要一个深复制。
	// 即使key是一个包级变量，此优化仍然有效。
	fmt.Println(m[string(key)]) // value
}
```

注意：在最后一行中，如果在估值 `string(key)` 的时候有数据竞争的情况，则这行的输出有可能并不是 `value`。 但是，无论如何，此行都不会造成恐慌（即使有数据竞争的情况发生）。

另一个例子：

```go
package main

import "fmt"
import "testing"

var s string
var x = []byte{1023: 'x'}
var y = []byte{1023: 'y'}

func fc() {
	// 下面的四个转换都不需要深复制。
	if string(x) != string(y) {
		s = (" " + string(x) + string(y))[1:]
	}
}

func fd() {
	// 两个在比较表达式中的转换不需要深复制，
	// 但两个字符串衔接中的转换仍需要深复制。
	// 请注意此字符串衔接和fc中的衔接的差别。
	if string(x) != string(y) {
		s = string(x) + string(y)
	}
}

func main() {
	fmt.Println(testing.AllocsPerRun(1, fc)) // 1
	fmt.Println(testing.AllocsPerRun(1, fd)) // 3
}
```

### 使用 `for-range` 循环遍历字符串中的码点

`for-range` 循环控制中的 `range` 关键字后可以跟随一个字符串，用来**遍历此字符串中的码点**（而非字节元素）。 字符串中非法的 UTF-8 编码字节序列将被解读为 Unicode 替换码点值`0xFFFD`。

一个例子：

```go
package main

import "fmt"

func main() {
	s := "éक्षिaπ囧"
	for i, rn := range s {
		fmt.Printf("%2v: 0x%x %v \n", i, rn, string(rn))
	}
	fmt.Println(len(s))
}
```

此程序的输出如下：

```
 0: 0x65 e
 1: 0x301 ́
 3: 0x915 क
 6: 0x94d ्
 9: 0x937 ष
12: 0x93f ि
15: 0x61 a
16: 0x3c0 π
18: 0x56e7 囧
21
```

从此输出结果可以看出：

1. 下标循环变量的值并非连续。原因是下标循环变量为字符串中字节的下标，而一个码点可能需要多个字节进行 UTF-8 编码。
2. 第一个字符 `é` 由两个码点（共三字节）组成，其中一个码点需要两个字节进行 UTF-8 编码。
3. 第二个字符 `क्षि` 由四个码点（共 12 字节）组成，每个码点需要三个字节进行 UTF-8 编码。
4. 英语字符 `a` 由一个码点组成，此码点只需一个字节进行 UTF-8 编码。
5. 字符 `π` 由一个码点组成，此码点只需两个字节进行 UTF-8 编码。
6. 汉字 `囧` 由一个码点组成，此码点只需三个字节进行 UTF-8 编码。

那么如何遍历一个字符串中的字节呢？使用传统 `for` 循环：

```go
package main

import "fmt"

func main() {
	s := "éक्षिaπ囧"
	for i := 0; i < len(s); i++ {
		fmt.Printf("第%v个字节为0x%x\n", i, s[i])
	}
}
```

当然，我们也可以利用前面介绍的编译器优化来使用 `for-range` 循环遍历一个字符串中的字节元素。 对于官方标准编译器来说，此方法比刚展示的方法效率更高。

```go
package main

import "fmt"

func main() {
	s := "éक्षिaπ囧"
	// 这里，[]byte(s)不需要深复制底层字节。
	for i, b := range []byte(s) {
		fmt.Printf("The byte at index %v: 0x%x \n", i, b)
	}
}
```

从上面几个例子可以看出，`len(s)` 将返回字符串 `s` 中的字节数。

如何得到一个字符串中的码点数呢？

- 使用刚介绍的 `for-range` 循环来统计一个字符串中的码点数
- 使用 `unicode/utf8` 标准库包中的 RuneCountInString，与上一种方法效率一致
- 使用 `len([]rune(s))` 来获取字符串 `s` 中码点数。标准编译器从 1.11 版本开始，对此表达式做了优化以避免一个不必要的深复制，从而使得它的效率和前两种方法一致。 

注意，这三种方法的时间复杂度均为 `O(n)`。

### 更多字符串衔接方法

除了使用 `+` 运算符来衔接字符串，我们也可以用下面的方法来衔接字符串：

- `fmt` 标准库包中的 `Sprintf` / `Sprint`/`Sprintln` 函数可以用来衔接各种类型的值的字符串表示，当然也包括字符串类型的值。
- 使用 `strings` 标准库包中的 `Join` 函数。
- `bytes` 标准库包提供的 `Buffer` 类型可以用来构建一个字节切片，然后我们可以将此字节切片转换为一个字符串。
- 从 Go 1.10 开始，`strings` 标准库包中的 `Builder` 类型可以用来拼接字符串。 和 `bytes.Buffer` 类型类似，此类型内部也维护着一个字节切片，但是它在将此字节切片转换为字符串时避免了底层字节的深复制。

标准编译器对使用 `+` 运算符的字符串衔接做了特别的优化。 所以，一般说来，在被衔接的字符串的数量是已知的情况下，使用 `+` 运算符进行字符串衔接是比较高效的。

### 语法糖：将字符串当作字节切片使用

我们了解到内置函数 `copy` 和 `append` 可以用来复制和添加切片元素。 事实上，做为一个特例，如果这两个函数的调用中的第一个实参为一个字节切片的话，那么第二个实参可以是一个字符串。 （对于 `append` 函数调用，字符串实参后必须跟随三个点 `...`） 换句话说，在此特例中，字符串可以当作字节切片来使用。

一个例子：

```go
package main

import "fmt"

func main() {
	hello := []byte("Hello ")
	world := "world!"

	// helloWorld := append(hello, []byte(world)...) // 正常的语法
	helloWorld := append(hello, world...)            // 语法糖
	fmt.Println(string(helloWorld))

	helloWorld2 := make([]byte, len(hello) + len(world))
	copy(helloWorld2, hello)
	// copy(helloWorld2[len(hello):], []byte(world)) // 正常的语法
	copy(helloWorld2[len(hello):], world)            // 语法糖
	fmt.Println(string(helloWorld2))
}
```

### 更多关于字符串的比较

上面已经提到了比较两个字符串事实上逐个比较这两个字符串中的字节。 Go 编译器一般会做出如下的优化：

- 对于 `==` 和 `!=` 比较，如果这两个字符串的长度不相等，则这两个字符串肯定不相等（无需进行字节比较）。
- 如果这两个字符串底层引用着字符串切片的指针相等，则比较结果等同于比较这两个字符串的长度。

**所以两个相等的字符串的比较的时间复杂度取决于它们底层引用着字符串切片的指针是否相等。 如果相等，则对它们的比较的时间复杂度为 `O(1)`，否则时间复杂度为 `O(n)`。**

上面已经提到了，对于标准编译器，一个字符串赋值完成之后，目标字符串和源字符串将共享同一个底层字节序列。 所以比较这两个字符串的代价很小。

一个例子：

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	bs := make([]byte, 1<<26)
	s0 := string(bs)
	s1 := string(bs)
	s2 := s1

	// s0、s1和s2是三个相等的字符串。
	// s0的底层字节序列是bs的一个深复制。
	// s1的底层字节序列也是bs的一个深复制。
	// s0和s1底层字节序列为两个不同的字节序列。
	// s2和s1共享同一个底层字节序列。

	startTime := time.Now()
	_ = s0 == s1
	duration := time.Now().Sub(startTime)
	fmt.Println("duration for (s0 == s1):", duration)

	startTime = time.Now()
	_ = s1 == s2
	duration = time.Now().Sub(startTime)
	fmt.Println("duration for (s1 == s2):", duration)
}
```

输出如下：

```
duration for (s0 == s1): 10.462075ms
duration for (s1 == s2): 136ns
```

1ms 等于 1000000ns！所以请**尽量避免比较两个很长的不共享底层字节序列的相等的（或者几乎相等的）字符串。**

## 值部

### Go 类型分为两大类别（category）

Go 可以被看作是一门 C 语言血统的语言，Go 中的指针和结构体类型的内存结构和 C 语言很类似。

另一方面，Go 也可以被看作是 C 语言的一个扩展框架。 在 C 中，值的内存结构都是很透明的；但在 Go 中，对于某些类型的值，其内存结构却不是很透明。 在 C 中，每个值在内存中只占据一个内存块（一段连续内存）；但是，一些 Go 类型的值可能占据多个内存块。

以后，我们称一个 Go 值分布在不同内存块上的部分为此值的各个值部（value part）。 一个分布在多个内存块上的值含有一个**直接值部**和若干被此直接值部引用着的**间接值部**。

上面的段落描述了两个类别的 Go 类型。下表将列出这两个类别（category）中的类型（type）种类（kind）：

|           每个值在内存中只分布在一个内存块上的类型           |           每个值在内存中会分布在多个内存块上的类型           |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                          单直接值部                          |                   直接值部 -> 底层间接值部                   |
| 布尔类型、各种数值类型、指针类型、非类型安全指针类型、结构体类型、数组类型 | 切片类型、映射类型、通道类型、函数类型、接口类型、字符串类型 |

> 接口类型和字符串类型值是否包含间接部分取决于具体编译器实现。 如果不使用今后将介绍的非类型安全途径，我们无法从这两类类型的值的外在表现来判定它们的值是否含有间接部分。
>
> 同样地，函数类型的值是否包含间接部分几乎也是不可能验证的。 

通过封装了很多具体的实现细节，第二个类别中的类型给 Go 编程带来了很大的便利。 

本文余下的内容将对第二类类型的内在实现做一个简单介绍。 这些实现的细节将不会在本文中谈及。本文的介绍主要基于官方标准编译器的实现。

### Go 中的两种指针类型

在继续下面的内容之前，我们先了解一下 Go 中的两种指针类型并明确一下“引用”这个词的含义。

除了普通的类型安全的指针，Go 还支持另一种称为非类型安全的指针类型。 非类型安全的指针类型提供在 `unsafe` 标准库包中。 非类型安全指针类型通常使用 `unsafe.Pointer` 来表示。 `unsafe.Pointer` 类似于 C 语言中的 `void*`。

> 在本文的余下内容中，当一个指针被谈及，它可能表示一个类型安全指针，也可能表示一个非类型安全指针。

一个指针值存储着另一个值的地址，除非此指针值是一个 nil 空指针。 我们可以说此指针**引用**着另外一个值，或者说另外一个值正被此指针所引用。 

一个值可能被**间接引用**，比如

- 如果一个结构体值 `a` 含有一个指针字段 `b` 并且这个指针字段 `b` 引用着另外一个值 `c`，那么我们可以说结构体值 `a` 也引用着值 `c`。
- 如果一个值 `x`（直接或者间接地）引用着另一个值 `y`，并且值 `y`（直接或者间接地）引用着第三个值 `z`，则我们可以说值 `x` 间接地引用着值 `z`。

以后，我们将一个含有（直接或者间接）指针字段的结构体类型称为一个**指针包裹类型**，将一个含有（直接或者间接）指针的类型称为**指针持有者类型**。 

- 指针类型和指针包裹类型都属于指针持有者类型。

- 元素类型为指针持有者类型的数组类型也是指针持有者类型。

### 第二个分类中的类型的（可能的）内部实现结构定义

为了更好地理解第二个分类中的类型的值的运行时刻行为，我们可以认为这些类型在内部是使用第一个分类中的类型来定义的（如下所示）。 如果你以前并没有很多使用过 Go 中各种类型的经验，目前你不必深刻地理解这些定义。 对这些定义拥有一个粗糙的印象足够对理解后续文章中将要讲解的类型有所帮助。 你可以在今后有了更多的 Go 编程经验之后再重读一下本文。

#### 映射、通道和函数类型的内部定义

映射、通道和函数类型的内部定义很相似：

```go
// 映射类型
type _map *hashtableImpl // 目前，官方标准编译器是使用
                         // 哈希表来实现映射的。

// 通道类型
type _channel *channelImpl

// 函数类型
type _function *functionImpl
```

从这些定义，我们可以看出来，这三个种类的类型的内部结构其实是一个指针类型。 或者说，这些类型的值的直接部分在内部是一个指针。 这些类型的每个值的直接部分引用着它的具体实现的底层间接部分。

#### 切片类型的内部定义

切片类型的内部定义：

```go
type _slice struct {
	elements unsafe.Pointer // 引用着底层的元素
	len      int            // 当前的元素个数
	cap      int            // 切片的容量
}
```

从这个定义可以看出来，一个切片类型在内部可以看作是一个指针包裹类型。 每个非零切片值包含着一个底层间接部分用来存储此切片的元素。 一个切片值的底层元素序列（间接部分）被此切片值的 `elements` 字段所引用。

#### 字符串类型的内部结构

```go
type _string struct {
	elements *byte // 引用着底层的byte元素
	len      int   // 字符串的长度
}
```

从此定义可以看出，每个字符串类型在内部也可以看作是一个指针包裹类型。 每个非零字符串值含有一个指针字段 `elements`。 这个指针字段引用着此字符串值的底层字节元素序列。

#### 接口类型的内部定义

我们可以认为接口类型在内部是如下定义的：

```go
type _interface struct {
	dynamicType  *_type         // 引用着接口值的动态类型
	dynamicValue unsafe.Pointer // 引用着接口值的动态值
}
```

从这个定义来看，接口类型也可以看作是一个指针包裹类型。一个接口类型含有两个指针字段。 每个非零接口值的（两个）间接部分分别存储着此接口值的动态类型和动态值。 这两个间接部分被此接口值的直接字段`dynamicType` 和 `dynamicValue`所引用。

事实上，上面这个内部定义只用于表示空接口类型的值。空接口类型没有指定任何方法。 

非空接口类型的内部定义如下：

```go
type _interface struct {
	dynamicTypeInfo *struct {
		dynamicType *_type       // 引用着接口值的动态类型
		methods     []*_function // 引用着动态类型的对应方法列表
	}
	dynamicValue unsafe.Pointer // 引用着动态值
}
```

一个非空接口类型的值的 `dynamicTypeInfo` 字段的 `methods` 字段引用着一个方法列表。 此列表中的每一项为此接口值的动态类型上定义的一个方法，此方法对应着此接口类型所指定的一个的同原型的方法。

### 在赋值中，底层间接值部将不会被复制

现在我们了解了第二个分类中的类型的内部结构是一个指针持有（指针或者指针包裹）类型。 这对于我们理解 Go 中的值复制行为有很大帮助。

在 Go 中，每个赋值操作（包括函数调用传参等）都是一个值的浅复制过程（假设源值和目标值的类型相同）。 换句话说，在一个赋值操作中，只有源值的直接部分被复制给了目标值。 如果源值含有间接部分，则在此赋值操作完成之后，目标值和源值的直接部分将引用着相同的间接部分。 换句话说，两个值将共享底层的间接值部，如下图所示：

![值复制](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/value-parts-copy.png)

事实上，对于字符串值和接口值的赋值，上述描述在理论上并非百分百正确。 [官方 FAQ](https://golang.google.cn/doc/faq#pass_by_value) 明确说明了在一个接口值的赋值中，接口的底层动态值将被复制到目标值。 但是，因为一个接口值的动态值是只读的，所以在接口值的赋值中，官方标准编译器并没有复制底层的动态值。这可以被视为是一个编译器优化。 对于字符串值的赋值，道理是一样的。所以对于官方标准编译器来说，上一段的描述是 100% 正确的。

因为一个间接值部可能并不专属于任何一个值，所以在使用 `unsafe.Sizeof` 函数计算一个值的尺寸的时候，此值的间接部分所占内存空间未被计算在内。
