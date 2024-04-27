---
title: "Python typing 库"
date: 2022-09-28
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
date created: 24-04-10 09:58
date modified: 24-04-17 17:47
---

# typing

> 摘自：https://zhuanlan.zhihu.com/p/464979921

Type Hints 即类型提示，是 Python 在 3.5 版本中加入的语法，并在 Python 3.6 基本可用。在此后的版本中，Type Hints 的功能不断扩充，至今已经能够实现一个比较完善的静态类型系统。

正如名字展示的那样，Type Hints 是“类型提示”而不是“类型检查”，Python 并**不会**在程序运行时检查你所标注的类型，即使程序运行时某个变量的类型不符合你的标注值也不会报错。Type Hints 唯一的目的就是为了方便代码编辑器（或是其他开发工具）进行类型检查。

Python 的官方类型检查器是 MyPy（也需要通过 pip 安装），它能够对代码进行静态类型检查，但同样**不会**进行运行时类型检查。目前并没有成熟的方案可以实现 Python 的运行时类型检查，而且这也不是很有必要，完善的类型提示自然可以使代码无需运行时类型检查，况且运行时类型检查显然会拖慢 Python 的运行速度，这几乎是不可接受的。

不过，**通常情况下你不必单独安装静态类型检查器**，因为 IDE 及常见的代码编辑器都对 Python 的静态类型检查有一定的支持。例如 VSCode 默认使用微软自家开发的 Pyright 进行静态类型检查，而 PyCharm 默认使用其自带的 Code Inspection 进行静态类型检查。

Python 的本质仍是动态类型语言，**没有必要追求 100% 的类型提示**，这反而失去了动态类型的优势，陷入了思维定势中，就像在 Python 上强行套用 Java 的设计模式一样吃力不讨好。

如果你在使用 Type Hints 的过程中没有感受到任何便利，或是已经通过大量的单元测试确保了你的 Python 代码已经能覆盖大多数情况，那么就不需要使用 Type Hints，这理所应当。

## 基本类型

### Optional

- `Optional[X]` 等效于 `X | None` (或 `Union[X, None]`)
- 可选类型与含默认值的可选参数不同：含默认值的可选参数不需要在类型注解上添加 Optional 限定符，因为它仅是可选的

### Union

- 如 ` Union[int]`，等效为 `int`
- 如 `Union[int, str]` 等效为 `int | str`，即 int or str（`|` 语法在 3.10 之后可用）

### Any

- 所有类型都与 `Any` 兼容，Any 与所有类型都兼容
- 可对 `Any` 类型的值执行任何操作或方法调用，并赋值给任意变量
- 使用 `Any`，说明值是动态类型
- 对于静态类型检查器（例如 MyPy）来说，任何未标注类型的变量与返回值都被认为是 `Any` 类型。

标注 `Any` 的意义不是很大，因为这就相当于没有标注类型，无法使类型检查器发挥作用——除非你在使用严格模式的类型检查，这会要求你为函数中的每一个参数标上类型，而 `Any` 就往往是你在没有其他合适选择的情况下最无奈的那个选择。

### Type

用于注解一个类型，而非类的实例

```python
from typing import Type

class Animal:
    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        print("Woof!")

class Cat(Animal):
    def speak(self):
        print("Meow!")

def make_sound(animal_type: Type[Animal]):
    animal_instance = animal_type()
    animal_instance.speak()

make_sound(Dog)  # 输出: Woof!
make_sound(Cat)  # 输出: Meow!

```

### Collection 泛化容器

> 有时也将“Collection”翻译为“集合”，这里为了避免与“set”的通常译名“集”产生概念混淆，译为“容器”。

Python 中的大多数容器（`list`、`tuple`、`set` 等）都是异构（heterogeneous）的，例如 `list` 就可以包含很多不同类型的值。不过在多数情况下，当使用这些数据结构时，我们倾向于在其中存储同样类型的值。毕竟我们通常希望稍后将放入容器的对象取出进行一些操作，这通常意味着它们必须共享同一个方法。

在 Python 中，你可以这样表示一个容器中**只包含特定的值**

```python
from typing import List

def tokenize(text: str) -> List[str]:
    return text.upper().split()
```

容器类型不写后面的方括号也是可以的，例如 `list` 等同于 `list[Any]`.

#### Dict

- 如 `Dict[str, str]` 表示 dict 的 key 为 str，value 为 str
- 如 `Dict[str, int] = {'age': 20}` 表示 dict 的 key 为 str，value 为 int，默认值为 `{'age': 20}`

#### Tuple

- `Tuple[X, Y]` 是二项元组类型，第一个元素的类型是 X，第二个元素的类型是 Y
- `Tuple[int, float, str]` 是由整数、浮点数、字符串组成的三项元组
- 空元组的类型可写为 `Tuple[()]`
- 可用**省略号**字面量指定同质变长元组，例如，`Tuple[int, ...]` 。`Tuple` 与 `Tuple[Any, ...]` 等价，也与 tuple 等价

元组（Tuple）有三种用法：

- 用作记录（Record）
- 用作具名记录（Records with Named Fields）
- 用作不可变序列（Immutable Sequences）

##### 用作记录

将 Tuple 用作**记录**（Record）时，可以直接将几个类型分别包含在 `[]` 中。例如 `('Shanghai', 'China', 24.28)` 的类型就可以表示为 `tuple[str, float, str]`

##### 用作具名记录

将 Tuple 用作**具名记录**（Records with Named Fields）时，可以使用 `NamedTuple`：

```python
from typing import NamedTuple

class Coordinate(NamedTuple):
    latitude: float
    longitude: float

def city_name(lat_lon: Coordinate) -> str:
    ...
```

这里用到了具名元组，而这是很推荐使用的，它使得代码看起来更加清晰。由于 `NamedTuple` 是 `tuple` 的子类，因此 `NamedTuple` 与 `tuple` 也是相一致（consistent-with）的，这意味着可以放心地使用 `NamedTuple` 代替 `tuple`，例如这里的 `Coordinate` 也能表示 `tuple[float, float]`，反之则不行，比如 `tuple[float, float]` 就不能表示 `Coordinate`。

##### 用作不可变序列

将 Tuple 用作**不可变序列**（Immutable Sequences）时，需要使用 `...` 表示可变长度：

```python
tuple[int, ...]  # 表示 `int` 类型构成的元组
tuple[int]       # 表示只有一个 `int` 值的元组
```

值得注意的是，**如果省略方括号，`tuple` 等价于 `tuple[Any, ...]` 而非 `tuple[Any]`**。`tuple` 的 用法与 `list` 不同，这是需要注意的。

#### List

