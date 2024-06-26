---
title: "Go strconv 标准库"
date: 2021-12-15
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# strconv

这个包实现了字符串和基本数据类型之间转换

这里的基本数据类型包括：布尔、整型（包括有 / 无符号、二进制、八进制、十进制和十六进制）和浮点型等。

## strconv 包转换错误处理

介绍具体的转换之前，先看看 *strconv* 中的错误处理。

由于将字符串转为其他数据类型可能会出错，*strconv* 包定义了两个 *error* 类型的变量：*ErrRange* 和 *ErrSyntax*。其中，*ErrRange* 表示值超过了类型能表示的最大范围，比如将 "128" 转为 int8 就会返回这个错误；*ErrSyntax* 表示语法错误，比如将 "" 转为 int 类型会返回这个错误。

然而，在返回错误的时候，不是直接将上面的变量值返回，而是通过构造一个 *NumError* 类型的 *error* 对象返回。*NumError* 结构的定义如下：

```go
// A NumError records a failed conversion.
type NumError struct {
    Func string // the failing function (ParseBool, ParseInt, ParseUint, ParseFloat)
    Num  string // the input
    Err  error  // the reason the conversion failed (ErrRange, ErrSyntax)
}
```

可见，该结构记录了转换过程中发生的错误信息。该结构不仅包含了一个 *error* 类型的成员，记录具体的错误信息，而且它自己也实现了 *error* 接口：

```go
func (e *NumError) Error() string {
    return "strconv." + e.Func + ": " + "parsing " + Quote(e.Num) + ": " + e.Err.Error()
}
```

包的实现中，定义了两个便捷函数，用于构造 *NumError* 对象：

```go
func syntaxError(fn, str string) *NumError {
    return &NumError{fn, str, ErrSyntax}
}

func rangeError(fn, str string) *NumError {
    return &NumError{fn, str, ErrRange}
}
```

在遇到 *ErrSyntax* 或 *ErrRange* 错误时，通过上面的函数构造 *NumError* 对象。

## 字符串和整型之间的转换

### 字符串转为整型

包括三个函数：ParseInt、ParseUint 和 Atoi，函数原型如下：

```go
// 转为有符号整型
func ParseInt(s string, base int, bitSize int) (i int64, err error)
// 转为无符号整型
func ParseUint(s string, base int, bitSize int) (n uint64, err error)
// 是 ParseInt 的便捷版，内部通过调用 *ParseInt(s, 10, 0)* 来实现的
func Atoi(s string) (i int, err error)
```

着重介绍 ParseInt。

- 参数 *base* 代表字符串按照给定的进制进行解释。
    - 一般的，base 的取值为 2~36
    - 如果 base 的值为 0，则会根据字符串的前缀来确定 base 的值："0x" 表示 16 进制； "0" 表示 8 进制；否则就是 10 进制。

- 参数 *bitSize* 表示的是整数取值范围，或者说整数的具体类型。取值 0、8、16、32 和 64 分别代表 int、int8、int16、int32 和 int64。

#### 当 bitSize==0 时的情况

这里有必要说一下，当 bitSize==0 时的情况。

Go 中，int/uint 类型，不同系统能表示的范围是不一样的，目前的实现是，32 位系统占 4 个字节；64 位系统占 8 个字节。当 bitSize==0 时，应该表示 32 位还是 64 位呢？这里没有利用 *runtime.GOARCH* 之类的方式，而是巧妙的通过如下表达式确定 intSize：

```
const intSize = 32 << uint(^uint(0)>>63)
const IntSize = intSize // number of bits in int, uint (32 or 64)
```

