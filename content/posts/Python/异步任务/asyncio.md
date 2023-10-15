---

---

# asyncio

1. 协程是在单线程里实现任务的切换的
2. 利用同步的方式去实现异步
3. 不再需要锁，提高了并发性能

## 协程基础——yield

### yield 和 next

先把 yield 看做 return，它首先是个 return，

- 普通的 return，就是在程序中返回某个值，返回之后程序就**不再往下运行了**。

看做 return 之后再把它看做一个是生成器（generator）的一部分

```py
def foo():
    print("starting...")
    while True:
        res = yield 4
        print("res:",res)
g = foo()
print(next(g))
print("*"*20)
print(next(g))
```

输出

```sh
starting...
4
********************
res: None
4
```

1. 程序开始执行以后，因为 foo 函数中有 yield 关键字，所以 foo 函数并不会真的执行，而是先得到一个生成器 g(相当于一个对象)

2. 直到调用 next 方法，foo 函数正式开始执行，先执行 foo 函数中的 print 方法，然后进入 while 循环

3. 程序遇到 yield 关键字，然后把 yield 想想成 return,return 了一个 4 之后，程序停止，并没有执行赋值给 res 操作，此时 next(g)语句执行完成，所以输出的前两行（第一个是 while 上面的 print 的结果,第二个是 return 出的结果）是执行 print(next(g))的结果，

4. 程序执行 print("*"*20)，输出20个*

5. 又开始执行下面的 print(next(g)),这个时候和上面那个差不多，不过不同的是，这个时候是从刚才那个 next 程序停止的地方开始执行的，也就是要执行 res 的赋值操作，这时候要注意，这个时候赋值操作的右边是没有值的（因为刚才那个是 return 出去了，并没有给赋值操作的左边传参数），所以这个时候 res 赋值是 None,所以接着下面的输出就是 res:None,

6. 程序会继续在 while 里执行，又一次碰到 yield,这个时候同样 return 出 4，然后程序停止，print 函数输出的 4 就是这次 return 出的 4.

可以看出：

- 带 yield 的函数是一个生成器，而不是一个函数了
- 这个生成器有一个函数就是 next 函数，next 就相当于“下一步”生成哪个数，这一次的 next 开始的地方是接着上一次的 next 停止的地方执行的，所以调用 next 的时候，生成器并不会从 foo 函数的开始执行，只是接着上一步停止的地方开始，然后遇到 yield 后，return 出要生成的数，此步就结束。

### send

```python
def foo():
    print("starting...")
    while True:
        res = yield 4
        print("res:",res)
g = foo()
print(next(g))
print("*"*20)
print(g.send(7))
```

这个例子就把上面那个例子的最后一行换掉了，输出结果：

```sh
starting...
4
********************
res: 7
4
```

send 函数发送一个参数给 res。

上面的例子 return 的时候，并没有把 4 赋值给 res，下次执行的时候只好继续执行赋值操作，只好赋值为 None 了，而如果用 send 的话，开始执行的时候，先接着上一次（return 4 之后）执行，先把 7 赋值给了 res，然后执行 next，遇见下一回的 yield，return 出结果后结束。

5. 程序执行 g.send(7)，程序会从 yield 关键字那一行继续向下运行，send 会把 7 这个值赋值给 res 变量

6. 由于 **send 方法中包含 next() 方法**，所以程序会继续向下运行执行 print 方法，然后再次进入 while 循环

7. 程序执行再次遇到 yield 关键字，yield 会返回后面的值后，程序再次暂停，直到再次调用 next 方法或 send 方法。

### 抛出错误

当生成器运行到底后，将抛出 `StopIteration` 错误，若生成器有返回值，则返回值存储在异常对象的 value 属性中

```py
def coroutine_example(name):
    print('start coroutine...name:', name)

    while True:
        x = yield name # 调用next()时，产出yield右边的值后暂停；调用send()时，产出值赋给x，并往下运行
        if x is None:
            return 'zhihuID: Zarten'
        print('send值:', x)

coro = coroutine_example('Zarten')
next(coro)
print('send的返回值:', coro.send(6))
try:
    coro.send(None)
except StopIteration as e:
    print('返回值：', e.value)
```

### yield from

`yield from` 后面需要加的是可迭代对象，它可以是普通的可迭代对象，也可以是迭代器，甚至是生成器。

#### 简单应用：拼接可迭代对象

我们可以用一个使用 `yield` 和一个使用 `yield from` 的例子来对比看下。

