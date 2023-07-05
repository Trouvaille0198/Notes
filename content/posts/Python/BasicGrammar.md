---
title: "Python 基础语法"
date: 2021-12-22
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# 基础语法

## 认识

Python 是一种动态类型语言（运行时做数据类型检查）、也是一种强类型语言（强制类型定义）

### 对象模型

- 对象：python 中处理的每样 “东西” 都是对象
    - 内置对象：可直接使用
        - 如数字、字符串、列表、del 等；
    - 非内置对象：需要导入模块才能使用
        - 如 sin(x)，random() 等。

### 内存管理

python 采用**基于值的内存管理**

- 在 Python 中，即使是简单的赋值语句 `a = 1`，也只是将变量标识符 `a` 引用向对象 `1`

  - ![image-20210529161755060](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210529161755060.png)
- 基于值的内存管理：小整数、短字符串等对象都被 Python 缓存，多个变量值相等时，可能会有相同的 id
- 在 `a = b` 中，建立的是 `a` 对 `b` 的引用。
- 使用 `a is b` 来判断 a 和 b 是否引用同一对象，`a is b` 是 `id(a) == id(b)` 的充分非必要条件
- 解释器会跟踪所有值，没有变量指向的自动删除，但自动内存管理不保证及时释放内存
- 使用 `del(a)` 主动释放一个变量，但如果对象还被引用不会导致对象被消除
- 形如 `a.append(a)` 会造成引用环，对垃圾回收会造成一定困难

### 操作符

```python
>>> [1,2,3] * 3
[1,2,3,1,2,3,1,2,3]

>>> '1' * 5
'11111'

>> 3 * 'a'
'aaa'

>>> [1, 2, 3] + [4, 5, 6]
[1, 2, 3, 4, 5, 6]
```

### 浅拷贝与深拷贝

- 浅拷贝出来的是一个独立的对象，但它的子对象还是原对象中的子对象

- 深拷贝会**递归**地拷贝原对象中的每一个子对象，因此拷贝后的对象和原对象互不相关。

**列表的切片是浅拷贝**，是对原列表的引用。当列表含列表元素时，会产生问题

要实现对列表的深拷贝：

```python
import copy

original_list = [1, 2, [3, 4]]
copied_list = copy.deepcopy(original_list)
```

## 选择结构

格式

```python
if <condition1>:
    <statement1>
elif < condition2>:
    <statement2>
elif < condition3>:
    <statement3>
else:
    <statement4>
```

注意冒号和缩进

## 循环结构

循环后可以跟 `else` 语句，当循环正常结束时执行，不正常结束就不执行

### for 循环

#### 格式

```python
for < variable> in < sequence >:
    <statements>
else:
    <statements>
```

#### 特殊语句

- **break** 语句可以跳出 for 和 while 的循环体。如果你从 for 或 while 循环中终止，任何对应的循环 else 块将不执行
- **continue** 语句被用来告诉 Python 跳过当前循环块中的剩余语句，然后继续进行下一轮循环

#### 迭代

如果给定一个 list 或 tuple，我们可以通过 for 循环来遍历这个 list 或 tuple，这种遍历我们称为迭代（Iteration）。在 Python 中，迭代是通过 for ... in 来完成的。Python 的 for 循环不仅可以用在 list 或 tuple 上，还可以作用在其他**可迭代对象**（Iterable）上

1. 默认情况下，dict 迭代的是 key。如果要迭代 value，可以用 `for value in d.values()`，如果要同时迭代 key 和 value，可以用`for k, v in d.items()`

```python
>>> d = {'a': 1, 'b': 2, 'c': 3}
>>> for key in d:
...     print(key)
...
a
c
b
```

2. 由于字符串也是可迭代对象，因此，也可以作用于 for 循环

```python
>>> for ch in 'ABC':
...     print(ch)
...
A
B
C
```

