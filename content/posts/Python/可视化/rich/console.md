---
title: "Python rich 库 - Console"
date: 2022-11-30
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Console

console 通常作为单例模式存在，所以你可以为 console 的配置专门创建一个文件 `console.py`：

```py
from rich.console import Console
console = Console()
```

然后在任何需要的地方引用之

```py
from <my_project>.console import console
```

## Attributes

渲染时，Rich 可以自动地检查一些所需参数，比如这些：

- [`size`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.size) is the current dimensions of the terminal (which may change if you resize the window).
- [`encoding`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.encoding) is the default encoding (typically “utf-8”).
- [`is_terminal`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.is_terminal) is a boolean that indicates if the Console instance is writing to a terminal or not.
- [`color_system`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.color_system) is a string containing the Console color system (see below).

这些参数当然也可以在 console 实例化时传进去

## Color systems

You can set `color_system` to one of the following values:

- `None` 不要颜色
- `"auto"` auto-detect
- `"standard"` Can display 8 colors, with normal and bright variations, for 16 colors in total.
- `"256"` Can display the 16 colors from “standard” plus a fixed palette of 240 colors.
- `"truecolor"` Can display 16.7 million colors, which is likely all the colors your monitor can display.
- `"windows"` Can display 8 colors in legacy Windows terminal. New Windows terminal can display “truecolor”.

> 谨慎地设置 `color_system` 参数，避免设置 terminal 不支持的更高颜色，这会让输出完全不可读，最好的方法是别设置

## Printing

`print()` 方法很聪明，它能根据 `__str__` 方法将对象转换为 `str`，并施以简单的语法高亮

它还支持一些语法标记的渲染：

```py
console.print([1, 2, 3])
console.print("[blue underline]Looks like a link")
console.print(locals())
console.print("FOO", style="white on blue")
```

可以使用终端协议（Console Protocol）为对象提供自定义渲染

## Logging

The [`log()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.log) methods offers the same capabilities as print, but adds some features useful for debugging a running application.

logging 会把当前时间展示在最左边，把调用所在的文件和行号放在最右边

```py
>>> console.log("Hello, World!")
```

`log()` 方法拥有一个 `log_locals` 参数，如果将其设为 `True`，Rich 会把调用处的局部变量打印出来

## Printing JSON

`print_json()` 方法会尝试把一个字符串格式化成 json 打印出来：

```py
console.print_json('[false, true, null, "foo"]')
```

You can also *log* json by logging a [`JSON`](https://rich.readthedocs.io/en/stable/reference/json.html#rich.json.JSON) object:

```py
from rich.json import JSON
console.log(JSON('["foo", "bar"]'))
```

由于打印 json 是一个频繁的需求，你也可以从 main namespace 引入 `print_json`

```py
from rich import print_json
```

You can also pretty print JSON via the command line with the following:

```bash
python -m rich.json cats.json
```

## Low level output

[`out()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.out) 方法输出级别更低，它将所有参数以字符串形式输出，并且不施以美化、标记语法，但会施以基本的格式化（包括一丢丢高亮）

```py
>>> console.out("Locals", locals())
```

## Rules

[`rule()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.rule) 方法会绘制一条水平线，中间嵌入标题（可选）

```
>>> console.rule("[bold red]Chapter 2")
```

```
─────────────────────────────── Chapter 2 ───────────────────────────────
```

The rule method also accepts a `style` parameter to set the style of the line, and an `align` parameter to align the title (“left”, “center”, or “right”).

## Status

Rich can display a status message with a ‘spinner’ animation that won’t interfere with regular console output. Run the following command for a demo of this feature:

```bash
python -m rich.status
```

To display a status message, call [`status()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.status) with the status message (which may be a string, Text, or other renderable). The result is a context manager which starts and stop the status display around a block of code. Here’s an example:

```py
with console.status("Working..."):
    do_work()
```

You can change the spinner animation via the `spinner` parameter:

```py
with console.status("Monkeying around...", spinner="monkey"):
    do_work()
```

Run the following command to see the available choices for `spinner`:

```py
python -m rich.spinner
```

## Justify / Alignment

`print()` 和 `log()` 方法都拥有一个 `justify` 参数，只能设置为 “default”, “left”, “right”, “center”, 或 “full”

The default for `justify` is `"default"` which will generally look the same as `"left"` but with a subtle difference. **Left justify will pad the right of the text with spaces, while a default justify will not.** 

You will only notice the difference if you set a background color with the `style` argument. 

