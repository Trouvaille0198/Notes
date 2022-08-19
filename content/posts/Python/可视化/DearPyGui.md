---
title: "DearPyGui"
date: 2021-04-17
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# DearPyGui

## 认识

### 窗口 Windows

窗口用于保存控件

#### 创建方法

1. 由 `add_window()` 方法启动窗口并在结束调 `end()` 方法
2. 使用 `dearpygui.simple` 包和相应的窗口管理器（推荐）

```python
# method 1
from dearpygui.core import *

add_window("Tutorial")
add_text("This is some text on window 1")
end()

# method 2
from dearpygui.simple import *

with window("Tutorial##2"):
    add_text("This is some text on window 2")

start_dearpygui()
```

代码最终必须以 `start_dearpygui()` 方法结束

#### 主窗口

如何设置主窗口？

1. 使用 `start_dearpygui` 方法的 `primary_window` 参数

2. 使用 `set_primary_window` 方法

```python
start_dearpygui(primary_window="Tutorial")
```

#### 全局设置

```python
add_additional_font('三极中柔宋.ttf', 18, glyph_ranges='chinese_simplified_common')
```

### 控件 Widgets

控件必须有一个唯一的 `name`，默认情况下，`name` 会被当成 `label` 使用（视具体控件而定）

如何改变 `label`

- 使用 `##` 进行字符拼接，左边的字符串为要显示的名称，右边则为隐藏名称
- 通过设置 `label` 参数的值，显式设置要显示的名称

```python
# Display 'Apply'
add_button("Apply##1")  
add_button("Apply2", label="Apply") 
```

#### 值 value

每个输入窗口控件都有一个 `value`

- 可以在创建时使用 `default_value` 参数设置
- 可以在运行时通过 `set_value` 方法进行设置。
- 可以使用 `get_value` 方法访问控件的 `value`

```python
from dearpygui.core import *
from dearpygui.simple import *

with window("Tutorial"):
    add_checkbox("Radio Button", default_value=False)
    print("First value of the Radio Button is: ", get_value("Radio Button"))
    set_value("Radio Button", True)
    print("Value after setting the Radio Button is: ", get_value("Radio Button"))

start_dearpygui()
```

##### 控制相同值

添加新的窗口控件时，会将 `value` 添加到 **Value存储系统** 中，默认情况下，此 `value` 的标识符是控件的 `name`。我们可以使用 `source` 参数覆盖标识符，这样做有一个好处，就是让多个控件控制同一个 `value`

```python
from dearpygui.core import *
from dearpygui.simple import *


def plus_one(sender, data):

    count = get_value('count_value')
    set_value('count_value', str(int(count)+1))


show_logger()
with window("Tutorial"):
    add_input_text("input text##1", source='count_value')
    add_button('plus 1', callback=plus_one)


start_dearpygui()
```

##### 存储其他数据结构

Dear PyGui 还支持传入任意 Python 数据对象类型（甚至可以自定义数据类型）用于数据存储。使用 `add_data`，我们可以传入任意数据类型，并通过 `get_data("name")` 进行访问。

```python
from dearpygui.core import *
from dearpygui.simple import *


def store_data(sender, data):
    custom_data = {
        "Radio Button": get_value("Radio Button"),
        "Checkbox": get_value("Checkbox"),
        "Text Input": get_value("Text Input"),
    }
    add_data("stored_data", custom_data)


def print_data(sender, data):
    log_debug(get_data("stored_data"))


show_logger()

with window("Tutorial"):
    add_radio_button("Radio Button", items=["opt 1", "opt 2"])
    add_checkbox("Checkbox", label="tag")
    add_input_text("Text Input", label="text")
    add_button("store data", callback=store_data)
    add_button("print data", callback=print_data)

start_dearpygui()
```

#### 回调 Callback

##### 添加回调

1. 生成控件时使用 `callback` 参数设置
2. 创建后使用 `set_item_callback` 分配给窗口控件

##### 参数

每个回调方法都必须包含一个 `sender` 和 `data` 参数

`sender` 记录哪个控件通过发送 `name` 来触发回调

`data` 显示控件指定的 `callback_data` 参数

##### 获取控件值

可以在回调函数中获取控件值

```python
from dearpygui.core import *
from dearpygui.simple import *


def update_var(sender, data):
    my_var = get_value(sender)
    log_debug(my_var)


show_logger()  
with window("Tutorial"):
    add_checkbox("check box", callback=update_var)
    add_input_text("input text", callback=update_var)
    add_input_int("input int", callback=update_var)

start_dearpygui()
```

##### 窗口的特殊回调

- ***on_close***：在窗口关闭时触发
- ***set_resize_callback()***：在窗口被调整大小时触发
- ***set_render_callback()***

