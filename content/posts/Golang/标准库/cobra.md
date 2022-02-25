# cobra

cobra既是一个用于创建强大现代 CLI 应用程序的库，也是一个生成应用程序和命令文件的程序。cobra 被用在很多 go 语言的项目中，比如 Kubernetes、Docker、Istio、ETCD、Hugo、Github CLI 等等

## 概念

cobra 中有个重要的概念，分别是 commands、arguments 和 flags。

- commands 代表行为
- arguments 就是命令行参数 (或者称为位置参数)
- flags 代表对行为的改变 (也就是常说的命令行选项)。

执行命令行程序时的一般格式为：

```shell
APPNAME COMMAND ARG --FLAG
```

比如下面的例子：

```shell
# server是 commands，port 是 flag
hugo server --port=1313

# clone 是 commands，URL 是 arguments，brae 是 flag
git clone URL --bare
```

如果是一个简单的程序 (功能单一的程序)，使用 commands 的方式可能会很啰嗦，但是像 git、docker 等应用，把这些本就很复杂的功能划分为子命令的形式，会方便使用 (对程序的设计者来说又何尝不是如此)。

## 创建 cobra 应用

安装 cobra 包：

```shell
$ go get -u github.com/spf13/cobra/cobra
```

然后就可以用 cobra 程序生成应用程序框架了：

```shell
$ cobra init <appname>
```

此时的程序并没有什么功能，执行它只会输出一些默认的提示信息

cobra 推荐的项目结构如下：

```text
+ cmd/
    root.go
    add.go
    your.go
    commands.go
    here.go
  main.go
```

所有命令放在项目根目录下的 cmd 目录中。其中，默认命令（即不输入任何命令）为 root.go

cobra 应用的 main.go 非常简单，通常如下：

```go
package main

import (
    "{pathToYourApp}/cmd"
)

func main() {
    cmd.Execute()
}
```

## **创建 rootCmd**

root.go的内容如下：

```go
package cmd

import (
    "fmt"
    "os"

    "github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
    Use:   "demo",
    Short: "A cobra demo",
    Long:  `A cobra demo. xxx...`,
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println("execute root cmd.")
    },
}

func Execute() {
    if err := rootCmd.Execute(); err != nil {
        fmt.Fprintln(os.Stderr, err)
        os.Exit(1)
    }
}
```

此时，执行 `go run main.go --help`，可以看到以下输出：

```go
A cobra demo. xxx...

Usage:
  demo [flags]

Flags:
  -h, --help   help for demo
```

直接执行 `go run main.go` 会打印 `execute root cmd.`。

## **创建其他命令**

我们再创建一个 `print` 命令。一般每个命令在 `cmd` 下都有一个自己的文件。只需要在 `cmd` 下再新建一个 `print.go`，内容如下：

```go
package cmd

import (
    "fmt"

    "github.com/spf13/cobra"
)

func init() {
    rootCmd.AddCommand(printCmd)
}

var printCmd = &cobra.Command{
    Use:   "print",
    Short: "print something",
    Long:  "print something, xxx",
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println("execute print cmd")
    },
}
```

此时再执行 `go run main.go --help` 可以看到已经增加了 `print` 命令：

```text
A cobra demo. xxx...

Usage:
  demo [flags]
  demo [command]

Available Commands:
  help    Help about any command
  print       print something

Flags:
  -h, --help   help for demo

Use "demo [command] --help" for more information about a command.
```

## **创建 flag**

在执行 `print` 命令时，我们想传递一些参数，来指定打印的内容，这时我们就需要增加 flags。

flags 分为 `persistent flag` 和 `local flags`。`persistent flag` 可以分配给当前命令及其所有子命令，而`local flags` 只应用于当前命令。

这里给 `print` 命令增加一个 `local flags`：

```go
package cmd

import (
    "fmt"

    "github.com/spf13/cobra"
)

func init() {
    rootCmd.AddCommand(printCmd)

    printCmd.Flags().StringVarP(&Msg, "message", "m", "default message", "message to be printed")
}

var Msg string
var printCmd = &cobra.Command{
    Use:   "print",
    Short: "print something",
    Long:  "print something, xxx",
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println(Msg)
    },
}
```

这时再使用 `go run main.go print` 会打印默认内容`default message`，也可以使用 `-m` 或 `--message` 来指定要打印的内容了。