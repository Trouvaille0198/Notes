---
title: "流畅的 Python"
date: 2022-04-17
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# 流畅的 Python

## 数据模型

（Data Model）

数据模型其实是对 Python 框架的描述，它规范了这门语言自身构建模块的接口，这些模块包括但不限于序列、迭代器、函数、类和上下文管理器

通过实现特殊方法，自定义数据类型可以表现得跟内置类型一样，从而让我们写出更具表达力的代码——或者说，更具 Python 风格的代码。

### 特殊方法

Python 解释器碰到特殊的句法时，会使用**特殊方法**去激活一些基本的对象操作，这些特殊方法的名字以两个下划线开头，以两个下划线结尾（例如 `__getitem__`）。比如 `obj[key]` 的背后就是 `__getitem__` 方法，为了能求得 `my_collection[key]` 的值，解释器实际上会调用 `my_collection.__getitem__(key)`。

> **魔术方法**（magic method）是特殊方法的昵称，也叫**双下方法**（dunder method）

通过实现特殊方法来利用 Python 数据模型有两个好处：

- 作为你的类的用户，他们不必去记住标准操作的各式名称（“怎么得到元素的总数？是 `.size()` 还是 `.length()` 还是别的什么？”）
- 可以更加方便地利用 Python 的标准库，比如 `random.choice` 函数，从而不用重新发明轮子。

首先明确一点，特殊方法的存在是为了被 Python 解释器调用的，你自己并不需要调用它们。也就是说没有 `my_object.__len__()` 这种写法，而应该使用 `len(my_object)`。在执行 `len(my_object)` 的时候，如果 `my_object` 是一个自定义类的对象，那么 Python 会自己去调用其中由你实现的 `__len__` 方法。

然而如果是 Python 内置的类型，比如列表（`list`）、字符串（`str`）、字节序列（`bytearray`）等，那么 CPython 会抄个近路，`__len__` 实际上会直接返回 **`PyVarObject` 里的 `ob_size` 属性**。`PyVarObject` 是表示内存中长度可变的内置对象的 C 语言结构体。直接读取这个值比调用一个方法要快很多。

**很多时候，特殊方法的调用是隐式的**，比如 `for i in x:` 这个语句，背后其实用的是 `iter(x)`，而这个函数的背后则是 `x.__iter__()` 方法。当然前提是这个方法在 `x` 中被实现了。

#### __repr__

Python 有一个内置的函数叫 `repr`，它能把一个对象用字符串的形式表达出来以便辨认，这就是 “**字符串表示形式**”`repr` 就是通过 `__repr__` 这个特殊方法来得到一个对象的字符串表示形式的。如果没有实现 `__repr__`，当我们在控制台里打印一个向量的实例时，得到的字符串可能会是 `<Vector object at 0x10e100070>`。

`__repr__` 和 `__str__` 的区别在于，后者是在 `str()` 函数被使用，或是在用 `print` 函数打印一个对象的时候才被调用的，并且它返回的字符串对终端用户更友好。

如果你只想实现这两个特殊方法中的一个，`__repr__` 是更好的选择，因为如果一个对象没有 `__str__` 函数，而 Python 又需要调用它的时候，解释器会用 `__repr__` 作为替代。前者方便我们调试和记录日志，后者则是给终端用户看的。

#### 算术运算符

 `__add__` 和 `__mul__` 这两个方法的返回值都是新创建的向量对象，被操作的两个向量（`self` 或 `other`）还是原封不动，代码里只是读取了它们的值而已。

**中缀运算符的基本原则就是不改变操作对象，而是产出一个新的值**

#### 布尔值

尽管 Python 里有 `bool` 类型，但实际上任何对象都可以用于需要布尔值的上下文中（比如 `if` 或 `while` 语句，或者 `and`、`or` 和 `not` 运算符）。为了判定一个值 `x` 为**真**还是为**假**，Python 会调用 `bool(x)`，这个函数只能返回 `True` 或者 `False`。

**默认情况下，我们自己定义的类的实例总被认为是真的，除非这个类对 `__bool__` 或者 `__len__` 函数有自己的实现。**`bool(x)` 的背后是调用 `x.__bool__()` 的结果；如果不存在 `__bool__` 方法，那么 `bool(x)` 会尝试调用 `x.__len__()`。若返回 0，则 `bool` 会返回 `False`；否则返回 `True`。

