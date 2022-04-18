---
title: "Python os 库"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# OS

## 简介

os 模块提供了多数操作系统的功能接口函数。当 os 模块被导入后，它会自适应于不同的操作系统平台，根据不同的平台进行相应的操作，在 python 编程时，经常和文件、目录打交道，这时就离不了 os 模块

```python
import os
```

## 文件路径操作

### os.getcwd()

查看当前路径（get current dictory）

```python
os.getcwd()
<<
	'D:\\repo\\PythonLearning\\Jupyter\\LearningTest'
```

### os.listdir(path)

列举 path 目录下所有文件，返回列表

无参数时，默认为当前路径

```python
os.listdir("..")
<<
	['.ipynb_checkpoints',
 	'CrawlerTest.ipynb',
 	'MatplotlibTest.ipynb',
 	'NumpyTest.ipynb',
 	'osTest.ipynb',
 	'PandasTest.ipynb']
```

### os.path.abspath(path):

返回 path 的绝对路径

```python
os.path.abspath('..')
<<
	'D:\\repo\\PythonLearning\\Jupyter'
```

### os.path.split(path)

将路径分解为（文件夹, 文件名），返回的是元组类型 	

若路径字符串最后一个字符是\，则只有文件夹部分有值；若路径字符串中均无\，则只有文件名部分有值

单纯地分析路径

```python
os.path.split('D:\\pythontest\\ostest\\Hello.py')
<<
	('D:\\pythontest\\ostest', 'Hello.py')
os.path.split('.')
<<
	('', '.')
os.path.split('D:\\pythontest\\ostest\\')
<<
	('D:\\pythontest\\ostest', '')
```

### os.path.join(path1,path2,...)

将 path 进行组合，返回组合后的路径

若其中有绝对路径，则之前的 path 将被删除

```python
os.path.join('D:\\pythontest', 'ostest')
<<
	'D:\\pythontest\\ostest'
os.path.join('D:\\pythontest\\b', 'D:\\pythontest\\a')
<<
	'D:\\pythontest\\a'
```

###  os.path.dirname(path)

返回 path 中的文件夹部分，结果不包含 '\\'

单纯地分析路径

```python
os.path.dirname('D:\\pythontest\\ostest\\hello.py')
<<
	'D:\\pythontest\\ostest'
```

###  os.path.basename(path)

返回 path 中的文件名

单纯地分析路径

```python
os.path.basename('D:\\pythontest\\ostest\\hello.py')
<<
	'hello.py'
os.path.basename('D:\\pythontest\\ostest\\')
<<
	''
```

### os.path.isfile(path)

判断 path 是否是一个**存在**的文件，返回布尔类型

```python
os.path.isfile('D:\\pythontest\\ostest\\Hello.py') 
# 尽管是格式正确的路径，凭空存在的话会返回False
<<
	False
os.path.isfile('C:\\Users\\13759\\shopName_2015.csv')
# 应输入存在于本计算机上的路径
<<
	True
```

###  os.path.isdir(path)

判断 path 是否为一个存在的目录，返回布尔类型

```python
os.path.isdir('D:\\pythontest\\ostest') 
# 尽管是格式正确的路径，凭空存在的话会返回False
<<
	False
os.path.isdir(os.getcwd())
<<
	True
os.path.isdir('.')
<< 
	True
```

###  os.path.exists(path)

检验 path 是否存在，返回布尔类型

```python
os.path.exists('.')
<<
	True
os.path.exists('C:\\Users\\13759\\shopName_2015.csv')
<<
	True
```

## 查看文件信息

###  os.path.getsize(path)

查看文件大小 ，单位为字节 (Byte)

```python
os.path.getsize('D:\\repo\\PythonLearning\\Jupyter\\LearningTest\\NumpyTest.ipynb')
<<
	3499
```

### os.path.getmtime(path)

查看文件或文件夹的最后修改时间（modify time），从新纪元到访问时的秒数

```python
os.path.getmtime('NumpyTest.ipynb')
<<
	1609932700.1095462
```

### os.path.getatime(path)

文件或文件夹的最后访问时间（access time），从新纪元到访问时的秒数

```python
os.path.getatime('NumpyTest.ipynb')
<<
	1610524866.1898422
```

### os.path.getctime(path)

文件或文件夹的创建时间（change time），从新纪元到访问时的秒数

```python
os.path.getctime('NumpyTest.ipynb')
<<
	1609920794.9881816
```

### os.stat()

获取文件或目录信息

```python
os.stat('.')
<<
	os.stat_result(st_mode=16895, st_ino=1688849860358640, st_dev=1957125357, st_nlink=1, st_uid=0, st_gid=0, st_size=4096, st_atime=1610524887, st_mtime=1609680144, st_ctime=1607355357)
```

## 文件操作

### os.chdir(path)

（change dir）转到指定 path，相当于cd

### os.mkdir(path)

创建 path 指定的目录，可以写相对路径也可以写绝对路径

```python
os.mkdir('aaa')
os.mkdir('D:\\repo\\PythonLearning\\aaa')
```

### os.rmdir(path)

删除 path 指定的目录，可以写相对路径也可以写绝对路径

### os.remove(path)

删除 path 指定的文件

### os.makedirs(path)

生成多层**递归**目录

### os.removedirs(path)

递归删除空目录（危险！）

### os.rename(oldname, newname)

重命名文件或目录

### os.system(cmd)

执行 shell 命令。返回值是脚本的退出状态码，0 代表成功，1 代表不成功