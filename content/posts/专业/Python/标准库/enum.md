---
title: "Python enum 库"
date: 2024-4-7
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# enum

> 官方文档：https://docs.python.org/zh-cn/3/library/enum.html

一个枚举（enum）是：

- 是绑定到唯一值的符号名称（成员）集合
- 可以被执行迭代以按定义顺序返回其规范的（即非别名的）成员
- 使用 *调用* 语法按值返回成员
- 使用 *索引* 语法按名称返回成员

枚举是使用 [`class`](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#class) 语法或是使用函数调用语法来创建的:

```py
>>> from enum import Enum

>>> # class syntax
>>> class Color(Enum):
...     RED = 1
...     GREEN = 2
...     BLUE = 3

>>> # functional syntax
>>> Color = Enum('Color', ['RED', 'GREEN', 'BLUE'])
```

> 虽然我们可以使用 [`class`](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#class) 语法来创建枚举，但枚举并不是常规的 Python 类。

- 类 `Color` 是一个 *枚举* （或 *enum* ）
- 属性 `Color.RED` 、 `Color.GREEN` 等是 *枚举成员* （或 *members* ）并且在功能上是常量。
- 枚举成员有 *names* 和 *values* (`Color.RED` 的 name 是 `RED`，`Color.BLUE` 的 value 是 `3`，等等)

## 快速上手

### Enum

[`Enum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum) 是一组与互不相同的值分别绑定的符号名。类似于全局变量，但提供了更好用的 [`repr()`](https://docs.python.org/zh-cn/3/library/functions.html#repr)、分组、类型安全和一些其它特性。

它们最适用于当某个变量可选的值有限时。例如，从一周中选取一天：

```py
>>> from enum import Enum
>>> class Weekday(Enum):
...     MONDAY = 1
...     TUESDAY = 2
...     WEDNESDAY = 3
...     THURSDAY = 4
...     FRIDAY = 5
...     SATURDAY = 6
...     SUNDAY = 7
```

或是 RGB 三原色：

```py
>>> from enum import Enum
>>> class Color(Enum):
...     RED = 1
...     GREEN = 2
...     BLUE = 3
```

正如你所见，创建一个 [`Enum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum) 就是简单地写一个继承 [`Enum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum) 的类。

```py
>>> Weekday(3)
<Weekday.WEDNESDAY: 3>

>>> print(Weekday.THURSDAY)
Weekday.THURSDAY

>>> type(Weekday.MONDAY)
<enum 'Weekday'>
>>> isinstance(Weekday.FRIDAY, Weekday)
True

>>> print(Weekday.TUESDAY.name)
TUESDAY
>>> Weekday.WEDNESDAY.value
3
```

### Flag

如果变量只需要存一天，这个 `Weekday` 枚举是不错，但如果需要好几天呢？比如要写个函数来描绘一周内的家务，并且不想用 [`list`](https://docs.python.org/zh-cn/3/library/stdtypes.html#list)，则可以使用不同类型的 [`Enum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum):

```py
>>> from enum import Flag
>>> class Weekday(Flag):
...     MONDAY = 1
...     TUESDAY = 2
...     WEDNESDAY = 4
...     THURSDAY = 8
...     FRIDAY = 16
...     SATURDAY = 32
...     SUNDAY = 64
```

这里做了两处改动：继承了 [`Flag`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Flag)，而且值都是2的幂。

就像最开始的 `Weekday` 枚举一样，可以只用一种类型:

```py
>>> first_week_day = Weekday.MONDAY
>>> first_week_day
<Weekday.MONDAY: 1>
```

但 [`Flag`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Flag) 也允许将几个成员并入一个变量:

```py
>>> weekend = Weekday.SATURDAY | Weekday.SUNDAY
>>> weekend
<Weekday.SATURDAY|SUNDAY: 96>
```

甚至可以在一个 [`Flag`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Flag) 变量上进行迭代:

```py
>>> for day in weekend:
...     print(day)
Weekday.SATURDAY
Weekday.SUNDAY
```

让我们来安排家务吧:

```py
>>> chores_for_ethan = {
...     'feed the cat': Weekday.MONDAY | Weekday.WEDNESDAY | Weekday.FRIDAY,
...     'do the dishes': Weekday.TUESDAY | Weekday.THURSDAY,
...     'answer SO questions': Weekday.SATURDAY,
...     }
```

一个显示某天家务的函数:

```py
>>> def show_chores(chores, day):
...     for chore, days in chores.items():
...         if day in days:
...             print(chore)
...
>>> show_chores(chores_for_ethan, Weekday.SATURDAY)
answer SO questions
```

:heavy_check_mark: 如果成员值是什么无所谓，可以少些工作，用 [`auto()`](https://docs.python.org/zh-cn/3/library/enum.html#enum.auto) 来取值:

```py
>>> from enum import auto
>>> class Weekday(Flag):
...     MONDAY = auto()
...     TUESDAY = auto()
...     WEDNESDAY = auto()
...     THURSDAY = auto()
...     FRIDAY = auto()
...     SATURDAY = auto()
...     SUNDAY = auto()
...     WEEKEND = SATURDAY | SUNDAY
```

### 枚举成员及其属性 (key and value) 的访问

有时，要在程序中访问枚举成员（如，开发时不知道颜色的确切值，`Color.RED` 不适用的情况）。`Enum` 支持如下访问方式:

```py
>>> Color(1)
<Color.RED: 1>
>>> Color(3)
<Color.BLUE: 3>
```

若要用 *名称* 访问枚举成员时，可使用枚举项:

```py
>>> Color['RED']
<Color.RED: 1>
>>> Color['GREEN']
<Color.GREEN: 2>
```

若有了枚举成员，需要获取 `name` 或 `value`:

```py
>>> member = Color.RED
>>> member.name
'RED'
>>> member.value
1
```

### 重复的枚举成员和值

两个枚举成员的名称不能相同:

```py
>>> class Shape(Enum):
...     SQUARE = 2
...     SQUARE = 3
...
Traceback (most recent call last):
...
TypeError: 'SQUARE' already defined as 2
```

然而，一个枚举成员可以关联多个其他名称。如果两个枚举项 `A` 和 `B` 具有相同值（并且首先定义的是 `A` ），则 `B` 是成员 `A` 的别名。对 `A` 按值检索将会返回成员 `A`。按名称检索 `B` 也会返回成员 `A`:

```py
>>> class Shape(Enum):
...     SQUARE = 2
...     DIAMOND = 1
...     CIRCLE = 3
...     ALIAS_FOR_SQUARE = 2
...
>>> Shape.SQUARE
<Shape.SQUARE: 2>
>>> Shape.ALIAS_FOR_SQUARE
<Shape.SQUARE: 2>
>>> Shape(2)
<Shape.SQUARE: 2>
```

默认情况下，枚举允许多个名称作为同一个值的别名。若不想如此，可以使用 [`unique()`](https://docs.python.org/zh-cn/3/library/enum.html#enum.unique) 装饰器:

```py
>>> from enum import Enum, unique
>>> @unique
... class Mistake(Enum):
...     ONE = 1
...     TWO = 2
...     THREE = 3
...     FOUR = 3
...
Traceback (most recent call last):
...
ValueError: duplicate values found in <enum 'Mistake'>: FOUR -> THREE
```

### 使用自动设定的值

如果具体的枚举值无所谓是什么，可以使用 [`auto`](https://docs.python.org/zh-cn/3/library/enum.html#enum.auto):

```py
>>> from enum import Enum, auto
>>> class Color(Enum):
...     RED = auto()
...     BLUE = auto()
...     GREEN = auto()
...
>>> [member.value for member in Color]
[1, 2, 3]
```

枚举值将交由 `_generate_next_value_()` 选取，该函数可以被重写:

```py
>>> class AutoName(Enum):
...     @staticmethod
...     def _generate_next_value_(name, start, count, last_values):
...         return name
...
>>> class Ordinal(AutoName):
...     NORTH = auto()
...     SOUTH = auto()
...     EAST = auto()
...     WEST = auto()
...
>>> [member.value for member in Ordinal]
['NORTH', 'SOUTH', 'EAST', 'WEST']
```

### 迭代遍历

对枚举成员的迭代遍历不会列出别名:

```py
>>> list(Shape)
[<Shape.SQUARE: 2>, <Shape.DIAMOND: 1>, <Shape.CIRCLE: 3>]

>>> list(Weekday)
[<Weekday.MONDAY: 1>, <Weekday.TUESDAY: 2>, <Weekday.WEDNESDAY: 4>, <Weekday.THURSDAY: 8>, <Weekday.FRIDAY: 16>, <Weekday.SATURDAY: 32>, <Weekday.SUNDAY: 64>]
```

👆 `Shape.ALIAS_FOR_SQUARE` 和 `Weekday.WEEKEND` 等别名没有被显示。

特殊属性 `__members__` 是一个名称与成员间的只读有序映射。包含了枚举中定义的所有名称，包括别名:

```py
>>> for name, member in Shape.__members__.items():
...     name, member
...
('SQUARE', <Shape.SQUARE: 2>)
('DIAMOND', <Shape.DIAMOND: 1>)
('CIRCLE', <Shape.CIRCLE: 3>)
('ALIAS_FOR_SQUARE', <Shape.SQUARE: 2>)
```

`__members__` 属性可用于获取枚举成员的详细信息。比如查找所有别名:

```py
>>> [name for name, member in Shape.__members__.items() if member.name != name]
['ALIAS_FOR_SQUARE']
```

### 比较运算

枚举成员是按 ID 进行比较的:

```py
>>> Color.RED is Color.RED
True
>>> Color.RED is Color.BLUE
False
>>> Color.RED is not Color.BLUE
True
```

枚举值之间无法进行有序的比较。枚举的成员不是整数（另请参阅下文 [IntEnum](https://docs.python.org/zh-cn/3/howto/enum.html#intenum)）:

```py
>>> Color.RED < Color.BLUE
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: '<' not supported between instances of 'Color' and 'Color'
```

相等性比较的定义如下:

```py
>>> Color.BLUE == Color.BLUE
True
>>> Color.BLUE == Color.RED
False
>>> Color.BLUE != Color.RED
True
```

与非枚举值的比较将总是不等的（同样 [`IntEnum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.IntEnum) 有意设计为其他的做法，参见下文）:

```py
>>> Color.BLUE == 2
False
```

### 合法的枚举成员和属性

以上大多数示例都用了整数作为枚举值。使用整数确实简短方便（并且是 [Functional API](https://docs.python.org/zh-cn/3/howto/enum.html#functional-api) 默认提供的值），但并非强制要求。绝大多数情况下，人们并不关心枚举的实际值是什么。但如果值确实重要，可以使用任何值。

枚举是 Python 的类，可带有普通方法和特殊方法。假设有如下枚举:

```py
>>> class Mood(Enum):
...     FUNKY = 1
...     HAPPY = 3
...
...     def describe(self):
...         # self is the member here
...         return self.name, self.value
...
...     def __str__(self):
...         return 'my custom str! {0}'.format(self.value)
...
...     @classmethod
...     def favorite_mood(cls):
...         # cls here is the enumeration
...         return cls.HAPPY
...
```

那么:

```py
>>> Mood.favorite_mood()
<Mood.HAPPY: 3>
>>> Mood.HAPPY.describe()
('HAPPY', 3)
>>> str(Mood.FUNKY)
'my custom str! 1'
```

合法的规则如下：以单下划线开头和结尾的名称是保留值，不能使用；在枚举中定义的其他所有属性都将成为该枚举的成员，但特殊方法（`__str__()` 、`__add__()` 等）、描述符（方法也是描述符）和在 `_ignore_` 中列出的变量名除外。

注意：如果你的枚举定义了 `__new__()` 和/或 `__init__()`，则给予枚举成员的任何值都将被传递给这些方法。 请参阅示例 [Planet](https://docs.python.org/zh-cn/3/howto/enum.html#planet)。

> 如果定义了 `__new__()` 方法，则它会在创建 Enum 成员时被使用；然后它将被 Enum 的 `__new__()` 所替换，该方法会在类创建后被用于查找现有成员。 详情参见 [何时使用 __new__() 与 __init__()](https://docs.python.org/zh-cn/3/howto/enum.html#new-vs-init)。

### 受限的 Enum 子类化

新建的 [`Enum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum) 类必须包含：一个枚举基类、至多一种数据类型和按需提供的基于 [`object`](https://docs.python.org/zh-cn/3/library/functions.html#object) 的混合类。这些基类的顺序如下:

```py
class EnumName([mix-in, ...,] [data-type,] base-enum):
    pass
```

仅当未定义任何成员时，枚举类才允许被子类化。因此不得有以下写法:

```py
>>> class MoreColor(Color):
...     PINK = 17
...
Traceback (most recent call last):
...
TypeError: <enum 'MoreColor'> cannot extend <enum 'Color'>
```

但以下代码是可以的:

```py
>>> class Foo(Enum):
...     def some_behavior(self):
...         pass
...
>>> class Bar(Foo):
...     HAPPY = 1
...     SAD = 2
...
```

如果定义了成员的枚举也能被子类化，则类型与实例的某些重要不可变规则将会被破坏。另一方面，一组枚举类共享某些操作也是合理的。（请参阅例程 [OrderedEnum](https://docs.python.org/zh-cn/3/howto/enum.html#orderedenum) ）

### 数据类支持

当从 [`dataclass`](https://docs.python.org/zh-cn/3/library/dataclasses.html#dataclasses.dataclass) 继承时，[`__repr__()`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum.__repr__) 将忽略被继承类的名称。 例如:

```py
>>> from dataclasses import dataclass, field
>>> @dataclass
... class CreatureDataMixin:
...     size: str
...     legs: int
...     tail: bool = field(repr=False, default=True)
...
>>> class Creature(CreatureDataMixin, Enum):
...     BEETLE = 'small', 6
...     DOG = 'medium', 4
...
>>> Creature.DOG
<Creature.DOG: size='medium', legs=4>
```

使用 `dataclass()` 参数 `repr=False` 来使用标准的 [`repr()`](https://docs.python.org/zh-cn/3/library/functions.html#repr)。

> *在 3.12 版本发生变更:* 只有数据类字段会被显示在值区域中，而不会显示数据类的名称。Only the dataclass fields are shown in the value area, not the dataclass' name.

### 打包（pickle）

枚举类型可以被打包和解包:

```py
>>> from test.test_enum import Fruit
>>> from pickle import dumps, loads
>>> Fruit.TOMATO is loads(dumps(Fruit.TOMATO))
True
```

打包的常规限制同样适用于枚举类型：必须在模块的最高层级定义，因为解包操作要求可从该模块导入。

> 用 pickle 协议版本 4 可以轻松地将嵌入其他类中的枚举进行打包。

通过在枚举类中定义 `__reduce_ex__()` 来修改枚举成员的封存/解封方式是可能的。 默认的方法是基于值的，但具有复杂值的枚举也许会想要基于名称的:

```py
>>> import enum
>>> class MyEnum(enum.Enum):
...     __reduce_ex__ = enum.pickle_by_enum_name
```

> 不建议为旗标使用基于名称的方式，因为未命名的别名将无法解封。

### 函数式 API

[`Enum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum) 类可调用并提供了以下函数式 API：

```py
>>> Animal = Enum('Animal', 'ANT BEE CAT DOG')
>>> Animal
<enum 'Animal'>
>>> Animal.ANT
<Animal.ANT: 1>
>>> list(Animal)
[<Animal.ANT: 1>, <Animal.BEE: 2>, <Animal.CAT: 3>, <Animal.DOG: 4>]
```

该 API 的语义类似于 [`namedtuple`](https://docs.python.org/zh-cn/3/library/collections.html#collections.namedtuple)。调用 [`Enum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum) 的第一个参数是枚举的名称。

第二个参数是枚举成员名称的 *来源*。可以是个用空格分隔的名称字符串、名称序列、表示键/值对的二元组的序列，或者名称到值的映射（如字典）。 最后两种可以为枚举赋任意值；其他类型则会自动赋成由 1 开始递增的整数值（利用 `start` 形参可指定为其他起始值）。返回值是一个派生自 [`Enum`](https://docs.python.org/zh-cn/3/library/enum.html#enum.Enum) 的新类。换句话说，上述对 `Animal` 的赋值等价于:

```py
>>> class Animal(Enum):
...     ANT = 1
...     BEE = 2
...     CAT = 3
...     DOG = 4
...
```

默认从 `1` 开始而非 `0` ，因为 `0` 是布尔值 `False` ，但默认的枚举成员都被视作 `True` 。

对使用函数式 API 创建的枚举进行封存，可能会很棘手，因为要使用栈帧的实现细节来尝试找出枚举是在哪个模块中创建的（例如当你使用了另一个模块中的实用函数时它就可能失败，在 IronPython 或 Jython 上也可能无效）。解决办法是像下面这样显式地指定模块名称：

\>>>

```
>>> Animal = Enum('Animal', 'ANT BEE CAT DOG', module=__name__)
```

警告

 

如果未提供 `module`，且 Enum 无法确定是哪个模块，新的 Enum 成员将不可被解封；为了让错误尽量靠近源头，封存将被禁用。

新的 pickle 协议版本 4 在某些情况下同样依赖于 [`__qualname__`](https://docs.python.org/zh-cn/3/library/stdtypes.html#definition.__qualname__) 被设为特定位置以便 pickle 能够找到相应的类。 例如，类是否存在于全局作用域的 SomeData 类中:

\>>>

```
>>> Animal = Enum('Animal', 'ANT BEE CAT DOG', qualname='SomeData.Animal')
```

完整的签名为:

```
Enum(
    value='NewEnumName',
    names=<...>,
    *,
    module='...',
    qualname='...',
    type=<mixed-in class>,
    start=1,
    )
```

- *value*: 新枚举类将会作为其名称记录的值。

- *names*: 枚举的成员。 这可以是一个用空格或逗号分隔的字符串（值将从 1 开始除非另外指定）:

    ```
    'RED GREEN BLUE' | 'RED,GREEN,BLUE' | 'RED, GREEN, BLUE'
    ```

    或是一个名称的迭代器对象:

    ```
    ['RED', 'GREEN', 'BLUE']
    ```

    或是一个 (名称, 值) 对的迭代器对象:

    ```
    [('CYAN', 4), ('MAGENTA', 5), ('YELLOW', 6)]
    ```

    或是一个映射对象:

    ```
    {'CHARTREUSE': 7, 'SEA_GREEN': 11, 'ROSEMARY': 42}
    ```

- *module*: 新枚举类所在的模块名。

- *qualname*: 新枚举类在模块内的位置。

- *type*: 要混入到新枚举类的类型。

- *start*: 当只传入名称时要使用的起始计数编号。

*在 3.5 版本发生变更:* 增加了 *start* 形参。