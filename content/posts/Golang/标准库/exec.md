---
title: "os/exec"
date: 2022-06-22
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# os/exec

在 Golang 中用于执行命令的库是 `os/exec`

## 快速上手

exec.Command 函数返回一个 `Cmd` 对象，根据不同的需求，可以将命令的执行分为三种情况

1. 只执行命令，不获取结果
2. 执行命令，并获取结果（不区分 stdout 和 stderr）
3. 执行命令，并获取结果（区分 stdout 和 stderr）

### 第一种：只执行命令，不获取结果

直接调用 Cmd 对象的 Run 函数，返回的只有成功和失败，获取不到任何输出的结果。

```go
package main

import (
    "log"
    "os/exec"
)

func main() {
    cmd := exec.Command("ls", "-l", "/var/log/")
    err := cmd.Run()
    if err != nil {
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
}
```

一些用于执行的函数

- Run 阻塞进程，直到命令执行结束
- Start 非阻塞执行
- Wait 阻塞进程，等待命令执行结束, 与 Star 配合使用

### 第二种：执行命令，并获取结果

有时候我们执行一个命令就是想要获取输出结果，此时你可以调用 Cmd 的 CombinedOutput 函数。

```go
package main

import (
"fmt"
"log"
"os/exec"
)

func main() {
    cmd := exec.Command("ls", "-l", "/var/log/")
    out, err := cmd.CombinedOutput()
    if err != nil {
        fmt.Printf("combined out:\n%s\n", string(out))
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Printf("combined out:\n%s\n", string(out))
}
```

CombinedOutput 函数，只返回 out，并不区分 stdout 和 stderr。如果你想区分他们，可以直接看第三种方法。

```text
$ go run demo.go 
combined out:
total 11540876
-rw-r--r--  2 root       root         4096 Oct 29  2018 yum.log
drwx------  2 root       root           94 Nov  6 05:56 audit
-rw-r--r--  1 root       root    185249234 Nov 28  2019 message
-rw-r--r--  2 root       root        16374 Aug 28 10:13 boot.log
```

不过在那之前，我却发现一个小问题：有时候，shell 命令能执行，并不代码 exec 也能执行。

比如我只想查看 `/var/log/` 目录下的 log 后缀名的文件呢？有点 Linux 基础的同学，都会用这个命令

```text
$ ls -l /var/log/*.log
total 11540
-rw-r--r--  2 root       root         4096 Oct 29  2018 /var/log/yum.log
-rw-r--r--  2 root       root        16374 Aug 28 10:13 /var/log/boot.log
```

按照这个写法将它放入到 `exec.Command`

```go
package main

import (
"fmt"
"log"
"os/exec"
)

func main() {
    cmd := exec.Command("ls", "-l", "/var/log/*.log")
    out, err := cmd.CombinedOutput()
    if err != nil {
        fmt.Printf("combined out:\n%s\n", string(out))
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Printf("combined out:\n%s\n", string(out))
}
```

什么情况？居然不行，报错了。

```text
$ go run demo.go 
combined out:
ls: cannot access /var/log/*.log: No such file or directory

2020/11/11 19:46:00 cmd.Run() failed with exit status 2
exit status 1
```

为什么会报错呢？shell 明明没有问题啊

其实很简单，原来 `ls -l /var/log/*.log` 并不等价于下面这段代码。

```text
exec.Command("ls", "-l", "/var/log/*.log")
```

上面这段代码对应的 Shell 命令应该是下面这样，如果你这样子写，ls 就会把参数里的内容当成具体的文件名，而忽略通配符 `*`

```text
$ ls -l "/var/log/*.log"
ls: cannot access /var/log/*.log: No such file or directory
```

### 第三种：执行命令，并区分 stdout 和 stderr

上面的写法，无法实现区分标准输出和标准错误，只要换成下面种写法，就可以实现。

```go
package main

import (
    "bytes"
    "fmt"
    "log"
    "os/exec"
)

func main() {
    cmd := exec.Command("ls", "-l", "/var/log/*.log")
    var stdout, stderr bytes.Buffer
    cmd.Stdout = &stdout  // 标准输出
    cmd.Stderr = &stderr  // 标准错误
    err := cmd.Run()
    outStr, errStr := string(stdout.Bytes()), string(stderr.Bytes())
    fmt.Printf("out:\n%s\nerr:\n%s\n", outStr, errStr)
    if err != nil {
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
}
```

输出如下，可以看到前面的报错内容被归入到标准错误里

```text
$ go run demo.go 
out:

err:
ls: cannot access /var/log/*.log: No such file or directory

2020/11/11 19:59:31 cmd.Run() failed with exit status 2
exit status 1
```

### 第四种：多条命令组合，请使用管道

将上一条命令的执行输出结果，做为下一条命令的参数。在 Shell 中可以使用管道符 `|` 来实现。

比如下面这条命令，统计了 message 日志中 ERROR 日志的数量。

```text
$ grep ERROR /var/log/messages | wc -l
19
```

类似的，在 Golang 中也有类似的实现。

```go
package main
import (
    "os"
    "os/exec"
)
func main() {
    c1 := exec.Command("grep", "ERROR", "/var/log/messages")
    c2 := exec.Command("wc", "-l")
    c2.Stdin, _ = c1.StdoutPipe()
    c2.Stdout = os.Stdout
    _ = c2.Start()
    _ = c1.Run()
    _ = c2.Wait()
}
```

输出如下

```text
$ go run demo.go 
19
```

### 第五种：设置命令级别的环境变量

使用 os 库的 Setenv 函数来设置的环境变量，是作用于整个进程的生命周期

```go
package main
import (
    "fmt"
    "log"
    "os"
    "os/exec"
)
func main() {
    os.Setenv("NAME", "wangbm")
    cmd := exec.Command("echo", os.ExpandEnv("$NAME"))
    out, err := cmd.CombinedOutput()
    if err != nil {
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Printf("%s", out)
}
```

只要在这个进程里，`NAME` 这个变量的值都会是 `wangbm`，无论你执行多少次命令

```ps1con
$ go run demo.go 
wangbm
```

如果想把环境变量的作用范围再缩小到命令级别，也是有办法的。

为了方便验证，我新建个 sh 脚本，内容如下

```ps1con
$ cat /home/wangbm/demo.sh
echo $NAME
$ bash /home/wangbm/demo.sh   # 由于全局环境变量中没有 NAME，所以无输出
```

另外，demo.go 里的代码如下

```go
package main
import (
    "fmt"
    "os"
    "os/exec"
)


func ChangeYourCmdEnvironment(cmd * exec.Cmd) error {
    env := os.Environ()
    cmdEnv := []string{}

    for _, e := range env {
        cmdEnv = append(cmdEnv, e)
    }
    cmdEnv = append(cmdEnv, "NAME=wangbm")
    cmd.Env = cmdEnv

    return nil
}

func main() {
    cmd1 := exec.Command("bash", "/home/wangbm/demo.sh")
  ChangeYourCmdEnvironment(cmd1) // 添加环境变量到 cmd1 命令: NAME=wangbm
    out1, _ := cmd1.CombinedOutput()
    fmt.Printf("output: %s", out1)

    cmd2 := exec.Command("bash", "/home/wangbm/demo.sh")
    out2, _ := cmd2.CombinedOutput()
    fmt.Printf("output: %s", out2)
}
```

执行后，可以看到第二次执行的命令，是没有输出 NAME 的变量值。

```ps1con
$ go run demo.go 
output: wangbm
output: 
```