- 如 `List[str]`、`List[int]` 表示 list 中的元素类型
- 如 `List[obj]` 表示 list 中的元素为 class 对象
- 如 `List[str] = ["jerry"]` 表示 list 中元素为 str 且默认值为 `["jerry"]`

#### Sequence

另外，typing 中包含一个 `Sequence` 类型可以表示 Python 中的序列类型（`str`, `tuple`, `list`, `array` 等），同样支持方括号表示容器内值的类型。

```python
from typing import Sequence, Any

def get_length(seq: Sequence[Any]) -> int: ...
```

一般来说，对于函数及方法的形参，推荐优先使用 `Sequence` 而非 `list`，以获得更好的泛化性。

#### 使用内置关键字

自 Python 3.9 起，可以直接使用 `list`、`set` 等内置关键字直接表示 Python 内置的容器类型，而不需要再从 typing 中导入：

```python
def tokenize(text: str) -> list[str]:
    return text.upper().split()
```

> 事实上，Python 正考虑在未来（初步计划是 Python 3.14 中）删除对冗余类型 `typing.Tuple` 等类型的支持，因此应该优先使用新语法（`list`、`tuple`、`dict`）而非旧语法（`typing.List`、`typing.Tuple`、`typing.Dict`）

### Callable 可调用对象

在 Python 中，对高阶函数的操作是很常见的，因此经常需要使用函数作为参数。Type Hints 也提供了 `Callable[[ParamType1, ParamType2, ...], ReturnType]` 这样的语法表示一个可调用对象（例如函数和类）。`Callable` 常用于标注高阶函数的类型。例如：

```python
from typing import Sequence, Callable

def reduce_int_sequence(
    seq: Sequence[int],
    func: Callable[[int, int], int],
    initial: int | None = None
) -> int:
    if initial is None:
        initial = seq[0]
        seq = seq[1:]
    result = initial
    for item in seq:
        result = func(result, item)
    return result
```

如果你熟悉 TypeScript，可以将这里的 `Callable[[int, int], int]` 理解为 `(a: number, b: number) => number`，这或许更为直观。

又如：

```python
class Order:
    def __init__(
        self,  # `self` 通常不需要显式的类型提示
        customer: Customer,
        cart: Sequence[LineItem],
        promotion: Optional[Callable[['Order'], float]] = None,
    ) -> None:  # `__init__` 总是返回 `None`，因此也不需要类型提示，但标上一个 `None` 通常是推荐的
```

注意到这里的 Callable 使用了 `'Order'` 字符串而非 `Order`，这涉及到 Python 类定义的实现问题：在 Python 中，类是在读取完整个类之后才被定义的，因此在类体中无法通过直接引用类本身来表示它的类型。替代方法是使用一个和类同名的字符串，这被称为**自引用类型**。

遗憾的是，`Callable` 并不支持可选参数。如果需要使用动态参数，只能标注为 `Callable[..., ReturnType]`，无法明确标注可选参数的类型。

> 实际上，要标注回调函数的类型，你不一定要使用 `Callable`. 如果你需要标注更复杂的类型，可以使用后文会提到的 `Protocol`

### Literal 字面量

typing 库中的 `Literal` 是一个十分便利的语法，可以一定程度上替代枚举（Enum）类型。

```python
from typing import Literal

# 下面的代码定义了 `Fruit` 类型，它只能是 'apple', 'pear', 'banana' 三个字面量之一
Fruit = Literal['apple', 'pear', 'banana']
```

与枚举（Enum）相比，`Literal` 并没有实际提供任何约束（因为 Type Hints 本就不提供实际约束），只是编辑器会通过静态分析找出不符合 `Literal` 约束的地方并进行提示，但运行时是不会报错的，这点需要注意下。因此 `Literal` 不能完全替代枚举，但在一些要求不高的场合下还是很有价值的。

### LiteralString 字符串字面量

`LiteralString` 是 Python 3.11 加入的新特性，用于表示一个字符串字面量。

什么时候需要用到这一特性呢？`Literal` 难道不足以表示字面量吗？如果仅仅用于表示字符串，`str` 不也可以吗？

事实上，`LiteralString` 的推出是为了满足一些不太常用的安全性需求。例如在下面的例子中，我们使用了某个第三方库执行 SQL 语句，并将一些操作封装到了一个特定的函数中：

```python
def query_user(conn: Connection, user_id: str) -> User:
    query = f'SELECT * FROM data WHERE user_id = {user_id}'
    conn.execute(query)
```

这段代码看起来很好，但实际上却有着 SQL 注入的风险。例如用户可以通过下面的方式执行恶意代码：

```python
query_user(conn, 'user123; DROP TABLE data;')
```

目前一些 SQL API 提供了参数化查询方法，以提高安全性，例如 sqlite3 这个库：

```python
def query_user(conn: Connection, user_id: str) -> User:
    query = 'SELECT * FROM data WHERE user_id = ?'
    conn.execute(query, (user_id,))
```

然而目前 API 作者无法强制用户按照上面的用法使用，sqlite3 的文档也只能告诫读者不要从外部输入动态构建的 SQL 参数。于是在 Python 3.11 加入了 `LiteralString`，允许 API 作者直接通过类型系统表明他们的意图：

```python
from typing import LiteralString

def execute(self, sql: LiteralString, parameters: Iterable[str] = ...) -> Cursor: ...
```

现在，这里的 `sql` 参数就不能是通过外部输入构建的了。现在再定义上面的 `query_user` 函数，编辑器就会在静态分析后提示错误：

```python
def query_user(conn: Connection, user_id: str) -> User:
    query = f`SELECT * FROM data WHERE user_id = {user_id}`
    conn.execute(query)
    # Error: Expected LiteralString, got str.
```

而其他字符串可以正常工作：

```python
def query_data(conn: Connection, user_id: str, limit: bool) -> None:
    # `query` 是一个 `LiteralString`
    query = '''
        SELECT
            user.name,
            user.age
        FROM data
        WHERE user_id = ?
    '''

    if limit:
        # `query` 仍是 `LiteralString`，因为这里只是加上了另一个 `LiteralString`
        query += ' LIMIT 1'

    conn.execute(query, (user_id,))  # 不报错
```

看了这些，你可能会认为 `LiteralString` 在大部分情况下仍然没什么用。然而，不妨想想在其他领域 `LiteralString` 的用途，例如应用在命令行相关的 API 上防止命令注入，或是应用在 Django 这类采用模板生成 HTML 的框架上防止 XSS 注入，甚至用在 Jinja 这类可对字符串形式的 Python 表达式直接求值渲染的框架上防止模板注入……当然，还有经典的日志注入漏洞，也可以通过 `LiteralString` 提高安全性。