```python
from dearpygui.core import *
from dearpygui.simple import *


def close_info(sender, data):
    log_debug(f"{sender} has been closed")


def resize_info(sender, data):
    log_debug(f'{sender} has been resized')


show_logger()
with window("Tutorial", on_close=close_info):
    add_text('Hello World!')

set_resize_callback(resize_info, handler="Tutorial")
start_dearpygui()
```

##### 运行时添加和删除控件

Dear PyGui 支持在运行时动态添加和删除任何控件或窗口

通过使用回调运行所需控件的 `add_***` 方法并指定该控件所属的 `parent` 来完成

默认情况下，如果未指定 `parent`，则将控件添加到主窗口。

而通过在添加控件时使用 `before` 参数，可以设置将新控件放在哪个控件之前，默认情况下，会将新控件放在最后。

```python
from dearpygui.core import *
from dearpygui.simple import *


def add_buttons(sender, data):
    add_button("New Button 2", parent="Secondary Window")
    add_button("New Button", before="New Button 2")


def delete_buttons(sender, data):
    delete_item("New Button")
    delete_item("New Button 2")


show_debug()

with window("Tutorial"):
    add_button("Add Buttons", callback=add_buttons)
    add_button("Delete Buttons", callback=delete_buttons)

with window("Secondary Window"):
    pass

start_dearpygui()
```

##### 删除窗口

删除窗口时，默认情况下，会删除窗口及其子控件，如果只想删除子控件，可以将 `children_only` 参数设置为 *True* 值

```python
from dearpygui.core import *
from dearpygui.simple import *


def add_widgets(sender, data):
    with window("Secondary Window"):
        add_button("New Button 2")
        add_button("New Button")
        add_button("New Button 3", parent="Secondary Window")


def delete_widgets(sender, data):
    delete_item("Secondary Window")


def delete_children(sender, data):
    delete_item("Secondary Window", children_only=True)


with window("Tutorial"):
    add_button("add", callback=add_widgets)
    add_button("delete window and widgets", callback=delete_widgets)
    add_button("delete widgets", callback=delete_children)

start_dearpygui()
```

## 控件

### 表格 Table

Dear PyGui has a simple table API that is well suited for static and dynamic tables.

The table widget is started by calling add_table().

To edit the table widget we can use the methods add_row() add_column() which will append the row/column to the last slot in the table.

Alternatively, we can insert rows/columns using insert_row insert_column. Columns and Rows are inserted according to their index argument. If the specified index already exists the exiting columns/rows will be bumped and the new row/column will be inserted at the specified index.

Also an added or inserted row/column will by default fill unspecified cells with empty cells.

```python
from dearpygui.core import *
from dearpygui.simple import *

with window("Tutorial"):
    add_table("Table Example", ["Header 0", "Header 1"])
    add_row("Table Example", ["row 0", "text"])
    add_row("Table Example", ["row 2", "text"])
    add_column("Table Example", "Header 3", ["data", "data"])
    insert_row("Table Example", 1, ["row 1", "inserted row", "inserted row"])
    insert_column("Table Example", 2, "Header 2", ["inserted with column", "inserted column", "inserted column"])

start_dearpygui()
```

![image-20210501221056398](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210501221056398.png)

##### 修改

- ***coord_list = get_table_selections("Table name")***

    获取选中的表格项

- ***set_table_item("Table name", coordinates[0], coordinates[1], "New Value")***

- **set_headers("Table name", header_list)***

    修改表头，传入表头名列表

```python
from dearpygui.core import *
from dearpygui.simple import *


def modify_tables(sender, data):
    log_debug(f"Table Called: {sender}")
    coord_list = get_table_selections("Table Example")
    log_debug(f"Selected Cells (coordinates): {coord_list}")
    for coordinates in coord_list:
        set_table_item("Table Example", coordinates[0], coordinates[1], "New Value")
    set_headers("Table Example", ["New Header 0", "New Header 1", "New Header 2"])


show_logger()

with window("Tutorial"):
    add_spacing(count=5)
    add_button("Modify Selected Table Values", callback=modify_tables)
    add_spacing(count=5)
    add_table("Table Example", ["Header 0", "Header 1"])
    add_row("Table Example", ["awesome row", "text"])
    add_row("Table Example", ["super unique", "unique text"])
    add_column("Table Example", "Header 2", ["text from column", "text from column"])
    add_row("Table Example", ["boring row"])

start_dearpygui()
```

### 分隔件

#### 同排 add_same_line

- *spacing*

    分隔距

#### 行距 add_spacing

#### 分隔线 add_separator

### 输入框 

#### 文本框 add_input_text

```python
add_input_text("Label", default_value="Test Window")
```

#### 整型数框 add_input_int

#### 浮点数框 add_input_float

### 选择框

#### 按钮 add_button

#### 复选框 add_checkbox

### 窗体

- *autosize*

    是否自动规划窗口大小

- *width*

    宽

- *height*

    高

