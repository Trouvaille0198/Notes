---
title: "Python tkinter 库"
date: 2021-04-17
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# tkinter

## 窗口

```python
import tkinter as tk    # 引入tkinter库，并取个别名（即外号)tk

root = tk.Tk()          # 创建窗口
root.mainloop()         # 窗口循环显示
```

### 属性设置

```python
root['bg'] = 'red'      # 背景色，或root['background'] = 'red'

root['height'] = 700     # 窗口的高
root['width'] = 1000      # 窗口的宽

root['highlightthickness'] = 100    # 加亮区域的宽度
root['highlightcolor'] = 'yellow'   # 设置加亮区域在 有焦点 时的颜色
root['highlightbackground'] = 'black' # 设置加亮区域在 无焦点 时的颜色
```

### 常用方法

#### 标题设置

```python
root.title('你好')
```

#### 移除窗口栏

```python
root.overrideredirect(True)
```

#### 窗口大小和位置

```python
# 大小为1000x700，位置为距离屏幕，左右距即x轴100，上下距即y轴50
root.geometry('1000x700+100+50')
```

#### 窗口刷新

```python
root.update()
```

#### 获取窗口位置

```python
# 获取位置前必须刷新窗口
root.update()					
print( root.winfo_x() )
print( root.winfo_y() )
```

#### 窗口最大最小尺寸

```python
# 使窗口能拉取的大小在一个范围内
root.maxsize(200, 300)
root.minsize(20, 100)
```

#### 窗口高宽是否可变

```python
# True表示可以拉伸，False反之，该例子表示可拉伸宽度但固定了高度
root.resizable( width=True, height=False )
```

#### 修改图标

```python
# 参数是*.ico格式的图标路径
root.iconbitmap('path\python.ico')
```

### 事件绑定

#### 格式

```python
root.bind(event,handler)
```

- *event*：系统事件，比如按键的点击，鼠标的点击。其接受的参数是 python 指定的格式
- *handler*：事件发生后，要执行的方法的名称，执行的方法要有个固定的参数 event
    方法格式为:

```python
def handler_name(event):
    pass
```

下面例子，点击窗口会改变窗口颜色：

```python
import tkinter as tk

root = tk.Tk()

# 绑定的方法：点击窗口改变颜色
def callback(event):
    print('点击改变颜色')
    if root['bg'] == 'black':
        root['bg'] = 'white'
    else:
        root['bg'] = 'black'

# 窗口绑定
root.bind( '<Button-1>', callback )

root.mainloop()
```

#### 事件

Tkinter 使用所谓的 事件队列 (event sequences) 暴露接口以绑定 handler 到相关事件. 事件以字符串的形式给出

```python
<modifier-type-detail>
```

- 事件序列是包含在尖括号（<...>）中
- type 部分的内容是最重要的，它通常用于描述普通的事件类型，例如鼠标点击或键盘按键点击（详见下方）。
- modifier 部分的内容是可选的，它通常用于描述组合键，例如 Ctrl + c，Shift + 鼠标左键点击（详见下方）。
- detail 部分的内容是可选的，它通常用于描述具体的按键，例如 Button-1 表示鼠标左键。

例如

| **事件序列**                | **含义**                      |
| --------------------------- | ----------------------------- |
| \<Button-1>                 | 用户点击鼠标左键              |
| \<KeyPress-H>               | 用户点击 H 按键               |
| \<Control-Shift-KeyPress-H> | 用户同时点击 Ctrl + Shift + H |

#### type

| **type**      | **含义**                                                                                                                                                                                        |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Activate      | 当组件的状态从“未激活”变为“激活”的时候触发该事件                                                                                                                                                |
| **Button**    | 1. 当用户点击鼠标按键的时候触发该事件 2. detail 部分指定具体哪个按键：\<Button-1>鼠标左键，\<Button-2>鼠标中键，\<Button-3>鼠标右键，\<Button-4>滚轮上滚（Linux），\<Button-5>滚轮下滚（Linux） |
| ButtonRelease | 1. 当用户释放鼠标按键的时候触发该事 2. 在大多数情况下，比 Button 要更好用，因为如果当用户不小心按下鼠标，用户可以将鼠标移出组件再释放鼠标，从而避免不小心触发事件                               |
| Configure     | 当组件的尺寸发生改变的时候触发该事件                                                                                                                                                            |
| Deactivate    | 当组件的状态从“激活”变为“未激活”的时候触发该事件                                                                                                                                                |
| Destroy       | 当组件被销毁的时候触发该事件                                                                                                                                                                    |
| Enter         | 1. 当鼠标指针进入组件的时候触发该事件 2. 注意：不是指用户按下回车键                                                                                                                             |
| Expose        | 当窗口或组件的某部分不再被覆盖的时候触发该事件                                                                                                                                                  |
| FocusIn       | 1. 当组件获得焦点的时候触发该事件 2. 用户可以用 Tab 键将焦点转移到该组件上（需要该组件的 takefocus 选项为 True） 3. 你也可以调用 focus_set() 方法使该组件获得焦点（见上方例子）                 |
| FocusOut      | 当组件失去焦点的时候触发该事件                                                                                                                                                                  |
| **KeyPress**  | 1. 当用户按下键盘按键的时候触发该事件 2. detail 可以指定具体的按键，例如 \<KeyPress-H>表示当大写字母 H 被按下的时候触发该事件 3. KeyPress 可以简写为 Key                                        |
| KeyRelease    | 当用户释放键盘按键的时候触发该事件                                                                                                                                                              |
| Leave         | 当鼠标指针离开组件的时候触发该事件                                                                                                                                                              |
| Map           | 1. 当组件被映射的时候触发该事件 2. 意思是在应用程序中显示该组件的时候，例如调用 grid() 方法                                                                                                     |
| Motion        | 当鼠标在组件内移动的整个过程均触发该事件                                                                                                                                                        |
| MouseWheel    | 1. 当鼠标滚轮滚动的时候触发该事件 2. 目前该事件仅支持 Windows 和 Mac 系统，Linux 系统请参考 Button                                                                                              |
| Unmap         | 1. 当组件被取消映射的时候触发该事件 2. 意思是在应用程序中不再显示该组件的时候，例如调用 grid_remove() 方法                                                                                      |
| Visibility    | 当应用程序至少有一部分在屏幕中是可见的时候触发该事件                                                                                                                                            |

#### modifier

在事件序列中，modifier 部分的内容可以是以下这些：

| **modifier** | **含义**                                                                                      |
| ------------ | --------------------------------------------------------------------------------------------- |
| Alt          | 当按下 Alt 按键的时候                                                                         |
| Any          | 1. 表示任何类型的按键被按下的时候 2. 例如 \<Any-KeyPress> 表示当用户按下任何按键时触发事件    |
| Control      | 当按下 Ctrl 按键的时候                                                                        |
| Double       | 1. 当后续两个事件被连续触发的时候 2. 例如 \<Double-Button-1> 表示当用户双击鼠标左键时触发事件 |
| Lock         | 当打开大写字母锁定键（CapsLock）的时候                                                        |
| Shift        | 当按下 Shift 按键的时候                                                                       |
| Triple       | 跟 Double 类似，当后续三个事件被连续触发的时候                                                |

#### Event 属性

当 Tkinter 去回调你定义的函数的时候，都会带着 Event 对象（作为参数）去调用，Event 对象以下这些属性你可以使用：

| **属性**       | **含义**                                           |
| -------------- | -------------------------------------------------- |
| widget         | 产生该事件的组件                                   |
| x, y           | 当前的鼠标位置坐标（相对于窗口左上角，像素为单位） |
| x_root, y_root | 当前的鼠标位置坐标（相对于屏幕左上角，像素为单位） |
| char           | 按键对应的字符（键盘事件专属）                     |
| keysym         | 按键名，见下方 Key names（键盘事件专属）           |
| keycode        | 按键码，见下方 Key names（键盘事件专属）           |
| num            | 按钮数字（鼠标事件专属）                           |
| width, height  | 组件的新尺寸（Configure 事件专属）                 |
| type           | 该事件类型                                         |

#### **Key names**

当事件为 \<Key>，\<KeyPress>，\<KeyRelease> 的时候，detail 可以通过设定具体的按键名（keysym）来筛选。例如 <Key-H> 表示按下键盘上的大写字母 H 时候触发事件，\<Key-Tab> 表示按下键盘上的 Tab 按键的时候触发事件。

下表列举了键盘所有特殊按键的 keysym 和 keycode：

（下边按键码是对应美国标准 101 键盘的“Latin-1”字符集，键盘标准不同对应的按键码不同，但按键名是一样的）

| **按键名（keysym）** | **按键码（keycode）** | **代表的按键**               |
| -------------------- | --------------------- | ---------------------------- |
| Alt_L                | 64                    | 左边的 Alt 按键              |
| Alt_R                | 113                   | 右边的 Alt 按键              |
| BackSpace            | 22                    | Backspace（退格）按键        |
| Cancel               | 110                   | break 按键                   |
| Caps_Lock            | 66                    | CapsLock（大写字母锁定）按键 |
| Control_L            | 37                    | 左边的 Ctrl 按键             |
| Control_R            | 109                   | 右边的 Ctrl 按键             |
| Delete               | 107                   | Delete 按键                  |
| Down                 | 104                   | ↓ 按键                       |
| End                  | 103                   | End 按键                     |
| Escape               | 9                     | Esc 按键                     |
| Execute              | 111                   | SysReq 按键                  |
| F1                   | 67                    | F1 按键                      |
| F2                   | 68                    | F2 按键                      |
| F3                   | 69                    | F3 按键                      |
| F4                   | 70                    | F4 按键                      |
| F5                   | 71                    | F5 按键                      |
| F6                   | 72                    | F6 按键                      |
| F7                   | 73                    | F7 按键                      |
| F8                   | 74                    | F8 按键                      |
| F9                   | 75                    | F9 按键                      |
| F10                  | 76                    | F10 按键                     |
| F11                  | 77                    | F11 按键                     |
| F12                  | 96                    | F12 按键                     |
| Home                 | 97                    | Home 按键                    |
| Insert               | 106                   | Insert 按键                  |
| Left                 | 100                   | ← 按键                       |
| Linefeed             | 54                    | Linefeed（Ctrl + J）         |
| KP_0                 | 90                    | 小键盘数字 0                 |
| KP_1                 | 87                    | 小键盘数字 1                 |
| KP_2                 | 88                    | 小键盘数字 2                 |
| KP_3                 | 89                    | 小键盘数字 3                 |
| KP_4                 | 83                    | 小键盘数字 4                 |
| KP_5                 | 84                    | 小键盘数字 5                 |
| KP_6                 | 85                    | 小键盘数字 6                 |
| KP_7                 | 79                    | 小键盘数字 7                 |
| KP_8                 | 80                    | 小键盘数字 8                 |
| KP_9                 | 81                    | 小键盘数字 9                 |
| KP_Add               | 86                    | 小键盘的 + 按键              |
| KP_Begin             | 84                    | 小键盘的中间按键（5）        |
| KP_Decimal           | 91                    | 小键盘的点按键（.）          |
| KP_Delete            | 91                    | 小键盘的删除键               |
| KP_Divide            | 112                   | 小键盘的 / 按键              |
| KP_Down              | 88                    | 小键盘的 ↓ 按键              |
| KP_End               | 87                    | 小键盘的 End 按键            |
| KP_Enter             | 108                   | 小键盘的 Enter 按键          |
| KP_Home              | 79                    | 小键盘的 Home 按键           |
| KP_Insert            | 90                    | 小键盘的 Insert 按键         |
| KP_Left              | 83                    | 小键盘的 ← 按键              |
| KP_Multiply          | 63                    | 小键盘的 * 按键              |
| KP_Next              | 89                    | 小键盘的 PageDown 按键       |
| KP_Prior             | 81                    | 小键盘的 PageUp 按键         |
| KP_Right             | 85                    | 小键盘的 → 按键              |
| KP_Subtract          | 82                    | 小键盘的 - 按键              |
| KP_Up                | 80                    | 小键盘的 ↑ 按键              |
| Next                 | 105                   | PageDown 按键                |
| Num_Lock             | 77                    | NumLock（数字锁定）按键      |
| Pause                | 110                   | Pause（暂停）按键            |
| Print                | 111                   | PrintScrn（打印屏幕）按键    |
| Prior                | 99                    | PageUp 按键                  |
| Return               | 36                    | Enter（回车）按键            |
| Right                | 102                   | → 按键                       |
| Scroll_Lock          | 78                    | ScrollLock 按键              |
| Shift_L              | 50                    | 左边的 Shift 按键            |
| Shift_R              | 62                    | 右边的 Shift 按键            |
| Tab                  | 23                    | Tab（制表）按键              |
| Up                   | 98                    | ↑ 按键                       |

#### 例

```python
# 捕获点击鼠标的位置
import tkinter as tk
 
root = tk.Tk()
 
def callback(event):
        print("点击位置：", event.x, event.y)
 
frame = tk.Frame(root, width = 200, height = 200)
frame.bind("<Button-1>", callback)
frame.pack()
 
root.mainloop()
```

```python
# 捕获键盘事件
import tkinter as tk
 
root = tk.Tk()
 
def callback(event):
        print("点击的键盘字符为：", event.char)
 
frame = tk.Frame(root, width = 200, height = 200)
frame.bind("<Key>", callback)
frame.focus_set()
frame.pack()
 
root.mainloop()
```

```python
# 捕获鼠标在组件上的运动轨迹
import tkinter as tk
 
root = tk.Tk()
 
def callback(event):
        print("当前位置为：", event.x, event.y)
 
frame = tk.Frame(root, width = 200, height = 200)
frame.bind("<Motion>", callback)
frame.pack()
 
root.mainloop()
```

## 控件

