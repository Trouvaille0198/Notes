# 认识

生成各种随机数

## 导入

```python
import random
```

模块中主要使用 `random` 类

# API

下述方法均为 `random` 类的成员函数

## 基本

- ***random()***

    生成 `[0,1)` 的随机浮点数

- ***seed(a: int=None)***

    初始化随机数生成器

    - *a*：随机数种子。若空，则使用当前系统时间

- ***uniform(a: float, b: float)***

    生成浮点数

- ***randint(a: int, b: int)***

    生成浮点数

- ***randrange(start, stop[, step])***

    从 *range(start, stop[, step])* 中随机选择一个元素

- ***choice(seq)***

    从序列 seq 中获取一个随机元素

- ***shuffle(seq)***

    将序列 seq 中的元素打乱，不返回，会打乱原有序列

    要改变一个不可变的序列并返回一个新的打乱列表，请使用 ``sample(x, k=len(x))``

- ***sample(seq, len)***

    从序列 seq 中随机获取指定长度 len 的片段并返回

## 分布

- ***normalvariate(mu, sigma)*** 

    返回符合指定均值方差的正态分布的一个随机数
    
    ```python
    c = [random.normalvariate(15, 10) for i in range(1000)]
    ```
    
    