---
title: "importlib"
date: 2021-08-15
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# importlib

文件结构

```python
a #文件夹
	│a.py
	│__init__.py
b #文件夹
	│b.py
	│__init__.py
	├─c#文件夹
		│c.py
		│__init__.py

# c.py 中内容
args = {'a':1}

class C:
    
    def c(self):
        pass
```

向 a 模块中导入 c.py 中的对象

```python
import importlib

params = importlib.import_module('b.c.c') #绝对导入
params_ = importlib.import_module('.c.c',package='b') #相对导入

# 对象中取出需要的对象
params.args #取出变量
params.C  #取出class C
params.C.c  #取出class C 中的c 方法
```

