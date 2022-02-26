---
title: "Go Unicode 标准库"
date: 2021-12-15
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# unicode

由于 UTF-8 的作者 Ken Thompson 同时也是 go 语言的创始人，所以说，在字符支持方面，几乎没有语言的理解会高于 go 了。 go 对 unicode 的支持包含三个包 :

- unicode
- unicode/utf8
- unicode/utf16

unicode 包包含基本的字符判断函数。utf8 包主要负责 rune 和 byte 之间的转换。utf16 包负责 rune 和 uint16 数组之间的转换。

由于字符的概念有的时候比较模糊，比如字符（小写 a）普通显示为 a，在重音字符中（grave-accented）中显示为à。 这时候字符（character）的概念就有点不准确了，因为 a 和à显然是两个不同的 unicode 编码，但是却代表同一个字符，所以引入了 rune。 **一个 rune 就代表一个 unicode 编码**，所以上面的 a 和à是两个不同的 rune。

> go 语言的所有代码都是 UTF8 的，所以如果我们在程序中的字符串都是 utf8 编码的，但是我们的单个字符（单引号扩起来的）却是 unicode 的

## unicode 包

unicode 包含了对 rune 的判断。这个包把所有 unicode 涉及到的编码进行了分类，使用结构

```go
type RangeTable struct {
    R16         []Range16
    R32         []Range32
    LatinOffset int
}
```

来表示这个功能的字符集。这些字符集都集中列表在 table.go 这个源码里面。

比如控制字符集：

```go
var _Pc = &RangeTable{
    R16: []Range16{
        {0x005f, 0x203f, 8160},
        {0x2040, 0x2054, 20},
        {0xfe33, 0xfe34, 1},
        {0xfe4d, 0xfe4f, 1},
        {0xff3f, 0xff3f, 1},
    },
}
```

比如对国内开发者很实用的汉字字符集：

```go
var _Han = &RangeTable{
    R16: []Range16{
        {0x2e80, 0x2e99, 1},
        {0x2e9b, 0x2ef3, 1},
        {0x2f00, 0x2fd5, 1},
        {0x3005, 0x3005, 1},
        {0x3007, 0x3007, 1},
        {0x3021, 0x3029, 1},
        {0x3038, 0x303b, 1},
        {0x3400, 0x4db5, 1},
        {0x4e00, 0x9fea, 1},
        {0xf900, 0xfa6d, 1},
        {0xfa70, 0xfad9, 1},
    },
    R32: []Range32{
        {0x20000, 0x2a6d6, 1},
        {0x2a700, 0x2b734, 1},
        {0x2b740, 0x2b81d, 1},
        {0x2b820, 0x2cea1, 1},
        {0x2ceb0, 0x2ebe0, 1},
        {0x2f800, 0x2fa1d, 1},
    },
}
```

回到包的函数，我们看到有下面这些判断函数：

```go
func IsControl(r rune) bool  // 是否控制字符
func IsDigit(r rune) bool  // 是否阿拉伯数字字符，即 0-9
func IsGraphic(r rune) bool // 是否图形字符
func IsLetter(r rune) bool // 是否字母
func IsLower(r rune) bool // 是否小写字符
func IsMark(r rune) bool // 是否符号字符
func IsNumber(r rune) bool // 是否数字字符，比如罗马数字Ⅷ也是数字字符
func IsOneOf(ranges []*RangeTable, r rune) bool // 是否是 RangeTable 中的一个
func IsPrint(r rune) bool // 是否可打印字符
func IsPunct(r rune) bool // 是否标点符号
func IsSpace(r rune) bool // 是否空格
func IsSymbol(r rune) bool // 是否符号字符
func IsTitle(r rune) bool // 是否 title case
func IsUpper(r rune) bool // 是否大写字符
func Is(rangeTab *RangeTable, r rune) bool // r 是否为 rangeTab 类型的字符
func In(r rune, ranges ...*RangeTable) bool  // r 是否为 ranges 中任意一个类型的字符
```

看下面这个例子：

