---
title: "Python rich 库 - Style"
date: 2022-12-01
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Styles

In various places in the Rich API you can set a “style” which defines the color of the text and various attributes such as bold, italic etc. 

A style may be given as **a string containing a *style definition*** or as **an instance of a [`Style`](https://rich.readthedocs.io/en/stable/reference/style.html#rich.style.Style) class**.

## Defining Styles

**A style definition is a string containing one or more words to set colors and attributes.**

使用 256 种 [Standard Colors](https://rich.readthedocs.io/en/stable/appendix/colors.html#appendix-colors) 之一的颜色设置**前景色**

For example, to print “Hello” in magenta:

```py
console.print("Hello", style="magenta")
```

也可以直接提供颜色号码 (0 到 255 中的 integer)，并使用  `"color(<number>)"` 语法.

The following will give the equivalent output:

```py
console.print("Hello", style="color(5)")
```

Alternatively you can use a **CSS-like syntax** to specify a color with a “#” followed by three pairs of hex characters, or in **RGB form** with three decimal integers. 

The following two lines both print “Hello” in the same color (purple):

```py
console.print("Hello", style="#af00ff")
console.print("Hello", style="rgb(175,0,255)")
```

> Some terminals only support 256 colors. Rich will attempt to pick the closest color it can if your color isn’t available.

在 “on” 后面添加一种颜色，可以用来设置**背景色**

```py
console.print("DANGER!", style="red on white")
```

使用 **`"default"`** 可以让前景色与终端风格一致；当然背景色也支持 `default`，so the style of `"default on default"` is what your terminal starts with.

一些 styles：

- `"bold"` or `"b"` for bold text.
- `"blink"` for text that flashes (use this one sparingly).
- `"blink2"` for text that flashes rapidly (not supported by most terminals).
- `"conceal"` for *concealed* text (not supported by most terminals).
- `"italic"` or `"i"` for italic text (not supported on Windows).
- `"reverse"` or `"r"` for text with foreground and background colors reversed.
- `"strike"` or `"s"` for text with a line through it.
- `"underline"` or `"u"` for underlined text.

Rich also supports the following styles, which are not well supported and may not display in your terminal:

- `"underline2"` or `"uu"` for doubly underlined text.
- `"frame"` for framed text.
- `"encircle"` for encircled text.
- `"overline"` or `"o"` for overlined text.

styles 和 coler 可以一起来使用：

```py
console.print("Danger, Will Robinson!", style="blink bold red underline on white")
```

### not

在 style 属性前加个 “not” 能让该 style 失效，This can be used to turn off styles if they overlap.

```
console.print("foo [not bold]bar[/not bold] baz", style="bold")
```

This will print “foo” and “baz” in bold, but “bar” will be in normal text.

### link

style 的 `"link"` 属性会把文字变成超链接

`"link"` 后面得要跟一个 URL

The following example will make a clickable link:

```py
console.print("Google", style="link https://google.com")
```

> If you are familiar with HTML you may find applying links in this way a little odd, but the terminal considers a link to be another attribute just like bold, italic etc.

## Style Class

创建 `Style` 类的实例以复用 style

```py
from rich.style import Style
danger_style = Style(color="red", blink=True, bold=True)
console.print("Danger, Will Robinson!", style=danger_style)
```

It is slightly quicker to construct a Style class like this, since a style definition takes a little time to parse – but only on the first call, as Rich will cache parsed style definitions.

可以以将两个 style 对象相加，即可获得一个同时拥有两者配置的新 style 对象

```py
from rich.console import Console
from rich.style import Style
console = Console()

base_style = Style.parse("cyan")
console.print("Hello, World", style = base_style + Style(underline=True))
```

You can parse a style definition explicitly with the [`parse()`](https://rich.readthedocs.io/en/stable/reference/style.html#rich.style.Style.parse) method, which accepts the style definition and returns a Style instance. For example, the following two lines are equivalent:

```py
style = Style(color="magenta", bgcolor="yellow", italic=True)
style = Style.parse("italic magenta on yellow")
```

## Style Themes

If you re-use styles it can be a maintenance headache if you ever want to modify an attribute or color – you would have to change every line where the style is used. Rich provides a [`Theme`](https://rich.readthedocs.io/en/stable/reference/theme.html#rich.theme.Theme) class which you can use to define custom styles that you can refer to by name. That way you only need to update your styles in one place.

Style themes 能让代码变得更加语义化（semantic）, for instance a style called `"warning"` better expresses intent that `"italic magenta underline"`.

To use a style theme, construct a [`Theme`](https://rich.readthedocs.io/en/stable/reference/theme.html#rich.theme.Theme) instance and pass it to the [`Console`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console) constructor. Here’s an example:

```py
from rich.console import Console
from rich.theme import Theme
custom_theme = Theme({
    "info": "dim cyan",
    "warning": "magenta",
    "danger": "bold red"
})
console = Console(theme=custom_theme)
console.print("This is information", style="info")
console.print("[warning]The pod bay doors are locked[/warning]")
console.print("Something terrible happened!", style="danger")
```

> style names must be lower case, start with a letter, and only contain letters or the characters `"."`, `"-"`, `"_"`.

### Customizing Defaults

`Theme` 类会继承 Rich 内置的默认 style，如果你自定义的 theme 包含了已经存在的 style名字，这将会直接覆盖掉默认值，这个特性允许你自定的更改默认值

For instance, here’s how you can change how Rich highlights numbers:

```py
from rich.console import Console
from rich.theme import Theme
console = Console(theme=Theme({"repr.number": "bold green blink"}))
console.print("The total is 128")
```

You can **disable** inheriting the default theme by setting `inherit=False` on the [`rich.theme.Theme`](https://rich.readthedocs.io/en/stable/reference/theme.html#rich.theme.Theme) constructor.

:heart: To see the default theme, run the following commands:

```bash
python -m rich.theme
python -m rich.default_styles
```

### Loading Themes

你可以在额外的 config 文件中定义 style

```toml
[styles]
info = dim cyan
warning = magenta
danger = bold red
```

 使用 [`read()`](https://rich.readthedocs.io/en/stable/reference/theme.html#rich.theme.Theme.read) 方法读取这些文件