使用 `yield`

```py
# 字符串
astr='ABC'
# 列表
alist=[1,2,3]
# 字典
adict={"name":"wangbm","age":18}
# 生成器
agen=(i for i in range(4,8))

def gen(*args, **kw):
    for item in args:
        for i in item:
            yield i

new_list=gen(astr, alist, adict, agen)
print(list(new_list))
# ['A', 'B', 'C', 1, 2, 3, 'name', 'age', 4, 5, 6, 7]
```

使用 `yield from`

```py
# 字符串
astr='ABC'
# 列表
alist=[1,2,3]
# 字典
adict={"name":"wangbm","age":18}
# 生成器
agen=(i for i in range(4,8))

def gen(*args, **kw):
    for item in args:
        yield from item

new_list=gen(astr, alist, adict, agen)
print(list(new_list))
# ['A', 'B', 'C', 1, 2, 3, 'name', 'age', 4, 5, 6, 7]
```

由上面两种方式对比，可以看出，**yield from 后面加上可迭代对象，他可以把可迭代对象里的每个元素一个一个地 yield 出来**，对比 yield 来说代码更加简洁，结构更加清晰。

#### 复杂应用：生成器的嵌套

如果你认为只是 `yield from` 仅仅只有上述的功能的话，那你就太小瞧了它，它的更强大的功能还在后面。

当 `yield from` 后面加上一个生成器后，就实现了**生成器的嵌套**。

> 当然实现生成器的嵌套，并不是一定必须要使用 `yield from`，而是使用 `yield from` 可以让我们避免让我们自己处理各种料想不到的异常，而让我们专注于业务代码的实现。

如果自己用 `yield` 去实现，那只会加大代码的编写难度，降低开发效率，降低代码的可读性。既然 Python 已经想得这么周到，我们当然要好好利用起来。

讲解它之前，首先要知道这个几个概念

1. `调用方`：调用委托生成器的客户端（调用方）代码 
2. `委托生成器`：包含 yield from 表达式的生成器函数
3. `子生成器`：yield from 后面加的生成器函数

以下这个例子，是实现实时计算平均值的。 比如，第一次传入 10，那返回平均数自然是 10. 第二次传入 20，那返回平均数是 (10+20)/2=15；第三次传入 30，那返回平均数 (10+20+30)/3=20

```py
# 子生成器
def average_gen():
    total = 0
    count = 0
    average = 0
    while True:
        new_num = yield average
        count += 1
        total += new_num
        average = total/count

# 委托生成器
def proxy_gen():
    while True:
        yield from average_gen()

# 调用方
def main():
    calc_average = proxy_gen()
    next(calc_average)            # 预激下生成器
    print(calc_average.send(10))  # 打印：10.0
    print(calc_average.send(20))  # 打印：15.0
    print(calc_average.send(30))  # 打印：20.0

if __name__ == '__main__':
    main()
```

认真阅读以上代码，应该很容易能理解，调用方、委托生成器、子生成器之间的关系。

**委托生成器的作用是**：在调用方与子生成器之间建立一个`双向通道`。

所谓的双向通道是什么意思呢？ 调用方可以通过 `send()` 直接发送消息给子生成器，而子生成器 yield 的值，也是直接返回给调用方。

你可能会经常看到有些代码，还可以在 `yield from` 前面看到可以赋值。这是什么用法？

你可能会以为，子生成器 yield 回来的值，被委托生成器给拦截了。事实上并没有。你可以亲自写个 demo 运行试验一下，并不是你想的那样。 因为我们之前说了，委托生成器，只起一个桥梁作用，它建立的是一个 `双向通道`，它并没有权利也没有办法，对子生成器 yield 回来的内容做拦截。

为了解释这个用法，我还是用上述的例子，并对其进行了一些改造。添加了一些注释，希望你能看得明白。

按照惯例，我们还是举个例子。

```py
# 子生成器
def average_gen():
    total = 0
    count = 0
    average = 0
    while True:
        new_num = yield average
        if new_num is None:
            break
        count += 1
        total += new_num
        average = total/count

    # 每一次return，都意味着当前协程结束。
    return total,count,average

# 委托生成器
def proxy_gen():
    while True:
        # 只有子生成器要结束（return）了，yield from左边的变量才会被赋值，后面的代码才会执行。
        total, count, average = yield from average_gen()
        print("计算完毕！！\n总共传入 {} 个数值， 总和：{}，平均数：{}".format(count, total, average))

# 调用方
def main():
    calc_average = proxy_gen()
    next(calc_average)            # 预激协程
    print(calc_average.send(10))  # 打印：10.0
    print(calc_average.send(20))  # 打印：15.0
    print(calc_average.send(30))  # 打印：20.0
    calc_average.send(None)      # 结束协程
    # 如果此处再调用calc_average.send(10)，由于上一协程已经结束，将重开一协程

if __name__ == '__main__':
    main()
```

