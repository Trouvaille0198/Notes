---
title: "Python inspect 库"
date: 2022-8-1
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# inspect

未摘录完，详见 https://zhuanlan.zhihu.com/p/290018252

inspect 是用来获取对象的信息，对象包括模块 (往往是一个 py 文件)、类、方法、函数、报错追踪、帧对象和代码对象。

例如，它能用来帮助你检验类的内容，检索一个方法的源代码，提取并格式化函数的参数列表，或者获取用来展示一个 traceback 的所有信息。

## 用法

### `inspect.getmembers(object[,predicate])`

返回由 object 的成员的 `(name,value)` 构成的列表，并且根据 name 进行排序。如果可选参数 predicate 是一个判断条件，只有 value 满足 predicate 条件的成员才会被返回。

```python
class Person:
    
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def get_name(self):
        return self.name
    
    def set_name(self, name):
        self.name = name
    
    def get_age(self):
        return self.age
    
    def set_age(self, age):
        self.age = age
```

返回 Person 类的所有成员：

```python
if __name__ == "__main__":
    import inspect
    print(inspect.getmembers(Person))
```

运行结果为：

```python
[('__class__', type),
 ('__delattr__', <slot wrapper '__delattr__' of 'object' objects>),
 ('__dict__',
  mappingproxy({'__module__': '__main__',
                '__init__': <function __main__.Person.__init__(self, name, age)>,
                'get_name': <function __main__.Person.get_name(self)>,
                'set_name': <function __main__.Person.set_name(self, name)>,
                'get_age': <function __main__.Person.get_age(self)>,
                'set_age': <function __main__.Person.set_age(self, age)>,
                '__dict__': <attribute '__dict__' of 'Person' objects>,
                '__weakref__': <attribute '__weakref__' of 'Person' objects>,
                '__doc__': None})),
 ('__dir__', <method '__dir__' of 'object' objects>),
 ('__doc__', None),
 ('__eq__', <slot wrapper '__eq__' of 'object' objects>),
 ('__format__', <method '__format__' of 'object' objects>),
 ('__ge__', <slot wrapper '__ge__' of 'object' objects>),
 ('__getattribute__', <slot wrapper '__getattribute__' of 'object' objects>),
 ('__gt__', <slot wrapper '__gt__' of 'object' objects>),
 ('__hash__', <slot wrapper '__hash__' of 'object' objects>),
 ('__init__', <function __main__.Person.__init__(self, name, age)>),
 ('__init_subclass__', <function Person.__init_subclass__>),
 ('__le__', <slot wrapper '__le__' of 'object' objects>),
 ('__lt__', <slot wrapper '__lt__' of 'object' objects>),
 ('__module__', '__main__'),
 ('__ne__', <slot wrapper '__ne__' of 'object' objects>),
 ('__new__', <function object.__new__(*args, **kwargs)>),
 ('__reduce__', <method '__reduce__' of 'object' objects>),
 ('__reduce_ex__', <method '__reduce_ex__' of 'object' objects>),
 ('__repr__', <slot wrapper '__repr__' of 'object' objects>),
 ('__setattr__', <slot wrapper '__setattr__' of 'object' objects>),
 ('__sizeof__', <method '__sizeof__' of 'object' objects>),
 ('__str__', <slot wrapper '__str__' of 'object' objects>),
 ('__subclasshook__', <function Person.__subclasshook__>),
 ('__weakref__', <attribute '__weakref__' of 'Person' objects>),
 ('get_age', <function __main__.Person.get_age(self)>),
 ('get_name', <function __main__.Person.get_name(self)>),
 ('set_age', <function __main__.Person.set_age(self, age)>),
 ('set_name', <function __main__.Person.set_name(self, name)>)]
```

返回 person 实例的所有成员：

```python
person = Person("Bob",25)
print(inspect.getmembers(person))
```

运行结果为：

