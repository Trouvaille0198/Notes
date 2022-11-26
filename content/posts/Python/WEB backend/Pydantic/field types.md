---
title: "pydantic field types"
date: 2022-11-25
author: MelonCholi
draft: false
tags: [Python, 后端, pydantic]
categories: [Python]
---

# field types

pydantic 尽可能的使用标准库类型（standard library types）来标注字段来提供一个平滑的学习曲线；不过它也实现了许多常用的类型（commonly used types）

你可以你创造自己的类型（your own pydantic-compatible types）

## 标准库类型

- `None`, `type(None)` or `Literal[None]`

    - 只允许 `None` 值

- `bool`

    - 详见 `Booleans`

- `int`

    - pydantic 使用 `int(v)` 去将 v 强制转换成 `int`

- `float`

    - 同样地，`float(v)` 也会将 v 强制转换成 `float`

- `str`

    - `str` 原样接收
    - `int` `float` 和 `Decimal` 会被 `str(v)` 强制转换
    - `bytes` 和 `bytearray` 会用 `v.decode()` 强制转换
    - 继承自 `str` 的 `enum` 会被 `v.value` 强制转换
    - 其他的类型都会报错

- `bytes`

    - `bytes` 原样接收
    - `bytearray` 用 `bytes(v)` 转换
    - `str` 用 `v.encode()` 转换
    -  `int`, `float` 和 `Decimal` 用 `str(v).encode()` 强制转换

- `list`

    allows `list`, `tuple`, `set`, `frozenset`, `deque`, or generators and casts to a list; see `typing.List` below for sub-type constraints

- `tuple`

    allows `list`, `tuple`, `set`, `frozenset`, `deque`, or generators and casts to a tuple; see `typing.Tuple` below for sub-type constraints

- `dict`

    `dict(v)` is used to attempt to convert a dictionary; see `typing.Dict` below for sub-type constraints

- `set`

    allows `list`, `tuple`, `set`, `frozenset`, `deque`, or generators and casts to a set; see `typing.Set` below for sub-type constraints

- `frozenset`

    allows `list`, `tuple`, `set`, `frozenset`, `deque`, or generators and casts to a frozen set; see `typing.FrozenSet` below for sub-type constraints

- `deque`

    allows `list`, `tuple`, `set`, `frozenset`, `deque`, or generators and casts to a deque; see `typing.Deque` below for sub-type constraints