运行后，输出

```text
10.0
15.0
20.0
计算完毕！！
总共传入 3 个数值， 总和：60，平均数：20.0
```

也就是说，当子生成器结束后抛出的 `StopIteration` 错误会被委托生成器接住，并且 `yield from` 左边的值会附上子生成器的返回值

如果我们去掉委托生成器，而直接调用子生成器。那我们就需要把代码改成像下面这样，我们需要自己捕获异常并处理。而不像使 `yield from` 那样省心。

```py
# 子生成器
# 子生成器
def average_gen():
    total = 0
    count = 0
    average = 0
    while True:
        new_num = yield average
        if new_num is None:
            break
        count += 1
        total += new_num
        average = total/count
    return total,count,average

# 调用方
def main():
    calc_average = average_gen()
    next(calc_average)            # 预激协程
    print(calc_average.send(10))  # 打印：10.0
    print(calc_average.send(20))  # 打印：15.0
    print(calc_average.send(30))  # 打印：20.0

    # ----------------注意-----------------
    try:
        calc_average.send(None)
    except StopIteration as e:
        total, count, average = e.value
        print("计算完毕！！\n总共传入 {} 个数值， 总和：{}，平均数：{}".format(count, total, average))
    # ----------------注意-----------------

if __name__ == '__main__':
    main()
```

所以**委派生成器主要就是来捕获子生成器的错误用的**

不过委派生成器如果自身退出，那么它的 `StopIteration` 还是会在调用方这边抛出

## 异步 IO（asyncio）

`asyncio` 是 Python 3.4 版本引入的标准库，直接内置了对异步 IO 的支持。

在了解 `asyncio` 的使用方法前，首先有必要先介绍一下，这几个贯穿始终的概念。

- `event_loop` 事件循环：程序开启一个无限的循环，程序员会把一些函数（协程）注册到事件循环上。当满足事件发生的时候，调用相应的协程函数。
- `coroutine` 协程：协程对象，指一个使用 async 关键字定义的函数，它的调用不会立即执行函数，而是会返回一个协程对象。协程对象需要注册到事件循环，由事件循环调用。
- `future` 对象： 代表将来执行或没有执行的任务的结果。它和 task 上没有本质的区别
- `task` 任务：一个协程对象就是一个原生可以挂起的函数，任务则是对协程进一步封装，其中包含任务的各种状态。Task 对象是 Future 的子类，它将 coroutine 和 Future 联系在一起，将 coroutine 封装成一个 Future 对象。
- `async/await` 关键字：python3.5 用于定义协程的关键字，async 定义一个协程，await 用于挂起阻塞的异步调用接口。其作用在一定程度上类似于 yield。

```text
@asyncio.coroutine -> async
yield from -> await
```

### 协程是如何工作的

协程完整的工作流程是这样的

- 定义/创建协程对象
- 将协程转为 task 任务
- 定义事件循环对象容器
- 将 task 任务扔进事件循环对象中触发

```py
import asyncio

async def hello(name):
    print('Hello,', name)

# 定义协程对象
coroutine = hello("World")

# 定义事件循环对象容器
loop = asyncio.get_event_loop()
# task = asyncio.ensure_future(coroutine)

# 将协程转为task任务
task = loop.create_task(coroutine)

# 将task任务扔进事件循环对象中并触发
loop.run_until_complete(task)
```

输出结果显而易见

```text
Hello, World
```

也将一个生成器，直接变成协程使用

```py
import asyncio
from collections.abc import Generator, Coroutine

'''
只要在一个生成器函数头部用上 @asyncio.coroutine 装饰器
就能将这个函数对象，【标记】为协程对象。注意这里是【标记】，划重点。
实际上，它的本质还是一个生成器。
标记后，它实际上已经可以当成协程使用。后面会介绍。
'''


@asyncio.coroutine
def hello():
    # 异步调用asyncio.sleep(1):
    yield from asyncio.sleep(1)


if __name__ == '__main__':
    coroutine = hello()
    print(isinstance(coroutine, Generator))  # True
    print(isinstance(coroutine, Coroutine))  # False
```