如果你当前使用的 Python 版本低于 Python 3.11，可以安装 Python 官方提供的 typing_extensions 扩展库来使用这一特性。

```python
from typing_extensions import LiteralString

def execute(self, sql: LiteralString, parameters: Iterable[str] = ...) -> Cursor: ...
```

### Self

在 Python 3.11 中，正式引入了 `Self` 类型，可以替代之前的**自引用类型**

```python
from typing import Self

class Rectangle:
    # ... 前面的代码省略 ...
    def stretch(self, factor: float) -> Self:
        return Rectangle(width=self.width * factor)
```

同样的，如果你想在低版本使用这一特性，可以安装 Python 官方提供的 `typing_extensions`typing_extension 扩展库。

```python
from typing_extensions import Self

class Rectangle:
    # ... 前面的代码省略 ...
    def stretch(self, factor: float) -> Self:
        return Rectangle(width=self.width * factor)
```

### 其他

Callable、Iterable、Iterator、Set 等

- 预期特定签名回调函数的框架可以用 `Callable[[Arg1Type, Arg2Type], ReturnType]` 实现类型提示
- 无需指定调用签名，用**省略号**字面量替换类型提示里的参数列表： `Callable[..., ReturnType]`，就可以声明可调对象的返回类型

## 位置参数与可变参数

Type Hints 自然也支持可变参数。

```python
from typing import Optional

def tag(
    name: str,
    /,
    *content: str,
    class_: Optional[str] = None,
    **attrs: str,
) -> str:
```

上面代码中的 `/` 表示 `/` 前面的参数**只能**通过位置指定，不能通过关键字指定。这是 Python 3.8 中新加入的特性。同样的，也可以使用 `*` 表示 `*` 后面的参数**只能**通过关键字指定，不能通过位置指定。这不是 Type Hints 范围内的知识，在这里提及只是作为补充，以免造成阅读时的困惑，在这里就不给出示例了。

> 在 Python 3.7 及之前的版本中，按照 PEP 484 中的约定，使用 `__` 前缀表示仅位置参数：

```python
from typing import Optional

def tag(__name: str, *content: str, class_: Optional[str] = None,
        **attrs: str) -> str:
```

这里对可变参数的类型提示很好理解。例如，`content` 的类型是 `tuple[str, ...]`，而 `attrs` 的类型则是 `dict[str, str]`. 如果把这里的 `**attrs: str` 改成 `**attrs: float` 的话，`attrs` 的实际类型就是 `dict[str, float]`.

## 省略号对象 Ellipsis

省略号 (`...`) 对象

```python
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

```python
from typing import Callable
def foo() -> Callable[..., int]:
    return lambda x: 1
```

1. 使用 Tuple 时返回不定长的 tuple，用 Ellipsis 进行指定

```python
from typing import Tuple

def bar() -> Tuple[int, ...]:
    return (1, 2, 3)

def buzz() -> Tuple[int, ...]:
    return (1, 2, 3, 4)
```

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

> 请注意，`None` 作为类型提示是一种特殊情况，并且由 `type(None)` 取代，这是因为 `None` 是一个存在于解释器中的单例对象。

在 Python 3.10 中，推荐使用新增的 `TypeAlias` 类型来显式表示类型别名的定义，这更加清晰。不过目前这样做没有什么特别的作用，只是让代码阅读起来更清晰一些。

```python
from typing import TypeAlias

Hexadecimal: TypeAlias = str | int

def hex_to_ascii_string(hex: Haxdecimal) -> str:
    ...
```

### NewType 子类型

类型别名很有用，但有时你可能更希望定义一个子类型，以更清晰地组织代码。你可以使用 `NewType` 来定义某个类型的子类型：

```python
from typing import NewType

UserId = NewType('UserId', int)
some_id = UserId(524313)
```

在上面的代码中，`UserId` 被定义为了 `int` 的子类型。因此若指定某个变量只能接受 `UserId` 类型，那么它就不能接受 `int` 类型：

```python
def get_user_name(user_id: UserId) -> str:
    ... 

# 类型检查通过
user_a = get_user_name(UserId(42351)) 

# 类型检查出错: `int` 不是 `UserId`
user_b = get_user_name(-1) 
```

自然，你也可以继续通过上面定义的 `UserId` 派生新的子类型：

```python
from typing import NewType

UserId = NewType('UserId', int)

ProUserId = NewType('ProUserId', UserId)
```

然而，通过 `NewType` 定义的子类型不是一个真正的“子类”，它无法通过 class 关键字进行继承：

```python
from typing import NewType

UserId = NewType('UserId', int)

# 运行时报错
class AdminUserId(UserId): pass
```

`NewType` 与类型别名的区别在于：类型别名只是一个“别名”，它本质上与定义该类型别名的类型相同；而 `NewType` 是一个子类型，若指定使用子类型，则不能使用父类型，正如上面展示的那样。

然而，值得注意的是通过 `NewType` 定义的子类型**可执行的操作仍与父类型完全相同**。例如即使上面定义了 `UserId` 类型，将两个 `UserId` 相加后得到的结果仍是 `int` 类型：

```python
# output是 `int` 类型，而非 `UserId` 类型
output = UserId(23413) + UserId(54341)
```

## 泛型

### TypeVar 参数化泛型

参数化泛型可以用类似 `list[T]` 这样的语法表示，其中的 `T` 表示一个每次使用时都会被绑定到某个特定类型的类型变量，这可以使参数的类型与返回值的类型一致。

下面是一个示例：

```python
from collections.abc import Sequence
from random import shuffle
from typing import TypeVar

T = TypeVar('T')

def sample(population: Sequence[T], size: int) -> list[T]:
    if size < 1:
        raise ValueError('size must be >= 1')
    result = list(population)
    shuffle(result)
    return result[:size]

