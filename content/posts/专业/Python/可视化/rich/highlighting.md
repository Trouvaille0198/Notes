---
title: "Python rich 库 - Highlighting"
date: 2022-12-01
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Highlighting

Rich 可以将 style 应用于你 `print()` 或 `log()` 的文本中。在默认设置下，Rich 会突出显示数字、字符串、集合 (collection)、bool、None，以及一些比较特殊的模式，如文件路径、URL 和 UUID。另外还有一些非默认的高亮显示，如 ISO8601 高亮显示日期和时间。

你可以通过在 `print()` 或 `log()` 上设置 `highlight=False` 来禁用高亮，或者在 Console 构造函数上设置`highlight=False` 来禁用高亮。

如果你在构造函数上禁用高亮，你仍然可以在 print/log 上用 `highlight=True` **选择性**地启用高亮。

## Custom Highlighters

If the default highlighting doesn’t fit your needs, you can define a **custom highlighter**. 

The easiest way to do this is to extend the [`RegexHighlighter`](https://rich.readthedocs.io/en/stable/reference/highlighter.html#rich.highlighter.RegexHighlighter) class which applies a style to any text matching a list of regular expressions.

Here’s an example which highlights text that looks like an email address:

```py
from rich.console import Console
from rich.highlighter import RegexHighlighter
from rich.theme import Theme

class EmailHighlighter(RegexHighlighter):
    """Apply style to anything that looks like an email."""

    base_style = "example."
    highlights = [r"(?P<email>[\w-]+@([\w-]+\.)+[\w-]+)"]


theme = Theme({"example.email": "bold magenta"})
console = Console(highlighter=EmailHighlighter(), theme=theme)
console.print("Send funds to money@example.org")
```

`highlight` 类变量应该包含一个正则表达式的 list。任何匹配表达式的组名都以 `base_style` 属性为前缀，并作为匹配文本的样式使用。

在上面的例子中，任何电子邮件地址都将应用 "example.email" 样式，我们已经在一个自定义的 Theme 中定义了这个样式。

在 Console 上设置 `highlighter` 将对你打印的所有文本应用相应的高亮（若启用）

你也可以通过将 `highlighter` 实例作为一个可调用对象来在更细的层次上使用 `highlighter`

For example, we could use the email highlighter class like this:

```py
console = Console(theme=theme)
highlight_emails = EmailHighlighter()
console.print(highlight_emails("Send funds to money@example.org"))
```

尽管  [`RegexHighlighter`](https://rich.readthedocs.io/en/stable/reference/highlighter.html#rich.highlighter.RegexHighlighter) 相当强大，但你也可以扩展它的基类 Highlighter 来实现自定义的高亮方案。它包含一个单独的方法 highlight，it contains a single method [`highlight`](https://rich.readthedocs.io/en/stable/reference/highlighter.html#rich.highlighter.Highlighter.highlight) which is passed the [`Text`](https://rich.readthedocs.io/en/stable/reference/text.html#rich.text.Text) to highlight.

Here’s a silly example that highlights every character with a different color:

```python
from random import randint

from rich import print
from rich.highlighter import Highlighter


class RainbowHighlighter(Highlighter):
    def highlight(self, text):
        for index in range(len(text)):
            text.stylize(f"color({randint(16, 255)})", index, index + 1)


rainbow = RainbowHighlighter()
print(rainbow("I must not fear. Fear is the mind-killer."))
```

