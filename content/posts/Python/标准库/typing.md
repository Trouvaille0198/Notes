---
title: "Python typing 库"
date: 2022-09-28
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# typing

Python 运行时并不强制标注函数和变量类型。类型标注可被用于第三方工具，比如类型检查器、集成开发环境、静态检查器等。

自 python3.5 开始，PEP484 为 python 引入了类型注解 (type hints)，typing 的主要作用有：

1. 类型检查，防止运行时出现参数、返回值类型不符。
2. 作为开发文档附加说明，方便使用者调用时传入和返回参数类型。
3. 模块加入不会影响程序的运行不会报正式的错误，pycharm 支持 typing 检查错误时会出现黄色警告。

## 基本类型

### List

- 如 `List[str]`、`List[int]` 表示 list 中的元素类型
- 如 `List[obj]` 表示 list 中的元素为 class 对象
- 如 `List[str] = ["jerry"]` 表示 list 中元素为 str 且默认值为 `["jerry"]`

### Optional

- `Optional[X]` 等效于 `X | None` (或 `Union[X, None]`)
- 可选类型与含默认值的可选参数不同：含默认值的可选参数不需要在类型注解上添加 Optional 限定符，因为它仅是可选的

### Dict

- 如 `Dict[str, str]` 表示 dict 的 key 为 str，value 为 str
- 如 `Dict[str, int] = {'age': 20}` 表示 dict 的 key 为 str，value 为 int，默认值为 `{'age': 20}`

### Tuple

- `Tuple[X, Y]` 是二项元组类型，第一个元素的类型是 X，第二个元素的类型是 Y
- `Tuple[int, float, str]` 是由整数、浮点数、字符串组成的三项元组
- 空元组的类型可写为 `Tuple[()]`
- 可用**省略号**字面量指定同质变长元组，例如，`Tuple[int, ...]` 。`Tuple` 与 `Tuple[Any, ...]` 等价，也与 tuple 等价

### Union

- 如` Union[int]`，等效为 `int`
- 如 `Union[int, str]` 等效为 `int | str`，即 int or str

### Any

- 所有类型都与 `Any` 兼容，Any 与所有类型都兼容
- 可对 `Any` 类型的值执行任何操作或方法调用，并赋值给任意变量
- 使用 `Any`，说明值是动态类型

### 其他

Callable、Iterable、Iterator、Set 等

- 预期特定签名回调函数的框架可以用 `Callable[[Arg1Type, Arg2Type], ReturnType]` 实现类型提示
- 无需指定调用签名，用**省略号**字面量替换类型提示里的参数列表： `Callable[..., ReturnType]`，就可以声明可调对象的返回类型

## 省略号对象 Ellipsis

省略号 (`...`) 对象

```py
print(...)
print(type(...))

def foo():
    ...

try:
    1 / 0
except :
    ...

####### output #######
Ellipsis
<class 'ellipsis'>
```

### 应用

