---
title: "sentry-sdk"
date: 2023-12-12
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# sentry-sdk

> 官方文档：https://docs.sentry.io/platforms/python/?original_referrer=https%3A%2F%2Fsentry.io%2F

Sentry's Python SDK enables automatic reporting of errors and performance data in your application.

```sh
pip install --upgrade sentry-sdk
```

## 术语

### Event

An *event* is one instance of sending data to Sentry. Generally, this data is an error or exception.

错误发生时向 sentry 发送的一个实例

### Capturing

The reporting of an event is called *capturing*. When an event is captured, it’s sent to Sentry.

一次事件的上报过程就叫做捕获

### Release

> https://docs.sentry.io/product/releases/?original_referrer=https%3A%2F%2Fsentry.io%2F

A *release* is a version of your code deployed to an environment. When you notify Sentry about a [release](https://try.sentry-demo.com/demo/start/?scenario=oneRelease&projectSlug=react&source=docs), you can easily identify new issues and regressions.

代码的版本，不同版本的操作将会分开展示

![View of the release index page showing each version of projects related to the release and the project details.](https://docs.sentry.io/static/6bedb945957ca3cbb93df067b9f5c401/c1b63/release_index.png)

### Breadcrumb

Sentry uses *breadcrumbs* to create a trail of events that happened prior to an issue. These events are very similar to traditional logs, but can record more rich structured data.

Breadcrumbs are different from events: they will not create an event in Sentry, but will be buffered until the next event is sent.

错误发生之前的一系列追踪信息，类似于日志上下文的概念

面包屑不会作为一个单独的 issue 或 event 显示在页面上，而是会在 event 的详情页上展现

### Issue

An *issue* is a grouping of similar events.

同类型的一系列事件

### fingerprint 

All events have a fingerprintThe set of characteristics that define an event.. Events with the same fingerprint are grouped together into an issue.

指纹相同的事件会聚集成一类 issue

By default, Sentry will run one of our built-in grouping algorithms to generate a fingerprint based on information available within the event such as `stacktrace`, `exception`, and `message`.

### Transaction

> https://docs.sentry.io/product/performance/transaction-summary/

A transaction represents a single instance of an activity you want to measure or track, like a page load, page navigation, or an asynchronous task. Having transaction information lets you monitor the overall performance of your application beyond when it crashes or generates an error. Without transactions, you can only know when things in your application have actually gone wrong, which is important, but not the whole picture.

## 配置

配置操作应当在程序最开始执行处完成

```sh
import sentry_sdk

sentry_sdk.init(
    dsn="https://examplePublicKey@o0.ingest.sentry.io/0",

    # Enable performance monitoring
    enable_tracing=True,
)
```

### Basic Options

> https://docs.sentry.io/platforms/python/configuration/options/?original_referrer=https%3A%2F%2Fsentry.io%2F

Options are passed to the `init()` function as optional keyword arguments:

```py
import sentry_sdk

sentry_sdk.init(
    dsn="https://examplePublicKey@o0.ingest.sentry.io/0",
    max_breadcrumbs=50,
    debug=True,
    enable_tracing=True,

    # By default the SDK will try to use the SENTRY_RELEASE
    # environment variable, or infer a git commit
    # SHA as release, however you may want to set
    # something more human-readable.
    # release="myapp@1.0.0",
)
```

Options that can be read from an environment variable (SENTRY_DSN, SENTRY_ENVIRONMENT, SENTRY_RELEASE) are read automatically.

- dsn：sentry 配置的 dsn 数据源地址
    - If this value is not provided, the SDK will try to read it from the `SENTRY_DSN` environment variable
- debug：是否开启 debug 模式，默认 False
    - debug 模式会打印错误

- release：指定代码的发行版本（即 release）
    - By default the SDK will try to read this value from the `SENTRY_RELEASE` environment variable
- environment：指定代码运行环境
    - This string is freeform and set to `production` by default
    - By default the SDK will try to read this value from the `SENTRY_ENVIRONMENT` environment variable.
- sample_rate：指定发送事件的比例
    - 范围是 0.0 到 1.0
    - The default is `1.0` which means that 100% of error events are sent. If set to `0.1` only 10% of error events will be sent. 
    - Events are picked **randomly**.
- attach_stacktrace：堆栈异常是否随消息一起发送，默认 False
    - When enabled, stack traces are automatically attached to all messages logged
    - Grouping in Sentry is different for events with stack traces and without. As a result, you will get new groups as you enable or disable this flag for certain events.
- include_source_context：是否开启代码前后文，默认 True
    - This source context includes the five lines of code above and below the line of code where an error happened.
- include_local_variables：是否包含本地变量，默认 True
    - When enabled, the SDK will capture a snapshot of local variables to send with the event to help with debugging.

---

以下是一些 hooks 参数

- before_send：发送 event 之前

- before_send_transaction：
- before_breadcrumb：

### 第三方模块集成

> https://docs.sentry.io/platforms/python/integrations/?original_referrer=https%3A%2F%2Fsentry.io%2F

#### Flask

```sh
pip install --upgrade 'sentry-sdk[flask]'
```

##### 自定义

```py
import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration

sentry_sdk.init(
    dsn="https://examplePublicKey@o0.ingest.sentry.io/0",
    enable_tracing=True,
    integrations = [
        FlaskIntegration(
            transaction_style="url",
        ),
    ],
)
```

#### logging

```py
import logging

def main():
    sentry_sdk.init(...)  # same as above

    logging.debug("I am ignored") # 不会被揭露
    logging.info("I am a breadcrumb") # 作为面包屑被记录
    logging.error("I am an event", extra=dict(bar=43)) # 作为错误事件bei上报
    logging.exception("An exception happened") # 作为异常事件被上报，并随附堆栈信息

main()
```

- There will be an error event with the message `"I am an event"`.
- `"I am a breadcrumb"` will be attached as a breadcrumb to that event.
- `bar` will end up in the event's `extra` attributes.
- `"An exception happened"` will send the current exception from `sys.exc_info()` with the stack trace and everything to the Sentry Python SDK. If there's no exception, the current stack will be attached.
- The debug message `"I am ignored"` will not surface anywhere. To capture it, you need to lower `level` to `DEBUG` (See below).

##### 自定义

```py
import logging
import sentry_sdk
from sentry_sdk.integrations.logging import LoggingIntegration

# The SDK will honor the level set by the logging library, which is WARNING by default.
# If we want to capture records with lower severity, we need to configure
# the logger level first.
logging.basicConfig(level=logging.INFO)

sentry_sdk.init(
    dsn="https://examplePublicKey@o0.ingest.sentry.io/0",
    integrations=[
        LoggingIntegration(
            level=logging.INFO,        # Capture info and above as breadcrumbs
            event_level=logging.INFO   # Send records as events
        ),
    ],
)
```

You can pass the following keyword arguments to `LoggingIntegration()`:

- `level` (default `INFO`)
    - The Sentry Python SDK will record log records with a level higher than or equal to `level` **as breadcrumbs**. Inversely, the SDK completely ignores any log record with a level lower than this one. 
    - If a value of `None` occurs, the SDK won't send log records as breadcrumbs.
- `event_level` (default `ERROR`)
    - The Sentry Python SDK will report log records with a level higher than or equal to `event_level` **as events** as long as the logger itself is set to output records of those log levels (see note below). 
    - If a value of `None` occurs, the SDK won't send log records as events.

##### 忽略指定 logger

Sometimes a logger is extremely noisy and spams you with pointless errors. You can ignore that logger by calling `ignore_logger`:

```py
from sentry_sdk.integrations.logging import ignore_logger

ignore_logger("a.spammy.logger")

logger = logging.getLogger("a.spammy.logger")
logger.error("hi")  # no error sent to sentry
```

You can also use `before-send` and `before-breadcrumb` to ignore only certain messages.

## 进阶设置

### Breadcrumbs

#### 手动记录

You can manually add breadcrumbs whenever something interesting happens.

```py
from sentry_sdk import add_breadcrumb

add_breadcrumb(
    category='auth',
    message='Authenticated user %s' % user.email,
    level='info',
)
```

The available breadcrumb keys are `type`, `category`, `message`, `level`, `timestamp` (which many SDKs will set automatically for you), and `data`, which is the place to put any additional information you'd like the breadcrumb to include. 

Using keys other than these six won't cause an error, but will result in the data being dropped when the event is processed by Sentry.

#### 自动上报

SDKs and their associated integrations will automatically record many types of breadcrumbs. 

For example, the browser JavaScript SDK will automatically record clicks and key presses on DOM elements, XHR/fetch requests, console API calls, and all location changes.

#### 自定义

SDKs allow you to customize breadcrumbs through the `before_breadcrumb` hook.

This hook is passed an already assembled breadcrumb and, in some SDKs, an optional hint. The function can modify the breadcrumb or decide to discard it entirely by returning `null`:

```py
import sentry_sdk

def before_breadcrumb(crumb, hint):
    if crumb['category'] == 'a.spammy.Logger':
        return None
    return crumb

sentry_sdk.init(
    # ...

    before_breadcrumb=before_breadcrumb,
)
```

### 过滤事件

We also offer [Inbound Filters](https://docs.sentry.io/product/data-management-settings/filtering/?original_referrer=https%3A%2F%2Fsentry.io%2F) to filter events in sentry.io. We recommend filtering at the client level though, because it removes the overhead of sending events you don't actually want.

#### 使用 before_send 过滤错误事件

Configure your SDK to filter error events by using the `before_send` callback method and configuring, enabling, or disabling integrations.

参数

- even
    - `before_send` receives the event object as a parameter, which you can use to either modify the event’s data or drop it completely by returning `null`, based on custom logic and the data available on the event.

- hint
    - The `before_send` callback is passed both the `event` and a second argument, `hint`, that holds one or more hints.
    - Typically a `hint` holds the original exception so that additional data can be extracted or grouping is affected.

```py
# In this example, the fingerprintThe set of characteristics that define an event. is forced to a common value if an exception of a certain type has been caught
import sentry_sdk

def before_send(event, hint):
    if 'exc_info' in hint:
        exc_type, exc_value, tb = hint['exc_info']
        if isinstance(exc_value, DatabaseUnavailable):
            event['fingerprint'] = ['database-unavailable']
    return event

sentry_sdk.init(
    # ...

    before_send=before_send,
)
```

