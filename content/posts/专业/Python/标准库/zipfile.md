---
title: "Python zipfile 库"
date: 2022-09-28
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# zipfile

zipfile 是 python 里用来做 zip 格式编码的压缩和解压缩的标准库

要进行相关操作，首先需要实例化一个 ZipFile 对象。ZipFile 接受一个字符串格式压缩包名称作为它的必选参数，第二个参数为可选参数，表示打开模式，类似于文件操作，有 r/w/a 三种模式，分别代表读、写、添加，默认为 r，即读模式。

zipfile 里有两个非常重要的 class, 分别是 ZipFile 和 ZipInfo, 在绝大多数的情况下，我们只需要使用这两个 class 就可以了。ZipFile 是主要的类，用来创建和读取 zip 文件而 ZipInfo 是存储的 zip 文件的每个文件的信息的

## ZipFile

```py
class zipfile.ZipFile(file[, mode[, compression[, allowZip64]]])
```

1. file：文件的路径或类文件对象 (file-like object);
2. mode：打开 zip 文件的模式
    - 默认值为 'r'，表示读已经存在的 zip 文件
    - 'w' 表示新建一个 zip 文档或覆盖一个已经存在的 zip 文档
    - 'a' 表示将数据附加到一个现存的 zip 文档中;
3. compression：写 zip 文档时使用的压缩方法
    - 它的值可以是 zipfile. ZIP_STORED 或 zipfile. ZIP_DEFLATED。
    - 如果要操作的 zip 文件大小超过 2G，应该将 allowZip64 设置为 True。

```py
file_dir = 'D:/text.zip'
zipFile = zipfile.ZipFile(file_dir)
```

### ZipFile.infolist()

获取 zip 文档内所有文件的信息，返回一个 zipfile.ZipInfo 的列表

```py
print(zipFile.infolist())
```

输出

```jsx
[<ZipInfo filename='text.txt' compress_type=deflate external_attr=0x20 file_size=13 compress_size=15>]
```

### ZipFile.namelist()

获取 zip 文档内所有文件的名称列表

```py
print(zipFile.namelist())
```

输出

```json
['text.txt']
```

### ZipFile.printdir()

将 zip 文档内的信息打印到控制台上

```py
print(zipFile.printdir())
```

输出

```css
File Name                                             Modified             Size
text.txt                                       2018-06-06 11:04:26           13
None
```

以上完整代码

```python
import zipfile
# 加载压缩文件，创建ZipFile对象
# class zipfile.ZipFile(file[, mode[, compression[, allowZip64]]])
# 参数file表示文件的路径或类文件对象(file-like object)
# 参数mode指示打开zip文件的模式，默认值为'r'，表示读已经存在的zip文件，也可以为'w'或'a'，
# 'w'表示新建一个zip文档或覆盖一个已经存在的zip文档，'a'表示将数据附加到一个现存的zip文档中
# 参数compression表示在写zip文档时使用的压缩方法，它的值可以是zipfile. ZIP_STORED 或zipfile. ZIP_DEFLATED。
# 如果要操作的zip文件大小超过2G，应该将allowZip64设置为True。
file_dir = 'D:/text.zip'
zipFile = zipfile.ZipFile(file_dir)

# 01 ZipFile.infolist() 获取zip文档内所有文件的信息，返回一个zipfile.ZipInfo的列表
print(zipFile.infolist())
# 02 ZipFile.namelist() 获取zip文档内所有文件的名称列表
print(zipFile.namelist())
# 03 ZipFile.printdir() 将zip文档内的信息打印到控制台上
print(zipFile.printdir())
```

### ZipFile.extract()

```py
ZipFile.extract(member[, path[, pwd]])
```

将 zip 文档内的指定文件解压到当前目录

- member 指定要解压的文件名称或对应的 ZipInfo 对象；
- path 指定解析文件保存的文件夹，默认为当前路径
- pwd 为解压密码。

下面一个例子将保存在程序根目录下的 text.zip 内的所有文件解压到 D:/Work 目录：

```go
import zipfile
import os
zipFile = zipfile.ZipFile(file_dir)
for file in zipFile.namelist():
    zipFile.extract(file, 'd:/Work')
zipFile.close()
```

### ZipFile.extractall()

```py
ZipFile.extractall([path[, members[, pwd]]])
```

解压 zip 文档中的所有文件到当前目录。

- members 的默认值为 zip 文档内的所有文件名称列表，也可以自己设置，选择要解压的文件名称。

```bash
zipFile.extractall('d:/Work') # 和上面效果一样
```
