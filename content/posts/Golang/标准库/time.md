---
title: "Go time 标准库"
date: 2021-12-16
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# time

time 包提供了时间的显示和测量用的函数。日历的计算采用的是公历。

## 一些对象

### 时间类型 Time

`time.Time` 代表一个纳秒精度的时间点。

- 程序中应使用 Time 类型值来保存和传递时间，而不是指针。就是说，表示时间的变量和字段，应为 time.Time 类型，而不是 *time.Time. 类型。
- 一个 Time 类型值可以被多个 go 协程同时使用。
- 时间点可以使用 Before、After 和 Equal 方法进行比较。Sub 方法让两个时间点相减，生成一个 Duration 类型值（代表时间段）。Add 方法给一个时间点加上一个时间段，生成一个新的 Time 类型时间点。
- 通过 `==` 比较 Time 时，Location 信息也会参与比较，因此 Time 不应该作为 map 的 key。

#### 内部结构

```go
type Time struct {
    // sec gives the number of seconds elapsed since
    // January 1, year 1 00:00:00 UTC.
    sec int64

    // nsec specifies a non-negative nanosecond
    // offset within the second named by Seconds.
    // It must be in the range [0, 999999999].
    nsec int32

    // loc specifies the Location that should be used to
    // determine the minute, hour, month, day, and year
    // that correspond to this Time.
    // Only the zero Time has a nil Location.
    // In that case it is interpreted to mean UTC.
    loc *Location
}
```

#### `time.Now()`

我们可以通过 `time.Now()` 函数获取当前的时间对象，然后获取时间对象的年月日时分秒等信息。

```go
// Now returns the current local time.
func Now() Time {
    sec, nsec := now()
    return Time{sec + unixToInternal, nsec, Local}
}
```

`now()` 的具体实现在 `runtime` 包中，以 linux/amd64 为例，在 sys_linux_amd64.s 中的 `time · now`，这是汇编实现的

> 回到 `time.Now()` 的实现，现在我们得到了 sec 和 nsec，从 `Time{sec + unixToInternal, nsec, Local}` 这句可以看出，Time 结构的 sec 并非 Unix 时间戳，实际上，加上的 `unixToInternal` 是 1-1-1 到 1970-1-1 经历的秒数。也就是 `Time` 中的 **sec 是从 1-1-1 算起的秒数**，而不是 Unix 时间戳。

示例代码如下：

```go
func timeDemo() {
    now := time.Now() //获取当前时间
    fmt.Printf("current time:%v\n", now)

    year := now.Year()     //年
    month := now.Month()   //月
    day := now.Day()       //日
    hour := now.Hour()     //小时
    minute := now.Minute() //分钟
    second := now.Second() //秒
    fmt.Printf("%d-%02d-%02d %02d:%02d:%02d\n", year, month, day, hour, minute, second)
}
```

### 时间戳

时间戳是自 1970 年 1 月 1 日（08:00:00GMT）至当前时间的总毫秒数。它也被称为 Unix 时间戳（UnixTimestamp）。

```go
time.Time.Unix() //得到 Unix 时间戳；
time.Time.UnixNano() //得到 Unix 时间戳的纳秒表示；
```

基于时间对象获取时间戳的示例代码如下：

```go
func timestampDemo() {
    now := time.Now()            //获取当前时间
    timestamp1 := now.Unix()     //时间戳
    timestamp2 := now.UnixNano() //纳秒时间戳
    fmt.Printf("current timestamp1:%v\n", timestamp1)
    fmt.Printf("current timestamp2:%v\n", timestamp2)
}
```

使用 `time.Unix()` 函数可以将时间戳转为时间格式。

```go
func timestampDemo2(timestamp int64) {
    timeObj := time.Unix(timestamp, 0) //将时间戳转为时间格式
    fmt.Println(timeObj)
}
```

### 时间间隔 Duration 对象

time.Duration 是 time 包定义的一个类型，它代表两个时间点之间经过的时间，以纳秒为单位。time.Duration 表示一段时间间隔，可表示的最长时间段大约 290 年。

