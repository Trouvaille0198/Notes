---
title: "tqdm"
date: 2021-04-17
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# tqdm

Tqdm 是一个快速，可扩展的 Python 进度条，可以在 Python 长循环中添加一个进度提示信息，用户只需要封装任意的迭代器`tqdm(iterator)`。

***`tqdm(iterator, color)`***

## 使用方法一: tqdm

`tqdm(list)` 方法可以传入任意一种 list,比如数组

```python
from tqdm import tqdm

for i in tqdm(range(1000)):  
     #do something
     pass  12345
```

或者 string 的数组

```python
for char in tqdm(["a", "b", "c", "d"]):
    #do something
    pass123
```

## 使用方法二: trange

`trange(i)` 是 `tqdm(range(i))` 的简单写法

```python
from tqdm import trange
for i in trange(100):
    #do something
    pass1234
```

## .set_description()

实时查看每次处理的数据

```python
from tqdm import tqdm
import time
 
pbar = tqdm(["a","b","c","d"])
for c in pbar:
  time.sleep(1)
  pbar.set_description("Processing %s"%c)
```

![image-20210213224128056](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210213224128056.png)

## 控制进度

```python
from tqdm import tqdm
import time
 
#total参数设置进度条的总长度
with tqdm(total=100) as pbar:
  for i in range(100):
    time.sleep(0.05)
    #每次更新进度条的长度
    pbar.update(1)
```

