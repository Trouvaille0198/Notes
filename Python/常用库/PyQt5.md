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
# 当有很多个文件的时候，想要获取入口文件参数时
print(app.arguments())
print(qApp.arguments())   # qApp是全局变量
```
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
### 1.2.4 应用程序的执行，进入到消息循环
```python
# 让整个程序开始执行，并且进入到消息循环(无限循环)
# 监测整个程序所接收到的用户交互信息
sys.exit(app.exec_())
```
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