### 特殊方法一览

Python 语言参考手册中的“Data Model”（https://docs.python.org/3/reference/datamodel.html）一章列出了 83 个特殊方法的名字，其中 47 个用于实现算术运算、位运算和比较操作。

**跟运算符无关的特殊方法**

|           类别            |                            方法名                            |
| :-----------------------: | :----------------------------------------------------------: |
| 字符串 / 字节序列表示形式 |       `__repr__`、`__str__`、`__format__`、`__bytes__`       |
|         数值转换          | `__abs__`、`__bool__`、`__complex__`、`__int__`、`__float__`、`__hash__`、`__index__` |
|         集合模拟          | `__len__`、`__getitem__`、`__setitem__`、`__delitem__`、`__contains__` |
|         迭代枚举          |            `__iter__`、`__reversed__`、`__next__`            |
|        可调用模拟         |                          `__call__`                          |
|        上下文管理         |                   `__enter__`、`__exit__`                    |
|      实例创建和销毁       |               `__new__`、`__init__`、`__del__`               |
|         属性管理          | `__getattr__`、`__getattribute__`、`__setattr__`、`__delattr__`、`__dir__` |
|        属性描述符         |              `__get__`、`__set__`、`__delete__`              |
|      跟类相关的服务       |   `__prepare__`、`__instancecheck__`、`__subclasscheck__`    |

**跟运算符相关的特殊方法**

|        类别        |                     方法名和对应的运算符                     |
| :----------------: | :----------------------------------------------------------: |
|     一元运算符     |          `__neg__ -`、`__pos__ +`、`__abs__ abs()`           |
|   众多比较运算符   | `__lt__ <`、`__le__ <=`、`__eq__ ==`、`__ne__ !=`、`__gt__ >`、`__ge__ >=` |
|     算术运算符     | `__add__ +`、`__sub__ -`、`__mul__ *`、`__truediv__ /`、`__floordiv__ //`、`__mod__ %`、`__divmod__ divmod()`、`__pow__ **` 或`pow()`、`__round__ round()` |
|   反向算术运算符   | `__radd__`、`__rsub__`、`__rmul__`、`__rtruediv__`、`__rfloordiv__`、`__rmod__`、`__rdivmod__`、`__rpow__` |
| 增量赋值算术运算符 | `__iadd__`、`__isub__`、`__imul__`、`__itruediv__`、`__ifloordiv__`、`__imod__`、`__ipow__` |
|      位运算符      | `__invert__ ~`、`__lshift__ <<`、`__rshift__ >>`、`__and__ &`、`__or__ |`、`__xor__ ^` |
|    反向位运算符    | `__rlshift__`、`__rrshift__`、`__rand__`、`__rxor__`、`__ror__` |
|  增量赋值位运算符  | `__ilshift__`、`__irshift__`、`__iand__`、`__ixor__`、`__ior__` |

### 其他

- 对序列数据类型的模拟是特殊方法用得最多的地方
- 迭代通常是隐式的，譬如说一个集合类型没有实现 `__contains__` 方法，那么 `in` 运算符就会按顺序做一次迭代搜索。

## 序列构成的数组

### 内置序列类型

#### 按元素类型分

Python 标准库用 C 实现了丰富的序列类型，列举如下。

- **容器序列**：`list`、`tuple` 和 `collections.deque` 这些序列能存放不同类型的数据。
- **扁平序列**：`str`、`bytes`、`bytearray`、`memoryview` 和 `array.array`，这类序列只能容纳一种类型。

**容器序列**存放的是它们所包含的任意类型的对象的引用，而**扁平序列**里存放的是值而不是引用。换句话说，扁平序列其实是一段连续的内存空间。由此可见扁平序列其实更加紧凑，但是它里面只能存放诸如字符、字节和数值这种基础类型。

#### 按能否被修改分

序列类型还能按照能否被修改来分类。

- **可变序列**：`list`、`bytearray`、`array.array`、`collections.deque` 和 `memoryview`。
- **不可变序列**`tuple`、`str` 和 `bytes`。

下图显示了可变序列（`MutableSequence`）和不可变序列（`Sequence`）的差异，同时也能看出前者从后者那里继承了一些方法。这个 UML 类图列举了 collections.abc 中的几个类（超类在左边，箭头从子类指向超类，斜体名称代表抽象类和抽象方法）

