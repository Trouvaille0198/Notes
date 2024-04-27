---
title: "Python sys 库"
date: 2022-11-25
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# sys

## 简介

“sys” 即 “system”。该模块提供了一些接口，用于访问 Python 解释器自身使用和维护的变量，同时模块中还提供了一部分函数，可以与解释器进行比较深度的交互。

## 常用功能

### sys.argv

“argv” 即 “argument value” 的简写，是一个**列表**，其中存储的是在命令行调用 Python 脚本时提供的“命令行参数”。

这个列表中的第一个参数是被调用的脚本名称，也就是说，调用 Python 解释器的“命令”（`python`）本身并没有被加入这个列表当中。

这个地方要注意一下，因为这一点跟 C 程序的行为有所不同，C 程序读取命令行参数是从头开始的。

举例来说，在当前目录下新建一个 Python 文件`sys_argv_example.py`，其内容为：

```python
 import sys
 
 print("The list of command line arguments:\n", sys.argv)
```

在命令行运行该脚本：

```bash
 $ python sys_argv_example.py
 The list of command line arguments:
  ['example.py']
```

加上几个参数试试：

```bash
 $ python sys_argv_example.py arg1 arg2 arg3
 The list of command line arguments:
  ['example.py', 'arg1', 'arg2', 'arg3']
```

利用好这个属性，可以极大增强 Python 脚本的交互性。

### **2.2 sys.platform**

查看 `sys` 模块中的 `sys.platform`属性可以得到关于运行平台更详细的信息

```python
 >>> import sys
 >>> sys.platform
 'win32'
```

在 Linux 上：

```python
 >>> sys.platform
 'linux'
```

比较一下 `os.name` 的结果，不难发现，`sys.platform` 的信息更加准确。

### sys.byteorder

“byteorder” 即 “字节序”，指的是在计算机内部存储数据时，**数据的低位字节存储在存储空间中的高位还是低位**

“小端存储”（Little-Endian）时，数据的低位也存储在存储空间的低位地址中，此时 `sys.byteorder` 的值为 `“little”`。如果不注意，在按地址顺序打印内容的时候，可能会把小端存储的内容打错。当前**大部分机器**都是使用的小端存储。

所以不出意外的话，你的机器上执行下述交互语句也应当跟我的结果一样：

```python
 >>> sys.byteorder
 'little'
```

而另外还存在一种存储顺序是“大端存储”（Big-Endian），即数据的高位字节存储在存储空间的低位地址上，此时 `sys.byteorder` 的值为 `“big”`。

比如数字 `0x12 34 56 78` 在内存中的表示形式为

**大端模式：**

```py
低地址 -----------------> 高地址
0x12  |  0x34  |  0x56  |  0x78
```

**小端模式：**

```py
低地址 ------------------> 高地址
0x78  |  0x56  |  0x34  |  0x12
```

这种方式看起来好像很合理也很自然，因为我们一般在书面表示的时候都将低位地址写在左边，高位地址写在右边，大端存储的顺序就很符合人类的阅读习惯。但实际上对机器而言，内存地址并没有左右之分，所谓的“自然”其实并不存在。

如果是大端存储的机器上运行 Python，输出结果应该像下面这样：x

```python
 >>> sys.byteorder
 'big'
```

### sys.executable

该属性是一个**字符串**，在正常情况下，其值是**当前运行的 Python 解释器对应的可执行程序所在的绝对路径**

比如在 Windows 上使用 Anaconda 安装的 Python，该属性的值就是：

```python
 >>> sys.executable
 'E:\\Anaconda\\Anaconda\\python.exe'
```

### sys.modules

该属性是一个**字典**，包含**各种已加载的模块的模块名到模块具体位置的映射**。

通过手动修改这个字典，可以重新加载某些模块；但要注意，切记不要大意删除了一些基本的项，否则可能会导致 Python 整个儿无法运行。

```py
>>> sys.modules
{'sys': <module 'sys' (built-in)>,
 'builtins': <module 'builtins' (built-in)>,
 '_frozen_importlib': <module 'importlib._bootstrap' (frozen)>,
 '_imp': <module '_imp' (built-in)>,
 '_thread': <module '_thread' (built-in)>,
 ... # 巨多
}
```