如何判断一个对象是可迭代对象呢？方法是通过 collections 模块的 Iterable 类型判断

```python
>>> from collections import Iterable
>>> isinstance('abc', Iterable) # str是否可迭代
True
>>> isinstance([1,2,3], Iterable) # list是否可迭代
True
>>> isinstance(123, Iterable) # 整数是否可迭代
False
```

迭代时，产生的是临时变量，修改此临时变量不会影响本身迭代对象里对应元素的值

### while 循环

```python
while <condition>:
    <statements>
```

### 循环的 else 语句

循环自然结束，就执行 else 中的语句，**如果遇到 break，则不执行 else 中的语句**

```python
for < variable> in < sequence >:
    <statements>
else:
    # 循环正常退出则执行
    <statements>
    
# or

while <conditions>:
    <statements>
else:
    # 循环正常退出则执行
    <statements>
```

## 函数

### 定义

```python
def 函数名（参数列表）:
    函数体
```

### 参数

####  默认参数

必选参数在前，默认参数在后，否则 Python 的解释器会报错

当函数有多个参数时，把变化大的参数放前面，变化小的参数放后面。变化小的参数就可以作为默认参数

#### 可变参数

传入的参数个数可变

1. 传列表、元组

```python
def calc(numbers):
    
calc([1, 2, 3])
calc((1, 3, 5, 7))
```

2. 用 `*` 号

```python
def calc(*numbers)

calc(1, 2)
```

`*numbers` 表示把 `number` 这个 list 的所有元素作为可变参数传进去。这种写法相当有用，而且很常见

#### 关键字参数

关键字参数允许你传入 0 个或任意个含参数名的参数，这些关键字参数在函数内部自动组装为一个 dict

```python
def func(name, age, **kw)

extra = {'city': 'Beijing', 'job': 'Engineer'}
func('Jack', 24, city=extra['city'], job=extra['job'])
func('Jack', 24, **extra)
```

`**extra` 表示把 extra 这个 dict 的所有 key-value 用关键字参数传入到函数的 `**kw` 参数

#### 补充

`*args` 是**可变参数**，args 接收的是一个 tuple

`**kwargs` 是**关键字参数**，kwargs 接收的是一个 dict

### 装饰器

功能：在不改变原函数结构的基础上为原函数增添新功能

```python
def timer(func):
    def wrapper(*args):
        start=time.time()
        a=func(*args)
        end=time.time()
        print("time taken:",end-start)
        return a
    return wrapper

def add(a,b):
    return a+b
def sub(a,b):
    return a-b

add=timer(add)
sub=timer(sub)
print(add(1,2))
print(sub(1,2))
```

使用方法：

```python
@timer
def add(a,b):
    return a+b
@timer
def sub(a,b):
    return a-b

print(add(1,2))
print(sub(1,2))
```

### lambda 表达式

声明临时用的匿名函数

```python
>>> f=lambda x,y,z:x+y+z
>>> print f(1,2,3)
6
```

```python
def pow(x):
    return x**2
list(map(pow, a))

# or
def pow(x):
    return x**2
list(map(lambda x:pow(x), a))

# or
list(map(lambda x:x**2,a))
```

# 列表

列表赋值，不同的变量名实质上指向同一块内存

:heavy_check_mark: 要创建指向不同内存的列表，使用切片

## 基本语句

### 声明列表

```python
favorate_singers = ['Mika','Jay Chou','Bruno Mars','Ed Sheeran']
```

### 添加列表元素

1. 在列表末尾添加元素

```python
list_a.append(value)
```

2. 在列表中插入元素

  ```python
list_a.insert(index，value)
  ```

3. 在列表末尾合并另一个列表

```python
list_a.extend(list_b)
```

### 删除列表元素

1. 知晓索引并将其删除

```python
del list_a[index]
```

2. 删除元素并将其弹出

```python
list_a.pop([index])	   # 括号内为空，则弹出最后一个元素；返回弹出的元素值
```

