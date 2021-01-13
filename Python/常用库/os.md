# 一、简介

os模块提供了多数操作系统的功能接口函数。当os模块被导入后，它会自适应于不同的操作系统平台，根据不同的平台进行相应的操作，在python编程时，经常和文件、目录打交道，这时就离不了os模块

```python
import os
```

# 二、文件路径操作

## 2.1 os.getcwd()

查看当前路径（get current dictory）

```python
os.getcwd()
<<
	'C:\\Users\\13759'
```

## 2.2 os.listdir(path)

列举 path 目录下所有文件，返回列表

无参数时，默认为当前路径

```python
os.listdir("..")
<<
	['13759', 'All Users', 'Default', 'Default User', 'desktop.ini', 'Public']
```

## 2.3 os.path.abspath(path):

返回 path 的绝对路径

```python
os.path.abspath("..")
<<
	'C:\\Users'
```

## 2.4 os.path.split(path)

将路径分解为（文件夹,文件名），返回的是元组类型 	

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

## 2.5 os.path.join(path1,path2,...)

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

## 2.6  os.path.dirname(path)

返回 path 中的文件夹部分，结果不包含 '\\'

单纯地分析路径

```python
os.path.dirname('D:\\pythontest\\ostest\\hello.py')
<<
	'D:\\pythontest\\ostest'
```

## 2.7  os.path.basename(path)

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

## 2.8 os.path.isfile(path)

判断 path 是否是一个存在的文件，返回布尔类型

```python
os.path.isfile('D:\\pythontest\\ostest\\Hello.py') 
#尽管是格式正确的路径，凭空存在的话会返回False
<<
	False
os.path.isfile('C:\\Users\\13759\\shopName_2015.csv')
#应输入存在于本计算机上的路径
<<
	True
```

## 2.9  os.path.isdir(path)

判断 path 是否为一个存在的目录，返回布尔类型

```python
os.path.isdir('D:\\pythontest\\ostest') 
#尽管是格式正确的路径，凭空存在的话会返回False
<<
	False
os.path.isdir(os.getcwd())
<<
	True
os.path.isdir('.')
<< 
	True
```

## 2.10  os.path.exists(path)

检验 path 是否存在，返回布尔类型

```python
os.path.exists('.')
<<
	True
os.path.exists('C:\\Users\\13759\\shopName_2015.csv')
<<
	True
```

# 三、查看文件信息

## 3.1  os.path.getsize(path)

查看文件大小 ，单位为字节 (Byte)

```python
os.path.getsize('C:\\Users\\13759\\shopName_2015.csv')
<<
	12403
```

## 3.2 os.path.getmtime(path)

查看文件或文件夹的最后修改时间，从新纪元到访问时的秒数

## 3.3 os.path.getatime(path)

## 3.4 os.path.getctime(path)