- Numpy 中的切片
- [FastAPI](https://fastapi.tiangolo.com/) 中的必选参数
- Type Hint 类型注解
    - 无需指定调用签名，用**省略号**字面量替换类型提示里的参数列表： `Callable[..., ReturnType]`，就可以声明可调对象的返回类型
    - 可用**省略号**字面量指定同质变长元组，例如，`Tuple[int, ...]` 。`Tuple` 与 `Tuple[Any, ...]` 等价，也与 `tuple` 等价

1. 在类型提示中使用 Callable，不确定参数签名时，可以用 Ellipsis 占位

```py
from typing import Callable
def foo() -> Callable[..., int]:
    return lambda x: 1
```

1. 使用 Tuple 时返回不定长的 tuple，用 Ellipsis 进行指定

```py
from typing import Tuple

def bar() -> Tuple[int, ...]:
    return (1, 2, 3)

def buzz() -> Tuple[int, ...]:
    return (1, 2, 3, 4)
```

## 可调对象 Callable

预期特定签名回调函数的框架可以用 `Callable[[Arg1Type, Arg2Type], ReturnType]` 实现类型提示。

例如：

```py
from collections.abc import Callable

def feeder(get_next_item: Callable[[], str]) -> None:
    # Body

def async_query(on_success: Callable[[int], None],
                on_error: Callable[[int, Exception], None]) -> None:
    # Body

async def on_update(value: str) -> None:
    # Body
callback: Callable[[str], Awaitable[None]] = on_update
```

无需指定调用签名，用省略号字面量替换类型提示里的参数列表： `Callable[..., ReturnType]`，就可以声明可调对象的返回类型。

## 别名和 NewType

### 类型别名

要定义一个类型别名，可以将一个类型赋给别名。

类型别名可用于简化复杂类型签名，在下面示例中，`Vector` 和 `list[float]` 将被视为可互换的同义词：

```python
Vector = list[float] 

def scale(scalar: float, vector: Vector) -> Vector: 

    return [scalar * num for num in vector] 

# typechecks; a list of floats qualifies as a Vector.

new_vector = scale(2.0, [1.0, -4.2, 5.4])
```

请注意，`None` 作为类型提示是一种特殊情况，并且由 `type(None)` 取代，这是因为 `None` 是一个存在于解释器中的单例对象。

### 2. NewType

使用 `NewType` 辅助函数创建不同的类型，静态类型检查器会将新类型视为它是原始类型的子类。

```python
from typing import NewType 

UserId = NewType('UserId', int) 

def get_user_name(user_id: UserId) -> str:
    ... 

# typechecks
user_a = get_user_name(UserId(42351)) 

# does not typecheck; an int is not a UserId 
user_b = get_user_name(-1) 
```

仍然可以对 `UserId` 类型的变量执行所有的 `int` 支持的操作，但结果将始终为 `int` 类型。这可以让你在需要 `int` 的地方传入 `UserId`，但会阻止你以无效的方式无意中创建 `UserId`:

```py
# 'output' is of type 'int', not 'UserId' 
output = UserId(23413) + UserId(54341) 
```

需要注意，这些检查**仅通过静态类型检查程序来强制**。

`NewType` 返回的是一个函数，该函数立即返回传递它的任意值；这就意味着 `UserId(1234)` 并不会创建一个新的类或引入任何超出常规函数调用的开销。

因此，运行过程中 `same_value is Newtype("TypeName", Base)(same_value)` 始终为 True。

但是，可以基于 `NewType` 创建 `NewType` 。

使用类型别名声明可以两种类型彼此等效。

- `Alias = Original` 将使静态类型检查对待所有情况下 `Alias` 完全等同于 `Original`。当您想简化复杂类型签名时，这很有用。

相反，`NewType` 也可以声明一种类型是另一种类型的子类型。

- `Derived = NewType('Derived', Original)` 将使静态类型检查器将 `Derived` 当作 `Original` 的子类 ，这意味着 `Original` 类型的值不能用于 `Derived` 类型的值需要的地方。当您想以最小的运行时间成本防止逻辑错误时，这非常有用。

## 基本支持类型

typing 模块最基本的支持由 `Any`，`Tuple`，`Callable`，`TypeVar` 和 `Generic`类型组成。

### 泛型集合类型

#### List

```py
class typing.List(*list, MutableSequence[T]*)
```

list 的泛型版本。用于注释返回类型。要注释参数，最好使用抽象集合类型，如 Sequence 或 Iterable。示例：

```py
T = TypeVar('T', int, float) 

def vec2(x: T, y: T) -> List[T]:

    return [x, y] 

def keep_positives(vector: Sequence[T]) -> List[T]:

    return [item for item in vector if item > 0]
```

#### Dict

```py
class typing.Dict(dict, MutableMapping[KT, VT])
```

dict 的泛型版本。对标注返回类型比较有用。如果要标注参数的话，使用如 Mapping 的抽象容器类型是更好的选择。示例：

```py
def count_words(text: str) -> Dict[str, int]: 
    ... 
```

类似的类型还有 `class typing.Set(set, MutableSet[T])`

### 抽象基类

```py
class typing.Iterable(Generic[T_co])
```

要注释函数参数中的迭代类型时，推荐使用的抽象集合类型。

```py
class typing.Sequence(Reversible[T_co], Collection[T_co])
```

要注释函数参数中的序列例如列表类型时，推荐使用的抽象集合类型。

```py
class typing.Mapping(Sized, Collection[KT], Generic[VT_co])
```

要注释函数参数中的Key-Value类型时，推荐使用的抽象集合类型。

### 泛型

#### TypeVar

类型变量。

需要注意的是 `TypeVar`不是一个类使用 `isinstance(x, T)` 会在运行时抛出 `TypeError` 异常。一般地说， `isinstance()` 和 `issubclass()` 不应该和类型变量一起使用。示例：

```py
T = TypeVar('T')  # Can be anything 

A = TypeVar('A', str, bytes)  # Must be str or bytes 

def repeat(x: T, n: int) -> Sequence[T]: 
		"""Return a list containing n references to x."""
    return [x]*n 

def longest(x: A, y: A) -> A: 
		"""Return the longest of two strings."""
    return x if len(x) >= len(y) else y 
```

#### AnyStr

```py
AnyStr = TypeVar('AnyStr', str, bytes)
```

AnyStr 是一个字符串和字节类型的特殊类型变量，它用于可以接受任何类型的字符串而不允许不同类型的字符串混合的函数。

```py
def concat(a: AnyStr, b: AnyStr) -> AnyStr: 
   return a + b 

concat(u"foo", u"bar") # Ok, output has type 'unicode'
concat(b"foo", b"bar") # Ok, output has type 'bytes'
concat(u"foo", b"bar") # Error, cannot mix unicode and bytes
```

#### Generic

泛型的抽象基类型，泛型类型通常通过继承具有一个或多个类型变量的该类的实例来声明。

- 泛型类型可以有任意数量的类型变量，并且类型变量可能会受到限制。
- 每个参数的类型变量必须是不同的。

```py
X = TypeVar('X') 
Y = TypeVar('Y') 

class Mapping(Generic[KT, VT]): 
   def __getitem__(self, key: KT) -> VT: ... 
    
def lookup_name(mapping: Mapping[X, Y], key: X, default: Y) -> Y:
   try:
       return mapping[key] 
   except KeyError: 
       return default
```

- 可以对 `Generic` 使用多重继承。

```py
from collections.abc import Sized 
from typing import TypeVar, Generic 

T = TypeVar('T') 

class LinkedList(Sized, Generic[T]): 
  	... 
```

- 从泛型类继承时，某些类型变量可能是固定的。

```py
from collections.abc import Mapping 
from typing import TypeVar 

T = TypeVar('T') 

class MyDict(Mapping[str, T]): 
  	... 
```

### 特殊类型

#### Any

特殊类型，表明类型没有任何限制。

- 每一个类型都对 `Any` 兼容。
- `Any` 对每一个类型都兼容。

`Any` 是一种特殊的类型。**静态类型检查器将所有类型视为与 `Any` 兼容，反之亦然， `Any` 也与所有类型相兼容。**

这意味着可对类型为 `Any` 的值执行任何操作或者方法调用并将其赋值给任意变量。

如下所示，将 `Any` 类型的值赋值给另一个更具体的类型时，Python 不会执行类型检查。例如，当把 `a` 赋值给 `s` 时，即使 `s` 被声明为 `str` 类型，在运行时接收到的是 `int` 值，静态类型检查器也不会报错

```py
from typing import Any 

a = None  # type: Any 
a = []  # OK 
a = 2 # OK 
s = ''  # type: str 
s = a # OK 

def foo(item: Any) -> int: 
   # Typechecks; 'item' could be any type, 
   # and that type might have a 'bar' method
   item.bar() 

   ... 
```

所有返回值无类型或形参无类型的函数将隐式地默认使用 `Any` 类型，如下所示 2 种写法等效。

```py
def legacy_parser(text): 
    ... 
    return data 

# A static type checker will treat the above
# as having the same signature as: 
def legacy_parser(text: Any) -> Any:
    ... 
    return data 
```

`Any` 和 `object` 的行为对比。与 `Any` 相似，所有的类型都是 `object` 的子类型。然而不同于 `Any`，反之并不成立：`object` 不是其他所有类型的子类型。

这意味着当一个值的类型是 `object` 的时候，类型检查器会拒绝对它的几乎所有的操作。把它赋值给一个指定了类型的变量（或者当作返回值）是一个类型错误。比如说，下述代码 `hash_a` 会被 IDE 标注不能从 `object` 找到 `magic` 的引用错误，而 hash_b 则不会：

```py
def hash_a(item: object) -> int: 
   # Fails; an object does not have a 'magic' method.  
   item.magic() 

def hash_b(item: Any) -> int: 
   # Typechecks 
   item.magic() 

# Typechecks, since ints and strs are subclasses of objecthash_a(42) 
hash_a("foo")  

# Typechecks, since Any is compatible with all typeshash_b(42) 
hash_b("foo") 
```

#### NoReturn

标记一个函数没有返回值的特殊类型。

```py
from typing import NoReturn 

def stop() -> NoReturn: 
    raise RuntimeError
```

### 特殊形式

#### Type

```py
class typing.Type(Generic[CT_co])
```

一个注解为 `C` 的变量可以接受一个类型为 `C` 的值。

相对地，一个注解为 `Type[C]` 的变量可以接受本身为类的值 。 更精确地说它接受 `C` 的类对象 ，例如：

```py
a = 3 # Has type 'int' 
b = int # Has type 'Type[int]' 
c = type(a) # Also has type 'Type[int]' 
```

注意 `Type[C]` 是协变的：

```py
class User: ... 

class BasicUser(User): ... 

class ProUser(User): ... 

class TeamUser(User): ... 

 # Accepts User, BasicUser, ProUser, TeamUser, ... 
def make_new_user(user_class: Type[User]) -> User: 
    # ... 
    return user_class()
```

#### Tuple

元组类型 `Tuple[X, Y]` 标注了一个二元组类型，其第一个元素的类型为 `X` 且第二个元素的类型为 `Y`。

空元组的类型可写作 `Tuple[()]`

为表达一个同类型元素的变长元组，使用省略号字面量，如 `Tuple[int, ...]`。单独的一个 `Tuple` 等价于 `Tuple[Any, ...]`，进而等价于 `tuple` 。

示例：`Tuple[int, float, str]` 表示一个由整数、浮点数和字符串组成的三元组。

#### Union

联合类型；`Union[X, Y]` 意味着：要么是 `X`，要么就是 `Y`。

定义一个联合类型，需要注意的有：

- 参数必须是类型，而且必须至少有一个参数。
- 能继承或者实例化一个联合类型。
- `Union[X, Y]` 不能写成 `Union[X][Y]` 。
- 可以使用 `Optional[X]` 作为 `Union[X, None]` 的缩写
- 联合类型的联合类型会被**展开打平**，比如

```py
Union[Union[int, str], float] == Union[int, str, float] 
```

- 仅有一个参数的联合类型会**坍缩成参数自身**，比如:

```py
Union[int] == int # The constructor actually returns int
```

- 多余的参数会被跳过，比如:

```py
Union[int, str, int] == Union[int, str]
```

- 在比较联合类型的时候，参数顺序会被忽略，比如:

```py
Union[int, str] == Union[str, int]
```

#### Optional

可选类型。`Optional[X]` 等价于 `Union[X, None]`。

```py
def sqrt(x: Union[int, float])->Optional[float]: 
    if x >= 0: 
        return math.sqrt(x) 
```

#### Callable

可调用类型；`Callable[[int], str]` 是一个函数，接受一个 `int` 参数，返回一个 `str`。

下标值的语法必须恰为两个值：参数列表和返回类型。

- 参数列表必须是一个类型和省略号组成的列表；
- 返回值必须是单一一个类型。

**不存在表示可选参数 / 关键词参数的语法**，这类函数类型罕见用于回调函数。

`Callable[..., ReturnType]`（使用字面省略号）能被用于提示一个可调用对象，接受任意数量的参数并且返回  `ReturnType`。

单独的 `Callable` 等价于 `Callable[..., Any]`，并且进而等价于 `collections.abc.Callable` 。