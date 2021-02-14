# 一、tqdm

Tqdm 是一个快速，可扩展的 Python 进度条，可以在 Python 长循环中添加一个进度提示信息，用户只需要封装任意的迭代器`tqdm(iterator)`。

***`tqdm(iterator, color)`***

## 1.1 使用方法一: tqdm

`tqdm(list)` 方法可以传入任意一种list,比如数组

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

## 1.2 使用方法二: trange

`trange(i)` 是 `tqdm(range(i))` 的简单写法

```python
from tqdm import trange
for i in trange(100):
    #do something
    pass1234
```

## 1.3 .set_description()

实时查看每次处理的数据

```python
from tqdm import tqdm
import time
 
pbar = tqdm(["a","b","c","d"])
for c in pbar:
  time.sleep(1)
  pbar.set_description("Processing %s"%c)
```

![image-20210213224128056](http://image.trouvaille0198.top/image-20210213224128056.png)