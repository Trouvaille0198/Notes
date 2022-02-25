---
title: "Go test 教程"
date: 2022-02-25
draft: false
author: "MelonCholi"
tags: []
categories: [Golang]
---

# go test

Go语言提供了go test 命令行工具，使用该工具可以很方便的进行测试。

不仅 Go 语言源码中大量使用 go test，在各种开源框架中的应用也极为普遍。

目前 go test 支持的测试类型有：

- 单元测试
- 性能测试
- 示例测试

## 单元测试

单元测试是指对软件中的最小可测试单元进行检查和验证，比如对一个函数的测试。

- 测试文件名必须以"_test.go"结尾；
- 测试函数名必须以“TestXxx”开始；
- 命令行下使用"go test"即可启动测试；

### 规范

Go 语言推荐测试文件和源代码文件放在一块，测试文件以 `_test.go` 结尾。比如，当前 package 有 `calc.go` 一个文件，我们想测试 `calc.go` 中的 `Add` 和 `Mul` 函数，那么应该新建 `calc_test.go` 作为测试文件。

```
example/
   |--calc.go
   |--calc_test.go
```

假如 `calc.go` 的代码如下：

```go
package main

func Add(a int, b int) int {
    return a + b
}

func Mul(a int, b int) int {
    return a * b
}
```

那么 `calc_test.go` 中的测试用例可以这么写：

```go
package main

import "testing"

func TestAdd(t *testing.T) {
	if ans := Add(1, 2); ans != 3 {
		t.Errorf("1 + 2 expected be 3, but %d got", ans)
	}

	if ans := Add(-10, -20); ans != -30 {
		t.Errorf("-10 + -20 expected be -30, but %d got", ans)
	}
}
```

### 测试文件

单元测试源码文件可以由多个测试用例组成，每个测试用例函数需要以 `Test` 为前缀，例如：

`func TestXXX( t *testing.T )`

- 测试用例文件不会参与正常源码编译，不会被包含到可执行文件中。
- 测试用例文件使用 `go test` 指令来执行，没有也不需要 `main()` 作为函数入口。所有在以 `_test` 结尾的源码内以 `Test` 开头的函数会自动被执行。
- 测试用例可以不传入 `*testing.T` 参数。
- 基准测试 (benchmark) 的参数是 `*testing.B`，TestMain 的参数是 `*testing.M` 类型。

### go test

默认的情况下，`go test` 命令不需要任何的参数，它会自动把你源码包下面所有 test 文件测试完毕，当然你也可以带上参数。

- `-bench regexp` 执行相应的 benchmarks，例如 -bench=.；
- `-cover` 开启测试覆盖率；
- `-run regexp` 只运行 regexp 匹配的函数，例如 -run=Array 那么就执行包含有 Array 开头的函数；
- `-v` 显示测试的详细命令。

#### 示例

运行 `go test`，该 package 下所有的测试用例都会被执行。

```go
$ go test
ok      example 0.009s
```

或者指定 test 文件

```go
go test helloworld_test.go
```

#### 显示每个用例的结果

`go test -v`，`-v` 参数会显示每个用例的测试结果

```go
$ go test -v
=== RUN   TestAdd
--- PASS: TestAdd (0.00s)
=== RUN   TestMul
--- PASS: TestMul (0.00s)
PASS
ok      example 0.007s
```

#### 查看覆盖率

#### 运行指定函数

如果只想运行其中的一个用例，例如 `TestAdd`，可以用 `-run` 参数指定，该参数支持通配符 `*`，和部分正则表达式，例如 `^`、`$`。

```go
$ go test -run TestAdd -v
=== RUN   TestAdd
--- PASS: TestAdd (0.00s)
PASS
ok      example 0.007s
```

#### 标记单元测试结果

当需要终止当前测试用例时，可以使用 FailNow，参考下面的代码。

测试结果标记（具体位置是`./src/chapter11/gotest/fail_test.go`）

```go
func TestFailNow(t *testing.T) {    
	t.FailNow()
}
```

还有一种**只标记错误不终止测试**的方法，代码如下：

```go
func TestFail(t *testing.T) {
    fmt.Println("before fail")
    t.Fail()
    fmt.Println("after fail")
}
```

测试结果如下：

```go
=== RUN   TestFail
before fail
after fail
--- FAIL: TestFail (0.00s)
FAIL
exit status 1
FAIL        command-line-arguments        0.002s
```

