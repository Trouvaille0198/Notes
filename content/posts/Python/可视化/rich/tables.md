---
title: "Python rich 库 - Progress Display"
date: 2022-12-02
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Tables

`Table` 类提供了多种向终端呈现表格数据的方法。

要渲染一个表格，构建一个 `Table` 对象，用 `add_column()` 添加列，用 `add_row()` 添加行，最后将其打印到控制台。

```py
from rich.console import Console
from rich.table import Table

table = Table(title="Star Wars Movies")

table.add_column("Released", justify="right", style="cyan", no_wrap=True)
table.add_column("Title", style="magenta")
table.add_column("Box Office", justify="right", style="green")

table.add_row("Dec 20, 2019", "Star Wars: The Rise of Skywalker", "$952,110,690")
table.add_row("May 25, 2018", "Solo: A Star Wars Story", "$393,151,347")
table.add_row("Dec 15, 2017", "Star Wars Ep. V111: The Last Jedi", "$1,332,539,889")
table.add_row("Dec 16, 2016", "Rogue One: A Star Wars Story", "$1,332,439,889")

console = Console()
console.print(table)
```

Rich will calculate the optimal column sizes to fit your content, and will wrap text to fit if the terminal is not wide enough to fit the contents.

> You are not limited to adding text in the `add_row` method. You can add anything that Rich knows how to render (including another table).

## Table Options

There are a number of keyword arguments on the Table constructor you can use to define how a table should look.

- `title` Sets the title of the table (text show above the table).
- `caption` Sets the table caption (text show below the table).
- `width` Sets the desired width of the table (disables automatic width calculation).
- `min_width` Sets a minimum width for the table.
- `box` Sets one of the [Box](https://rich.readthedocs.io/en/stable/appendix/box.html#appendix-box) styles for the table grid, or `None` for no grid.
- `safe_box` Set to `True` to force the table to generate ASCII characters rather than unicode.
- `padding` A integer, or tuple of 1, 2, or 4 values to set the padding on cells.
- `collapse_padding` If True the padding of neighboring cells will be merged.
- `pad_edge` Set to False to remove padding around the edge of the table.
- `expand` Set to True to expand the table to the full available size.
- `show_header` Set to True to show a header, False to disable it.
- `show_footer` Set to True to show a footer, False to disable it.
- `show_edge` Set to False to disable the edge line around the table.
- `show_lines` Set to True to show lines between rows as well as header / footer.
- `leading` Additional space between rows.
- `style` A Style to apply to the entire table, e.g. “on blue”
- `row_styles` Set to a list of styles to style alternating rows. e.g. `["dim", ""]` to create *zebra stripes*
- `header_style` Set the default style for the header.
- `footer_style` Set the default style for the footer.
- `border_style` Set a style for border characters.
- `title_style` Set a style for the title.
- `caption_style` Set a style for the caption.
- `title_justify` Set the title justify method (“left”, “right”, “center”, or “full”)
- `caption_justify` Set the caption justify method (“left”, “right”, “center”, or “full”)
- `highlight` Set to True to enable automatic highlighting of cell contents.

## Border Styles

你可以通过导入一个预设的 `Box` 对象并在 table 构造函数中设置 `box` 参数来设置边界样式。

Here’s an example that modifies the look of the Star Wars table:

```py
from rich import box
table = Table(title="Star Wars Movies", box=box.MINIMAL_DOUBLE_HEAD)
```

See [Box](https://rich.readthedocs.io/en/stable/appendix/box.html#appendix-box) for other box styles.

设置 `box=None` 来删除边框

`Table` 类提供了许多配置选项来设置表的外观和感觉，包括边框的呈现方式以及列的样式和对齐方式。

## Lines

默认情况下，table 只会在标题下显示一行。如果你想在所有行之间显示行，请在构造函数中添加 `show_lines=True`

你也可以通过在调用 `add_row()` 时设置 `end_section=True` 来强制在下一行显示一行，或者通过调用 `add_section()` 来在当前行和后续行之间添加一行。

## Empty Tables

打印一个没有列的表的结果是一个空白行。

如果你正在动态地建立一个表，并且数据源没有列，你可能想打印一些不同的东西，可以这样写：

```py
if table.columns:
    print(table)
else:
    print("[i]No data...[/i]")
```

## Adding Columns

你也可以通过在表构造函数的位置参数中添加指定列。

For example, we could construct a table with three columns like this:

```py
table = Table("Released", "Title", "Box Office", title="Star Wars Movies")
```

这允许你只指定该列的文本。如果你想设置其他属性，如宽度和样式，你可以添加一个 `Column` 类

```py
from rich.table import Column
table = Table(
    "Released",
    "Title",
    Column(header="Box Office", justify="right"),
    title="Star Wars Movies"
)
```

## Column Options

There are a number of options you can set on a column to modify how it will look.

- `header_style` Sets the style of the header, e.g. “bold magenta”.
- `footer_style` Sets the style of the footer.
- `style` Sets a style that applies to the column. You could use this to highlight a column by setting the background with “on green” for example.
- `justify` Sets the text justify to one of “left”, “center”, “right”, or “full”.
- `vertical` Sets the vertical alignment of the cells in a column, to one of “top”, “middle”, or “bottom”.
- `width` Explicitly set the width of a row to a given number of characters (disables automatic calculation).
- `min_width` When set to an integer will prevent the column from shrinking below this amount.
- `max_width` When set to an integer will prevent the column from growing beyond this amount.
- `ratio` Defines a ratio to set the column width. For instance, if there are 3 columns with a total of 6 ratio, and `ratio=2` then the column will be a third of the available size.
- `no_wrap` Set to True to prevent this column from wrapping.

## Vertical Alignment

你可以通过设置列的 `vertical` 参数来定义该列的垂直对齐。你也可以通过用 `Align` 类来包装你的文本或可渲染的内容，在每一个单元格中实现这一功能

```py
table.add_row(Align("Title", vertical="middle"))
```

## Grids

`Table` 类也可以成为一个很棒的布局工具。如果你禁用了页眉（header）和边框，你可以用它来定位终端内的内容。

替代的构造函数 `grid()` 可以为你创建这样一个表格。

例如，下面的代码显示了两段文字，它们在终端的左边和右边的边缘上都对齐了一行。

```py
from rich import print
from rich.table import Table

grid = Table.grid(expand=True)
grid.add_column()
grid.add_column(justify="right")
grid.add_row("Raising shields", "[bold magenta]COMPLETED [green]:heavy_check_mark:")

print(grid)
```

