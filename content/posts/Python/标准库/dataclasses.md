---
title: "Python dataclasses 库"
date: 2022-11-09
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# dataclasses

## 简介

dataclass 的定义位于 [PEP-557](https://www.python.org/dev/peps/pep-0557/)，根据定义，一个 dataclass 是指 “一个带有默认值的可变的 namedtuple”，广义的定义就是有一个类，它的属性均可公开访问，可以带有默认值并能被修改，而且类中含有与这些属性相关的类方法，那么这个类就可以称为 dataclass，再通俗点讲，**dataclass 就是一个含有数据及操作数据方法的容器**。

乍一看可能会觉得这个概念不就是普通的 class 么，然而还是有几处不同：

1. 相比普通 class，dataclass 通常不包含私有属性，数据可以直接访问
2. dataclass 的 repr 方法通常有固定格式，会打印出类型名以及属性名和它的值
3. dataclass 拥有 `__eq__` 和 `__hash__` 魔法方法
4. dataclass 有着模式单一固定的构造方式，或是需要重载运算符，而普通 class 通常无需这些工作

基于上述原因，通常自己实现一个dataclass是繁琐而无聊的，而dataclass单一固定的行为正适合程序为我们自动生成，于是`dataclasses`模块诞生了。

配合类型注解语法，我们可以轻松生成一个实现了`__init__`，`__repr__`，`__cmp__`等方法的dataclass：

```python
from dataclasses import dataclass
 
@dataclass
class InventoryItem:
    '''Class for keeping track of an item in inventory.'''
    name: str
    unit_price: float
    quantity_on_hand: int = 0
 
    def total_cost(self) -> float:
        return self.unit_price * self.quantity_on_hand
```

同时使用 dataclass 也有一些好处，它比 namedtuple 更灵活。同时因为它是一个常规的类，所以你可以享受继承带来的便利。

## 使用

在 python 中创建一个类，我们需要写 `__init__` 方法进行初始化对象操作，需要对对象进一步说明的话，最好写一个 `__repr__` 方法，这样我们直接输出对象的话，方便理解这个对象是啥。写两三个这样的类还好，多了的话，就觉得烦躁了，因为每写个类，你都得需要写 `__init__`，`__repr__` 这些方法，都是重复性的操作。

```python
class People:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __repr__(self):
        return f"Student-{self.name}"


# 实例一个name为zhuyu的People对象
zhuyu = People("zhuyu", 23)
print(zhuyu.name)  # 输出 zhuyu
print(zhuyu)  # Student-zhuyu
```

下面使用 dataclasses 去创建一个类，相对于上面这个类的写法是不是显得简单很多，一些魔法方法不用我们自己去写 dataclasss 会帮我们完成。

```python
from dataclasses import dataclass


@dataclass  # 重点这里
class Goods:
    """商品类"""
    name: str
    price: float


milk = Goods("milk", 9.99)
print(milk.name)  # milk
print(milk)       # Goods(name='milk', price=9.99)
```

### 控制魔法方法的重写

dataclass 会帮我们重写一个魔法方法，可能是你想要的，也可能是你不想要的，我们可以通过一些参数进行控制(哪些魔法不想重写)，继续看 dataclass 函数，它是可以传参数的，它的注释也写得很清楚了

```python
def dataclass(_cls=None, *, init=True, repr=True, eq=True, order=False,
              unsafe_hash=False, frozen=False):
    """Returns the same class as was passed in, with dunder methods
    added based on the fields defined in the class.

    Examines PEP 526 __annotations__ to determine fields.

    If init is true, an __init__() method is added to the class. If
    repr is true, a __repr__() method is added. If order is true, rich
    comparison dunder methods are added. If unsafe_hash is true, a
    __hash__() method function is added. If frozen is true, fields may
    not be assigned to after instance creation.
    """

    def wrap(cls):
        return _process_class(cls, init, repr, eq, order, unsafe_hash, frozen)

    # See if we're being called as @dataclass or @dataclass().
    if _cls is None:
        # We're called with parens.
        return wrap

    # We're called as @dataclass without parens.
    return wrap(_cls)
```

**init** 参数默认为 `True`，会默认帮你添加 init 方法，那么你实例化该对象的话，就需要传参数 (如果需要参数传递话)，为 `False` 的话，实例对象就不用传递了

当然之前我们在写类的时候，`init` 方法中不单单只是对属性进行赋值，例如下面这个 demo

```python
import uuid


def get_id():
    return str(uuid.uuid4())


class A:

    def __init__(self, name):
        self.name = name
        self.id = get_id()   # id不需要当作参数传来
        self._init_config()  # 执行其他一些初始化操作

    def _init_config(self):
        """配置相关的操作"""
				print("执行初始化操作")
        print(self.name)


a = A("zhuyu")
print(a.id)
```

### post_init

下面我们通过 dataclass 来实现上面这个例子，通过重写 `__post_init__` 这个方法，在这个方法中做一个逻辑操作，它执行完 `__init__` 方法之后就会调用 `__post_init__` 这个方法

```python
from dataclasses import dataclass
import uuid


def get_id():
    return str(uuid.uuid4())


@dataclass
class A:
    name: str
    id: str = get_id()  # id 通过调用一个函数生成，就不用传入了

    def _init_config(self):
        """配置相关的操作"""
        print("执行初始化操作")
        print(self.name)

    def __post_init__(self):
        self._init_config()


a = A("zhu")
print(a.id)
```

关于类的继承，使用 dataclass 一样也是可以继承的

```python
from dataclasses import dataclass


@dataclass
class A:
    name: str

    def __post_init__(self):
        print('父类')


@dataclass
class B(A):
    age: int

    def __post_init__(self):
        print('基类')
        super().__post_init__()


b = B('name', 22)
```

### field

继续看 field，这个函数的位置为 `from dataclasses import field`

```python
def field(*, default=MISSING, default_factory=MISSING, init=True, repr=True,
          hash=None, compare=True, metadata=None):
    """Return an object to identify dataclass fields.

    default is the default value of the field.  default_factory is a
    0-argument function called to initialize a field's value.  If init
    is True, the field will be a parameter to the class's __init__()
    function.  If repr is True, the field will be included in the
    object's repr().  If hash is True, the field will be included in
    the object's hash().  If compare is True, the field will be used
    in comparison functions.  metadata, if specified, must be a
    mapping which is stored but not otherwise examined by dataclass.

    It is an error to specify both default and default_factory.
    """

    if default is not MISSING and default_factory is not MISSING:
        raise ValueError('cannot specify both default and default_factory')
    return Field(default, default_factory, init, repr, hash, compare,
                 metadata)
```

写个demo看看这个怎么使用

```python
from dataclasses import field, dataclass


@dataclass
class A:
    name: str = field(default='zhuyu')


@dataclass
class B:
    name: str = field(init=True)


a = A()
b = B('zhuyu')
print(a.name)  # zhuyu
print(b.name)  # zhuyu

# init 默认为 true,说明你在初始化对象的时候，需要传递该参数(参考class B)，但是 field 中从参数 default 或者 default_factory 不为空的时候，就算 init 为 true，也是可以不用传递参数(参考 class A)
from dataclasses import field, dataclass


@dataclass
class A:
    name: str = field()
    age: int = field(repr=False)


@dataclass
class B:
    name: str = field()
    age: int = field(repr=True)


a = A('zhuyu', 22)
b = B('zhuyu', 23)
print(a)  # A(name='zhuyu')
print(b)  # B(name='zhuyu', age=23)

# repr 默认为 True，会将该字段添加到 __repr__ 中去，为 False 的话，则不会添加进去
```

## 深入 dataclasses 装饰器

dataclass 的魔力源泉都在 `dataclass` 这个装饰器中，如果想要完全掌控 dataclass 的话那么它是你必须了解的内容。

装饰器的原型如下：

```python
dataclasses.dataclass(*, init=True, repr=True, eq=True, order=False, unsafe_hash=False, frozen=False)
```

`dataclass` 装饰器将根据类属性生成数据类和数据类需要的方法。

我们的关注点集中在它的`kwargs`上：

- init
    - 指定是否自动生成 `__init__`，如果已经有定义同名方法则忽略这个值，也就是指定为 True 也不会自动生成
- repr
    - 同 init，指定是否自动生成 `__repr__`；自动生成的打印格式为 `class_name(arrt1:value1, attr2:value2, ...)`
- eq
    - 同 init，指定是否生成 `__eq__`；自动生成的方法将按属性在类内定义时的顺序逐个比较，全部的值相同才会返回 True
- order
    - 自动生成 `__lt__`，`__le__`，`__gt__`，`__ge__`，比较方式与 eq 相同；如果 order 指定为 True 而 eq 指定为 False，将引发 `ValueError`；如果已经定义同名函数，将引发 `TypeError`
- frozen
    - 设为 True 时，对 field 赋值将会引发错误，对象将是不可变的，如果已经定义了 `__setattr__` 和 `__delattr__` 将会引发 `TypeError`
- unsafehash
    - 如果是 False，将根据 eq 和 frozen 参数来生成 `__hash__`。
        1. eq 和 frozen 都为True，`__hash__` 将会生成 
        2. eq 为 True 而 frozen 为 False，`__hash__` 被设为 `None`
        3. eq 为 False，frozen 为 True，`__hash__` 将使用超类（object）的同名属性（通常就是基于对象 id 的 hash） 当设置为 True 时将会根据类属性自动生成 `__hash__`
            - 然而这是不安全的，因为这些属性是默认可变的，这会导致 hash 的不一致，所以除非能保证对象属性不可随意改变，否则应该谨慎地设置该参数为 True

有默认值的属性必须定义在没有默认值的属性之后，和对 kw 参数的要求一样。

上面我们偶尔提到了 field 的概念，我们所说的数据类属性，数据属性实际上都是被 field 的对象，它代表着一个数据的实体和它的元信息，下面我们了解一下 `dataclasses.field`。

### 数据类的基石 —— dataclasses.field

先看下 field 的原型：

```py
python dataclasses.field(*, default=MISSING, default_factory=MISSING, repr=True, hash=None, init=True, compare=True, metadata=None)
```

通常我们无需直接使用，装饰器会根据我们给出的类型注解自动生成 field，但有时候我们也需要定制这一过程，这时 `dataclasses.field` 就显得格外有用了。

default 和 default_factory 参数将会影响默认值的产生，它们的默认值都是 None，意思是调用时如果为指定则产生一个为 None 的值。

其中 default 是 field 的默认值，而 default_factory 控制如何产生值，它接收一个无参数或者全是默认参数的 `callable` 对象，然后用调用这个对象获得 field 的初始值，之后再将 default（如果值不是 MISSING）复制给 `callable` 返回的这个对象。

举个例子，对于 list，当复制它时只是复制了一份引用，所以像 dataclass 里那样直接复制给实例的做法是危险而错误的，为了保证使用 list 时的安全性，应该这样做：

```python
@dataclass
class C:
    mylist: List[int] = field(default_factory=list)
```

当初始化 `C` 的实例时就会调用 `list()` 而不是直接复制一份 list 的引用：

```py
>>> c1 = C()
>>> c1.mylist += [1,2,3]
>>> c1.mylist
[1, 2, 3]
>>> c2 = C()
>>> c2.mylist
[]
```

数据污染得到了避免。

init 参数如果设置为 False，表示不为这个 field 生成初始化操作，dataclass 提供了 hook—— `__post_init__` 供我们利用这一特性：

```py
@dataclass
class C:
    a: int
    b: int
    c: int = field(init=False)
 
    def __post_init__(self):
        self.c = self.a + self.b
```

`__post_init__` 在 `__init__` 后被调用，我们可以在这里初始化那些需要前置条件的 field。

repr 参数表示该 field 是否被包含进 repr 的输出，compare 和 hash 参数表示 field 是否参与比较和计算 hash 值。metadata 不被 dataclass自身使用，通常让第三方组件从中获取某些元信息时才使用，所以我们不需要使用这一参数。

如果指定一个 field 的类型注解为 `dataclasses.InitVar`，那么这个 field 将只会在初始化过程中（`__init__` 和 `__post_init__`）可以被使用，当初始化完成后访问该 field 会返回一个 `dataclasses.Field` 对象而不是 field 原本的值，也就是**该 field 不再是一个可访问的数据对象**。

举个例子，比如一个由数据库对象，它只需要在初始化的过程中被访问：

```py
@dataclass
class C:
    i: int
    j: int = None
    database: InitVar[DatabaseType] = None
 
    def __post_init__(self, database):
        if self.j is None and database is not None:
            self.j = database.lookup('j')
 
c = C(10, database=my_database)
```

这个例子中会返回 `c.i` 和 `c.j` 的数据，但是不会返回 `c.database` 的。

### 一些常用函数

`dataclasses` 模块中提供了一些常用函数供我们处理数据类。

使用 `dataclasses.asdict` 和 `dataclasses.astuple` 我们可以把数据类实例中的数据转换成字典或者元组：

```python
>>> from dataclasses import asdict, astuple
>>> asdict(Lang())
{'name': 'python', 'strong_type': True, 'static_type': False, 'age': 28}
>>> astuple(Lang())
('python', True, False, 28)
```

使用 `dataclasses.is_dataclass` 可以判断一个类或实例对象是否是数据类：

```python
>>> from dataclasses import is_dataclass
>>> is_dataclass(Lang)
True
>>> is_dataclass(Lang())
True
```

### dataclass 继承

python3.7 引入 dataclass 的一大原因就在于**相比 namedtuple，dataclass 可以享受继承带来的便利**

`dataclass` 装饰器会检查当前 class 的所有基类，如果发现一个 dataclass，就会把它的字段按顺序添加进当前的 class，随后再处理当前 class 的 field。所有生成的方法也将按照这一过程处理，因此如果子类中的 field 与基类同名，那么**子类将会无条件覆盖基类**。子类将会根据所有的 field 重新生成一个构造函数，并在其中初始化基类。

看个例子：

```python
@dataclass 
class Lang: 
  """a dataclass that describes a programming language"""
  name: str = 'python' 
  strong_type: bool = True 
  static_type: bool = False 
  age: int = 28

@dataclass
class Python(Lang):
    tab_size: int = 4
    is_script: bool = True
 
>>> Python()
Python(name='python', strong_type=True, static_type=False, age=28, tab_size=4, is_script=True)
 
@dataclass
class Base:
    x: float = 25.0
    y: int = 0
 
@dataclass
class C(Base):
    z: int = 10
    x: int = 15
 
>>> C()
C(x=15, y=0, z=10)
```

`Lang` 的 field 被 `Python` 继承了，而 `C` 中的 `x` 则覆盖了 `Base` 中的定义。

没错，数据类的继承就是这么简单。

## 总结

合理使用 dataclass 将会大大减轻开发中的负担，将我们从大量的重复劳动中解放出来，这既是 dataclass 的魅力，不过魅力的背后也总是有陷阱相伴

- dataclass 通常情况下是 unhashable 的，因为默认生成的 `__hash__` 是 `None`，所以不能用来做字典的 key，如果有这种需求，那么应该指定你的数据类为 frozen dataclass 
- 小心当你定义了和 `dataclass` 生成的同名方法时会引发的问题
- 当使用可变类型（如 list）时，应该考虑使用 `field` 的 `default_factory`
- 数据类的属性都是公开的，如果你有属性只需要初始化时使用而不需要在其他时候被访问，请使用 `dataclasses.InitVar`

只要避开这些陷阱，dataclass 一定能成为提高生产力的利器
