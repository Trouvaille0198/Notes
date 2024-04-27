---
title: "Go context 库源码分析"
date: 2022-02-07
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# context 源码分析

## 什么是 Context

Context 也叫作上下文，是一个比较抽象的概念，一般理解为程序单元的一个运行状态、现场、快照。其中上下是指存在上下层的传递，上会把内容传递给下，程序单元则指的是 Goroutine。

每个 Goroutine 在执行之前，都要先知道程序当前的执行状态，通常将这些执行状态封装在一个 Context 变量中，传递给要执行的 Goroutine 中。

**例如**：在网络编程下，当接收到一个网络请求 Request，在处理 Request 时，我们可能需要开启不同的 Goroutine 来获取数据与逻辑处理，即一个请求 Request，会在多个 Goroutine 中处理。

而这些 Goroutine 可能需要共享 Request 的一些信息，同时当 Request 被取消或者超时的时候，所有从这个 Request 创建的所有 Goroutine 也应该被结束。

context 包就是为了解决上面所说的这些问题而开发的：在 一组 goroutine 之间传递共享的值、取消信号、deadline……

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly9waWM0LnpoaW1nLmNvbS84MC92Mi04ZTcwNDE5Y2IwN2U5OWJkYTY1NmYyM2YzZWI3NWRjYl83MjB3LmpwZw)

源码很短，总共不到 500 行，其中还有很多大段的注释，代码可能也就 200 行左右的样子。这是一张整体结构图：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly9waWNiLnpoaW1nLmNvbS84MC92Mi01NGYzODk2NGM2NzE1Yjg1ZDZjODc4NTg3NDUxNGFkMV83MjB3LmpwZw" alt="在这里插入图片描述" style="zoom:67%;" />

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly9waWMzLnpoaW1nLmNvbS84MC92Mi02YTI3NTI2ZjUzNjUwNWNlYTA4YTU4MTNjY2NlMDViMl83MjB3LmpwZw)

## 快速入门

Context 包中定义了四个 With 系列函数。

### WithCancel

WithCancel 的函数签名如下：

```go
func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
```

WithCancel 返回带有新 Done 通道的父节点的副本，当调用返回的 cancel 函数或当关闭父上下文的 Done 通道时，将关闭返回上下文的 Done 通道，无论先发生什么情况。

取消此上下文将释放与其关联的资源，因此代码应该在此上下文中运行的操作完成后立即调用 cancel，示例代码如下：

```go
package main

import (
    "context"
    "fmt"
)

func main() {
    gen := func(ctx context.Context) <-chan int {
        dst := make(chan int)
        n := 1
        go func() {
            for {
                select {
                case <-ctx.Done():
                    return // return结束该goroutine，防止泄露
                case dst <- n:
                    n++
                }
            }
        }()
        return dst
    }

    ctx, cancel := context.WithCancel(context.Background())
    defer cancel() // 当我们取完需要的整数后调用cancel

    for n := range gen(ctx) {
        fmt.Println(n)
        if n == 5 {
            break
        }
    }
}
```

上面的代码中，gen 函数在单独的 Goroutine 中生成整数并将它们发送到返回的通道，gen 的调用者在使用生成的整数之后需要取消上下文，以免 gen 启动的内部 Goroutine 发生泄漏。

运行结果如下：

```
go run main.go
1
2
3
4
5
```

### WithDeadline

WithDeadline 的函数签名如下：

```go
func WithDeadline(parent Context, deadline time.Time) (Context, CancelFunc)
```

WithDeadline 函数会返回父上下文的副本，并将 deadline 调整为不迟于 d。

如果父上下文的 deadline 已经早于 d，则 `WithDeadline(parent, d)` 在语义上等同于父上下文。

当截止日过期时，当调用返回的 cancel 函数时，或者当父上下文的 Done 通道关闭时，返回上下文的 Done 通道将被关闭，以最先发生的情况为准。

取消此上下文将释放与其关联的资源，因此代码应该在此上下文中运行的操作完成后立即调用 cancel，示例代码如下：

