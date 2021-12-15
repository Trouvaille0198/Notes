# bytes

该包定义了一些操作 byte slice 的便利操作。

因为字符串可以表示为 []byte，所以 bytes 包定义的函数、方法等和 strings 包很类似

> 为了方便，会称呼 []byte 为 字节数组

## 是否存在某个子 slice

```go
// 子 slice subslice 在 b 中，返回 true
func Contains(b, subslice []byte) bool
```

该函数的内部调用了 bytes.Index 函数

```go
func Contains(b, subslice []byte) bool {
    return Index(b, subslice) != -1
}
```

题外：对比 `strings.Contains` 会发现，一个判断 `>=0`，一个判断 `!= -1`，可见库不是一个人写的，没有做到一致性。

## []byte 出现次数

```go
// slice sep 在 s 中出现的次数（无重叠）
func Count(s, sep []byte) int
```

和 strings 实现不同，此包中的 Count 核心代码如下：

```go
count := 0
c := sep[0]
i := 0
t := s[:len(s)-n+1]
for i < len(t) {
    // 判断 sep 第一个字节是否在 t[i:] 中
    // 如果在，则比较之后相应的字节
    if t[i] != c {
        o := IndexByte(t[i:], c)
        if o < 0 {
            break
        }
        i += o
    }
    // 执行到这里表示 sep[0] == t[i]
    if n == 1 || Equal(s[i:i+n], sep) {
        count++
        i += n
        continue
    }
    i++
}
```

## Runes 类型转换

```go
// 将 []byte 转换为 []rune
func Runes(s []byte) []rune
```

该函数将 []byte 转换为 []rune ，适用于汉字等多字节字符，示例：

```go
b:=[]byte("你好，世界")
for k,v:=range b{
    fmt.Printf("%d:%s |",k,string(v))
}
r:=bytes.Runes(b)
for k,v:=range r{
    fmt.Printf("%d:%s|",k,string(v))
}
```

运行结果：

```bash
0:ä |1:½ |2:  |3:å |4:¥ |5:½ |6:ï |7:¼ |8:  |9:ä |10:¸ |11:  |12:ç |13:  |14: |
0:你|1:好|2:，|3:世|4:界|
```