# 假如通过下面的语法指定类型，那么population的类型与
# 返回值的类型就不一定是一致的，这就是使用泛型的原因
def sample(population: Sequence[int | str], size: int) -> list[int | str]: ...
```

`TypeVar` 的语法看上去有些累赘。如果你有使用其他语言的经验，就知道在 Java、C#、TypeScript 等语言中，可以直接通过前置 `<T>` 来简短地声明泛型，而在 Type Hints 中必须使用 `TypeVar` 才能表示泛型，这看起来很奇怪，也有些别扭。但这是不得已而为之，因为 Python 在引入 Type Hints 时不希望更改语言的其他语法。通过元编程技巧，可以巧妙地实现 `Sequence[T]` 这样的语法，但 `T` 必须要在其他地方定义，否则就需要深入修改 Python 的解释器。因此在 Type Hints 中声明泛型需要使用 `TypeVar` 构造函数，而在 Java、C#、TypeScript 等语言中则不需要。

> 简单来说，因为 Type Hints 不是也不应该是 Python 的核心，所以 Python 官方团队不希望为了引入泛型机制而大量修改 Python 解释器的核心代码，这会造成很多不必要的工作量，并且显然会减慢 Python 代码编译成字节码的速度，而且将对 Python 元编程的一些操作造成影响。
>
> 考虑到 Python 用户大多数并不很需要 Type Hints，需要用到泛型的用户就更少了，为了在 Type Hints 中引入泛型让他们付出这样巨大的代价显然是不符合 Python 理念的。于是最终决定通过 `TypeVar` 这样有些别扭的方式实现泛型，这也可以算是一种妥协了

当然，`TypeVar` 也支持**受限泛型**。

```python
from collections.abc import Iterable
from decimal import Decimal
from fractions import Fraction
from typing import TypeVar

NumberT = TypeVar('NumberT', float, Decimal, Fraction)

def mode(data: Iterable[NumberT]) -> NumberT:
    pairs = Counter(data).most_common(1)
    if len(pairs) == 0:
        raise ValueError('no mode for empty data')
    return pairs[0][0]
```

这里的 `mode` 函数是对 Python 中 `collections.mode` 的一个实现，用来返回序列中出现次数最多的数据。

此外可能也存在一些其他情况。例如这里不仅希望能支持 `float`、`Decimal`、`Fraction` 这几个类型，而希望支持所有合理的类型。既然代码里使用了 `Counter()`，就代表这里的 `data` 必然是可哈希的（因为 `Counter()` 的实现基于 `dict`，而 `dict` 中的键必然是可哈希的）。因此这里的“合理类型”就是一个可哈希的类型，我们通过使用 `bound=Hashable` 来表示一个泛型是可哈希的，用 `Hashable` 表示类型实现了 `__hash__` 方法。

```python
from collections.abc import Hashable
from decimal import Decimal
from fractions import Fraction
from typing import TypeVar

HashableT = TypeVar('NumberT', bound=Hashable)

def mode(data: Iterable[HashableT]) -> HashableT:
    pairs = Counter(data).most_common(1)
    if len(pairs) == 0:
        raise ValueError('no mode for empty data')
    return pairs[0][0]
```

需要注意的是，这里的 `bound` 表示 `boundary`（边界），和 `bind` 无关。这里定义的 `TypeVar` 则被称为**有界泛型**，表示泛型的“下限”，这里表示的“下限”就是该泛型至少要是可哈希的（Hashable）。

此外，`typing` 库中还提供了一个常用泛型 `AnyStr`，等价于 `TypeVar('AnyStr', bytes, str)`。

### TypeVarTuple 参数化泛型元组

还记得 typing 中的 `Tuple` 和 `Union` 吗？它们可以接收任意多个参数化泛型：

```python
from typing import Tuple, Union, TypeAlias

ColorRGB: TypeAlias = Tuple[int, int, int]
Hexidecimal: TypeAlias = Union[int, str]
```

在 Python 3.11 中，加入了泛型元组（TypeVarTuple），使得实现类似于 `Tuple`、`Union` 这种可接收不定长参数化泛型的类型成为可能。

假设一下，在过去的版本中，我们想要实现一个自定义类型 `Array`，它可以像下面这样使用：

```python
def to_gray(videos: Array[Time, Batch, Height, Width, Channels]): ...
```

然而在过去，仅有 typing 中的一些内置类型，例如 `Tuple` 能够实现这样的功能。我们曾经只能妥协地将其写为：

```python
def to_gray(videos: Array): ...
```

很明显，这样很不清晰。于是 Python 3.11 加入了 `TypeVarTuple`：

```python
from typing import TypeVar, TypeVarTuple

DType = TypeVar('DType')
Shape = TypeVarTuple('Shape')

class Array(Generic[DType, *Shape]):

    def __abs__(self) -> Array[DType, *Shape]: ...

    def __add__(self, other: Array[DType, *Shape]) -> Array[DType, *Shape]: ...
```

现在我们就可以优雅地使用 `Array` 了：

```python
from typing import NewType

Height = NewType('Height', int)
Width = NewType('Width', int)

x: Array[float, Height, Width] = Array()
```

你当然也可以直接在类型中注释 `Array` 的大小：

```python
from typing import Literal as L

x: Array[float, L[480], L[640]] = Array()
```

同样的，如果你希望在低版本应用这一特性，可以考虑安装 typing_extensions `typing_extensions` 库。

### 更简洁的参数化泛型语法

当你写多了 `TypeVar` 之后，你一定会认为这是一个非常累赘的语法。如果你有过其他支持泛型的编程语言的编程经验的话，一定会开始怀念在那里定义个泛型是多么轻松。

虽然上面提到 Python 使用 `TypeVar` 是不得已而为之，有种种考量。但现在 Python 官方也意识到到处都写个 `TypeVar` 确实太傻了。在 Python 3.12 中，正式引入了更简单的参数化泛型语法，现在你可以这么写了：

```python
def max[T](args: Iterable[T]) -> T:
    ...

class list[T]:
    def __getitem__(self, index: int, /) -> T:
        ...

    def append(self, element: T) -> None:
        ...
```

简直和你在其他编程语言中的体验一模一样不是吗？只是把尖括号换成了方括号而已。并且如果你有过 Go、Scala 这些编程语言的经验，应该会反而对这个方括号更加熟悉。

同时，这种更简便的语法也可以在类型别名中使用。现在类型别名有了更新更合适的语法：

```python
type Point[T] = tuple[T, T]

type IntFunc[**P] = Callable[P, int]  # ParamSpec
type LabeledTuple[*Ts] = tuple[str, *Ts]  # TypeVarTuple
type HashableSequence[T: Hashable] = Sequence[T]  # TypeVar with bound
type IntOrStrSequence[T: (int, str)] = Sequence[T]  # TypeVar with constraints
```

——如你所见，这看起来简直和 TypeScrpt 一模一样。然后，正如你的直觉一样，你可以在这里用 `*Ts` 表示可变参数（TypeVarTuple），用 `**P` 表示关键字参数（ParamSpec），用 `:` 表示有界泛型（有点像 Java 中的 extends，如果你熟悉 Java 的话）和受限泛型——只不过这些“可变参数”、“关键字参数”都在类型上。

### Generic Class 泛化类

Type Hints 中的泛型除了支持参数化泛型外，还支持泛化类，例如：

```python
from typing import TypeVar, Generic, Optional

T = TypeVar('T')