The following example demonstrates the difference:

```py
from rich.console import Console

console = Console(width=20)

style = "bold white on blue"
console.print("Rich", style=style)
console.print("Rich", style=style, justify="left")
console.print("Rich", style=style, justify="center")
console.print("Rich", style=style, justify="right")
```

## Overflow

当要打印的文字大于可用空间时，溢出（overflow）就发生了。Overflow may occur if you print long ‘words’ such as URLs for instance, or if you have text inside a panel or table cell with restricted space.

`print()` 提供 `overflow` 参数，只能设置为 “fold”, “crop”, “ellipsis”, 或 “ignore” ；

- 默认值 “fold” 会溢出到下一行（下下一行……）
- “crop” 直接截断多余的文字部分
- “ellipsis” 在 “crop” 的基础上添加一段省略号
- “ignore” allows text to run on to the next line. In practice this will look the same as “crop” unless you also set `crop=False` when calling [`print()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.print).

## Console style

`style` 参数用来风格化输出

默认 `style` 为 None，意味着没有多余的 style

```py
from rich.console import Console
blue_console = Console(style="white on blue")
blue_console.print("I'm blue. Da ba dee da ba di.")
```

## Soft Wrapping

Rich word wraps text you print by inserting line breaks. You can disable this behavior by setting `soft_wrap=True` when calling [`print()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.print). 

With *soft wrapping* enabled any text that doesn’t fit will run on to the following line(s), just like the built-in `print`.

## Cropping

The [`print()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.print) method has a boolean `crop` argument. 

The default value for crop is True which tells Rich to **crop any content that would otherwise run on to the next line**. 

You generally don’t need to think about cropping, as Rich will resize content to fit within the available width.

> Cropping is automatically disabled if you print with `soft_wrap=True`.

## Input

`input()` 方法使用起来与自带的 `input()` 类似

For example, here’s a colorful prompt with an emoji:

```py
from rich.console import Console
console = Console()
console.input("What is [i]your[/i] [bold red]name[/]? :smiley: ")
```

If Python’s builtin [`readline`](https://docs.python.org/3/library/readline.html#module-readline) module is previously loaded, elaborate line editing and history features will be available.

## Exporting

Console 可以导出任何传入的数据，无论是 text，svg 还是 html

在实例化 console 时传入 `record=True`，即可开启导出，它会为 `print()` 与 `log()` 的所有数据保存一份副本

```py
from rich.console import Console
console = Console(record=True)
```

调用 `export_text()`, `export_svg()` 或 `export_html()` 以获取 str 格式的导出

调用 `save_text()`, `save_svg()` 或 `save_html()` 以写入文件

### Exporting SVGs

When using [`export_svg()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.export_svg) or [`save_svg()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.save_svg), the width of the SVG will match the width of your terminal window (in terms of characters), while the height will scale automatically to accommodate the console output.

You can open the SVG in a web browser. You can also insert it in to a webpage with an `<img>` tag or by copying the markup in to your HTML.

The image below shows an example of an SVG exported by Rich.

![_images/svg_export.svg](https://rich.readthedocs.io/en/stable/_images/svg_export.svg)

ou can customize the theme used during SVG export by importing the desired theme from the `rich.terminal_theme` module and passing it to [`export_svg()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.export_svg) or [`save_svg()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.save_svg) via the `theme` parameter:

```py
from rich.console import Console
from rich.terminal_theme import MONOKAI

console = Console(record=True)
console.save_svg("example.svg", theme=MONOKAI)
```

Alternatively, you can create a theme of your own by constructing a `rich.terminal_theme.TerminalTheme` instance yourself and passing that in.

## Error console

Console 实例默认将输出写入到 `sys.stdout`（这也是为什么你能在终端看到输出的原因）

如果在实例化时设置了 `stderr=True`，Rich 会写入到 `sys.stderr`；You may want to use this to create an *error console* so you can split error messages from regular output. 

```py
from rich.console import Console
error_console = Console(stderr=True)
```

You might also want to set the `style` parameter on the Console to make error messages visually distinct. Here’s how you might do that:

```py
error_console = Console(stderr=True, style="bold red")
```

## File output

实例化 console 时传入 `file` 参数可以让 console 写入文件中，You could use this to write to a file without the output ever appearing on the terminal.

```py
import sys
from rich.console import Console
from datetime import datetime

with open("report.txt", "wt") as report_file:
    console = Console(file=report_file)
    console.rule(f"Report Generated {datetime.now().ctime()}")
```

Note that when writing to a file you may want to explicitly set the `width` argument if you don’t want to wrap the output to the current console width.

## Capturing output

There may be situations where you want to *capture* the output from a Console rather than writing it directly to the terminal. 

You can do this with the [`capture()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.capture) method which returns a context manager. 

