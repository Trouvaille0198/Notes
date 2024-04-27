---
title: "Python unittest 库"
date: 2022-09-15
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# unittest

```json
import unittest

class TestStringMethods(unittest.TestCase):

    def test_upper(self):
        self.assertEqual('foo'.upper(), 'FOO')

    def test_isupper(self):
        self.assertTrue('FOO'.isupper())
        self.assertFalse('Foo'.isupper())

    def test_split(self):
        s = 'hello world'
        self.assertEqual(s.split(), ['hello', 'world'])
        # check that s.split fails when the separator is not a string
        with self.assertRaises(TypeError):
            s.split(2)

if __name__ == '__main__':
    unittest.main()
```

## Mock

> 更详细的介绍：https://www.cnblogs.com/guyuyun/p/14880885.html
>
> 官方文档：https://docs.python.org/zh-cn/3/library/unittest.mock.html#quick-guide

[`unittest.mock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#module-unittest.mock) 是一个用于测试的 Python 库。它允许使用模拟对象来替换受测系统的一些部分，并对这些部分如何被使用进行断言判断。

在进行单元测试的时候，会遇到以下问题：

- 接口的依赖
- 外部接口调用

测试环境非常复杂。

且单元测试应该只针对当前单元进行测试, 所有的内部或外部的依赖应该是稳定的, 已经在别处进行测试过的。使用 mock 就可以对外部依赖组件实现进行模拟并且替换掉, 从而使得单元测试将焦点只放在当前的单元功能。

### 快速上手

当您访问对象时， [`Mock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock) 和 [`MagicMock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.MagicMock) 将创建所有属性和方法，并保存他们在使用时的细节。你可以通过配置，指定返回值或者限制可访问属性，然后断言他们如何被调用：

```py
>>> from unittest.mock import MagicMock
>>> thing = ProductionClass()
>>> thing.method = MagicMock(return_value=3)
>>> thing.method(3, 4, 5, key='value')
3
>>> thing.method.assert_called_with(3, 4, 5, key='value')
```

通过 `side_effect` 设置副作用 (side effects) ，可以是一个 mock 被调用时抛出的异常：

```py
>>> from unittest.mock import Mock
>>> mock = Mock(side_effect=KeyError('foo'))
>>> mock()
Traceback (most recent call last):
 ...
KeyError: 'foo'
```

也可以是一个函数，一个列表

```py
>>> values = {'a': 1, 'b': 2, 'c': 3}
>>> def side_effect(arg):
...     return values[arg]
...
>>> mock.side_effect = side_effect
>>> mock('a'), mock('b'), mock('c')
(1, 2, 3)
>>> mock.side_effect = [5, 4, 3, 2, 1]
>>> mock(), mock(), mock()
(5, 4, 3)
```

Mock 还可以通过其他方法配置和控制其行为。例如 mock 可以通过设置 *spec* 参数来从一个对象中获取其规格 (specification)。如果访问 mock 的属性或方法不在 spec 中，会报 [`AttributeError`](https://docs.python.org/zh-cn/3/library/exceptions.html#AttributeError) 错误。

使用 [`patch()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch) 装饰去/上下文管理器，可以更方便地测试一个模块下的类或对象。你指定的对象会在测试过程中替换成 mock （或者其他对象），测试结束后恢复。

```py
>>> from unittest.mock import patch
>>> @patch('module.ClassName2')
... @patch('module.ClassName1')
... def test(MockClass1, MockClass2):
...     module.ClassName1()
...     module.ClassName2()
...     assert MockClass1 is module.ClassName1
...     assert MockClass2 is module.ClassName2
...     assert MockClass1.called
...     assert MockClass2.called
...
>>> test()
```

> 当你嵌套 patch 装饰器时，mock 将以执行顺序传递给装饰器函数（*Python* 装饰器正常顺序）。由于从下至上，因此在上面的示例中，mock 传入的首先是 `module.ClassName1` 。

[`patch()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch) 也可以 with 语句中使用上下文管理。

```py
>>> with patch.object(ProductionClass, 'method', return_value=None) as mock_method:
...     thing = ProductionClass()
...     thing.method(1, 2, 3)
...
>>> mock_method.assert_called_once_with(1, 2, 3)
```

还有一个 [`patch.dict()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch.dict) 用于在一定范围内设置字典中的值，并在测试结束时将字典恢复为其原始状态：

```py
>>> foo = {'key': 'value'}
>>> original = foo.copy()
>>> with patch.dict(foo, {'newkey': 'newvalue'}, clear=True):
...     assert foo == {'newkey': 'newvalue'}
...
>>> assert foo == original
```

