---
title: "Python abc 库"
date: 2022-11-30
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# abc

> 抽象基类 Abstract Base Class

官方文档：https://docs.python.org/zh-cn/3/library/abc.html

该模块提供了一个元类 [`ABCMeta`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABCMeta)，可以用来定义抽象类，另外还提供一个工具类 [`ABC`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABC)，可以用它以继承的方式定义抽象基类。

## 快速开始

```py
# BEGIN TOMBOLA_ABC

import abc

class Tombola(abc.ABC):  # <1>

    @abc.abstractmethod
    def load(self, iterable):  # <2>
        """Add items from an iterable."""

    @abc.abstractmethod
    def pick(self):  # <3>
        """Remove item at random, returning it.
        This method should raise `LookupError` when the instance is empty.
        """

    def loaded(self):  # <4>
        """Return `True` if there's at least 1 item, `False` otherwise."""
        return bool(self.inspect())  # <5>


    def inspect(self):
        """Return a sorted tuple with the items currently inside."""
        items = []
        while True:  # <6>
            try:
                items.append(self.pick())
            except LookupError:
                break
        self.load(items)  # <7>
        return tuple(sorted(items))


# END TOMBOLA_ABC
```

## 官方文档摘录

### *class* abc.ABC

一个使用 [`ABCMeta`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABCMeta) 作为元类的工具类。**抽象基类可以通过从 [`ABC`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABC) 派生来简单地创建**，这就避免了在某些情况下会令人混淆的元类用法，例如：

```py
from abc import ABC

class MyABC(ABC):
    pass
```

注意 [`ABC`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABC) 的类型仍然是 [`ABCMeta`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABCMeta)，因此继承 [`ABC`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABC) 仍然需要关注元类使用中的注意事项，比如可能会导致元类冲突的多重继承。当然你也可以直接使用 [`ABCMeta`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABCMeta) 作为元类来定义抽象基类，例如：

```py
from abc import ABCMeta

class MyABC(metaclass=ABCMeta):
    pass
```

#### *class* abc.ABCMeta

用于定义抽象基类（ABC）的元类。使用该元类以创建抽象基类。

抽象基类可以像 mix-in 类一样直接被子类继承。你也可以将不相关的具体类（包括内建类）和抽象基类注册为“抽象子类” —— 这些类以及它们的子类会被内建函数 [`issubclass()`](https://docs.python.org/zh-cn/3/library/functions.html#issubclass) 识别为对应的抽象基类的子类，但是该抽象基类不会出现在其 MRO（Method Resolution Order，方法解析顺序）中，抽象基类中实现的方法也不可调用（即使通过 [`super()`](https://docs.python.org/zh-cn/3/library/functions.html#super) 调用也不行）

使用 [`ABCMeta`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABCMeta) 作为元类创建的类含有如下方法：

##### `register` (*subclass*)

将“子类”注册为该抽象基类的“抽象子类”

```py
from abc import ABC

class MyABC(ABC):
    pass

MyABC.register(tuple)

assert issubclass(tuple, MyABC)
assert isinstance((), MyABC)
```

你也可以在虚基类中重载这个方法。

#### `__subclasshook__` (*subclass*)

> 必须定义为类方法

检查 *subclass* 是否是该抽象基类的子类。也就是说对于那些你希望定义为该抽象基类的子类的类，你不用对每个类都调用 [`register()`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABCMeta.register) 方法了，而是可以直接自定义 `issubclass` 的行为。（这个类方法是在抽象基类的 `__subclasscheck__()` 方法中调用的。）

该方法必须返回 `True`, `False` 或是 `NotImplemented`。

- 如果返回 `True`，*subclass* 就会被认为是这个抽象基类的子类
- 如果返回 `False`，无论正常情况是否应该认为是其子类，统一视为不是。
- 如果返回 `NotImplemented`，子类检查会按照正常机制继续执行。

定义 ABC 的示例：

```py
class Foo:
    def __getitem__(self, index):
        ...
    def __len__(self):
        ...
    def get_iterator(self):
        return iter(self)

class MyIterable(ABC):

    @abstractmethod
    def __iter__(self):
        while False:
            yield None

    def get_iterator(self):
        return self.__iter__()

    @classmethod
    def __subclasshook__(cls, C):
        if cls is MyIterable:
            if any("__iter__" in B.__dict__ for B in C.__mro__):
                return True
        return NotImplemented

MyIterable.register(Foo)
```

ABC `MyIterable` 定义了标准的迭代方法 [`__iter__()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#iterator.__iter__) 作为一个抽象方法。这里给出的实现仍可在子类中被调用。

`get_iterator()` 方法也是 `MyIterable` 抽象基类的一部分，但它并非必须被非抽象派生类所重载。

这里定义的 [`__subclasshook__()`](https://docs.python.org/zh-cn/3/library/abc.html#abc.ABCMeta.__subclasshook__) 类方法指明了任何在其 [`__dict__`](https://docs.python.org/zh-cn/3/library/stdtypes.html#object.__dict__) (或在其通过 [`__mro__`](https://docs.python.org/zh-cn/3/library/stdtypes.html#class.__mro__) 列表访问的基类) 中具有 [`__iter__()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#iterator.__iter__) 方法的类也都会被视为 `MyIterable`。

最后，末尾行使得 `Foo` 成为 `MyIterable` 的一个虚子类，即使它没有定义 [`__iter__()`](https://docs.python.org/zh-cn/3/library/stdtypes.html#iterator.__iter__) 方法（它使用了以 `__len__()` 和 `__getitem__()` 术语定义的旧式可迭代对象协议）。 请注意这将不会使 `get_iterator` 成为 `Foo` 的一个可用方法，它是被另外提供的。: