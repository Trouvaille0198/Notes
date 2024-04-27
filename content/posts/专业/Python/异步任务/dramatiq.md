---
title: "Python dramatiq 库"
date: 2023-8-1
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# dramatiq

> 官方文档：https://dramatiq.io/

一个简单的分布式任务队列库

Dramatiq 主要遵循以下原则:

- 高可用性和高性能
- 简单并且易于理解的核心
- 约定大于配置

如果你曾经对使用 Celery 感到过心烦意乱，那么 Dramatiq 会成为你的好工具的。

```py
import dramatiq
import requests


@dramatiq.actor
def count_words(url):
     response = requests.get(url)
     count = len(response.text.split(" "))
     print(f"There are {count} words at {url!r}.")


# Synchronously count the words on example.com in the current process
count_words("http://example.com")

# or send the actor a message so that it may perform the count
# later, in a separate process.
count_words.send("http://example.com")
```

## 安装

If you want to use it with [RabbitMQ](https://www.rabbitmq.com/):

```sh
$ pip install -U 'dramatiq[rabbitmq, watch]'
```

Or if you want to use it with [Redis](https://redis.io/):

```sh
$ pip install -U 'dramatiq[redis, watch]'
```

## 快速入门

### Actors

To turn this into a function that can be processed asynchronously using Dramatiq, all we have to do is decorate it with [`actor`](https://dramatiq.io/reference.html#dramatiq.actor):

使用 actor 装饰器修饰函数，来达成异步的目的

```py
import dramatiq

@dramatiq.actor
def add(a, b):
    print(a + b)
```

使用 send 方法来异步地调用这个被修饰的函数，以开头的 `count_words` 为例

```python
>>> count_words.send("http://example.com")
Message(
  queue_name='default',
  actor_name='count_words',
  args=('http://example.com',), kwargs={}, options={},
  message_id='8cdcae57-af36-40ba-9616-849a336a4316',
  message_timestamp=1498557015410)
```

Doing so immediately enqueues a message (via our local RabbitMQ server) that can be processed asynchronously but *doesn’t actually run the function*. In order to run it, we’ll have to boot up a Dramatiq worker.

这样做会立即向消息中间件 Broker 中插入一条可以被异步处理的消息，但是函数并没有立即被运行，我们需要启动一个 Dramatiq worker 来运行这个函数。

> Because all messages have to be sent over the network, any arguments you send to an actor must be **JSON-encodable**.

### Workers

Dramatiq 自带一个命令行工具，称为 `dramatiq`。该工具能够启动多个并发的 worker 进程，从队列中获取消息并将其发送到 actor  函数以进行执行。

使用 `dramatiq` 命令行工具来生成解决 actors 的 workers

To spawn workers for our `count_words.py` example, run the following command in a new terminal window:

```sh
dramatiq count_words
```

This will spin up as many processes as there are CPU cores on your machine with 8 worker threads per process. Run `dramatiq -h` if you want to see a list of the available command line flags.

As soon as you run that command you’ll see log output along these lines:

```sh
[2017-11-19 13:03:48,188] [PID 13047] [MainThread] [dramatiq.MainProcess] [INFO] Dramatiq '0.13.1' is booting up.
[2017-11-19 13:03:48,349] [PID 22377] [MainThread] [dramatiq.WorkerProcess(3)] [INFO] Worker process is ready for action.
[2017-11-19 13:03:48,350] [PID 22375] [MainThread] [dramatiq.WorkerProcess(1)] [INFO] Worker process is ready for action.
[2017-11-19 13:03:48,357] [PID 22376] [MainThread] [dramatiq.WorkerProcess(2)] [INFO] Worker process is ready for action.
[2017-11-19 13:03:48,357] [PID 22374] [MainThread] [dramatiq.WorkerProcess(0)] [INFO] Worker process is ready for action.
[2017-11-19 13:03:48,358] [PID 22379] [MainThread] [dramatiq.WorkerProcess(5)] [INFO] Worker process is ready for action.
[2017-11-19 13:03:48,362] [PID 22381] [MainThread] [dramatiq.WorkerProcess(7)] [INFO] Worker process is ready for action.
[2017-11-19 13:03:48,364] [PID 22380] [MainThread] [dramatiq.WorkerProcess(6)] [INFO] Worker process is ready for action.
[2017-11-19 13:03:48,366] [PID 22378] [MainThread] [dramatiq.WorkerProcess(4)] [INFO] Worker process is ready for action.
[2017-11-19 13:03:48,369] [PID 22377] [Thread-4] [count_words.count_words] [INFO] Received args=('http://example.com',) kwargs={}.
There are 338 words at 'http://example.com'.
[2017-11-19 13:03:48,679] [PID 22377] [Thread-4] [count_words.count_words] [INFO] Completed after 310.42ms.
```

If you open your Python interpreter back up and send the actor some more URLs to process:

```py
>>> urls = [
...     "https://news.ycombinator.com",
...     "https://xkcd.com",
...     "https://rabbitmq.com",
... ]
>>> [count_words.send(url) for url in urls]
[Message(queue_name='default', actor_name='count_words', args=('https://news.ycombinator.com',), kwargs={}, options={}, message_id='a99a5b2d-d2da-407b-be55-f2925266e216', message_timestamp=1498557998218),
 Message(queue_name='default', actor_name='count_words', args=('https://xkcd.com',), kwargs={}, options={}, message_id='0ec93dcb-2f9f-414f-99ec-7035e3b1ac5a', message_timestamp=1498557998218),
 Message(queue_name='default', actor_name='count_words', args=('https://rabbitmq.com',), kwargs={}, options={}, message_id='d3dd9799-1ea5-4b00-a70b-2cd6f6f634ed', message_timestamp=1498557998218)]
```

and then switch back to the worker terminal, you’ll see nine new lines:

```sh
[2017-11-19 13:10:02,620] [PID 24357] [Thread-4] [count_words.count_words] [INFO] Received args=('https://rabbitmq.com',) kwargs={}.
[2017-11-19 13:10:02,621] [PID 24357] [Thread-6] [count_words.count_words] [INFO] Received args=('https://xkcd.com',) kwargs={}.
[2017-11-19 13:10:02,621] [PID 24357] [Thread-5] [count_words.count_words] [INFO] Received args=('https://news.ycombinator.com',) kwargs={}.
There are 888 words at 'https://rabbitmq.com'.
[2017-11-19 13:10:02,757] [PID 24357] [Thread-4] [count_words.count_words] [INFO] Completed after 137.26ms.
There are 461 words at 'https://xkcd.com'.
[2017-11-19 13:10:02,841] [PID 24357] [Thread-6] [count_words.count_words] [INFO] Completed after 219.76ms.
There are 3598 words at 'https://news.ycombinator.com'.
[2017-11-19 13:10:03,297] [PID 24357] [Thread-5] [count_words.count_words] [INFO] Completed after 675.19ms.
```

At this point, you’re probably wondering what happens if you send the actor an invalid URL. Let’s try it:

```py
>>> count_words.send("foo")
```

### Error Handling 错误处理

使用指数退避算法来重试出错的 actors：

```sh
[2017-06-27 13:11:22,059] [PID 13053] [Thread-8] [dramatiq.worker.WorkerThread] [WARNING] Failed to process message count_words('foo') with unhandled exception.
Traceback (most recent call last):
  ...
requests.exceptions.MissingSchema: Invalid URL 'foo': No schema supplied. Perhaps you meant http://foo?
[2017-06-27 13:11:22,062] [PID 13053] [Thread-8] [dramatiq.middleware.retries.Retries] [INFO] Retrying message 'a53a5a7d-74e1-48ae-a5a8-0b72af2a8708' in 8104 milliseconds.
```

Dramatiq will keep retrying the message with longer and longer delays in between runs until we fix our code or for up to about 30 days from when it was first enqueued.

Change `count_words` to catch the missing schema error:

```py
@dramatiq.actor
def count_words(url):
    try:
        response = requests.get(url)
        count = len(response.text.split(" "))
        print(f"There are {count} words at {url!r}.")
    except requests.exceptions.MissingSchema:
        print(f"Message dropped due to invalid url: {url!r}")
```

Then send `SIGHUP` to the main worker process to make the workers pick up the source code changes:

```sh
$ kill -s HUP <dramatiq-worker-pid>
```

Substitute the process ID of your own main process for `<dramatiq-worker-pid>`. You can find the PID by looking at the log lines from the worker starting up. Look for lines containing the string `[dramatiq.MainProcess]`.

The next time your message is retried you should see:

```sh
Message dropped due to invalid url: 'foo'
```

### Code Reloading

Sending `SIGHUP` to the workers every time you make a change is going to get old quick. Instead, you can run the command line utility with the `--watch` flag pointing to the folder it should watch for source code changes. It’ll reload the workers whenever Python files under that folder or any of its sub-folders change:

```sh
$ dramatiq count_words --watch .
```

> Warning: Although this is a handy feature to use when developing your code, you should avoid using it in production!

### Message Retries

除了默认的指数退避算法，你还可以向装饰器传入参数 `max_retries` 来指定最大重试次数

```py
@dramatiq.actor(max_retries=3)
def count_words(url):
  ...
```

If you want to retry certain exceptions and not others, you can pass a predicate function via the `retry_when` parameter:

如果你想要对不同 exceptions 结果进行不同的重试处理，使用 `retry_when` 参数

```py
def should_retry(retries_so_far, exception):
    return retries_so_far < 3 and isinstance(exception, HttpTimeout)


@dramatiq.actor(retry_when=should_retry)
def count_words(url):
    ...
```

The following retry options are configurable on a per-actor basis:

| Option        | Default    | Description                                                  |
| :------------ | :--------- | :----------------------------------------------------------- |
| `max_retries` | `20`       | 最大重试次数. `None` means the message should be retried indefinitely. |
| `min_backoff` | 15 seconds | 指数退避中，两次重试间隔的最小时间，单位为 milliseconds 毫秒 Must be greater than 100 milliseconds. |
| `max_backoff` | 7 days     | 指数退避中，两次重试间隔的最大时间，单位为 milliseconds 毫秒 Higher values are less reliable. |
| `retry_when`  | `None`     | 一个函数，决定 actor 是否被重试. When this is set, `max_retries` is ignored. |
| `throws`      | `None`     | An exception or a tuple of exceptions that must not get retried if they are raised from within the actor. |

### Message Age Limits

Instead of limiting the number of times messages can be retried, you might want to expire old messages. You can specify the `max_age` of messages (given in milliseconds) on a per-actor basis:

```py
@dramatiq.actor(max_age=3600000)
def count_words(url):
    ...
```

#### Dead Letters

Once a message has exceeded its retry or age limits, it gets moved to the dead letter queue where it’s kept for up to 7 days and then automatically dropped from the message broker. From here, you can manually inspect the message and decide whether or not it should be put back on the queue.

### Message Time Limits

In `count_words`, we didn’t set an explicit timeout for the outbound request which means that it can take a very long time to complete if the server we’re requesting is timing out. Dramatiq has a default actor time limit of 10 minutes, which means that any actor running for longer than 10 minutes is killed with a [`TimeLimitExceeded`](https://dramatiq.io/reference.html#dramatiq.middleware.TimeLimitExceeded) error.

actor 运行的最长时间默认为 10 分钟

You can control these time limits at the individual actor level by specifying the `time_limit` (in milliseconds) of each one:

```py
@dramatiq.actor(time_limit=60000)
def count_words(url):
    ...
```

> Note: While this will keep our actor from running forever, remember that you should take care to always specify a timeout for the request itself, and this is **not** a good way to handle request timeouts in production code.

#### Handling Time Limits

If you want to gracefully handle time limits within an actor, you can wrap its source code in a try block and catch [`TimeLimitExceeded`](https://dramatiq.io/reference.html#dramatiq.middleware.TimeLimitExceeded):

使用 `TimeLimitExceeded` 异常来捕获超时情况

```py
from dramatiq.middleware import TimeLimitExceeded


@dramatiq.actor(time_limit=1000)
def long_running():
    try:
        setup_missiles()
        time.sleep(2)
        launch_missiles()    # <- this will not run
    except TimeLimitExceeded:
        teardown_missiles()  # <- this will run
```

### Scheduling Messages

You can schedule messages to run some time in the future by calling [`send_with_options`](https://dramatiq.io/reference.html#dramatiq.Actor.send_with_options) on actors and providing a `delay` (in **milliseconds**):

延迟运行函数

```py
>>> count_words.send_with_options(args=("https://example.com",), delay=10000)
Message(
  queue_name='default',
  actor_name='count_words',
  args=('https://example.com',), kwargs={},
  options={'eta': 1498560453548},
  message_id='7387dc76-8ebe-426e-aec1-db34c236563c',
  message_timestamp=1498560443548)
```

Keep in mind that *your message broker is not a database*. Scheduled messages should represent a small subset of all your messages.

### Prioritizing Messages

使用 `priority` 参数来指定 actor 的优先级，数字越低，优先级越高

```py
@dramatiq.actor(priority=0)  # 0 is the default
def generate_report(user_id):
    ...


@dramatiq.actor(priority=10)
def sync_order_to_warehouse(order_id):
    ...
```

Although all positive integers represent valid priorities, if you’re going to use this feature, I’d recommend setting up constants for the various priorities you plan to use:

```py
PRIO_LO = 100
PRIO_MED = 50
PRIO_HI = 0
```

### Message Brokers

Dramatiq abstracts over the notion of a message broker and currently supports both RabbitMQ and Redis out of the box. By default, it’ll set up a RabbitMQ broker instance pointing at the local host.

#### RabbitMQ Broker

To configure the RabbitMQ host, instantiate a [`RabbitmqBroker`](https://dramatiq.io/reference.html#dramatiq.brokers.rabbitmq.RabbitmqBroker) and set it as the global broker as early as possible during your program’s execution:

```py
import dramatiq

from dramatiq.brokers.rabbitmq import RabbitmqBroker


rabbitmq_broker = RabbitmqBroker(host="rabbitmq")
dramatiq.set_broker(rabbitmq_broker)
```

#### Redis Broker

To use Dramatiq with the Redis broker, create an instance of it and set it as the global broker as early as possible during your program’s execution:

```py
import dramatiq

from dramatiq.brokers.redis import RedisBroker


redis_broker = RedisBroker(host="redis")
dramatiq.set_broker(redis_broker)
```

### Unit Testing

Dramatiq provides a [`StubBroker`](https://dramatiq.io/reference.html#dramatiq.brokers.stub.StubBroker) that can be used in unit tests so you don’t have to have a running RabbitMQ or Redis instance in order to run your tests. My recommendation is to use it in conjunction with [pytest fixtures](https://docs.pytest.org/en/latest/fixture.html):

broker.py

```py
import os

from dramatiq.brokers.rabbitmq import RabbitmqBroker
from dramatiq.brokers.stub import StubBroker


if os.getenv("UNIT_TESTS") == "1":
    broker = StubBroker()
    broker.emit_after("process_boot")
else:
    broker = RabbitmqBroker()
```

conftest.py

```py
import dramatiq
import pytest

from dramatiq import Worker
from yourapp import broker


@pytest.fixture()
def stub_broker():
    broker.flush_all()
    return broker


@pytest.fixture()
def stub_worker():
    worker = Worker(broker, worker_timeout=100)
    worker.start()
    yield worker
    worker.stop()
```

Then you can inject and use those fixtures in your tests:

```py
def test_count_words(stub_broker, stub_worker):
    count_words.send("http://example.com")
    stub_broker.join(count_words.queue_name)
    stub_worker.join()
```

Because all actors are callable, you can of course also unit test them synchronously by calling them as you would normal functions.

#### Dealing with Exceptions

By default, any exceptions raised by an actor are raised in the worker, which runs in a separate thread from the one your tests run in. This means that any exceptions your actor throws will not be visible to your test code!

You can make the stub broker re-raise exceptions from failed actors in your main thread by passing `fail_fast=True` to its `join` method:

```py
def test_count_words(stub_broker, stub_worker):
    count_words.send("http://example.com")
    stub_broker.join(count_words.queue_name, fail_fast=True)
    stub_worker.join()
```

This way, whatever exception caused the actor to fail will be raised eagerly within your test. Note that the exception will only be raised once the actor exceeds its available retries.

## Best Practices 最佳实践

### Concurrent Actors

Your actor will run concurrently with other actors in the system. You need to be mindful of the impact this has on your database, any third party services you might be calling and the resources available on the systems running your workers. Additionally, you need to be mindful of data races between actors that manipulate the same objects in your database.

### Retriable Actors

Dramatiq actors may receive the same message multiple times in the event of a worker failure (hardware, network or power failure). This means that, for any given message, running your actor multiple times must be safe. This is also known as being “idempotent”.

### Simple Messages

Attempting to send an actor any object that can’t be encoded to JSON by the standard `json` package will fail immediately so you’ll want to limit your actor parameters to the following object types: bool, int, float, bytes, string, list and dict.

Additionally, since messages are sent over the wire you’ll want to keep them as short as possible. For example, if you’ve got an actor that operates over `User` objects in your system, send that actor the user’s id rather than the serialized user.

### Error Reporting

Invariably, you’re probably going to introduce issues in production every now and then and some of those issues are going to affect your tasks. You should use an error reporting service such as [Sentry](https://sentry.io/welcome/) so you get notified of these errors as soon as they occur.

## 控制 Workers

Dramatiq 进程接受如下信号：

```sh
$ kill -TERM [master-process-pid]
```

#### `INT` 和 `TERM`

Sending an `INT` or `TERM` signal to the main process triggers graceful shutdown. Consumer threads will stop receiving new work and worker threads will finish processing the work they have in flight before shutting down. Any tasks still in worker memory at this point are re-queued on the broker.

优雅地关闭 Dramatiq

- 消费线程停止接受新的 actors
- worker 线程先执行完当前 actor 再关闭
- 一些遗留在 worker memory 的任务填回队列

If you send a **second** `INT` or `TERM` signal then the worker processes will be killed immediately.

#### `HUP`

Sending `HUP` to the main process triggers a graceful shutdown followed by a reload of the workers. This is useful if you want to reload code without completely restarting the main process.

## Using gevent

Dramatiq comes with a CLI utility called `dramatiq-gevent` that can run workers under [gevent](http://www.gevent.org/). The following invocation would run 8 worker processes with 250 greenlets per process for a total of 2k lightweight worker threads:

```
$ dramatiq-gevent my_app -p 8 -t 250
```

If your tasks spend most of their time doing network IO and don’t depend on C extensions to execute those network calls then using gevent could provide a significant performance improvement.

I suggest at least experimenting with it to see if it fits your use case.

## 中间件

Dramaiq 提供了一些功能丰富的中间件

### 使用

```python
redis_broker = RedisBroker(
    client=redis_client,
    middleware=[
        AgeLimit(),
        TimeLimit(),
        ShutdownNotifications(),
        Callbacks(),
        Pipelines(),
        Retries(),
        CurrentMessage(),
        Results(backend=backend),
    ],
)
```

### DIY

## dramatiq_dashboard

> https://github.com/Bogdanp/dramatiq_dashboard

第三方库，可视化仪表盘

## 其他技巧

### 控制单个 actor 函数的并发量

> https://github.com/Bogdanp/dramatiq/issues/32

dramtiq 提供了一个 *ConcurrentRateLimiter* 类来控制单个 actor 函数的并发量，具体原理就是设定一个互斥量 mutex 来保证同一时刻只有指定数量的 actor 在执行。

```py
import dramatiq
import time

from dramatiq.rate_limits import ConcurrentRateLimiter
from dramatiq.rate_limits.backends import RedisBackend

backend = RedisBackend(client=...)
DISTRIBUTED_MUTEX = ConcurrentRateLimiter(backend, "distributed-mutex", limit=1)


@dramatiq.actor
def one_at_a_time():
    with DISTRIBUTED_MUTEX.acquire():
        time.sleep(1)
        print("Done.")
```

可以将其封装成中间件

```python
def get_mutex(limit: int = 1) -> ConcurrentRateLimiter:
    """获取mutex"""
    backend = RateLimitRedisBackend(client=redis_client)
    return ConcurrentRateLimiter(backend, "distributed-mutex", limit=limit)


class RetryMutex(Middleware):
    def after_process_message(self, broker, message, *, result=None, exception=None) -> None:  # type:ignore
        if isinstance(exception, RateLimitExceeded):
            # 若访问mutex失败，将此任务重新入列
            broker.enqueue(message, delay=10_000) 

            
broker = dramatiq.get_broker()
broker.add_middleware(RetryMutex())
```

使用示例：

```py
MUTEX = get_mutex(1)


@dramatiq_app.actor(max_retries=0)
def t_func(i: int) -> None:
    with MUTEX.acquire():
        # do sth...
```