3. 根据值删除元素

```python
list_a.remove(value)      # 只删除第一个指定的值，要删除多个相同值需使用循环
```

### 组织列表

#### 按照首字母顺序排序列表（永久性）

```python
list.sort()	
# 反向排序：列表名.sort(reverse=True)
```

#### 按照首字母顺序排序列表（临时性）

```python
sorted(list) # 返回一个有序的列表
```

#### 倒着排序列表（永久性）

```python
list.reverse()	# 恢复的办法，再来一次 reverse()
```

#### 倒着排序列表（临时性）

```python
reversed(list) # 返回迭代器
```

#### 确定列表的长度

```python
len(list)
```

### 操作列表

#### 遍历列表

```python
L=[1,2,3,4,5]
for i in range(len(L)):
     L[i]+=10         
print(L) 
               # 等效于
L=[]
for i in range(1,6):
	L.append(i+10)
print(L)
```

#### 列表解析

```python
L=[1,2,3,4,5]
L=[x+10 for x in L]     # result: [11,12,13,14,15]
```

#### 创建切片

参数 [start_index: stop_index: step] ：

- `start_index` 是切片的起始位置索引，不提供时默认从头
- `stop_index` 是切片的结束位置（**不包括**）索引，不提供时默认至尾；可为负
- `step` 为步长，可以不提供，默认值是 1

### 复制列表 / 创建列表副本

 用切片复制

```python
List2 = List1[:]
```

### 检查元素是否在列表中

```python
List = [a,b,c,d,e]

if a in List
if a not in List
```

### 其他函数

- ***list.index(value)***
    - 返回值为 value 的首个元素的下标
- ***list.count(value)***
    - 返回值为 value 的元素在列表中出现的个数

## 性质

### 序列对象的内存机制

序列对象在内存中的起始地址是不变的，修改序列中的值不会影响到整个序列的起始地址。（有点像链表）

```python
>>> a=[1,2,3]
>>> id(a)
2790016530624

>>> a[0]=4
>>> id(a)
2790016530624

>>> a=[4,5,6]
>>> id(a)
2790016530560

>>> b=a
>>> id(a)==id(b)
True
```

1. 使用 `extend()` 不会改变地址

2. 使用乘法运算相当于创建了一个新列表，改变了地址

3. 使用乘法复制了列表中的列表元素时，**实质上是创建了其引用，非常危险**

    ```python
    >>> a = [[0] * 2] * 3
    >>> a
    [[0, 0], [0, 0], [0, 0]]
    
    >>> a[0][0]=2
    >>> a
    [[2, 0], [2, 0], [2, 0]]
    ```

4. 列表直接赋值是创建一个引用，修改其一，另一也会变；而切片是浅拷贝，可以放心使用

### 列表表达式

```python
>>> [v**2 if v%2==0 else v+1 for v in [2,3,4,-1] if v>0]
[4, 4, 16]
```

## 元组

元组是不可变的列表，用圆括号来标识（tuple）

元组可以作为字典的键（**不可变对象**），而列表不能

### 定义元组

```python
tup1 = ('physics', 'chemistry', 1997, 2000)
tup2 = (1, 2, 3, 4, 5 )
tup3 = "a", "b", "c", "d"
```

### 注意

1. 元组本身不可改变，但是可以给元组变量赋值
2. 元组中只包含一个元素时，需要在元素后面添加逗号

```python
tup1 = (50, )
```

3. 可以对元组进行连接组合       

 ```python
tup1 = (50, )
tup2 = ('abc', 'xyz') 
tup3 = tup1 + tup2
 ```

### 序列解包

可以使用元组进行序列解包

```python
>>> a,b,c=1,2,3
>>> print(a,b,c)
1 2 3

>>> *range(4),4
(0, 1, 2, 3, 4)

>>> [*range(4),4]
[0, 1, 2, 3, 4]

>>> {'x':1, **{'y':2}}
{'x': 1, 'y': 2}
```