- `datetime.date`

    see [Datetime Types](https://pydantic-docs.helpmanual.io/usage/types/#datetime-types) below for more detail on parsing and validation

- `datetime.time`

    see [Datetime Types](https://pydantic-docs.helpmanual.io/usage/types/#datetime-types) below for more detail on parsing and validation

- `datetime.datetime`

    see [Datetime Types](https://pydantic-docs.helpmanual.io/usage/types/#datetime-types) below for more detail on parsing and validation

- `datetime.timedelta`

    see [Datetime Types](https://pydantic-docs.helpmanual.io/usage/types/#datetime-types) below for more detail on parsing and validation

- `typing.Any`

    allows any value including `None`, thus an `Any` field is optional

- `typing.Annotated`

    allows wrapping another type with arbitrary metadata, as per [PEP-593](https://www.python.org/dev/peps/pep-0593/). The `Annotated` hint may contain a single call to the [`Field` function](https://pydantic-docs.helpmanual.io/usage/schema/#typingannotated-fields), but otherwise the additional metadata is ignored and the root type is used.

- `typing.TypeVar`

    constrains the values allowed based on `constraints` or `bound`, see [TypeVar](https://pydantic-docs.helpmanual.io/usage/types/#typevar)

- `typing.Union`

    see [Unions](https://pydantic-docs.helpmanual.io/usage/types/#unions) below for more detail on parsing and validation

- `typing.Optional`

    `Optional[x]` is simply short hand for `Union[x, None]`; see [Unions](https://pydantic-docs.helpmanual.io/usage/types/#unions) below for more detail on parsing and validation and [Required Fields](https://pydantic-docs.helpmanual.io/usage/models/#required-fields) for details about required fields that can receive `None` as a value.

- `typing.List`

    see [Typing Iterables](https://pydantic-docs.helpmanual.io/usage/types/#typing-iterables) below for more detail on parsing and validation

- `typing.Tuple`

    see [Typing Iterables](https://pydantic-docs.helpmanual.io/usage/types/#typing-iterables) below for more detail on parsing and validation

- `subclass of typing.NamedTuple`

    Same as `tuple` but instantiates with the given namedtuple and validates fields since they are annotated. See [Annotated Types](https://pydantic-docs.helpmanual.io/usage/types/#annotated-types) below for more detail on parsing and validation

- `subclass of collections.namedtuple`

    Same as `subclass of typing.NamedTuple` but all fields will have type `Any` since they are not annotated

- `typing.Dict`

    see [Typing Iterables](https://pydantic-docs.helpmanual.io/usage/types/#typing-iterables) below for more detail on parsing and validation

- `subclass of typing.TypedDict`

    Same as `dict` but *pydantic* will validate the dictionary since keys are annotated. See [Annotated Types](https://pydantic-docs.helpmanual.io/usage/types/#annotated-types) below for more detail on parsing and validation

- `typing.Set`

    see [Typing Iterables](https://pydantic-docs.helpmanual.io/usage/types/#typing-iterables) below for more detail on parsing and validation

- `typing.FrozenSet`

    see [Typing Iterables](https://pydantic-docs.helpmanual.io/usage/types/#typing-iterables) below for more detail on parsing and validation

- `typing.Deque`

    see [Typing Iterables](https://pydantic-docs.helpmanual.io/usage/types/#typing-iterables) below for more detail on parsing and validation

- `typing.Sequence`

    see [Typing Iterables](https://pydantic-docs.helpmanual.io/usage/types/#typing-iterables) below for more detail on parsing and validation

- `typing.Iterable`

    this is reserved for iterables that shouldn't be consumed. See [Infinite Generators](https://pydantic-docs.helpmanual.io/usage/types/#infinite-generators) below for more detail on parsing and validation

- `typing.Type`

    see [Type](https://pydantic-docs.helpmanual.io/usage/types/#type) below for more detail on parsing and validation

- `typing.Callable`

    see [Callable](https://pydantic-docs.helpmanual.io/usage/types/#callable) below for more detail on parsing and validation

- `typing.Pattern`

    will cause the input value to be passed to `re.compile(v)` to create a regex pattern

- `ipaddress.IPv4Address`

    simply uses the type itself for validation by passing the value to `IPv4Address(v)`; see [Pydantic Types](https://pydantic-docs.helpmanual.io/usage/types/#pydantic-types) for other custom IP address types

- `ipaddress.IPv4Interface`

    simply uses the type itself for validation by passing the value to `IPv4Address(v)`; see [Pydantic Types](https://pydantic-docs.helpmanual.io/usage/types/#pydantic-types) for other custom IP address types

- `ipaddress.IPv4Network`

    simply uses the type itself for validation by passing the value to `IPv4Network(v)`; see [Pydantic Types](https://pydantic-docs.helpmanual.io/usage/types/#pydantic-types) for other custom IP address types

- `ipaddress.IPv6Address`

    simply uses the type itself for validation by passing the value to `IPv6Address(v)`; see [Pydantic Types](https://pydantic-docs.helpmanual.io/usage/types/#pydantic-types) for other custom IP address types

- `ipaddress.IPv6Interface`

    simply uses the type itself for validation by passing the value to `IPv6Interface(v)`; see [Pydantic Types](https://pydantic-docs.helpmanual.io/usage/types/#pydantic-types) for other custom IP address types

- `ipaddress.IPv6Network`

    simply uses the type itself for validation by passing the value to `IPv6Network(v)`; see [Pydantic Types](https://pydantic-docs.helpmanual.io/usage/types/#pydantic-types) for other custom IP address types

- `enum.Enum`

    checks that the value is a valid Enum instance

- `subclass of enum.Enum`

    checks that the value is a valid member of the enum; see [Enums and Choices](https://pydantic-docs.helpmanual.io/usage/types/#enums-and-choices) for more details

- `enum.IntEnum`

    checks that the value is a valid IntEnum instance

- `subclass of enum.IntEnum`

    checks that the value is a valid member of the integer enum; see [Enums and Choices](https://pydantic-docs.helpmanual.io/usage/types/#enums-and-choices) for more details

- `decimal.Decimal`

    *pydantic* attempts to convert the value to a string, then passes the string to `Decimal(v)`

- `pathlib.Path`

    simply uses the type itself for validation by passing the value to `Path(v)`; see [Pydantic Types](https://pydantic-docs.helpmanual.io/usage/types/#pydantic-types) for other more strict path types

- `uuid.UUID`

    strings and bytes (converted to strings) are passed to `UUID(v)`, with a fallback to `UUID(bytes=v)` for `bytes` and `bytearray`; see [Pydantic Types](https://pydantic-docs.helpmanual.io/usage/types/#pydantic-types) for other stricter UUID types

- `ByteSize`

    converts a bytes string with units to bytes