class Node(Generic[T]):
    def __init__(self, data: T, next: Optional['Node[T]']):
        self._data = data
        self._next = next

    @property
    def data(self) -> T:
        return self._data

    @property
    def next(self) -> 'Node[T]':
        return self._next
```

需要注意的是，这里的 `Generic[T]` 需要在最后继承。如果这里的 `Node` 类继承了其他父类，那么需要将其他继承放在前面。

在自定义泛化类后，就可以使用 `Node[...]` 这样的语法为自定义的泛化类绑定类型了，例如 `Node[int]`、`Node[str]`.

```python
from typing import TypeVar, Generic

T = TypeVar('T')  # 定义一个类型变量

class Box(Generic[T]):
    def __init__(self, item: T) -> None:
        self.item = item

    def get_item(self) -> T:
        return self.item

# 使用 Box 类
box_int = Box(123)
# 这样也可以👇
box_int = Box[int](123)
print(box_int.get_item())  # 输出: 123

box_str = Box("Hello")
print(box_str.get_item())  # 输出: Hello
```

## 进阶用法

### Protocol 协议

协议（Protocol）是 Python 3.8 中新加入的语法，可以更好地实现 Type Hints，例如接口。`Protocol` 实际上是一种静态的鸭子类型，和 Go 或 TypeScript 中的 `interface` 非常相似。

假设现在有一个函数 `top`，接收一个可迭代对象和长度 `n`，返回可迭代对象中最大的 `n` 个值：

```python
def top(series: Iterable[T], length: int) -> list[T]:
    ordered = sorted(series, reverse=True)
    return ordered[:length]
```

现在的问题在于，这里的 `T` 必须可以使用 `sorted()` 排序。你可能会希望 collections.abc 中存在一个名为 `Sortable` 的抽象类型表示某个类型是可排序的，然而很遗憾并不存在这样一个类型。

不过，你可以通过 `Protocol` 创建自己的抽象基础类型。要创建一个类型表示其支持通过 `sorted()` 排序，就要知道 Python 中的 `sorted()` 函数是如何实现的：它使用 `__lt__` 魔术方法比较两个值的大小进行排序。因此如果某个类型要支持 `sorted()`，那么只需要其实现了魔术方法 `__lt__`。

自 Python 3.8 起，可以使用 `Protocol` 表示这样一个类型：

```python
from collections.abc import Iterable
from typing import Protocol, Any, TypeVar

class SupportsLessThan(Protocol):
    def __lt__(self, other: Any) -> bool: ...

LT = TypeVar('LT', bound=SupportsLessThan)

def top(series: Iterable[LT], length: int) -> list[LT]:
    ordered = sorted(series, reverse=True)
    return ordered[:length]
```

相比于 `abc.ABC`（Python 内置的抽象类，这里不过多说明），使用 `Protocol` 的好处是它只关注实现，而不关注继承关系。例如，这里不再需要使用 `SupportsLessThan` 重新派生 `str`、`tuple`、`float`、`set` 等内置类也可以在需要使用 `SupportsLessThan` 参数的地方使用它，唯一的要求只是这一类型必须实现 `__lt__` 方法而已。

### Parameter Specification Variable

> 参数规范变量

正如 1.9 节提到的，我们目前已知有两种方法定义函数类型，一种简单使用 Callable，一种结合 Protocol 和 `__call__` 方法。但是，这两种方法似乎都不能很好地与泛型相结合。也就是说，我们无法将 `Callable` 的参数类型“传递”给另外一个类型。而这在装饰器中实际上是一个比较常见的需求。

考虑这段代码：

```python
from typing import Awaitable, Callable, TypeVar

R = TypeVar('R')

def add_logging(f: Callable[..., R]) -> Callable[..., Awaitable[R]]:
    async def inner(*args: object, **kwargs: object) -> R:
        await log_to_database()
        return f(*args, **kwargs)
    return inner

@add_logging
def takes_int_str(x: int, y: str) -> int:
    return x + 7

await takes_int_str(1, 'A')
await takes_int_str('B', 2)  # Fails at runtime
```

在这里，`f` 的参数类型应当与 `inner` 是一致的。然而由于 `Callable` 自身的限制，我们只能简单使用 `...` 来忽略对参数类型的标注。

而在 Python 3.10 中，引入了 `ParamSpec`，这使得对此类情况的类型标注成为可能：

```python
from typing import Awaitable, Callable, ParamSpec, TypeVar

P = ParamSpec('P')
R = TypeVar('R')

def add_logging(f: Callable[P, R]) -> Callable[P, Awaitable[R]]:
    async def inner(*args: P.args, **kwargs: P.kwargs) -> R:
        await log_to_database()
        return f(*args, **kwargs)
    return inner

@add_logging
def takes_int_str(x: int, y: str) -> int:
   return x + 7

await takes_int_str(1, 'A')  # Accepted
await takes_int_str('B', 2)  # Correctly rejected by the type checker
```

另一种常见情况是，高阶函数（或可调用对象）的返回值往往依赖于传入的某个函数。它们常常添加、移除或修改另一个函数的参数。因此，随着 `ParamSpec` 的引入，也同样引入了一个 `Concatenate`，它与 `Callable` 和 `ParamSpec` 结合使用。

`Concatenate` 目前只有作为 `Callable` 的第一个参数时有效。`Concatenate` 的最后一个参数必须是 `ParamSpec` 或 `...`.

下面是一个 Python 文档中的例子，展示了如何注解一个装饰器 `with_lock`，它为被装饰的函数提供了一个 `threading.Lock`，可以使用 `Concatenate` 来表示 `with_lock` 期望一个接受 `Lock` 作为第一个参数的可调用对象，并返回一个具有不同类型签名的可调用对象。在这种情况下，`ParamSpec` 表示返回的可调用对象的参数类型取决于传入的可调用对象的参数类型。

```python
from collections.abc import Callable
from threading import Lock
from typing import Concatenate, ParamSpec, TypeVar

P = ParamSpec('P')
R = TypeVar('R')

# Use this lock to ensure that only one thread is executing a function
# at any time.
my_lock = Lock()

def with_lock(f: Callable[Concatenate[Lock, P], R]) -> Callable[P, R]:
    """A type-safe decorator which provides a lock."""
    def inner(*args: P.args, **kwargs: P.kwargs) -> R:
        # Provide the lock as the first argument.
        return f(my_lock, *args, **kwargs)
    return inner

@with_lock
def sum_threadsafe(lock: Lock, numbers: list[float]) -> float:
    """Add a list of numbers together in a thread-safe manner."""
    with lock:
        return sum(numbers)