## 生成器

### 定义

在 Python 中，一边循环一边计算的机制，称为生成器（generator）

生成器是一个特殊的程序，可以被用作控制循环的迭代行为，python 中生成器是迭代器的一种，使用 yield 返回值函数，每次调用 yield 会暂停，而可以使用 `next() ` 函数和 `send()` 函数恢复生成器

生成器类似于返回值为数组的一个函数，这个函数可以接受参数，可以被调用，但是，不同于一般的函数会一次性返回包括了所有数值的数组，生成器一次只能产生一个值，这样消耗的内存数量将大大减小，而且允许调用函数可以很快的处理前几个返回值，因此生成器**看起来像是一个函数，但是表现得却像是迭代器**

### 创建

#### 把一个列表生成式的 `[]` 中括号改为 `()` 小括号

```python
l = [x*x for x in range(10)]
g = (x*x for x in range(10))
```

1. 直接打印 g 的结果

```python
<generator object <genexpr> at 0x000002A4CBF9EBA0>
```

2. 打印值

   如果要一个个打印出来，可以通过 `next()` 函数获得 generator 的下一个返回值

```python
print(next(g))
print(next(g))
print(next(g))
```

计算出最后一个元素，没有更多的元素时，会抛出 StopIteration 的错误

或使用 for 循环

```python
for i in g:
    # 即调用 __iter__()
    print(i)
```

#### 构建函数

如果一个函数定义中包含 yield 关键字，那么这个函数就不再是一个普通函数，而是一个 generator

```python
def generator(max):
    x = 1
    while x <= max:
        yield x**2
        x += 1
    return 'done'

g = generator(4)
```

## 技巧

1. 索引数从 0 开始
2. 将索引指定为 -1，可以返回最后一个列表元素
3. 负数索引返回离列表末尾相应距离的元素，如 `print(list[-3:])` 即打印 list 的最后三个元素

![image-20201206215555032](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20201206215555032.png)

4. 在 if 语句和 while 语句中，将列表名用在条件表达式中时，列表包含至少一个元素，则返回 True；列表为空返回 False

5. 关于切片

   - 元组（tuple）也是一种 list，唯一区别是 tuple 不可变。因此，tuple 也可以用切片操作，只是操作的结果仍是 tuple

     ```python
     >>> (0, 1, 2, 3, 4, 5)[:3]
     (0, 1, 2)
     ```

   - 字符串 `'xxx'` 也可以看成是一种元组，每个元素就是一个字符。因此，字符串也可以用切片操作，只是操作结果仍是字符串

     ```python
     >>> 'ABCDEFG'[:3]
     'ABC'
     >>> 'ABCDEFG'[::2]
     'ACEG'
     ```

6. 运用列表生成式

   - 要生成 `[1x1, 2x2, 3x3, ..., 10x10]`

     ```python
     [x * x for x in range(1, 11)]
     ```

   - 筛选出仅偶数的平方

     ```python
     [x * x for x in range(1, 11) if x % 2 == 0]
     ```

   - 生成全排列

     ```python
     [m + n for m in 'ABC' for n in 'XYZ']
     ```

   - 列出当前目录下的所有文件和目录名

     ```python
     >>> import os # 导入os模块
     >>> [d for d in os.listdir('.')] # os.listdir可以列出文件和目录
     ['.emacs.d', '.ssh', '.Trash', 'Adlm', 'Applications', 'Desktop', 'Documents', 'Downloads', 'Library', 'Movies', 'Music', 'Pictures', 'Public', 'VirtualBox VMs', 'Workspace', 'XCode']
     ```

   - 把一个 list 中所有的字符串变成小写

     ```python
     >>> L = ['Hello', 'World', 'IBM', 'Apple']
     >>> [s.lower() for s in L]
     ['hello', 'world', 'ibm', 'apple']
     ```

