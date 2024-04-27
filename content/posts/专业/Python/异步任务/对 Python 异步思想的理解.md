---
title: "对 Python 异步思想的理解"
date: 2023-8-25
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# 对 Python 异步思想的理解

> 摘自 https://lulaoshi.info/python/asyncio/basics.html

1. 记住 asyncio 是一个事件循环

2. 记住在你不想阻塞其他任务的地方，await

每一次 await，函数会停止执行，但不会返回。他会把执行权交还给事件循环，让其他 async 函数执行。等待下次被重启。

## 函数调用 v.s. 协程调用

### 并行计算

计算机的 CPU 一次只做一件事。现代计算机配备了多个 CPU 核心，通过多线程（multi-threading）或者多进程（multi-processing）等方式来并行化，以充分利用多核。不同编程语言的实现也稍有不同，其中 Python 使用最多的是 `multiprocessing` 库。这些库的核心思想是让 Python 代码并行地在多个 CPU 核心上同时执行。

**但 asyncio 并不是传统意义上的多线程或多进程**

> asyncio 更像是操作系统中**并发**的概念：让多个函数交替占用单个 CPU 运行；
>
> 其他多线 / 进程库则是**并行**的概念：使用多核来同时运行多个函数

使用 asyncio 并不是将代码转换成多线程，它不会导致多条 Python 指令同时执行，也不会以任何方式让你避开所谓的全局解释器锁（Global Interpreter Lock，GIL）

> CPU bound v.s. IO bound
>
> CPU bound：有些应用受 CPU 速度的限制，并不需要频繁IO。很多传统高性能计算应用就是CPU bound的，例如，分子动力学模拟。
>
> IO bound：有些应用受 IO 速度的限制，即使 CPU 速度再快，也无法充分发挥 CPU 的性能。这些应用花费大量时间从存储或网络设备读写数据，往往需要等待数据到达后才能进行计算，在等待期间，CPU 什么都做不了。大数据和AI就是典型的 IO bound 应用。****

如果应用是 IO bound ，CPU 大量时间什么都做不了，单纯等待其他地方把数据准备好并搬运过来。其实，在 CPU 等待期间其实可以给它安排一些其他工作。 asyncio 的目的就是为了给 CPU 安排更多的工作：当前单线程代码正在等待某个事情发生时，另一段代码可以接管并使用 CPU，以充分利用 CPU 的计算性能。

**asyncio 更多是关于更有效地使用单核，而不是如何使用多核**

### 函数 v.s. 协程

> 许多编程语言使用术语“函数”（Function）或“方法”（Method）或“过程”(Procedure)或“子程序”(Subroutine)来表示可以被其他代码调用的一段代码。一些比较古老的编程语言，比如 Fortran，会使用 Subroutine 这个词，在 Python 中，主要使用“函数”（Function）或“方法”（Method）这两个概念。

大多数编程语言都有所谓的 **“子程序” (Subroutine) 调用模型**。父函数遇到一个子程序，开始调用该函数，进入到该函数的开头，然后一直执行，直到函数的结尾（或遇到 `return` 语句），返回到调用该函数的地方。所有对该函数的调用都遵循上面的这个流程：进入函数，从头开始，直到 `return` 结尾，返回父函数调用处。这种调用模型我们再熟悉不过了。

此外，还有另一种代码执行模型，称为 **“协程”（Coroutine）调用模型**。在这个调用模型中，被调用者可以 “**让出**” 控制权而不是运行完之后把整个函数都返回。当这个被调用的协程 “让出” 控制权时，调用他的父函数会立即返回到当初调用协程的的位置。但未来再次调用协程时，不会从头开始，而是从上一次该协程执行停止的地方继续执行。控制权在父函数和协程之间来回跳转，如下图所示：

