---
title: "Python tempfile 库"
date: 2022-09-28
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# tempfile

tempfile 模块专门用于创建临时文件和临时目录，它既可以在 UNIX 平台上运行良好，也可以在 Windows 平台上运行良好

## 快速入门

tempfile 模块中常用的函数，如表所示

| tempfile 模块函数                                            | 功能描述                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `tempfile.TemporaryFile(mode='w+b', buffering=None, encoding=None, newline=None, suffix=None, prefix=None, dir=None)` | 创建临时文件。该函数返回一个类文件对象，也就是支持文件 I/O。 |
| `tempfile.NamedTemporaryFile(mode='w+b', buffering=None, encoding=None, newline=None, suffix=None, prefix=None, dir=None, delete=True)` | 创建临时文件。该函数的功能与上一个函数的功能大致相同，只是它生成的临时文件在文件系统中有文件名。 |
| `tempfile.SpooledTemporaryFile(max_size=0, mode='w+b', buffering=None, encoding=None, newline=None, suffix=None, prefix=None, dir=None)` | 创建临时文件。与 TemporaryFile 函数相比，当程序向该临时文件输出数据时，会先输出到内存中，直到超过 max_size 才会真正输出到物理磁盘中。 |
| `tempfile.TemporaryDirectory(suffix=None, prefix=None, dir=None)` | 生成临时目录。                                               |
| `tempfile.gettempdir()`                                      | 获取系统的临时目录。                                         |
| `tempfile.gettempdirb()`                                     | 与 `gettempdir()` 相同，只是该函数返回字节串。               |
| `tempfile.gettempprefix()`                                   | 返回用于生成临时文件的前缀名。                               |
| `tempfile.gettempprefixb()`                                  | 与 `gettempprefix()` 相同，只是该函数返回字节串。            |

tempfile 模块还提供了 tempfile.mkstemp() 和 tempfile.mkdtemp() 两个低级别的函数。上面介绍的 4 个用于创建临时文件和临时目录的函数都是高级别的函数，高级别的函数支持自动清理，而且可以与 with 语句一起使用，而这两个低级别的函数则不支持，因此一般推荐使用高级别的函数来创建临时文件和临时目录。

此外，tempfile 模块还提供了 tempfile.tempdir 属性，通过对该属性赋值可以改变系统的临时目录。

下面程序示范了如何使用临时文件和临时目录：

```py
import tempfile

# 创建临时文件
fp = tempfile.TemporaryFile()
print(fp.name)
fp.write('两情若是久长时，'.encode('utf-8'))
fp.write('又岂在朝朝暮暮。'.encode('utf-8'))
# 将文件指针移到开始处，准备读取文件
fp.seek(0)
print(fp.read().decode('utf-8')) # 输出刚才写入的内容
# 关闭文件，该文件将会被自动删除
fp.close()

# 通过with语句创建临时文件，with会自动关闭临时文件
with tempfile.TemporaryFile() as fp:
    # 写入内容
    fp.write(b'I Love Python!')
    # 将文件指针移到开始处，准备读取文件
    fp.seek(0)
    # 读取文件内容
    print(fp.read()) # b'I Love Python!'

# 通过with语句创建临时目录
with tempfile.TemporaryDirectory() as tmpdirname:
    print('创建临时目录', tmpdirname)
```

上面程序以两种方式来创建临时文件：

1. 第一种方式是手动创建临时文件，读写临时文件后需要主动关闭它，当程序关闭该临时文件时，该文件会被自动删除。
2. 第二种方式则是使用 with 语句创建临时文件，这样 with 语句会自动关闭临时文件。


上面程序最后还创建了临时目录。由于程序使用 with 语句来管理临时目录，因此程序也会自动删除该临时目录。

运行上面程序，可以看到如下输出结果：

```shell
C:\Users\admin\AppData\Local\Temp\tmphvehw9z1
两情若是久长时，又岂在朝朝暮暮。
b'I Love Python!'
创建临时目录C:\Users\admin\AppData\Local\Temp\tmp3sjbnwob
```

上面第一行输出结果就是程序生成的临时文件的文件名，最后一行输出结果就是程序生成的临时目录的目录名。需要注意的是，不要去找临时文件或临时文件夹，因为程序退出时该临时文件和临时文件夹都会被删除。