```python
[('__class__', <class '__main__.Person'>), ('__delattr__', <method-wrapper '__delattr__' of Person object at 0x000001FB2AA52B88>), ('__dict__', {'name': 'Bob', 'age': 25}), ('__dir__', <built-in method __dir__ of Person object at 0x000001FB2AA52B88>), ('__doc__', None), ('__eq__', <method-wrapper '__eq__' of Person object at 0x000001FB2AA52B88>), ('__format__', <built-in method __format__ of Person object at 0x000001FB2AA52B88>), ('__ge__', <method-wrapper '__ge__' of Person object at 0x000001FB2AA52B88>), ('__getattribute__', <method-wrapper '__getattribute__' of Person object at 0x000001FB2AA52B88>), ('__gt__', <method-wrapper '__gt__' of Person object at 0x000001FB2AA52B88>), ('__hash__', <method-wrapper '__hash__' of Person object at 0x000001FB2AA52B88>), ('__init__', <bound method Person.__init__ of <__main__.Person object at 0x000001FB2AA52B88>>), ('__init_subclass__', <built-in method __init_subclass__ of type object at 0x000001FB2903C508>), ('__le__', <method-wrapper '__le__' of Person object at 0x000001FB2AA52B88>), ('__lt__', <method-wrapper '__lt__' of Person object at 0x000001FB2AA52B88>), ('__module__', '__main__'), ('__ne__', <method-wrapper '__ne__' of Person object at 0x000001FB2AA52B88>), ('__new__', <built-in method __new__ of type object at 0x00007FFE21D67B30>), ('__reduce__', <built-in method __reduce__ of Person object at 0x000001FB2AA52B88>), ('__reduce_ex__', <built-in method __reduce_ex__ of Person object at 0x000001FB2AA52B88>), ('__repr__', <method-wrapper '__repr__' of Person object at 0x000001FB2AA52B88>), ('__setattr__', <method-wrapper '__setattr__' of Person object at 0x000001FB2AA52B88>), ('__sizeof__', <built-in method __sizeof__ of Person object at 0x000001FB2AA52B88>), ('__str__', <method-wrapper '__str__' of Person object at 0x000001FB2AA52B88>), ('__subclasshook__', <built-in method __subclasshook__ of type object at 0x000001FB2903C508>), ('__weakref__', None), ('age', 25), ('get_age', <bound method Person.get_age of <__main__.Person object at 0x000001FB2AA52B88>>), ('get_name', <bound method Person.get_name of <__main__.Person object at 0x000001FB2AA52B88>>), ('name', 'Bob'), ('set_age', <bound method Person.set_age of <__main__.Person object at 0x000001FB2AA52B88>>), ('set_name', <bound method Person.set_name of <__main__.Person object at 0x000001FB2AA52B88>>)]
```

现在我们考虑 predicate 这个参数。根据官方文档的意思，我们可以写一个函数，如果成员的值能够让该函数返回 True，则 getmembers 可以返回该成员，否则则不返回。

还是上面的例子，如果我们想返回值为字符串的成员，则可以写如下的代码：

```python
def is_string(x):
    if isinstance(x,str):
        return True
    else:
        return False
print(inspect.getmembers(person,is_string))
```

运行结果为：

```python
[('__module__', '__main__'), ('name', 'Bob')]
```

### inspect.getmodulename(path)

通过输入一个路径返回模块名称。在 Python 中，一个 py 文件就是一个 module，这需要与包 (package) 相区别，如果输入的 path 是一个 package，则该方法会返回 None。

例如我们返回 `D:\Software\Anaconda3\Lib\site-packages\sklearn\cluster\_bicluster.py` 的模块名：

```python
import inspect
path = r"D:\Software\Anaconda3\Lib\site-packages\sklearn\cluster\_bicluster.py"
print(inspect.getmodulename(path))
```

运行结果为：

```python
'_bicluster'
```

此时我们将路径变成 sklearn 文件夹（是 package 而不是 module)：

```python
import inspect
path = r"D:\Software\Anaconda3\Lib\site-packages\sklearn"
print(inspect.getmodulename(path))
```

运行结果为：

```python
None
```

### 其他

1. `inspect.ismodule(object)`
   - 如果 object 是一个 module 就返回 True，反之则返回 False。
2. `inspect.isclass(object)`
   - 如果 object 是一个 class 就返回 True，反之则返回 False。

3. `inspect.ismethod(object)`
   - 如果 object 是一个方法则返回 True，反之则返回 False。

此外还有一系列的 is 开头的方法，包括：isfunction, isgeneratorfunction, isgenerator, iscoroutinefunction, iscoroutine, isawaitable, isasyncgenfunction, isasyncgen, istraceback 等。

除了 is 开头的一系列方法外，还有一系列 get 开头的方法，这里不再赘述，可自行查询官方文档。我们将关注点转向 inspect 的其他对象，包括：

1. Signatrure object
2. Parameter
3. BoundArguments