# We don't need to pass in the lock ourselves thanks to the decorator.
sum_threadsafe([1.1, 2.2, 3.3])
```

### @overload 函数重载签名

用于为重载的函数提供类型标注

```python
def double(input_: int | list[int]) -> int | list[int]:
    if isinstance(input_, list):
        return [i * 2 for i in input_]
    return input_ * 2
```

这样的函数并不能很好地捕捉到参数和返回值之间的关系，如果我要做到以下要求：

- 如果 `input_` 是一个 `int` ，返回值是一个 `int` 。
- 如果 `input_` 是一个 `list[int]` ，那么返回值也是一个 `list[int]` 。

那就需要用到 `typing.overload` 来装饰这个函数

```python
from typing import overload


@overload
def double(input_: int) -> int:
    ...


@overload
def double(input_: list[int]) -> list[int]:
    ...


def double(input_: int | list[int]) -> int | list[int]:
    if isinstance(input_, list):
        return [i * 2 for i in input_]
    return input_ * 2
```

也就是使用 overload 来声明所有允许的类型组合，最后再具体实现这个函数

当 mypy 检查文件时，它收集了 `@overload` 定义作为类型提示。然后它使用第一个非 `@overload` 定义作为实现。所有 `@overload` 定义必须在实现之前，不允许有多个实现。

当 Python 导入文件时，`@overload` 定义会创建临时的 `double` 函数，但每个定义都会被下一个定义覆盖。在导入后，只有实现存在。作为防止意外丢失实现的保护措施，试图调用 `@overload` 定义会引发 `NotImplementedError` 。

有了我们的类型关系描述，让我们检查一下*两种*输入类型的返回类型。

```python
x = double(12)
reveal_type(x)

y = double([1, 2])
reveal_type(y)
```

Mypy 说。

```console
$ mypy example.py
example.py:23: note: Revealed type is 'builtins.int'
example.py:26: note: Revealed type is 'builtins.list[builtins.int]'
```

很好！返回类型与输入类型相匹配，正如我们所希望的那样。现在可以对 `double()` 的任何调用者进行准确的类型检查，不需要任何额外的缩小。

### Type Casting 强制类型转换

静态类型检查器有时不能完全理解发生了什么，因此会报告一些不必要的错误。强制类型转换（Type Casting）就是用来消除这些不必要的错误的。需要注意的是，这里的强制类型转换（Type Casting）并不是真正意义上地转换了变量的类型，它只是为静态类型检查器提供了提示。下面是 `typing.cast` 的代码实现：

```python
def cast(typ, val):
    """将一个值转换为某个类型.
    该函数会原样返回值。对于类型检查器来说，这是一个标志，
    表示返回值已经被转换成了指定的类型。但在运行时，我们
    希望该函数不会进行任何类型检查（因为我们希望这个函数
    能够尽可能快）
    """
    return val
```

下面是一个例子

```python
from typing import cast

def find_first_str(a: list[object]) -> str:
    index = next(i for i, x in enumerate(a) if isinstance(x, str))
    # 如果上面的代码没有引发异常，这个函数应该始终返回 str
    # 但是由于上面 a 的类型被标注为了 list[object]， 因此静态
    # 类型检查器会认为返回值的类型为 object，因此我们需要使
    # 用 cast 来帮助静态类型检查器理解这里的代码
    return cast(str, a[index])
```

显然不应该过多地使用 `cast`，因为静态类型检查器通常是正确的，只在极少数情况下无法理解代码的含义。如果发现自己在过多地使用 `cast`，那么你可能并没有在以正确的方式使用 Type Hints.

> 实话实说，如果你真开了严格类型检查模式，你会发现你需要大量使用 `cast`，这是因为大多数 Python 库都没有包含完备的类型定义……所以这东西可以说是相当实用了……

## Variant 型变

一般来说，只有代码库作者需要对这部分有比较深入的了解，所以如果你第一次看不懂，也没关系。或者如果你不打算为 Python 编写什么代码库，那么直接跳过也无妨。

小总结，在 Type Hint 中：

1. 泛型类是不变的
2. 函数参数是逆变的
3. 函数返回值是协变的

### Invariant 不变

我们知道，由于子类型（Sub Type）的存在，编写这样的代码是不会被类型检查器查出问题的：

```python
class Beverage:
    """任何饮料"""

class Juice(Beverage):
    """任何果汁"""

class OrangeJuice(Juice):
    """橙汁"""

juice1: Juice = Juice()  # OK
juice2: Juice = OrangeJuice()  # OK
```

而这样的代码是会报错的：

```python
juice3: Juice = Beverage()  # Error
```

显然，这符合我们的预期和直觉。

**但参数化泛型却不遵从这样的规律。**假设现在我们有一个饮料贩卖机类：

```python
T = TypeVar('T')

class BeverageDispenser(Generic[T]):
    """饮料贩卖机"""
    def __init__(self, beverage: T) -> None:
        self.beverage = beverage
    
    def dispense(self) -> T:
        return self.beverage
```

然后我们有一个 `install` 函数，用于安装一台饮料贩卖机。因为某些原因，这台机器只能贩卖果汁：

```python
def install_dispenser(dispenser: BeverageDispenser[Juice]) -> None:
    """安装果汁贩卖机"""
    ...
```

显然，这样的代码是有效的：

```python
juice_dispenser = BeverageDispenser(Juice())
install_dispenser(juice_dispenser)
```

理应如此。毕竟我们定义时就明确了 `install_dispenser` 只能安装果汁贩卖机。

按照你的直觉，你推断出下面这样的代码会报错，因为 `Beverage` 是 `Juice` 的父类型，而 `install_dispenser` 只能安装果汁贩卖机。

```python
beverage_dispenser = BeverageDispenser(Beverage())
install_dispenser(beverage_dispenser)
```

当然，事实也的确如此：

![img](https://pic1.zhimg.com/80/v2-f4fb509fe3e93116083ec114da5d9bf4_1440w.webp)

不过，怪异的事情来了。实际上，`install_dispenser` 也不能安装橙汁贩卖机，尽管 `OrangeJuice` 是 `Juice` 的子类：

```python
orange_juice_dispenser = BeverageDispenser(OrangeJuice())
install_dispenser(orange_juice_dispenser)
```

![img](https://pic3.zhimg.com/80/v2-1ad2a852a1f605533feab82769d609fe_1440w.webp)

这就是所谓的“不变 (Invariant)”。在 Python 中，参数化泛型默认都是“不变”的，也就是说该容器**只能包含某个精确的类型，而不能包含该类型的任何父类或子类。**

同理，`list`、`set` 等 Python 内置的**可变**容器类型也是不变的。

![img](https://pic3.zhimg.com/80/v2-a73e1172841bce87dbeef4bc8448e806_1440w.webp)

可以看到，`list[OrangeJuice]` 也不能赋值给 `list[Juice]`.

你可能会困惑于为什么要这么设计——似乎这并不十分符合直觉。

考虑下面这段代码：

```python
class Animal:
    ...

