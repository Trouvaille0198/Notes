---
title: "Python rich 库 - Rich Text"
date: 2022-12-01
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Rich Text

[`Text`](https://rich.readthedocs.io/en/stable/reference/text.html#rich.text.Text) 类允许你用 color 和 style 来标注字符串

你可以把 `Text` 类看成是一个带有标记的文本区域的字符串；与内建的 `str` 不同，`Text` 实例是可变的，大多数方法都是就地操作，而不是返回一个新的实例。

给 `Text` 添加样式的一种方法是 `stylize()` 方法，它将一个 style 应用于开始和结束的偏移量

```py
from rich.console import Console
from rich.text import Text

console = Console()
text = Text("Hello, World!")
text.stylize("bold magenta", 0, 6)
console.print(text)
# print “Hello, World!” with the first word in bold magenta.
```

另外，你可以通过调用 `append()` 在 `Text` 最后添加一个 str 和 style 来构造风格化的文本。下面是一个例子。

```py
text = Text()
text.append("Hello", style="bold magenta")
text.append(" World!")
console.print(text)
```

如果你想使用已经用 ANSI 代码格式化的文本，调用 `from_ansi()` 将其转换为一个 `Text` 对象

```py
text = Text.from_ansi("\033[1mHello, World!\033[0m")
console.print(text.spans)
```

从部分中构建 `Text` 实例是一个常见的需求，Rich 为此提供了`assemble()`，它将 **strs** 或 **str - style pairs** 相结合，并返回一个 `Text` 实例

The follow example is equivalent to the code above:

```py
text = Text.assemble(("Hello", "bold magenta"), " World!")
console.print(text)
```

你可以用 `highlight_words()` 对文本中的给定字词应用一个 style，或者调用 `highlight_regex()` 来突出显示与正则表达式匹配的文本。

## Text attributes

The Text class has a number of parameters you can set on the constructor to modify how the text is displayed.

Text 类拥有许多参数，它们在实例化时被传入，定义了文本如何被显示

- `justify` should be “left”, “center”, “right”, or “full”, and will override default justify behavior.
- `overflow` should be “fold”, “crop”, or “ellipsis”, and will override default overflow.
- `no_wrap` prevents wrapping if the text is longer then the available width.
- `tab_size` Sets the number of characters in a tab.

在 Rich API 中，几乎所有地方都可以使用 Text 实例来代替普通字符串，这使你可以对文本在其他 Rich 渲染器中的渲染方式进行大量控制。

For instance, the following example right aligns text within a [`Panel`](https://rich.readthedocs.io/en/stable/reference/panel.html#rich.panel.Panel):

```py
from rich import print
from rich.panel import Panel
from rich.text import Text
panel = Panel(Text("Hello", justify="right"))
print(panel)
```