目前有 15 种 Tkinter 的控件。下表简单简单介绍各个控件：

| 控件         | 描述                                                     |
| ------------ | -------------------------------------------------------- |
| Button       | 按扭控件：添加按钮                                       |
| Canvas       | 画布控件：显示图形元素，用于绘图                         |
| Checkbutton  | 多选框控件：提供多个选项的选择框，嗯用来制作多选题不可少 |
| Entry        | 输入控件：接受用户的输入                                 |
| Frame        | 框架控件：显示一个矩形区域，用于布局美观                 |
| Label        | 标签控件：可以显示文本和位图                             |
| LabelFrame   | 简单的容器控件： 常用于复杂的窗口布局                    |
| Listbox      | 列表框控件：一个选项列表，用户可以从中选择               |
| Menubutton   | 菜单按钮控件：显示菜单项                                 |
| Menu         | 菜单控件：显示菜单栏，下拉菜单和弹出菜单                 |
| Message      | 消息控件：展示一些文字短消息，与Label类似，但更好        |
| Radiobutton  | 单选按钮控件：显示一个单选的按钮                         |
| Scale        | 范围控件：显示一个数值刻度，为输出限定范围的数字区间     |
| Scrollbar    | 滚动条控件：为方便查看超出可视化区域的内容               |
| Text         | 文本控件：显示和处理多行文本                             |
| tkMessageBox | 显示您应用程序的消息框                                   |
| Toplevel     | 容器控件：显示和处理多行文本                             |
| Spinbox      | 输入控件：与Entry类似，但可以指定输入范围值              |
| PanedWindow  | 窗口布局管理的插件：可以包含一个或者多个子控件           |

### 标签 Label

Label（标签）组件用于在屏幕上显示文本或图像。Label 组件仅能显示单一字体的文本，但文本可以跨越多行。另外，还可以为其中的个别字符加上下划线（例如用于表示键盘快捷键）。

```python
import tkinter as tk
 
master = tk.Tk()
 
w = tk.Label(master, text="Hello World!")
w.pack()
 
master.mainloop()
```

![image-20210203204437109](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203204437109.png)

如果你没有指定 Label 的大小，那么 Label 的尺寸是正好可以容纳其内容而已

#### 参数

***Label(master=None, \*\*options)***

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法

