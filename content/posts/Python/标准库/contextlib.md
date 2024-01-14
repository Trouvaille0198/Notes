---
title: "Python contextlib 库"
date: 2023-08-02
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# contextlib

上下文，简而言之，就是程式所执行的环境状态，或者说程式运行的情景。

上下文管理器 (context manager) 是 Python2.5 开始支持的一种语法，用于规定某个对象的使用范围。一旦进入或者离开该使用范围，会有特殊操作被调用。它的语法形式是 with…as…，主要应用场景资源的创建和释放。例如，文件就支持上下文管理器，可以确保完成文件读写后关闭文件句柄。

```py
with open('password.txt', 'wt') as f:
    f.write('contents go here')
# 文件会自动关闭
```

## ContextDecorator - 作为装饰器使用上下文管理器

通过继承 contextlib 里面的 ContextDecorator 类，实现对常规上下文管理器类的支持，其不仅可以作为上下文管理器，也可以作为函数修饰符。

```py
import contextlib


class Context(contextlib.ContextDecorator):

    def __init__(self, how_used):
        self.how_used = how_used
        print(f'__init__({how_used})')

    def __enter__(self):
        print(f'__enter__({self.how_used})')
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f'__exit__({self.how_used})')


@Context('这是装饰器方式')
def func(message):
    print(message)
    
    
print("---------------")
func('作为装饰器运行')


print("\n-------华丽的分割线--------\n")
with Context('上下文管理器方式'):
    print('emmmm')
```

<img src="C:\Users\chenx\AppData\Roaming\Typora\typora-user-images\image-20231213165118061.png" alt="image-20231213165118061" style="zoom:50%;" />

## contextmanager - 生成器函数转为上下文管理器

有时候我们的代码只有很少的上下文要管理，此时再使用上面的形式写出 with 相关的魔法函数就显得比较啰嗦了，在这种情况下，我们可以使用 contextmanager 修饰符将一个生成器转换为上下文管理器。

官方注释

```py
Typical usage:

    @contextmanager
    def some_generator(<arguments>):
        <setup>
        try:
            yield <value>
        finally:
            <cleanup>

This makes this:

    with some_generator(<arguments>) as <variable>:
        <body>

equivalent to this:

    <setup>
    try:
        <variable> = <value>
        <body>
    finally:
        <cleanup>
```

被装饰器装饰的函数分为三部分:

- with 语句中的代码块执行前，执行函数中 yield 之前代码
- yield 返回的内容复制给 as 之后的变量
- with 代码块执行完毕后，执行函数中 yield 之后的代码

再简单理解就是

- **yield 前半段用来表示 `__enter__()`**
- **yield 后半段用来表示 `__exit__()`**

```py
import contextlib

@contextlib.contextmanager
def make_context():
    print("enter make_context")
    try:
        yield {}
    except RuntimeError as err:
        print(f"{err=}")

        
print("Normal")

with make_context() as value:
    print("in with")
    
# Normal
# enter make_context
# in with

print("RuntimeError")

with make_context() as value:
    raise RuntimeError("runtimeerror")
    
# RuntimeError
# enter make_context
# err=RuntimeError('runtimeerror')

print("Else Error")

with make_context() as value:
    raise ZeroDivisionError("0 不能作为分母")
    
# Else Error
# enter make_context
```

因为 contextmanager 继承自 ContextDecorator，所以也可以被用作函数修饰符

```py
import contextlib


@contextlib.contextmanager
def make_context():
    print("enter make_context")  # enter
    try:
        yield {}
    except RuntimeError as err:
        print(f"{err=}")
    finally:
        print("existing")  # exit


@make_context()
def normal():
    print("in normal")


@make_context()
def raise_error(err):
    raise err


if __name__ == "__main__":
    print("Normal:")
    normal()
    print("RuntimeError:")
    raise_error(RuntimeError("runtime error"))
    print("Else Error")
    raise_error(ValueError("value error"))
```

输出

![image-20231213171751340](C:\Users\chenx\AppData\Roaming\Typora\typora-user-images\image-20231213171751340.png)

### 原理

1. 因为 func() 已经是个生成器了嘛，所以运行 `__enter__()` 的时候，contextmanager 调用 `self.gen.next()` 会跑到 func 的 yield 处，停住挂起

2. 然后运行 with 语句体里面的语句
3. 跑完后运行 `__exit__()` 的时候，contextmanager 调用 `self.gen.next()` 会从 func 的 yield 的下一句开始一直到结束。

