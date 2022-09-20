---
title: "Python unittest 库"
date: 2022-09-15
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# unittest

## Mock

> 更详细的介绍：https://www.cnblogs.com/guyuyun/p/14880885.html

mock 允许用模拟对象替换系统中真实对象，并对它们已使用的方式进行断言。

在进行单元测试的时候，会遇到以下问题：

- 接口的依赖
- 外部接口调用

测试环境非常复杂。

且单元测试应该只针对当前单元进行测试, 所有的内部或外部的依赖应该是稳定的, 已经在别处进行测试过的。使用 mock 就可以对外部依赖组件实现进行模拟并且替换掉, 从而使得单元测试将焦点只放在当前的单元功能。

例如对于以下代码，想要针对函数 func_a 写一个简单的单元测试：

```python
import unittest


def func_c(arg1, arg2):
    a_dict = {}
    # 其他代码
    return a_dict


def func_b(arg3, arg4):
    b_list = []
    a_arg1 = None
    a_arg2 = None
    # 其他代码
    a_dict = func_c(a_arg1, a_arg2)
    # 其他代码
    return b_list


def func_a():
    b_list = func_b('111', '222')
    if 'aaa' in b_list:
        return False

    return True


class FuncTest(unittest.TestCase):
    def test_func_a(self):
        assert func_a()
```

但是这样的话，函数 func_b 和 func_c 的逻辑都需要一起测试，在单元测试中这明显是不合理的，对于想要测试的函数 func_a，里面所使用到的其他函数或接口，我们只需要关心它的返回值即可，保证当前测试的函数按它自己的逻辑运行，所以可以写成下面这样：

```python
import unittest


def mock_func_b(arg3, arg4):
    return ['bbb', 'ccc']


def func_a():
    # 使用一个模拟的mock_func_b代替真正的函数func_b
    # 这个mock_func_b不需要关心具体实现逻辑，只关心返回值
    b_list = mock_func_b('111', '222')
    if 'aaa' in b_list:
        return False

    return True


class FuncTest(unittest.TestCase):
    def test_func_a(self):
        assert func_a()
```

注意，模拟的 mock_func_b 并不需要保证 func_a 中所有的可能分支和逻辑都执行一次，单元测试更多的是验证函数或接口（比如这里的 func_a）是否与设计相符、发现代码实现与需求中存在的错误、修改代码时是否引入了新的错误等。但是这里的写法也有很大的问题，一个功能模块中使用的函数或接口通常来讲其实并不少、也没有这里这么简单，如果涉及的接口都要重新写一个 mock 对象（如 mock_func_b），那单元测试的工作将会变得非常繁重和复杂，所以 unittest 中的 mock 模块派上了用场，这个模块也正如它的名称一样，可以模拟各种对象。

```3python
import unittest
from unittest import mock


def func_a():
    # 创建一个mock对象，return_value表示在该对象被执行时返回指定的值
    mock_func_b = mock.Mock(return_value=['bbb', 'ccc'])
    b_list = mock_func_b('111', '222')
    if 'aaa' in b_list:
        return False

    return True


class FuncTest(unittest.TestCase):
    def test_func_a(self):
        assert func_a()
```

#### 基本使用

##### return_vaule 

mock 对象的 return_vaule 的作用：它将忽略 mock 对象的行为，指定其返回值。

modular.py

```py
class Count():

    def add(self):
        pass
```

mock_demo01.py

```py
from unittest import mock
import unittest

from modular import Count

# test Count class
class TestCount(unittest.TestCase):

    def test_add(self):
        count = Count()
        count.add = mock.Mock(return_value=13)
        result = count.add(8,5)
        self.assertEqual(result,13)

if __name__ == '__main__':
    unittest.main()
```

假设 Count 计算类没有实现，原本 add() 方法要实现两数相加。但这个功能还没有完成。这时就可以借助 mock 对其进行测试。　　

count = Count()

首先，调用被测试类 Count() 。

count.add = mock.Mock(return_value=7)