![NeatReader-1658976007715](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/NeatReader-1658976007715.png)

### 元组

除了用作不可变的列表，它还可以用于没有字段名的记录。鉴于后者常常被忽略，我们先来看看元组作为记录的功用。

#### 元组和记录

元组最大的特征是其不可变性。不可变性实际上暗含多种含义，其一是元组记录的值不会改变，**其二是元组记录的值的顺序不会改变**。第二条相当重要，但是常被忽略。有些时候单纯的数值没有意义，只有结合值与该值在序列中的位置才会有明确的意义（例如经纬度记录，抑或是按照一定顺序采集到的数据）。

拆包让元组可以完美地被当作记录来使用

#### 元组拆包

拆包可以以多种方式进行：

- 平行赋值：对于一个可迭代对象，使用相同数量的变量接收其中的元素
- \* 运算符拆包：* 可以将一个可迭代对象拆包并作为传入函数的参数
- \* 运算符处理剩余元素：* 除了可以拆包可迭代对象外，还可以用于接收不确定数量的拆包结果（非常神奇的功能，类似于*args。对于同一个赋值表达式的左式最多仅能使用一个 \*，并且带有 \* 运算符的变量总会自动接受合适数量的拆包结果）

```python
# * 运算符处理剩余元素
>>> a, b, *rest = range(5)
>>> a, b, rest
(0, 1, [2, 3, 4])

>>> a, b, *rest = range(3)
>>> a, b, rest
(0, 1, [2])

>>> a, b, *rest = range(2)
>>> a, b, rest
(0, 1, [])

>>> a, *body, c, d = range(5)
>>> a, body, c, d
(0, [1, 2], 3, 4)

>>> *head, b, c, d = range(5)
>>> head, b, c, d
([0, 1], 2, 3, 4)
```

#### 嵌套元组拆包

接受表达式的元组可以是嵌套式的，例如 `(a, b, (c, d))`。只要这个接受元组的嵌套结构符合表达式本身的嵌套结构，Python 就可以作出正确的对应。

```python
metro_areas = [
    ('Tokyo','JP',36.933,(35.689722,139.691667)),  
    ('Delhi NCR', 'IN', 21.935, (28.613889, 77.208889)),
    ('Mexico City', 'MX', 20.142, (19.433333, -99.133333)),
    ('New York-Newark', 'US', 20.104, (40.808611, -74.020386)),
    ('Sao Paulo', 'BR', 19.649, (-23.547778, -46.635833)),
]

print('{:15} | {:^9} | {:^9}'.format('', 'lat.', 'long.'))
fmt = '{:15} | {:9.4f} | {:9.4f}'
for name, cc, pop, (latitude, longitude) in metro_areas: 
    if longitude <= 0:  
        print(fmt.format(name, latitude, longitude))
```

#### 具名元组

有些情况下，我们希望元组能带有一个可以解释各位置数据的含义的字段。collections.namedtuple 即可实现这一功能( collections.namedtuple 实际上创建了一个类 )

> 用 `namedtuple` 构建的类的实例所消耗的内存跟元组是一样的，因为字段名都被存在对应的类里面。这个实例跟普通的对象实例比起来也要小一些，因为 Python 不会用 `__dict__` 来存放这些实例的属性。

```python
>>> from collections import namedtuple
# 创建一个具名元组需要两个参数，一个是类名，另一个是类的各个字段的名字。后者可以是由数个字符串组成的可迭代对象，或者是由空格分隔开的字段名组成的字符串。
>>> City = namedtuple('City', 'name country population coordinates')  
# or
>>> City = namedtuple('City', ['name', 'country', 'population', 'coordinates']) 

>>> tokyo = City('Tokyo', 'JP', 36.933, (35.689722, 139.691667))  ➋
>>> tokyo
City(name='Tokyo', country='JP', population=36.933, coordinates=(35.689722,
139.691667))
>>> tokyo.population  ➌
36.933
>>> tokyo.coordinates
(35.689722, 139.691667)
>>> tokyo[1]
'JP'
```

使用 collections.namedtuple 创建的类的实例可以使用对应的字段名或者索引来获取对应的值。此外，还有如下常用功能：