### await 与 yield 对比

前面我们说，`await` 用于挂起阻塞的异步调用接口。其作用在一定程度上类似于 yield。

注意这里是，一定程度上，意思是效果上一样（都能实现暂停的效果），但是功能上却不兼容。就是你不能在生成器中使用 `await`，也不能在 async 定义的协程中使用 `yield from`。

除此之外呢，还有一点很重要的。

- `yield from` 后面可接可迭代对象，也可接 future 对象 / 协程对象；
- `await` 后面必须要接 future 对象 / 协程对象

### 绑定回调函数

异步 IO 的实现原理，就是在 IO 高的地方挂起，等 IO 结束后，再继续执行。在绝大部分时候，我们后续的代码的执行是需要依赖 IO 的返回值的，这就要用到回调了。

回调的实现，有两种，一种是绝大部分程序员喜欢的，利用的同步编程实现的回调。 这就要求我们要能够有办法取得协程的 await 的返回值。

```py
import asyncio
import time

async def _sleep(x):
    time.sleep(2)
    return '暂停了{}秒！'.format(x)


coroutine = _sleep(2)
loop = asyncio.get_event_loop()

task = asyncio.ensure_future(coroutine)
loop.run_until_complete(task)

# task.result() 可以取得返回结果
print('返回结果：{}'.format(task.result()))
```

输出

```text
返回结果：暂停了2秒！
```

还有一种是通过 asyncio 自带的添加回调函数功能来实现。

```py
import time
import asyncio


async def _sleep(x):
    time.sleep(2)
    return '暂停了{}秒！'.format(x)

def callback(future):
    print('这里是回调函数，获取返回结果是：', future.result())

coroutine = _sleep(2)
loop = asyncio.get_event_loop()
task = asyncio.ensure_future(coroutine)

# 添加回调函数
task.add_done_callback(callback)

loop.run_until_complete(task)
```

输出

```text
这里是回调函数，获取返回结果是： 暂停了2秒！
```

### 协程中的并发

协程的并发，和线程一样。举个例子来说，就好像一个人同时吃三个馒头，咬了第一个馒头一口，就得等这口咽下去，才能去啃第其他两个馒头。就这样交替换着吃。

`asyncio` 实现并发，就需要多个协程来完成任务，每当有任务阻塞的时候就 await，然后其他协程继续工作。

第一步，当然是创建多个协程的列表。

```py
# 协程函数
async def do_some_work(x):
    print('Waiting: ', x)
    await asyncio.sleep(x)
    return 'Done after {}s'.format(x)

# 协程对象
coroutine1 = do_some_work(1)
coroutine2 = do_some_work(2)
coroutine3 = do_some_work(4)

# 将协程转成task，并组成list
tasks = [
    asyncio.ensure_future(coroutine1),
    asyncio.ensure_future(coroutine2),
    asyncio.ensure_future(coroutine3)
]
```

第二步，如何将这些协程注册到事件循环中呢。

有两种方法，至于这两种方法什么区别，稍后会介绍。

- 使用 `asyncio.wait()`

```py
loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.wait(tasks))
```

- 使用 `asyncio.gather()`

```py
# 千万注意，这里的 「*」 不能省略
loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.gather(*tasks))
```

最后，return 的结果，可以用 `task.result()` 查看。

```py
for task in tasks:
    print('Task ret: ', task.result())
```

完整代码如下

```py
import asyncio

# 协程函数
async def do_some_work(x):
    print('Waiting: ', x)
    await asyncio.sleep(x)
    return 'Done after {}s'.format(x)

# 协程对象
coroutine1 = do_some_work(1)
coroutine2 = do_some_work(2)
coroutine3 = do_some_work(4)

# 将协程转成task，并组成list
tasks = [
    asyncio.ensure_future(coroutine1),
    asyncio.ensure_future(coroutine2),
    asyncio.ensure_future(coroutine3)
]

loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.wait(tasks))

for task in tasks:
    print('Task ret: ', task.result())
```

输出结果

```sh
Waiting:  1
Waiting:  2
Waiting:  4
Task ret:  Done after 1s
Task ret:  Done after 2s
Task ret:  Done after 4s
```

### 协程中的嵌套

使用 async 可以定义协程，协程用于耗时的 io 操作，我们也可以封装更多的 io 操作过程，这样就实现了嵌套的协程，即一个协程中 await 了另外一个协程，如此连接起来。