通过 Mock 类模拟被调用的方法 add()方法，return_value 定义 add()方法的返回值。

result = count.add(2,5)

接下来，相当于在正常的调用 add()方法，传两个参数 2 和 5，然后会得到相加的结果 7。然后，7 的结果是我们在上一步就预先设定好的。

self.assertEqual(result,7)

最后，通过 assertEqual()方法断言，返回的结果是否是预期的结果 7。

#### side_effect

mock 对象的 side_effect 的作用：通过 side_effect 指定 mock 对象的副作用，这个副作用就是当你调用这个 mock 对象时会调用的函数,也可以选择抛出一个异常，来对程序的错误状态进行测试。

```py
from unittest.mock import Mock


def say_hello(word):
    print(f"Hello {word}")


mock=Mock()
# 指定为函数
mock.side_effect  = say_hello
mock('china')

# 指定为异常
mock.side_effect  = KeyError('This is b') #Exception("Raise Exception")
mock()
```

另外也可以通过为 side_effect 指定一个列表，这样在每次调用时会依次返回，如下：

```py
from unittest.mock import Mock


mock=Mock(side_effect = [1, 2, 3])
print(mock())
print(mock())
print(mock())
```

#### patch 装饰器

它是一个装饰器，需要把你想模拟的函数写在里面，然后在后面的单元测试案例中为它赋一个具体实例，再用 return_value 来指定模拟的这个函数希望返回的结果就可以了，后面就是正常单元测试代码。

```py
@mock.pathc.object(类名，“类中函数名”)
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
        mock_add. return_value = 13
        result = mock_add()
        self.assertEqual(result,13)

if __name__ == '__main__':
    unittest.main()
```

@mock.pathc(模块名，“函数名”)

linux_tool.py

```py
import re
 
def send_shell_cmd():
    return "Response from send_shell_cmd function"
 
def check_cmd_response():
    response = send_shell_cmd()
    print("response: {}".format(response))
    return re.search(r"mock_send_shell_cmd", response)
```

测试代码：

```py
from unittest import TestCase, mock
import linux_tool
 
class TestLinuxTool(TestCase):
    def setUp(self):
        pass
 
    def tearDown(self):
        pass
 
    @mock.patch("linux_tool.send_shell_cmd")
    def test_check_cmd_response(self, mock_send_shell_cmd):
        mock_send_shell_cmd.return_value = "Response from emulated mock_send_shell_cmd function"
 
        status = linux_tool.check_cmd_response()
        print("check result: %s" % status)
        self.assertTrue(status)
```

如果 patch 多个外部函数，那么调用遵循自下而上的规则，比如：

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

assertEqual(a,b，[msg='测试失败时打印的信息'])：若 a=b，则测试用例通过

assertNotEqual(a,b，[msg='测试失败时打印的信息'])：若 a != b，则测试用例通过

assertTrue(x，[msg='测试失败时打印的信息'])：若 x 是 True，则测试用例通过

assertFalse(x，[msg='测试失败时打印的信息'])：若 x 是 False，则测试用例通过

assertIs(a,b，[msg='测试失败时打印的信息'])：若 a 是 b，则测试用例通过

assertNotIs(a,b，[msg='测试失败时打印的信息'])：若 a 不是 b，则测试用例通过

assertIsNone(x，[msg='测试失败时打印的信息'])：若 x 是 None，则测试用例通过

assertIsNotNone(x，[msg='测试失败时打印的信息'])：若 x 不是 None，则测试用例通过

assertIn(a,b，[msg='测试失败时打印的信息'])：若 a 在 b 中，则测试用例通过

assertNotIn(a,b，[msg='测试失败时打印的信息'])：若 a 不在 b 中，则测试用例通过

assertIsInstance(a,b，[msg='测试失败时打印的信息'])：若 a 是 b 的一个实例，则测试用例通过

assertNotIsInstance(a,b，[msg='测试失败时打印的信息'])：若 a 不是 b 的实例，则测试用例通过

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