```py
class GeneratorContextManager(object):
    """Helper for @contextmanager decorator."""

    def __init__(self, gen):
        self.gen = gen # func

    def __enter__(self):
        try:
            return self.gen.next()
        except StopIteration:
            raise RuntimeError("generator didn't yield")

    def __exit__(self, type, value, traceback):
        if type is None:
            try:
                self.gen.next()
            except StopIteration:
                return
            else:
                raise RuntimeError("generator didn't stop")
        else:
            if value is None:
                # Need to force instantiation so we can reliably
                # tell if we get the same exception back
                value = type()
            try:
                self.gen.throw(type, value, traceback)
                raise RuntimeError("generator didn't stop after throw()")
            except StopIteration, exc:
                return exc is not value
            except:
                if sys.exc_info()[1] is not value:
                    raise


def contextmanager(func):
    @wraps(func)
    def helper(*args, **kwds):
        return GeneratorContextManager(func(*args, **kwds))
    return helper
```

## closing - 关闭打开的句柄

并不是所有的类都支持上下文管理器的 API，有一些遗留的类会使用一个 close 方法。

为了确保关闭句柄，需要使用 closing 为他创建一个上文管理器。

该模块主要是解决不能支持上下文管理器的类。

```py
import contextlib


class Http:
    def __init__(self):
        print("int init:")
        self.session = "open"

    def close(self):
        """
        关闭的方法必须叫 close
        """
        print("in close:")
        self.session = "close"


if __name__ == "__main__":
    with contextlib.closing(Http()) as http:
        print(f"inside session value:{http.session}")
    print(f"outside session value:{http.session}")

    with contextlib.closing(Http()) as http:
        print(f"inside session value:{http.session}")
        raise EnvironmentError("EnvironmentError")
    print(f"outside session value:{http.session}")
```

输出

<img src="C:\Users\chenx\AppData\Roaming\Typora\typora-user-images\image-20231213173150856.png" alt="image-20231213173150856" style="zoom: 50%;" />

可以看到即使程序出现了错误，最后也会执行 close 方法的内容。

看一眼下面的源码就知道 closing 干嘛了

```py
class closing(object):
    """Context to automatically close something at the end of a block.
    Code like this:
        with closing(<module>.open(<arguments>)) as f:
            <block>
    is equivalent to this:
        f = <module>.open(<arguments>)
        try:
            <block>
        finally:
            f.close()
    """
    def __init__(self, thing):
        self.thing = thing
    def __enter__(self):
        return self.thing
    def __exit__(self, *exc_info):
       self.thing.close()
```

这个 `contextlib.closing()` 会帮它加上 `__enter__()` 和 `__exit__()`，使其满足 with 的条件。然后 exit 里执行的就是对应类的 close 方法。

## suppress - 巧妙的回避错误

```py
contextlib.suppress(*exceptions)
```

另一个工具就是在 Python 3.4 中加入的 suppress 类。这个上下文管理工具背后的理念就是它可以**禁止任意数目的异常**。

假如我们想忽略 FileNotFoundError 异常。如果你书写了如下的上下文管理器，那么它不会正常运行。

```py
>>> with open("1.txt") as fobj:
...     for line in fobj:
...         print(line)
...
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
FileNotFoundError: [Errno 2] No such file or directory: '1.txt'
```

正如你所看到的，这个上下文管理器没有处理这个异常，如果你想忽略这个错误，你可以按照如下方式来做，

```py
>>> from contextlib import suppress
>>> with suppress(FileNotFoundError):
...     with open("1.txt") as fobj:
...         for line in fobj:
...             print(line)
```

在这段代码中，我们引入 suppress，然后将我们要忽略的异常传递给它，在这个例子中，就是 FileNotFoundError。如果你想运行这段代码，你将会注意到，文件不存在时，什么事情都没有发生，也没有错误被抛出。请注意，这个上下文管理器是可重用的。

## 例子数据库的自动提交和回滚

在编程中如果频繁的修改数据库，一味的使用类似 `try:… except..: rollback() raise e` 其实是不太好的.

```py
try:
    gift = Gift()
    gift.isbn = isbn
    ... 
    db.session.add(gift)
    db.session.commit()
except Exception as e:
    db.session.rollback()
    raise e
```

为了达到使用 with 语句的目的, 我们可以重写 db 所属的类:

```py
from flask_sqlalchemy import SQLAlchemy as _SQLALchemy


class SQLAlchemy(_SQLALchemy):
    @contextmanager
    def auto_commit(self):
        try:
            yield
            self.session.commit()
        except Exception as e:
            db.session.rollback()
            raise e
```

这时候, 在执行数据的修改的时候便可以:

```py
with db.auto_commit():
    gift = Gift()
    gift.isbn = isbndb.session.add(gift)
    db.session.add(gift)

with db.auto_commit():
    user = User()
    user.set_attrs(form.data)
    db.session.add(user)
```

上下文管理器很有趣，也很方便。我经常在自动测试中使用它们，例如，打开和关闭对话。现在，你应该可以使用 Python 内置的工具去创建你的上下文管理器。你还可以继续阅读 Python 关于 contextlib 的文档，那里有很多本文没有覆盖到的知识。