主要是 *^uint(0)>>63* 这个表达式。操作符 *^* 在这里是一元操作符 按位取反，而不是 按位异或。更多解释可以参考：[Go 位运算：取反和异或](http://studygolang.com/topics/303)。

#### 超出 bitSize 的表示范围

问题：下面的代码 n 和 err 的值分别是什么？

```go
n, err := strconv.ParseInt("128", 10, 8)
```

在 *ParseInt/ParseUint* 的实现中，如果字符串表示的整数超过了 bitSize 参数能够表示的范围，则会返回 ErrRange，同时会返回 bitSize 能够表示的最大或最小值。因此，这里的 n 是 127。

另外，*ParseInt* 返回的是 int64，这是为了能够容纳所有的整型，在实际使用中，可以根据传递的 bitSize，然后将结果转为实际需要的类型。

转换的基本原理（以 "128" 转 为 10 进制 int 为例）：

```go
s := "128"
n := 0
for i := 0; i < len(s); i++ {
    n *= 10    + s[i]     // base
}
```

在循环处理的过程中，会检查数据的有效性和是否越界等。

### 整型转为字符串

实际应用中，我们经常会遇到需要将字符串和整型连接起来，在 Java 中，可以通过操作符 "+" 做到。不过，在 Go 语言中，你需要将整型转为字符串类型，然后才能进行连接。

这个时候，*strconv* 包中的整型转字符串的相关函数就派上用场了。这些函数签名如下：

```go
// 无符号整型转字符串
func FormatUint(i uint64, base int) string    
// 有符号整型转字符串
func FormatInt(i int64, base int) string  
// Itoa内部直接调用FormatInt(i, 10)实现
func Itoa(i int) string
```

其中，base 参数可以取 2~36（0-9，a-z）。

标准库还提供了另外两个函数：***AppendInt*** 和 ***AppendUint***，这两个函数不是将整数转为字符串，而是将整数转为字符数组 append 到目标字符数组中。（最终，我们也可以通过返回的 []byte 得到字符串）

除了使用上述方法将整数转为字符串外，经常见到有人使用 *fmt* 包来做这件事。如：

```go
fmt.Sprintf("%d", 127)
```

那么，这两种方式我们该怎么选择呢？我们主要来考察一下性能。

```go
startTime := time.Now()
for i := 0; i < 10000; i++ {
    fmt.Sprintf("%d", i)
}   
fmt.Println(time.Now().Sub(startTime))

startTime := time.Now()
for i := 0; i < 10000; i++ {
    strconv.Itoa(i)
}   
fmt.Println(time.Now().Sub(startTime))
```

我们分别循环转换了 10000 次。*Sprintf* 的时间是 3.549761ms，而 *Itoa* 的时间是 848.208us，相差 4 倍多。

*Sprintf* 性能差些可以预见，因为它接收的是 interface，需要进行反射等操作。个人建议使用 *strconv* 包中的方法进行转换。

> 注意：别想着通过 string(65) 这种方式将整数转为字符串，这样实际上得到的会是 ASCCII 值为 65 的字符，即 'A'。

## 字符串和布尔值之间的转换

Go 中字符串和布尔值之间的转换比较简单，主要有三个函数：

```go
// 接受 1, t, T, TRUE, true, True, 0, f, F, FALSE, false, False 等字符串；
// 其他形式的字符串会返回错误
func ParseBool(str string) (value bool, err error)

// 直接返回 "true" 或 "false"
func FormatBool(b bool) string

// 将 "true" 或 "false" append 到 dst 中
// 这里用了一个 append 函数对于字符串的特殊形式：append(dst, "true"...)
func AppendBool(dst []byte, b bool)
```

## 字符串和浮点数之间的转换

类似的，包含三个函数：

```go
func ParseFloat(s string, bitSize int) (f float64, err error)
func FormatFloat(f float64, fmt byte, prec, bitSize int) string
func AppendFloat(dst []byte, f float64, fmt byte, prec int, bitSize int)
```

函数的命名和作用跟上面讲解的其他类型一致。

关于 *FormatFloat* 的 *fmt* 参数， 在格式化 IO 中有详细介绍。而 *prec* 表示有效数字（对 *fmt='b'* 无效），对于 'e', 'E' 和 'f'，有效数字用于小数点之后的位数；对于 'g' 和 'G'，则是所有的有效数字。例如：

```go
strconv.FormatFloat(1223.13252, 'e', 3, 32)    // 结果：1.223e+03
strconv.FormatFloat(1223.13252, 'g', 3, 32)    // 结果：1.22e+03
```

由于浮点数有精度的问题，精度不一样，ParseFloat 和 FormatFloat 可能达不到互逆的效果。如：

```go
s := strconv.FormatFloat(1234.5678, 'g', 6, 64)
strconv.ParseFloat(s, 64)
```

另外，fmt='b' 时，得到的字符串是无法通过 *ParseFloat* 还原的。

特别地（不区分大小写），+inf/inf，+infinity/infinity，-inf/-infinity 和 nan 通过 ParseFloat 转换分别返回对应的值（在 math 包中定义）。

同样的，基于性能的考虑，应该使用 *FormatFloat* 而不是 *fmt.Sprintf*。

## 其他导出的函数

如果要输出这样一句话：*This is "studygolang.com" website*. 该如何做？

So easy:

```go
fmt.Println(`This is "studygolang.com" website`)
```

如果没有 *``* 符号，该怎么做？转义：

```go
fmt.Println("This is \"studygolang.com\" website")
```

除了这两种方法，*strconv* 包还提供了函数这做件事（Quote 函数）。我们称 "studygolang.com" 这种用双引号引起来的字符串为 **Go 语言字面值字符串**（Go string literal）。

上面的一句话可以这么做：

```go
fmt.Println("This is", strconv.Quote("studygolang.com"), "website")
```