# 字典

## 基本语句

- 声明字典

```python
alien_0 = {'color':'green','points':5}         #字典是一系列键-值对
```

- 访问字典中的值

```python
print(alien_0['points'])
```

- 添加键-值对

```python
alien_0 ['x_position']=10
alien_0 ['y_position']=25
```

- 修改字典中的值

```python
alien_0['color'] = 'yellow'
```

- 删除键-值对

```python
del alien_0['color']
```

遍历字典

- 遍历键-值对

```python
for key,value in alien_0.items():
    print(key+':'+value+'\n')                #返回顺序与储存顺序无关
```

- 遍历键

```python
for key in alien_0.keys():                  #当要遍历所有键时，可去".keys()"
```

- 遍历值

```python
for value in alien_0.values(): 
```

- 有顺序地遍历

  使用 `sorted()` 函数，如：

```python
for key in sorted(alien_0.keys()):
```

- 合并遍历中的重复项

  使用 `set()` 函数，如：

```python
for value in set(alien_0.values()): 
```

## 集合

### 定义

集合（set）是一个无序的不重复元素序列

set 和 dict 类似，也是一组 key 的集合，但不存储 value。由于 key 不能重复，所以，在 set 中，没有重复的 key

### 基本操作

- 初始化

```python
s1 = set('cheershopa')         
s2 = set([1, 2, 3, 34, 15, 25, 35, 45, 75])         #传列表
```

- 添加值

```python
s.add(8)
```

- 删除值

```python
s.remove(8)
```

- 交集、并集

```python
s1 & s2
s1 | s2
```

### 嵌套

定义：列表中嵌套字典，字典中嵌套列表，字典中嵌套字典

#### 在列表中存储字典

```python
aliens=[]
for new_alien in range(30):
    new_alien={'color':'green','speed':'slow'}
    aliens.append(new_alien)
```

#### 在字典中存储列表

```python
favorate_languages={
       'Trouvaille':['C++'],
       'Nick':['Python'],
       'Leo':['Java','Python'],
       'Seamus':['Javascript','C++','Ruby']
   }
for x,y in favorate_languages.items( ):
    if len(y)>=2:
        print(x+"'s favorate are")
        for Y in y:
            print(Y)
     else: 
        print(x+"'s favorate is")
        for Y in y:
            print(Y)
```

#### 在字典中存储字典

```python
users={
    'Trouvaille':{
        'gender':'male',
        'location':'Hangzhou'
    },

    'Ketchup_Lover':{
        'gender':'male',
        'location':'Shanghai'
    }
}

for x,y in users.items():
    print(x+':')
    print("\t"+y['gender']+' , '+y['location'])
```

## 相关函数

### get()

- 说明：返回指定键的值，如果值不在字典中返回默认值 None

- 语法

```python
dict.get(key, default=None)
```

- 参数
  - key -- 字典中要查找的键
  - default -- 如果指定键的值不存在时，返回该默认值

### len()

- 说明：计算字典元素个数，即键的总数。

- 语法

```python
len(dict)
```

## 其他技巧

1. 通常习惯声明一个空字典以便添加键-值对

2. 字典通常储存一个对象的多种信息，也可以储存多个对象的同一种信息

3. 利用字典来完成列表中的词频统计

    ```python
    # 举例：
    a = [1, 2, 3, 1, 1, 2] 
    dict = {} 
    for key in a:         
        dict[key] = dict.get(key, 0) + 1  # 字典的get函数可以查询键的值，0代表默认值,每出现一次加1
    print (dict) 
    
    输出结果： >>>{1: 3, 2: 2, 3: 1}  
    ```

4. 字典推导式

    ```python
    >>> {i:str(i) for i in range(10)}
    {0: '0', 1: '1', 2: '2', 3: '3', 4: '4', 5: '5', 6: '6', 7: '7', 8: '8', 9: '9'}
    ```