从日志中看出，第 5 行调用 `Fail()` 后测试结果标记为失败，但是第 7 行依然被程序执行了。

#### 单元测试日志

每个测试用例可能并发执行，使用 testing.T 提供的日志输出可以保证日志跟随这个测试上下文一起打印输出。testing.T 提供了几种日志输出方法，详见下表所示。

| 方  法 | 备  注                           |
| ------ | -------------------------------- |
| Log    | 打印日志，同时结束测试           |
| Logf   | 格式化打印日志，同时结束测试     |
| Error  | 打印错误日志，同时结束测试       |
| Errorf | 格式化打印错误日志，同时结束测试 |
| Fatal  | 打印致命日志，同时结束测试       |
| Fatalf | 格式化打印致命日志，同时结束测试 |


开发者可以根据实际需要选择合适的日志。

## 性能测试

性能测试，也称**基准测试**，可以测试一段程序的性能，可以得到时间消耗、内存使用情况的报告。

Go 语言中提供了基准测试框架，使用方法类似于单元测试，使用者无须准备高精度的计时器和各种分析工具，基准测试本身即可以打印出非常标准的测试报告。

### 规范

基准测试（具体位置是 `./src/chapter11/gotest/benchmark_test.go`）

```go
package code11_3

import "testing"

func BenchmarkAdd(b *testing.B) {
    var n int
    for i := 0; i < b.N; i++ {
        n++
    }
}
```

这段代码使用基准测试框架测试加法性能。

第 7 行中的 `b.N` 由基准测试框架提供。N 值是动态调整的，直到可靠的算出程序执行时间后才会停止，具体执行次数会在执行结束后打印出来。

测试代码需要保证函数可重入性及无状态，也就是说，测试代码不使用全局变量等带有记忆性质的数据结构。避免多次运行同一段代码时的环境不一致，不能假设 N 值范围。

使用如下命令行开启基准测试：

```go
$ go test -v -bench=. benchmark_test.go
goos: linux
goarch: amd64
Benchmark_Add-4           20000000         0.33 ns/op
PASS
ok          command-line-arguments        0.700s
```

- 第 1 行的 `-bench=.` 表示运行 benchmark_test.go 文件里的所有基准测试，和单元测试中的 `-run` 类似。
- 第 4 行中显示基准测试名称，20000000 表示测试的次数，也就是 testing.B 结构中提供给程序使用的 N。“0.33 ns/op”表示每一个操作耗费多少时间（纳秒）。

> Windows 下使用 go test 命令行时，`-bench=.` 应写为 `-bench="."`。

#### 基准测试原理

基准测试框架对一个测试用例的默认测试时间是 1 秒。开始测试时，当以 Benchmark 开头的基准测试用例函数返回时还不到 1 秒，那么 testing.B 中的 N 值将按 1、2、5、10、20、50……递增，同时以递增后的值重新调用基准测试用例函数。

#### 自定义测试时间

通过 `-benchtime` 参数可以自定义测试时间，例如：

```go
$ go test -v -bench=. -benchtime=5s benchmark_test.go
goos: linux
goarch: amd64
Benchmark_Add-4           10000000000                 0.33 ns/op
PASS
ok          command-line-arguments        3.380s
```

####  测试内存 `-benchmem`

基准测试可以对一段代码可能存在的内存分配进行统计，下面是一段使用字符串格式化的函数，内部会进行一些分配操作。

```go
func BenchmarkAlloc(b *testing.B) {
    for i := 0; i < b.N; i++ {
        fmt.Sprintf("%d", i)
    }
}
```

在命令行中添加 `-benchmem` 参数以显示内存分配情况，参见下面的指令：

```go
$ go test -v -bench=Alloc -benchmem benchmark_test.go
goos: linux
goarch: amd64
Benchmark_Alloc-4 20000000 109 ns/op 16 B/op 2 allocs/op
PASS
ok          command-line-arguments        2.311s
```

代码说明如下：

- 第 1 行的代码中 `-bench` 后添加了 Alloc，指定只测试 `BenchmarkAlloc()` 函数。
- 第 4 行代码的“16 B/op”表示每一次调用需要分配 16 个字节，“2 allocs/op”表示每一次调用有两次分配。

#### 控制计时器

有些测试需要一定的启动和初始化时间，如果从 `Benchmark()` 函数开始计时会很大程度上影响测试结果的精准性。

