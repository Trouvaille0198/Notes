---
title: "Python typing 库"
date: 2022-09-28
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# typing

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



```dart
# 'output' is of type 'int', not 'UserId' 

output = UserId(23413) + UserId(54341) 
```

> 需要注意，这些检查仅通过静态类型检查程序来强制。`NewType`返回的是一个函数该函数立即返回传递它的任意值这就意味着`UserId(1234)`并不会创建一个新的类或引入任何超出常规函数调用的开销。
>  因此，运行过程中`same_value is Newtype("TypeName", Base)(same_value)` 始终为True。
>  但是，可以基于 `NewType` 创建 `NewType` 。

------

> 使用类型别名声明两种类型彼此 *等效* 。`Alias = Original` 将使静态类型检查对待所有情况下 `Alias` *完全等同于* `Original`。当您想简化复杂类型签名时，这很有用。
>  相反，`NewType` 声明一种类型是另一种类型的子类型。`Derived = NewType('Derived', Original)` 将使静态类型检查器将 `Derived` 当作 `Original` 的 *子类* ，这意味着 `Original` 类型的值不能用于 `Derived` 类型的值需要的地方。当您想以最小的运行时间成本防止逻辑错误时，这非常有用。