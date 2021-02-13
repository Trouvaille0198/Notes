Tqdm 是一个快速，可扩展的 Python 进度条，可以在 Python 长循环中添加一个进度提示信息，用户只需要封装任意的迭代器`tqdm(iterator)`。

使用方法一: tqdm

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

使用方法二: trange

`trange(i)` 是 `tqdm(range(i))` 的简单写法

```python
from tqdm import trange
for i in trange(100):
    #do something
    pass1234
```

使用方法三: 手动方法

在 for 循环外部初始化 tqdm,可以打印其他信息

```python
bar = tqdm(["a", "b", "c", "d"])
for char in pbar:
    pbar.set_description("Processing %s" % char)123
```

效果：

```python
100%|███████████████████████████████████| 857K/857K [00:04<00:00, 246Kloc/s]
```