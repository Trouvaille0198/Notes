---
title: "Python celery 库"
date: 2022-8-2
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# celery

## 快速使用

步骤如下

- 选择并且安装一个消息中间件（Broker）
- 安装 Celery 并且创建第一个任务
- 运行职程（Worker）以及调用任务
- 跟踪任务的情况以及返回值

### 选择中间人（Broker）

Celery 需要一个中间件来进行接收和发送消息，通常以独立的服务形式出现，成为 消息中间人（Broker）

以下有几种选择：

#### RabbitMQ

RabbitMQ 的功能比较齐全、稳定、便于安装。在生产环境来说是首选的

如果您使用的是 Ubuntu 或 Debian ，可以通过以下命令进行安装 RabbitMQ：

```shell
$ sudo apt-get install rabbitmq-server
```

如果在 Docker 中运行 RabbitMQ ，可以使用以下命令：

```shell
$ docker run -d -p 5462:5462 rabbitmq
```

命令执行完毕之后，中间人（Broker）会在后台继续运行，准备输出一条 *Starting rabbitmq-server: SUCCESS* 的消息。

#### Redis

Redis 功能比较全，但是如果突然停止运行或断电会造成数据丢失

在 Docker 中运行 Redis ，可以通过以下命令实现：

```shell
$ docker run -d -p 6379:6379 redis
```

### 安装 Celery

Celery 在 python 的 PyPI 中管理，可以使用 pip 或 easy_install 来进行安装：

```shell
$ pip install celery
```

### 应用

创建第一个 Celery 实例程序，我们把创建 Celery 程序成为 Celery 应用或直接简称为 app，创建的第一个实例程序可能需要包含 Celery 中执行操作的所有入口点，例如创建任务、管理职程（Worker）等，所以必须要导入 Celery 模块。

在本教程中将所有的内容，保存为一个 app 文件中。针对大型的项目，可能需要创建独立的模块。

首先创建 tasks.py：

```python
from celery import Celery
app = Celery('tasks', broker='amqp://guest@localhost//')
@app.task
def add(x, y):
    return x + y
```

第一个参数为当前模块的名称，只有在 __main__ 模块中定义任务时才会生产名称。

第二个参数为中间人（Broker）的链接 URL ，实例中使用的 RabbitMQ（Celery 默认使用 RabbitMQ）。

创建了一个名称为 add 的任务，返回的俩个数字的和。

### 运行 Celery 职程（Worker）服务

现在可以使用 worker 参数进行执行我们刚刚创建职程（Worker）

```shell
$ celery -A tasks worker --loglevel=info
```

> 在生产环境中，如果需要将职程（Worker）作为守护进程在后台运行，可以使用平台提供的工具来进行实现，或使用类似 supervisord 这样的工具来进行管理（详情： [`守护进程：Daemonization` ]()部分）

关于 Celery 可用的命令完整列表，可以通过以下命令进行查看：

```shell
$ celery worker --help
```

### 调用任务

需要调用我们创建的实例任务，可以通过 `delay()` 进行调用。

`delay()` 是 `apply_async()` 的快捷方法，可以更好的控制任务的执行

```python
>>> from tasks import add
>>> add.delay(4, 4)
```

该任务已经有职程（Worker）开始处理，可以通过控制台输出的日志进行查看执行情况。

调用任务会返回一个 AsyncResult 的实例，用于检测任务的状态，等待任务完成获取返回值（如果任务执行失败，会抛出异常）。默认这个功能是不开启的，如果开启则需要配置 Celery 的结果后端，下一小节会详细说明。

### 保存结果

如果您需要跟踪任务的状态，Celery 需要在某处存储任务的状态信息。

Celery 内置了一些后端结果：[SQLAlchemy/Django](https://www.sqlalchemy.org/) ORM、[Memcached](http://memcached.org/)、[Redis](https://redis.io/)、 RPC ([RabbitMQ](https://www.rabbitmq.com/)/AMQP) 以及自定义的后端结果存储中间件。

针对本次实例，我们使用 RPC 作为结果后端，将状态信息作为临时消息回传。后端通过 backend 参数指定给 Celery（或者通过配置模块中的 result_backend 选项设定）：

```python
app = Celery('tasks', backend='rpc://', broker='pyamqp://')
```

可以使用Redis作为Celery结果后端，使用RabbitMQ作为中间人（Broker）可以使用以下配置（这种组合比较流行）：

```python
app = Celery('tasks', backend='redis://localhost', broker='pyamqp://')
```

现在已经配置结果后端，重新调用执行任务。会得到调用任务后返回的一个 AsyncResult 实例：

```python
>>> result = add.delay(4, 4)
```

`ready()` 可以检测是否已经处理完毕：

```python
>>> result.ready()
False
```

整个任务执行过程为异步的，如果一直等待任务完成，会将异步调用转换为同步调用：

```python
>>> result.get(timeout=1)
8
```

如果任务出现异常，`get()` 会再次引发异常，可以通过 propagate 参数进行覆盖：

```python
>>> result.get(propagate=False)
```

如果任务出现异常，可以通过以下命令进行回溯：

```python
>>> result.traceback
```

### 配置

Celery 像家用电器一样，不需要任何配置，开箱即用。它有一个输入和输出，输入端必须连接中间人（Broker），输出端可以连接到结果后端。如果仔细观察一些家用电器，会发现有很多到按钮，这就是配置。

大多数情况下，使用默认的配置就可以满足，也可以按需配置。

可以直接在程序中进行配置，也可以通过配置模块进行专门配置。例如，通过 task_serializer 选项可以指定序列化的方式：

```python
app.conf.task_serializer = 'json'
```

如果需要配置多个选项，可以通过 update 进行配置：

```python
app.conf.update(
    task_serializer='json',
    accept_content=['json'],  # Ignore other content
    result_serializer='json',
    timezone='Europe/Oslo',
    enable_utc=True,
)
```

针对大型的项目，建议使用专用配置模块，进行针对 Celery 配置。不建议使用硬编码，建议将所有的配置项集中化配置。集中化配置可以像系统管理员一样，当系统发生故障时可针对其进行微调。

可以通过 `app.config_from_object()` 进行加载配置模块：

```python
app.config_from_object('celeryconfig')
```

其中 celeryconfig 为配置模块的名称，这个是可以自定义修改的、

在上面的实例中，需要在同级目录下创建一个名为 `celeryconfig.py` 的文件，添加以下内容：

```python
broker_url = 'pyamqp://'
result_backend = 'rpc://'

task_serializer = 'json'
result_serializer = 'json'
accept_content = ['json']
timezone = 'Europe/Oslo'
enable_utc = True
```

可以通过以下命令来进行验证配置模块是否配置正确：

```python
$ python -m celeryconfig
```