```go
package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    d := time.Now().Add(50 * time.Millisecond)
    ctx, cancel := context.WithDeadline(context.Background(), d)

    // 尽管ctx会过期，但在任何情况下调用它的cancel函数都是很好的实践。
    // 如果不这样做，可能会使上下文及其父类存活的时间超过必要的时间。
    defer cancel()

    select {
    case <-time.After(1 * time.Second):
        fmt.Println("overslept")
    case <-ctx.Done():
        fmt.Println(ctx.Err())
    }
}
```

运行结果如下：

```
go run main.go
context deadline exceeded
```

上面的代码中，定义了一个 50 毫秒之后过期的 deadline，然后我们调用 `context.WithDeadline(context.Background(), d)` 得到一个上下文（ctx）和一个取消函数（cancel），然后使用一个 select 让主程序陷入等待，等待 1 秒后打印 overslept 退出或者等待 ctx 过期后退出。因为 ctx 50 秒后就过期，所以 `ctx.Done()` 会先接收到值，然后打印 `ctx.Err()` 取消原因。

### WithTimeout

WithTimeout 的函数签名如下：

```go
func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
```

WithTimeout 函数返回 `WithDeadline(parent, time.Now().Add(timeout))`。

取消此上下文将释放与其相关的资源，因此代码应该在此上下文中运行的操作完成后立即调用 cancel，示例代码如下：

```go
package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    // 传递带有超时的上下文
    // 告诉阻塞函数在超时结束后应该放弃其工作。
    ctx, cancel := context.WithTimeout(context.Background(), 50*time.Millisecond)
    defer cancel()

    select {
    case <-time.After(1 * time.Second):
        fmt.Println("overslept")
    case <-ctx.Done():
        fmt.Println(ctx.Err()) // 终端输出"context deadline exceeded"
    }
}
```

运行结果如下：

```
go run main.go
context deadline exceeded
```

### WithValue

WithValue 函数能够将请求作用域的数据与 Context 对象建立关系。函数声明如下：

```go
func WithValue(parent Context, key, val interface{}) Context
```

WithValue 函数接收 context 并返回派生的 context，其中值 val 与 key 关联，并通过 context 树与 context 一起传递。这意味着一旦获得带有值的 context，从中派生的任何 context 都会获得此值。

不建议使用 context 值传递关键参数，函数应接收签名中的那些值，使其显式化。

所提供的键必须是可比较的，并且不应该是 string 类型或任何其他内置类型，以避免使用上下文在包之间发生冲突。WithValue 的用户应该为键定义自己的类型，为了避免在分配给接口 `{ } ` 时进行分配，上下文键通常具有具体类型 `struct{}`。或者，导出的上下文关键变量的静态类型应该是指针或接口。

```go
package main

import (
    "context"
    "fmt"
)

func main() {
    type favContextKey string // 定义一个key类型
    // f:一个从上下文中根据key取value的函数
    f := func(ctx context.Context, k favContextKey) {
        if v := ctx.Value(k); v != nil {
            fmt.Println("found value:", v)
            return
        }
        fmt.Println("key not found:", k)
    }
    k := favContextKey("language")
    // 创建一个携带key为k，value为"Go"的上下文
    ctx := context.WithValue(context.Background(), k, "Go")

    f(ctx, k)
    f(ctx, favContextKey("color"))
}
```

运行结果如下：

```
go run main.go
found value: Go
key not found: color
```

使用 Context 的注意事项：

- 不要把 Context 放在结构体中，要以参数的方式显示传递；
- 以 Context 作为参数的函数方法，应该把 Context 作为第一个参数；
- 给一个函数方法传递 Context 的时候，不要传递 nil，如果不知道传递什么，就使用 context.TODO；
- Context 的 Value 相关方法应该传递请求域的必要数据，不应该用于传递可选参数；
- Context 是线程安全的，可以放心的在多个 Goroutine 中传递。

## 接口

### Context

Context 包的核心就是 Context 接口，其定义如下：

```go
type Context interface {
    Deadline() (deadline time.Time, ok bool)
    Done() <-chan struct{}
    Err() error
    Value(key interface{}) interface{}
}
```