time 包中定义的时间间隔类型的常量如下：

```go
const (
    Nanosecond  Duration = 1
    Microsecond          = 1000 * Nanosecond
    Millisecond          = 1000 * Microsecond
    Second               = 1000 * Millisecond
    Minute               = 60 * Second
    Hour                 = 60 * Minute
)
```

例如：time.Duration 表示 1 纳秒，time.Second 表示 1 秒。

## 时间操作

### Add

我们在日常的编码过程中可能会遇到要求时间 + 时间间隔的需求，Go 语言的时间对象有提供 Add 方法如下：

```go
func (t Time) Add(d Duration) Time
```

举个例子，求一个小时之后的时间：

```go
func main() {
    now := time.Now()
    later := now.Add(time.Hour) // 当前时间加1小时后的时间
    fmt.Println(later)
}
```

### Sub

求两个时间之间的差值：

```go
func (t Time) Sub(u Time) Duration
```

返回一个时间段 t-u。如果结果超出了 Duration 可以表示的最大值/最小值，将返回最大值/最小值。

要获取时间点 t-d（d 为 Duration），可以使用 t.Add(-d)。

### Equal

```go
func (t Time) Equal(u Time) bool
```

判断两个时间是否相同，会考虑时区的影响，因此不同时区标准的时间也可以正确比较。

本方法和用 t==u 不同，这种方法还会比较**地点和时区信息**。

### Before

```go
func (t Time) Before(u Time) bool
```

如果 t 代表的时间点在 u 之前，返回真；否则返回假。

### After

```go
func (t Time) After(u Time) bool
```

如果 t 代表的时间点在 u 之后，返回真；否则返回假。

## 定时器

定时器是进程规划自己在未来某一时刻接获通知的一种机制

使用 `time.Tick` (时间间隔) 来设置定时器，定时器的本质上是一个通道（channel）。

```go
func tickDemo() {
    ticker := time.Tick(time.Second) //定义一个1秒间隔的定时器
    for i := range ticker {
        fmt.Println(i)//每秒都会执行的任务
    }
}

// 或
var ticker *time.Ticker = time.NewTicker(time.Second)
for {
    t:=<-ticker.C
}
```

## 时间格式化

时间类型有一个自带的方法 Format 进行格式化，需要注意的是 Go 语言中格式化时间模板不是常见的 `Y-m-d H:M:S`，而是使用 Go 的诞生时间 2006 年 1月 2 号15 点 04 分（记忆口诀为 2006 1 2 3 4）。也许这就是技术人员的浪漫叭。

补充：如果想格式化为 12 小时方式，需指定 PM。

```go
func formatDemo() {
    now := time.Now()
    // 格式化的模板为Go的出生时间2006年1月2号15点04分 Mon Jan
    // 24小时制
    fmt.Println(now.Format("2006-01-02 15:04:05.000 Mon Jan"))
    // 12小时制
    fmt.Println(now.Format("2006-01-02 03:04:05.000 PM Mon Jan"))
    fmt.Println(now.Format("2006/01/02 15:04"))
    fmt.Println(now.Format("15:04 2006/01/02"))
    fmt.Println(now.Format("2006/01/02"))
}
```

### 解析字符串格式的时间

`time.Parse` 和 `time.ParseInLocation` 被用来解析时间串

一般的，我们应该总是使用 `time.ParseInLocation` 来解析时间，并给第三个参数传递 `time.Local`

```go
now := time.Now()
fmt.Println(now)
// 加载时区
loc, err := time.LoadLocation("Asia/Shanghai")
if err != nil {
    fmt.Println(err)
    return
}
// 按照指定时区和指定格式解析字符串时间
timeObj, err := time.ParseInLocation("2006/01/02 15:04:05", "2019/08/04 14:15:20", loc)
if err != nil {
    fmt.Println(err)
    return
}
fmt.Println(timeObj)
fmt.Println(timeObj.Sub(now))
```

### 获取整点的 Time 实例

