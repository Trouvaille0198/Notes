# 简介
## 模块
- QtWidgets ：包含了一整套的 UI 元素控件，用于建立符合系统风格的界面
- QtGui：涵盖了多种基本图形功能的类(字体，图形，图标，颜色)
- QtCore：涵盖了包的核心的非 GUI 界面的功能(时间，文件，目录，数据类型，文本流，链接，线程进程等)
- QtWebKit：显示网页
- QtTest：对 Qt 应用程序和库进行单元测试的类
- QtSql：提供对 SQL 数据库支持的基本模块
- QtMultimedia：多媒体，比如音频，视频
- QtMultimediaWidgets：多媒体，比如音频，视频
## 程序基本结构分析
### 导入需要的包和模块
```python
from PyQt5.Qt import *    # 别问为什么这么写，问就是懒，这样做的好处是可以不管什么包都导入，不需要一点点导包，缺点就是占点内存
import sys
```
sys是什么
```python
# sys是什么
# 我们的代码，到时候的执行方式，1、右击run去执行，2、命令行Python代码名称

# argv:当别人通过命令行启动这个程序的时候，可以设定一种功能(接收命令行传递的参数来执行不同的业务逻辑)
args = sys.argv
print(args)
if args[1] == '1':
	print("hello world")
else:
	print("hello pyqt")

# exit(退出码)，正常退出是0，程序内部错误是其他的错误码，通过传递不同的错误码，可以知道怎么退出的。
sys.exit()
```
### 创建一个应用程序对象
```python
app = QApplication(sys.argv)
```
sys.argv 参数是来自命令行的参数列表。 Python 脚本可以从 shell 运行。 写了这句话就能让我们的程序从命令行启动

`QApplication` 管理 GUI 程序的控制流和主要设置。对于用 Qt 写的任何一个 GUI 应用，不管这个应用有没有窗口或多少个窗口，有且只有一个 `QApplication` 对象。

### 控件操作

```python
# 创建控件，设置控件(大小，位置，样式)，事件，信号的处理

# 1、创建控件
# 控件创建好后(没有父控件)，则把它当作顶层控件(窗口)，系统会自动的给窗口添加一些装饰(标题栏)，窗口控件具备一些性质(设置标题，图标)
window = QWidget()

# 2、设置控件
window.setWindowTitle("程序基本结构分析") # 设置窗口标题
window.resize(300,150) # 设置窗口尺寸，长宽
w.move(300,300)  # 移动窗口(显示时在哪),长高

# 控件也可以作为一个容器承载其他控件
label = QLabel(window)
label.setText('hello world')
lable.move(100,100)

# 3、展示控件
# 刚创建好一个控件后(没父控件)，需要手动展示
window.show()
```
`QWidget` 控件（所有的窗口和控件都直接或者间接继承自 `QWidget`）是一个用户界面的基础控件，它提供了基本的应用构造器。默认情况下，构造器是没有父级的，没有父级的构造器被称为窗口（window）。

PyQt5 创建的窗口默认是隐藏的，需要调用 `show()` 显示

### 应用程序的执行，进入到消息循环

```python
# 让整个程序开始执行，并且进入到消息循环(无限循环)
# 监测整个程序所接收到的用户交互信息
sys.exit(app.exec_())
```
为了让 GUI 启动，需要使用 `app.exec_()` 启动事件循环（启动应用，直至用户关闭它）。

`app.exec_()` 的作用是运行主循环，必须调用此函数才能开始事件处理，调用该方法进入程序的主循环直到调用 `exit()` 结束

### 将面向过程的代码改为面向对象版本

可以理解为界面与逻辑分离
设置控件的代码需要被维护，控件的设置又是通过类来完成的，那么只要在类的内部去添加就可以，但是类又是封装好的，所以要通过继承去实现，然后通过 `__init__` 方法，再加上 `super` 来继承父类的所有方法，以后就只需要在 `__init__` 方法内部去写设置就可以了。
```python
from PyQt5.QtWidgets import QApplication, QWidget, QLabel

class Window(QWidget):
    def __init__(self):
        super().__init__()
        self.resize(300, 150)
        self.move(300, 300)
        self.setWindowTitle('第一个基于PyQt5的桌面应用')
        self.setup_ui()

    def setup_ui(self):
        label = QLabel(self)
        label.setText('hello world')
        label.move(100, 100)
```
使用的时候，只需要在引入时，引入这个文件就可以
```python
import sys
from PyQt5.QtWidgets import QApplication, QWidget, QLabel

from ui import Window

if __name__ == '__main__':
    # 创建一个QApplication类的实例
    app = QApplication(sys.argv)
    # 创建一个窗口
    window = Window()
    # 显示窗口
    window.show()
    # 进入程序主循环，并通过exit函数确保主循环安全结束
    sys.exit(app.exec_())
```
## 事件与信号处理