| **选项**            | **含义**                                                                                                                                                                                                                                                                                   |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| activebackground    | 1. 设置当 Label 处于活动状态（通过 state 选项设置状态）的背景色 2. 默认值由系统指定                                                                                                                                                                                                        |
| activeforeground    | 1. 设置当 Label 处于活动状态（通过 state 选项设置状态）的前景色 2. 默认值由系统指定                                                                                                                                                                                                        |
| **anchor**          | 1. 控制文本（或图像）在 Label 中显示的位置 2. "n", "ne", "e", "se", "s", "sw", "w", "nw", 或者 "center" 来定位（ewsn 代表东西南北，上北下南左西右东） 3. 默认值是 "center"                                                                                                                 |
| background          | 1. 设置背景颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                        |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                                         |
| bitmap              | 1. 指定显示到 Label 上的位图 2. 如果指定了 image 选项，则该选项被忽略                                                                                                                                                                                                                      |
| borderwidth         | 1. 指定 Label 的边框宽度 2. 默认值由系统指定，通常是 1 或 2 像素                                                                                                                                                                                                                           |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                                        |
| compound            | 1. 控制 Label 中文本和图像的混合模式 2. 默认情况下，如果有指定位图或图片，则不显示文本 3. 如果该选项设置为 "center"，文本显示在图像上（文本重叠图像） 4. 如果该选项设置为 "bottom"，"left"，"right" 或 "top"，那么图像显示在文本的旁边（如 "bottom"，则图像在文本的下方） 5. 默认值是 NONE |
| cursor              | 1. 指定当鼠标在 Label 上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                           |
| disabledforeground  | 1. 指定当 Label 不可用的时候前景色的颜色 2. 默认值由系统指定                                                                                                                                                                                                                               |
| font                | 1. 指定 Label 中文本的字体(注：如果同时设置字体和大小，应该用元组包起来，如（"楷体", 20） 2. 一个 Label 只能设置一种字体 3. 默认值由系统指定                                                                                                                                               |
| **foreground**      | 1. 设置 Label 的文本和位图的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                       |
| fg                  | 跟 foreground 一样                                                                                                                                                                                                                                                                         |
| **height**          | 1. 设置 Label 的高度 2. 如果 Label 显示的是文本，那么单位是文本单元 3. 如果 Label 显示的是图像，那么单位是像素（或屏幕单元） 4. 如果设置为 0 或者干脆不设置，那么会自动根据 Label 的内容计算出高度                                                                                         |
| highlightbackground | 1. 指定当 Label 没有获得焦点的时候高亮边框的颜色 2. 默认值由系统指定，通常是标准背景颜色                                                                                                                                                                                                   |
| highlightcolor      | 1. 指定当 Label 获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                           |
| highlightthickness  | 1. 指定高亮边框的宽度 2. 默认值是 0（不带高亮边框）                                                                                                                                                                                                                                        |
| **image**           | 1. 指定 Label 显示的图片 2. 该值应该是 PhotoImage，BitmapImage，或者能兼容的对象 3. 该选项优先于 text 和 bitmap 选项                                                                                                                                                                       |
| **justify**         | 1. 定义如何对齐多行文本 2. 使用 "left"，"right" 或 "center" 3. 注意，文本的位置取决于 anchor 选项 4. 默认值是 "center"                                                                                                                                                                     |
| padx                | 1. 指定 Label 水平方向上的额外间距（内容和边框间） 2. 单位是像素                                                                                                                                                                                                                           |
| pady                | 1. 指定 Label 垂直方向上的额外间距（内容和边框间） 2. 单位是像素                                                                                                                                                                                                                           |
| relief              | 1. 指定边框样式 2. 默认值是 "flat" 3. 另外你还可以设置 "groove", "raised", "ridge", "solid" 或者 "sunken"                                                                                                                                                                                  |
| state               | 1. 指定 Label 的状态 2. 这个标签控制 Label 如何显示 3. 默认值是 "normal 4. 另外你还可以设置 "active" 或 "disabled"                                                                                                                                                                         |
| takefocus           | 1. 如果是 True，该 Label 接受输入焦点 2. 默认值是 False                                                                                                                                                                                                                                    |
| **text**            | 1. 指定 Label 显示的文本 2. 文本可以包含换行符 3. 如果设置了 bitmap 或 image 选项，该选项则被忽略                                                                                                                                                                                          |
| textvariable        | 1. Label 显示 Tkinter 变量（通常是一个 StringVar 变量）的内容 2. 如果变量被修改，Label 的文本会自动更新                                                                                                                                                                                    |
| underline           | 1. 跟 text 选项一起使用，用于指定哪一个字符画下划线（例如用于表示键盘快捷键）  2. 默认值是 -1 3. 例如设置为 1，则说明在 Button 的第 2 个字符处画下划线                                                                                                                                     |
| **width**           | 1. 设置 Label 的宽度 2. 如果 Label 显示的是文本，那么单位是文本单元 3. 如果 Label 显示的是图像，那么单位是像素（或屏幕单元） 4. 如果设置为 0 或者干脆不设置，那么会自动根据 Label 的内容计算出宽度                                                                                         |
| wraplength          | 1. 决定 Label 的文本应该被分成多少行 2. 该选项指定每行的长度，单位是屏幕单元 3. 默认值是 0                                                                                                                                                                                                 |

### 按钮 Button

Button（按钮）组件用于实现各种各样的按钮。Button 组件可以包含文本或图像，你可以将一个 Python 的函数或方法与之相关联，当按钮被按下时，对应的函数或方法将被自动执行

Button 组件仅能显示单一字体的文本，但文本可以跨越多行。另外，还可以为其中的个别字符加上下划线（例如用于表示键盘快捷键）。默认情况下，tab 按键被用于在按钮间切换

```python
import tkinter as tk
 
master = tk.Tk()
 
def callback():
    print("我被调用了！")
 
b = tk.Button(master, text="执行", command=callback)
b.pack()
 
master.mainloop()
```

![image-20210203205325365](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203205325365.png)

#### 参数

***Button(master=None, \*\*options)***

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**            | **含义**                                                                                                                                                                                                                                                                                                                                                                                                      |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| activebackground    | 1. 设置当 Button 处于活动状态（通过 state 选项设置状态）的背景色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                          |
| activeforeground    | 1. 设置当 Button 处于活动状态（通过 state 选项设置状态）的前景色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                          |
| anchor              | 1. 控制文本（或图像）在 Button 中显示的位置2. "n", "ne", "e", "se", "s", "sw", "w", "nw", 或者 "center" 来定位（ewsn 代表东西南北，上北下南左西右东） 3. 默认值是 "center"                                                                                                                                                                                                                                    |
| background          | 1. 设置背景颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                                           |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                                                                                                                                                            |
| bitmap              | 1. 指定显示到 Button 上的位图 2. 如果指定了 image 选项，则该选项被忽略                                                                                                                                                                                                                                                                                                                                        |
| borderwidth         | 1. 指定 Button 的边框宽度 2. 默认值由系统指定，通常是 1 或 2 像素                                                                                                                                                                                                                                                                                                                                             |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                                                                                                                                                           |
| compound            | 1. 控制 Button 中文本和图像的混合模式 2. 默认情况下，如果有指定位图或图片，则不显示文本3. 如果该选项设置为 "center"，文本显示在图像上（文本重叠图像） 4. 如果该选项设置为 "bottom"，"left"，"right" 或 "top"，那么图像显示在文本的旁边（如 "bottom"，则图像在文本的下方） 5. 默认值是 NONE                                                                                                                    |
| cursor              | 1. 指定当鼠标在 Button 上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                             |
| default             | 1. 如果设置该选项（"normal"），该按钮会被绘制成默认按钮 2. Tkinter 会根据平台的具体指标来绘制（通常就是绘制一个额外的边框） 2. 默认值是 "disable"                                                                                                                                                                                                                                                             |
| disabledforeground  | 1. 指定当 Button 不可用的时候前景色的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                 |
| font                | 1. 指定 Button 中文本的字体 2. 一个 Button 只能设置一种字体 3. 默认值由系统指定                                                                                                                                                                                                                                                                                                                               |
| foreground          | 1. 设置 Button 的文本和位图的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                         |
| fg                  | 跟 foreground 一样                                                                                                                                                                                                                                                                                                                                                                                            |
| height              | 1. 设置 Button 的高度 2. 如果 Button 显示的是文本，那么单位是文本单元 3. 如果 Button 显示的是图像，那么单位是像素（或屏幕单元） 4. 如果设置为 0 或者干脆不设置，那么会自动根据 Button 的内容计算出高度                                                                                                                                                                                                        |
| highlightbackground | 1. 指定当 Button 没有获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                         |
| highlightcolor      | 1. 指定当 Button 获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                             |
| highlightthickness  | 1. 指定高亮边框的宽度 2. 默认值是 0（不带高亮边框）                                                                                                                                                                                                                                                                                                                                                           |
| image               | 1. 指定 Button 显示的图片 2. 该值应该是 PhotoImage，BitmapImage，或者能兼容的对象 3. 该选项优先于 text 和 bitmap 选项                                                                                                                                                                                                                                                                                         |
| justify             | 1. 定义如何对齐多行文本2. 使用 "left"，"right" 或 "center" 3. 注意，文本的位置取决于 anchor 选项 4. 默认值是 "center"                                                                                                                                                                                                                                                                                         |
| overrelief          | 1. 定义当鼠标飘过时 Button 的样式 2. 如果不设置，那么总是使用 relief 选项指定的样式                                                                                                                                                                                                                                                                                                                           |
| padx                | 指定 Button 水平方向上的额外间距（内容和边框间）                                                                                                                                                                                                                                                                                                                                                              |
| pady                | 指定 Button 垂直方向上的额外间距（内容和边框间）                                                                                                                                                                                                                                                                                                                                                              |
| **relief**          | 1. 指定边框样式 2. 通常当按钮被按下时是 "sunken"，其他时候是 "raised" 3. 另外你还可以设置 "groove"、"ridge" 或 "flat" 4. 默认值是 "raised"                                                                                                                                                                                                                                                                    |
| repeatdelay         | 见下方 repeatinterval 选项的描述                                                                                                                                                                                                                                                                                                                                                                              |
| repeatinterval      | 1. 通常当用户鼠标按下按钮并释放的时候系统认为是一次点击动作。如果你希望当用户持续按下按钮的时候（没有松开），根据一定的间隔多次触发按钮，那么你可以设置这个选项。 2. 当用户持续按下按钮的时候，经过 repeatdelay 时间后，每 repeatinterval 间隔就触发一次按钮事件。 3. 例如设置 repeatdelay=1000，repeatinterval=300，则当用户持续按下按钮，在 1 秒的延迟后开始每 300 毫秒触发一次按钮事件，直到用户释放鼠标。 |
| **state**           | 1. 指定 Button 的状态 2. 默认值是 "normal" 3. 另外你还可以设置 "active" 或 "disabled"                                                                                                                                                                                                                                                                                                                         |
| takefocus           | 1. 指定使用 Tab 键可以将焦点移到该 Button 组件上（这样按下空格键也相当于触发按钮事件） 2. 默认是开启的，可以将该选项设置为 False 避免焦点在此 Button 上                                                                                                                                                                                                                                                       |
| text                | 1. 指定 Button 显示的文本 2. 文本可以包含换行符 3. 如果设置了 bitmap 或 image 选项，该选项则被忽略                                                                                                                                                                                                                                                                                                            |
| textvariable        | 1. Button 显示 Tkinter 变量（通常是一个 StringVar 变量）的内容 2. 如果变量被修改，Button 的文本会自动更新                                                                                                                                                                                                                                                                                                     |
| underline           | 1. 跟 text 选项一起使用，用于指定哪一个字符画下划线（例如用于表示键盘快捷键）  2. 默认值是 -1 3. 例如设置为 1，则说明在 Button 的第 2 个字符处画下划线                                                                                                                                                                                                                                                        |
| width               | 1. 设置 Button 的宽度 2. 如果 Button 显示的是文本，那么单位是文本单元 3. 如果 Button 显示的是图像，那么单位是像素（或屏幕单元） 4. 如果设置为 0 或者干脆不设置，那么会自动根据 Button 的内容计算出宽度                                                                                                                                                                                                        |
| wraplength          | 1. 决定 Button 的文本应该被分成多少行 2. 该选项指定每行的长度，单位是屏幕单元 3. 默认值是 0                                                                                                                                                                                                                                                                                                                   |

#### 方法

***flash()***

-- 刷新 Button 组件，该方法将重绘 Button 组件若干次（在 "active" 和 "normal" 状态间切换）。

***invoke()*** 

-- 调用 Button 中 command 选项指定的函数或方法，并返回函数的返回值。
-- 如果 Button 的 state (状态)是 "disabled"（不可用）或没有指定 command 选项，则该方法无效。

### 多选按钮 Checkbutton

Checkbutton（多选按钮）组件用于实现确定是否选择的按钮，当你希望表达“多选多”选项的时候，可以将一系列 Checkbutton 组合起来使用。

```python
from tkinter import *
 
master = Tk()
 
var = IntVar()
 
c = Checkbutton(master, text="我是帅锅", variable=var)
c.pack()
 
mainloop()
```

![image-20210203210307785](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203210307785.png)

默认情况下，variable 选项设置为 1 表示选中状态，反之设置为 0

如果你的 Tkinter 代码是放在类中的（在实际编程中你就应该这么干），那么将 variable 选项的值作为属性存储可能是更好的选择：

```python
def __init__(self, master):
    self.var = tk.IntVar()
    c = tk.Checkbutton(master, text="DUANG~", variable=self.var, command=self.cb)
    c.pack()
 
def cb(self, event):
    print "variable is", self.var.get()
```

#### 参数

**Checkbutton(master=None, \**options)** (class) 

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**            | **含义**                                                                                                                                                                                                                                                                                         |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| activebackground    | 1. 设置当 Checkbutton 处于活动状态（通过 state 选项设置状态）的背景色 2. 默认值由系统指定                                                                                                                                                                                                        |
| activeforeground    | 1. 设置当 Checkbutton 处于活动状态（通过 state 选项设置状态）的前景色 2. 默认值由系统指定                                                                                                                                                                                                        |
| anchor              | 1. 控制文本（或图像）在 Checkbutton 中显示的位置 2. "n", "ne", "e", "se", "s", "sw", "w", "nw", 或者 "center" 来定位（ewsn 代表东西南北，上北下南左西右东） 3. 默认值是 "center"                                                                                                                 |
| background          | 1. 设置背景颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                              |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                                               |
| bitmap              | 1. 指定显示到 Checkbutton 上的位图 2. 如果指定了 image 选项，则该选项被忽略                                                                                                                                                                                                                      |
| borderwidth         | 1. 指定 Checkbutton 的边框宽度 2. 默认值由系统指定，通常是 1 或 2 像素                                                                                                                                                                                                                           |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                                              |
| command             | 1. 指定于该按钮相关联的函数或方法 2. 当按钮被按下时由 Tkinter 自动调用对应的函数或方法 3. 如果不设置此选项，那么该按钮被按下后啥事儿也不会发生                                                                                                                                                   |
| compound            | 1. 控制 Checkbutton 中文本和图像的混合模式 2. 默认情况下，如果有指定位图或图片，则不显示文本 3. 如果该选项设置为 "center"，文本显示在图像上（文本重叠图像） 4. 如果该选项设置为 "bottom"，"left"，"right" 或 "top"，那么图像显示在文本的旁边（如 "bottom"，则图像在文本的下方） 5. 默认值是 NONE |
| cursor              | 1. 指定当鼠标在 Checkbutton 上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                           |
| disabledforeground  | 1. 指定当 Checkbutton 不可用的时候前景色的颜色 2. 默认值由系统指定                                                                                                                                                                                                                               |
| font                | 1. 指定 Checkbutton 中文本的字体 2. 一个 Checkbutton 只能设置一种字体 3. 默认值由系统指定                                                                                                                                                                                                        |
| foreground          | 1. 设置 Checkbutton 的文本和位图的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                       |
| fg                  | 跟 foreground 一样                                                                                                                                                                                                                                                                               |
| height              | 1. 设置 Checkbutton 的高度 2. 如果 Checkbutton 显示的是文本，那么单位是文本单元 3. 如果 Checkbutton 显示的是图像，那么单位是像素（或屏幕单元） 4. 如果设置为 0 或者干脆不设置，那么会自动根据 Checkbutton 的内容计算出高度                                                                       |
| highlightbackground | 1. 指定当 Checkbutton 没有获得焦点的时候高亮边框的颜色 2. 默认值由系统指定，通常是标准背景颜色                                                                                                                                                                                                   |
| highlightcolor      | 1. 指定当 Checkbutton 获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                           |
| highlightthickness  | 1. 指定高亮边框的宽度 2. 默认值是 1                                                                                                                                                                                                                                                              |
| image               | 1. 指定 Checkbutton 显示的图片 2. 该值应该是 PhotoImage，BitmapImage，或者能兼容的对象 3. 该选项优先于 text 和 bitmap 选项                                                                                                                                                                       |
| indicatoron         | 1. 指定前边作为选择的小方块是否绘制 2. 默认是绘制的 3. 该选项会影响到按钮的样式，如果设置为 False，则点击后该按钮变成 "sunken"（凹陷），再次点击变为 "raised"（凸起）                                                                                                                            |
| justify             | 1. 定义如何对齐多行文本 2. 使用 "left"，"right" 或 "center" 3. 注意，文本的位置取决于 anchor 选项 4. 默认值是 "center"                                                                                                                                                                           |
| **offvalue**        | 1. 默认情况下，variable 选项设置为 1 表示选中状态，反之设置为 0。2. 设置 offvalue 的值可以自定义未选中状态的值（详见上方用法举例）                                                                                                                                                               |
| **onvalue**         | 1. 默认情况下，variable 选项设置为 1 表示选中状态，反之设置为 0。2. 设置 onvalue 的值可以自定义选中状态的值（详见上方用法举例）                                                                                                                                                                  |
| padx                | 1. 指定 Checkbutton 水平方向上的额外间距（内容和边框间） 2. 默认值是 1                                                                                                                                                                                                                           |
| pady                | 1. 指定 Checkbutton 垂直方向上的额外间距（内容和边框间） 2. 默认值是 1                                                                                                                                                                                                                           |
| relief              | 1. 指定边框样式 2. 该值通常是 "flat"，除非你设置 indicatoron 选项为 False 3. 如果 indicatoron 为 False，你还可以设置 "sunken"，"raised"，"groove" 或 "ridge"                                                                                                                                     |
| selectcolor         | 1. 选择框的颜色（就是打勾勾的那个正方形小框框） 2. 默认值由系统指定                                                                                                                                                                                                                              |
| selectimage         | 1. 设置当 Checkbutton 为选中状态的时候显示的图片 2. 如果没有指定 image 选项，该选项被忽略                                                                                                                                                                                                        |
| state               | 1. 指定 Checkbutton 的状态 2. 默认值是 "normal" 3. 另外你还可以设置 "active" 或 "disabled"                                                                                                                                                                                                       |
| takefocus           | 1. 如果是 True，该组件接受输入焦点（用户可以通过 tab 键将焦点转移上来） 2. 默认值是 False                                                                                                                                                                                                        |
| text                | 1. 指定 Checkbutton 显示的文本 2. 文本可以包含换行符 3. 如果设置了 bitmap 或 image 选项，该选项则被忽略                                                                                                                                                                                          |
| textvariable        | 1. Checkbutton 显示 Tkinter 变量（通常是一个 StringVar 变量）的内容 2. 如果变量被修改，Checkbutton 的文本会自动更新                                                                                                                                                                              |
| underline           | 1. 跟 text 选项一起使用，用于指定哪一个字符画下划线（例如用于表示键盘快捷键）  2. 默认值是 -1 3. 例如设置为 1，则说明在 Checkbutton 的第 2 个字符处画下划线                                                                                                                                      |
| **variable**        | 1. 将 Checkbutton 跟一个 Tkinter 变量关联 2. 当按钮按下时，该变量在 onvalue 和 offvalue 之间切换 3. 这个切换的过程是完全自动的                                                                                                                                                                   |
| width               | 1. 设置 Checkbutton 的宽度 2. 如果 Checkbutton 显示的是文本，那么单位是文本单元 3. 如果 Checkbutton 显示的是图像，那么单位是像素（或屏幕单元） 4. 如果设置为 0 或者干脆不设置，那么会自动根据 Checkbutton 的内容计算出宽度                                                                       |
| wraplength          | 1. 决定 Checkbutton 的文本应该被分成多少行 2. 该选项指定每行的长度，单位是屏幕单元 3. 默认值是 0                                                                                                                                                                                                 |

#### 方法

**deselect()**

-- 取消 Checkbutton 组件的选中状态，也就是设置 variable 为 offvalue。

**select()**

-- 将 Checkbutton 组件设置为选中状态，也就是设置 variable 为 onvalue。

**toggle()**

-- 切换 Checkbutton 组件的状态（选中 -> 未选中 / 未选中 -> 选中）

**flash()**

-- 刷新 Checkbutton 组件，该方法将重绘 Checkbutton 组件若干次（在"active" 和 "normal" 状态间切换）。

**invoke()**

-- 调用 Checkbutton 中 command 选项指定的函数或方法，并返回函数的返回值。
-- 如果 Checkbutton 的 state(状态)"disabled"是 （不可用）或没有指定 command 选项，则该方法无效。

### 单选按钮 Radiobutton

Radiobutton（单选按钮）组件用于实现多选一的问题，它几乎总是成组地被使用，其中所有成员共用相同的变量

```python
import tkinter as tk
 
master = tk.Tk()
 
v = tk.IntVar()
v.set(2)
 
tk.Radiobutton(master, text="One", variable=v, value=1).pack(anchor="w")
tk.Radiobutton(master, text="Two", variable=v, value=2).pack(anchor="w")
tk.Radiobutton(master, text="Three", variable=v, value=3).pack(anchor="w")
 
master.mainloop()
```

![image-20210203211041140](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203211041140.png)

如果按钮（选项）比较多，强烈建议您使用以下方式来初始化 Radiobutton 组件：

```python
import tkinter as tk
 
master = tk.Tk()
 
GIRLS = [
    ("西施", 1),
    ("王昭君", 2),
    ("貂蝉", 3),
    ("杨玉环", 4)]
 
v = tk.IntVar()
 
for girl, num in GIRLS:
    b = tk.Radiobutton(master, text=girl, variable=v, value=num)
    b.pack(anchor="w")
 
master.mainloop()
```

![image-20210203211405507](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203211405507.png)

#### 参数

***Radiobutton(master=None, \*\*options)***

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**            | **含义**                                                                                                                                                                                                                                                                                         |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| activebackground    | 1. 设置当 Radiobutton 处于活动状态（通过 state 选项设置状态）的背景色 2. 默认值由系统指定                                                                                                                                                                                                        |
| activeforeground    | 1. 设置当 Radiobutton 处于活动状态（通过 state 选项设置状态）的前景色 2. 默认值由系统指定                                                                                                                                                                                                        |
| anchor              | 1. 控制文本（或图像）在 Radiobutton 中显示的位置 2. "n", "ne", "e", "se", "s", "sw", "w", "nw", 或者 "center" 来定位（ewsn 代表东西南北，上北下南左西右东） 3. 默认值是 "center"                                                                                                                 |
| background          | 1. 设置背景颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                              |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                                               |
| bitmap              | 1. 指定显示到 Radiobutton 上的位图 2. 如果指定了 image 选项，则该选项被忽略                                                                                                                                                                                                                      |
| borderwidth         | 1. 指定 Radiobutton 的边框宽度 2. 默认值由系统指定，通常是 1 或 2 像素                                                                                                                                                                                                                           |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                                              |
| command             | 1. 指定于该按钮相关联的函数或方法 2. 当按钮被按下时由 Tkinter 自动调用对应的函数或方法 3. 如果不设置此选项，那么该按钮被按下后啥事儿也不会发生                                                                                                                                                   |
| compound            | 1. 控制 Radiobutton 中文本和图像的混合模式 2. 默认情况下，如果有指定位图或图片，则不显示文本 3. 如果该选项设置为 "center"，文本显示在图像上（文本重叠图像） 4. 如果该选项设置为 "bottom"，"left"，"right" 或 "top"，那么图像显示在文本的旁边（如 "bottom"，则图像在文本的下方） 5. 默认值是 NONE |
| cursor              | 1. 指定当鼠标在 Radiobutton 上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                           |
| disabledforeground  | 1. 指定当 Radiobutton 不可用的时候前景色的颜色 2. 默认值由系统指定                                                                                                                                                                                                                               |
| font                | 1. 指定 Radiobutton 中文本的字体 2. 一个 Radiobutton 只能设置一种字体 3. 默认值由系统指定                                                                                                                                                                                                        |
| foreground          | 1. 设置 Radiobutton 的文本和位图的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                       |
| fg                  | 跟 foreground 一样                                                                                                                                                                                                                                                                               |
| height              | 1. 设置 Radiobutton 的高度 2. 如果 Radiobutton 显示的是文本，那么单位是文本单元 3. 如果 Radiobutton 显示的是图像，那么单位是像素（或屏幕单元） 4. 如果设置为 0 或者干脆不设置，那么会自动根据 Radiobutton 的内容计算出高度                                                                       |
| highlightbackground | 1. 指定当 Radiobutton 没有获得焦点的时候高亮边框的颜色 2. 默认值由系统指定，通常是标准背景颜色                                                                                                                                                                                                   |
| highlightcolor      | 1. 指定当 Radiobutton 获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                           |
| highlightthickness  | 1. 指定高亮边框的宽度 2. 默认值由系统指定，通常是 1 或 2 像素                                                                                                                                                                                                                                    |
| image               | 1. 指定 Radiobutton 显示的图片 2. 该值应该是 PhotoImage，BitmapImage，或者能兼容的对象 3. 该选项优先于 text 和 bitmap 选项                                                                                                                                                                       |
| **indicatoron**     | 1. 指定前边作为选择的小圆圈是否绘制 2. 默认是绘制的 3. 该选项会影响到按钮的样式，如果设置为 False，则点击后该按钮变成 "sunken"（凹陷），再次点击变为 "raised"（凸起）                                                                                                                            |
| justify             | 1. 定义如何对齐多行文本 2. 使用 "left"，"right" 或 "center" 3. 注意，文本的位置取决于 anchor 选项 4. 默认值是 "center"                                                                                                                                                                           |
| padx                | 1. 指定 Radiobutton 水平方向上的额外间距（内容和边框间） 2. 默认值是 1                                                                                                                                                                                                                           |
| pady                | 1. 指定 Radiobutton 垂直方向上的额外间距（内容和边框间） 2. 默认值是 1                                                                                                                                                                                                                           |
| **relief**          | 1. 指定边框样式 2. 可以设置 "sunken"，"raised"，"groove"，"ridge" 或 "flat" 3. 如果 indicatoron 选项设置为 True，则默认值是 "flat"，否则为 "raised"                                                                                                                                              |
| **selectcolor**     | 1. 选择框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                              |
| selectimage         | 1. 设置当 Radiobutton 为选中状态的时候显示的图片 2. 如果没有指定 image 选项，该选项被忽略                                                                                                                                                                                                        |
| state               | 1. 指定 Radiobutton 的状态 2. 默认值是 "normal" 3. 另外你还可以设置 "active" 或 "disabled"                                                                                                                                                                                                       |
| takefocus           | 1. 如果是 True，该组件接受输入焦点（用户可以通过 tab 键将焦点转移上来） 2. 默认值是 False                                                                                                                                                                                                        |
| text                | 1. 指定 Radiobutton 显示的文本 2. 文本可以包含换行符 3. 如果设置了 bitmap 或 image 选项，该选项则被忽略                                                                                                                                                                                          |
| textvariable        | 1. Radiobutton 显示 Tkinter 变量（通常是一个 StringVar 变量）的内容 2. 如果变量被修改，Radiobutton 的文本会自动更新                                                                                                                                                                              |
| underline           | 1. 跟 text 选项一起使用，用于指定哪一个字符画下划线（例如用于表示键盘快捷键）  2. 默认值是 -1 3. 例如设置为 1，则说明在 Radiobutton 的第 2 个字符处画下划线                                                                                                                                      |
| **value**           | 1. 标志该单选按钮的值 2. 在同一组中的所有按钮应该拥有各不相同的值 3. 通过将该值与 variable 选项的值对比，即可判断用户选中了哪个按钮                                                                                                                                                              |
| **variable**        | 1. 与 Radiobutton 组件关联的变量 2. 同一组中的所有按钮的 variable 选项应该都指向同一个变量 3. 通过将该变量与 value 选项的值对比，即可判断用户选中了哪个按钮                                                                                                                                      |
| width               | 1. 设置 Radiobutton 的宽度 2. 如果 Radiobutton 显示的是文本，那么单位是文本单元 3. 如果 Radiobutton 显示的是图像，那么单位是像素（或屏幕单元） 4. 如果设置为 0 或者干脆不设置，那么会自动根据 Radiobutton 的内容计算出宽度                                                                       |
| wraplength          | 1. 决定 Radiobutton 的文本应该被分成多少行 2. 该选项指定每行的长度，单位是屏幕单元 3. 默认值是 0                                                                                                                                                                                                 |

#### 方法

**deselect()**
-- 取消该按钮的选中状态。

**select()**
-- 将 Radiobutton 组件设置为选中状态。

**flash()**
-- 刷新 Radiobutton 组件，该方法将重绘 Radiobutton 组件若干次（在"active" 和 "normal" 状态间切换）。
-- 该方法在调试的时候很有用，也可以使用此方法提醒用户激活了该按钮。

**invoke()**
-- 调用 Radiobutton 中 command 选项指定的函数或方法，并返回函数的返回值。
-- 如果 Radiobutton 的 state(状态)"disabled"是 （不可用）或没有指定 command 选项，则该方法无效。

### 框架 Frame

Frame（框架）组件是在屏幕上的一个矩形区域。Frame 主要是作为其他组件的框架基础，或为其他组件提供间距填充

Frame 组件主要用于在复杂的布局中将其他组件分组，也用于填充间距和作为实现高级组件的基类

```python
import tkinter as tk
 
master = tk.Tk()
 
tk.Label(text="天王盖地虎").pack()
 
separator = tk.Frame(height=2, bd=1, relief="sunken")
separator.pack(fill="x", padx=5, pady=5)
 
tk.Label(text="小鸡炖蘑菇").pack()
 
master.mainloop()
```

![image-20210203211832334](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203211832334.png)

#### 参数

***Frame(master=None, \*\*options)***

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**            | **含义**                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| background          | 1. 设置 Frame 组件的背景颜色 2. 默认值由系统指定 3. 为了防止更新，可以将颜色值设置为空字符串                                                                                                                                                                                                                                                                                                                                     |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                                                                                                                                                                               |
| borderwidth         | 1. 指定 Frame 的边框宽度 2. 默认值是 0                                                                                                                                                                                                                                                                                                                                                                                           |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                                                                                                                                                                              |
| class_              | 默认值是 Frame                                                                                                                                                                                                                                                                                                                                                                                                                   |
| **colormap**        | 1. 有些显示器只支持 256 色（有些可能更少），这种显示器通常提供一个颜色映射来指定要使用要使用的 256 种颜色 2. 该选项允许你指定用于该组件以及其子组件的颜色映射 3. 默认情况下，Frame 使用与其父组件相同的颜色映射 4. 使用此选项，你可以使用其他窗口的颜色映射代替（两窗口必须位于同个屏幕并且具有相同的视觉特性） 5. 你也可以直接使用 "new" 为 Frame 组件分配一个新的颜色映射 6. 一旦创建 Frame 组件实例，你就无法修改这个选项的值 |
| container           | 1. 该选项如果为 True，意味着该窗口将被用作容器，一些其它应用程序将被嵌入  2. 默认值是 False                                                                                                                                                                                                                                                                                                                                      |
| cursor              | 1. 指定当鼠标在 Frame 上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                                 |
| **height**          | 1. 设置 Frame 的高度 2. 默认值是 0                                                                                                                                                                                                                                                                                                                                                                                               |
| highlightbackground | 1. 指定当 Frame 没有获得焦点的时候高亮边框的颜色 2. 默认值由系统指定，通常是标准背景颜色                                                                                                                                                                                                                                                                                                                                         |
| highlightcolor      | 1. 指定当 Frame 获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                                 |
| highlightthickness  | 1. 指定高亮边框的宽度 2. 默认值是 0（不带高亮边框）                                                                                                                                                                                                                                                                                                                                                                              |
| **padx**            | 水平方向上的边距                                                                                                                                                                                                                                                                                                                                                                                                                 |
| **pady**            | 垂直方向上的边距                                                                                                                                                                                                                                                                                                                                                                                                                 |
| relief              | 1. 指定边框样式 2. 默认值是 "flat" 3. 另外你还可以设置 "sunken"，"raised"，"groove" 或 "ridge" 4. 注意，如果你要设置边框样式，记得设置 borderwidth 或 bd 选项不为 0，才能看到边框                                                                                                                                                                                                                                                |
| takefocus           | 1. 指定该组件是否接受输入焦点（用户可以通过 tab 键将焦点转移上来） 2. 默认值是 False                                                                                                                                                                                                                                                                                                                                             |
| visual              | 1. 为新窗口指定视觉信息 2. 该选项没有默认值                                                                                                                                                                                                                                                                                                                                                                                      |
| **width**           | 1. 设置 Frame 的宽度 2. 默认值是 0                                                                                                                                                                                                                                                                                                                                                                                               |

### 标签框架 LabelFrame

LabelFrame 组件是 Frame 组件的变体。默认情况下，LabelFrame 会在其子组件的周围绘制一个边框以及一个标题

当你想要将一些相关的组件分为一组的时候，可以使用 LabelFrame 组件，比如一系列 Radiobutton（单选按钮）组件

```python
import tkinter as tk
 
master = tk.Tk()
 
group = tk.LabelFrame(master, text="你从哪里得知CSDN？", padx=5, pady=5)
group.pack(padx=10, pady=10)
 
v = tk.IntVar()
r1 = tk.Radiobutton(group, text="同学/同事介绍", variable=v, value=1).pack(anchor="w")
r2 = tk.Radiobutton(group, text="老婆大人介绍", variable=v, value=2).pack(anchor="w")
r3 = tk.Radiobutton(group, text="老师/学长介绍", variable=v, value=3).pack(anchor="w")
 
master.mainloop()
```

![image-20210203212646783](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203212646783.png)

#### 参数

***LabelFrame(master=None, \*\*options)***

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**            | **含义**                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| background          | 1. 设置 LabelFrame 组件的背景颜色 2. 默认值由系统指定 3. 为了防止更新，可以将颜色值设置为空字符串                                                                                                                                                                                                                                                                                                                                |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                                                                                                                                                                               |
| borderwidth         | 1. 指定 LabelFrame 的边框宽度 2. 默认值是 2 像素                                                                                                                                                                                                                                                                                                                                                                                 |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                                                                                                                                                                              |
| class               | 默认值是 LabelFrame                                                                                                                                                                                                                                                                                                                                                                                                              |
| colormap            | 1. 有些显示器只支持 256 色（有些可能更少），这种显示器通常提供一个颜色映射来指定要使用要使用的 256 种颜色 2. 该选项允许你指定用于该组件以及其子组件的颜色映射 3. 默认情况下，Frame 使用与其父组件相同的颜色映射 4. 使用此选项，你可以使用其他窗口的颜色映射代替（两窗口必须位于同个屏幕并且具有相同的视觉特性） 5. 你也可以直接使用 "new" 为 Frame 组件分配一个新的颜色映射 6. 一旦创建 Frame 组件实例，你就无法修改这个选项的值 |
| container           | 1. 该选项如果为 True，意味着该窗口将被用作容器，一些其它应用程序将被嵌入  2. 默认值是 False                                                                                                                                                                                                                                                                                                                                      |
| cursor              | 1. 指定当鼠标在 LabelFrame 上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                            |
| foreground          | 1. 设置 LabelFrame 的文本颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                                                |
| fg                  | 跟 foreground 一样                                                                                                                                                                                                                                                                                                                                                                                                               |
| font                | 1. 指定 LabelFrame 中文本的字体 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                                              |
| height              | 1. 设置 LabelFrame 的高度 2. 单位是像素                                                                                                                                                                                                                                                                                                                                                                                          |
| highlightbackground | 1. 指定当 LabelFrame 没有获得焦点的时候高亮边框的颜色 2. 默认值由系统指定，通常是标准背景颜色                                                                                                                                                                                                                                                                                                                                    |
| highlightcolor      | 1. 指定当 LabelFrame 获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                            |
| highlightthickness  | 1. 指定高亮边框的宽度 2. 默认值是 1 或 2 像素                                                                                                                                                                                                                                                                                                                                                                                    |
| labelanchor         | 1. 控制文本在 LabelFrame 的显示位置 2. "n", "ne", "e", "se", "s", "sw", "w", "nw", 或 "center" 来定位（ewsn代表东西南北，上北下南左西右东） 3. 默认值是 NW                                                                                                                                                                                                                                                                       |
| labelwidget         | 1. 指定一个组件替代默认的文本 Label 2. 如果同时设置此选项和 text 选项，则忽略 text 选项的内容                                                                                                                                                                                                                                                                                                                                    |
| padx                | 1. 指定 FrameLabel 水平方向上的额外间距（内容和边框间） 2. 默认值是 0                                                                                                                                                                                                                                                                                                                                                            |
| pady                | 1. 指定 FrameLabel 垂直方向上的额外间距（内容和边框间） 2. 默认值是 0                                                                                                                                                                                                                                                                                                                                                            |
| relief              | 1. 指定边框样式 2. 默认值是 "groove" 3. 另外你还可以设置 "flat"，"sunken"，"raised" 或 "ridge" 4. 注意，如果你要设置边框样式，记得设置 borderwidth 或 bd 选项不为 0，才能看到边框                                                                                                                                                                                                                                                |
| takefocus           | 1. 指定该组件是否接受输入焦点（用户可以通过 tab 键将焦点转移上来） 2. 默认值是 False                                                                                                                                                                                                                                                                                                                                             |
| **text**            | 1. 指定 LabelFrame 显示的文本 2. 文本可以包含换行符                                                                                                                                                                                                                                                                                                                                                                              |
| visual              | 1. 为新窗口指定视觉信息 2. 该选项没有默认值                                                                                                                                                                                                                                                                                                                                                                                      |
| width               | 1. 设置 LabelFrame 的宽度 2. 默认值是 0                                                                                                                                                                                                                                                                                                                                                                                          |

### 输入框 Entry

Entry（输入框）组件通常用于获取用户的输入文本。

Entry 组件仅允许用于输入一行文本，如果用于输入的字符串长度比该组件可显示空间更长，那内容将被滚动。这意味着该字符串将不能被全部看到（你可以用鼠标或键盘的方向键调整文本的可见范围）。

```python
import tkinter as tk
 
master = tk.Tk()
 
e = tk.Entry(master)
e.pack(padx=20, pady=20)
 
e.delete(0, "end")
e.insert(0, "默认文本...")
 
master.mainloop()
```

![image-20210203213234423](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203213234423.png)

Entry 组件允许通过以下几种方式指定字符的位置

> - 数字索引号：常规的 Python 索引号，从 0 开始
> - "anchor"：对应第一个被选中的字符（如果有的话）
> - "end"：对应已存在文本的后一个位置
> - "insert"：对应插入光标的当前位置
> - 使用鼠标坐标（"@x"）：x 是鼠标位置与 Entry 左侧边缘的水平距离，这样就可以通过鼠标相对地定位字符的位置

#### 参数

**Entry(master=None, \**options)**

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**            | **含义**                                                                                                                                                                                                                                                                        |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| background          | 1. 设置 Entry 的背景颜色 2. 默认值由系统指定                                                                                                                                                                                                                                    |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                              |
| borderwidth         | 1. 设置 Entry 的边框宽度 2. 默认值是 1 或 2 像素                                                                                                                                                                                                                                |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                             |
| cursor              | 1. 指定当鼠标在 Entry 上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                |
| exportselection     | 1. 指定选中的文本是否可以被复制到剪贴板 2. 默认值是 True 3. 可以修改为 False 表示不允许复制文本                                                                                                                                                                                 |
| font                | 1. 指定 Entry 中文本的字体 2. 默认值由系统指定                                                                                                                                                                                                                                  |
| foreground          | 1. 设置 Entry 的文本颜色 2. 默认值由系统指定                                                                                                                                                                                                                                    |
| fg                  | 跟 foreground 一样                                                                                                                                                                                                                                                              |
| highlightbackground | 1. 指定当 Entry 没有获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                            |
| highlightcolor      | 1. 指定当 Entry 获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                |
| highlightthickness  | 1. 指定高亮边框的宽度 2. 默认值是 1 或 2 像素                                                                                                                                                                                                                                   |
| insertbackground    | 指定输入光标的颜色                                                                                                                                                                                                                                                              |
| insertborderwidth   | 1. 指定输入光标的边框宽度 2. 如果被设置为非 0 值，光标样式会被设置为 RAISED 3. 小甲鱼温馨提示：将 insertwidth 设置大一点才能看到效果哦                                                                                                                                          |
| insertofftime       | 1. 该选项控制光标的闪烁频率（灭） 2. 单位是毫秒                                                                                                                                                                                                                                 |
| insertontime        | 1. 该选项控制光标的闪烁频率（亮） 2. 单位是毫秒                                                                                                                                                                                                                                 |
| insertwidth         | 1. 指定光标的宽度 2. 默认值是 1 或 2 像素                                                                                                                                                                                                                                       |
| invalidcommand      | 1. 指定当输入框输入的内容“非法”时调用的函数 2. 也就是指定当 validateCommand 选项指定的函数返回 False 时的函数 3. 详见本内容最下方小甲鱼关于验证详解                                                                                                                             |
| invcmd              | 跟 invalidcommand 一样                                                                                                                                                                                                                                                          |
| justify             | 1. 定义如何对齐输入框中的文本 2. 使用 "left"，"right" 或 "center" 3. 默认值是 "left"                                                                                                                                                                                            |
| relief              | 1. 指定边框样式 2. 默认值是 "sunken" 3. 其他可以选择的值是 "flat"，"raised"，"groove" 和 "ridge"                                                                                                                                                                                |
| selectbackground    | 1. 指定输入框的文本被选中时的背景颜色 2. 默认值由系统指定                                                                                                                                                                                                                       |
| selectborderwidth   | 1. 指定输入框的文本被选中时的边框宽度（选中边框） 2. 默认值由系统指定                                                                                                                                                                                                           |
| selectforeground    | 1. 指定输入框的文本被选中时的字体颜色 2. 默认值由系统指定                                                                                                                                                                                                                       |
| **show**            | 1. 设置输入框如何显示文本的内容 2. 如果该值非空，则输入框会显示指定字符串代替真正的内容 3. 将该选项设置为 "*"，则是密码输入框                                                                                                                                                   |
| state               | 1. Entry 组件可以设置的状态："normal"，"disabled" 或 "readonly"（注意，它跟 "disabled" 相似，但它支持选中和拷贝，只是不能修改，而 "disabled" 是完全禁止） 2. 默认值是 "normal" 3. 注意，如果此选项设置为 "disabled" 或 "readonly"，那么调用 insert() 和 delete() 方法都会被忽略 |
| takefocus           | 1. 指定使用 Tab 键可以将焦点移动到输入框中 2. 默认是开启的，可以将该选项设置为 False 避免焦点在此输入框中                                                                                                                                                                       |
| **textvariable**    | 1. 指定一个与输入框的内容相关联的 Tkinter 变量（通常是 StringVar） 2. 当输入框的内容发生改变时，该变量的值也会相应发生改变                                                                                                                                                      |
| validate            | 1. 该选项设置是否启用内容验证  2. 详见本内容最下方小甲鱼关于验证详解                                                                                                                                                                                                            |
| validatecommand     | 1. 该选项指定一个验证函数，用于验证输入框内容是否合法 2. 验证函数需要返回 True 或 False 表示验证结果 3. 注意，该选项只有当 validate 的值非 "none" 时才有效 3. 详见本内容最下方小甲鱼关于验证详解                                                                                |
| vcmd                | 跟 validatecommand 一样                                                                                                                                                                                                                                                         |
| **width**           | 1. 设置输入框的宽度，以字符为单位 2. 默认值是 20 3. 对于变宽字体来说，组件的实际宽度等于字体的平均宽度乘以 width 选项的值                                                                                                                                                       |
| xscrollcommand      | 1. 与 scrollbar（滚动条）组件相关联 2. 如果你觉得用户输入的内容会超过该组件的输入框宽度，那么可以考虑设置该选项 3. 使用方法可以参考：Scrollbar 组件                                                                                                                             |

#### 方法

**delete(first, last=None)** 

-- 删除参数 first 到 last 范围内（包含 first 和 last）的所有内容
-- 如果忽略 last 参数，表示删除 first 参数指定的选项
-- 使用 delete(0, END) 实现删除输入框的所有内容

**get()**

-- 获得当前输入框的内容

**index(index)** 

-- 返回与 index 参数相应的选项的序号（例如 e.index(END)）

**insert(index, text)** 

-- 将 text 参数的内容插入到 index 参数指定的位置
-- 使用 insert(INSERT, text) 将 text 参数指定的字符串插入到光标的位置
-- 使用 insert(END, text) 将 text 参数指定的字符串插入到输入框的末尾

### 文本 Text

Text（文本）组件用于显示和处理多行文本。在 Tkinter 的所有组件中，Text 组件显得异常强大和灵活，适用于多种任务。虽然该组件的主要目的是显示多行文本，但它常常也被用于作为简单的文本编辑器和网页浏览器使用

```python
import tkinter as tk
 
root = tk.Tk()
 
text = tk.Text(root)
text.pack()
 
# "insert" 索引表示插入光标当前的位置
text.insert("insert", "I love ")
text.insert("end", "Python.com!")
 
root.mainloop()
```

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203214123731.png" alt="image-20210203214123731" style="zoom:67%;" />

#### 参数

**Text(master=None, \**options)**

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**            | **含义**                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| autoseparators      | 1. 指定实现“撤销”操作的时候是否自动插入一个“分隔符”（用于分隔操作记录） 2. 默认值是 True 3. 详见上方用法【“撤销”和“恢复”操作】                                                                                                                                                                                                                                                                                                  |
| background          | 1. 设置 Text 组件的背景颜色 2. 注意：通过使用 Tags 可以使 Text 组件中的文本支持多种背景颜色显示（请参考上方【Tags 用法】）                                                                                                                                                                                                                                                                                                      |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                                                                                                                                                                              |
| borderwidth         | 1. 设置 Entry 的边框宽度 2. 默认值是 1 像素                                                                                                                                                                                                                                                                                                                                                                                     |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                                                                                                                                                                             |
| cursor              | 1. 指定当鼠标在 Text 组件上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                             |
| exportselection     | 1. 指定选中的文本是否可以被复制到剪贴板 2. 默认值是 True 3. 可以修改为 False 表示不允许复制文本                                                                                                                                                                                                                                                                                                                                 |
| font                | 1. 设置 Text 组件中文本的默认字体 2. 注意：通过使用 Tags 可以使 Text 组件中的文本支持多种字体显示（请参考上方【Tags 用法】）                                                                                                                                                                                                                                                                                                    |
| foreground          | 1. 设置 Text 组件中文本的颜色 2. 注意：通过使用 Tags 可以使 Text 组件中的文本支持多种颜色显示（请参考上方【Tags 用法】）                                                                                                                                                                                                                                                                                                        |
| fg                  | 跟 foreground 一样                                                                                                                                                                                                                                                                                                                                                                                                              |
| height              | 1. 设置 Text 组件的高度 2. 注意：单位是行数，不是像素噢                                                                                                                                                                                                                                                                                                                                                                         |
| highlightbackground | 1. 指定当 Text 组件没有获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                         |
| highlightcolor      | 1. 指定当 Text 组件获得焦点的时候高亮边框的颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                             |
| highlightthickness  | 1. 指定高亮边框的宽度 2. 默认值是 0                                                                                                                                                                                                                                                                                                                                                                                             |
| insertbackground    | 1. 设置插入光标的颜色 2. 默认是 BLACK（或 "black"）                                                                                                                                                                                                                                                                                                                                                                             |
| insertborderwidth   | 1. 设置插入光标的边框宽度 2. 默认值是 0 3. 提示：你得设置 insertwidth 选项为比较大的数值才能看出来噢                                                                                                                                                                                                                                                                                                                            |
| insertofftime       | 1. 该选项控制光标的闪烁频率（灭） 2. 单位是毫秒                                                                                                                                                                                                                                                                                                                                                                                 |
| insertontime        | 1. 该选项控制光标的闪烁频率（亮） 2. 单位是毫秒                                                                                                                                                                                                                                                                                                                                                                                 |
| insertwidth         | 1. 指定光标的宽度 2. 默认值是 2 像素                                                                                                                                                                                                                                                                                                                                                                                            |
| maxundo             | 1. 设置允许“撤销”操作的最大次数 2. 默认值是 0 3. 设置为 -1 表示不限制                                                                                                                                                                                                                                                                                                                                                           |
| padx                | 1. 指定水平方向上的额外间距（内容和边框间） 2. 默认值是 1                                                                                                                                                                                                                                                                                                                                                                       |
| pady                | 1. 指定垂直方向上的额外间距（内容和边框间） 2. 默认值是 1                                                                                                                                                                                                                                                                                                                                                                       |
| relief              | 1. 指定边框样式 2. 默认值是 "sunken" 3. 其他可以选择的值是 "flat"，"raised"，"groove" 和 "ridge"                                                                                                                                                                                                                                                                                                                                |
| selectbackground    | 1. 指定被选中文本的背景颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                                                 |
| selectborderwidth   | 1. 指定被选中文本的边框宽度 2. 默认值是 0                                                                                                                                                                                                                                                                                                                                                                                       |
| selectforeground    | 1. 指定被选中文本的字体颜色 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                                                 |
| setgrid             | 1. 指定一个布尔类型的值，确定是否启用网格控制 2. 默认值是 False                                                                                                                                                                                                                                                                                                                                                                 |
| spacing1            | 1. 指定 Text 组件的文本块中每一行与上方的空白间隔 2. 注意：自动换行不算 3. 默认值是 0                                                                                                                                                                                                                                                                                                                                           |
| spacing2            | 1. 指定 Text 组件的文本块中自动换行的各行间的空白间隔 2. 注意：换行符（'\n'）不算 3. 默认值是 0                                                                                                                                                                                                                                                                                                                                 |
| spacing3            | 1. 指定 Text 组件的文本中每一行与下方的空白间隔  2. 注意：自动换行不算 3. 默认值是 0                                                                                                                                                                                                                                                                                                                                            |
| state               | 1. 默认情况下 Text 组件响应键盘和鼠标事件（"normal"） 2. 如果将该选项的值设置为 "disabled"，那么上述响应就不会发生，并且你无法修改里边的内容                                                                                                                                                                                                                                                                                    |
| tabs                | 1. 定制 Tag 所描述的文本块中 Tab 按键的功能 2. 默认 Tab 被定义为 8 个字符的宽度 3. 你还可以定义多个制表位：tabs=('3c', '5c', '12c') 表示前 3 个 Tab 宽度分别为 3厘米，5厘米，12厘米，接着的 Tab 按照最后两个的差值计算，即：19厘米，26厘米，33厘米 4. 你应该注意到了，它上边 'c' 的含义是“厘米”而不是“字符”，还可以选择的单位有 'i'（英寸），'m'（毫米）和 'p'（DPI，大约是 '1i' 等于 '72p'） 5. 如果是一个整型值，则单位是像素 |
| takefocus           | 1. 指定使用 Tab 键可以将焦点移动到 Text 组件中 2. 默认是开启的，可以将该选项设置为 False 避免焦点在此 Text 组件中                                                                                                                                                                                                                                                                                                               |
| undo                | 1. 该选项设置为 True 开启“撤销”功能 2. 该选项设置为 False 关闭“撤销”功能 3. 默认值是 False                                                                                                                                                                                                                                                                                                                                      |
| width               | 1. 设置 Text 组件的宽度 2. 注意：单位是字符数，因此 Text 组件的实际宽度还取决于字体的大小                                                                                                                                                                                                                                                                                                                                       |
| wrap                | 1. 设置当一行文本的长度超过 width 选项设置的宽度时，是否自动换行 2. 该选项的值可以是："none"（不自动换行），"char"（按字符自动换行）和 "word"（按单词自动换行）                                                                                                                                                                                                                                                                 |
| xscrollcommand      | 1. 与 scrollbar（滚动条）组件相关联（水平方向） 2. 使用方法可以参考：[Scrollbar 组件](https://blog.csdn.net/qq_41556318/article/details/85108366)                                                                                                                                                                                                                                                                               |
| yscrollcommand      | 1. 与 scrollbar（滚动条）组件相关联（垂直方向） 2. 使用方法可以参考：[Scrollbar 组件](https://blog.csdn.net/qq_41556318/article/details/85108366)                                                                                                                                                                                                                                                                               |

#### 方法

**bbox(index)**
-- 返回给定索引指定的字符的边界框
-- 返回值是一个 4 元组：(x, y, width, height)
-- 如果该字符是不可见的，那么返回 None
-- 注意：只有当 Text 组件被更新的时候该方法才有效，可以使用 update_idletasks() 方法先更新 Text 组件

**compare(index1, op, index2)**
-- 返回对比 index1 和 index2 指定的两个字符的结果
-- op 是操作符：'<', '<=', '==', '>=', '>' 或 '!='（不支持 Python 的 '<>' 操作符）
-- 返回布尔类型的值表示对比的结果

**debug(boolean=None)**
-- 开启或关闭 Debug 状态

**delete(start, end=None)**
-- 删除给定范围的文本或嵌入对象
-- 如果在给定范围内有任何 Marks 标记的位置，则将 Marks 移动到 start 参数开始的位置

**dlineinfo(index)**
-- 返回给定索引指定的字符所在行的边界框
-- 返回值是一个 5 元组：(x, y, width, height, offset)，offset 表示从该行的顶端到基线的偏移
-- 如果该行不可见，则返回 None
-- 注意：只有当 Text 组件被更新的时候该方法才有效，可以使用 update_idletasks() 方法先更新 Text 组件

**dump(index1, index2=None, command=None, \**kw)**
-- 返回 index1 和 index2 之间的内容
-- 返回的值是一个由 3 元组（关键词，值，索引）组成的列表，关键词参数的顺序为：all, image, mark, tag, text, window
-- 默认关键词是 'all'，表示全部关键词均为选中状态
-- 如果需要筛选个别关键词，可以用 dump(index1, index2, image=True, text=True) 这样的形式调用
-- 如果指定了 command 函数，那么会为列表中的每一个三元组作为参数调用一次该函数（这种情况下，dump() 不返回值）

**edit_modified(arg=None)**
-- 该方法用于查询和设置 modified 标志（该标标志用于追踪 Text 组件的内容是否发生变化）
-- 如果不指定 arg 参数，那么返回 modified 标志是否被设置
-- 你可以传递显式地使用 True 或 False 作为参数来设置或清除 modified 标志
-- 任何代码或用户的插入或删除文本操作，“撤销”或“恢复”操作，都会是的 modified 标志被设置

**edit_redo(self)**
-- “恢复”上一次的“撤销”操作
-- 如果 undo 选项为 False，该方法无效
-- 详见上方用法【“撤销”和“恢复”操作】

**edit_reset()**
-- 清空存放操作记录的栈

**edit_separator()**
-- 插入一个“分隔符”到存放操作记录的栈中，用于表示已经完成一次完整的操作
-- 如果 undo 选项为 False，该方法无效
-- 详见上方用法【“撤销”和“恢复”操作】

**edit_undo()**
-- 撤销最近一次操作
-- 如果 undo 选项为 False，该方法无效
-- 详见上方用法【“撤销”和“恢复”操作】

**get(index1, index2=None)**
-- 返回 index1 到 index2（不包含）之间的文本
-- 如果 index2 参数忽略，则返回一个字符
-- 如果包含 image 和 window 的嵌入对象，均被忽略
-- 如果包含有多行文本，那么自动插入换行符（'\n'）

**image_cget(index, option)**
-- 返回 index 参数指定的嵌入 image 对象的 option 选项的值
-- 如果给定的位置没有嵌入 image 对象，则抛出 TclError 异常

**image_configure(index, \**options)**
-- 修改 index 参数指定的嵌入 image 对象的一个或多个 option 选项的值
-- 如果给定的位置没有嵌入 image 对象，则抛出 TclError 异常

**image_create(index, cnf={}, \**kw)**
-- 在 index 参数指定的位置嵌入一个 image 对象
-- 该 image 对象必须是 Tkinter 的 PhotoImage 或 BitmapImage 实例
-- 可选选项 align：设定此图像的垂直对齐，可以是 "top"、"center"、"bottom" 或 "baseline"
-- 可选选项 image：PhotoImage 或 BitmapImage 对象
-- 可选选项 name：你可以为该图像实例命名，如果你忽略此选项，那么 Tkinter 会自动为其取一个独一无二的名字。
-- 可选选项 padx：设置水平方向上的额外间距
-- 可选选项 pady：设置垂直方向上的额外间距

**image_names()**
-- 返回 Text 组件中嵌入的所有 image 对象的名字

**index(index)**
-- 将 index 参数指定的位置以 "line.column" 的索引形式返回
-- index 参数支持任何格式的索引

**insert(index, text, \*tags)**
-- 在 index 参数指定的位置插入字符串
-- 可选参数 tags 用于指定文本的样式
-- 详见上方【Tags 用法】

**mark_gravity(self, markName, direction=None)**
-- 设置 Mark 的方向，可以是 "left" 或 "right"（默认是 "right"，即如果在 Mark 处插入文本的话，Mark 将发生相应的移动以保持在插入文本的右侧）
-- 如果设置为 "left"，那么在 Mark 处插入文本并不会移动 Mark（因为 Mark 在插入文本的左侧）
-- 如果忽略 direction 参数，则返回指定 Mark 的方向
-- 详见上方【Marks 用法】

**mark_names()**
-- 返回 Text 组件中所有 Marks 的名字
-- 包括两个特殊 Mark："insert" 和 "current"
-- 注意："end" 是特殊的索引，不是 Mark

**mark_next(index)**
-- 返回在 index 指定的位置后边的一个 Mark 的名字
-- 如果不存在则返回空字符串

**mark_previous(index)**
-- 返回在 index 指定的位置前边的一个 Mark 的名字
-- 如果不存在则返回空字符串

**mark_set(markName, index)**
-- 移动 Mark 到 index 参数指定的位置
-- 如果 markName 参数指定的 Mark 不存在，则创建一个新的 Mark

**mark_unset(\*markNames)**
-- 删除 markNames 指定的 Marks
-- 不能删除预定义的 "insert" 和 "current"

**replace(index1, index2, chars, \*args)**
-- 将 index1 到 index2 之间的内容替换为 chars 参数指定的字符串
-- 如果需要为替换的内容添加 Tag，可以在 args 参数指定 Tag
-- 详见上方【Tags 用法】

**scan_dragto(x, y)**
-- 详见下方 scan_mark(x, y)

**scan_mark(x, y)**
-- 使用这种方式来实现 Text 组件内容的滚动
-- 需要将鼠标按钮事件以及鼠标当前位置绑定到 scan_mark(x, y) 方法，然后将 <motion> 事件及当前鼠标位置绑定到 scan_dragto(x, y) 方法，就可以实现 Text 组件的内容在当前位置和 scan_mark(x, y) 指定的位置 (x, y) 之间滚动

**search(pattern, index, stopindex=None, forwards=None, backwards=None, exact=None, regexp=None, nocase=None, count=None)**
-- 从 index 开始搜索 pattern，到 stopindex 结束（不指定表示搜索到末尾）
-- 如果成功找到，以 "line.column" 返回第一个匹配的字符；否则返回空字符串
-- forwards 参数设置为 True 表示向前（->）搜索
-- backwards 参数设置为 True 表示向后（<-）搜索
-- exact 参数设置为 True 表示搜索与 pattern 完全匹配的结果
-- regexp 参数设置为 True，则 pattern 被解释为 Tcl 格式的正则表达式
-- nocase 参数设置为 True 是忽略大小写，默认是区分大小写的搜索
-- count 参数指定为一个 IntVar 的 Tkinter 变量，用于存放当找到匹配的字符个数（如果匹配结果中没有嵌入的 image 或 window 对象的话，一般该值等于 pattern 的字符个数）

**see(index)**
-- 滚动内容，确保 index 指定的位置可见

**tag_add(tagName, index1, index2=None)**
-- 为 index1 到 index2 之间的内容添加一个 Tag（tagName 参数指定）
-- 如果 index2 参数忽略，则单独为 index1 指定的内容添加 Tag
-- 详见上方【Tags 用法】

**tag_bind(tagName, sequence, func, add=None)**
-- 为 Tag 绑定事件
-- 详见上方【Tags 用法】

**tag_cget(tagName, option)**
-- 返回 tagName 指定的 option 选项的值

**tag_config(tagName, cnf=None, \**kw)**
-- 跟 tag_configure(tagName, cnf=None, **kw) 一样

**tag_configure(tagName, cnf=None, \**kw)**
-- 设置 tagName 的选项
-- 详见上方【Tags 用法】

**tag_delete(\*tagNames)**
-- 删除 tagNames 指定的 Tags

**tag_lower(tagName, belowThis=None)**
-- 降低 Tag 的优先级
-- 如果 belowThis 参数不为空，则表示 tagName 需要比 belowThis 指定的 Tag 优先级更低
-- 详见上方【Tags 用法】

**tag_names(index=None)**
-- 如果不带参数，表示返回 Text 组件中所有 Tags 的名字
-- index 参数表示返回该位置上所有的 Tags 的名字

**tag_nextrange(tagName, index1, index2=None)**
-- 在 index1 到 index2 的范围内第一个 tagName 的位置
-- 如果没有则返回空字符串

**tag_prevrange(tagName, index1, index2=None)**
-- tag_nextrange() 的反向查找，也就是查找范围是 index2 到 index1

**tag_raise(tagName, aboveThis=None)**
-- 提高 Tag 的优先级
-- 如果 aboveThis 参数不为空，则表示 tagName 需要比 aboveThis 指定的 Tag 优先级更高
-- 详见上方【Tags 用法】

**tag_ranges(tagName)**
-- 返回所有 tagName 指定的文本，并将它们的范围以列表的形式返回

**tag_remove(tagName, index1, index2=None)**
-- 删除 index1 到 index2 之间所有的 tagName
-- 如果忽略 index2 参数，那么只删除 index1 指定的那个字符的 tagName（如果有的话）

**tag_unbind(tagName, sequence, funcid=None)**
-- 解除与 tagName 绑定的事件（sequence 指定）

**window_cget(index, option)**
-- 返回 index 参数指定的嵌入 window 对象的 option 选项的值
-- 如果给定的位置没有嵌入 window 对象，则抛出 TclError 异常

**window_config(index, cnf=None, \**kw)**
-- 跟 window_configure(index, cnf=None, **kw) 一样

**window_configure(index, cnf=None, \**kw)**
-- 修改 index 参数指定的嵌入 window 对象的一个或多个 option 选项的值
-- 如果给定的位置没有嵌入 window 对象，则抛出 TclError 异常

**window_create(index, \**options)**
-- 在 index 参数指定的位置嵌入一个 window 对象
-- 支持两种方式在 Text 组件中嵌入 window 对象：请看下方 create 选项和 window 选项的描述
-- 可选选项 align：设定此图像的垂直对齐，可以是 "top"、"center"、"bottom" 或 "baseline"
-- 可选选项 create：指定一个回调函数用于创建嵌入的 window 组件，该函数没有参数，并且必须创建 Text 的子组件并返回
-- 可选选项 padx：设置水平方向上的额外间距
-- 可选选项 pady：设置垂直方向上的额外间距
-- 可选选项 stretch：该选项控制当行的高度大于嵌入组件的高度时，嵌入组件是否延伸。默认值是 False，表示组件保持原形；设置为 True 表示将该组件垂直部分延伸至行的高度
-- 可选选项 window：指定一个已经创建好的 window 组件，该组件必须是 Text 组件的子组件

**window_names()**
-- 返回 Text 组件中嵌入的所有 window 对象的名字

**xview(\*args)**
-- 该方法用于在水平方向上滚动 Text 组件的内容，一般通过绑定 Scollbar 组件的 command 选项来实现（具体操作参考：[Scrollbar](https://blog.csdn.net/qq_41556318/article/details/85108366)）
-- 如果第一个参数是 "moveto"，则第二个参数表示滚动到指定的位置：0.0 表示最左端，1.0 表示最右端
-- 如果第一个参数是 "scroll"，则第二个参数表示滚动的数量，第三个参数表示滚动的单位（可以是 "units" 或 "pages"），例如：xview("scroll", 3, "units") 表示向右滚动三行

**xview_moveto(fraction)**
-- 跟 xview("moveto", fraction) 一样

**xview_scroll(number, what)**
-- 跟 xview("scroll", number, what) 一样

**yview(\*args)**
-- 该方法用于在垂直方向上滚动 Text 组件的内容，一般通过绑定 Scollbar 组件的 command 选项来实现（具体操作参考：[Scrollbar](https://blog.csdn.net/qq_41556318/article/details/85108366)）
-- 如果第一个参数是 "moveto"，则第二个参数表示滚动到指定的位置：0.0 表示最顶端，1.0 表示最底端
-- 如果第一个参数是 "scroll"，则第二个参数表示滚动的数量，第三个参数表示滚动的单位（可以是 "units" 或 "pages"），例如：yview("scroll", 3, "pages") 表示向下滚动三页

**yview_moveto(fraction)**
-- 跟 yview("moveto", fraction) 一样

**yview_scroll(number, what)**
-- 跟 yview("scroll", number, what) 一样

### 顶层窗口 Toplevel

Toplevel（顶级窗口）组件类似于 Frame 组件，但 Toplevel 组件是一个独立的顶级窗口，这种窗口通常拥有标题栏、边框等部件

Toplevel 组件通常用在显示额外的窗口、对话框和其他弹出窗口上

```python
import tkinter as tk
 
root = tk.Tk()
 
def create():
    top = tk.Toplevel()
    top.title("Python")
 
    msg = tk.Message(top, text="I love Python!")
    msg.pack()
 
tk.Button(root, text="创建顶级窗口", command=create).pack()
 
root.mainloop()
```

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203214849716.png" alt="image-20210203214849716" style="zoom:67%;" />

#### 参数

**Toplevel(master=None, \**options)**

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**            | **含义**                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| background          | 1. 设置背景颜色 2. 默认值由系统指定 3. 为了防止更新，可以将颜色值设置为空字符串                                                                                                                                                                                                                                                                                                                                                           |
| bg                  | 跟 background 一样                                                                                                                                                                                                                                                                                                                                                                                                                        |
| borderwidth         | 设置边框宽度                                                                                                                                                                                                                                                                                                                                                                                                                              |
| bd                  | 跟 borderwidth 一样                                                                                                                                                                                                                                                                                                                                                                                                                       |
| class_              | 默认值是 Toplevel                                                                                                                                                                                                                                                                                                                                                                                                                         |
| colormap            | 1. 有些显示器只支持 256 色（有些可能更少），这种显示器通常提供一个颜色映射来指定要使用要使用的 256 种颜色 2. 该选项允许你指定用于该组件以及其子组件的颜色映射 3. 默认情况下，Toplevel 使用与其父组件相同的颜色映射 4. 使用此选项，你可以使用其他窗口的颜色映射代替（两窗口必须位于同个屏幕并且具有相同的视觉特性） 5. 你也可以直接使用 "new" 为 Toplevel 组件分配一个新的颜色映射 6. 一旦创建 Toplevel 组件实例，你就无法修改这个选项的值 |
| container           | 1. 该选项如果为 True，意味着该窗口将被用作容器，一些其它应用程序将被嵌入  2. 默认值是 False                                                                                                                                                                                                                                                                                                                                               |
| cursor              | 1. 指定当鼠标在 Toplevel 上飘过的时候的鼠标样式 2. 默认值由系统指定                                                                                                                                                                                                                                                                                                                                                                       |
| height              | 设置高度                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| highlightbackground | 指定当 Toplevel 没有获得焦点的时候高亮边框的颜色                                                                                                                                                                                                                                                                                                                                                                                          |
| highlightcolor      | 指定当 Toplevel 获得焦点的时候高亮边框的颜色                                                                                                                                                                                                                                                                                                                                                                                              |
| highlightthickness  | 指定高亮边框的宽度                                                                                                                                                                                                                                                                                                                                                                                                                        |
| menu                | 设置该选项为 Toplevel 窗口提供菜单栏                                                                                                                                                                                                                                                                                                                                                                                                      |
| padx                | 水平方向上的边距                                                                                                                                                                                                                                                                                                                                                                                                                          |
| pady                | 垂直方向上的边距                                                                                                                                                                                                                                                                                                                                                                                                                          |
| relief              | 1. 指定边框样式 2. 默认值是 "flat" 3. 另外你还可以设置 "sunken"，"raised"，"groove" 或 "ridge" 4. 注意，如果你要设置边框样式，记得设置 borderwidth 或 bd 选项不为 0，才能看到边框                                                                                                                                                                                                                                                         |
| takefocus           | 1. 指定该组件是否接受输入焦点（用户可以通过 tab 键将焦点转移上来） 2. 默认值是 False                                                                                                                                                                                                                                                                                                                                                      |
| width               | 设置宽度                                                                                                                                                                                                                                                                                                                                                                                                                                  |

### 菜单 Menu

Menu（菜单）组件用于实现顶级菜单、下拉菜单和弹出菜单

```python
import tkinter as tk
 
root = tk.Tk()
 
def callback():
    print("~被调用了~")
 
# 创建一个顶级菜单
menubar = tk.Menu(root)
 
# 创建一个下拉菜单“文件”，然后将它添加到顶级菜单中
filemenu = tk.Menu(menubar, tearoff=False)
filemenu.add_command(label="打开", command=callback)
filemenu.add_command(label="保存", command=callback)
filemenu.add_separator()
filemenu.add_command(label="退出", command=root.quit)
menubar.add_cascade(label="文件", menu=filemenu)
 
# 创建另一个下拉菜单“编辑”，然后将它添加到顶级菜单中
editmenu = tk.Menu(menubar, tearoff=False)
editmenu.add_command(label="剪切", command=callback)
editmenu.add_command(label="拷贝", command=callback)
editmenu.add_command(label="粘贴", command=callback)
menubar.add_cascade(label="编辑", menu=editmenu)
 
# 显示菜单
root.config(menu=menubar)
 
root.mainloop()
```

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203215735047.png" alt="image-20210203215735047" style="zoom:67%;" />

#### 参数

**Menu(master=None, \**options)** 

- *master* -- 父组件

- *\*\*options* -- 组件选项，下方表格详细列举了各个选项的具体含义和用法：

| **选项**           | **含义**                                                                                                                                                                                                               |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| activebackground   | 设置当 Menu 处于 "active" 状态（通过 state 选项设置状态）的背景色                                                                                                                                                      |
| activeborderwidth  | 设置当 Menu 处于 "active" 状态（通过 state 选项设置状态）的边框宽度                                                                                                                                                    |
| activeforeground   | 设置当 Menu 处于 "active" 状态（通过 state 选项设置状态）的前景色                                                                                                                                                      |
| background         | 设置背景颜色                                                                                                                                                                                                           |
| bg                 | 跟 background 一样                                                                                                                                                                                                     |
| borderwidth        | 指定边框宽度                                                                                                                                                                                                           |
| bd                 | 跟 borderwidth 一样                                                                                                                                                                                                    |
| cursor             | 指定当鼠标在 Menu 上飘过的时候的鼠标样式                                                                                                                                                                               |
| disabledforeground | 指定当 Menu 处于 "disabled" 状态的时候的前景色                                                                                                                                                                         |
| font               | 指定 Menu 中文本的字体                                                                                                                                                                                                 |
| foreground         | 设置 Menu 的前景色                                                                                                                                                                                                     |
| fg                 | 跟 foreground 一样                                                                                                                                                                                                     |
| postcommand        | 将此选项与一个方法相关联，当菜单被打开的时候该方法将自动被调用                                                                                                                                                         |
| relief             | 1. 指定边框样式 2. 默认值是 "flat" 3. 另外你还可以设置 "sunken"，"raised"，"groove" 或 "ridge"                                                                                                                         |
| selectcolor        | 指定当菜单项显示为单选按钮或多选按钮时选择中标志的颜色                                                                                                                                                                 |
| tearoff            | 1. 默认情况下菜单可以被“撕下”（点击 IDLE 菜单上边的 --------- 试试） 2. 将该选项设置为 Flase 关闭这一特性                                                                                                              |
| tearoffcommand     | 如果你希望当用户“撕下”你的菜单时通知你的程序，那么你可以将该选项与一个方法相关联，那么当用户“撕下”你的菜单时，Tkinter 会带着两个参数去调用你的方法（一个参数是当前窗口的 ID，另一个参数是承载被“撕下”的菜单的窗口 ID） |
| title              | 默认情况下，被“撕下”的菜单标题是其主菜单的名字，不过你也可以通过修改此项的值来修改标题                                                                                                                                 |

#### 方法

**add(type, \*\*options)**
-- type 参数指定添加的菜单类型，可以是："command"，"cascade"，"checkbutton"，"radiobutton" 或 "separator"
-- 还可以通过 options 选项设置菜单的属性，下表列举了 options 可以使用的选项和具体含义：

| **选项**         | **含义**                                                                                                                                                                                                                                                                       |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| accelerator      | 1. 显示该菜单项的加速键（快捷键） 2. 例如 accelerator = "Ctrl+N" 3. 该选项仅显示，并没有实现加速键的功能（通过按键绑定实现）                                                                                                                                                   |
| activebackground | 设置当该菜单项处于 "active" 状态（通过 state 选项设置状态）的背景色                                                                                                                                                                                                            |
| activeforeground | 设置当该菜单项处于 "active" 状态（通过 state 选项设置状态）的前景色                                                                                                                                                                                                            |
| background       | 设置该菜单项的背景颜色                                                                                                                                                                                                                                                         |
| bitmap           | 指定显示到该菜单项上的位图                                                                                                                                                                                                                                                     |
| columnbreak      | 从该菜单项开始另起一列显示                                                                                                                                                                                                                                                     |
| **command**      | 将该选项与一个方法相关联，当用户点击该菜单项时将自动调用此方法                                                                                                                                                                                                                 |
| compound         | 1. 控制菜单项中文本和图像的混合模式 2. 如果该选项设置为 "center"，文本显示在图像上（文本重叠图像） 3. 如果该选项设置为 "bottom"，"left"，"right" 或 "top"，那么图像显示在文本的旁边（如 "bottom"，则图像在文本的下方                                                           |
| font             | 指定文本的字体                                                                                                                                                                                                                                                                 |
| foreground       | 设置前景色                                                                                                                                                                                                                                                                     |
| hidemargin       | 是否显示菜单项旁边的空白                                                                                                                                                                                                                                                       |
| image            | 1. 指定菜单项显示的图片 2. 该值应该是 PhotoImage，BitmapImage，或者能兼容的对象                                                                                                                                                                                                |
| label            | 指定菜单项显示的文本                                                                                                                                                                                                                                                           |
| **menu**         | 1. 该选项仅在 cascade 类型的菜单中使用 2. 用于指定它的下级菜单                                                                                                                                                                                                                 |
| offvalue         | 1. 默认情况下，variable 选项设置为 1 表示选中状态，反之设置为 0 2. 设置 offvalue 的值可以自定义未选中状态的值                                                                                                                                                                  |
| onvalue          | 1. 默认情况下，variable 选项设置为 1 表示选中状态，反之设置为 0 2. 设置 onvalue 的值可以自定义选中状态的值                                                                                                                                                                     |
| selectcolor      | 指定当菜单项显示为单选按钮或多选按钮时选择中标志的颜色                                                                                                                                                                                                                         |
| selectimage      | 如果你在单选按钮或多选按钮菜单中使用图片代替文本，那么设置该选项指定被菜单项被选中时显示的图片                                                                                                                                                                                 |
| state            | 1. 跟 text 选项一起使用，用于指定哪一个字符画下划线（例如用于表示键盘快捷键）                                                                                                                                                                                                  |
| underline        | 1. 用于指定在该菜单项的某一个字符处画下划线 2. 例如设置为 1，则说明在该菜单项的第 2 个字符处画下划线                                                                                                                                                                           |
| value            | 1. 当菜单项为单选按钮时，用于标志该按钮的值 2. 在同一组中的所有按钮应该拥有各不相同的值 3. 通过将该值与 variable 选项的值对比，即可判断用户选中了哪个按钮 4. 如在使用上有不懂具体可以参照 [Radiobutton](https://blog.csdn.net/qq_41556318/article/details/85108309) 组件的说明 |
| variable         | 1. 当菜单项是单选按钮或多选按钮时，与之关联的变量 2. 如在使用上有不懂具体可以参照：[Checkbutton](https://blog.csdn.net/qq_41556318/article/details/85108303) 和 [Radiobutton](https://blog.csdn.net/qq_41556318/article/details/85108309) 组件的说明                           |

==***add_cascade(\*\*options)***==
-- 添加一个父菜单
-- 相当于 add("cascade", **options)

**add_checkbutton(\**options)**
-- 添加一个多选按钮的菜单项
-- 相当于 add("checkbutton", **options)

==***add_command(\*\*options)***==
-- 添加一个普通的命令菜单项
-- 相当于 add("command", **options)

**add_radiobutton(\**options)**
-- 添加一个单选按钮的菜单项
-- 相当于 add("radiobutton", **options)

**add_separator(\**options)**
-- 添加一条分割线
-- 相当于 add("separator", **options)

**delete(index1, index2=None)**
-- 删除 index1 ~ index2（包含）的所有菜单项
-- 如果忽略 index2 参数，则删除 index1 指向的菜单项
-- 注意：对于一个被“撕下”的菜单，你无法使用该方法

**entrycget(index, option)**
-- 获得指定菜单项的某选项的值

**entryconfig(index, \**options)**
-- 设置指定菜单项的选项
-- 选项的参数及具体含义请参考上方 add() 方法

**entryconfigure(index, \**options)**
-- 跟 entryconfig() 一样

**index(index)**
-- 返回与 index 参数相应的选项的序号（例如 e.index("end")）

**insert(index, itemType, \**options)**
-- 插入指定类型的菜单项到 index 参数指定的位置
-- itemType 参数指定添加的菜单类型，可以是："command"，"cascade"，"checkbutton"，"radiobutton" 或 "separator"
-- 选项的参数及具体含义请参考上方 add() 方法

**insert_cascade(index, \**options)**
-- 在 index 参数指定的位置添加一个父菜单
-- 相当于 insert("cascade", **options)

**insert_checkbutton(index, \**options)**
-- 在 index 参数指定的位置添加一个多选按钮
-- 相当于 insert("checkbutton", **options)

**insert_command(index, \**options)**
-- 在 index 参数指定的位置添加一个普通的命令菜单项
-- 相当于 insert("command", **options)

**insert_radiobutton(index, \**options)**
-- 在 index 参数指定的位置添加一个单选按钮
-- 相当于 insert("radiobutton", **options)

**insert_separator(index, \**options)**
-- 在 index 参数指定的位置添加一条分割线
-- 相当于 insert("separator", **options)

**invoke(index)**
-- 调用 index 指定的菜单项相关联的方法
-- 如果是单选按钮，设置该菜单项为选中状态
-- 如果是多选按钮，切换该菜单项的选中状态

**post(x, y)**
-- 在指定的位置显示弹出菜单
-- 参考上创建弹窗菜单的例子

**type(index)**
-- 获得 index 参数指定菜单项的类型
-- 返回值可以是："command"，"cascade"，"checkbutton"，"radiobutton" 或 "separator"

**unpost()**
-- 移除弹出菜单

**yposition(index)**
-- 返回 index 参数指定的菜单项的垂直偏移位置
-- 该方法的目的是为了让你精确放置相对于当前鼠标的位置弹出菜单

## 布局管理器

pack、grid 和 place 均用于管理同在一个父组件下的所有组件的布局，其中：

- pack 是按添加顺序排列组件
- grid 是按行/列形式排列组件
- place 则允许程序员指定组件的大小和位置

我们常常会遇到的一个情况是将一个组件放到一个容器组件中，并填充整个父组件

### pack

默认下，pack 是将添加的组件依次纵向排列

如果想要组件横向挨个儿排放，你可以使用 side 选项

```python
import tkinter as tk
 
root = tk.Tk()
 
listbox = tk.Listbox(root)
listbox.pack(fill="both", expand=True)
 
for i in range(10):
        listbox.insert("end", str(i))
 
root.mainloop()
```

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203221444206.png" alt="image-20210203221444206"  />

#### 参数

**pack(\**options)**

-- 下方表格详细列举了各个选项的具体含义和用法：

| **选项**   | **含义**                                                                                                                                                              |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| anchor     | 1. 控制组件在 pack 分配的空间中的位置 2. "n", "ne", "e", "se", "s", "sw", "w", "nw", 或者 "center" 来定位（ewsn 代表东西南北，上北下南左西右东） 3. 默认值是 "center" |
| **expand** | 1. 指定是否填充父组件的额外空间 2. 默认值是 False                                                                                                                     |
| **fill**   | 1. 指定填充 pack 分配的空间 2. 默认值是 NONE，表示保持子组件的原始尺寸 3. 还可以使用的值有："x"（水平填充），"y"（垂直填充）和 "both"（水平和垂直填充）               |
| in_        | 1. 将该组件放到该选项指定的组件中 2. 指定的组件必须是该组件的父组件                                                                                                   |
| ipadx      | 指定水平方向上的内边距                                                                                                                                                |
| ipady      | 指定垂直方向上的内边距                                                                                                                                                |
| padx       | 指定水平方向上的外边距                                                                                                                                                |
| pady       | 指定垂直方向上的外边距                                                                                                                                                |
| **side**   | 1. 指定组件的放置位置 2. 默认值是 "top" 3. 还可以设置的值有："left"，"bottom"，"right"                                                                                |

### grid

使用 grid 排列组件，只需告诉它你想要将组件放置的位置（行/列，row 选项指定行，cloumn 选项指定列）。此外，你并不用提前指出网格（grid 分布给组件的位置称为网格）的尺寸，因为管理器会自动计算

```python
import tkinter as tk
 
root = tk.Tk()
 
# column 默认值是 0
tk.Label(root, text="用户名").grid(row=0)
tk.Label(root, text="密码").grid(row=1)
 
tk.Entry(root).grid(row=0, column=1)
tk.Entry(root, show="*").grid(row=1, column=1)
 
root.mainloop()
```

![image-20210203222402496](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203222402496.png)

默认情况下组件会居中显示在对应的网格里，你可以使用 sticky 选项来修改这一特性

有时候你可能需要用几个网格来放置一个组件，你只需要指定 rowspan 和 columnspan 就可以实现跨行和跨列的功能

#### 参数

**grid(\**options)**
-- 下方表格详细列举了各个选项的具体含义和用法：

| **选项**       | **含义**                                                                                                                                                                                                                                                                |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **column**     | 1. 指定组件插入的列（0 表示第 1 列） 2. 默认值是 0                                                                                                                                                                                                                      |
| **columnspan** | 指定用多少列（跨列）显示该组件                                                                                                                                                                                                                                          |
| in_            | 1. 将该组件放到该选项指定的组件中 2. 指定的组件必须是该组件的父组件                                                                                                                                                                                                     |
| ipadx          | 指定水平方向上的内边距                                                                                                                                                                                                                                                  |
| ipady          | 指定垂直方向上的内边距                                                                                                                                                                                                                                                  |
| padx           | 指定水平方向上的外边距                                                                                                                                                                                                                                                  |
| pady           | 指定垂直方向上的外边距                                                                                                                                                                                                                                                  |
| **row**        | 指定组件插入的行（0 表示第 1 行）                                                                                                                                                                                                                                       |
| **rowspan**    | 指定用多少行（跨行）显示该组件                                                                                                                                                                                                                                          |
| **sticky**     | 1. 控制组件在 grid 分配的空间中的位置 2. 可以使用 "n", "e", "s", "w" 以及它们的组合来定位（ewsn代表东西南北，上北下南左西右东） 3. 使用加号（+）表示拉长填充，例如 "n" + "s" 表示将组件垂直拉长填充网格，"n" + "s" + "w" + "e" 表示填充整个网格 4. 不指定该值则居中显示 |

### place

通常情况下不建议使用 place 布局管理器，因为对比起 pack 和 grid，place 要做更多的工作。不过纯在即合理，place 在一些特殊的情况下可以发挥妙用

```python
import tkinter as tk
 
root = tk.Tk()
 
def callback():
    print("正中靶心")
 
tk.Button(root, text="点我", command=callback).place(relx=0.5, rely=0.5, anchor="center")
 
root.mainloop()
```

![image-20210203222650526](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203222650526.png)

relx 和 rely 选项指定的是相对于父组件的位置，范围是 00 ~ 1.0，因此 0.5 表示位于正中间。那么 relwidth 和 relheight 选项则是指定相对于父组件的尺寸

#### 参数

**place(\**options)**
-- 下方表格详细列举了各个选项的具体含义和用法：

| **选项**      | **含义**                                                                                                                                                        |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| anchor        | 1. 控制组件在 place 分配的空间中的位置 2. "n", "ne", "e", "se", "s", "sw", "w", "nw", 或 "center" 来定位（ewsn代表东西南北，上北下南左西右东） 3. 默认值是 "nw" |
| bordermode    | 1. 指定边框模式（"inside" 或 "outside"） 2. 默认值是 "inside"                                                                                                   |
| height        | 指定该组件的高度（像素）                                                                                                                                        |
| in_           | 1. 将该组件放到该选项指定的组件中 2. 指定的组件必须是该组件的父组件                                                                                             |
| **relheight** | 1. 指定该组件相对于父组件的高度 2. 取值范围 0.0 ~ 1.0                                                                                                           |
| **relwidth**  | 1. 指定该组件相对于父组件的宽度 2. 取值范围 0.0 ~ 1.0                                                                                                           |
| **relx**      | 1. 指定该组件相对于父组件的水平位置 2. 取值范围 0.0 ~ 1.0                                                                                                       |
| **rely**      | 1. 指定该组件相对于父组件的垂直位置 2. 取值范围 0.0 ~ 1.0                                                                                                       |
| width         | 指定该组件的宽度（像素）                                                                                                                                        |
| x             | 1. 指定该组件的水平偏移位置（像素） 2. 如同时指定了 relx 选项，优先实现 relx 选项                                                                               |
| y             | 1. 指定该组件的垂直偏移位置（像素） 2. 如同时指定了 rely 选项，优先实现 rely 选项                                                                               |

## 标准对话框

Tkinter 为了提供了三种标准对话框模块，它们分别是：

- messagebox
- filedialog
- colorchooser

### messagebox（消息对话框）

```python
import tkinter as tk
from tkinter import messagebox
 
messagebox.askokcancel("Python Demo", "发射核弹？")
 
tk.mainloop()
```

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203223132391.png" alt="image-20210203223132391" style="zoom:77%;" />

#### 标准对话框样式

| **使用函数**                            | **对话框样式**                                                                        |
| --------------------------------------- | ------------------------------------------------------------------------------------- |
| askokcancel(title, message, options)    | ![img](https://img-blog.csdnimg.cn/20190102102603983.png)                             |
| askquestion(title, message, options)    | ![img](https://img-blog.csdnimg.cn/20190102104400724.png)                             |
| askretrycancel(title, message, options) | ![img](https://img-blog.csdnimg.cn/20190102104522848.png)                             |
| askyesno(title, message, options)       | ![img](https://img-blog.csdnimg.cn/20190102104602651.png)                             |
| showerror(title, message, options)      | ![img](https://img-blog.csdnimg.cn/2019010210464195.png)                              |
| showinfo(title, message, options)       | ![img](https://img-blog.csdnimg.cn/20190102104752798.png)                             |
| showwarning(title, message, options)    | ![img](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20190102104846588.png) |

#### 参数

所有的这些函数都有相同的参数：

- title 参数毋庸置疑是设置标题栏的文本
- message 参数是设置对话框的主要文本内容，你可以用 '\n' 来实现换行
- options 参数可以设置的选项和含义如下表所示

| **选项** | **含义**                                                                                                                                                                          |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| default  | 1. 设置默认的按钮（也就是按下回车响应的那个按钮） 2. 默认是第一个按钮（像“确定”，“是”或“重试”） 3. 可以设置的值根据对话框函数的不同可以选择：CANCEL，IGNORE，OK，NO，RETRY 或 YES |
| icon     | 1. 指定对话框显示的图标 2. 可以指定的值有：ERROR，INFO，QUESTION 或 WARNING 3. 注意：不能指定自己的图标                                                                           |
| parent   | 1. 如果不指定该选项，那么对话框默认显示在根窗口上 2. 如果想要将对话框显示在子窗口 w 上，那么可以设置 parent=w                                                                     |

#### 返回值

askokcancel()，askretrycancel() 和 askyesno() 返回布尔类型的值：

- 返回 True 表示用户点击了“确定”或“是”按钮
- 返回 False 表示用户点击了“取消”或“否”按钮

askquestion() 返回“yes”或“no”字符串表示用户点击了“是”或“否”按钮

showerror()，showinfo() 和 showwarning() 返回“ok”表示用户按下了“是”按钮

### filedialog（文件对话框）

当你的应用程序需要使用打开文件或保存文件的功能时，文件对话框显得尤为重要

```python
import tkinter as tk
from tkinter import filedialog
root = tk.Tk()
 
def callback():
    fileName = filedialog.askopenfilename()
    print(fileName)
 
tk.Button(root, text="打开文件", command=callback).pack()
 
root.mainloop()
```

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203225057051.png" alt="image-20210203225057051" style="zoom:67%;" />

filedialog 模块提供了两个函数：askopenfilename(\*\*option) 和 asksaveasfilename(\*\*option)，分别用于打开文件和保存文件

#### 参数

两个函数可供设置的选项是一样的，下边列举了可用的选项及含义：

| **选项**             | **含义**                                                                                                                                                                            |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **defaultextension** | 1. 指定文件的后缀 2. 例如：defaultextension=".jpg"，那么当用户输入一个文件名 "logo" 的时候，文件名会自动添加后缀为 "logo.jpg" 3. 注意：如果用户输入文件名包含后缀，那么该选项不生效 |
| filetypes            | 1. 指定筛选文件类型的下拉菜单选项 2. 该选项的值是由 2 元祖构成的列表 3. 每个 2 元祖由（类型名，后缀）构成，例如：filetypes=[("PNG", ".png"), ("JPG", ".jpg"), ("GIF", ".gif")]      |
| **initialdir**       | 1. 指定打开/保存文件的默认路径 2. 默认路径是当前文件夹                                                                                                                              |
| parent               | 1. 如果不指定该选项，那么对话框默认显示在根窗口上 2. 如果想要将对话框显示在子窗口 w 上，那么可以设置 parent=w                                                                       |
| **title**            | 指定文件对话框的标题栏文本                                                                                                                                                          |

#### 返回值

1. 如果用户选择了一个文件，那么返回值是该文件的完整路径

2. 如果用户点击了取消按钮，那么返回值是空字符串

### colorchooser（颜色选择对话框）

颜色选择对话框提供一个友善的界面让用户选择需要的颜色

```python
import tkinter as tk
from tkinter import colorchooser
 
root = tk.Tk()
 
def callback():
    fileName = colorchooser.askcolor()
    print(fileName)
 
tk.Button(root, text="选择颜色", command=callback).pack()
 
root.mainloop()
```

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210203223907695.png" alt="image-20210203223907695" style="zoom:67%;" />

##### 参数

askcolor(color, **option) 函数的 color 参数用于指定初始化的颜色，默认是浅灰色；

option 参数可以指定的选项及含义如下：

| **选项** | **含义**                                                                                                      |
| -------- | ------------------------------------------------------------------------------------------------------------- |
| title    | 指定颜色对话框的标题栏文本                                                                                    |
| parent   | 1. 如果不指定该选项，那么对话框默认显示在根窗口上 2. 如果想要将对话框显示在子窗口 w 上，那么可以设置 parent=w |

##### 返回值

1. 如果用户选择一个颜色并按下“确定”按钮后，返回值是一个 2 元祖，第 1 个元素是选择的 RGB 颜色值，第 2 个元素是对应的 16 进制颜色值

2. 如果用户按下“取消”按钮，那么返回值是 (None, None)