# 类

## 基本语句

### 创建类

```python
class Restaurant():
    def __init__(self, name, type):
        self.name = name
        self.type = type
        self.customer_number = 0
```

### 创建方法

```python
def describe_rest(self):
    print("The restaurant's name is " + self.name.title())
    print("The restaurant's type is " + self.type.title())

def open_rest(self):
    print("This restaurant is opening")
```

### 使用类和实例

```python
rest1 = Restaurant('KFC', 'snack bar')
```

### 调用方法

```python
rest1.describe_rest()
rest1.open_rest()
```

## 继承

### 子类

```python
class IceCreamStand(Restaurant):
	def __init__(self,name,type):
		super().__init__(name,type)  # super()用来继承父类的属性                                                                    # 父类也称超类(superclass)
		self.flavours=['strawberry','chocolate','milk','matcha']  # 为子类定义的属性
```

### 给子类定义方法

```python
def describe_flavour(self):
	print("There're several kinds of flavours which are",end=' ')
	for flavour in self.flavours:
    	print(flavour,end=' ')
```

### 使用子类和实例 

```python
rest2=IceCreamStand('Dairy Queen','Ice Cream Stand')
rest2.describe_rest()
rest2.describe_flavour()
```

## 导入

假若有 Car 类, ElectricCar 类于 car.py 模块中

- 导入单个类

```python
from car import Car
```

- 导入多个类

```python
from car import Car, ElectricCar
```

- 导入整个模块

```python
import car                  #需用句点表示法
```

- 导入模块中的所有类

```python
from car import *
```

必要时，也允许从一个模块中导入另一个模块来构建子类

### 关于 `if __name__ == '__main__'`

这是个 Python 的语法，`__name__` 属性显示当前模块名

当模块被直接运行时 `__name__` 属性为 `‘__main__’` ，作为模块被导入时为模块名

这句话的意思就是，当模块被直接运行时，以下代码块将被运行，当模块是被导入时，代码块不被运行。

可以用作测试，也可以用作模板

## 私有成员与公有成员

python 并没有对私有成员提供严格的访问保护机制。

- 私有属性："__"  双下划线开头
    - 主函数中访问：`对象名._类名__value`
- 保护成员："_" 开头
    - 不能被作为包导入

```py
class A:
    def __init__(self, value1 = 0, value2 = 0):
        self._value1 = value1
        self.__value2 = value2
    def setValue(self, value1, value2):
        self._value1 = value1
        self.__value2 = value2
    def show(self):
        print(self._value1)
        print(self.__value2)

>>> a = A()
>>> a._value1
0
>>> a._A__value2         # 在外部访问对象的私有数据成员
0
>>> a.__value2           # 报错
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'A' object has no attribute '__value2'. Did you mean: '_A__value2'?
```

## 特殊方法

以双下划线开头结尾

- `__new__`：构造函数
- `__init__`：初始化函数
- `__del__`：析构函数
- `__add__`、`__sub__`：加减运算符
- `__str__`、`__repr__`：转字符串，后者将不可见字符转译
- `__call__`：被函数调用
- `__len__`：字面意思
- `__bool__`：字面意思
- `__lt__` `__gt__`、`__le__`、`__ge__`、`__eq__`、`__ne__`：`< > <= >= == !=`运算符重载
- `__contians__`：`in`，返回布尔值
- `__getitem__`：下标访问或迭代器访问
- `__setitem__`：下标修改或迭代器修改
- `__dict__`：使用一个字典对对象中成员的值进行修改，一般不需要重载
- `__iter__`：迭代器实现

# 文件

## 读取文件

### 全部读取

使用 `.read()` 

```python
with open(filename) as file_object:
    contents = file_object.read()  # 使用.read()读取文件的全部内容
    print(contents.rstrip())       # 使用.rstrip()来剥除.read()造成的末尾空字符串
```