testing.B 提供了一系列的方法可以方便地控制计时器，从而让计时器只在需要的区间进行测试。我们通过下面的代码来了解计时器的控制。

基准测试中的计时器控制（具体位置是 `./src/chapter11/gotest/benchmark_test.go`）：

```go
func BenchmarkAddTimerControl(b *testing.B) {
    // 重置计时器
    b.ResetTimer()
    // 停止计时器
    b.StopTimer()
    // 开始计时器
    b.StartTimer()
    var n int
    for i := 0; i < b.N; i++ {
        n++
    }
}
```

从 `Benchmark()` 函数开始，Timer 就开始计数。`StopTimer()` 可以停止这个计数过程，做一些耗时的操作，通过 `StartTimer()` 重新开始计时。`ResetTimer()` 可以重置计数器的数据。

**计数器内部不仅包含耗时数据，还包括内存分配的数据。**

## 示例测试

示例测试，广泛应用于 Go 源码和各种开源框架中，用于展示某个包或某个方法的用法。

1. 例子测试函数名需要以 "Example" 开头；
2. 检测单行输出格式为 “`// Output: <期望字符串>`”；
3. 检测多行输出格式为 “`// Output: \ <期望字符串> \ <期望字符串>`”，每个期望字符串占一行；
4. 检测无序输出格式为 "`// Unordered output: \ <期望字符串> \ <期望字符串>`"，每个期望字符串占一行；
5. 测试字符串时会自动忽略字符串前后的空白字符；
6. 如果测试函数中没有 “Output” 标识，则该测试函数不会被执行；
7. 执行测试可以使用 `go test`，此时该目录下的其他测试文件也会一并执行；
8. 执行测试可以使用 `go test <xxx_test.go>`，此时仅执行特定文件中的测试函数；

### 示例

源代码文件 `example.go` 中包含 `SayHello()`、`SayGoodbye()`和`PrintNames()` 三个方法，如下所示：

```go
package gotest

import "fmt"

// SayHello 打印一行字符串
func SayHello() {
    fmt.Println("Hello World")
}

// SayGoodbye 打印两行字符串
func SayGoodbye() {
    fmt.Println("Hello,")
    fmt.Println("goodbye")
}

// PrintNames 打印学生姓名
func PrintNames() {
    students := make(map[int]string, 4)
    students[1] = "Jim"
    students[2] = "Bob"
    students[3] = "Tom"
    students[4] = "Sue"
    for _, value := range students {
        fmt.Println(value)
    }
}
```

这几个方法打印内容略有不同，分别代表一种典型的场景：

- `SayHello()`：只有一行打印输出
- `SayGoodbye()`：有两行打印输出
- `PrintNames()`：有多行打印输出，且由于 Map 数据结构的原因，多行打印次序是随机的。

****

测试文件 `example_test.go` 中包含 3 个测试方法，于源代码文件中的 3 个方法一一对应，测试文件如下所示：

```go
package gotest_test

import "gotest"

// 检测单行输出
func ExampleSayHello() {
    gotest.SayHello()
    // OutPut: Hello World
}

// 检测多行输出
func ExampleSayGoodbye() {
    gotest.SayGoodbye()
    // OutPut:
    // Hello,
    // goodbye
}

// 检测乱序输出
func ExamplePrintNames() {
    gotest.PrintNames()
    // Unordered output:
    // Jim
    // Bob
    // Tom
    // Sue
}
```

例子测试函数命名规则为"Examplexxx"，其中"xxx"为自定义的标识，通常为待测函数名称。

这三个测试函数分别代表三种场景：

- `ExampleSayHello()`： 待测试函数只有一行输出，使用"// OutPut: "检测。
- `ExampleSayGoodbye()`：待测试函数有多行输出，使用"// OutPut: "检测，其中期望值也是多行。
- `ExamplePrintNames()`：待测试函数有多行输出，但输出次序不确定，使用"// Unordered output:"检测。

注：字符串比较时会忽略前后的空白字符。

****

命令行下，使用 `go test` 或 `go test example_test.go` 命令即可启动测试，如下所示：

```go
E:\OpenSource\GitHub\RainbowMango\GoExpertProgrammingSourceCode\GoExpert\src\gotest>go test example_test.go
ok      command-line-arguments  0.331s
```

## 子测试