class Dog(Animal):
    ...

class Cat(Animal):
    ...

def add_animal(animal_list: list[Animal]):
    animal_list.append(Cat())
```

现在，让我们假设 `list[Dog]` 可以是 `list[Animal]` 的子类，也就是说现在 `list` 不再是“不变（Invariant）”的，而是自动将子类型关系传递了下来，这就是我们之后会谈到的“协变（Covariant）”。不过，在这里我们暂时不关心具体什么是“协变”，你只需要有这个直觉就可以了。

然后，考虑这段代码：

```python
dogs: list[Dog] = [Dog(), Dog()]
add_animal(dogs)
```

如果 `list[Dog]` 确实被认为是 `list[Animal]` 的子类，那么这段代码不会报错——`add_animal` 期望接受一个 `list[Animal]`，由于 `list[Dog]` 是 `list[Animal]` 的子类，因此这是合理的。但是我们看到，现在我们意外地向一个原本只应该包含狗的列表中加入了一只猫——这显然不是我们期望的。

因此，参数化泛型被设计为是不变的，以防止这种意外情况的出现。例如在 VSCode 中，上面的代码就会报错：

![img](https://pic2.zhimg.com/80/v2-732e2d01e9c9835d1a1a3f4d62f4441d_1440w.webp)

正如 MyPy 给我们的提示所述——`Sequence` 类型实际上不是逆变而是协变的，这是它和 `list`、`set` 这些类型的一个重要差异。

### Covariant 协变

在上一节最后的例子中，你应该已经能通过直觉朴素地感知到什么是“协变（Covariant）”了。现在，让我们改造一下上面的饮料贩卖机，让它更灵活些，能够贩卖橙汁：

```python
T_co = TypeVar('T_co', covariant=True)

class BeverageDispenser(Generic[T_co]):
    """饮料贩卖机"""
    def __init__(self, beverage: T_co) -> None:
        self.beverage = beverage
    
    def dispense(self) -> T_co:
        return self.beverage

def install_dispenser(dispenser: BeverageDispenser[Juice]) -> None:
    """安装果汁贩卖机"""
    ...
```

实际上这里只是在定义泛型 `T` 时加上了一个 `covariant=True`，这表示 `T` 现在是协变的。

*在这里，`T_co` 是一种约定，表明这是协变的类型参数。*

现在，我们看到 `BeverageDispenser[OrangeJuice]` 就被认为是 `BeverageDispenser[Juice]` 的子类了：

![img](https://pic1.zhimg.com/80/v2-0fea859416910c1be400eaa2e3fe8ae8_1440w.webp)

不过，同样的，`install_dispenser` 还是没法安装通用的饮料贩卖机，这符合我们的预期。

### Contravariant 逆变

有“协变（Covariant）”，自然也有“逆变（Contravariant）”。正如字面意思所述，假设存在逆变类型 `C`，如果 `A` 是 `B` 的子类，那么 `C[B]` 是 `C[A]` 的子类，恰好与协变反着来。

你可能会疑惑在什么情况下需要“逆变”。事实上，函数参数就是一个典型的“逆变”例子。首先，让我们假设函数参数是协变的，看看会有什么后果。

考虑下面这段代码：

```python
class Food:
    ...

class Chocolate(Food):
    ...

class DogFood(Food):
    ...

class Animal:
    def eat_food(self, food: Food) -> None:
        ...

class Dog(Animal):
    def eat_food(self, food: DogFood) -> None:
        ...
```

当然，这段代码实际上是会类型报错的，因为函数参数实际上是逆变的：

![img](https://pic2.zhimg.com/80/v2-d2430ccac5afed3d872c6cc44fda2669_1440w.webp)

不过，在这里我们不妨假设如果这段代码成立，会有什么后果：

```python
food: Food = Chocolate()
animals: list[Animal] = [Animal(), Dog()]
for animal in animals:
    animal.eat_food(food)
```

可以看到，在这个例子中，狗意外地食用了巧克力，而狗吃巧克力是会中毒的！但在这里，`Dog()` 由于在 `animals` 数组中，它的类型被推断为 `Animal`，这没有什么问题。然后，我们调用 `animal.eat_food`，这里传入一个 `Food`，这符合该方法的定义，也没有什么问题。但是，意外还是发生了。

这段代码在 VSCode 中会这样报错：

![img](https://pic3.zhimg.com/80/v2-5b451e05d392f4e400b1b3850eb703da_1440w.webp)

因此，我们意识到函数参数显然不能是协变的。那么，“逆变”体现在哪里呢？

让我们考虑下面这段代码：

```python
class Food:
    ...

class Pie(Food):
    def cook(self, callback: Callable[['Pie'], None]) -> None:
        ...
```

在这里，`Pie` 继承了 `Food`，并且有一个 `cook` 方法，它接受一个回调函数，表示如何烹饪这个派。

> 这里使用字符串 `'Pie'` 而不是直接使用 `Pie` 涉及到 Python 的自引用问题

显然，这样的代码是行得通的：

```python
def cook_pie(pie: Pie) -> None:
    ...

pie = Pie()
pie.cook(cook_pie)
```

但是，如果我们有一个通用的 `cook_food` 函数呢？显然，`cook_food` 也能够烹饪派，那么也应该可以将 `cook_food` 函数作为回调传入 `Pie.cook` 中：

```python
def cook_food(food: Food) -> None:
    ...

pie = Pie()
pie.cook(cook_food)
```

在 VSCode 中，这段代码并不会报错：

![img](https://pic2.zhimg.com/80/v2-bd26b061bf6c7b5fb5823a8f26fcfd61_1440w.webp)

显然，这也符合我们的预期。

我们看到，在上面这个例子中，`Callable[[Food], None]` 被认为是 `Callable[[Pie], None]` 的子类型，而 `Pie` 反而是 `Food` 的子类型。因此，我们看到，**函数参数应当是“逆变”的**。

在此稍微再扩展一点，函数的返回值应该是哪种型变呢？答案是**函数返回值应当是协变的**。这应该不难想到，你可以自己举些例子理解一下。

在函数参数外，逆变的例子似乎不像协变那么多。不过，在这里也可以举一个使用逆变的例子。

考虑一下，假设现在要对食堂垃圾桶建模，它为了环保考虑，它必须存放可生物降解的废弃物。我们对其建模如下：

```python
class Refuse:
    """任何废弃物"""