### 逐行读取

遍历

```python
with open(filename) as file_object:
    for line in file_object:
        print(line.rstrip())               #使用.rstrip()来剥除文件每行末尾的换行符
```

### 创建一个包含文件各行内容的列表

使用 `.readlines() ` 

```python
with open(filename) as file_object:
    lines = file_object.readlines()       #使用.readlines() 从文件中读取每一行并存储到一个列表中

for line in lines:
    print(line.strip())
```

### 使用文件内容并将文件的空格全部移除

```python
with open(filename) as file_object:
    lines=file_object.readlines()

pi_string=''
for line in lines:
    pi_string+=line.strip()             # 使用.strip()将每行空格全部除去

print(pi_string)
print(pi_string[:10] + '...')
print(len(pi_string))
```

## 写入文件

### 写入空文件

```python
filename = 'text_files\programming.txt'

with open(filename, 'w') as file_object:
    file_object.write('Heya!\n')              # write()不会自动添加换行符，需手动添加
```

### 附加到文件

```python
filename = 'text_files\programming.txt'

with open(filename, 'a') as file_object:      # 'a'表示以附加模式打开文件
    file_object.write('Greeting!\n') 
```

## 其他打开方式

- r：以只读方式打开文件。文件的指针将会放在文件的开头。这是**默认**模式。
- rb：以二进制只读方式打开一个文件。文件指针将会放在文件的开头。
- r+：以读写方式打开一个文件。文件指针将会放在文件的开头。
- rb+：以二进制读写方式打开一个文件。文件指针将会放在文件的开头。
- w：以写入方式打开一个文件。如果该文件已存在，则将其覆盖。如果该文件不存在，则创建新文件。
- wb：以二进制写入方式打开一个文件。如果该文件已存在，则将其覆盖。如果该文件不存在，则创建新文件。
- w+：以读写方式打开一个文件。如果该文件已存在，则将其覆盖。如果该文件不存在，则创建新文件。
- wb+：以二进制读写格式打开一个文件。如果该文件已存在，则将其覆盖。如果该文件不存在，则创建新文件。
- a：以追加方式打开一个文件。如果该文件已存在，文件指针将会放在文件结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，则创建新文件来写入。
- ab：以二进制追加方式打开一个文件。如果该文件已存在，则文件指针将会放在文件结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，则创建新文件来写入。
- a+：以读写方式打开一个文件。如果该文件已存在，文件指针将会放在文件的结尾。文件打开时会是追加模式。如果该文件不存在，则创建新文件来读写。
- ab+：以二进制追加方式打开一个文件。如果该文件已存在，则文件指针将会放在文件结尾。如果该文件不存在，则创建新文件用于读写。

## 用 json 处理数据

### json 格式

对象：它在 JavaScript 中是使用花括号 `{}` 包裹起来的内容，数据结构为 `{key1: value1, key2: value2, ...}` 的键值对结构。在面向对象的语言中，key 为对象的属性，value 为对应的值。键名可以使用整数和字符串来表示。值的类型可以是任意类型。

数组：数组在 JavaScript 中是方括号 `[]` 包裹起来的内容，数据结构为 `["java", "javascript", "vb", ...]` 的索引结构。在 JavaScript 中，数组是一种比较特殊的数据类型，它也可以像对象那样使用键值对，但还是索引用得多。同样，值的类型可以是任意类型。

一个 JSON 对象可以写为如下形式：

```json
[{
    "name": "Bob",
    "gender": "male",
    "birthday": "1992-10-18"
}, {
     "name": "Selina",
    "gender": "female",
    "birthday": "1995-10-18"
}]
```

值得注意的是，JSON 的数据需要用双引号来包围，不能使用单引号

### 导入模块

```python
import json
```

json 库提供的主要功能也是字典与 json 的相互转换

### 存储数据

使用 `json.dump() `