- `._fields`：返回包括所有字段名称的元组
- `._make()`：接受一个可迭代对象以生成一个实例
- `._asdict()`：将具名元组以 `collections.OrderedDict` 形式返回 —— `[(key1, value1), (key2, value2), ...]`

```python
>>> City._fields  ➊
('name', 'country', 'population', 'coordinates')
>>> LatLong = namedtuple('LatLong', 'lat long')
>>> delhi_data = ('Delhi NCR', 'IN', 21.935, LatLong(28.613889, 77.208889))
>>> delhi = City._make(delhi_data)  ➋
>>> delhi._asdict()  ➌
OrderedDict([('name', 'Delhi NCR'), ('country', 'IN'), ('population',
21.935), ('coordinates', LatLong(lat=28.613889, long=77.208889))])
>>> for key, value in delhi._asdict().items():
        print(key + ':', value)

name: Delhi NCR
country: IN
population: 21.935
coordinates: LatLong(lat=28.613889, long=77.208889)
```

### 切片

#### 为什么切片和区间会忽略最后一个元素

- 当只有最后一个位置信息时，我们也可以快速看出切片和区间里有几个元素：`range(3)` 和 `my_list[:3]` 都返回 3 个元素。
- 当起止位置信息都可见时，我们可以快速计算出切片和区间的长度，用后一个数减去第一个下标（`stop - start`）即可。
- 这样做也让我们可以利用任意一个下标来把序列分割成不重叠的两部分，只要写成 `my_list[:x]` 和 `my_list[x:]` 就可以了

> 这些理由对我不是很有说服力……

#### 具有名称标识的切片操作

```python
slice(startIndex, endIndex, step=1)
```

这个用法很实用，主要是能够对切片操作进行单独的定义。方便对不同的序列使用相同的切片操作进行切片。同样的，slice 对象也会忽略最后一个元素

```python
# 纯文本文件形式的收据以一行字符串的形式被解析
>>> invoice = """
... 0.....6................................40........52...55........
... 1909  Pimoroni PiBrella                    $17.50    3    $52.50
... 1489  6mm Tactile Switch x20                $4.95    2     $9.90
... 1510  Panavise Jr. - PV-201                $28.00    1    $28.00
... 1601  PiTFT Mini Kit 320x240               $34.95    1    $34.95
... """

>>> SKU = slice(0, 6)
>>> DESCRIPTION = slice(6, 40)
>>> UNIT_PRICE = slice(40, 52)
>>> QUANTITY = slice(52, 55)
>>> ITEM_TOTAL = slice(55, None)

>>> line_items = invoice.split('\n')[2:]
>>> for item in line_items:
...     print(item[UNIT_PRICE], item[DESCRIPTION])
...
    $17.50   Pimoroni PiBrella
     $4.95   6mm Tactile Switch x20
    $28.00   Panavise Jr. - PV-201
    $34.95   PiTFT Mini Kit 320x240
```

#### 多维切片和省略

多维切片在处理实际数据时经常用到，例如处理图像数据或者更高维的数据。Python 内置的序列类型均是一维的，**因此内置的序列类型仅支持一维的**。

`[]` 运算符里还可以使用以逗号分开的多个索引或者是切片，外部库 NumPy 里就用到了这个特性，二维的 `numpy.ndarray` 就可以用 `a[i, j]` 这种形式来获取，抑或是用 `a[m:n, k:l]` 的方式来得到二维切片。

要正确处理这种 `[]` 运算符的话，对象的特殊方法 `__getitem__` 和 `__setitem__` 需要以元组的形式来接收 `a[i, j]` 中的索引。也就是说，如果要得到 `a[i, j]` 的值，Python 会调用 `a.__getitem__((i, j))`。

总的来说，若想实现多维切片，需要实现 `__getitem__` 和 `__setitem__` 。前者用于读取数据，后者用于赋值。

省略符号（...）则被用于省略无需额外指定的参数。例如，对于一个四维数组，若仅对第一维和最后一维进行切片，在 Numpy 可以写为：

```
test_list[i, ..., j]
test_list[i:j, ..., k:z]
```

> 这些句法上的特性主要是为了支持用户自定义类或者扩展，比如 NumPy 就是个例子。

#### 给切片赋值

若赋值的对象是一个切片，则赋值语句的右侧也必须是一个可迭代对象