定义的 4 个方法都是幂等的。也就是说连续多次调用同一个方法，得到的结果都是相同的。

- Deadline 返回 context 完成工作**截止时间**
    - 通过此时间，函数就可以决定是否进行接下来的操作，如果时间太短，就可以不往下做了，否则浪费系统资源。当然，也可以用这个 deadline 来设置一个 I/O 操作的超时时间。
- Done 方法需要返回一个**只读**的 Channel，可以表示 `context` 被取消的信号
    - 注意，这是一个只读的 channel。 我们又知道，读一个关闭的 channel 会读出相应类型的零值。并且源码里没有地方会向这个 `channel` 里面塞入值。换句话说，这是一个 `receive-only` 的 channel。因此在子协程里读这个 channel，除非被关闭，否则读不出来任何东西。也正是利用了这一点，子协程从 `channel` 里读出了值（零值）后，就可以做一些收尾工作，尽快退出。
- Err 方法会返回当前 Context 结束的原因，它只会在 Done 返回的 Channel 被关闭时才会返回非空的值，否则返回 `nil`
    - 如果当前 Context 被**取消**就会返回 Canceled 错误；
    - 如果当前 Context **超时**就会返回 DeadlineExceeded 错误；
- Value 方法会从 Context 中返回**预设的键对应的值**
    - 对于同一个上下文来说，多次调用 Value 并传入相同的 Key 会返回相同的结果，该方法仅用于传递跨 API 和进程间跟请求域的数据。

### canceler

```go
type canceler interface {
    cancel(removeFromParent bool, err error)
    Done() <-chan struct{}
}
```

实现了上面定义的两个方法的 Context，就表明该 Context 是**可取消的**。

源码中有两个类型实现了 canceler 接口：`*cancelCtx` 和 `*timerCtx`。注意是加了 * 号的，是这两个结构体的指针实现了 canceler 接口。

Context 接口设计成这个样子的原因：

- “取消”操作应该是建议性，而非强制性
    - caller 不应该去关心、干涉 callee 的情况，决定如何以及何时 return 是 callee 的责任。caller 只需发送“取消”信息，callee 根据收到的信息来做进一步的决策，因此接口并没有定义 cancel 方法。

- “取消”操作应该可传递
    - “取消”某个函数时，和它相关联的其他函数也应该“取消”。因此，Done() 方法返回一个只读的 channel，所有相关函数监听此 channel。一旦 channel 关闭，通过 channel 的“广播机制”，所有监听者都能收到。

## 结构体

### emptyCtx

源码中定义了 `Context` 接口后，并且给出了一个实现：

```go
type emptyCtx int

func (*emptyCtx) Deadline() (deadline time.Time, ok bool) {
    return
}

func (*emptyCtx) Done() <-chan struct{} {
    return nil // 读之将阻塞
}

func (*emptyCtx) Err() error {
    return nil
}

func (*emptyCtx) Value(key interface{}) interface{} {
    return nil
}
```

看这段源码，非常 happy。因为每个函数都实现的异常简单，要么是直接返回，要么是返回 nil。

所以，这实际上是一个空的 context，永远不会被 cancel，没有存储值，也没有 deadline。

它被包装成：

```go
var (
    background = new(emptyCtx) // 本质是一个指针
    todo       = new(emptyCtx)
)
```

通过下面两个导出的函数（首字母大写）对外公开：

```go
func Background() Context {
    return background
}

func TODO() Context {
    return todo
}
```

background 通常用在 main 函数中，作为所有 context 的**根节点**。

todo 通常用在并不知道传递什么 context 的情形。

例如，调用一个需要传递 context 参数的函数，你手头并没有其他 context 可以传递，这时就可以传递 todo。这常常发生在重构进行中，给一些函数添加了一个 Context 参数，但不知道要传什么，就用 todo “占个位子”，最终要换成其他 context。

### cancelCtx

再来看一个重要的 context：

```go
type cancelCtx struct {
    Context

    // 保护之后的字段
    mu       sync.Mutex
    done     chan struct{}
    children map[canceler]struct{}
    err      error
}
```

