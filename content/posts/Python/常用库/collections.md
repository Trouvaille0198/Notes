# 认识

collections 实现了特定目标的容器，以提供 Python 标准内建容器 dict、list、set、tuple 的替代选择

- Counter：计数器，字典的子类，提供了可哈希对象的计数功能
- defaultdict：默认字典，字典的子类，提供了一个工厂函数，为字典查询提供了默认值
- OrderedDict：有序字典，字典的子类，保留了他们被添加的顺序
- namedtuple：可命名元组，创建命名元组子类的工厂函数
- deque：双向队列，类似列表容器，实现了在两端快速添加 (append) 和弹出 (pop)
- ChainMap：类似字典的容器类，将多个映射集合到一个视图里面

# Counter

## 说明

Counter作为字典dicit（）的一个子类用来进行 hashtable 计数，将元素进行数量统计

计数后返回一个字典，键值为元素，值为元素个数

```python
a=Counter('hello world hello world hello nihao'.split())
print(a)

# Counter({'hello': 3, 'world': 2, 'nihao': 1})
```

允许进行 `Counter` 对象之间的**加减操作**

## 方法

- ***elements()***

    返回一个迭代器，每个元素重复计算的个数，如果一个元素的计数小于1,就会被忽略。

- ***most_common([n])***

    返回一个嵌套着元组的列表，提供 n 个访问频率最高的元素和计数

- subtract([iterable-or-mapping])

    从迭代对象中减去元素，输入输出可以是 0 或者负数

- update([iterable-or-mapping])

    从迭代对象计数元素或者从另一个 映射对象 (或计数器) 添加。

```python
print(list(a.elements()))
# ['hello', 'hello', 'hello', 'world', 'world', 'nihao']

for x in a.elements():
    print(x)
# hello
# hello
# hello
# world
# world
# nihao

print(a.most_common(2))
# [('hello', 3), ('world', 2)]

a.subtract({'nihao':2})
print(a)
# Counter({'hello': 3, 'world': 2, 'nihao': -1})

a.update({'wow':5})
print(a)
# Counter({'wow': 5, 'hello': 3, 'world': 2, 'nihao': -1})

```

# defaultdict

默认字典，字典的一个子类，继承所有字典的方法，默认字典在进行定义初始化的时候得指定字典值有默认类型

暂时没啥用

# OrderedDict

Python 字典中的键的顺序是任意的:它们不受添加的顺序的控制。

`collections.OrderedDict`类提供了保留他们添加顺序的字典对象。

```python
d1 = collections.OrderedDict()
d1['a'] = 'A'
d1['b'] = 'B'
d1['c'] = 'C'
d1['1'] = '1'
d1['2'] = '2'
for k,v in d1.items():
    print k,v
```

输出

```python\
a A
b B
c C
1 1
312 2
```



# namedtuple

namedtuple 由自己的类工厂 namedtuple() 进行创建，而不是由表中的元组进行初始化

通过 namedtuple 创建类的参数包括类名称和一个包含元素名称的字符串

```python
# 三种声明方式
Person1 = namedtuple('Person1', ['name', 'age', 'sex'])
Person2 = namedtuple('Person2', 'name, age, sex')
Person3 = namedtuple('Person3', 'name age sex')

zhangsan=Person1('zhangsan',20,'male')
print(zhangsan)
# Person1(name='zhangsan', age=20, sex='male')
```

# deque

`collections.deque`返回一个新的双向队列对象，从左到右初始化(用方法 append()) ，从 iterable （迭代对象) 数据创建。如果 iterable 没有指定，新队列为空。

`collections.deque` 队列支持线程安全，对于从两端添加(append)或者弹出(pop)，复杂度 O(1)

- maxlen：属性参数，队列的最大长度，没有限定则为 None

- append(x)：添加 x 到右端
- appendleft(x)：添加 x 到左端
- clear()：清除所有元素，长度变为 0
- copy()：创建一份浅拷贝
- count(x)：计算队列中 x 元素的个数
- extend(iterable)：在队列右侧添加 iterable 中的元素
- extendleft(iterable)：在队列左侧添加 iterable 中的元素，注：在左侧添加时，iterable参数的顺序将会反过来添加
- index(x[,start[,stop]])：返回第 x 个元素（从 start 开始计算，在 stop 之前）。返回第一个匹配，如果没找到的话，升起 ValueError 
- insert(i,x)：在位置 i 插入 x 。注：如果插入会导致一个限长deque超出长度 maxlen 的话，就升起一个 IndexError 。
- pop()：移除最右侧的元素
- popleft()：移除最左侧的元素
- remove(value)：移去找到的第一个 value。没有抛出ValueError
- reverse()：将deque逆序排列。返回 None 。

```python
a=deque([],maxlen=10)
a.append('1')
a.appendleft('2')

print(a)
# deque(['2', '1'], maxlen=10)
```

# ChainMap

一个 ChainMap 将多个字典或者其他映射组合在一起，创建一个单独的可更新的视图。若没有 maps 被指定，就提供一个默认的空字典 

`ChainMap ` 是管理嵌套上下文和覆盖的有用工具