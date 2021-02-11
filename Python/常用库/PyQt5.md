# 一、简介
## 1.1 模块
- QtWidgets ：包含了一整套的 UI 元素控件，用于建立符合系统风格的界面
- QtGui：涵盖了多种基本图形功能的类(字体，图形，图标，颜色)
- QtCore：涵盖了包的核心的非 GUI 界面的功能(时间，文件，目录，数据类型，文本流，链接，线程进程等)
- QtWebKit：显示网页
- QtTest：对 Qt 应用程序和库进行单元测试的类
- QtSql：提供对 SQL 数据库支持的基本模块
- QtMultimedia：多媒体，比如音频，视频
- QtMultimediaWidgets：多媒体，比如音频，视频
## 1.2 程序基本结构分析
### 1.2.1 导入需要的包和模块
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
### 1.2.2 创建一个应用程序对象
```python
app = QApplication(sys.argv)
```
sys.argv 参数是来自命令行的参数列表。 Python 脚本可以从 shell 运行。 写了这句话就能让我们的程序从命令行启动

`QApplication` 管理 GUI 程序的控制流和主要设置。对于用 Qt 写的任何一个 GUI 应用，不管这个应用有没有窗口或多少个窗口，有且只有一个 `QApplication` 对象。

### 1.2.3 控件操作

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

### 1.2.4 应用程序的执行，进入到消息循环

```python
# 让整个程序开始执行，并且进入到消息循环(无限循环)
# 监测整个程序所接收到的用户交互信息
sys.exit(app.exec_())
```
为了让 GUI 启动，需要使用 `app.exec_()` 启动事件循环（启动应用，直至用户关闭它）。

`app.exec_()` 的作用是运行主循环，必须调用此函数才能开始事件处理，调用该方法进入程序的主循环直到调用 `exit()` 结束

### 1.2.5 将面向过程的代码改为面向对象版本

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
## 1.3 事件与信号处理

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

# 二、窗口

窗口就是没有父部件的部件，所以又称为顶级部件

`QMainWindow` 窗口可以包含菜单栏、工具栏、状态栏和标题栏等，是最常见的窗口形式，是 GUI 程序的主窗口。

`QDialog` 是对话框的基类，对话框主要用来执行短期任务和与用户进行互动任务，有模态和非模态两种形式。

`QWidget` 可以用作嵌入其他窗口。

## 2.1 父类操作 QWidget

`QWidget` 类是所有用户界面对象的基类，被称为基础窗口部件。像主窗口、对话框、标签、还有按钮、文本输入框等都是窗口部件

- 客户区 (Client Area)：不包含边框的部分，即用户操作的界面，可以添加子控件。
- 窗口：整一个界面

![img](http://image.trouvaille0198.top/1114626-dace58b6414623d5.png)

### 2.1.1 获取大小

- ***QWidget.size()***

    返回 `PyQt5.QtCore.QSize(width, height)`

- ***QWidget.width()、QWidget.height()***

    返回客户区 width 和 height 值

- ***QWidget.frameGeometry().width()、QWidget.frameGeometry().height()***

    返回窗口 width 和 height 值

### 2.1.2 设置大小

- ***QWidget.resize(width, height)***

    改变客户区的大小，可以通过鼠标的来改变尺寸

- ***QWidget.setFixedWidth(int width)、QWidget.setFixedHeight(int height)***

    设定不可使用鼠标修改的宽度或者高度

- ***QWidget.setFixedSize(width, height)***

    设定不可使用鼠标修改的宽度和高度

### 2.1.3 获取位置

- ***QWidget.pos()***

    返回窗口左上角坐标

- ***QWidget.x()、QWidget.y()***

    返回窗口横、纵坐标

- ***QWidget.geometry().x()、QWidget.geometry().y()***

    返回客户区横、纵坐标


### 2.1.4 设置位置

- ***QWidget.move(int x, int y)***

    设置窗口的位置

### 2.1.5 同时设置

- ***QWidget.frameGeometry()***

    返回窗口的大小和位置

- ***QWidget.setGeometry(int x, int y, int width, int height)***

    同时客户区设置大小和位置

### 2.1.6 初始化

- ***QWidget.setWindowIcon(QIcon)***

    设置窗口图标

- ***QWidget.setWindowTitle(title)***

    设置窗口标题

- ***QWidget.setToolTip(str)***

    显示气泡提示信息

## 2.2 设置主窗口类 QMainWindow

`QWidget` 可以作为嵌套型的窗口存在，结构简单，而 `QMainWindow` 是一个程序框架，有自己的布局，可以在布局中添加控件，如将工具栏添加到布局管理器中。它常常作为 GUI 的主窗口

主窗口在 GUI 程序是唯一的，是所有窗口中的最顶层窗口，其他窗口都是它的直接或间接子窗口

`QMainWindow` 继承自 `QWidget` 类，拥有 `QWidget` 所有的派生方法和属性。

### 2.2.1 状态栏 statusBar

- ***QMAinWindow.StatusBar()***

    返回状态栏对象

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
        # 5 秒后状态栏消失
        self.status.showMessage("这是状态栏提示", 5000)

if __name__ == "__main__": 
    app = QApplication(sys.argv)
    main = MainWidget()
    main.show()
    sys.exit(app.exec_())
```

![image-20210211155643867](http://image.trouvaille0198.top/image-20210211155643867.png)

### 2.2.2 菜单栏 menuBar

菜单栏是一组命令的集合