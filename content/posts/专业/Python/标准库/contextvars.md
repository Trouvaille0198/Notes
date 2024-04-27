---
title: "Python contextvars 库"
date: 2023-12-13
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# contextvars

这个模块提供了一组接口，可用于管理、储存、访问 局部上下文的状态。

主要用于在异步环境中管理上下文变量。

在多并发环境中，有状态上下文管理器应该使用上下文变量，而不是 [`threading.local()`](https://docs.python.org/zh-cn/3/library/threading.html#threading.local) 来防止他们的状态意外泄露到其他代码。

## 基本使用

### ContextVar

```py
class contextvars.ContextVar(name[, *, default])
```

声明一个新的上下文变量

```py
var: ContextVar[int] = ContextVar('var', default=42)
```

#### 参数

- `name`
    - 上下文变量的名称
- `default`：
    - 上下文变量的默认值，只能通过关键字传参

#### 方法

- `get([default])`

    - 返回该上下文变量的值。
    - 未指定默认值且上下文变量无默认值时，抛出 LookupError。

- `set(value)`

    - 设置上下文变量的值
    - 返回一个 [`Token`](https://docs.python.org/zh-cn/3/library/contextvars.html#contextvars.Token) 对象，可通过 [`ContextVar.reset()`](https://docs.python.org/zh-cn/3/library/contextvars.html#contextvars.ContextVar.reset) 方法将上下文变量还原为之前某个状态。

- `reset(token)`

    - 使用 token 重置上下文变量的值。

    - ```py
        var = ContextVar('var')
        
        token = var.set('new value')
        # code that uses 'var'; var.get() returns 'new value'.
        var.reset(token)
        
        # After the reset call the var has no value again, so
        # var.get() would raise a LookupError.
        ```

### 手动上下文管理

#### `contextvars.copy_context()`

返回当前上下文中 [`Context`](https://docs.python.org/zh-cn/3/library/contextvars.html#contextvars.Context) 对象的拷贝。

以下代码片段会获取当前上下文的拷贝并打印设置到其中的所有变量及其值 👇

```py
ctx: Context = copy_context()
print(list(ctx.items()))
```

此函数复杂度为 `O(1)` ，也就是说对于只包含几个上下文变量和很多上下文变量的情况，他们是一样快的。

#### `class contextvars.Context`

- `copy()`：返回 Context 的浅拷贝。

- `run(callable, *args, **kwargs)`：在该上下文中运行 `callable(*args,* *kwargs)`
    - *callable* 对上下文变量所做的任何修改都会保留在上下文对象中
    - `run` 的条件
        - 当多线程同时执行 run 时，抛出 `RuntimeError`.
        - 当递归地执行 run 时，也会抛出 `RuntimeError`.
        - 同一个 Context，在同一时刻只能有一个 run 方法运行。
        - 多进程显然不在考虑范围内。

```python
var = ContextVar('var')
var.set('spam')

def main():
    # 'var' was set to 'spam' before
    # calling 'copy_context()' and 'ctx.run(main)', so:
    # var.get() == ctx[var] == 'spam'

    var.set('ham')

    # Now, after setting 'var' to 'ham':
    # var.get() == ctx[var] == 'ham'

ctx = copy_context()

# Any changes that the 'main' function makes to 'var'
# will be contained in 'ctx'.
ctx.run(main)

# The 'main()' function was run in the 'ctx' context,
# so changes to 'var' are contained in it:
# ctx[var] == 'ham'

# However, outside of 'ctx', 'var' is still set to 'spam':
# var.get() == 'spam'
```

## 其他

在异步编程中的运用：https://blog.csdn.net/luchengtao11/article/details/126442670