这是一个可以取消的 Context，实现了 canceler 接口。它直接将接口 Context 作为它的一个匿名字段，这样，它就可以被看成一个 Context。

#### Done()

先来看 `Done()` 方法的实现：

```go
func (c *cancelCtx) Done() <-chan struct{} {
    c.mu.Lock()
    if c.done == nil {
        c.done = make(chan struct{})
    }
    d := c.done
    c.mu.Unlock()
    return d
}
```

`c.done` 是“懒汉式”创建，只有调用了 `Done()` 方法的时候才会被创建。再次说明，函数返回的是一个只读的 channel，而且没有地方向这个 channel 里面写数据。所以，直接调用读这个 `channel`，协程会被 block 住。**一般通过搭配 select 来使用**。一旦关闭，就会立即读出零值。

`Err()` 和 `String()` 方法比较简单，不多说。推荐看源码，非常简单。

#### cancel()

接下来，我们重点关注 `cancel()` 方法的实现：

```go
func (c *cancelCtx) cancel(removeFromParent bool, err error) {
    // 必须要传 err
    if err == nil {
        panic("context: internal error: missing cancel error")
    }
    
    c.mu.Lock()
    if c.err != nil {
        c.mu.Unlock()
        return // 已经被其他协程取消
    }
    // 给 err 字段赋值
    c.err = err
    // 关闭 channel，通知其他协程
    if c.done == nil {
        c.done = closedchan
    } else {
        close(c.done)
    }

    // 遍历它的所有子节点
    for child := range c.children {
        // 递归地取消所有子节点
        child.cancel(false, err)
    }
    // 将子节点置空
    c.children = nil
    c.mu.Unlock()

    if removeFromParent {
        // 从父节点中移除自己 
        removeChild(c.Context, c)
    }
}
```

总体来看，`cancel()` 方法的功能就是：

1. 关闭 c.done 这个 channel；
2. 递归地取消它的所有子节点；
3. 从父节点从删除自己。

达到的效果是通过关闭 channel，将取消信号传递给了它的所有子节点。goroutine 接收到取消信号的方式就是 select 语句中的读 `c.done` 被选中。

我们再来看创建一个可取消的 Context 的方法：

```go
func WithCancel(parent Context) (ctx Context, cancel CancelFunc) {
    c := newCancelCtx(parent)
    propagateCancel(parent, &c)
    return &c, func() { c.cancel(true, Canceled) }
}

func newCancelCtx(parent Context) cancelCtx {
    return cancelCtx{Context: parent}
}
```

这是一个暴露给用户的方法，传入一个父 Context（这通常是一个 background，作为根节点），返回新建的 context，新 context 的 done channel 是新建的（前文讲过）。

当 WithCancel 函数返回的 CancelFunc 被调用或者是父节点的 done channel 被关闭（父节点的 CancelFunc 被调用），此 context（子节点） 的 done channel 也会被关闭。

注意传给 WithCancel 方法的参数，前者是 true，也就是说取消的时候，需要将自己从父节点里删除。第二个参数则是一个固定的取消错误类型：

```go
var Canceled = errors.New("context canceled")
```

还注意到一点，cancel 方法中递归地调用子节点 cancel 方法的时候，传入的第一个参数 `removeFromParent` 是 false。

两个问题需要回答：

1. 什么时候会传 true？
2. 为什么有时传 true，有时传 false？

当 `removeFromParent` 为 true 时，会将当前节点的 context 从父节点 context 中删除：

```go
func removeChild(parent Context, child canceler) {
    p, ok := parentCancelCtx(parent)
    if !ok {
        return
    }
    p.mu.Lock()
    if p.children != nil {
        delete(p.children, child) // 最关键的一行
    }
    p.mu.Unlock()
}

```

什么时候会传 true 呢？答案是调用 `WithCancel()` 方法的时候，也就是新创建一个可取消的 context 节点时，返回的 cancelFunc 函数会传入 true。这样做的结果是：当调用返回的 cancelFunc 时，会将这个 context 从它的父节点里“除名”，因为父节点可能有很多子节点，你自己取消了，所以我要和你断绝关系，对其他人没影响。