> 但是在 Numpy 等库中，则可以直接用单个数值对切片进行赋值，这一操作主要依赖 Numpy 等库中的 broadcast 机制；基于 broadcast 机制，一些 shape 没有完全对应上的情况在 Numpy 中也可以进行赋值和运算

```python
>>> l = list(range(10))
>>> l
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> l[2:5] = [20, 30]
>>> l
[0, 1, 20, 30, 5, 6, 7, 8, 9]
>>> del l[5:7]
>>> l
[0, 1, 20, 30, 5, 8, 9]
>>> l[3::2] = [11, 22]
>>> l
[0, 1, 20, 11, 5, 22, 9]
>>> l[2:5] = 100  
# 如果赋值的对象是一个切片，那么赋值语句的右侧必须是个可迭代对象。即便只有单独一个值，也要把它转换成可迭代的序列。
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: can only assign an iterable
>>> l[2:5] = [100]
>>> l
[0, 1, 100, 22, 9]
```

#### 一个有趣的极限情况

```python
test_tuple = (1, 2, [3, 4])
test_tuple[2] += [5, 6]
```

上述操作按理来说应当是直接报错，因为元组中的元素不可赋值。但是实际情况是报错的同时，元组包含的列表被修改了。

对上述代码的字节码进行分析可以发现，顺序执行了下述三个操作

1. 读取 `test_tuple[2]` 并将其存入栈顶，记为 `TOS`
2. 完成操作 `TOS += [5, 6]`
3. 将结果存入原位置：`test_tuple[2] = TOS`

其中，第二步是对 list 进行的操作，由于 list 是可变序列因此该操作不会报错；第三步是对 tuple 进行的操作，由于 tuple 是不可变序列，当尝试赋值时会抛出错误。但是tuple中存放的是list的引用，因此此时 tuple 中的 list 实际上已经被修改。

上述结果反映：

1. 将可变对象放置于不可变对象中是十分危险的操作
2. 上述操作不是原子操作，因此发生了上述既完成了操作又抛出了错误的结果。

### 序列的增量赋值

`+=` 背后的特殊方法是 `__iadd__` （用于“就地加法”）。但是如果一个类没有实现这个方法的话，Python 会退一步调用 `__add__` 。考虑下面这个简单的表达式：

```python
>>> a += b
```

如果 `a` 实现了 `__iadd__` 方法，就会调用这个方法。同时对可变序列（例如 `list`、`bytearray` 和 `array.array`）来说，`a` 会就地改动，就像调用了 `a.extend(b)` 一样。但是如果 `a` 没有实现 `__iadd__` 的话，`a += b` 这个表达式的效果就变得跟 `a = a + b` 一样了：首先计算 `a + b`，得到一个新的对象，然后赋值给 `a`。也就是说，在这个表达式中，变量名会不会被关联到新的对象，完全取决于这个类型有没有实现 `__iadd__` 这个方法。

总体来讲，可变序列一般都实现了 `__iadd__` 方法，因此 `+=` 是就地加法。而不可变序列根本就不支持这个操作，对这个方法的实现也就无从谈起。

> 上面所说的这些关于 `+=` 的概念也适用于 `*=`，不同的是，后者相对应的是 `__imul__`。

接下来有个小例子，展示的是 `*=` 在可变和不可变序列上的作用：

```python
>>> l = [1, 2, 3]
>>> id(l)
4311953800
>>> l *= 2
>>> l
[1, 2, 3, 1, 2, 3]
>>> id(l)
4311953800
>>> t = (1, 2, 3)
>>> id(t)
4312681568
>>> t *= 2
>>> id(t)
4301348296  
```

**对不可变序列进行重复拼接操作的话，效率会很低**，因为每次都有一个新对象，而解释器需要把原来对象中的元素先复制到新的对象里，然后再追加新的元素。

> `str` 是一个例外，因为对字符串做 `+=` 实在是太普遍了，所以 CPython 对它做了优化。为 `str` 初始化内存的时候，程序会为它留出额外的可扩展空间，因此进行增量操作的时候，并不会涉及复制原有字符串到新位置这类操作

### 有序序列的元素查找以及插入

`bisect` 模块提供了对有序序列进行元素查找以及插入的方法。

- `bisect.bisect` 可以用于元素插入位置查找：寻找一个位置，使得插入待插入元素后，有序序列仍是有序的。
- `bisect.insort` 函数则可以将元素插入有序序列中。