class Biodegradable(Refuse):
    """可生物降解的废弃物"""

class Compostable(Biodegradable):
    """可制成肥料的废弃物"""

T_contra = TypeVar('T_contra', contravariant=True)

class TrashCan(Generic[T_contra]):
    def put(self, refuse: T_contra) -> None:
        """在倾倒之前存放垃圾"""

def deploy(trash_can: TrashCan[Biodegradable]):
    """放置一个垃圾桶，存放可生物降解的废弃物"""
```

在这里，`deploy` 除了可以放置 `TrashCan[Biodegradable]` 外，应当还能放置 `TrashCan[Refuse]`，因为它可以存放任何废弃物，包括可生物降解的废弃物，不能是 `TrashCan[Compostable]`，因为它只能存放可制成肥料的废弃物，无法处理所有可生物降解的废弃物。

*同理，这里的 `T_contra` 也只是一种约定，表明这是逆变的类型参数。*

这是在 VSCode 中的结果：

![img](https://pic2.zhimg.com/80/v2-89722027c483bd9615f2e9efeb76b77d_1440w.webp)

显然，这符合我们的预期。

### 型变总结

在这里，让我们严谨一些，以更形式化的语言来描述这些型变。

<img src="C:\Users\chenx\AppData\Roaming\Typora\typora-user-images\image-20231220165757749.png" alt="image-20231220165757749" style="zoom:50%;" />

根据一些经验，我们可以推知某些类型的具体型变种类：

- 泛型最好是不变的，以避免可能的意外情况出现。
- 如果某泛型定义的是从对象中**获取**的数据类型，那么它可能是**协变**的。例如 `frozenset` 等只读容器是协变的。另外，`Iterator` 也是协变的，因为它只会产生输出。同理，函数的返回值类型也是协变的。
- 如果某泛型定义的是对象初始化后向对象中**输入**的数据类型，那么它可能是**逆变**的。例如上文提到的 `TrashCan` 这种只写的数据结构。另外，`Generator` 等也有一个可逆变的类型参数。同理，函数参数也是逆变的。
- 如果某泛型定义的是从对象中**获取**的数据类型，同时也是向对象中**输入**的数据类型，那么它必定是**不变**的。例如 Python 中的可变容器都是不变的。

> 实际上，除了不变、协变和逆变外，还有一种“双变（bivariance）”，意味着既是协变的也是逆变的。
>
> 上面提到只读类型可以是协变的，只写类型可以是逆变的，那么可以推断不可读不可写类型应当可以是双变的，比如一个多余的未被使用的函数参数。
>
> 然而，一个“不可读不可写”的数据结构显然是非常罕见的，而双变也常常导致运行时类型错误，因此在大多数编程语言中双变都几乎未被支持，也包括 Python 的 Type Hints. 除非有明确需要，否则我们也应当尽可能避免对双变的使用。

## （重复）基本支持类型

typing 模块最基本的支持由 `Any`，`Tuple`，`Callable`，`TypeVar` 和 `Generic` 类型组成。

### 泛型集合类型

#### List

```python
class typing.List(*list, MutableSequence[T]*)
```

list 的泛型版本。用于注释返回类型。要注释参数，最好使用抽象集合类型，如 Sequence 或 Iterable。示例：

```python
T = TypeVar('T', int, float) 

def vec2(x: T, y: T) -> List[T]:

    return [x, y] 

def keep_positives(vector: Sequence[T]) -> List[T]:

    return [item for item in vector if item > 0]
```

#### Dict

```python
class typing.Dict(dict, MutableMapping[KT, VT])
```

dict 的泛型版本。对标注返回类型比较有用。如果要标注参数的话，使用如 Mapping 的抽象容器类型是更好的选择。示例：

```python
def count_words(text: str) -> Dict[str, int]: 
    ... 
```

类似的类型还有 `class typing.Set(set, MutableSet[T])`

### 抽象基类

```python
class typing.Iterable(Generic[T_co])
```

要注释函数参数中的迭代类型时，推荐使用的抽象集合类型。

```python
class typing.Sequence(Reversible[T_co], Collection[T_co])
```

要注释函数参数中的序列例如列表类型时，推荐使用的抽象集合类型。

```python
class typing.Mapping(Sized, Collection[KT], Generic[VT_co])
```

要注释函数参数中的 Key-Value 类型时，推荐使用的抽象集合类型。

### 泛型

#### TypeVar

类型变量。

需要注意的是，`TypeVar` 不是一个类，使用 `isinstance(x, T)` 会在运行时抛出 `TypeError` 异常。一般地说， `isinstance()` 和 `issubclass()` 不应该和类型变量一起使用。示例：

```python
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

```python
AnyStr = TypeVar('AnyStr', str, bytes)
```

AnyStr 是一个字符串和字节类型的特殊类型变量，它用于可以接受任何类型的字符串而不允许不同类型的字符串混合的函数。

```python
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

```python
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

```python
from collections.abc import Sized 
from typing import TypeVar, Generic 

T = TypeVar('T') 

class LinkedList(Sized, Generic[T]): 
  	... 
```

- 从泛型类继承时，某些类型变量可能是固定的。

```python
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

```python
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

```python
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

```python
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

```python
from typing import NoReturn 

def stop() -> NoReturn: 
    raise RuntimeError
```

### 特殊形式

#### Type

```python
class typing.Type(Generic[CT_co])
```

一个注解为 `C` 的变量可以接受一个类型为 `C` 的值。

相对地，一个注解为 `Type[C]` 的变量可以接受本身为类的值 。 更精确地说它接受 `C` 的类对象 ，例如：

```python
a = 3 # Has type 'int' 
b = int # Has type 'Type[int]' 
c = type(a) # Also has type 'Type[int]' 
```

注意 `Type[C]` 是协变的：

```python
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

```python
Union[Union[int, str], float] == Union[int, str, float] 
```

- 仅有一个参数的联合类型会**坍缩成参数自身**，比如:

```python
Union[int] == int # The constructor actually returns int
```

- 多余的参数会被跳过，比如:

```python
Union[int, str, int] == Union[int, str]
```

- 在比较联合类型的时候，参数顺序会被忽略，比如:

```python
Union[int, str] == Union[str, int]
```

#### Optional

可选类型。`Optional[X]` 等价于 `Union[X, None]`。

```python
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

`Callable[..., ReturnType]`（使用字面省略号）能被用于提示一个可调用对象，接受任意数量的参数并且返回 `ReturnType`。

单独的 `Callable` 等价于 `Callable[..., Any]`，并且进而等价于 `collections.abc.Callable` 。