(signals and slots)

GUI 应用程序是事件驱动的。在事件模型中，有三个参与者：

- 事件来源：状态被更改的对象，它生成了事件
- 事件对象：（event）将状态的更改封装在事件源中
- 事件目标：要通知的对象

PyQt5 具有独特的信号和插槽机制来处理事件。 信号和槽用于对象之间的通信。 发生特定事件时发出信号。 槽可以是任何 Python 可调用的函数。 当发射连接的信号时会调用一个槽。槽是对信号作出反应的方法。

- 重写事件

- 知晓事件发送者

若有多个信号连接到同一个槽，需要调用 `sender()` 方法来确定

- 发出自定义信号

从 QObject 创建的对象可以发出信号

# 窗口

窗口就是没有父部件的部件，所以又称为顶级部件

`QMainWindow` 窗口可以包含菜单栏、工具栏、状态栏和标题栏等，是最常见的窗口形式，是 GUI 程序的主窗口。

`QDialog` 是对话框的基类，对话框主要用来执行短期任务和与用户进行互动任务，有模态和非模态两种形式。

`QWidget` 可以用作嵌入其他窗口。

## 父类操作 QWidget

`QWidget` 类是所有用户界面对象的基类，被称为基础窗口部件。像主窗口、对话框、标签、还有按钮、文本输入框等都是窗口部件

- 客户区 (Client Area)：不包含边框的部分，即用户操作的界面，可以添加子控件。
- 窗口：整一个界面

