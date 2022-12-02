---
title: "Python rich 库 - Progress Display"
date: 2022-12-02
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Progress Display

Rich 可以将持续更新信息的进度可视化。

显示的信息是可配置的，默认会显示 "任务 "的描述、进度条、完成百分比和预计剩余时间（a description of the ‘task’, a progress bar, percentage complete, and estimated time remaining）

Progress Display 显示支持多个任务，每个任务都有一个条和进度信息。你可以用它来跟踪工作在线程或进程中进行的并发任务。

To see how the progress display looks, try this from the command line:

```bash
python -m rich.progress
```

> Progress works with Jupyter notebooks, with the caveat that auto-refresh is disabled. You will need to explicitly call [`refresh()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.refresh) or set `refresh=True` when calling [`update()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.update). Or use the [`track()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.track) function which does a refresh automatically on each loop.

## Basic Usage

使用 [`track()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.track)，它接收一个序列（a sequence，such as a list or range object）和描述（可选）

The track function will yield values from the sequence and update the progress information on each iteration. Here’s an example:

```py
import time
from rich.progress import track

for i in track(range(20), description="Processing..."):
    time.sleep(1)  # Simulate work being done
```

## Advanced usage

如果你需要多任务功能，或者想要自定义进度条，你可以直接使用 [`Progress`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress) 类

Progress 实例拥有一些方法

- add task(s) with [`add_task()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.add_task)
- update progress with [`update()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.update)

The Progress class is designed to be used as a *context manager* which will start and stop the progress display automatically.

```py
import time

from rich.progress import Progress

with Progress() as progress:

    task1 = progress.add_task("[red]Downloading...", total=1000)
    task2 = progress.add_task("[green]Processing...", total=1000)
    task3 = progress.add_task("[cyan]Cooking...", total=1000)

    while not progress.finished:
        progress.update(task1, advance=0.5)
        progress.update(task2, advance=0.3)
        progress.update(task3, advance=0.9)
        time.sleep(0.02)
```

`total` 参数是必须完成的步骤数，以使进度达到 100%。在这种情况下，一个 step 对你的应用程序来说是任何有意义的；它可以是读取文件的字节数，或处理图像的数量（A *step* in this context is whatever makes sense for your application; it could be number of bytes of a file read, or number of images processed, etc.）

### Updating tasks

当你调用 [`add_task()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.add_task) 是你会得到一个 Task ID. Use this ID to call [`update()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.update) whenever you have completed some work, or any information has changed. 

Typically you will need to update `completed` every time you have completed a step. You can do this by updated `completed` directly or by setting `advance` which will add to the current `completed` value.

The [`update()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.update) method collects keyword arguments which are also associated with the task. Use this to supply any additional information you would like to render in the progress display. The additional arguments are stored in `task.fields` and may be referenced in [Column classes](https://rich.readthedocs.io/en/stable/progress.html#columns).

### Hiding tasks

通过修改 task 的 `visible` 值，你可以自由地显示或隐藏 task：calling [`add_task()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.add_task) with `visible=False`.

### Transient progress