比如，有这么个需求：获取当前时间整点的 `Time` 实例。例如，当前时间是 15:54:23，需要的是 15:00:00。我们可以这么做：

```go
t, _ := time.ParseInLocation("2006-01-02 15:04:05", time.Now().Format("2006-01-02 15:00:00"), time.Local)
fmt.Println(t)
```

实际上，`time` 包给我们提供了专门的方法，功能更强大，性能也更好，这就是 **`Round` 和 `Trunate`**，它们区别，一个是取最接近的，一个是向下取整。

使用示例：

```go
t, _ := time.ParseInLocation("2006-01-02 15:04:05", "2016-06-13 15:34:39", time.Local)
// 整点（向下取整）
fmt.Println(t.Truncate(1 * time.Hour))
// 整点（最接近）
fmt.Println(t.Round(1 * time.Hour))

// 整分（向下取整）
fmt.Println(t.Truncate(1 * time.Minute))
// 整分（最接近）
fmt.Println(t.Round(1 * time.Minute))

t2, _ := time.ParseInLocation("2006-01-02 15:04:05", t.Format("2006-01-02 15:00:00"), time.Local)
fmt.Println(t2)
```

## 时区

不同国家（有时甚至是同一个国家内的不同地区）使用不同的时区。对于要输入和输出时间的程序来说，必须对系统所处的时区加以考虑。Go 语言使用 `Location` 来表示地区相关的时区，一个 Location 可能表示多个时区。

`time` 包提供了 Location 的两个实例：`Local` 和 `UTC`。`Local` 代表当前系统本地时区；`UTC` 代表通用协调时间，也就是零时区。`time` 包默认（为显示提供时区）使用 `UTC` 时区。

### Local 如何表示本地时区？

时区信息既浩繁又多变，Unix 系统以标准格式存于文件中，这些文件位于 /usr/share/zoneinfo，而本地时区可以通过 /etc/localtime 获取，这是一个符号链接，指向 /usr/share/zoneinfo 中某一个时区。如：/usr/share/zoneinfo/Asia/Shanghai。

因此，在初始化 Local 时，通过读取 /etc/localtime 可以获取到系统本地时区。

当然，如果设置了环境变量 `TZ`，则会优先使用它。

相关代码：

```go
tz, ok := syscall.Getenv("TZ")
switch {
case !ok:
    z, err := loadZoneFile("", "/etc/localtime")
    if err == nil {
        localLoc = *z
        localLoc.name = "Local"
        return
    }
case tz != "" && tz != "UTC":
    if z, err := loadLocation(tz); err == nil {
        localLoc = *z
        return
    }
}
```

###  获得特定时区的实例

函数 `LoadLocation` 可以根据名称获取特定时区的实例。

函数声明如下：

```go
func LoadLocation(name string) (*Location, error)
```

如果 name 是 "" 或 "UTC"，返回 UTC；如果 name 是 "Local"，返回 Local；否则 name 应该是 IANA 时区数据库里有记录的地点名（该数据库记录了地点和对应的时区），如 "America/New_York"。

LoadLocation 函数需要的时区数据库可能不是所有系统都提供，特别是非 Unix 系统。此时 `LoadLocation` 会查找环境变量 ZONEINFO 指定目录或解压该变量指定的 zip 文件（如果有该环境变量）；然后查找 Unix 系统的惯例时区数据安装位置，最后查找 `$GOROOT/lib/time/zoneinfo.zip`。

可以在 Unix 系统下的 /usr/share/zoneinfo 中找到所有的名称。

> 通常，我们使用 `time.Local` 即可，偶尔可能会需要使用 `UTC`。在解析时间时，心中一定记得有时区这么回事。当你发现时间出现莫名的情况时，很可能是因为时区的问题，特别是当时间相差 8 小时时。

### 其他方法

#### `time.Sleep()`

```go
func Sleep(d Duration)
```

例：

```go
// Calling Sleep method 
time.Sleep(8 * time.Second) 

// Printed after sleep is over 
fmt.Println("Sleep Over.....") 
```

