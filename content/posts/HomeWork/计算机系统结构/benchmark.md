---
draft: true
---

# Golang 程序性能分析与优化

## 实验环境与测试工具

实验环境配置

- CPU：i5-9300H

- 语言版本：Go 1.17.4

性能分析工具：`runtime/pprof` 与 `pkg/profile`

获取方式

- `runtime/pprof` 包为 Golang 的标准库，下载 Golang 时自带
- `pkg/profile` 是对 `runtime/pprof` 的封装，使用 `go get github.com/pkg/profile` 来获取

## 程序介绍

程序生成了若干数组，对每个数组进行冒泡排序，最后将数组中的数字拼接成一个字符串

```go
package src

import (
	"math/rand"
	"strconv"
	"strings"
	"sync"
	"time"
)

// generate 生成随机数组
func generate(n int) []int {
	rand.Seed(time.Now().UnixNano())
	nums := make([]int, 0)
	for i := 0; i < n; i++ {
		nums = append(nums, rand.Int())
	}
	return nums
}

// bubbleSort 冒泡排序
func bubbleSort(nums []int) {
	for i := 0; i < len(nums)-1; i++ {
		for j := 0; j < len(nums)-i-1; j++ {
			if nums[j] > nums[j+1] {
				nums[j], nums[j+1] = nums[j+1], nums[j]
			}
		}
	}
}

func getChar(nums []int) (res string) {
	for _, num := range nums {
		res += strconv.Itoa(num)
	}
	return
}

func Run() {
	n := 10000
	for i := 0; i < 50; i++ {
		nums := generate2(n)
		bubbleSort(nums)
		_ = getChar2(nums)
	}
}
```

## CPU 耗时分析

### 优化前

在源程序中嵌入如下代码以分析 CPU 耗时情况

```go
f, _ := os.OpenFile("cpu.pprof", os.O_CREATE|os.O_RDWR, 0644) // cpu性能分析结果文件
defer f.Close()
pprof.StartCPUProfile(f)
defer pprof.StopCPUProfile()
```

运行结束后，使用以下命令打开可交互界面

```shell
go tool pprof cpu.pprof
```

**程序总共耗时 10.57s**

键入 `top` 查看各函数运行时长

![image-20220504143042349](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504143042349.png)

键入 `web` 打开网页，查看更清晰的调用时长图

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504143644841.png" alt="image-20220504143644841" style="zoom:67%;" />

可以看到，**冒泡排序函数**和**拼接字符串操作**占用了很长一段时间

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504143836405.png" alt="image-20220504143836405" style="zoom:67%;" />

gc 垃圾收集器也相当耗时，猜测是生成数组时产生的临时变量太多

### 优化后

**程序总共耗时 5.51s**

再次查看函数耗时图

![image-20220504145835152](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504145835152.png)

字符串拼接函数耗时大大减少，内存分配的相关运行时甚至都没有出现在运行图中。

## 内存占用分析

### 优化前

使用 `pkg/profile` 包来采集内存占用数据，只需在程序中嵌入以下代码：

```go
defer profile.Start(profile.MemProfile, profile.MemProfileRate(1)).Stop()
```

**共占用 1600kb 内存**

查看内存占用情况

![image-20220504151409748](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504151409748.png)

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504152849442.png" alt="image-20220504152849442" style="zoom:67%;" />

可以看到字符串拼接函数占用了绝大部分的内存，生成数组也占用了一些内存

![image-20220504153129669](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504153129669.png)

gc 回收和进程本身也占用了必要的一些内存

### 优化后

**共占用 92kb 内存**

查看内存占用情况

![image-20220504150835247](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504150835247.png)

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504153732565.png" alt="image-20220504153732565" style="zoom:50%;" />

可以看到，字符串拼接方法甚至没有出现在图中，说明其基本不占用内存

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504153907362.png" alt="image-20220504153907362" style="zoom:67%;" />

可以看到，在协程切换时不可避免地出现了一点内存泄漏的情况

## 优化措施

### 修改字符串拼接方式

更改字符串拼接方式，放弃使用 `+` 方法，转而使用 `strings.Builder`

`strings.Builder` 的底层是一个 `[]byte` 数组，其扩容时是成倍扩容，效率比使用 `+` 时每次只扩容对应长度的策略更高，又可以节省内存

```go
func builderConcat(n int, str string) string {
	var builder strings.Builder
	for i := 0; i < n; i++ {
		builder.WriteString(str)
	}
	return builder.String()
}
```

### 生成数组时预先分配内存

其次，在生成数组时，预先分配固定大小的内存，这样可以减少扩容次数，加快运行速度

```go
func generate(n int) []int {
	rand.Seed(time.Now().UnixNano())
	nums := make([]int, n)
	for i := 0; i < n; i++ {
		nums[i] = rand.Intn(n)
	}
	return nums
}
```

### 并行处理

开启 Goroutine（协程）来充分利用 CPU 性能做并行运算

```go
n := 10000
var wg sync.WaitGroup
for i := 0; i < 50; i++ {
    wg.Add(1)
    go func() {
        nums := generate2(n)
        bubbleSort(nums)
        _ = getChar2(nums)
        wg.Done()
    }()
}
wg.Wait()
```

可以将时间压缩至 1.88s；但是由于协程切换需要消耗内存，所以内存占用会有所增加

协程对于内存不友好的更重要原因是：gc 回收将会分开进行

在线性处理时，每一次拼接字符串结束后，gc 回收器都会将 `strings.Builder` 进行垃圾回收处理

但在多协程情况下，每一个协程都会在 `getChar()` 函数中生成一个 `strings.Builder`，其所占内存也就大大增加了，如下图所示：

![image-20220504155844637](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220504155844637.png)