![img](http://image.trouvaille0198.top/1114626-dace58b6414623d5.png)

### 获取大小

- ***QWidget.size()***

    返回 `PyQt5.QtCore.QSize(width, height)`

- ***QWidget.width()、QWidget.height()***

    返回客户区 width 和 height 值

- ***QWidget.frameGeometry().width()、QWidget.frameGeometry().height()***

    返回窗口 width 和 height 值

### 设置大小

- ***QWidget.resize(width, height)***

    改变客户区的大小，可以通过鼠标的来改变尺寸

- ***QWidget.setFixedWidth(int width)、QWidget.setFixedHeight(int height)***

    设定不可使用鼠标修改的宽度或者高度

- ***QWidget.setFixedSize(width, height)***

    设定不可使用鼠标修改的宽度和高度

### 获取位置

- ***QWidget.pos()***

    返回窗口左上角坐标

- ***QWidget.x()、QWidget.y()***

    返回窗口横、纵坐标

- ***QWidget.geometry().x()、QWidget.geometry().y()***

    返回客户区横、纵坐标


### 设置位置

- ***QWidget.move(int x, int y)***

    设置窗口的位置

### 同时设置

- ***QWidget.frameGeometry()***

    返回窗口的大小和位置

- ***QWidget.setGeometry(int x, int y, int width, int height)***

    同时客户区设置大小和位置

### 初始化

- ***QWidget.setWindowIcon(QIcon)***

    设置窗口图标

- ***QWidget.setWindowTitle(title)***

    设置窗口标题

- ***QWidget.setToolTip(str)***

    显示气泡提示信息

## 设置主窗口类 QMainWindow

`QWidget` 可以作为嵌套型的窗口存在，结构简单，而 `QMainWindow` 是一个程序框架，有自己的布局，可以在布局中添加控件，如将工具栏添加到布局管理器中。它常常作为 GUI 的主窗口

主窗口在 GUI 程序是唯一的，是所有窗口中的最顶层窗口，其他窗口都是它的直接或间接子窗口

`QMainWindow` 继承自 `QWidget` 类，拥有 `QWidget` 所有的派生方法和属性。

### 状态栏 statusBar

- ***QMAinWindow.statusBar()***

    设置并返回状态栏对象

- ***QMAinWindow.StatusBar().showMessage(message, int timeout)***：显示状态栏信息

    - *message*：str，文本信息
    - *timeout*：int，显示时间，单位毫秒，默认为0，表示一直显示状态栏信息

```python
import sys
from PyQt5.QtWidgets import QMainWindow, QApplication
class MainWidget(QMainWindow):
    def __init__(self, parent=None):
        super().__init__(parent)
        # 设置主窗体标签
        self.setWindowTitle("QMainWindow 例子")         
        self.resize(400, 200) 
        self.status = self.statusBar() 
        # 秒后状态栏消失
        self.status.showMessage("这是状态栏提示", 5000)

if __name__ == "__main__": 
    app = QApplication(sys.argv)
    main = MainWidget()
    main.show()
    sys.exit(app.exec_())
```

![image-20210211155643867](http://image.trouvaille0198.top/image-20210211155643867.png)

### 菜单栏 menuBar

菜单栏是一组命令的集合

- ***QMAinWindow.menuBar()***

    设置并返回菜单栏对象

- ***menuBar.addMenu(str)***

    在菜单栏中添加菜单

    *str*：菜单名

- ***menu.addMenu(qmenu)***

    往菜单中添加子菜单

    *qmenu*：QMenu 对象

- ***menu.addAction(qaction)***

    往菜单中添加操作

    *qaction*：QAction 对象

- ***menu.addSeperator()***

    往菜单中添加分隔线

#### 简单菜单例

```python
import sys
from PyQt5.QtWidgets import QMainWindow, QAction, qApp, QApplication
from PyQt5.QtGui import QIcon


class Example(QMainWindow):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        # 初始化
        self.statusBar()
        self.setGeometry(300, 300, 300, 200)
        self.setWindowTitle('Simple menu')
        
        # 创建一个图标、一个 exit 的标签和一个快捷键组合，都执行了一个动作
        exitAct = QAction(QIcon('7092.gif'), '&Exit', self)
        exitAct.setShortcut('Ctrl+Q')
        # 创建了一个状态栏，当鼠标悬停在菜单栏的时候，能显示当前状态
        exitAct.setStatusTip('Exit application')
        # 当执行这个指定的动作时，就触发了一个事件。
        # 这个事件跟 QApplication 的 quit() 行为相关联，所以这个动作就能终止这个应用。
        exitAct.triggered.connect(qApp.quit)

        # 创建菜单栏
        menubar = self.menuBar()
        fileMenu = menubar.addMenu('&File')
        fileMenu.addAction(exitAct)

        self.show()


def main():
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
```

![image-20210212145400143](http://image.trouvaille0198.top/image-20210212145400143.png)

在上面的例子中，我们用一个菜单创建一个菜单。 此菜单将包含一个选择时终止应用程序的操作。 还创建状态栏。 该操作可通过Ctrl + Q快捷方式访问

QAction 是使用菜单栏，工具栏或自定义键盘快捷方式执行操作的抽象。在上述三行中，我们创建一个具有特定图标和“退出”标签的动作。此外，为此操作定义了快捷方式。当我们选择这个特定的动作时，发出触发信号。 信号连接到 QApplication 小部件的 `quit()` 方法。 这终止了应用程序。

#### 子菜单例

```python
# coding=utf-8

from PyQt5.QtWidgets import QApplication, QMainWindow, QAction, qApp, QMenu
from PyQt5.QtGui import QIcon
import sys


class Example(QMainWindow):
    def __init__(self):
        super().__init__()
        self.InitUI()

    def InitUI(self):
        self.statusBar().showMessage('准备就绪')

        self.setGeometry(300, 300, 400, 300)
        self.setWindowTitle('关注微信公众号：学点编程吧--子菜单')

        exitAct = QAction(QIcon('exit.png'), '退出(&E)', self)
        exitAct.setShortcut('Ctrl+Q')
        exitAct.setStatusTip('退出程序')
        exitAct.triggered.connect(qApp.quit)

        saveMenu = QMenu('保存方式(&S)', self)
        saveAct = QAction(QIcon('save.png'), '保存...', self)
        saveAct.setShortcut('Ctrl+S')
        saveAct.setStatusTip('保存文件')
        saveasAct = QAction(QIcon('saveas.png'), '另存为...(&O)', self)
        saveasAct.setStatusTip('文件另存为')
        saveMenu.addAction(saveAct)
        saveMenu.addAction(saveasAct)

        newAct = QAction(QIcon('new.png'), '新建(&N)', self)
        newAct.setShortcut('Ctrl+N')

        menubar = self.menuBar()
        fileMenu = menubar.addMenu('文件(&F)')
        fileMenu.addAction(newAct)
        fileMenu.addMenu(saveMenu)
        fileMenu.addSeparator()
        fileMenu.addAction(exitAct)

        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())
```

![image-20210212153342602](http://image.trouvaille0198.top/image-20210212153342602.png)

在这个例子中，我们有三个菜单项： 其中两个位于文件菜单中（新建、退出），另一个位于文件的保存子菜单中

#### 上下文菜单

```python
import sys
from PyQt5.QtWidgets import QMainWindow, qApp, QMenu, QApplication


class Example(QMainWindow):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setGeometry(300, 300, 300, 200)
        self.setWindowTitle('Context menu')
        self.show()

    def contextMenuEvent(self, event):
        cmenu = QMenu(self)
        newAct = cmenu.addAction("New")
        openAct = cmenu.addAction("Open")
        quitAct = cmenu.addAction("Quit")
        # 使用 exec_() 方法显示菜单。从鼠标右键事件对象中获得当前坐标。
        # mapToGlobal() 方法把当前组件的相对坐标转换为窗口（window）的绝对坐标。
        action = cmenu.exec_(self.mapToGlobal(event.pos()))


def main():
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
```

![image-20210212154037291](http://image.trouvaille0198.top/image-20210212154037291.png)

要使用上下文菜单，我们必须重新实现 `contextMenuEvent()` 方法

使用 `exec_()` 方法显示上下文菜单。 从事件对象获取鼠标指针的坐标。 `mapToGlobal()` 方法将窗口小部件坐标转换为全局屏幕坐标

### 工具栏

各项命令都是在菜单栏当中，但是我们可以把一些常用的命令放在工具栏上，例如新建、打开、保存等等

- ***QMAinWindow.addToolBar()***

    设置并返回工具栏对象

- ***tool.addAction(qaction)***

    往工具栏中添加操作

    *qaction*：QAction 对象

```python
# coding=utf-8

from PyQt5.QtWidgets import QApplication, QMainWindow, QAction, qApp, QMenu
from PyQt5.QtGui import QIcon
import sys


class Example(QMainWindow):
    def __init__(self):
        super().__init__()
        self.InitUI()

    def InitUI(self):
        self.statusBar().showMessage('准备就绪')

        self.setGeometry(300, 300, 400, 300)
        self.setWindowTitle('Toolbar')

        exitAct = QAction(QIcon('exit.png'), '退出(&E)', self)
        exitAct.setShortcut('Ctrl+Q')
        exitAct.setStatusTip('退出程序')
        exitAct.triggered.connect(qApp.quit)

        saveMenu = QMenu('保存方式(&S)', self)
        saveAct = QAction(QIcon('save.png'), '保存...', self)
        saveAct.setShortcut('Ctrl+S')
        saveAct.setStatusTip('保存文件')
        saveasAct = QAction(QIcon('saveas.png'), '另存为...(&O)', self)
        saveasAct.setStatusTip('文件另存为')
        saveMenu.addAction(saveAct)
        saveMenu.addAction(saveasAct)

        newAct = QAction(QIcon('new.png'), '新建(&N)', self)
        newAct.setShortcut('Ctrl+N')
        newAct.setStatusTip('新建文件')

        menubar = self.menuBar()
        fileMenu = menubar.addMenu('文件(&F)')
        fileMenu.addAction(newAct)
        fileMenu.addMenu(saveMenu)
        fileMenu.addSeparator()
        fileMenu.addAction(exitAct)

        toolbar = self.addToolBar('工具栏')
        toolbar.addAction(newAct)
        toolbar.addAction(exitAct)

        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())
```

![image-20210212154545698](http://image.trouvaille0198.top/image-20210212154545698.png)

### 居中展示

`QMainWindow` 利用 `QDesktopWidget` 类实现窗口居中显示

```python
from PyQt5.QtWidgets import QDesktopWidget, QApplication, QMainWindow
import sys

class Winform(QMainWindow):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle('主窗口放在屏幕中间例子')
        self.resize(300, 200)
        self.center()

    def center(self):
        # 获取屏幕信息
        screen = QDesktopWidget().screenGeometry()
        size = self.geometry()
        x = int((screen.width() - size.width()) / 2)
        y = int((screen.height() - size.height()) / 2)
        self.move(x, y)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    win = Winform()
    win.show()
    sys.exit(app.exec_())
```

也可以直接使用 `QDesktopWidget().availableGeometry().center()` 设置窗口居中

```python
import sys
from PyQt5.QtWidgets import QWidget, QDesktopWidget, QApplication

class CenterWin(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):               
        self.resize(250, 150)
        self.center()
        self.setWindowTitle('Center')    
        self.show()

    def center(self):
        qr = self.frameGeometry() # 获得主窗口所在的框架
        # 获取显示器的分辨率，然后得到屏幕中间点的位置
        cp = QDesktopWidget().availableGeometry().center()
        # 然后把主窗口框架的中心点放置到屏幕的中心位置
        qr.moveCenter(cp)
        # 然后通过 move 函数把主窗口的左上角移动到其框架的左上角，这样就把窗口居中了
        self.move(qr.topLeft())

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = CenterWin()
    sys.exit(app.exec_())
```

# 布局

一般有两种方式：绝对布局 （absolute positioning）和 PyQt5 的 Layout 类

Layout 布局方式分为盒布局、网格布局、表单布局。

## 绝对布局

(absolute positioning)

绝对布局主要是在窗口程序中指定每一个控件的显示坐标和大小来实现布局

缺点

- 窗口中控件的大小和位置不会随着我们更改窗口的位置和大小而变化。
- 不能适用于不同的平台和不同分辨率的显示器。
- 改变字体时可能会破坏布局。
- 如果我们决定重构这个应用，需要全部计算一下每个元素的位置和大小，既烦琐又费时。

## 盒布局

采用 `QBoxLayout` 类可以在水平和垂直方向上排列控件，分别为：`QHBoxLayout` 和 `QVBoxLayout`

- ***QBoxLayout.addStretch(int stretch)***

    添加伸缩量

    *strentch*：均分的比例，默认为0

- ***QBoxLayout.addSpacing(int size)***

    添加一个固定大小的间距

    *size*：间距

- ***QBoxLayout.addWidget(QWidget)***

    在布局中添加控件

- ***QBoxLayout.addLayout(QBoxLayout)***

    添加一个盒布局对象

- ***QWidget.setLayout(QBoxLayout)***

    设置窗口的主要布局

```python
#coding = 'utf-8'

import sys
from PyQt5.QtWidgets import (QWidget, QPushButton, QApplication, QHBoxLayout,QVBoxLayout)


class Example(QWidget):
    def __init__(self):
        super().__init__()
        self.Init_UI()

    def Init_UI(self):
        self.setGeometry(300, 300, 400, 300)
        self.setWindowTitle('学点编程吧')

        bt1 = QPushButton('剪刀', self)
        bt2 = QPushButton('石头', self)
        bt3 = QPushButton('布', self)

        hbox = QHBoxLayout()
        hbox.addStretch(1)  # 增加伸缩量
        hbox.addWidget(bt1)
        hbox.addStretch(1)  # 增加伸缩量
        hbox.addWidget(bt2)
        hbox.addStretch(1)  # 增加伸缩量
        hbox.addWidget(bt3)
        hbox.addStretch(1)  # 增加伸缩量

        vbox = QVBoxLayout()
        vbox.addStretch(1)
        vbox.addLayout(hbox)

        self.setLayout(vbox)

        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Example()
    app.exit(app.exec_())
```

![image-20210212182700766](http://image.trouvaille0198.top/image-20210212182700766.png)

## 网格布局

`QGridLayout`（网格布局）是将窗口分隔成行和列的网格来进行排列

- ***QBoxLayout.addWidget(QWidget, frontRow, fromColumn, rowSpan, columnSpan)***

    在布局中添加控件

    *frontRow*：起始行数

    *fromColumn*：起始列数

    *rowSpan*：跨越的行数

    *columnSpan*：跨越的列数

- ***QBoxLayout.addWidget(QWidget, row, column)***

    在布局中添加控件

    *row*：行数	

    *column*：列数

- ***QWidget.setLayout(QGridLayout)***

    设置窗口的主要布局

- ***QBoxLayout.setSpacing(int spacing)***

    控制控件在水平方向的间隔

    *spacing*：间隔

```python
#coding = 'utf-8'

import sys
from PyQt5.QtWidgets import (
    QWidget, QPushButton, QApplication, QGridLayout, QLCDNumber)


class Example(QWidget):
    def __init__(self):
        super().__init__()
        self.Init_UI()

    def Init_UI(self):
        self.setGeometry(300, 300, 400, 300)
        self.setWindowTitle('学点编程吧-计算器')

        grid = QGridLayout()
        self.setLayout(grid)

        self.lcd = QLCDNumber()
        grid.addWidget(self.lcd, 0, 0, 3, 0)
        grid.setSpacing(10)

        names = ['Cls', 'Bc', '', 'Close',
                 '7', '8', '9', '/',
                 '4', '5', '6', '*',
                 '1', '2', '3', '-',
                 '0', '.', '=', '+']

        positions = [(i, j) for i in range(4, 9) for j in range(4, 8)]
        for position, name in zip(positions, names):
            if name == '':
                continue
            button = QPushButton(name)
            grid.addWidget(button, *position)
            button.clicked.connect(self.Cli)

        self.show()

    def Cli(self):
        sender = self.sender().text()
        ls = ['/', '*', '-', '=', '+']
        if sender in ls:
            self.lcd.display('A')
        else:
            self.lcd.display(sender)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Example()
    app.exit(app.exec_())
```

![image-20210212191725891](http://image.trouvaille0198.top/image-20210212191725891.png)

## 表单布局

`QFormLayout` 是 label-field 式的表单布局，顾名思义，就是实现表单方式的布局。表单是提示用户进行交互的一种模式，其主要由两列组成，第一列用于显示信息，给用户提示，一般叫作 label 域；第二列需要用户进行选择或输入，一般叫作 field 域。label 与 field 的关系就是 label 关联 field。

`QFormLayout` 是一个方便的布局类，其中的控件以两列的形式被布局在表单中。左列包括标签，右列包含输入控件，例如：QLineEdit、QSpinBox、QTextEdit 等

- ***QFormLayout.addRow(label, field)***

    添加一行表单

```python
import sys
from PyQt5.QtWidgets import QApplication, QWidget, QFormLayout, QLineEdit, QLabel, QTextEdit


class Winform(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("窗体布局管理例子")
        self.resize(350, 100)

        formlayout = QFormLayout()

        forms = [
            ['姓名', '阿芒'],
            ['性别', '男'],
            ['年龄', '17']
        ]

        for name, value in forms:
            formlayout.addRow(QLabel(name), QLabel(value))

        introductionLabel = QLabel("简介")
        introductionLineEdit = QTextEdit("")

        formlayout.addRow(introductionLabel, introductionLineEdit)
        self.setLayout(formlayout)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    form = Winform()
    form.show()
    sys.exit(app.exec_())
```

![image-20210212193025509](http://image.trouvaille0198.top/image-20210212193025509.png)

# 显示类控件

## QLabel

`QLabel` 对象作为一个占位符可以显示不可编辑的文本、图片或者 GIF 动画等

`QLabel` 是 GUI 中的标签类，它继承自 QFrame（是 QWidget 的子类）

### API

#### 修改内容

- ***setText(str text)***

    - 设置文本内容
    - *text*：文本内容

- ***setPixmap(QPixmap)***

    - 设置图片

- ***setMovie(QMovie)***

    - 设置视频

    - `QMovie` 类是用 QImageReader 播放动画的便捷类。

        这个类用来显示没有声音的简单的动画

#### 文字设置

- ***setAlignment()***
    - 按固定值方式对齐文本
    - `Qt.AlignLeft`：水平方向靠左对齐；
    - `Qt.AlignRight`:水平方向靠右对齐；
    - `Qt.AlignCenter`：水平方向居中对齐；
    - `Qt.AlignJustify`：水平方向调整间距两端对齐；
    - `Qt.AlignTop`：垂直方向靠上对齐；
    - `Qt.AlignBottom`：垂直方向靠下对齐；
    - `Qt.AlignVCenter`：垂直方向居中对齐。
- ***serIndent()***
    - 设置文本缩进值
- ***setWordWrap()***
    - 设置是否允许换行
- ***setFont(QFont)***
    - 设置字体的大小样式
- ***setStyleSheet(str cssStyle)***
    - 设置 CSS 样式
    - cssStyle：CSS 样式，如 `"border-radius: 25px;border: 1px solid black;"`

#### 返回

- ***text()***
    - 返回文本内容
- ***selectedText()***
    - 返回所选中的字符

### 

# 文本框类控件

## QLineEdit

`QLineEdit` 类是一个单行文本框控件，可以输入单行字符串