```python
filename = 'name.json'
with open(filename, 'w') as f_obj:
	json.dump(name, f_obj)          # name为要储存的数据
```

### 读取数据

使用 `json.load() `

返回字典对象

```python
filename = 'name.json'
with open(filename) as f_obj:
    name = json.load(f_obj)         # 将json中的数据读到name中
```

使用 load 方法将字符串转为 JSON 对象。如果最外层是中括号，那最终的类型是列表类型

#### 数据转换表

| JSON          | Python |
| ------------- | ------ |
| object        | dict   |
| array         | list   |
| string        | str    |
| number (int)  | int    |
| number (real) | float  |
| true          | True   |
| false         | False  |
| null          | None   |

#### 其他特点

- 当 JSON 数据中有重复键名, 则后面的键值会覆盖前面的、
- json.loads 方法默认会将 JSON 字符串中的 NaN, Infinity, -Infinity 转化为 Python 中的 float('nan'), float('inf') 和 float('-inf')

### 输出数据

调用 dumps 方法将 JSON 对象转化为字符串

```python
import json

data = [{
    'name': 'Bob',
    'gender': 'male',
    'birthday': '1992-10-18'
}]
with open('data.json', 'w') as file:
    file.write(json.dumps(data))
```

利用 dumps 方法，我们可以将 JSON 对象转为字符串，然后再调用文件的 write 方法写入文本

如果想保存 JSON 的格式，可以再加一个参数 indent，代表缩进字符个数

```python
with open('data.json', 'w') as file:
    file.write(json.dumps(data, indent=2))
```

为了输出中文，还需要指定参数 ensure_ascii 为 False，另外还要规定文件输出的编码

```python
with open('data.json', 'w', encoding='utf-8') as file:
    file.write(json.dumps(data, indent=2, ensure_ascii=False))
```

# 异常处理

在 Python 中，`try` 语句用于捕获和处理异常。它的基本语法如下：

```py
try:
    # 可能引发异常的代码块
    # ...
except ExceptionType1:
    # 处理 ExceptionType1 类型的异常
    # ...
except ExceptionType2:
    # 处理 ExceptionType2 类型的异常
    # ...
else:
    # 当没有异常发生时执行的代码
    # ...
finally:
    # 无论是否有异常发生，都会执行的清理代码
    # ...
```

# 技巧

1. 生成依赖文件 `requirement.txt`：使用 `pipreqs`

```shell
pipreqs ./
```

2. 去除分隔符，将一段字符串转化为词语列表

```python
punctuation = r"""!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~“”？，！【】（）、。：；’‘……￥·"""
dicts = {i: ' ' for i in punctuation}
   punc_table = str.maketrans(dicts)
```

3. 矩阵转置

    ![image-20210530153535372](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210530153535372.png)

4. 获取当前路径

```python
from pathlib import Path

current_path = Path.cwd()
```

5. 用装饰器实现单例模式

```py
from functools import wraps
def singleton(cls):
    instances = {}
    @wraps(cls)
    def getinstance(*args, **kw):
        if cls not in instances:
            instances[cls] = cls(*args, **kw)
        return instances[cls]
    return getinstance
 
@singleton
class test_singleton(object):
  def __init__(self):
    self.num_sum=0
  def add(self):
    self.num_sum=100
    
if __name__ == '__main__':
  cls1 = test_singleton()
  cls2 = test_singleton()
  print(cls1)
  print(cls2)
```

输出

```py
<__main__.test_singleton object at 0x7fcb651870f0>
<__main__.test_singleton object at 0x7fcb651870f0>
```

可以看出，虽然进行了两次实例化，但仍为同一个实例

6. 删除一个列表中的重复元素

```py
L.sort()
last = L[-1]
for i in range(len(L)-2, -1, -1): # 从倒数第二个开始往前
    if last == L[i]:
    		del L[i]
		else:
    		last = L[i]
```