一般情况下，当你退出 progress context manager (or call [`stop()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.stop)) 时，最后一次刷新的显示仍然在终端中，光标在下一行

You can also make the progress display disappear on exit by setting `transient=True` on the Progress constructor. 

Here’s an example:

```py
with Progress(transient=True) as progress:
    task = progress.add_task("Working", total=100)
    do_work(task)
```

Transient progress displays are useful if you want more minimal output in the terminal when tasks are complete.

### Indeterminate progress

当你添加一个任务时，它会自动启动，这意味着它将在 0% 的时候显示一个进度条，剩余时间将从当前时间计算出来。

如果在你开始更新进度之前要停留很长时间，效果就并不好了（你可能需要等待服务器的响应或计算目录中的文件）

在这些情况下，你可以用 `start=False` 或 `total=None` 来调用 `add_task()`，这将显示一个脉冲动画，让用户知道一些事情正在进行。这就是所谓的不确定的进度条 （Indeterminate progress）

当你有了步骤数后，你可以调用 `start_task()`，这将显示 0% 的进度条，然后像平常一样 `update()`

### Auto refresh

默认情况下，进度信息将每秒刷新 10 次

你可以通过 `Progress` 构造函数的 `refresh_per_second` 参数来设置刷新率。如果你知道你的更新不会那么频繁，你应该把这个参数设置为低于 10 的参数。

如果你的更新不是很频繁，你可能想完全禁用自动刷新，你可以通过在构造函数中设置 `auto_refresh=False` 来实现。如果你禁用了自动刷新，你将需要在更新任务后手动调用 `refresh()`

### Expand

进度条将只使用终端的宽度来显示任务信息

如果您在 `Progress` 构造函数上设置了 `expand` 参数，那么 Rich 将把进度条显示拉伸到全部可用宽度

### Columns

你可以通过 `Progress` 构造函数的位置参数来定制进度显示中的列。列被指定为一个格式字符串（ *format string*）或一个 `ProgressColumn` 对象。

格式字符串将以一个单一的值 "task "呈现，它将是一个 [`Task`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Task) instance。

例如，`"{task.description}"` 将在列中显示任务描述，而 `"{task.completed} of {task.total}"` 将显示总步骤中多少已经完成。

通过关键字参数传递给 ~rich.progress.Progress.update 的额外字段被存储在 task.fields 中。你可以用以下语法将它们添加到格式字符串中。`"extra info: {task.fields[extra]}"`.

The default columns are equivalent to the following:

```py
progress = Progress(
    TextColumn("[progress.description]{task.description}"),
    BarColumn(),
    TaskProgressColumn(),
    TimeRemainingColumn(),
)
```

To create a Progress with your own columns in addition to the defaults, use [`get_default_columns()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.get_default_columns):

```py
progress = Progress(
    SpinnerColumn(),
    *Progress.get_default_columns(),
    TimeElapsedColumn(),
)
```

The following column objects are available:

- [`BarColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.BarColumn) Displays the bar.
- [`TextColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.TextColumn) Displays text.
- [`TimeElapsedColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.TimeElapsedColumn) Displays the time elapsed.
- [`TimeRemainingColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.TimeRemainingColumn) Displays the estimated time remaining.
- [`MofNCompleteColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.MofNCompleteColumn) Displays completion progress as `"{task.completed}/{task.total}"` (works best if completed and total are ints).
- [`FileSizeColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.FileSizeColumn) Displays progress as file size (assumes the steps are bytes).
- [`TotalFileSizeColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.TotalFileSizeColumn) Displays total file size (assumes the steps are bytes).
- [`DownloadColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.DownloadColumn) Displays download progress (assumes the steps are bytes).
- [`TransferSpeedColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.TransferSpeedColumn) Displays transfer speed (assumes the steps are bytes.
- [`SpinnerColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.SpinnerColumn) Displays a “spinner” animation.
- [`RenderableColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.RenderableColumn) Displays an arbitrary Rich renderable in the column.

To implement your own columns, extend the [`ProgressColumn`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.ProgressColumn) class and use it as you would the other columns.

### Table Columns

Rich 为 Progress 实例中的任务建立了一个 `Table`。你可以通过在 `Column` 构造函数中指定 `table_column` 参数来定制该任务表的列的创建方式，该参数应该是一个 Column 实例。

下面的例子演示了一个进度条，其中描述占据了终端宽度的三分之一，而进度条占据了其余的三分之二。

```py
from time import sleep

from rich.table import Column
from rich.progress import Progress, BarColumn, TextColumn

text_column = TextColumn("{task.description}", table_column=Column(ratio=1))
bar_column = BarColumn(bar_width=None, table_column=Column(ratio=2))
progress = Progress(text_column, bar_column, expand=True)

with progress:
    for n in progress.track(range(100)):
        progress.print(n)
        sleep(0.1)
```

### Print / log

Progress 类将创建一个内部的 Console 对象，你可以通过 `progress.console` 访问。如果你打印或记录到这个控制台，输出将显示在 progress display 的上方。

```py
with Progress() as progress:
    task = progress.add_task("twiddling thumbs", total=10)
    for job in range(10):
        progress.console.print(f"Working on job #{job}")
        run_job(job)
        progress.advance(task)
```

If you have another Console object you want to use, pass it in to the [`Progress`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress) constructor. Here’s an example:

```py
from my_project import my_console

with Progress(console=my_console) as progress:
    my_console.print("[bold blue]Starting work!")
    do_work(progress)
```

### Redirecting stdout / stderr

为了避免破坏进度显示的视觉效果，Rich 会重定向 `stdout` 和 `stderr`，以便你可以使用内置的打印语句。这个功能默认是启用的，但你可以通过设置 `redirect_stdout` 或 `redirect_stderr` 为 `False` 来禁用。

### Customizing

如果Progress类没有提供你所需要的 progress display，你可以重写 `get_renderables` 方法。

For example, the following class will render a [`Panel`](https://rich.readthedocs.io/en/stable/reference/panel.html#rich.panel.Panel) around the progress display:

```py
from rich.panel import Panel
from rich.progress import Progress

class MyProgress(Progress):
    def get_renderables(self):
        yield Panel(self.make_tasks_table(self.tasks))
```

### Reading from a file

Rich 可以在读取文件时生成一个进度条。如果你调用 `open()`，它将返回一个上下文管理器，在你阅读时显示一个进度条。当你不能轻易修改进行读取的代码时，这一点特别有用。

The following example demonstrates how we might show progress when reading a JSON file:

```py
import json
import rich.progress

with rich.progress.open("data.json", "rb") as file:
    data = json.load(file)
print(data)
```

如果你已有一个 file object，你可以调用 `wrap_file()`，它返回一个包装你文件的上下文管理器，以便显示一个进度条。如果你使用这个函数，你将需要设置你期望读取的字节数或字符数。

Here’s an example that reads a url from the internet:

```py
from time import sleep
from urllib.request import urlopen

from rich.progress import wrap_file

response = urlopen("https://www.textualize.io")
size = int(response.headers["Content-Length"])

with wrap_file(response, size) as file:
    for line in file:
        print(line.decode("utf-8"), end="")
        sleep(0.1)
```

If you expect to be reading from multiple files, you can use [`open()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.open) or [`wrap_file()`](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress.wrap_file) to add a file progress to an existing Progress instance.

See cp_progress.py <https://github.com/willmcgugan/rich/blob/master/examples/cp_progress.py> for a minimal clone of the `cp` command which shows a progress bar as the file is copied.

## Multiple Progress

You can’t have different columns per task with a single Progress instance. However, you can have as many Progress instances as you like in a [Live Display](https://rich.readthedocs.io/en/stable/live.html#live). See [live_progress.py](https://github.com/willmcgugan/rich/blob/master/examples/live_progress.py) and [dynamic_progress.py](https://github.com/willmcgugan/rich/blob/master/examples/dynamic_progress.py) for examples of using multiple Progress instances.

## Example

See [downloader.py](https://github.com/willmcgugan/rich/blob/master/examples/downloader.py) for a realistic application of a progress display. This script can download multiple concurrent files with a progress bar, transfer speed and file size.
