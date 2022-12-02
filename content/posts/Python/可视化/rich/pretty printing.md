---
title: "Python rich 库 - Pretty Printing"
date: 2022-12-02
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Pretty Printing

除了语法高亮，Rich 还会为容器类型（list, dict, set）进行格式化

Run the following command to see an example of pretty printed output:

```bash
python -m rich.pretty
```

## pprint method

[`pprint()`](https://rich.readthedocs.io/en/stable/reference/pretty.html#rich.pretty.pprint) 方法 提供了一些参数用来调整对象的打印方式

```py
>>> from rich.pretty import pprint
>>> pprint(locals())
```

### Indent guides

Indent guides 设置可以高亮锁紧部分，使我们更容易阅读更深层次的嵌套输出。

pprint 方法默认启用缩进指南。你可以设置 `indent_guides=False` 来禁用这个功能。

### Expand all

Rich 在扩展数据结构方面是相当保守的，它将尽量在每一行中容纳更多的数据。你可以通过设置 `expand_all=True` 来告诉 Rich 完全展开所有数据结构。

```py
>>> pprint(["eggs", "ham"], expand_all=True)
```

### Truncating pretty output

长数据结构可能难以阅读，需要滚动页面才能找到自己想要的数据；Rich 可以截断容器和长字符串，让你在不影响终端的情况下获得概览

如果您将 `max_length` 参数设置为一个整数

- 超过长度的**容器**类型将会被截断；并显示一个省略号 “......” 以及未显示的元素数量。

```py
>>> pprint(locals(), max_length=2)
```

- 超过长度的 **str** 类型将会被截断，并显示 “+” 号以及未显示的字符数量

```py
>>> pprint("Where there is a Will, there is a Way", max_string=21)
```

## Pretty renderable

`Pretty` 类用于来将 pretty printing data 插入到另一个可渲染数据中。

```py
from rich import print
from rich.pretty import Pretty
from rich.panel import Panel

pretty = Pretty(locals())
panel = Panel(pretty)
print(panel)
```

There are a large number of options to tweak the pretty formatting, See the [`Pretty`](https://rich.readthedocs.io/en/stable/reference/pretty.html#rich.pretty.Pretty) reference for details.

## Rich Repr Protocol

Rich 能够对任何输出进行语法高亮，但格式化只限于内建容器（built-in containers）、dataclasses 和其他 Rich 知道的对象，例如由 attrs 库生成的对象。要将 Rich 的格式化功能添加到自定义对象中，你可以实现 rich repr protocol

Run the following command to see an example of what the Rich repr protocol can generate:

```bash
python -m rich.repr
```

First, let’s look at a class that might benefit from a Rich repr:

```py
class Bird:
    def __init__(self, name, eats=None, fly=True, extinct=False):
        self.name = name
        self.eats = list(eats) if eats else []
        self.fly = fly
        self.extinct = extinct

    def __repr__(self):
        return f"Bird({self.name!r}, eats={self.eats!r}, fly={self.fly!r}, extinct={self.extinct!r})"

BIRDS = {
    "gull": Bird("gull", eats=["fish", "chips", "ice cream", "sausage rolls"]),
    "penguin": Bird("penguin", eats=["fish"], fly=False),
    "dodo": Bird("dodo", eats=["fruit"], fly=False, extinct=True)
}
print(BIRDS)
```

The result of this script would be:

```bash
{'gull': Bird('gull', eats=['fish', 'chips', 'ice cream', 'sausage rolls'], fly=True, extinct=False), 'penguin': Bird('penguin', eats=['fish'], fly=False, extinct=False), 'dodo': Bird('dodo', eats=['fruit'], fly=False, extinct=True)}
```

输出过长，难以阅读。repr 字符串的信息量很大，但有点冗长，因为它们包括默认参数。如果我们用 Rich 来打印，情况就会有一些改善：

```py
{
    'gull': Bird('gull', eats=['fish', 'chips', 'ice cream', 'sausage rolls'],
fly=True, extinct=False),
    'penguin': Bird('penguin', eats=['fish'], fly=False, extinct=False),
    'dodo': Bird('dodo', eats=['fruit'], fly=False, extinct=True)
}
```

这样还是会有些冗余和换行

We can solve both these issues by adding the following `__rich_repr__` method:

```py
def __rich_repr__(self):
    yield self.name
    yield "eats", self.eats
    yield "fly", self.fly, True
    yield "extinct", self.extinct, False
```

Now if we print the same object with Rich we would see the following:

```py
{
    'gull': Bird(
        'gull',
        eats=['fish', 'chips', 'ice cream', 'sausage rolls']
    ),
    'penguin': Bird('penguin', eats=['fish'], fly=False),
    'dodo': Bird('dodo', eats=['fruit'], fly=False, extinct=True)
}
```

参数的默认值被忽略，输出更好看了。The output remains readable even if we have less room in the terminal, or our objects are part of a deeply nested data structure:

```py
{
    'gull': Bird(
        'gull',
        eats=[
            'fish',
            'chips',
            'ice cream',
            'sausage rolls'
        ]
    ),
    'penguin': Bird(
        'penguin',
        eats=['fish'],
        fly=False
    ),
    'dodo': Bird(
        'dodo',
        eats=['fruit'],
        fly=False,
        extinct=True
    )
}
```

You can add a `__rich_repr__` method to **any class** to enable the Rich formatting. 这个方法应该返回一个 tuple 的迭代器，当然你可以返回 tuple 列表，但是使用 `yield` 构建生成器是更好的选择。

每个 tuple 描述一个属性

- `yield value` will generate a **positional argument**.
- `yield name, value` will generate a **keyword argument**.
- `yield name, value, default` will generate a **keyword argument *if* `value` is not equal to `default`**.

If you use `None` as the `name`, then it will be treated as a positional argument as well, in order to support having `tuple` positional arguments.

你也可以让 Rich 生成 angular bracket 风格的 repr，这往往用于没有简单方法重新创建对象的构造函数的情况（where there is no easy way to recreate the object’s constructor）。要做到这一点，请在你的 `__rich_repr__` 方法之后立即将函数属性 "angular "设置为True。比如说。

```py
__rich_repr__.angular = True
```

This will change the output of the Rich repr example to the following:

```py
{
    'gull': <Bird 'gull' eats=['fish', 'chips', 'ice cream', 'sausage rolls']>,
    'penguin': <Bird 'penguin' eats=['fish'] fly=False>,
    'dodo': <Bird 'dodo' eats=['fruit'] fly=False extinct=True>
}
```

你可以将 `__rich_repr__` 方法添加到第三方库中，而不需要将 Rich 作为一个依赖项。如果没有安装 Rich，那么就不会有任何问题。希望将来会有更多的第三方库采用 Rich repr 方法。

### Typing

If you want to type the Rich repr method you can import and return `rich.repr.Result`, which will help catch logical errors:

```py
import rich.repr


class Bird:
    def __init__(self, name, eats=None, fly=True, extinct=False):
        self.name = name
        self.eats = list(eats) if eats else []
        self.fly = fly
        self.extinct = extinct

    def __rich_repr__(self) -> rich.repr.Result:
        yield self.name
        yield "eats", self.eats
        yield "fly", self.fly, True
        yield "extinct", self.extinct, False
```

### Automatic Rich Repr

如果参数的名称与你的属性相同，Rich可以自动生成一个 repr。

要自动建立一个rich repr，请使用 `auto()` 类装饰器。

```py
import rich.repr

@rich.repr.auto
class Bird:
    def __init__(self, name, eats=None, fly=True, extinct=False):
        self.name = name
        self.eats = list(eats) if eats else []
        self.fly = fly
        self.extinct = extinct


BIRDS = {
    "gull": Bird("gull", eats=["fish", "chips", "ice cream", "sausage rolls"]),
    "penguin": Bird("penguin", eats=["fish"], fly=False),
    "dodo": Bird("dodo", eats=["fruit"], fly=False, extinct=True)
}
from rich import print
print(BIRDS)
```

Note that the decorator will also create a __repr__, so you will get an auto-generated repr even if you don’t print with Rich.

If you want to auto-generate the angular type of repr, then set `angular=True` on the decorator:

```py
@rich.repr.auto(angular=True)
class Bird:
    def __init__(self, name, eats=None, fly=True, extinct=False):
        self.name = name
        self.eats = list(eats) if eats else []
        self.fly = fly
        self.extinct = extinct
```

