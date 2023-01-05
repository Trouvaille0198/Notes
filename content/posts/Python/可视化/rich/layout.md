---
title: "Python rich 库 - Console"
date: 2022-12-02
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Layout

Rich 提供了一个 `Layout` 类，可用于将屏幕区域划分为若干部分，其中每个部分可包含独立的内容。它可以与 Live Display 一起使用，以创建全屏 "应用程序"，但也可以单独使用。

To see an example of a Layout, run the following from the command line:

```bash
python -m rich.layout
```

## Creating layouts

To define a layout, construct a Layout object and print it:

```py
from rich import print
from rich.layout import Layout

layout = Layout()
print(layout)
```

这将画出一个与终端一样大小的方框，并附有一些关于布局的信息。这个盒子是一个 "占位符"（placeholder），因为我们还没有向它添加任何内容。

在这之前，让我们通过调用 `split_column()` 方法来创建一个更有趣的布局，将布局分成两个子布局。

```py
layout.split_column(
    Layout(name="upper"),
    Layout(name="lower")
)
print(layout)
```

You should now see the screen area divided in to 3 portions; an upper half and a lower half that is split in to two quarters.

```bash
╭─────────────────────────────── 'upper' (84 x 13) ────────────────────────────────╮
│                                                                                  │
│                                                                                  │
│                                                                                  │
│                                                                                  │
│                                                                                  │
│          {'size': None, 'minimum_size': 1, 'ratio': 1, 'name': 'upper'}          │
│                                                                                  │
│                                                                                  │
│                                                                                  │
│                                                                                  │
│                                                                                  │
╰──────────────────────────────────────────────────────────────────────────────────╯
╭─────────── 'left' (42 x 14) ───────────╮╭────────── 'right' (42 x 14) ───────────╮
│                                        ││                                        │
│                                        ││                                        │
│                                        ││                                        │
│         {                              ││         {                              │
│             'size': None,              ││             'size': None,              │
│             'minimum_size': 1,         ││             'minimum_size': 1,         │
│             'ratio': 1,                ││             'ratio': 1,                │
│             'name': 'left'             ││             'name': 'right'            │
│         }                              ││         }                              │
│                                        ││                                        │
│                                        ││                                        │
│                                        ││                                        │
╰────────────────────────────────────────╯╰────────────────────────────────────────╯
```

You can continue to call split() in this way to create as many parts to the screen as you wish.

## Setting renderables

Layout 的第一个位置参数可以是任何 Rich renderable，它的大小将被调整为适合布局的区域。下面是我们如何将 "右边 "的布局划分为两个面板。

```py
layout["right"].split(
    Layout(Panel("Hello")),
    Layout(Panel("World!"))
)
```

You can also call [`update()`](https://rich.readthedocs.io/en/stable/reference/layout.html#rich.layout.Layout.update) to set or replace the current renderable:

```py
layout["left"].update(
    "The mystery of life isn't a problem to solve, but a reality to experience."
)
print(layout)
```

## Fixed size

你可以通过在 `Layout` 构造函数上设置 `size` 参数或直接设置属性，将一个布局设置为使用固定尺寸

```py
layout["upper"].size = 10
print(layout)
```

这将使 upper 的部分正好是 10 行，无论终端的大小如何。如果父级布局是水平的而不是垂直的，那么尺寸适用于字符数而不是行数。

## Ratio

除了固定的尺寸外，你还可以在构造函数上设置 `ratio` 比率参数或直接设置属性来制作一个灵活的布局。

比率定义了该布局相对于其他布局应占据多少屏幕。

例如，让我们重置尺寸，并将上层布局的比例设置为 2

```py
layout["upper"].size = None
layout["upper"].ratio = 2
print(layout)
```

这使得上面的布局占据了三分之二的空间。这是因为默认的比例是 1，使上层和下层布局的总和为 3。由于上层布局的比例为 2，它占用了三分之二的空间，剩下的三分之一留给下层布局。

一个设置了比例的布局也可能有一个最小尺寸，以防止它变得太小。例如，这里我们可以设置下层子布局的最小尺寸，这样它就不会收缩到超过 10 行。

```py
layout["lower"].minimum_size = 10
```

## Visibility

You can make a layout invisible by setting the `visible` attribute to False. Here’s an example:

```py
layout["upper"].visible = False
print(layout)
```

The top layout is now invisible, and the “lower” layout will expand to fill the available space. Set `visible` to True to bring it back:

```py
layout["upper"].visible = True
print(layout)
```

你可以用它来根据你的应用程序的配置来切换你的界面的一部分

## Tree

To help visualize complex layouts you can print the `tree` attribute which will display a summary of the layout as a tree:

```py
print(layout.tree)
```

## Example

See [fullscreen.py](https://github.com/willmcgugan/rich/blob/master/examples/fullscreen.py) for an example that combines [`Layout`](https://rich.readthedocs.io/en/stable/reference/layout.html#rich.layout.Layout) and [`Live`](https://rich.readthedocs.io/en/stable/reference/live.html#rich.live.Live) to create a fullscreen “application”.