`bisect()` 和 `insort()` 均有两种形式，分别被命名为 `_right`，`_left`。若遇到相等的元素，`_right` 会将元素插入到序列中相同值的元素的后面，而 `_left` 则会插入到前面。

> `bisect` 函数其实是 `bisect_right` 函数的别名

```python
>>> def grade(score, breakpoints=[60, 70, 80, 90], grades='FDCBA'):
...     i = bisect.bisect(breakpoints, score)
...     return grades[i]
...
>>> [grade(score) for score in [33, 99, 77, 70, 89, 90, 100]]
['F', 'A', 'C', 'C', 'B', 'A', 'A']
```

```python
import bisect
import random

SIZE=7

random.seed(1729)

my_list = []
for i in range(SIZE):
    new_item = random.randrange(SIZE*2)
    bisect.insort(my_list, new_item)
    print('%2d ->' % new_item, my_list)
```

```shell
10 -> [10]
 0 -> [0, 10]
 6 -> [0, 6, 10]
 8 -> [0, 6, 8, 10]
 7 -> [0, 6, 7, 8, 10]
 2 -> [0, 2, 6, 7, 8, 10]
10 -> [0, 2, 6, 7, 8, 10, 10]
```

`insort` 跟 `bisect` 一样，有 `lo` 和 `hi` 两个可选参数用来控制查找的范围。它也有个变体叫 `insort_left`，这个变体在背后用的是 `bisect_left`。

### 当列表不是首选时

虽然列表既灵活又简单，但面对各类需求时，我们可能会有更好的选择。

比如，要存放 1000 万个浮点数的话，数组（`array`）的效率要高得多，因为数组在背后存的并不是 `float` 对象，而是数字的机器翻译，也就是字节表述。这一点就跟 C 语言中的数组一样。

再比如说，如果需要频繁对序列做先进先出的操作，`deque`（双端队列）的速度应该会更快。

如果在你的代码里，包含操作（比如检查一个元素是否出现在一个集合中）的频率很高，用 `set`（集合）会更合适。`set` 专为检查元素是否存在做过优化。

#### 数组

如果我们需要一个只包含数字的列表，那么 `array.array` 比 `list` 更高效。数组支持所有跟可变序列有关的操作，包括 `.pop`、`.insert` 和 `.extend`。另外，数组还提供从文件读取和存入文件的更快的方法，如 `.frombytes` 和 `.tofile`。

```python
from array import array  
test_array = array(type, data)
```

```python
# 一个浮点型数组的创建、存入文件和从文件读取的过程

>>> from array import array  
>>> from random import random
>>> floats = array('d', (random() for i in range(10**7)))  
>>> floats[-1]  
0.07802343889111107
>>> fp = open('floats.bin', 'wb')
>>> floats.tofile(fp)  
>>> fp.close()
>>> floats2 = array('d')  
>>> fp = open('floats.bin', 'rb')
>>> floats2.fromfile(fp, 10**7)  
>>> fp.close()
>>> floats2[-1]  
0.07802343889111107
>>> floats2 == floats  
True
```

一个小试验告诉我，用 `array.fromfile` 从一个二进制文件里读出 1000 万个双精度浮点数只需要 0.1 秒，这比从文本文件里读取的速度要快 60 倍，因为后者会使用内置的 `float` 方法把每一行文字转换成浮点数。

另外，使用 `array.tofile` 写入到二进制文件，比以每行一个浮点数的方式把所有数字写入到文本文件要快 7 倍。另外，1000 万个这样的数在二进制文件里只占用 80 000 000 个字节（每个浮点数占用 8 个字节，不需要任何额外空间），如果是文本文件的话，我们需要 181 515 739 个字节。

#### 内存视图

`memoryview` 是一个内置类，它能让用户在不复制内容的情况下操作同一个数组的不同切片。

实际上提供了一种在不需要赋值内容的前提下，实现不同数据结构之间的内存共享。即指定一块区域，能够使用不同的方式去存读数据，例如可以以list的形式创建一个序列，然后以Numpy array的形式去处理这个序列，而不需要额外再创建一个包含相同内容的新array。

### 其他

- 对 `seq[start:stop:step]` 进行求值的时候，Python 会调用 `seq.__getitem__(slice(start, stop, step))`