Mock 支持 Python [魔术方法](https://docs.python.org/zh-cn/3/library/unittest.mock.html#magic-methods) 。使用魔术方法最简单的方式是使用 [`MagicMock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.MagicMock) class. 。它可以做如下事情：

```py
>>> mock = MagicMock()
>>> mock.__str__.return_value = 'foobarbaz'
>>> str(mock)
'foobarbaz'
>>> mock.__str__.assert_called_with()
```

Mock 能指定函数（或其他 Mock 实例）为魔术方法，它们将被适当地调用。 [`MagicMock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.MagicMock) 是预先创建了所有魔术方法（所有有用的方法） 的 Mock 。

下面是一个使用了普通 Mock 类的魔术方法的例子

```py
>>> mock = Mock()
>>> mock.__str__ = Mock(return_value='wheeeeee')
>>> str(mock)
'wheeeeee'
```

使用 [auto-speccing](https://docs.python.org/zh-cn/3/library/unittest.mock.html#auto-speccing) 可以保证测试中的模拟对象与要替换的对象具有相同的 api 。在 patch 中可以通过 *autospec* 参数实现自动推断，或者使用 [`create_autospec()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.create_autospec) 函数。自动推断会创建一个与要替换对象相同的属相和方法的模拟对象，并且任何函数和方法（包括构造函数）都具有与真实对象相同的调用签名。

这么做是为了因确保不当地使用 mock 导致与生产代码相同的失败：

```py
>>> from unittest.mock import create_autospec
>>> def function(a, b, c):
...     pass
...
>>> mock_function = create_autospec(function, return_value='fishy')
>>> mock_function(1, 2, 3)
'fishy'
>>> mock_function.assert_called_once_with(1, 2, 3)
>>> mock_function('wrong arguments')
Traceback (most recent call last):
 ...
TypeError: <lambda>() takes exactly 3 arguments (1 given)
```

在类中使用 [`create_autospec()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.create_autospec) 时，会复制 `__init__` 方法的签名，另外在可调用对象上使用时，会复制 `__call__` 方法的签名。

### Mock 和 MagicMock 对象

Mock 对象可以用来模拟对象、属性和方法，Mock 对象也会记录自身被使用的过程，你可以通过相关 assert 方法来测试验证代码是否被执行过。MagicMock 类是 Mock 类的一个子类，它实现了所有常用的 magic 方法。

#### Mock 构造函数

```py
unittest.mock.Mock(spec=None, side_effect=None, return_value=DEFAULT, wraps=None, name=None, spec_set=None, unsafe=False, **kwargs)
```

- ==spec==： 可传入一个字符串列表、类或者实例
    - 访问（get 操作）任何不在此列表中的属性和方法时都会抛出 AttributeError。
    - 如果传入的是类或者实例对象，那么将会使用 `dir` 方法将该类或实例转化为一个字符串列表（magic 属性和方法除外）
    - 如果传入的是一个类或者实例对象，那么 `__class__` 方法会返回对应的类，以便在使用 `isinstance` 方法时进行判断。
- spec_set： spec 参数的变体，但更加严格，如果试图使用 get 操作或 set 操作来操作此参数指定的对象中没有的属性或方法，则会抛出 AttributeError
    - 而 spec 参数是可以对 spec 指定对象中没有的属性进行 set 操作的。参考 `mock_add_spec` 方法。
- ==side_effect==：可以传入一个函数，**每次当 Mock 对象被调用的时候，就会自动调用该函数**，可以用于抛出异常或者动态改变 mock 对象的返回值
    - 此函数使用的参数与 mock 对象被调用时传入的参数是一样的。
    - 也可以传入一个 exception 对象或者实例对象，如果传入 exception 对象，则每次调用 mock 对象都会抛出该异常。
    - 也可以传入一个可迭代对象，每次调用 mock 对象时就会返回该迭代对象的下一个值。
- ==return_value==： 每次调用 mock 对象时的返回值，默认第一次调用时创建新的 Mock 对象。
- name： 指定 mock 对象的名称，可在 debug 的时候使用，并且可以 “传播” 到子类中。
- 其他参数详见官方文档

#### MagicMock 构造函数

```py
unittest.mock.MagicMock(**args*, ***kw*)
```

`MagicMock` 是包含了大部分魔术方法的默认实现的 [`Mock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock) 的子类。 你可以使用 `MagicMock` 而无须自行配置魔术方法。

构造器形参的含义与 [`Mock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock) 的相同。

魔术方法是通过 [`MagicMock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.MagicMock) 对象来设置的，因此你可以用通常的方式来配置它们并使用它们:

```py
>>> mock = MagicMock()
>>> mock[3] = 'fish'
>>> mock.__setitem__.assert_called_with(3, 'fish')
>>> mock.__getitem__.return_value = 'result'
>>> mock[2]
'result'
```

在默认情况下许多协议方法都需要返回特定类型的对象。 这些方法都预先配置了默认的返回值，以便它们在你对返回值不感兴趣时可以不做任何事就能被使用。 如果你想要修改默认值则你仍然可以手动 *设置* 返回值。

方法及其默认返回值:

- `__lt__`: `NotImplemented`
- `__gt__`: `NotImplemented`
- `__le__`: `NotImplemented`
- `__ge__`: `NotImplemented`
- `__int__`: `1`
- `__contains__`: `False`
- `__len__`: `0`
- `__iter__`: `iter([])`
- `__exit__`: `False`
- `__aexit__`: `False`
- `__complex__`: `1j`
- `__float__`: `1.0`
- `__bool__`: `True`
- `__index__`: `1`
- `__hash__`: mock 的默认 hash
- `__str__`: mock 的默认 str
- `__sizeof__`: mock 的默认 sizeof

例如:

```py
>>> mock = MagicMock()
>>> int(mock)
1
>>> len(mock)
0
>>> list(mock)
[]
>>> object() in mock
False
```

两个相等性方法 `__eq__()` 和 `__ne__()` 是特殊的。 它们基于标识号进行默认的相等性比较，使用 [`side_effect`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.side_effect) 属性，除非你修改它们的返回值以返回其他内容:

```py
>>> MagicMock() == 3
False
>>> MagicMock() != 3
True

>>> mock = MagicMock()
>>> mock.__eq__.return_value = True
>>> mock == 3
True
```

`MagicMock.__iter__()` 的返回值可以是任意可迭代对象而不要求必须是迭代器:

```py
>>> mock = MagicMock()
>>> mock.__iter__.return_value = ['a', 'b', 'c']
>>> list(mock)
['a', 'b', 'c']
>>> list(mock)
['a', 'b', 'c']
>>> list(mock)
['a', 'b', 'c']
```

如果返回值是迭代器，则对其执行一次迭代就会将它耗尽因而后续执行的迭代将会输出空列表:

```py
>>> mock.__iter__.return_value = iter(['a', 'b', 'c'])
>>> list(mock)
['a', 'b', 'c']
>>> list(mock)
[]
```

`MagicMock` 已配置了所有受支持的魔术方法，只有某些晦涩和过时的魔术方法是例外。 如果你需要仍然可以设置它们。

在 `MagicMock` 中受到支持但默认未被设置的魔术方法有:

- `__subclasses__`
- `__dir__`
- `__format__`
- `__get__`, `__set__` 和 `__delete__`
- `__reversed__` 和 `__missing__`
- `__reduce__`, `__reduce_ex__`, `__getinitargs__`, `__getnewargs__`, `__getstate__` 和 `__setstate__`
- `__getformat__`

### 常用方法

#### `assert_called()`

断言 mock 对象至少被调用过一次。

```py
mock = Mock()
>>> mock.method()
<Mock name='mock.method()' id='...'>
>>> mock.method.assert_called()
```

#### `assert_called_once()`

断言 mock 对象只被调用过一次。

```python
>>> mock = Mock()
>>> mock.method()
<Mock name='mock.method()' id='...'>
>>> mock.method.assert_called_once()
>>> mock.method()
<Mock name='mock.method()' id='...'>
>>> mock.method.assert_called_once()
Traceback (most recent call last):
...
AssertionError: Expected 'method' to have been called once. Called 2 times.
```

#### `assert_called_with(*args, **kwargs)`

断言 mock 对象**最后一次**被调用的方式。

```py
>>> from unittest.mock import Mock
>>> mock = Mock()
>>> mock.method(1, 2, 3, test='wow')
<Mock name='mock.method()' id='2956280756552'>
>>> mock.method.assert_called_with(1, 2, 3, test='wow')
```

#### `assert_called_once_with(*args, **kwargs)`

断言 mock 对象以指定方式只被调用过一次。

#### `assert_any_call(*args, **kwargs)`

断言 mock 对象以指定方式被调用过。

#### `assert_has_calls(calls, any_order=False)`

断言 mock 对象以 calls 中指定的调用方式被调用过。

- calls 是一个 `unittest.mock.call` 对象列表，any_order 默认为 False，表示 calls 中的对象必须按照原来的调用顺序传入，为 True 则表示可以是任意顺序。

```py
from unittest.mock import Mock, call
>>> mock = Mock(return_value=None)
>>> mock(1)
>>> mock(2)
>>> mock(3)
>>> mock(4)
>>> calls = [call(2), call(3)]
>>> mock.assert_has_calls(calls)
>>> calls = [call(4), call(2), call(3)]
>>> mock.assert_has_calls(calls, any_order=True)
```

#### `assert_not_called()`

断言 mock 对象没有被调用过。

#### `reset_mock(*, return_value=False, side_effect=False)`

重置所有调用相关的属性，但是默认不会改变它的 return_value 和 side_effect，以及其他属性。

- 如果你想要重置 return_value 或 side_effect，则要为相应的形参传入 `True`。

```py
>>> from unittest.mock import Mock
>>> mock = Mock(return_value='hi')
>>> mock('hello')
'hi'
>>> mock.called
True
>>> mock.reset_mock()
>>> mock.called
False
```

#### `mock_add_spec(spec, spec_set=False)`

spec 参数可以是一个对象或者一个字符串列表，如果指定了此参数，那么只有 spec 指定的属性才可以进行访问（get 操作）。如果 spec_set 设置为 True，那么只有 spec 中指定的属性才可以进行 set 操作。

```py
>>> mock = Mock()
>>> mock.mock_add_spec(spec=['test_spec'])
>>> mock.test_spec
<Mock name='mock.test_spec' id='1504477311816'>
>>> mock.new_test_spec  # 只能访问spec指定的属性
Traceback (most recent call last):
  ...
AttributeError: Mock object has no attribute 'new_test_spec'
>>> mock.new_test_spec = 'test spec!!!'  # 但是可以设置新的属性
>>> mock.new_test_spec
'test spec!!!'
>>> mock.mock_add_spec(spec=['test_spec'], spec_set=True)
>>> mock.new_test_spec3 = 'test spec3'  # spec_set设置为True后，将不能设置新的属性
Traceback (most recent call last):
  ...
AttributeError: Mock object has no attribute 'new_test_spec3'
```

#### `attach_mock(mock, attribute)`

将一个 mock 对象作为一个子属性添加到当前 mock 对象，并且会将其 name 值和 parent 关系进行替换。注意，此方法的调用会被记录在 `method_calls` 方法和 `mock_calls` 方法中。

#### `configure_mock(**kwargs)`

添加额外的属性到已经创建的 mock 对象，并且可以给属性添加 return_value 值和 side_effect 值。在创建 mock 对象时也可以用这种方式添加额外的属性。

```py
>>> from unittest.mock import Mock
>>> mock = Mock()
>>> attrs = {'func.return_value': 'hello', 'side_func.side_effect': ValueError}
>>> mock.configure_mock(**attrs)  # 给已经创建的mock对象添加额外的属性
>>> mock.func()
'hello'
>>> mock.side_func()
Traceback (most recent call last):
  ...
ValueError

>>> new_mock = Mock(other_attr='hi', **attrs)  # 在创建mock对象时指定额外的属性，效果同configure_mock()方法
>>> new_mock.other_attr
'hi'
>>> new_mock.func()
'hello'
>>> new_mock.side_func()
Traceback (most recent call last):
  ...
ValueError
```

### 常用属性

#### **called**

如果 mock 对象被调用过则返回 True，否则返回 False。

```py
>>> mock = Mock(return_value=None)
>>> mock.called
False

>>> mock()
>>> mock.called
True
```

#### **call_count**

返回 mock 对象被调用的次数。

```py
>>> mock = Mock(return_value=None)
>>> mock.call_count
0

>>> mock()
>>> mock()
>>> mock.call_count
2
```

#### **return_value**

指定 mock 对象被调用时的返回值，也可以在创建 mock 对象时通过参数进行指定。如果没有进行指定，return_value 的默认值为一个 mock 对象，而且它就是一个正常的 mock 对象，你可以把它当成普通的 mock 对象进行其他操作。

```py
>>> mock = Mock(return_value='hello')
>>> mock()
'hello'

>>> mock.return_value = 'hi'
>>> mock()
'hi'

>>> new_mock = Mock()
>>> new_mock.return_value
<Mock name='mock()' id='2064061578056'>
```

#### **side_effect**

这个属性可以是函数、可迭代对象或者异常（类或实例都可以），当 mock 对象被调用时， `side_effect` 属性对应的对象就会被调用一次。

- 如果传入的是函数，那么它将在 mock 对象调用时被执行，且执行时此函数传入的参数与 mock 对象被调用时的参数是一致的
    - 此函数的返回值即 mock 被对象调用的返回值，但是如果函数的返回值是 `unittest.mock.DEFAULT` 对象，那么 mock 对象被调用的返回值就是它自身的 return_value 属性值。
- 如果传入的是一个可迭代对象，那么这个对象将被用作产生一个迭代器，这个迭代器在每一次 mock 对象被调用时返回一个值，这个值可以是异常类的实例，也可以是一个普通的值，当然如果这个返回值是一个 `unittest.mock.DEFAULT` 对象，则返回 mock 对象本身的 return_value 属性值。

`side_effect` 是一个异常:

```py
>>> from unittest.mock import Mock
>>> mock = Mock()
>>> mock.side_effect = ValueError('hello')
>>> mock()
Traceback (most recent call last):
  ...
ValueError: hello
```

`side_effect` 是一个可迭代对象：

```py
>>> mock.side_effect = [1, 2, 3]
>>> mock()
1
>>> mock()
2
>>> mock()
3
>>> mock()
Traceback (most recent call last):
  ...
StopIteration
```

`side_effect` 是一个 `unittest.mock.DEFAULT`：

```py
>>> from unittest.mock import DEFAULT, Mock
>>> def side_func(*args, **kwargs):
...     return DEFAULT
... 
>>> mock = Mock(return_value='hi')
>>> mock.side_effect = side_func
>>> mock()
'hi'
```

创建 mock 对象时指定 `side_effect` 为一个函数：

```py
>>> def side_func(value):
...     return value ** 2
... 
>>> mock = Mock(side_effect=side_func)
>>> mock(3)
9
```

将 `side_effect` 指定为 None，即可清除该选项：

```py
>>> mock = Mock(side_effect=KeyError, return_value=3)
>>> mock()
Traceback (most recent call last):
  ...
KeyError
>>> mock.side_effect = None
>>> mock()
3
```

#### **call_args**

返回 mock 对象最近一次被调用时的参数，如果没有被调用过，则为 None。

也可以通过 `call_args.args` 和 `call_args.kwargs` 属性分别获取对应的位置参数和关键词参数

```py
>>> mock = Mock(return_value='hello')
>>> print(mock.call_args)
None

>>> mock('aa', 'bb', hi='hi')
'hello'

>>> mock.call_args
call('aa', 'bb', hi='hi')

>>> isinstance(mock.call_args, tuple)
True
>>> mock.call_args == (('aa', 'bb'), {'hi': 'hi'})
True
```

#### **call_args_list**

存储 mock 对象调用的列表，列表元素为 call 对象，在没有被调用之前为空列表。

```py
>>> from unittest.mock import Mock
>>> mock = Mock(return_value=None)
>>> mock.call_args_list
[]

>>> mock(1, 2)
>>> mock(arg1='hi', arg2='hello')
>>> mock.call_args_list
[call(1, 2), call(arg1='hi', arg2='hello')]

>>> mock.call_args_list == [((1, 2), ), ({'arg1': 'hi', 'arg2': 'hello'}, )]
True
```

#### **method_calls**

存储 mock 对象调用以及“调用的调用“的列表，列表元素为 call 对象，在没有被调用之前为空列表。

```py
>>> mock = Mock()
>>> mock.method_calls
[]
>>> mock.func()
<Mock name='mock.func()' id='2152783337672'>

>>> mock.pro.func2.attr()
<Mock name='mock.pro.func2.attr()' id='2152784407496'>

>>> mock.method_calls
[call.func(), call.pro.func2.attr()]
```

#### **mock_calls**

存储 mock 对象所有类型调用的列表。

```py
>>> from unittest.mock import call, Mock
>>> mock = Mock()
>>> mock(1, 2, 3)
<Mock name='mock()' id='2152784400584'>
>>> result = mock.func(a=3)
>>> result(44)
<Mock name='mock.func()()' id='2152771939848'>
>>> mock.top(a=3).bottom()
<Mock name='mock.top().bottom()' id='2152784434888'>

>>> mock.mock_calls
[call(1, 2, 3),
 call.func(a=3),
 call.func()(44),
 call.top(a=3),
 call.top().bottom()]

>>> mock.mock_calls[-1] == call.top(a=-1).bottom()  # 注意：子调用bottom是没有记录其父调用top的参数的
True
```

#### `__class__`

如果 mock 对象指定了 spec 对象，则会返回 spec 对象的类型，也可以直接赋值。

这个属性主要是在 `isinstance` 进行判断的时候会用到。

```py
>>> mock = Mock(spec=3)
>>> isinstance(mock, int)
True

>>> mock.__class__ = dict  # 如果不想特别去指定spec参数，可以直接进行赋值
>>> isinstance(mock, dict)
True
```

### 其他 Mock 类

#### AsyncMock 类

`unittest.mock.AsyncMock` 是 MagicMock 的异步版本，AsyncMock 对象会像一个异步函数一样运行，它的调用的返回值是一个 awaitable 对象，这个 awaitable 对象返回 `side_effect` 或者 `return_value` 指定的值。

```py
>>> import asyncio
>>> import inspect
>>> from unittest.mock import AsyncMock
>>> mock = AsyncMock()

>>> asyncio.iscoroutinefunction(mock)
True
>>> inspect.isawaitable(mock())
True
```

如果 Mock 或者 MagicMock 的 spec 参数指定了一个异步的函数，那么对应 mock 对象的调用将返回一个协程对象。

```py
>>> from unittest.mock import MagicMock
>>> async def async_func(): pass
... 
>>> mock = MagicMock(async_func)
>>> mock
<MagicMock spec='function' id='1934190100048'>
>>> mock()
<coroutine object AsyncMockMixin._execute_mock_call at 0x000001C2568E8EC0>
```

如果 Mock、MagicMock 或者 AsyncMock 的 spec 参数指定了带有同步或者异步函数的类，那么对于 Mock，所有的同步函数将被定义为 Mock 对象，对于 MagicMock 和 AsyncMock，所有同步函数将被定义为 MagicMock。而对于 Mock、MagicMock 或者 AsyncMock，所有的异步函数都将被定义为 AsyncMock 对象。

```py
>>> class ExampleClass:
...     def sync_foo():
...         pass
...     async def async_foo():
...         pass
...     
>>> a_mock = AsyncMock(ExampleClass)

>>> a_mock.sync_foo
<MagicMock name='mock.sync_foo' id='1934183952000'>
>>> a_mock.async_foo
<AsyncMock name='mock.async_foo' id='1934183974272'>

>>> from unittest.mock import Mock
>>> mock = Mock(ExampleClass)
>>> mock.sync_foo
<Mock name='mock.sync_foo' id='1934183980864'>
>>> mock.async_foo
<AsyncMock name='mock.async_foo' id='1934183978800'>
```

### 上手指南

> 摘自 https://docs.python.org/zh-cn/3/library/unittest.mock-examples.html

使用 [`Mock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock) 的常见场景：

- 模拟函数调用
- 记录在对象上的方法调用

#### 模拟方法调用

你可能需要替换一个对象上的方法，用于确认此方法被系统中的其他部分调用过，并且调用时使用了正确的参数。

```py
>>> real = SomeClass()
>>> real.method = MagicMock(name='method')
>>> real.method(3, 4, 5, key='value')
<MagicMock name='method()' id='...'>
```

> 在多数示例中，[`Mock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock) 与 [`MagicMock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.MagicMock) 两个类可以相互替换，而 `MagicMock` 是一个更适用的类，通常情况下，使用它就可以了。

如果 mock 被调用，它的 [`called`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.called) 属性就会变成 `True`，更重要的是，我们可以使用 [`assert_called_with()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.assert_called_with) 或者 [`assert_called_once_with()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.assert_called_once_with) 方法来确认它在被调用时使用了正确的参数。

在如下的测试示例中，验证对于 `ProductionClass().method` 的调用会导致 `something` 的调用。

```py
>>> class ProductionClass:
...     def method(self):
...         self.something(1, 2, 3)
...     def something(self, a, b, c):
...         pass
...
>>> real = ProductionClass()
>>> real.something = MagicMock()
>>> real.method()
>>> real.something.assert_called_once_with(1, 2, 3)
```

#### 对象上的方法调用的 mock

上一个例子中我们直接在对象上给方法打补丁以检查它是否被正确地调用。 另一个常见的用例是将一个对象传给一个方法（或被测试系统的某个部分）然后检查它是否以正确的方式被使用。

下面这个简单的 `ProductionClass` 具有一个 `closer` 方法。 如果它附带一个对象被调用那么它就会调用其中的 `close`。

```py
>>> class ProductionClass:
...     def closer(self, something):
...         something.close()
...
```

所以为了测试它我们需要传入一个带有 `close` 方法的对象并检查它是否被正确地调用。

```py
>>> real = ProductionClass()
>>> mock = Mock()
>>> real.closer(mock)
>>> mock.close.assert_called_with()
```

我们不需要做任何事来在我们的 mock 上提供 'close' 方法。 访问 close 的操作就会创建它。

#### 模拟类

一个常见的用例是模拟被测试的代码所实例化的类。 当你给一个类打上补丁，该类就会被替换为一个 mock。 实例是通过 *调用该类* 来创建的。 这意味着你要通过查看被模拟类的返回值来访问“mock 实例”。

在下面的例子中我们有一个函数 `some_function` 实例化了 `Foo` 并调用该实例中的一个方法。 对 [`patch()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch) 的调用会将类 `Foo` 替换为一个 mock。 `Foo` 实例是调用该 mock 的结果，所以它是通过修改 [`return_value`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.return_value) 来配置的。

```py
>>> def some_function():
...     instance = module.Foo()
...     return instance.method()
...
>>> with patch('module.Foo') as mock:
...     instance = mock.return_value
...     instance.method.return_value = 'the result'
...     result = some_function()
...     assert result == 'the result'
```

#### 命名你的 mock

给你的 mock 起个名字可能会很有用。 名字会显示在 mock 的 repr 中并在 mock 出现于测试失败消息中时可以帮助理解。 这个名字也会被传播给 mock 的属性或方法:

```py
>>> mock = MagicMock(name='foo')
>>> mock
<MagicMock name='foo' id='...'>
>>> mock.method
<MagicMock name='foo.method' id='...'>
```

#### 追踪所有的调用

通常你会想要追踪对某个方法的多次调用。 [`mock_calls`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.mock_calls) 属性记录了所有对 mock 的子属性的调用 —— 并且还包括对它们的子属性的调用。

```py
>>> mock = MagicMock()
>>> mock.method()
<MagicMock name='mock.method()' id='...'>

>>> mock.attribute.method(10, x=53)
<MagicMock name='mock.attribute.method()' id='...'>

>>> mock.mock_calls
[call.method(), call.attribute.method(10, x=53)]
```

如果你做了一个有关 `mock_calls` 的断言并且有任何非预期的方法被调用，则断言将失败。 这很有用处，因为除了断言你所预期的调用已被执行，你还会检查它们是否以正确的顺序被执行并且没有额外的调用:

你使用 [`call`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.call) 对象来构造列表以便与 `mock_calls` 进行比较:

```py
>>> expected = [call.method(), call.attribute.method(10, x=53)]
>>> mock.mock_calls == expected
True
```

然而，返回 mock 的调用的形参不会被记录，这意味着不可能追踪附带了重要形参的创建上级对象的嵌套调用:

```py
>>> m = Mock()
>>> m.factory(important=True).deliver()
<Mock name='mock.factory().deliver()' id='...'>

>>> m.mock_calls[-1] == call.factory(important=False).deliver()
True
```

#### 设置返回值和属性

在 mock 对象上设置返回值是非常容易的:

```py
>>> mock = Mock()
>>> mock.return_value = 3
>>> mock()
3
```

当然你也可以对 mock 上的方法做同样的操作:

```py
>>> mock = Mock()
>>> mock.method.return_value = 3
>>> mock.method()
3
```

返回值也可以在构造器中设置:

```py
>>> mock = Mock(return_value=3)
>>> mock()
3
```

如果你需要在你的 mock 上设置一个属性，只需这样做:

```py
>>> mock = Mock()
>>> mock.x = 3
>>> mock.x
3
```

有时你会想要模拟更复杂的情况，例如这个例子 `mock.connection.cursor().execute("SELECT 1")`。 如果我们希望这个调用返回一个列表，那么我们还必须配置嵌套调用的结果。

我们可以像这样使用 [`call`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.call) 在一个“链式调用”中构造调用集合以便随后方便地设置断言:

```py
>>> mock = Mock()
>>> cursor = mock.connection.cursor.return_value
>>> cursor.execute.return_value = ['foo']
>>> mock.connection.cursor().execute("SELECT 1")
['foo']

>>> expected = call.connection.cursor().execute("SELECT 1").call_list()
>>> mock.mock_calls
[call.connection.cursor(), call.connection.cursor().execute('SELECT 1')]
>>> mock.mock_calls == expected
True
```

对 `.call_list()` 的调用会将我们的调用对象转成一个代表链式调用的调用列表。

#### 通过 mock 引发异常

一个很有用的属性是 [`side_effect`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.side_effect)。 如果你将该属性设为一个异常类或者实例那么当 mock 被调用时该异常将会被引发。

```py
>>> mock = Mock(side_effect=Exception('Boom!'))
>>> mock()
Traceback (most recent call last):
  ...
Exception: Boom!
```

#### 附带影响函数和可迭代对象

`side_effect` 也可以被设为一个函数或可迭代对象。 **`side_effect` 作为可迭代对象的应用场景适用于你的 mock 将要被多次调用，并且你希望每次调用都返回不同的值的情况。** 当你将 `side_effect` 设为一个可迭代对象时每次对 mock 的调用将返回可迭代对象的下一个值。

```py
>>> mock = MagicMock(side_effect=[4, 5, 6])
>>> mock()
4
>>> mock()
5
>>> mock()
6
```

对于更高级的用例，例如根据 mock 调用时附带的参数动态改变返回值，`side_effect` 可以指定一个函数。 该函数将附带与 mock 相同的参数被调用。 该函数所返回的就是调用所返回的对象:

```py
>>> vals = {(1, 2): 1, (2, 3): 2}
>>> def side_effect(*args):
...     return vals[args]
...

>>> mock = MagicMock(side_effect=side_effect)
>>> mock(1, 2)
1
>>> mock(2, 3)
2
```

#### 模拟异步迭代器

从 Python 3.8 起，`AsyncMock` 和 `MagicMock` 支持通过 `__aiter__` 来模拟 [异步迭代器](https://docs.python.org/zh-cn/3/reference/datamodel.html#async-iterators)。 `__aiter__` 的 [`return_value`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.return_value) 属性可以被用来设置要用于迭代的返回值。

```py
>>> mock = MagicMock()  # AsyncMock also works here
>>> mock.__aiter__.return_value = [1, 2, 3]
>>> async def main():
...     return [i async for i in mock]  # 异步迭代
...
>>> asyncio.run(main())
[1, 2, 3]
```

#### 模拟异步上下文管理器

从 Python 3.8 起，`AsyncMock` 和 `MagicMock` 支持通过 `__aenter__` 和 `__aexit__` 来模拟 [异步上下文管理器](https://docs.python.org/zh-cn/3/reference/datamodel.html#async-context-managers)。 在默认情况下，`__aenter__` 和 `__aexit__` 将为返回异步函数的 `AsyncMock` 实例。

```py
>>> class AsyncContextManager:
...     async def __aenter__(self):
...         return self
...     async def __aexit__(self, exc_type, exc, tb):
...         pass
...
>>> mock_instance = MagicMock(AsyncContextManager())  # AsyncMock also works here
>>> async def main():
...     async with mock_instance as result:  # 异步上下文管理器
...         pass
...
>>> asyncio.run(main())
>>> mock_instance.__aenter__.assert_awaited_once()
>>> mock_instance.__aexit__.assert_awaited_once()
```

#### 基于现有对象创建模拟对象

使用模拟操作的一个问题是它会将你的测试与你的 mock 实现相关联而不是与你的真实代码相关联。 假设你有一个实现了 `some_method` 的类。 在对另一个类的测试中，你提供了一个 *同样* 提供了 `some_method` 的模拟该对象的 mock 对象。 如果后来你重构了第一个类，使得它不再具有 `some_method` —— 那么你的测试将继续保持通过，尽管现在你的代码已经被破坏了！

[`Mock`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock) 允许你使用 spec 关键字参数来提供一个对象作为 mock 的规格说明。 在 mock 上访问不存在于你的规格说明对象中的方法 / 属性将立即引发一个属性错误。 如果你修改你的规格说明的实现，，那么使用了该类的测试将立即开始失败而不需要你在这些测试中实例化该类。

```py
>>> mock = Mock(spec=SomeClass)
>>> mock.old_method()

Traceback (most recent call last):
   ...
AttributeError: object has no attribute 'old_method'
```

使用规格说明还可以启用对 mock 的调用的更聪明的匹配操作，无论是否有将某些形参作为位置或关键字参数传入:

```py
>>> def f(a, b, c): pass
...
>>> mock = Mock(spec=f)
>>> mock(1, 2, 3)
<Mock name='mock()' id='140161580456576'>
>>> mock.assert_called_with(a=1, b=2, c=3)
```

如果你想要让这些更聪明的匹配操作也适用于 mock 上的方法调用，你可以使用 [auto-speccing](https://docs.python.org/zh-cn/3/library/unittest.mock.html#auto-speccing)。

如果你想要更强形式的规格说明以防止设置任意属性并获取它们那么你可以使用 *spec_set* 来代替 *spec*。

#### 使用 side_effect 返回每个文件的内容

[`mock_open()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.mock_open) 被用来为 [`open()`](https://docs.python.org/zh-cn/3/library/functions.html#open) 方法打补丁。 [`side_effect`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.Mock.side_effect) 可被用来在每次调用中返回一个新的 Mock 对象。 这可被用来返回存储在字典中的每个文件的不同内容:

```py
from unittest.mock import mock_open

DEFAULT = "default"
data_dict = {"file1": "data1",
             "file2": "data2"}

def open_side_effect(name):
    return mock_open(read_data=data_dict.get(name, DEFAULT))()

with patch("builtins.open", side_effect=open_side_effect):
    with open("file1") as file1:
        assert file1.read() == "data1"

    with open("file2") as file2:
        assert file2.read() == "data2"

    with open("file3") as file2:
        assert file2.read() == "default"
```

### patch

它是一个装饰器，需要把你想模拟的函数写在里面，然后在后面的单元测试案例中为它赋一个具体实例，再用 return_value 来指定模拟的这个函数希望返回的结果就可以了，后面就是正常单元测试代码。

mock 提供了三个便捷的装饰器: [`patch()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch), [`patch.object()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch.object) 和 [`patch.dict()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch.dict)。

- `patch` 接受单个字符串，其形式 `package.module.Class.attribute` 指明你要修补的属性。 它还可选择接受一个值用来替换指定的属性（或者类对象等等）。
- `patch.object` 接受一个类和你想要修补的属性名称，并可选择接受要用作补丁的值。

#### 构造函数

`unittest.mock.patch` 可以作为一个函数装饰器，类装饰器，或者上下文管理器（with 语句）

```py
unittest.mock.patch(target, new=DEFAULT, spec=None, create=False, spec_set=None, autospec=None, new_callable=None, **kwargs)
```

- target： 形如 `package.module.ClassName` 的字符串。
    - target 值将会被 import 并创建一个新的对象，所以 target 字符串必须是在当前环境可以 import 的。
    - 需要注意，如果 patch 被作为装饰器的话，只有在被装饰的函数执行时，target 的对象才会被创建，而不是运行装饰器的时候被创建。
- new：声明创建的对象 / 值，如果没有指定，则对于 async 函数会创建一个 AsyncMock 对象，对于其他的，则会创建一个 MagicMock 对象。
    - 如果 `patch()` 是作为一个装饰器，且 new 参数没有指定，则创建的 mock 对象将会作为一个额外（即放在被装饰函数原有的参数之后）的参数传入被装饰的函数。
    - 如果 `patch()` 用在上下文管理器中，则创建的 mock 对象会被上下文管理器返回。
- spec 和 spec_set：会当作参数传入 MagicMock 中。如果创建的是 spec 或 spec_set 对象，可以设置 `spec=True` 或者 `spec_set=True`，以便让 patch 正常运行。
- new_callable：与 new 功能类似，但传入的是一个类或者一个 callable 对象，并会使用此参数创建一个对象，默认情况下，对于 async 函数会创建一个 AsyncMock 对象，对于其他的，则会创建一个 MagicMock 对象。
- create：默认为 False，如果指定为 True，那么当 patch 的对象或函数不存在时会自动创建，当真正的对象在运行过程中被程序创建后就删除 patch 出来的 mock 对象，这个参数特别适用于一些运行时创建的内容。
    - 如果想要 patch 的内容是 `builtin` 内建模块，则不用指定 `create=True` ，patch 会在运行时自动创建。

#### @mock.patch

patch 可以作为一个装饰器为函数创建一个 mock 对象并传入被装饰的函数。如果 patch 装饰的是一个类，那么将会返回一个 MagicMock 对象，当这个类在 test 方法中被实例化时，那么将会返回此 MagicMock 对象的 `return_value` 值

```py
class SomeClass:
    pass

@patch('__main__.SomeClass')
def func(a, b, mock_someclass):
    print(a)
    print(b)
    print(mock_someclass)


if __name__ == '__main__':
    func(2, 3)

'''打印输出
2
3
<MagicMock name='SomeClass' id='1519607444288'>
'''
```

如果 mock 了一个类，对该类的实例对象和真实的 class 进行 `isinstance` 判断，则需要指定 `spec=True` 。

```python
class Class:
    def method(self):
       pass

def func():
    Original = Class
    patcher = patch('__main__.Class', spec=True)
    MockClass = patcher.start()
    instance = MockClass()
    # 如果不指定spec=True，则会抛出异常
    assert isinstance(instance, Original)
    patcher.stop()


if __name__ == '__main__':
    func()
```

patch 默认创建的是 MagicMock 对象，如果想要创建一个指定的对象，就可以使用 `new_callable` 参数。甚至可以使用 `new_callable` 参数在 test case 中重定向输出。

```python
thing = object()
with patch('__main__.thing', new_callable=NonCallableMock) as mock_thing:
    assert thing is mock_thing
    thing()

'''打印输出
Traceback (most recent call last):
  ...
TypeError: 'NonCallableMock' object is not callable
'''

from io import StringIO
def foo():
    print('Something')

@patch('sys.stdout', new_callable=StringIO)
def test(mock_stdout):
    foo()
    assert mock_stdout.getvalue() == 'Something\n'

test()
```

patch 中可以通过传参的方式给 mock 对象设置属性。

```py
>>> patcher = patch('__main__.thing', first='one', second='two')
>>> mock_thing = patcher.start()
>>> mock_thing.first
'one'
>>> mock_thing.second
'two'
```

可以通过字典的方式来配置 mock 对象的属性。

```py
>>> config = {'method.return_value': 3, 'other.side_effect': KeyError}
>>> patcher = patch('__main__.thing', **config)
>>> mock_thing = patcher.start()
>>> mock_thing.method()
3
>>> mock_thing.other()
Traceback (most recent call last):
  ...
KeyError
```

#### @mock.patch.object

patch.object 用来给对象（target 参数）的成员（attribute 参数）进行 “mock”，其参数的用法和 patch 是一样的，且也可以使用参数的形式给创建的 mock 对象添加额外的属性。

如果被装饰的对象是类的话，可以使用 `patch.TEST_PREFIX` 指定哪些方法需要被 “mock”。

```py
@mock.patch.object(类名，“类中函数名”)
```

patch.object 被用来装饰一个函数的时候，那么被创建的 mock 对象会一个额外参数的形式传入被装饰的函数。

```py
@patch.object(SomeClass, 'class_method')
def test(mock_method):
    SomeClass.class_method(3)
    mock_method.assert_called_with(3)

test()
```

```py
from unittest import mock
import unittest

class Count():

    def add(self):
        pass


# test Count class
class TestCount(unittest.TestCase):

    @mock.patch.object(Count, "add")
    def test_add(self, mock_add):
        mock_add.return_value = 13
        result = mock_add()
        self.assertEqual(result,13)
    
    # same as 👇
    def test_add(self):
        with mock.patch.object(Count, "add") as mock_add:
            mock_add.return_value = 13
        result = mock_add()
        self.assertEqual(result,13)

if __name__ == '__main__':
    unittest.main()
```

#### 自上而下原则

如果 patch 多个外部函数，那么调用遵循**自下而上**的规则，比如：

```py
@mock.patch("function_C")
@mock.patch("function_B")
@mock.patch("function_A")
def test_check_cmd_response(self, mock_function_A, mock_function_B, mock_function_C):
    mock_function_A.return_value = "Function A return"
    mock_function_B.return_value = "Function B return"
    mock_function_C.return_value = "Function C return"
 
    self.assertTrue(re.search("A", mock_function_A()))
    self.assertTrue(re.search("B", mock_function_B()))
    self.assertTrue(re.search("C", mock_function_C()))
```

#### patch 的位置

[`patch()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch) 通过（临时性地）修改某一个对象的 *名称* 指向另一个对象来发挥作用。 可以有多个名称指向任意单独对象，因此要让补丁起作用你必须确保已为被测试的系统所使用的名称打上补丁。

基本原则是你要在对象 *被查找* 的地方打补丁，这不一定就是它被定义的地方。 一组示例将有助于厘清这一点。

想像我们有一个想要测试的具有如下结构的项目:

```py
a.py
    -> Defines SomeClass

b.py
    -> from a import SomeClass
    -> some_function instantiates SomeClass
```

现在我们要测试 `some_function` 但我们想使用 [`patch()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch) 来模拟 `SomeClass`。 问题在于当我们导入模块 b 时，我们将必须让它从模块 a 导入 `SomeClass`。 如果我们使用 [`patch()`](https://docs.python.org/zh-cn/3/library/unittest.mock.html#unittest.mock.patch) 来模拟 `a.SomeClass` 那么它将不会对我们的测试造成影响；模块 b 已经拥有对 *真正的* `SomeClass` 的引用因此看上去我们的补丁不会有任何影响。

关键在于对 `SomeClass` 打补丁操作是在它被使用（或它被查找）的地方。 在此情况下实际上 `some_function` 将在模块 b 中查找 `SomeClass`，而我们已经在那里导入了它。 补丁看上去应该是这样:

```py
@patch('b.SomeClass')
```

但是，再考虑另一个场景，其中不是 `from a import SomeClass` 而是模块 b 执行了 `import a` 并且 `some_function` 使用了 `a.SomeClass`。 这两个导入形式都很常见。 在这种情况下我们要打补丁的类将在该模块中被查找因而我们必须改为对 `a.SomeClass` 打补丁:

```py
@patch('a.SomeClass')
```

#### patch 的 start 和 stop 方法

如果不想使用装饰器或 with 语法而直接使用 patch，那么可以使用 patch 的 start 方法和 stop 方法。start 方法能直接返回对应的 mock 对象，而 stop 方法则是取消使用 patch，类似 with 语句的开始和结束。

```py
patcher = patch('package.module.ClassName')
from package import module
original = module.ClassName
new_mock = patcher.start()
assert module.ClassName is not original
assert module.ClassName is new_mock
patcher.stop()
assert module.ClassName is original
assert module.ClassName is not new_mock
```

使用 start 和 stop 方法的另一个典型例子是 test case 的 setUp 和 tearDown 方法。

```python
class MyTest(unittest.TestCase):
    def setUp(self):
        self.patcher1 = patch('package.module.Class1')
        self.patcher2 = patch('package.module.Class2')
        self.MockClass1 = self.patcher1.start()
        self.MockClass2 = self.patcher2.start()

    def tearDown(self):
        self.patcher1.stop()
        self.patcher2.stop()

    def test_something(self):
        assert package.module.Class1 is self.MockClass1
        assert package.module.Class2 is self.MockClass2

MyTest('test_something').run()
```

调用了 start 后一定要记得调用 stop，也可以在最后使用 stopall 方法一次性 stop 所有使用了 start 方法的 patch 对象。

如果怕自己在最后忘记了调用 stop 方法，也可以在调用了 start 方法后，立即调用 `unittest.TestCase.addCleanup()` 方法，此方法会在最后自动调用 stop。

```python
class MyTest(unittest.TestCase):
    def setUp(self):
        patcher = patch('package.module.Class')
        self.MockClass = patcher.start()
        self.addCleanup(patcher.stop)

    def test_something(self):
        assert package.module.Class is self.MockClass
```

#### 一个示例

Count 类中 add_and_multiply 依赖 multiply，由于 multiply 并没有实现，这时候可以使用 mock 替换 multiply：

```py
from unittest import mock
import unittest

class Count():

    def add_and_multiply(self,x, y):
        addition = x + y
        multiple = self.multiply(x, y)
        return (addition, multiple)

    def multiply(self,x, y):
        pass


# test Count class
class TestCount(unittest.TestCase):

    @mock.patch.object(Count, "multiply")
    def test_add(self, mock_multiply):
        mock_multiply. return_value = 40
        count = Count()
        addition,multiple = count.add_and_multiply(5,8)
        self.assertEqual(addition,13)
        self.assertEqual(multiple, 40)

if __name__ == '__main__':
    unittest.main()
```

## assert

### 预览

assertEqual(a,b，[msg=' 测试失败时打印的信息 '])：若 a=b，则测试用例通过

assertNotEqual(a,b，[msg=' 测试失败时打印的信息 '])：若 a != b，则测试用例通过

assertTrue(x，[msg=' 测试失败时打印的信息 '])：若 x 是 True，则测试用例通过

assertFalse(x，[msg=' 测试失败时打印的信息 '])：若 x 是 False，则测试用例通过

assertIs(a,b，[msg=' 测试失败时打印的信息 '])：若 a 是 b，则测试用例通过

assertNotIs(a,b，[msg=' 测试失败时打印的信息 '])：若 a 不是 b，则测试用例通过

assertIsNone(x，[msg=' 测试失败时打印的信息 '])：若 x 是 None，则测试用例通过

assertIsNotNone(x，[msg=' 测试失败时打印的信息 '])：若 x 不是 None，则测试用例通过

assertIn(a,b，[msg=' 测试失败时打印的信息 '])：若 a 在 b 中，则测试用例通过

assertNotIn(a,b，[msg=' 测试失败时打印的信息 '])：若 a 不在 b 中，则测试用例通过

assertIsInstance(a,b，[msg=' 测试失败时打印的信息 '])：若 a 是 b 的一个实例，则测试用例通过

assertNotIsInstance(a,b，[msg=' 测试失败时打印的信息 '])：若 a 不是 b 的实例，则测试用例通过

assertAlmostEqual(a, b)：round(a-b, 7) == 0

assertNotAlmostEqual(a, b)：round(a-b, 7) != 0

assertGreater(a, b)：a > b

assertGreaterEqual(a, b)：a >= b

assertLess(a, b)：a < b

assertLessEqual(a, b)：a <= b

assertRegexpMatches(s, re)：regex.search(s)

assertNotRegexpMatches(s, re)：not regex.search(s)

assertItemsEqual(a, b)：sorted(a) == sorted(b) and works with unhashable objs

assertDictContainsSubset(a, b)：all the key/value pairs in a exist in b

assertMultiLineEqual(a, b)：strings

assertSequenceEqual(a, b)：sequences

assertListEqual(a, b)：lists

assertTupleEqual(a, b)：tuples

assertSetEqual(a, b)：sets or frozensets

assertDictEqual(a, b)：dicts

### assertRaises()

```py
assertRaises(
	exception,  # 待验证异常类型
  callable,  # 待验证方法
	*args,  # 待验证方法参数
	**kwds # 待验证方法参数(dict类型)
)
```

功能说明

- 验证异常测试
- 验证异常（第一个参数）是当调用待测试函数时，在传入相应的测试数据后，如果测试通过，则表明待测试函数抛出了预期的异常，否则测试失败。

下面我们通过一个示例来进行演示，如果验证做除法时抛出除数不能为 0 的异常 ZeroDivisionError。

```python
# _*_ coding:utf-8 _*_

__author__ = '苦叶子'

import unittest
import sys
reload(sys)
sys.setdefaultencoding("utf-8")

# 除法函数
def div(a, b):
    return a/b
    
# 测试用例
class demoRaiseTest(unittest.TestCase):
    def test_raise(self):
        self.assertRaises(ZeroDivisionError, div, 1, 0)
        
# 主函数
if __name__ == '__main__':
    unittest.main()
```

test_raise 方法使用了 assertRaises 方法来断言验证 div 方法除数为零时抛出的异常。

运行 python raise_demo.py 结果如下

```bash
.
-------------------------------------
Ran 1 test in 0.000s

OK
```

你还可以尝试调整下数据，如下：

```ruby
def test_raise(self):
    
    self.assertRaises(ZeroDivisionError, div, 1,1)
```

执行结果如下:

```bash
F
=====================================
FAIL: test_raise (__main__.demoRaiseTest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "raise_demo.py", line 18, in test_raise
    self.assertRaises(ZeroDivisionError, div, 1,1)
AssertionError: ZeroDivisionError not raised

----------------------------------
Ran 1 test in 0.000s
```

## 跳过

在执行测试用例时，有时候有些用例是不需要执行的，直接删除代码是不妥的；unittest 提供了一些跳过指定用例的方法

- `@unittest.skip(reason)`：强制跳转。reason 是跳转原因
- `@unittest.skipIf(condition, reason)`：condition 为 True 的时候跳转
- `@unittest.skipUnless(condition, reason)`：condition 为 False 的时候跳转
- `@unittest.expectedFailure`：如果 test 失败了，这个 test 不计入失败的 case 数目

```py
# coding = utf-8
import unittest
import warnings
from selenium import webdriver
from time import sleep
# 驱动文件路径
driverfile_path = r'D:\coship\Test_Framework\drivers\IEDriverServer.exe'

class CmsLoginTest(unittest.TestCase):
    def setUp(self):
        # 这行代码的作用是忽略一些告警打印
        warnings.simplefilter("ignore", ResourceWarning)
        self.driver = webdriver.Ie(executable_path=driverfile_path)
        self.driver.get("http://172.21.13.83:28080/")

    def tearDown(self):
        self.driver.quit()

    @unittest.skip("用户名密码都为空用例不执行")
    def test_login1(self):
        '''用户名、密码为空'''
        self.driver.find_element_by_css_selector("#imageField").click()
        error_message1 = self.driver.find_element_by_css_selector("[for='loginName']").text
        error_message2 = self.driver.find_element_by_css_selector("[for='textfield']").text
        self.assertEqual(error_message1, '用户名不能为空')
        self.assertEqual(error_message2, '密码不能为空')

    @unittest.skipIf(3 > 2, "3大于2，此用例不执行")
    def test_login3(self):
        '''用户名、密码正确'''
        self.driver.find_element_by_css_selector("[name='admin.loginName']").send_keys("autotest")
        self.driver.find_element_by_css_selector("[name='admin.password']").send_keys("111111")
        self.driver.find_element_by_css_selector("#imageField").click()
        sleep(1)
        self.driver.switch_to.frame("topFrame")
        username = self.driver.find_element_by_css_selector("#nav_top>ul>li>a").text
        self.assertEqual(username,"autotest")

    @unittest.skipUnless(3 < 2,"2没有大于3，此用例不执行")
    def test_login2(self):
        '''用户名正确，密码错误'''
        self.driver.find_element_by_css_selector("[name='admin.loginName']").send_keys("autotest")
        self.driver.find_element_by_css_selector("[name='admin.password']").send_keys("123456")
        self.driver.find_element_by_css_selector("#imageField").click()
        error_message = self.driver.find_element_by_css_selector(".errorMessage").text
        self.assertEqual(error_message, '密码错误,请重新输入!')

    @unittest.expectedFailure
    def test_login4(self):
        '''用户名不存在'''
        self.driver.find_element_by_css_selector("[name='admin.loginName']").send_keys("test007")
        self.driver.find_element_by_css_selector("[name='admin.password']").send_keys("123456")
        self.driver.find_element_by_css_selector("#imageField").click()
        error_message = self.driver.find_element_by_css_selector(".errorMessage").text
        self.assertEqual(error_message, '用户名不存在!')

    def test_login5(self):
        '''用户名为空'''
        self.driver.find_element_by_css_selector("[name='admin.password']").send_keys("123456")
        self.driver.find_element_by_css_selector("#imageField").click()
        error_message = self.driver.find_element_by_css_selector("[for='loginName']").text
        self.assertEqual(error_message, '用户不存在!')

    def test_login6(self):
        '''密码为空'''
        self.driver.find_element_by_css_selector("[name='admin.loginName']").send_keys("autotest")
        self.driver.find_element_by_css_selector("#imageField").click()
        error_message = self.driver.find_element_by_css_selector("[for='textfield']").text
        self.assertEqual(error_message, '密码不能为空')


if __name__ == "__main__":
    unittest.main(verbosity=2)
```

执行结果

```bash
"C:\Program Files\Python36\python.exe" D:/Git/Test_Framework/utils/cmslogin.py
test_login1 (__main__.CmsLoginTest)
用户名、密码为空 ... skipped '用户名密码都为空用例不执行'
test_login2 (__main__.CmsLoginTest)
用户名正确，密码错误 ... skipped '2没有大于3，此用例不执行'
test_login3 (__main__.CmsLoginTest)
用户名、密码正确 ... skipped '3大于2，此用例不执行'
test_login4 (__main__.CmsLoginTest)
用户名不存在 ... expected failure
test_login5 (__main__.CmsLoginTest)
用户名为空 ... FAIL
test_login6 (__main__.CmsLoginTest)
密码为空 ... ok

======================================================================
FAIL: test_login5 (__main__.CmsLoginTest)
用户名为空
----------------------------------------------------------------------
Traceback (most recent call last):
  File "D:/Git/Test_Framework/utils/cmslogin.py", line 71, in test_login5
    self.assertEqual(error_message, '用户不存在!')
AssertionError: '用户名不能为空' != '用户不存在!'
- 用户名不能为空
+ 用户不存在!


----------------------------------------------------------------------
Ran 6 tests in 32.663s

FAILED (failures=1, skipped=3, expected failures=1)

Process finished with exit code 1
```