在取消函数内部，我知道，我所有的子节点都会因为我的一 `c.children = nil` 而化为灰烬。我自然就没有必要再多做这一步，最后我所有的子节点都会和我断绝关系，没必要一个个做。另外，如果遍历子节点的时候，调用 child.cancel 函数传了 true，还会造成同时遍历和删除一个 map 的境地，会有问题的。

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/aHR0cHM6Ly9waWMxLnpoaW1nLmNvbS84MC92Mi1mN2VhMGIwYmFlYzY4YjcxOGE1MTQ0MTk2MzZlODc1Yl83MjB3LmpwZw)

如上图，代表一棵 context 树。当调用左图中标红 context 的 cancel 方法后，该 context 从它的父 context 中去除掉了：实线箭头变成了虚线。且虚线圈框出来的 context 都被取消了，圈内的 context 间的父子关系都荡然无存了。

重点看 `propagateCancel()`：

```go
func propagateCancel(parent Context, child canceler) {
    // 父节点是个空节点
    if parent.Done() == nil {
        return // parent is never canceled
    }
    // 找到可以取消的父 context
    if p, ok := parentCancelCtx(parent); ok {
        p.mu.Lock()
        if p.err != nil {
            // 父节点已经被取消了，本节点（子节点）也要取消
            child.cancel(false, p.err)
        } else {
            // 父节点未取消
            if p.children == nil {
                p.children = make(map[canceler]struct{})
            }
            // "挂到"父节点上
            p.children[child] = struct{}{}
        }
        p.mu.Unlock()
    } else {
        // 如果没有找到可取消的父 context。新启动一个协程监控父节点或子节点取消信号
        go func() {
            select {
            case <-parent.Done():
                child.cancel(false, parent.Err())
            case <-child.Done():
            }
        }()
    }
}
```

这个方法的作用就是**向上寻找可以“挂靠”的“可取消”的 context，并且将 child “挂靠”上去**。这样，调用上层 cancel 方法的时候，就可以层层传递，将那些挂靠的子 context 同时“取消”。

这里着重解释下为什么会有 else 描述的情况发生。else 是指当前节点 context 没有向上找到可以取消的父节点，那么就要再启动一个协程监控父节点或者子节点的取消动作。

这里就有疑问了，既然没找到可以取消的父节点，那 `case <-parent.Done()` 这个 case 就永远不会发生，所以可以忽略这个 case；而 `case <-child.Done()` 这个 case 又啥事不干。那这个 else 不就多余了吗？

其实不然。我们来看 `parentCancelCtx` 的代码：

```go
func parentCancelCtx(parent Context) (*cancelCtx, bool) {
    for {
        switch c := parent.(type) {
        case *cancelCtx:
            return c, true
        case *timerCtx:
            return &c.cancelCtx, true
        case *valueCtx:
            parent = c.Context
        default:
            return nil, false
        }
    }
}
```

这里只会识别三种 Context 类型：`*cancelCtx`，`*timerCtx`，`*valueCtx`。若是把 `Context` 内嵌到一个类型里，就识别不出来了。

else 这段代码说明，如果把 ctx 强行塞进一个结构体，并用它作为父节点，调用 WithCancel 函数构建子节点 context 的时候，Go 会新启动一个协程来监控取消信号，明显有点浪费嘛。

再来说一下，select 语句里的两个 case 其实都不能删。

```go
select {
    case <-parent.Done():
        child.cancel(false, parent.Err())
    case <-child.Done():
}
```

第一个 case 说明当父节点取消，则取消子节点。如果去掉这个 case，那么父节点取消的信号就不能传递到子节点。

第二个 case 是说如果子节点自己取消了，那就退出这个 select，父节点的取消信号就不用管了。如果去掉这个 case，那么很可能父节点一直不取消，这个 goroutine 就泄漏了。当然，如果父节点取消了，就会重复让子节点取消，不过，这也没什么影响嘛。

### timerCtx

