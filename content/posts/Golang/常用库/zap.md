---
title: "Go zap 库"
date: 2023-02-17
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# zap

> https://github.com/uber-go/zap

Go 中快速、结构化、分级的日志记录。

在许多 Go 语言项目中，我们需要一个好的日志记录器能够提供下面这些功能：

- 能够将事件记录到文件中，而不是应用程序控制台。
- 日志切割 - 能够根据文件大小、时间或间隔等来切割日志文件。
- 支持不同的日志级别。例如 INFO，DEBUG，ERROR 等。
- 能够打印基本信息，如调用文件 / 函数名和行号，日志时间等。

## 快速开始

### 安装

```shell
go get -u go.uber.org/zap
```

### 默认的 Go Logger

在介绍 Uber-go 的 zap 包之前，让我们先看看 Go 语言提供的基本日志功能。

Go 语言提供的默认日志包是 [golang.org/pkg/log/](https://golang.org/pkg/log/)

实现一个 Go 语言中的日志记录器非常简单：创建一个新的日志文件，然后设置它为日志的输出位置

```go
package main

import (
    "log"
    "os"
)

func initGoLogger()  {
  locatonPath := "/Users/codehope/remote-es-server-code/zap-demo/test.log"
    locationLoggerFile, _ := os.OpenFile(locatonPath,os.O_CREATE|os.O_APPEND|os.O_RDWR,0744)
    log.SetOutput(locationLoggerFile)
}
func main()  {
    initGoLogger()
    log.Printf("info %s","message")
}
```

当我们执行上面的代码，我们能看到一个 `test.log` 文件被创建，下面的内容会被添加到这个日志文件中

```log
2021/11/02 14:08:43 info message
```

**优势**

- 它最大的优点是使用非常简单。我们可以设置任何 io.Writer 作为日志记录输出并向其发送要写入的日志。

**劣势**

- 仅限基本的日志级别
- 只有一个 Print 选项。不支持 INFO/DEBUG 等多个级别。
- 对于错误日志，它有 Fatal 和 Panic
    - Fatal 日志通过调用 os.Exit (1) 来结束程序
    - Panic 日志在写入日志消息之后抛出一个 panic
    - 但是它缺少一个 ERROR 日志级别，这个级别可以在不抛出 panic 或退出程序的情况下而记录错误
        缺乏日志格式化的能力，例如记录调用者的函数名和行号，格式化日期和时间格式。等等。
- 不提供日志切割的能力。

### 示例

In contexts where performance is nice, but not critical, use the `SugaredLogger`. It's 4-10x faster than other structured logging packages and includes both structured and `printf`-style APIs.

```go
logger, _ := zap.NewProduction()
defer logger.Sync() // flushes buffer, if any
sugar := logger.Sugar()
sugar.Infow("failed to fetch URL",
  // Structured context as loosely typed key-value pairs.
  "url", url,
  "attempt", 3,
  "backoff", time.Second,
)
sugar.Infof("Failed to fetch URL: %s", url)
```

When performance and type safety are critical, use the `Logger`. It's even faster than the `SugaredLogger` and allocates far less, but it only supports structured logging.

```go
logger, _ := zap.NewProduction()
defer logger.Sync()
logger.Info("failed to fetch URL",
  // Structured context as strongly typed Field values.
  zap.String("url", url),
  zap.Int("attempt", 3),
  zap.Duration("backoff", time.Second),
)
```

## 创建 logger

Zap 提供了两种类型的日志记录器 — `Sugared Logger` 和 `Logger`

在性能很好但不是很关键的上下文中，使用 SugaredLogger：它比其他结构化日志记录包快 4-10 倍，并且支持结构化和 printf 风格的日志记录。

在每一微秒和每一次内存分配都很重要的上下文中，使用 Logger：它甚至比 SugaredLogger 更快，内存分配次数也更少，但它只支持强类型的结构化日志记录。

### 创建 Logger

通过调用` zap.NewProduction()` /` zap.NewDevelopment()` 或者 `zap.Example()` 创建一个 Logger。

上面的每一个函数都将创建一个 logger。唯一的区别在于它将记录的信息不同。例如 production logger 默认记录调用函数信息、日期和时间等。

通过 Logger 调用 Info/Error 等。

默认情况下日志都会打印到应用程序的 console 界面。

```go
package main

import (
    "go.uber.org/zap"
    "net/http"
)

var logger *zap.Logger 

func simpleHttpGet(url string) {
    resp, err := http.Get(url)
    if err != nil {
        logger.Error(
            "Error fetching url..",
            zap.String("url", url),
            zap.Error(err))
    } else {
        logger.Info("Success..",
            zap.String("statusCode", resp.Status),
            zap.String("url", url))
        err := resp.Body.Close()
        if err != nil {
            return
        }
    }
}
func main()  {
    logger, _ = zap.NewProduction()
    simpleHttpGet("https://www.baidu.com")
    simpleHttpGet("https://www.google.com")
}
```

测试执行输出结果：

```json
{"level":"info","ts":1635834613.299716,"caller":"zap-demo/main.go:23","msg":"Success..","statusCode":"200 OK","url":"https://www.baidu.com"}

{"level":"error","ts":1635834643.3006458,"caller":"zap-demo/main.go:18","msg":"Error fetching url..","url":"https://www.google.com","error":"Get \"https://www.google.com\": dial tcp 185.45.6.103:443: i/o timeout","stacktrace":"main.simpleHttpGet\n\t/Users/codehope/remote-es-server-code/zap-demo/main.go:18\nmain.main\n\t/Users/codehope/remote-es-server-code/zap-demo/main.go:38\nruntime.main\n\t/usr/local/go/src/runtime/proc.go:255"}
```

### 创建  Sugared Logger

现在让我们使用 Sugared Logger 来实现相同的功能。

大部分的实现基本都相同，惟一的区别是，我们通过调用主 logger 的 `Sugar()` 方法来获取一个 `SugaredLogger`。

然后使用 `SugaredLogger` 来 printf 格式记录语句

```go
package main

import (
  "go.uber.org/zap"
  "net/http"
)

var sluggerLogger *zap.SugaredLogger
/*
    simpleHttpGet 带有日志的http请求
*/
func simpleHttpGet(url string) {
    resp, err := http.Get(url)
    if err != nil {
        sluggerLogger.Errorf(
            "Error fetching url..,url = %s,err= %d",
            url,
            err)
    } else {
        sluggerLogger.Infof("Success..,statusCode=%s.url=%s",
            resp.Status,
            url)
        err := resp.Body.Close()
        if err != nil {
            return
        }
    }
}
func main()  {
    logger, _ := zap.NewProduction()
    sluggerLogger = logger.Sugar()
    simpleHttpGet("https://www.baidu.com")
}
```

当你执行上面的代码会得到如下输出：

```json
{
  "level":"info",
  "ts":1635835735.4530501,
  "caller":"zap-demo/sugerLoger.go:20",
  "msg":"Success..,statusCode=200 OK.url=https://www.baidu.com"
}
```

## 定制 logger

### 将日志写入文件而不是终端

> 我们要做的第一个更改是把日志写入文件，而不是打印到应用程序控制台。

我们将使用 `zap.New()` 方法来手动传递所有配置，而不是使用像 `zap.NewProduction()` 这样的预置方法来创建 logger

```go
func New(core zapcore.Core, options ...Option) *Logger
```

zapcore.Core 需要三个配置:

- Encoder 编码器 (如何写入日志)

    - 我们将使用开箱即用的 `NewJSONEncoder()`，并使用预先设置的 `ProductionEncoderConfig()`

    - ```go
        zapcore.NewJSONEncoder(zap.NewProductionEncoderConfig())
        ```

- `WriteSyncer` 指定日志将写到哪里去

    - 我们使用 `zapcore.AddSync()` 函数并且将打开的文件句柄传进去

    - ```go
        file, _ := os.Create("./test.log")
        writeSyncer := zapcore.AddSync(file)
        ```

- `LogLevel` 哪种级别的日志将被写入

    - ```go
        package main
        
        import (
            "fmt"
            "go.uber.org/zap"
            "go.uber.org/zap/zapcore"
            "os"
        )
        
        /*
            setJSONEncoder 设置logger编码
        */
        func setJSONEncoder() zapcore.Encoder {
            return zapcore.NewJSONEncoder(zap.NewProductionEncoderConfig())
        }
        
        /*
            setLoggerWrite 设置logger写入文件
        */
        func setLoggerWrite() zapcore.WriteSyncer {
            create, err := os.OpenFile("./test.log", os.O_CREATE|os.O_APPEND|os.O_RDWR, 0755)
            if err != nil {
                fmt.Println(err)
            }
            return zapcore.AddSync(create)
        }
        
        func main() {
            var logger *zap.SugaredLogger
            core := zapcore.NewCore(setJSONEncoder(), setLoggerWrite(), zap.InfoLevel)
            logger = zap.New(core).Sugar()
            for i := 0; i < 10; i++ {
                logger.Infof("Info%d", i)
                logger.Errorf("Error%d", i)
                logger.Debugf("Debug%d", i)
                logger.Warnf("Warn%d", i)
            }
        }
        ```

        上面代码执行后，发现当前目录多了一个 test.log，发现只写入了 Info，Error，Warn 级别的 log，Debug 级别没有写入

        ```text
        {"level":"info","ts":1635837845.908652,"msg":"Info0"}
        {"level":"error","ts":1635837845.908742,"msg":"Error0"}
        {"level":"warn","ts":1635837845.9087548,"msg":"Warn0"}
        {"level":"info","ts":1635837845.9087648,"msg":"Info1"}
        {"level":"error","ts":1635837845.908774,"msg":"Error1"}
        {"level":"warn","ts":1635837845.9087832,"msg":"Warn1"}
        {"level":"info","ts":1635837845.908791,"msg":"Info2"}
        {"level":"error","ts":1635837845.908799,"msg":"Error2"}
        ...
        ```

### 将 JSON Encoder 更改为普通的 Log Encoder

现在，我们希望将编码器从 JSON Encoder 更改为普通 Encoder。

为此，我们需要将 `NewJSONEncoder()` 更改为 `NewConsoleEncoder()`

```go
/*
    setJSONEncoder 设置logger编码
*/
func setJSONEncoder() zapcore.Encoder {
    return zapcore.NewConsoleEncoder(zap.NewProductionEncoderConfig())
}
```

当使用这些修改过的 logger 配置调用上述部分的 main () 函数时，以下输出将打印在文件 ——test.log 中。

```text
1.635838141476396e+09    info    Info0
1.635838141476515e+09    error    Error0
1.6358381414765272e+09    warn    Warn0
1.635838141476535e+09    info    Info1
1.635838141476552e+09    error    Error1
1.6358381414765608e+09    warn    Warn1
...
```

### 更改编码（格式化时间，日志级别大写）

鉴于我们对配置所做的更改，有下面问题：

- 时间是以非人类可读的方式展示，例如 1.572161051846623e+09

我们要做的第一件事是覆盖默认的 `ProductionConfig()`，并进行以下更改:

- 修改时间编码器
- 在日志文件中使用大写字母记录日志级别

```go
/*
    setJSONEncoder 设置logger编码
*/

func setJSONEncoder() zapcore.Encoder {
    encoderConfig := zap.NewProductionEncoderConfig()
    encoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder // 转换编码的时间戳
    encoderConfig.EncodeLevel = zapcore.CapitalLevelEncoder // 编码级别调整为大写的级别输出
    return zapcore.NewConsoleEncoder(encoderConfig)
}
```

修改编码配置后，重新执行后，test.log 的内容：可以看到时间也被调整了，日志级别的格式也都为大写

```text
2021-11-02T15:33:46.712+0800    INFO    Info0
2021-11-02T15:33:46.712+0800    ERROR    Error0
2021-11-02T15:33:46.712+0800    WARN    Warn0
2021-11-02T15:33:46.712+0800    INFO    Info1
2021-11-02T15:33:46.712+0800    ERROR    Error1
2021-11-02T15:33:46.712+0800    WARN    Warn1
2021-11-02T15:33:46.712+0800    INFO    Info2
...
```

### 添加调用者详细信息

我们将修改 zap logger 代码，添加将调用函数信息记录到日志中的功能。为此，我们将在 `zap.New()` 函数中添加一个 Option：

```go
zap.New(zapCore,zap.AddCaller()).Sugar()
```

执行后 test.log 的内容，加入了对应目录 / 文件 行数的日志信息

```text
2021-11-02T15:37:42.035+0800    INFO    zap-demo/customLogger.go:36    Info0
2021-11-02T15:37:42.035+0800    ERROR    zap-demo/customLogger.go:37    Error0
2021-11-02T15:37:42.035+0800    WARN    zap-demo/customLogger.go:39    Warn0
2021-11-02T15:37:42.035+0800    INFO    zap-demo/customLogger.go:36    Info1
2021-11-02T15:37:42.035+0800    ERROR    zap-demo/customLogger.go:37    Error1
2021-11-02T15:37:42.035+0800    WARN    zap-demo/customLogger.go:39    Warn1
2021-11-02T15:37:42.035+0800    INFO    zap-demo/customLogger.go:36    Info2
...
```

## 使用 Lumberjack 进行日志切割归档

Zap 本身不支持切割归档日志文件

为了添加日志切割归档功能，我们将使用第三方库 Lumberjack 来实现。

安装执行下面的命令安装 Lumberjack

```shell
go get -u github.com/natefinch/lumberjack
```

要在 zap 中加入 Lumberjack 支持，我们需要修改 `WriteSyncer` 代码。我们将按照下面的代码修改 `getLogWriter()` 函数：

```go
func setLoggerWrite() zapcore.WriteSyncer {
    //create, _ := os.OpenFile("./test.log",os.O_CREATE|os.O_APPEND|os.O_RDWR,0744)
    //create, err := os.OpenFile("./test.log", os.O_CREATE|os.O_APPEND|os.O_RDWR, 0755)
    //if err != nil {
    //    fmt.Println(err)
    //}
    l :=&lumberjack.Logger{
        Filename:"./test.log",  // Filename 是要写入日志的文件。
        MaxSize:    1, 			// MaxSize 是日志文件在轮换之前的最大大小（以兆字节为单位）。它默认为 100 兆字节
        MaxBackups: 1,			// MaxBackups 是要保留的最大旧日志文件数。默认是保留所有旧的日志文件（尽管 MaxAge 可能仍会导致它们被删除。）
        MaxAge:     30,			// MaxAge 是根据文件名中编码的时间戳保留旧日志文件的最大天数。
        Compress:   true,		// 压缩
        LocalTime: true, 		// LocalTime 确定用于格式化备份文件中的时间戳的时间是否是计算机的本地时间。默认是使用 UTC 时间。
    }
    return zapcore.AddSync(l)
}
```