### sys.builtin_module_names

该属性是一个 `Tuple[str]`，其中的元素均为**当前所使用的的 Python 解释器内置的模块名称**。

注意区别 `sys.modules` 和 `sys.builtin_module_names`：前者的关键字（keys）列出的是导入的模块名，而后者则是解释器内置的模块名。

```python
>>> sys.builtin_module_names
('_abc', '_ast', '_bisect', '_blake2', '_codecs', '_codecs_cn', '_codecs_hk', '_codecs_iso2022', '_codecs_jp', '_codecs_kr', '_codecs_tw', '_collections', '_contextvars', '_csv', '_datetime', '_functools', '_heapq', '_imp', '_io', '_json', '_locale', '_lsprof', '_md5', '_multibytecodec', '_opcode', '_operator', '_pickle', '_random', '_sha1', '_sha256', '_sha3', '_sha512', '_signal', '_sre', '_stat', '_string', '_struct', '_symtable', '_thread', '_tracemalloc', '_warnings', '_weakref', '_winapi', 'array', 'atexit', 'audioop', 'binascii', 'builtins', 'cmath', 'errno', 'faulthandler', 'gc', 'itertools', 'marshal', 'math', 'mmap', 'msvcrt', 'nt', 'parser', 'sys', 'time', 'winreg', 'xxsubtype', 'zipimport', 'zlib')
```

### sys.path

> A list of strings that specifies the search path for modules. Initialized from the environment variable `PYTHONPATH`, plus an installation-dependent default.

该属性是一个 `List[str]`，其中各个元素表示的是 **Python 搜索模块的路径**；在程序启动期间被初始化。

其中第一个元素（也就是 `path[0]`）的值是最初调用 Python 解释器的脚本所在的绝对路径；如果是在交互式环境下查看 `sys.path`的值，就会得到一个空字符串。

命令行运行脚本：

```bash
$ python sys_path_example.py
The path[0] =  D:\justdopython\sys_example
```

交互式环境查看属性第一个元素：

```python
>>> sys.path[0]
''
```

## 进阶功能

### sys.stdin

即 Python 的**标准输入通道**。通过改变这个属性为其他的类文件（file-like）对象，可以实现输入的重定向，也就是说可以用其他内容替换标准输入的内容。

所谓 “标准输入”，实际上就是通过键盘输入的字符。

在示例中，我们尝试把这个属性的值改为一个打开的文件对象 `hello_python.txt`，其中包含如下的内容：

```text
Hello Python!
Just do Python, go~

Go, Go, GO!
```

由于 `input()` 使用的就是标准输入流，因此通过修改 `sys.stdin` 的值，我们使用老朋友 `input()` 函数，也可以实现对文件内容的读取

```python
import sys


with open('hello_python.txt', 'r', encoding='utf-8') as f:
    sys.stdin = f
    try:
        while True:
            print(input())
    
    except EOFError:
        exit()
```

程序运行效果如下：

```bash
$ python sys_stdin_example.py
Hello Python!
Just do Python, go~

Go, Go, GO!
```

### sys.stdout

### sys.stdout

与上一个 “标准输入”类似，`sys.stdout` 则是代表 “标准输出” 的属性。

通过将这个属性的值修改为某个文件对象，可以将本来要打印到屏幕上的内容写入文件。

比如运行示例程序，用来临时生成日志也是十分方便的：

```python
import sys


# 以附加模式打开文件，若不存在则新建
with open("count_log.txt", 'a', encoding='utf-8') as f:
    sys.stdout = f
    for i in range(10):
        print("count = ", i)
```

### sys.err

与前面两个属性类似，只不过该属性标识的是标准错误，通常也是定向到屏幕的，可以粗糙地认为是一个输出错误信息的特殊的标准输出流。由于性质类似，因此不做演示。

此外，`sys` 模块中还存在几个“私有”属性：`sys.__stdin__`，`sys.__stdout__`，`sys.__stderr__`。这几个属性中保存的就是最初定向的 “标准输入”、“标准输出” 和 “标准错误” 流。在适当的时侯，我们可以借助这三个属性将 `sys.stdin`、`sys.stdout` 和 `sys.err` 恢复为初始值。