timerCtx 基于 cancelCtx，只是多了一个 time.Timer 和一个 deadline。

**Timer 会在 deadline 到来时，自动取消 context。**

```go
type timerCtx struct {
    cancelCtx
    timer *time.Timer // Under cancelCtx.mu.

    deadline time.Time
}
```

timerCtx 首先是一个 cancelCtx，所以它能取消。看下 cancel() 方法：

```go
func (c *timerCtx) cancel(removeFromParent bool, err error) {
    // 直接调用 cancelCtx 的取消方法
    c.cancelCtx.cancel(false, err)
    if removeFromParent {
        // 从父节点中删除子节点
        removeChild(c.cancelCtx.Context, c)
    }
    c.mu.Lock()
    if c.timer != nil {
        // 关掉定时器，这样，在 deadline 到来时，不会再次取消
        c.timer.Stop()
        c.timer = nil
    }
    c.mu.Unlock()
}
```

创建 timerCtx 的方法：

```go
func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc) {
    return WithDeadline(parent, time.Now().Add(timeout))
}
```

`WithTimeout` 函数直接调用了 `WithDeadline`，传入的 `deadline` 是当前时间加上 `timeout` 的时间，也就是从现在开始再经过 `timeout` 时间就算超时。也就是说，`WithDeadline` 需要用的是绝对时间。重点来看它：

```go
func WithDeadline(parent Context, deadline time.Time) (Context, CancelFunc) {
    if cur, ok := parent.Deadline(); ok && cur.Before(deadline) {
        // 如果父节点 context 的 deadline 早于指定时间。直接构建一个可取消的 context。
        // 原因是一旦父节点超时，自动调用 cancel 函数，子节点也会随之取消。
        // 所以不用单独处理子节点的计时器时间到了之后，自动调用 cancel 函数
        return WithCancel(parent)
    }

    // 构建 timerCtx
    c := &timerCtx{
        cancelCtx: newCancelCtx(parent),
        deadline:  deadline,
    }
    // 挂靠到父节点上
    propagateCancel(parent, c)

    // 计算当前距离 deadline 的时间
    d := time.Until(deadline)
    if d <= 0 {
        // 直接取消
        c.cancel(true, DeadlineExceeded) // deadline has already passed
        return c, func() { c.cancel(true, Canceled) }
    }
    c.mu.Lock()
    defer c.mu.Unlock()
    if c.err == nil {
        // d 时间后，timer 会自动调用 cancel 函数。自动取消
        c.timer = time.AfterFunc(d, func() {
            c.cancel(true, DeadlineExceeded)
        })
    }
    return c, func() { c.cancel(true, Canceled) }
}
```

也就是说仍然要把子节点挂靠到父节点，一旦父节点取消了，会把取消信号向下传递到子节点，子节点随之取消。

有一个特殊情况是，如果要创建的这个子节点的 deadline 比父节点要晚，也就是说如果父节点是时间到自动取消，那么一定会取消这个子节点，导致子节点的 deadline 根本不起作用，因为子节点在 deadline 到来之前就已经被父节点取消了。

这个函数的最核心的一句是：

```go
c.timer = time.AfterFunc(d, func() {
    c.cancel(true, DeadlineExceeded)
})
```

c.timer 会在 d 时间间隔后，自动调用 cancel 函数，并且传入的错误就是 `DeadlineExceeded`：

```go
var DeadlineExceeded error = deadlineExceededError{}

type deadlineExceededError struct{}

func (deadlineExceededError) Error() string   { return "context deadline exceeded" }
```

也就是超时错误。

## 总结

Go 语言中的 Context 的主要作用还是**在多个 Goroutine 或者模块之间同步取消信号或者截止日期**，用于减少对资源的消耗和长时间占用，避免资源浪费，虽然传值也是它的功能之一，但是这个功能我们还是很少用到。

在真正使用传值的功能时我们也应该非常谨慎，不能将请求的所有参数都使用 Context 进行传递，这是一种非常差的设计，比较常见的使用场景是传递请求对应用户的认证令牌以及用于进行分布式追踪的请求 ID。