![Subroutines v.s. Coroutines](http://aixingqiu-1258949597.cos.ap-beijing.myqcloud.com/2023-05-03-subroutines-coroutines.png)

在 Python 中就是 yield 语法了

### 函数调用栈

继续深入探究函数调用，大多数操作系统和编程语言都使用一种称为“调用栈”的抽象。调用栈是一个堆栈数据结构。

为了说明这一点，下面使用一段简单的 Python 代码来演示：

```python
def a_func(x):
    return x-2

def main():
    some_value = 12
    some_other_value = a_func(some_value)

main()
```

当我们开始执行这段代码时，堆栈被初始化为内存中一个后进先出 (Last In First Out) 存储区，整个函数从最后一行 `main()` 开始执行。

假设我们对这段 Python 代码进行了编译，得到下面这个编译后的代码段。每行有一个行号，用来记录程序运行到哪一行。同时有一个名为指令指针（Instruction Pointer，IP）的指针，指向下一步将要运行哪一行代码。

![程序刚开始：执行 main() 函数](http://aixingqiu-1258949597.cos.ap-beijing.myqcloud.com/2023-05-03-stack0.svg)

由于 `main()` 函数本身就是一个函数调用，Python 解释器会调用 `main()` 函数：

- Python 解释器将一个新的“**栈帧**”添加到堆栈的顶部。栈帧是一个数据结构，是为这个函数调用单独分配的栈空间。
- Python 解释器在栈帧的栈顶添加了一个“返回指针”（Return Point）。这是一个地址，它告诉解释器，当函数返回时，回到哪一行。
- Python 解释器根据 Instruction Pointer 中存的地址确定下一行将要执行什么。

![程序进入 main() 函数，开始执行 main() 函数中的内容](http://aixingqiu-1258949597.cos.ap-beijing.myqcloud.com/2023-05-03-stack1.svg)

下一条指令：`some_value = 12` 创建了一个局部变量，这个局部变量仅存在于这个 `main()` 函数的上下文，一旦离开 `main()` 函数，`some_value` 就不存在了。因此，局部变量 `some_value` 存储在 `main()` 栈帧中。

![执行 some_value = 12，在栈帧内创建局部变量](http://aixingqiu-1258949597.cos.ap-beijing.myqcloud.com/2023-05-03-stack2.svg)

下一条指令： `some_other_value = a_func(some_value)`。这又是一个函数调用，Python 解释器继续进行函数调用：

- 它将一个新栈帧添加到堆栈的顶部。
- 它添加了一个 Return Point，该指针指向 04。
- 这个函数调用传递了参数，参数被放置在栈帧的顶部（x = 12）。
- Instruction Pointer 设置为 01，`a_func` 是下一条要执行的指令。

![执行 some_other_value = a_func(some_value)，进行函数调用](http://aixingqiu-1258949597.cos.ap-beijing.myqcloud.com/2023-05-03-stack3.svg)

下一条要执行的指令是 `return x-2` ，这里面有 `return` ，Python 解释器执行从函数返回的过程。

- 它从堆栈中删除顶部栈帧，包括其中的所有内容。
- 它将函数的返回值放在栈顶。
- Instruction Pointer 设置为 04，即刚刚记录的 Return Point。

![执行 return x-2，从 a_func() 返回到 main()](http://aixingqiu-1258949597.cos.ap-beijing.myqcloud.com/2023-05-03-stack4.svg)

几乎所有编程语言的函数调用都遵循这种模式。多线程跟这种方式也很像，只不过每个线程都有一个单独的堆栈，除此之外几乎完全相同。

然而，说了这么多，都是关于传统的函数调用的。asyncio 的原理跟这种函数调用有很大不同。

### Event Loops/Tasks/Coroutines

在 asyncio 中，每个线程不再只有一个堆栈。相反，每个线程都有一个被称为事件循环（Event Loop）的对象。Event Loop 中包含一个任务（Task）对象列表。每个 Task 维护一个堆栈，以及它自己的 Instruction Pointer。

![Event Loop 有多个 Task，每个 Task 维护一个堆栈](http://aixingqiu-1258949597.cos.ap-beijing.myqcloud.com/2023-05-03-eventloop.svg)

在任意时刻，Event Loop 只能有一个 Task 实际执行，毕竟 CPU 在某一时刻只能做一件事，Event Loop 中的其他任务都暂停了。当前正在执行的 Task 跟我们经常使用的函数调用的 Python 程序一模一样。唯一区别在于，遇到需要等待的事情时接下来的处理方式，即当 Task 遇到需要等待的事情，比如 IO bound 应用需要等待数据到达。

此时，Task 中的代码不再等待，而是让出控制权。Event Loop 暂停正在运行的 Task。未来的某个时刻，当这个 Task 所等待的事情已经成熟，Event Loop 将再次唤醒这个 Task。

Task 让出控制权后，Event Loop 唤醒某个休眠的 Task，并将这个新唤醒的 Task 设置为当前执行的 Task。有一种可能，所有 Task 都无法被唤醒，因为所有 Task 都在等待自己所依赖的事情发生，那么 Event Loop 和所有 Task 一起等待。

通过这种方式，CPU 可以被不同的 Task 共享。Task 或者在执行自己的代码，或者在休眠，休眠期间等待自己所依赖的事情。

> Event Loop 不能中断正在执行的协程。
>
> Event Loop 不能强制中断当前正在执行的协程。当前正在执行的协程将继续执行，直到它让出控制权（比如 yield）。Event Loop 选择下一个被调度的协程，并跟踪这些协程的状态，例如哪些协程被阻塞且无法执行，直到某些 IO 完成。Event Loop 仅在当前没有协程正在执行时才执行去做这些跟踪状态的工作。

控制权在不同 Task 之间来回切换，下次唤醒 Task 时正好在上次停止的地方继续执行。这种方式被称为“协程调用”（Coroutine Calling）。这就是 Python asyncio 所提供的功能，它使得 CPU 闲置的时间更少。

这种调用方法适用于 IO bound 应用，在这类应用中，长时间的暂停是为了等待其他事情，比如某个应用请求一个 HTTP 网页，需要等待网页内容返回后才能进行下面的操作。有关 HTTP 或其他互联网流量的处理任务几乎都是 IO bound 的。

### 总结

- 异步（Asynchronous）编程：与传统的同步（Synchronous）编程相对应
    - 同步编程就是传统的函数调用的方式
    - 异步编程不需要等待事情完成，而是把控制权让出。
- 协程（Coroutine）：异步编程中的某个函数体。
- Event Loop：管理和控制协程。
- Task：某个可运行的任务。

## 编写 asyncio 代码

### async def 关键字

`async def` 是 asyncio 异步编程中最关键的关键字，它用来**声明一个异步协程函数**，就像用 `def` 定义一个普通的同步函数一样。

> 可以认为 async def 共同组成一个关键字
>
> 可以认为 `async def` 共同组成一个关键字。实际上， `async` 本身是一个关键字，但我们并不能单独使用 `async` 。所以，可以简单认为 `async def` 组合在一起，共同组成一个关键字。同样， `async for` 和 `async with` 也是两个单词共同组成的关键字。

下面的例子中我们定义了一个协程函数 `example_coroutine_function` 和一个普通函数 `example_function`。 `example_function` 的代码块是普通的同步 Python 代码，而`example_coroutine_function` 的代码块是异步 Python 代码，又被称为协程。

```python
async def example_coroutine_function(a, b):
    # 异步代码
    ...

def example_function(a, b):
    # 同步代码
    ...
```

> 提示
>
> - 我们**只**能在 `async def` 定义的协程函数体内编写异步 Python 代码。
> - 异步 Python 代码可以使用普通 Python 中允许的任何 Python 关键字、结构等。
> - 有几个只能在异步代码中使用的新关键字：`await`、`async with` 和 `async for`。

使用 `async def` 定义一个协程函数，这看起来与使用 `def` 的普通函数声明非常相似。大多数时候确实非常相似，但是有一些关键的区别，这对于异步编程非常重要：

#### def

`def` 定义一个同步函数，函数本身是一个 `Callable` 对象，调用这个函数的时候，函数体内的代码被执行。

```python
def example_function(a, b, c):
    ...
```

`example_function` 是一个 `Callable` 对象实例，这个函数接收 3 个参数，像这样调用它：

```python
r = example_function(1, 2, 3)
```

调用之后，`example_function` 会被立即执行，返回值会被赋值给 `r` 。

#### async def

`async def` 关键字也定义了一个 `Callable` 对象实例，但当我们调用这个函数时，函数体内代码**不是**立即执行。

```python
async def example_coroutine_function(a, b, c):
    ...
```

跟 `example_function` 类似，`example_coroutine_function` 也是一个 `Callable` 对象实例，它接受 3 个参数，通过下面的方式调用：

```python
r = example_coroutine_function(1, 2, 3)
```

但执行这行之后**不会**直接运行函数体内的代码块。相反，Python 创建了一个 `Coroutine` 对象实例，并将其分配给 `r`。要使代码块实际运行，需要使用 asyncio 提供的其他工具。最常见的是 `await` 关键字。接下来我们开始讨论 `await`。

### await 与 awaitable

`await` 是 asyncio 的最为核心的关键字之一。

- 它只能在异步代码块中使用，即在 `async def` 语句定义的协程代码块中。
- 它有一个参数，并且有一个返回值。

例如：

```python
r = example_coroutine_function(1, 2, 3)
s = await r
```

上面这行代码中，`r` 是一个 awaitable 对象。它用 `r = example_coroutine_function(1, 2, 3)` 定义。 执行 `s = await r` 这行代码，就将对 `r` 执行 `await` 操作并将返回值赋值给 `s`。

awaitable 对象，从名字中可以看出，这种对象是**可以被等待**的。

将刚才例子的两行整合成一行：

```python
s = await example_coroutine_function(1, 2, 3)
```

一个 `async def` + `await` 的完整的例子：

```python
import asyncio

async def add(x, y):
    return x + y

async def get_results():
    # 直接 print(add(3, 4)) 得到的是一个 coroutine object
    # 这个 coroutine object 是 awaitable 的
    # 而且还会提示：RuntimeWarning: coroutine 'add' was never awaited
    # 因为这个 awaitable 从来没被 await
    print(add(3, 4))

    # 打印出结果为 7
    print(await add(3, 4))

    res1 = await add(3, 4)
    res2 = await add(8, 5)
    # 打印出结果为 7 13
    print(res1, res2)

asyncio.run(get_results())
```

可以看到 `await` 在 `async def` 定义的协程 `get_results()` 里。直接 `print(add(3, 4))` 得到的是一个 Coroutine 对象，这个 coroutine 对象是 awaitable 可等待的。而且还会提示：RuntimeWarning: coroutine 'add' was never awaited，因为这个 awaitable 对象从来没被 await。 `print(await add(3, 4))` 可以打印出结果，先 `await` ，才能得到结果。

换个角度思考，**`await` 一个 coroutine object，有点像主动去调用一个传统意义上的同步函数。**这个 coroutine 对象里的代码段包含了异步的代码。

我们有说过，异步代码是以 Task 的形式去运行、被 Event Loop 管理和调度的，Task 可以被暂停和恢复，每个 Task 有自己调用栈。所以，虽然调用一个同步函数和 `await` 一个 coroutine 对象有点像，但是 coroutine 对象中的异步代码是可以被暂停和恢复的。这也是同步函数和异步函数的重要区别。

一共有三种可以被 `await` 的对象：

- coroutine 对象
    - 前面多个例子中的 `await r`， `r` 是一个 coroutine 对象。

- `asyncio.Future` 类对象
    - 如果 `await` 一个 `asyncio.Future` 对象，则当前 Task 被暂停。下文提到的 `asyncio.Task` 是一种继承了 `asyncio.Future` 的类。或者说，`asyncio.Future` 是提供了底层的 awaitable 接口。下文用 `Task` 指代 `asyncio.Task`，用 `Future` 指代 `asyncio.Future`。

- 实现了 `__await__` 方法的类和对象
    - 这种方法给一些包开发者提供了接口，开发者可以自己定义一些 awaitable 的类。

### 运行一个协程

刚才提到，`async def` 定义一个协程，协程跟普通函数区别是不会直接运行，如果想运行这个协程，可以使用 `asyncio.run`

用 `asyncio.run` 作为整个异步函数的入口。比如:

```python
async def main():
    print("hello")

asyncio.run(main())
```

- `await` coroutine 对象。

之前提到的类似的例子：

```python
async def hello():
    return "hello"

async def main():
    coro = hello()
    h = await coro
    print(h)
```

- `asyncio.create_task()`，创建一个 `Task` 对象实例，`Task` 对象实例立即被运行。

```python
async def hello():
    print("async function called")
    return "hello"

async def main():
    t = asyncio.create_task(hello())
    h = await t
    print(h)
```

这里的三个场景，第二种 `await` 的方式和第三种 `asyncio.create_task()` 看不出明显区别。我们需要加一个 `asyncio.sleep()` 可能才能看出一些区别。

### asyncio.sleep()

`asyncio.sleep()` 和 `time.sleep()` 很像。`asyncio.sleep()` 是 `asyncio` 库专用的，它跟其他协程函数一样，是**异步**的，或者说是**非阻塞**的。与之对应，`time.sleep()` 是**同步**的，或者说是**阻塞**的。

当 `time.sleep()` 被调用，整个程序都会暂停，什么都做不了。

当 `await asyncio.sleep()` 被调用，如果使用了 Event Loop，Event Loop 会将当前的 `asyncio.sleep()` 的协程暂停，Event Loop 去找其他可以被唤醒的 `Task`，先执行其他 `Task` 。当刚刚这个 `asyncio.sleep()` 满足了睡眠时间，Event Loop 把这个协程唤醒。

但在协程的场景，确实不容易理解这两种不同的 `sleep` 到底发生有什么区别。

下面用几个例子来演示 `asyncio.sleep()` 。

#### time.sleep()

```python
import asyncio
import time

async def call_api():
    print('Hello')
    time.sleep(3)
    print('World')

async def main():
    start = time.perf_counter()
    await asyncio.gather(call_api(), call_api())
    end = time.perf_counter()
    print(f'It took {end-start} second(s) to complete.')

asyncio.run(main())
```

得到的结果是：

```text
Hello
World
Hello
World
It took 6.006464317906648 second(s) to complete.
```

如果使用 `time.sleep()` ：先打印 Hello，等待 3 秒，再打印 World。一共执行了两次 `call_api()` ，两次 `call_api()` 都是相互阻塞，执行一共需要 6 秒多。

`call_api()` 内部经历了下面的过程：

- `print()`
- 休眠几秒
- 继续执行 `return result`

#### asyncio.sleep()

如果使用 `asyncio.sleep()`：

```python
import asyncio
import time

async def call_api():
    print('Hello')
    await asyncio.sleep(3)
    print('World')

async def main():
    start = time.perf_counter()
    await asyncio.gather(call_api(), call_api())
    end = time.perf_counter()
    print(f'It took {end-start} second(s) to complete.')

asyncio.run(main())
```

输出结果：

```text
Hello
Hello
World
World
It took 3.003517189063132 second(s) to complete.
```

改成 `asyncio.sleep()` 后：两次的 Hello 被马上打印出来，说明 `asyncio.sleep()` 没有阻塞程序执行，而是让多个协程并发执行，整个程序的总时间也仅用了 3 秒多。

两次 `call_api()` 和 `main` 内部经历了下面的过程：

- 第一个 `call_api()` 调用 `print()`
- 第一个进入休眠状态，Event Loop 唤醒第二个 `call_api()`

在这里用了 `asyncio.gather()` 的 API，它可以并发地运行协程，或者说**它可以将协程调度为 Task**。下面重点说说如何让协程调度为 Task。

### Task

#### 没有使用 Event Loop

```python
import asyncio
import time

async def call_api():
    print("Hello")
    await asyncio.sleep(3)
    print("World")

async def main():
    start = time.perf_counter()

    await call_api()
    await call_api()

    end = time.perf_counter()
    print(f'It took {end-start} second(s) to complete.')

asyncio.run(main())
```

输出结果：

```text
Hello
World
Hello
World
It took 6.005615991074592 second(s) to complete.
```

在这个例子中，直接创建了协程并通过 `await` 来等待协程执行结果，结果显示这个程序和普通的同步函数没有任何区别。主要原因是：这里其实没有将协程放到 Event Loop 中。或者说，虽然这里使用了 `async def` 和 `await` 关键字编写了异步的代码，但是依然像同步函数那样执行。

#### Task 与 Event Loop

异步程序与同步程序的区别在于：程序以 `Task` 的形式放到 Event Loop 中，Event Loop 管理多个 `Task`，唤醒某个 `Task` 或者暂停某个 `Task` 。

如何创建一个 `Task`，并将这个 `Task` 放到 Event Loop ？答案是用 `asyncio.create_task()` 。`asyncio.create_task()` 是一个比较直观的 API，其他的还有 `asyncio.gather()` 等。

把刚才的程序做一个简单的修改，`call_api()` 不变，只不过调用 `call_api()` 的方式变为使用 `asyncio.create_task()`。

输出结果为：

```text
Hello
Hello
World
World
It took 3.0035055382177234 second(s) to complete.
```

两次 Hello 几乎同时被打印出来，说明 `call_api()` 非阻塞执行。

在这个程序中，两个关键点：

- `task = asyncio.create_task()` 创建协程
    - `asyncio.create_task()` 将协程函数创建为 `Task`，函数的返回值是一个 `Task` 对象，所创建的 `Task` 被放到了 Event Loop 中。

- `await task` 等待 `Task` 执行结束
    - 如果不 `await task`，我们只看到了开头的 Hello，看不到结尾的 World。程序还没执行完，就退出了。

这里本质上是等待 `Task` 的 `done()` 方法返回 `True`。返回 `True` 说明 `Task` 执行结束。使用 `done()` 来判断 `Task` 是否结束的程序：

```python
import asyncio
import time

async def call_api():
    print("Hello")
    await asyncio.sleep(3)
    print("World")

async def main():
    start = time.perf_counter()

    task_1 = asyncio.create_task(
        call_api()
    )
    task_2 = asyncio.create_task(
        call_api()
    )

    tasks = [task_1, task_2]
    while True:
        # 检查所有 tasks 中哪些还没结束
        tasks = [t for t in tasks if not t.done()]
        if len(tasks) == 0:
            # 所有 tasks 都结束，tasks 数组为空，程序可以结束
            end = time.perf_counter()
            print(f'It took {end-start} second(s) to complete.')
            return
        # tasks 中有还没结束的 Task，使用 await 等待
        await tasks[0]

asyncio.run(main())
```