On exit from this context manager, call [`get()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Capture.get) to return the string that would have been written to the terminal.

```py
from rich.console import Console
console = Console()
with console.capture() as capture:
    console.print("[bold red]Hello[/] World")
str_output = capture.get()
```

An alternative way of capturing output is to set the Console file to a [`io.StringIO`](https://docs.python.org/3/library/io.html#io.StringIO). This is the recommended method if you are testing console output in unit tests. Here’s an example:

```py
from io import StringIO
from rich.console import Console
console = Console(file=StringIO())
console.print("[bold red]Hello[/] World")
str_output = console.file.getvalue()
```

## Paging

如果你的输出很长，可以用 `pager()` 来分页，A pager is typically an application on your operating system which will at least support pressing a key to scroll, but will often support scrolling up and down through the text and other features.

[`pager()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.pager) returns a context manager. When the pager exits, anything that was printed will be sent to the pager. 

```python
from rich.__main__ import make_test_card
from rich.console import Console

console = Console()
with console.pager():
    console.print(make_test_card())
```

Since the default pager on most platforms don’t support color, Rich will strip color from the output. If you know that your pager supports color, you can set `styles=True` when calling the [`pager()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.pager) method.

>  Rich will look at `MANPAGER` then the `PAGER` environment variables (`MANPAGER` takes priority) to get the pager command. On Linux and macOS you can set one of these to `less -r` to enable paging with ANSI styles.

## Alternate screen

> experimental

Terminals support an **‘alternate screen’ mode** which is separate from the regular terminal and allows for full-screen applications that leave your stream of input and commands intact. 

Rich supports this mode via the [`set_alt_screen()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.set_alt_screen) method, although it is recommended that you use [`screen()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.screen) which returns a context manager that disables alternate mode on exit.

Here’s an example of an alternate screen:

```py
from time import sleep
from rich.console import Console

console = Console()
with console.screen():
    console.print(locals())
    sleep(5)
```

The above code will display a pretty printed dictionary on the alternate screen before returning to the command prompt after 5 seconds.

You can also provide a renderable to [`screen()`](https://rich.readthedocs.io/en/stable/reference/console.html#rich.console.Console.screen) which will be displayed in the alternate screen when you call `update()`.

Here’s an example:

```py
from time import sleep

from rich.console import Console
from rich.align import Align
from rich.text import Text
from rich.panel import Panel

console = Console()

with console.screen(style="bold white on red") as screen:
    for count in range(5, 0, -1):
        text = Align.center(
            Text.from_markup(f"[blink]Don't Panic![/blink]\n{count}", justify="center"),
            vertical="middle",
        )
        screen.update(Panel(text))
        sleep(1)
```

Updating the screen with a renderable allows Rich to crop the contents to fit the screen without scrolling.

For a more powerful way of building full screen interfaces with Rich, see [Live Display](https://rich.readthedocs.io/en/stable/live.html#live).

> If you ever find yourself stuck in alternate mode after exiting Python code, type `reset` in the terminal

## Terminal detection

如果 Rich 意识到它不在向终端输出的话，他会删减掉输出中的控制字符（control codes）

If you want to write control codes to a regular file then set `force_terminal=True` on the constructor.

Letting Rich auto-detect terminals is useful as it will write plain text when you pipe output to a file or other application.

## Interactive mode

不输出到终端的情况下，Rich 会将进度条、状态指示器等动画全部移除，实例化时设置 `force_interactive=True` 参数就可以取消这一特性

> Some CI systems support ANSI color and style but not anything that moves the cursor or selectively refreshes parts of the terminal. For these you might want to set `force_terminal` to `True` and `force_interactive` to `False`.

## Environment variables

Rich 可以识别并遵循一些环境变量的设置

- Setting the environment variable `TERM` to `"dumb"` or `"unknown"` will disable color/style and some features that require moving the cursor, such as progress bars.
- If the environment variable `NO_COLOR` is set, Rich will disable all color in the output.
- If `width`/`height` arguments are not explicitly provided as arguments to `Console` then the environment variables `COLUMNS`/`LINES` can be used to set the console width/height. 
    - `JUPYTER_COLUMNS`/`JUPYTER_LINES` behave similarly and are used in Jupyter.