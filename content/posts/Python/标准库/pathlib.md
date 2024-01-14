---
title: "Python pathlib 库"
date: 2023-12-19
author: MelonCholi
draft: false
tags: []
categories: [Python]
---

# pathlib

> [pathlib 库，文件与文件夹处理的 "四大天王" 之一，贼好用！](https://mp.weixin.qq.com/s/upXCeqRAsR-dZdr_UPwLvA)

![img](https://pic2.zhimg.com/80/v2-046244f5fa0fad6736ee6ffb205cd169_1440w.webp)

## 简介

pathlib 库从 python3.4 开始，到 python3.6 已经比较成熟。如果你的新项目可以直接用 3.6 以上，建议用 pathlib。相比于老式的 os.path 有几个优势：

1. 老的路径操作函数管理比较混乱，有的是导入 os, 有的又是在 os.path 当中，而新的用法统一可以用 pathlib 管理。
2. 老用法在处理不同操作系统 win，mac 以及 linux 之间很吃力。换了操作系统常常要改代码，还经常需要进行一些额外操作。
3. 老用法主要是函数形式，返回的数据类型通常是字符串。但是路径和字符串并不等价，所以在使用 os 操作路径的时候常常还要引入其他类库协助操作。新用法是面向对象，处理起来更灵活方便。

pathlib 简化了很多操作，用起来更轻松。

### 小例子

举个例子， 把所有的 txt 文本全部移动到 archive 目录当中（archive 目录必须存在)。

![img](https://pic4.zhimg.com/80/v2-84bae56136367b62cb390227485e2e63_1440w.webp)

使用原来的用法：

```py
import glob
import os
import shutil

# 获取运行目录下所有的 txt 文件。注意：不是这个文件目录下
print(glob.glob('*.txt'))

for file_name in glob.glob('*.txt'):
    new_path = os.path.join('archive', file_name)
    shutil.move(file_name, new_path)
```

新的写法：

```py
from pathlib import Path

Path("demo.txt").replace('archive/demo.txt')
```

## 基本操作

### Path 对象

Path 对象是这个库的核心，里面有着超级多好用的 `文件、文件夹` 处理方法，供我们调用。

Path 对象既可以是一个`文件对象`，也可以是一个`文件夹对象`。

#### 当前路径下的 Path 对象

```py
p = Path.cwd()

# PosixPath('/home/melon')
```

#### 任意指定路径下的 Path 对象

```py
p = Path('C:/Users/Administrator/Desktop/python/pathlib/123.txt')

# PosixPath('C:/Users/Administrator/Desktop/python/pathlib/123.txt')
```

### 路径拼接

进行路径拼接，直接使用一个 `/` 斜杠即可。

```py
p = Path('C:/Users/Administrator/Desktop/python')
p1 = p/'pathlib'

# PosixPath('C:/Users/Administrator/Desktop/python/pathlib')
```

### 获取上级目录

```py
p = Path.cwd()
p.parent
p.parent.parent
```

### 获取文件的具体信息

```py
p = Path("some path")
p.stat()
```

输出

```py
os.stat_result(st_mode=16877, st_ino=628476, st_dev=2080, st_nlink=10, st_uid=1000, st_gid=1000, st_size=4096, st_atime=1702974364, st_mtime=1702974364, st_ctime=1702974364)
```

### 获取指定路径下所有文件/文件夹的路径信息

```py
p = Path.cwd()
for i in p.iterdir():
    print(i)
```

iterdir() 方法返回的是**直接**子文件或子文件夹，不考虑嵌套文件夹中的文件

### 获取指定路径下"符合条件"文件的路径信息

仅想要获取直接子文件的路径信息，使用的是 glob() 方法

```py
p = Path.cwd()

file_list = p.glob('*.txt')
for file in file_list:
    print(file)
```

### 限制递归次数，访问嵌套文件夹

#### 不限制递归次数

```py
p = Path.cwd()
file_list = p.rglob('*.txt')

for file in file_list:
    print(file)
```

####  限制递归次数

```py
p = Path.cwd()
file_list = p.rglob('*.txt')

for i,file in enumerate(file_list):
    if i <= 2:
        print(file)
```

### 判断当前路径是否存在某个文件或者文件夹

使用 `.exists()`

```py
p.exists()

# True or False
```

### 创建文件夹

```py
p = Path.cwd()
p1 = p/'b'

if not Path('C:/Users/Administrator/Desktop/python三剑客/pathlib库/b').exists():
    p1.mkdir()
```

使用 `parents=True` 参数来递归创建

```py
p = Path.cwd()
p1 = p/'嵌套第一层'/'嵌套第二层'
p1.mkdir(parents=True)
```

### 判断某个路径是文件，还是文件夹

```py
p = Path('C:/Users/Administrator/Desktop/python三剑客/pathlib库/抽奖.txt')
p.is_dir()
p.is_file()
```

### 文件/文件夹重命名

```py
p = Path('3.gif')
p.rename("重命名_3.gif")
```

### 获取文件的文件名和后缀

```py
p = Path('C:/Users/Administrator/Desktop/python/pathlib/123.txt')
p.name # 123.txt
p.suffix # .txt
```