### sys.getrecursionlimit() 和 sys.setrecursionlimit()

`sys.getrecursionlimit()` 和 `sys.setrecursionlimit()` 是成对的

前者可以获取 Python 的最大递归数目，后者则可以设置最大递归数目

### sys.getrefcount()

其返回值是传入对象的引用计数。

由于作为参数传入 `getrefcount()` 的时候产生了一次临时引用，因此返回的计数值一般要比预期多 1

### sys.getsizeof()

这个函数的作用与 C 语言中的 `sizeof` 运算符类似，返回的是**对象所占用的字节数**

比如我们就可以看看一个整型对象 `1` 在内存中的大小：

```python
>>> sys.getsizeof(1)
28
```

注意，在 Python 中，某类对象的大小并非一成不变的：

```python
>>> sys.getsizeof(2**30-1)
28
>>> sys.getsizeof(2**30)
32
```

### sys.int_info 和 sys.float_info

这两个属性分别给出了 Python 中两个重要的数据类型的相关信息。

其中 `sys.int_info` 的值为：

```python
>>> sys.int_info
sys.int_info(bits_per_digit=30, sizeof_digit=4)
```

在文档中的解释为：

|      属性      |                             解释                             |
| :------------: | :----------------------------------------------------------: |
| bits_per_digit | number of bits held in each digit. Python integers are stored internally in base `2**int_info.bits_per_digit` |
|  sizeof_digit  |    size in bytes of the C type used to represent a digit     |

意思

- Python 以 2 的 `sys.int_info.bits_per_digit` 次方为基来表示整数
- 也就是说它是 “2 的 `sys.int_info.bits_per_digit` 次方进制” 的数。
- 这样的数每一个位都用 C 类中的 4 个字节来存储。

换句话说，每 “进 1 位”（即整数值增加 2 的 `sys.int_info.bits_per_digit` 次方），就需要多分配 4 个字节用以保存某个整数。

因此在 `sys.getsizeof()` 的示例中，我们可以看到 `2**30-1` 和 `2**30` 之间，虽然本身只差了 1，但是所占的字节后者却比前者多了 4。

而 `sys.float_info` 的值则是：

```python
>>> sys.float_info
sys.float_info(max=1.7976931348623157e+308, max_exp=1024, max_10_exp=308, min=2.2250738585072014e-308, min_exp=-1021, min_10_exp=-307, dig=15, mant_dig=53, epsilon=2.220446049250313e-16, radix=2, rounds=1)
```

### sys.ps1 和 sys.ps2

所谓 “ps”，应当是 “prompts” 的简写，即 “提示符”。

- `sys.ps1` 是一级提示符，也就是进入 Python 交互界面之后就会出现的那一个 `>>>`
- `sys.ps2` 是二级提示符，是在同一级内容没有输入完，换行之后新行行首的提示符 `...`

当然，两个属性都是字符串。

```python
 >>> sys.ps1 = "justdopython "
 justdopython li = [1,2,3]
 justdopython li[0]
 1
 justdopython 
```

提示符已经被改变了

```python
 justdopython sys.ps1 = "ILoveYou: "
 ILoveYou: print("你可真是个小机灵鬼儿！")
 你可真是个小机灵鬼儿！
 ILoveYou:
```

注意不要忘了在字符串最后加个空格，否则提示符就会和你输入的内容混杂在一起了

### sys.exit()

功能：执行到主程序末尾，解释器自动退出，但是如果需要中途退出程序，可以调用 sys.exit 函数

它带有一个可选的整数参数返回给调用它的程序，表示你可以在主程序中捕获对 sys.exit 的调用（0 是正常退出，其他为异常）

```python
#!/usr/bin/env python

import sys

def exitfunc(value):
	print value
	sys.exit(0)

print "hello"

try:
	sys.exit(1)
except SystemExit,value:
	exitfunc(value)

print "come?"
```

运行：

```bash
# python exit.py
hello
1
```