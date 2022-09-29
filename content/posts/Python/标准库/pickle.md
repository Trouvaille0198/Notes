---
title: "Python pickle 库"
date: 2022-09-26
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# pickle

pickle 能够实现任意对象与文本之间的相互转化，也可以实现任意对象与二进制之间的相互转化。也就是说，pickle 可以实现 Python 对象的存储及恢复。

pickle 模块提供了以下 4 个函数供我们使用：

1. `dumps()`：将 Python 中的对象序列化成二进制对象，并返回；
2. `loads()`：读取给定的二进制对象数据，并将其转换为 Python 对象；
3. `dump()`：将 Python 中的对象序列化成二进制对象，并写入文件；
4. `load()`：读取指定的序列化数据文件，并返回对象。


以上这 4 个函数可以分成两类，其中 dumps 和 loads 实现基于内存的 Python 对象与二进制互转；dump 和 load 实现基于文件的 Python 对象与二进制互转。

## pickle.dumps()

此函数用于将 Python 对象转为二进制对象，其语法格式如下：

```py
dumps(obj, protocol=None, *, fix_imports=True)
```

- obj：要转换的 Python 对象；
- protocol：pickle 的转码协议，取值为 0、1、2、3、4，其中 0、1、2 对应 Python 早期的版本，3 和 4 则对应 Python 3.x 版本及之后的版本。未指定情况下，默认为 3。
- 其它参数：为了兼容 Python 2.x 版本而保留的参数，Python 3.x 中可以忽略。

例 1

```py
import pickletup1 = ('I love Python', {1,2,3}, None)#使用 dumps() 函数将 tup1 转成 p1
p1 = pickle.dumps(tup1)
print(p1)
```

输出结果为：

```shell
b'\x80\x03X\r\x00\x00\x00I love Pythonq\x00cbuiltins\nset\nq\x01]q\x02(K\x01K\x02K\x03e\x85q\x03Rq\x04N\x87q\x05.'
```

## pickle.loads()

此函数用于将二进制对象转换成 Python 对象，其基本格式如下：

```py
loads(data, *, fix_imports=True, encoding='ASCII', errors='strict')
```

其中，data 参数表示要转换的二进制对象，其它参数只是为了兼容 Python 2.x 版本而保留的，可以忽略。

在例 1 的基础上，将 p1 对象反序列化为 Python 对象。

```py
import pickle
tup1 = ('I love Python', {1,2,3}, None)
p1 = pickle.dumps(tup1) # 使用 loads() 函数将 p1 转成 Python 对象
t2 = pickle.loads(p1)
print(t2)
```

运行结果为：

```shell
('I love Python', {1, 2, 3}, None)
```

注意，在使用 loads() 函数将二进制对象反序列化成 Python 对象时，会自动识别转码协议，所以不需要将转码协议当作参数传入。并且，当待转换的二进制对象的字节数超过 pickle 的 Python 对象时，多余的字节将被忽略。

## pickle.dump()

此函数用于将 Python 对象转换成二进制文件，其基本语法格式为：

```py
dump (obj, file,protocol=None, *, fix mports=True)
```

- obj：要转换的 Python 对象。
- file：转换到指定的二进制文件中，要求该文件必须是以"wb"的打开方式进行操作。
- protocol：和 dumps() 函数中 protocol 参数的含义完全相同，因此这里不再重复描述。
- 其他参数：为了兼容以前 Python 2.x 版本而保留的参数，可以忽略。

例 3：将 tup1 元组转换成二进制对象文件。

```py
import pickle
tup1 = ('I love Python', {1,2,3}, None) # 使用 dumps() 函数将 tup1 转成 p1
with open ("a.txt", 'wb') as f: 
		pickle.dump(tup1, f) # 用 dump 函数将 Python 对象转成二进制对象文件
```

运行完此程序后，会在该程序文件同级目录中，生成 a.txt 文件，但由于其内容为二进制数据，因此直接打开会看到乱码。

## pickle.load()

此函数和 dump() 函数相对应，用于将二进制对象文件转换成 Python 对象。该函数的基本语法格式为：

```py
load(file, *, fix_imports=True, encoding='ASCII', errors='strict')
```

其中，file 参数表示要转换的二进制对象文件（必须以 "rb" 的打开方式操作文件），其它参数只是为了兼容 Python 2.x 版本而保留的参数，可以忽略。

例 4：将例 3 转换的 a.txt 二进制文件对象转换为 Python 对象。

```py
import pickle
tup1 = ('I love Python', {1,2,3}, None) # 使用 dumps() 函数将 tup1 转成 p1

with open ("a.txt", 'wb') as f: 
		pickle.dump(tup1, f) # 用 dump 函数将 Python 对象转成二进制对象文件
    
with open ("a.txt", 'rb') as f: 
    t3 = pickle.load(f) # 将二进制文件对象转换成 Python 对象    
    print(t3)
```

运行结果为：

```shell
('I love Python', {1, 2, 3}, None)
```

## 总结

看似强大的 pickle 模块，其实也有它的短板，即 pickle 不支持并发地访问持久性对象，在复杂的系统环境下，尤其是读取海量数据时，使用 pickle 会使整个系统的 `I/O` 读取性能成为瓶颈。