来看个例子。

```py
import asyncio

# 用于内部的协程函数
async def do_some_work(x):
    print('Waiting: ', x)
    await asyncio.sleep(x)
    return 'Done after {}s'.format(x)

# 外部的协程函数
async def main():
    # 创建三个协程对象
    coroutine1 = do_some_work(1)
    coroutine2 = do_some_work(2)
    coroutine3 = do_some_work(4)

    # 将协程转为task，并组成list
    tasks = [
        asyncio.ensure_future(coroutine1),
        asyncio.ensure_future(coroutine2),
        asyncio.ensure_future(coroutine3)
    ]

    # 【重点】：await 一个task列表（协程）
    # dones：表示已经完成的任务
    # pendings：表示未完成的任务
    dones, pendings = await asyncio.wait(tasks)

    for task in dones:
        print('Task ret: ', task.result())

loop = asyncio.get_event_loop()
loop.run_until_complete(main())
```

如果这边，使用的是 `asyncio.gather()`，是这么用的

```py
# 注意这边返回结果，与await不一样

results = await asyncio.gather(*tasks)
for result in results:
    print('Task ret: ', result)
```

输出还是一样的。

```text
Waiting:  1
Waiting:  2
Waiting:  4
Task ret:  Done after 1s
Task ret:  Done after 2s
Task ret:  Done after 4s
```

仔细查看，可以发现这个例子完全是由 上面「`协程中的并发`」例子改编而来。结果完全一样。只是把创建协程对象，转换 task 任务，封装成在一个协程函数里而已。外部的协程，嵌套了一个内部的协程。

其实你如果去看下 `asyncio.await()` 的源码的话，你会发现下面这种写法

```py
loop.run_until_complete(asyncio.wait(tasks))
```

看似没有嵌套，实际上内部也是嵌套的。

### 协程中的状态

还记得我们在讲生成器的时候，有提及过生成器的状态。同样，在协程这里，我们也了解一下协程（准确的说，应该是 Future 对象，或者 Task 任务）有哪些状态。

1. `Pending`：创建 future，还未执行
2. `Running`：事件循环正在调用执行任务
3. `Done`：任务执行完毕
4. `Cancelled`：Task 被取消后的状态

```py
import asyncio
import threading
import time

async def hello():
    print("Running in the loop...")
    flag = 0
    while flag < 1000:
        with open("F:\\test.txt", "a") as f:
            f.write("------")
        flag += 1
    print("Stop the loop")

if __name__ == '__main__':
    coroutine = hello()
    loop = asyncio.get_event_loop()
    task = loop.create_task(coroutine)

    # Pending：未执行状态
    print(task)
    try:
        t1 = threading.Thread(target=loop.run_until_complete, args=(task,))
        # t1.daemon = True
        t1.start()

        # Running：运行中状态
        time.sleep(1)
        print(task)
        t1.join()
    except KeyboardInterrupt as e:
        # 取消任务
        task.cancel()
        # Cacelled：取消任务
        print(task)
    finally:
        print(task)
```

顺利执行的话，将会打印 `Pending` -> `Pending：Runing` -> `Finished` 的状态变化

假如，执行后 立马按下 Ctrl+C，则会触发 task 取消，就会打印 `Pending` -> `Cancelling` -> `Cancelling` 的状态变化。

###  gather 与 wait

还记得上面我说，把多个协程注册进一个事件循环中有两种方法吗？

- 使用 `asyncio.wait()`

```py
loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.wait(tasks))
```

- 使用 `asyncio.gather()`

```py
# 千万注意，这里的 「*」 不能省略
loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.gather(*tasks))
```

`asyncio.gather` 和 `asyncio.wait` 在 asyncio 中用得的比较广泛，这里有必要好好研究下这两货。

还是照例用例子来说明，先定义一个协程函数

```py
import asyncio

async def factorial(name, number):
    f = 1
    for i in range(2, number+1):
        print("Task %s: Compute factorial(%s)..." % (name, i))
        await asyncio.sleep(1)
        f *= i
    print("Task %s: factorial(%s) = %s" % (name, number, f))
```

#### 接收参数方式

##### asyncio.wait

接收的 tasks，必须是一个 list 对象，这个 list 对象里，存放多个的 task。

它可以这样，用 `asyncio.ensure_future` 转为 task 对象

