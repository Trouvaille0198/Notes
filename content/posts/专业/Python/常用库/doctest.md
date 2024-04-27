---
title: "doctest"
date: 2021-08-10
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# doctest

Doctest 的测试原理是把我们在 Python 控制台的输入输出记录保存到函数的 docstring 里，然后一一把这些输入到解析器然后对比输出是否一致用来确定测试结果是否通过。

## 例子

```python
"""
This is the "example" module.

The example module supplies one function, factorial().  For example,

>>> factorial(5)
120
"""

def factorial(n):
    """Return the factorial of n, an exact integer >= 0.

    >>> [factorial(n) for n in range(6)]
    [1, 1, 2, 6, 24, 120]
    >>> factorial(30)
    265252859812191058636308480000000
    >>> factorial(-1)
    Traceback (most recent call last):
        ...
    ValueError: n must be >= 0

    Factorials of floats are OK, but the float must be an exact integer:
    >>> factorial(30.1)
    Traceback (most recent call last):
        ...
    ValueError: n must be exact integer
    >>> factorial(30.0)
    265252859812191058636308480000000

    It must also not be ridiculously large:
    >>> factorial(1e100)
    Traceback (most recent call last):
        ...
    OverflowError: n too large
    """

    import math
    if not n >= 0:
        raise ValueError("n must be >= 0")
    if math.floor(n) != n:
        raise ValueError("n must be exact integer")
    if n+1 == n:  # catch a value like 1e300
        raise OverflowError("n too large")
    result = 1
    factor = 2
    while factor <= n:
        result *= factor
        factor += 1
    return result


if __name__ == "__main__":
    import doctest
    doctest.testmod()
```

## 测试用例基本格式规范

### 输入

```bash
>>>
... 
```

`>>>` `...` 这个跟交互控制台的概念是一样的。

### 注释

```bash
>>> # 这是一段注释
```

### 测试代码

```bash
>>> a = 0
... for i in range(10):
...       a=i
```

### 预期结果（输出）

在测试代码后面紧跟文本，就是预期结果，对应就是交互控制台的输出内容。Doctest 会拿这些文本去跟测试代码执行的结果对比。

**直接结果**

```bash
9
```

**异常结果**

```bash
Traceback (most recent call last):
        ...
    <异常类型>: <异常信息>
[要空一行]
这里可以写点注释
```

异常结果会匹配 Traceback (most recent call last): 到 <异常类型>: <异常信息>，`...` 的意思是忽略中间行。

## 将测试用例保存到外部文件

函数如果功能简单直接在 docstring 里写用例其实还不错，但是如果函数功能比较复杂，测试用例比较多，那么写到 docstring 里就太长了。

Doctest 支持把测试代码抽离到另外一个 txt 里，然后通过解析 txt 的方式运行用例。

```python3
# doctest只会解析>>>和>>>的下一行（输出）,其他文本会被忽略。
The ``example`` module   # 所以这个不过是个注释
==================

Using ``factorial``  # 这个也是注释
------------------

First import factorial function # 这个是个注释，你喜欢用中文写也行
    >>> from example import factorial  # 这行就是输入命令了

Now use it  # 这个是个注释
    >>> [factorial(n) for n in range(6)]  # 这里到下面就全是测试用例代码了
    [1, 1, 2, 6, 24, 120]
    >>> factorial(30)
    265252859812191058636308480000000
    >>> factorial(-1)
    Traceback (most recent call last):
        ...
    ValueError: n must be >= 0

    Factorials of floats are OK, but the float must be an exact integer:
    >>> factorial(30.1)
    Traceback (most recent call last):
        ...
    ValueError: n must be exact integer
    >>> factorial(30.0)
    265252859812191058636308480000000

    It must also not be ridiculously large:
    >>> factorial(1e100)
    Traceback (most recent call last):
        ...
    OverflowError: n too large
```

### 执行文本用例

执行文本用例的途径有两个

直接命令行调用 doctest 模块运行文本用例

```bash
python -m doctest -v example.txt
```

但是要注意，你在哪个目录下调用就意味着当前工作目录（cwd）就在那里，这会影响文本用例里 `import` 查找模块。举个例子

```bash
python -m doctest -v test/example.txt
```

在 py 脚本里调用

```bash
doctest.testfile('example_text.txt')
```

这个方式适合一次运行所有的文本用例。

## 其他

在测试中，如果可能的输出过长的话，那么过长的内容就会被如上面例子的最后一行的省略号（`...`）所替代。此时就需要 `#doctest: +ELLIPSIS` 这个指令来保证 doctest 能够通过。