```go
func main() {
    single := '\u0015'
    fmt.Println(unicode.IsControl(single))
    single = '\ufe35'
    fmt.Println(unicode.IsControl(single))

    digit := '1'
    fmt.Println(unicode.IsDigit(digit))
    fmt.Println(unicode.IsNumber(digit))

    letter := 'Ⅷ'
    fmt.Println(unicode.IsDigit(letter))
    fmt.Println(unicode.IsNumber(letter))

    han:='你'
    fmt.Println(unicode.IsDigit(han))
    fmt.Println(unicode.Is(unicode.Han,han))
    fmt.Println(unicode.In(han,unicode.Gujarati,unicode.White_Space))
 }
```

输出结果：

```bash
true
false
true
true
false
true
false
true
false
```

## utf8 包

utf8 里面的函数就有一些字节和字符的转换。

判断是否符合 utf8 编码的函数：

- `func Valid(p []byte) bool`
- `func ValidRune(r rune) bool`
- `func ValidString(s string) bool`

判断 rune 所占字节数：

- `func RuneLen(r rune) int`

判断字节串或者字符串的 rune 数：

- `func RuneCount(p []byte) int`
- `func RuneCountInString(s string) (n int)`

编码和解码到 rune：

```go
func EncodeRune(p []byte, r rune) int

func DecodeRune(p []byte) (r rune, size int)

func DecodeRuneInString(s string) (r rune, size int)

func DecodeLastRune(p []byte) (r rune, size int)

func DecodeLastRuneInString(s string) (r rune, size int)
```

是否为完整 rune：

- `func FullRune(p []byte) bool`
- `func FullRuneInString(s string) bool`

是否为 rune 第一个字节：

- `func RuneStart(b byte) bool`

示例：

```go
word:=[]byte("界")

fmt.Println(utf8.Valid(word[:2]))
fmt.Println(utf8.ValidRune('界'))
fmt.Println(utf8.ValidString("世界"))

fmt.Println(utf8.RuneLen('界'))

fmt.Println(utf8.RuneCount(word))
fmt.Println(utf8.RuneCountInString("世界"))

p:=make([]byte,3)
utf8.EncodeRune(p,'好')
fmt.Println(p)
fmt.Println(utf8.DecodeRune(p))
fmt.Println(utf8.DecodeRuneInString("你好"))
fmt.Println(utf8.DecodeLastRune([]byte("你好")))
fmt.Println(utf8.DecodeLastRuneInString("你好"))

fmt.Println(utf8.FullRune(word[:2]))
fmt.Println(utf8.FullRuneInString("你好"))

fmt.Println(utf8.RuneStart(word[1]))
fmt.Println(utf8.RuneStart(word[0]))
```

运行结果：

```bash
false
true
true
3
1
2
[229 165 189]
22909 3
20320 3
22909 3
22909 3
false
true
false
true
```

## utf16 包

utf16 的包的函数就比较少了。

将 uint16 和 rune 进行转换

```go
func Encode(s []rune) []uint16
func EncodeRune(r rune) (r1, r2 rune)
func Decode(s []uint16) []rune
func DecodeRune(r1, r2 rune) rune
func IsSurrogate(r rune) bool // 是否为有效代理对
```

unicode 有个基本字符平面和增补平面的概念，基本字符平面只有 65535 个字符，增补平面（有 16 个）加上去就能表示 1114112 个字符。 utf16 就是严格实现了 unicode 的这种编码规范。

而基本字符和增补平面字符就是一个代理对（Surrogate Pair）。一个代理对可以和一个 rune 进行转换。

示例：

```go
words :=[]rune{'𝓐','𝓑'}

u16:=utf16.Encode(words)
fmt.Println(u16)
fmt.Println(utf16.Decode(u16))

r1,r2:=utf16.EncodeRune('𝓐')
fmt.Println(r1,r2)
fmt.Println(utf16.DecodeRune(r1,r2))
fmt.Println(utf16.IsSurrogate(r1))
fmt.Println(utf16.IsSurrogate(r2))
fmt.Println(utf16.IsSurrogate(1234))
```

输出结果：

```bash
[55349 56528 55349 56529]
[120016 120017]
55349 56528
120016
true
true
false
```