```py
tasks=[
       asyncio.ensure_future(factorial("A", 2)),
       asyncio.ensure_future(factorial("B", 3)),
       asyncio.ensure_future(factorial("C", 4))
]

loop = asyncio.get_event_loop()

loop.run_until_complete(asyncio.wait(tasks))
```

也可以这样，不转为 task 对象。

```py
loop = asyncio.get_event_loop()

tasks=[
       factorial("A", 2),
       factorial("B", 3),
       factorial("C", 4)
]

loop.run_until_complete(asyncio.wait(tasks))
```

##### asyncio.gather

接收的就比较广泛了，他可以接收 list 对象，但是 `*` 不能省略

```py
tasks=[
       asyncio.ensure_future(factorial("A", 2)),
       asyncio.ensure_future(factorial("B", 3)),
       asyncio.ensure_future(factorial("C", 4))
]

loop = asyncio.get_event_loop()

loop.run_until_complete(asyncio.gather(*tasks))
```

还可以这样，和上面的 `*` 作用一致，这是因为 `asyncio.gather()` 的第一个参数是 `*coros_or_futures`，它叫 `非命名键值可变长参数列表`，可以集合所有没有命名的变量。

```py
loop = asyncio.get_event_loop()

loop.run_until_complete(asyncio.gather(
    factorial("A", 2),
    factorial("B", 3),
    factorial("C", 4),
))
```

甚至还可以这样

```py
loop = asyncio.get_event_loop()

group1 = asyncio.gather(*[factorial("A" ,i) for i in range(1, 3)])
group2 = asyncio.gather(*[factorial("B", i) for i in range(1, 5)])
group3 = asyncio.gather(*[factorial("B", i) for i in range(1, 7)])

loop.run_until_complete(asyncio.gather(group1, group2, group3))
```

#### 返回结果不同

##### asyncio.wait

`asyncio.wait` 返回 `dones` 和 `pendings`

- `dones`：表示已经完成的任务
- `pendings`：表示未完成的任务

如果我们需要获取，运行结果，需要手工去收集获取。

```py
dones, pendings = await asyncio.wait(tasks)

for task in dones:
    print('Task ret: ', task.result())
```

##### asyncio.gather

`asyncio.gather` 它会把值直接返回给我们，不需要手工去收集。

```py
results = await asyncio.gather(*tasks)

for result in results:
    print('Task ret: ', result)
```

#### wait 有控制功能

```py
import asyncio
import random


async def coro(tag):
    await asyncio.sleep(random.uniform(0.5, 5))

loop = asyncio.get_event_loop()

tasks = [coro(i) for i in range(1, 11)]


# 【控制运行任务数】：运行第一个任务就返回
# FIRST_COMPLETED ：第一个任务完全返回
# FIRST_EXCEPTION：产生第一个异常返回
# ALL_COMPLETED：所有任务完成返回 （默认选项）
dones, pendings = loop.run_until_complete(
    asyncio.wait(tasks, return_when=asyncio.FIRST_COMPLETED))
print("第一次完成的任务数:", len(dones))


# 【控制时间】：运行一秒后，就返回
dones2, pendings2 = loop.run_until_complete(
    asyncio.wait(pendings, timeout=1))
print("第二次完成的任务数:", len(dones2))


# 【默认】：所有任务完成后返回
dones3, pendings3 = loop.run_until_complete(asyncio.wait(pendings2))

print("第三次完成的任务数:", len(dones3))

loop.close()
```

输出结果

```text
第一次完成的任务数: 1
第二次完成的任务数: 4
第三次完成的任务数: 5
```

## 其他

### 运行协程的选择

传统的 get_event_loop 与 run_until_complete

```python
import asyncio

async def coro_func(a):
    pass

loop = asyncio.get_event_loop()

loop.run_until_complete(asyncio.gather(
    coro_func("A"),
    coro_func("B"),
    coro_func("C"),
))
```

这种方法适用于底层代码的编写

> Application developers should typically use the high-level asyncio functions, such as [asyncio.run()](https://docs.python.org/3.7/library/asyncio-task.html#asyncio.run), and should rarely need to reference the loop object or call its methods. This section is intended mostly for authors of lower-level code, libraries, and frameworks, who need finer control over the event loop behavior.

`asyncio.run` 是对上面两个函数的集成，Python 3.7 开始提供

```python
import asyncio
import time

async def coro_func(a):
    pass

async def main():
    await asyncio.gather(
    	coro_func("A"),
    	coro_func("B"),
    	coro_func("C"),
	)

asyncio.run(main())
```

