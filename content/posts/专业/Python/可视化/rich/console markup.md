---
title: "Python rich 库 - Console Markup"
date: 2022-12-01
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Console Markup

Rich 支持简单的 markup（标记语言），可以将 color 和 style 随意地插入文本

Run the following command to see some examples:

```bash
python -m rich.markup
```

## Syntax

Console markup uses a syntax inspired by [bbcode](https://en.wikipedia.org/wiki/BBCode). 

If you write the style in square brackets, e.g. `[bold red]`, that style will apply until it is *closed* with a corresponding `[/bold red]`.

Here’s a simple example:

```py
from rich import print
print("[bold red]alert![/bold red] Something happened")
```

If you don’t close a style, it will apply until the end of the string. Which is sometimes convenient if you want to style a single line. For example:

```py
print("[bold italic yellow on red blink]This text is impossible to read")
```

There is a shorthand for closing a style. If you omit the style name from the closing tag, Rich will close the last style. For example:

```py
print("[bold red]Bold and red[/] not bold or red")
```

These markup tags may be use in combination with each other and don’t need to be strictly nested. The following example demonstrates overlapping of markup tags:

```py
print("[bold]Bold[italic] bold and italic [/bold]italic[/italic]")
```

## Errors

若 markup 包含了以下错误，Rich 会抛出 `MarkupError`：

- 错配的标签（Mismatched tags）e.g. `"[bold]Hello[/red]"`
- No matching tag for implicit close, e.g. `"no tags[/]"`

## Links

Console markup 使用 `[link=URL]text[/link]` 语法输出超链接

```py
print("Visit my [link=https://www.willmcgugan.com]blog[/link]!")
```

If your terminal software supports hyperlinks, you will be able to click the word “blog” which will typically open a browser. If your terminal doesn’t support hyperlinks, you will see the text but it won’t be clickable.

## Escaping

Occasionally you may want to print something that Rich would interpret as markup. You can *escape* a tag by preceding it with a **backslash**. Here’s an example:

```py
>>> from rich import print
>>> print(r"foo\[bar]")
foo[bar]
```

Without the backslash, Rich will assume that `[bar]` is a tag and remove it from the output if there is no “bar” style.

> If you want to prevent the backslash from escaping the tag and output a literal backslash before a tag you can enter **two backslashes**.

The function [`escape()`](https://rich.readthedocs.io/en/stable/reference/markup.html#rich.markup.escape) will handle escaping of text for you.

Escaping is important if you construct console markup dynamically, with `str.format` or f strings (for example). 

Without escaping it may be possible to inject tags where you don’t want them. Consider the following function:

```py
def greet(name):
    console.print(f"Hello {name}!")
```

Calling `greet("Will")` will print a greeting, but if you were to call `greet("[blink]Gotcha![/blink]"])` then you will also get blinking text, which may not be desirable. The solution is to escape the arguments:

```py
from rich.markup import escape
def greet(name):
    console.print(f"Hello {escape(name)}!")
```

## Emoji

如果你添加了一条 emoji 代码，它将被同义的 unicode 替换

An emoji code consists of the name of the emoji surrounded be colons (:)

```py
>>> from rich import print
>>> print(":warning:")
⚠️
```

Some emojis have two variants, the “emoji” variant displays in full color, and the “text” variant displays in monochrome (whatever your default colors are set to). You can specify the variant you want by adding either “-emoji” or “-text” to the emoji code. Here’s an example:

```py
>>> from rich import print
>>> print(":red_heart-emoji:")
>>> print(":red_heart-text:")
```

To see a list of all the emojis available, run the following command:

```bash
python -m rich.emoji
```

## Rendering Markup

By default, Rich will render console markup when you explicitly pass a string to `print()` or implicitly when you embed a string in another renderable object such as [`Table`](https://rich.readthedocs.io/en/stable/reference/table.html#rich.table.Table) or [`Panel`](https://rich.readthedocs.io/en/stable/reference/panel.html#rich.panel.Panel).

Console markup is convenient, but you may wish to disable it if the syntax clashes with the string you want to print. You can do this by setting `markup=False` on the `print()` method or on the [`Console`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console) constructor.

## Markup API

You can convert a string to styled text by calling [`from_markup()`](https://rich.readthedocs.io/en/stable/reference/text.html#rich.text.Text.from_markup), which returns a [`Text`](https://rich.readthedocs.io/en/stable/reference/text.html#rich.text.Text) instance you can print or add more styles to.