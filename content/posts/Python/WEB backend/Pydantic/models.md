---
title: "pydantic models"
date: 2022-11-22
author: MelonCholi
draft: false
tags: [Python, 后端, pydantic]
categories: [Python]
---

# models

通过创建一个继承 `BaseModel` 的子类（model）来定义一类对象（defining objects）

模型（model）可以是强类型语言中的类型（types），也可以是 API 接口中的参数

未经验证的 raw data 可以被传入 model，model 会根据自身的的字段定义对 untrusted data 进行验证

> pydantic 不仅仅是一个验证模块（validation library），更是一个解析模块（parsing library），验证只提供对传入数据的类型与约束，而 pydantic 可以保证传出数据的类型与约束都是符合规则的。
>
> *pydantic* is primarily a parsing library, **not a validation library**. Validation is a means to an end: building a model which conforms to the types and constraints provided.
>
> In other words, *pydantic* guarantees the types and constraints of the output model, not the input data

## 基础使用

```py
from pydantic import BaseModel

class User(BaseModel):
    id: int
    name = 'Jane Doe' # has default value, not required then
```

`name` 字段的类型被它的默认值所指出，所以就不用显式地定义了

```py
user = User(id='123') # str was cast to an int
user_x = User(id='123.45') # float was cast to an int
```

聪明的实例化

```py
assert user.__fields_set__ == {'id'}
```

`__fields_set__` 指出了在实例化时传入的字段

`<model>.dict()` 和 `dict(<model>)` 能将 model 转换为字典；不过 `<model>.dict()` 可能会包含一些其他数据

## model 的属性

- `dict()`
    - 返回字典
- `json()`
    -  返回 json 字符串
- `copy()`
    - 返回拷贝（默认浅拷贝 shallow copy）
- `parse_obj()`
    - class method，将一个 dict 转换为 model 的方法
- `parse_raw()`
    - class method，将字符串转换为 model 的方法
- `parse_file()`
    - class method，将文件路径对应的文件转换为 model 的方法，类似 `parse_raw()`
- `from_orm()`
    - class method，将一个 ORM 模型对象转换为 model 的方法
- `schema()`
    - 返回一个 JSON Schema 格式的字典
- `schema_json()`
    - 返回一个 JSON Schema 格式的字符串
- `construct()`
    - class method，生成一个跳过校验的实例
- `__fields_set__`
    - 初始化实例所传入字段的集合
- `__fields__`
    - model 定义字段的集合
- `__config__`
    - model 的 configuration class

## 嵌套 model

```py
from typing import Optional
from pydantic import BaseModel


class Foo(BaseModel):
    count: int
    size: Optional[float] = None


class Bar(BaseModel):
    apple = 'x'
    banana = 'y'


class Spam(BaseModel):
    foo: Foo
    bars: list[Bar]


m = Spam(foo={'count': 4}, bars=[{'apple': 'x1'}, {'apple': 'x2'}])
print(m)
#> foo=Foo(count=4, size=None) bars=[Bar(apple='x1', banana='y'),
#> Bar(apple='x2', banana='y')]
print(m.dict())
"""
{
    'foo': {'count': 4, 'size': None},
    'bars': [
        {'apple': 'x1', 'banana': 'y'},
        {'apple': 'x2', 'banana': 'y'},
    ],
}
"""
```

## ORM Mode

models 支持 ORM 模式

```py
from sqlalchemy import Column, Integer, String
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.ext.declarative import declarative_base
from pydantic import BaseModel, constr

Base = declarative_base()


class CompanyOrm(Base):
    __tablename__ = 'companies'
    id = Column(Integer, primary_key=True, nullable=False)
    public_key = Column(String(20), index=True, nullable=False, unique=True)
    name = Column(String(63), unique=True)
    domains = Column(ARRAY(String(255)))


class CompanyModel(BaseModel):
    id: int
    public_key: constr(max_length=20)
    name: constr(max_length=63)
    domains: list[constr(max_length=255)]

    class Config:
        orm_mode = True


co_orm = CompanyOrm(
    id=123,
    public_key='foobar',
    name='Testing',
    domains=['example.com', 'foobar.com'],
)
print(co_orm)
#> <models_orm_mode_3_9.CompanyOrm object at 0x7fb20cc17790>
co_model = CompanyModel.from_orm(co_orm)
print(co_model)
#> id=123 public_key='foobar' name='Testing' domains=['example.com',
#> 'foobar.com']
```

要点

- `Config` 属性 `orn_mode` 必须为 `True`
- 使用 `.from_orm()` 类方法来创建 model

### 保留字

设置 `Field` 的 `alias` 参数来使用 SQLAlchemy 的保留字

```py
from pydantic import BaseModel, Field
import sqlalchemy as sa
from sqlalchemy.ext.declarative import declarative_base


class MyModel(BaseModel):
    metadata: dict[str, str] = Field(alias='metadata_')

    class Config:
        orm_mode = True


BaseModel = declarative_base()


class SQLModel(BaseModel):
    __tablename__ = 'my_table'
    id = sa.Column('id', sa.Integer, primary_key=True)
    # 'metadata' is reserved by SQLAlchemy, hence the '_'
    metadata_ = sa.Column('metadata', sa.JSON)


sql_model = SQLModel(metadata_={'key': 'val'}, id=1)

pydantic_model = MyModel.from_orm(sql_model)

print(pydantic_model.dict())
#> {'metadata': {'key': 'val'}}
print(pydantic_model.dict(by_alias=True))
#> {'metadata_': {'key': 'val'}}
```

### 嵌套 ORM models

ORM 实例也可以嵌套地传入 model

```py
from pydantic import BaseModel


class PetCls:
    def __init__(self, *, name: str, species: str):
        self.name = name
        self.species = species


class PersonCls:
    def __init__(self, *, name: str, age: float = None, pets: list[PetCls]):
        self.name = name
        self.age = age
        self.pets = pets


class Pet(BaseModel):
    name: str
    species: str

    class Config:
        orm_mode = True


class Person(BaseModel):
    name: str
    age: float = None
    pets: list[Pet]

    class Config:
        orm_mode = True


bones = PetCls(name='Bones', species='dog')
orion = PetCls(name='Orion', species='cat')
anna = PersonCls(name='Anna', age=20, pets=[bones, orion])
anna_model = Person.from_orm(anna) # Recursive ORM instance be parsed
print(anna_model)
#> name='Anna' age=20.0 pets=[Pet(name='Bones', species='dog'),
#> Pet(name='Orion', species='cat')]
```

### 数据绑定

> ORM to model 的原理
>
> Arbitrary classes are processed by *pydantic* using the `GetterDict` class (see [utils.py](https://github.com/pydantic/pydantic/blob/main/pydantic/utils.py)), which attempts to provide a dictionary-like interface to any class. You can customise how this works by setting your own sub-class of `GetterDict` as the value of `Config.getter_dict` (see [config](https://pydantic-docs.helpmanual.io/usage/model_config/)).

You can also customise class validation using [root_validators](https://pydantic-docs.helpmanual.io/usage/validators/#root-validators) with `pre=True`. In this case your validator function will be passed a `GetterDict` instance which you may copy and modify.

The `GetterDict` instance will be called for each field with a sentinel as a fallback (if no other default value is set). Returning this sentinel means that the field is missing. Any other value will be interpreted as the value of the field.

```py
from pydantic import BaseModel
from typing import Any
from pydantic.utils import GetterDict
from xml.etree.ElementTree import fromstring


xmlstring = """
<User Id="2138">
    <FirstName />
    <LoggedIn Value="true" />
</User>
"""


class UserGetter(GetterDict):

    def get(self, key: str, default: Any) -> Any:

        # element attributes
        if key in {'Id', 'Status'}:
            return self._obj.attrib.get(key, default)

        # element children
        else:
            try:
                return self._obj.find(key).attrib['Value']
            except (AttributeError, KeyError):
                return default


class User(BaseModel):
    Id: int
    Status: str | None
    FirstName: str | None
    LastName: str | None
    LoggedIn: bool

    class Config:
        orm_mode = True
        getter_dict = UserGetter


user = User.from_orm(fromstring(xmlstring))
```

## 错误处理

校验过程中，一旦出错，pydantic 将会抛出 `ValidationError` 错误

> 自定义的验证代码不应该抛出 `ValidationError` 错误，而是抛出 `ValueError`、`TypeError` 或 `AssertionError`，这样它们能被 `ValidationError` 捕获到

校验中只会报一次错，`ValidationError` 将包含所有的错误

你可以使用以下方法处理错误 `exception`：

- `e.errors()`
    - 列表形式
- `e.json()`
    - json 形式
- `str(e)`
    - 易读的字符串形式

每个 error 对象都包含：

- `loc`
    - 一个列表，指出**错误位置**
        - 第一个元素指出出错的 field
        - 如果 fields 是一个 sub-model，其下的元素也会被嵌套地展示

- `type`
    - 一个计算机易读的字符串，指出**错误类型**

- `msg`
    - 一个用户易读的**错误说明**

- `ctx`
    - 补充错误信息的上下文

```py
from pydantic import BaseModel, ValidationError, conint


class Location(BaseModel):
    lat = 0.1
    lng = 10.1


class Model(BaseModel):
    is_required: float
    gt_int: conint(gt=42)
    list_of_ints: list[int] = None
    a_float: float = None
    recursive_model: Location = None


data = dict(
    list_of_ints=['1', 2, 'bad'],
    a_float='not a float',
    recursive_model={'lat': 4.2, 'lng': 'New York'},
    gt_int=21,
)

try:
    Model(**data)
except ValidationError as e:
    print(e)
    """
    5 validation errors for Model
    is_required
      field required (type=value_error.missing)
    gt_int
      ensure this value is greater than 42 (type=value_error.number.not_gt;
    limit_value=42)
    list_of_ints -> 2
      value is not a valid integer (type=type_error.integer)
    a_float
      value is not a valid float (type=type_error.float)
    recursive_model -> lng
      value is not a valid float (type=type_error.float)
    """

try:
    Model(**data)
except ValidationError as e:
    print(e.json())
    """
    [
      {
        "loc": [
          "is_required"
        ],
        "msg": "field required",
        "type": "value_error.missing"
      },
      {
        "loc": [
          "gt_int"
        ],
        "msg": "ensure this value is greater than 42",
        "type": "value_error.number.not_gt",
        "ctx": {
          "limit_value": 42
        }
      },
      {
        "loc": [
          "list_of_ints",
          2
        ],
        "msg": "value is not a valid integer",
        "type": "type_error.integer"
      },
      {
        "loc": [
          "a_float"
        ],
        "msg": "value is not a valid float",
        "type": "type_error.float"
      },
      {
        "loc": [
          "recursive_model",
          "lng"
        ],
        "msg": "value is not a valid float",
        "type": "type_error.float"
      }
    ]
    """

```

### 自定义错误

使用 `ValueError`、`TypeError` 或 `AssertionError` 在 `@validator` 装饰的函数中抛出错误

```py
from pydantic import BaseModel, ValidationError, validator


class Model(BaseModel):
    foo: str

    @validator('foo')
    def value_must_equal_bar(cls, v):
        if v != 'bar':
            raise ValueError('value must be "bar"')

        return v


try:
    Model(foo='ber')
except ValidationError as e:
    print(e.errors())
    """
    [
        {
            'loc': ('foo',),
            'msg': 'value must be "bar"',
            'type': 'value_error',
        },
    ]
    """
```

当然，你也可以设计一个错误类，来自定义错误码，消息模版和上下文

```py
from pydantic import BaseModel, PydanticValueError, ValidationError, validator


class NotABarError(PydanticValueError):
    code = 'not_a_bar'
    msg_template = 'value is not "bar", got "{wrong_value}"'


class Model(BaseModel):
    foo: str

    @validator('foo')
    def value_must_equal_bar(cls, v):
        if v != 'bar':
            raise NotABarError(wrong_value=v)
        return v


try:
    Model(foo='ber')
except ValidationError as e:
    print(e.json())
    """
    [
      {
        "loc": [
          "foo"
        ],
        "msg": "value is not \"bar\", got \"ber\"",
        "type": "value_error.not_a_bar",
        "ctx": {
          "wrong_value": "ber"
        }
      }
    ]
    """
```

## helper 函数

pydantic 为 model 提供三个 helper 类方法供其在 parsing data 时使用

- `parse_obj()`
    - 将一个对象转换为 model 的方法
    - 跟 `__init__` 方法很像，只不过它接收一个 dict 而不是关键字参数（说实话，在 `__init__` 里用 `**kwargs` 传字典也能起到相同的作用）
- `parse_raw()`
    - 将字符串转换为 model 的方法
    - str / bytes 都能传，它首先会转换成 json，然后再把 json 传进 `parse_obj()`
    - pickle data 也能传，方法详见示例
- `parse_file()`
    - 将文件路径对应的文件转换为 model 的方法，
    - 它会先读文件，再把结果传进 `parse_raw()`
    - 套娃了属于是

```py
import pickle
from datetime import datetime
from pathlib import Path

from pydantic import BaseModel, ValidationError


class User(BaseModel):
    id: int
    name = 'John Doe'
    signup_ts: datetime = None


m = User.parse_obj({'id': 123, 'name': 'James'})
print(m)
#> id=123 signup_ts=None name='James'

try:
    User.parse_obj(['not', 'a', 'dict'])
except ValidationError as e:
    print(e)
    """
    1 validation error for User
    __root__
      User expected dict not list (type=type_error)
    """

# assumes json as no content type passed
m = User.parse_raw('{"id": 123, "name": "James"}')
print(m)
#> id=123 signup_ts=None name='James'

pickle_data = pickle.dumps({
    'id': 123,
    'name': 'James',
    'signup_ts': datetime(2017, 7, 14)
})
m = User.parse_raw(
    pickle_data, content_type='application/pickle', allow_pickle=True
)
print(m)
#> id=123 signup_ts=datetime.datetime(2017, 7, 14, 0, 0) name='James'

path = Path('data.json')
path.write_text('{"id": 123, "name": "James"}')
m = User.parse_file(path)
print(m)
#> id=123 signup_ts=None name='James'
```

> 来自 pickle 官方文档的警告："The pickle module is not secure against erroneous or maliciously constructed data. Never unpickle data received from an untrusted or unauthenticated source."

### 不经验证地创建 model

 `construct()` 方法允许你不经验证就创建 model，当信息源绝对可靠时，这样做可以提高效率（不验证比验证快 30 倍）

```py
from pydantic import BaseModel


class User(BaseModel):
    id: int
    age: int
    name: str = 'John Doe'


original_user = User(id=123, age=32)

user_data = original_user.dict()
print(user_data)
#> {'id': 123, 'age': 32, 'name': 'John Doe'}
fields_set = original_user.__fields_set__
print(fields_set)
#> {'age', 'id'}

# ...
# pass user_data and fields_set to RPC or save to the database etc.
# ...

# you can then create a new instance of User without
# re-running validation which would be unnecessary at this point:
new_user = User.construct(_fields_set=fields_set, **user_data)
print(repr(new_user))
#> User(id=123, age=32, name='John Doe')
print(new_user.__fields_set__)
#> {'age', 'id'}

# construct can be dangerous, only use it with validated data!:
bad_user = User.construct(id='dog')
print(repr(bad_user))
#> User(id='dog', name='John Doe')
```

`_fields_set` 参数是可选的，它可以准确地区分出**传入的**和**默认赋值的**参数；如果它被忽略，`__fields_set__` 就是这个 model 的所有字段了

## Generic Models

为了方便 model 的复用，pydantic 支持创建 generic models

按照以下步骤去创建一个 generic model

1. 声明一个或多个 `typing.TypeVar` 实例，用于参数化你的 model

2. 声明一个继承自 `pydantic.generics.GenericModel` 和 `typing.Generic` 的 pydantic model，并在其中传入你刚刚声明的 `typing.TypeVar` 实例作为 `typing.Generic` 的参数

3. 在你想要的字段上，使用 `typing.TypeVar` 实例作为标注

以下是一个可复用的 HTTP 响应负载处理类（HTTP response payload wrapper）的例子

```py
from typing import Generic, TypeVar

from pydantic import BaseModel, validator, ValidationError
from pydantic.generics import GenericModel

DataT = TypeVar('DataT')


class Error(BaseModel):
    code: int
    message: str


class DataModel(BaseModel):
    numbers: list[int]
    people: list[str]


class Response(GenericModel, Generic[DataT]):
    data: DataT | None
    error: Error | None

    @validator('error', always=True)
    def check_consistency(cls, v, values):
        if v is not None and values['data'] is not None:
            raise ValueError('must not provide both data and error')
        if v is None and values.get('data') is None:
            raise ValueError('must provide data or error')
        return v


data = DataModel(numbers=[1, 2, 3], people=[])
error = Error(code=404, message='Not found')

print(Response[int](data=1))
#> data=1 error=None
print(Response[str](data='value'))
#> data='value' error=None
print(Response[str](data='value').dict())
#> {'data': 'value', 'error': None}
print(Response[DataModel](data=data).dict())
"""
{
    'data': {'numbers': [1, 2, 3], 'people': []},
    'error': None,
}
"""
print(Response[DataModel](error=error).dict())
"""
{
    'data': None,
    'error': {'code': 404, 'message': 'Not found'},
}
"""
try:
    Response[int](data='value')
except ValidationError as e:
    print(e)
    """
    2 validation errors for Response[int]
    data
      value is not a valid integer (type=type_error.integer)
    error
      must provide data or error (type=value_error)
    """
```

如果要继承一个 GenericModel 并且不替换 `TypeVar` 实例的话，这个字类也必须继承一个 `typing.Generic`

```py
from typing import TypeVar, Generic
from pydantic.generics import GenericModel

TypeX = TypeVar('TypeX')


class BaseClass(GenericModel, Generic[TypeX]):
    X: TypeX


class ChildClass(BaseClass[TypeX], Generic[TypeX]):
    # Inherit from Generic[TypeX]
    pass


# Replace TypeX by int
print(ChildClass[int](X=1))
#> X=1
```

当然，可以部分继承父类的 `TypeVar` 实例，也可以新增 `TypeVar` 实例

```py
from typing import TypeVar, Generic
from pydantic.generics import GenericModel

TypeX = TypeVar('TypeX')
TypeY = TypeVar('TypeY')
TypeZ = TypeVar('TypeZ')


class BaseClass(GenericModel, Generic[TypeX, TypeY]):
    x: TypeX
    y: TypeY


class ChildClass(BaseClass[int, TypeY], Generic[TypeY, TypeZ]):
    z: TypeZ


# Replace TypeY by str
print(ChildClass[str, int](x=1, y='y', z=3))
#> x=1 y='y' z=3
```

还可以用 `__concrete_name__` 方法复写具体子类（concrete subclasses）的名字

```py
from typing import Any, Generic, TypeVar

from pydantic.generics import GenericModel

DataT = TypeVar('DataT')


class Response(GenericModel, Generic[DataT]):
    data: DataT

    @classmethod
    def __concrete_name__(cls: type[Any], params: tuple[type[Any], ...]) -> str:
        return f'{params[0].__name__.title()}Response'


print(repr(Response[int](data=1)))
#> IntResponse(data=1)
print(repr(Response[str](data='a')))
#> StrResponse(data='a')
```

在嵌套 model 中使用相同的 `TypeVar` 实例可以保证一致性

```py
from typing import Generic, TypeVar

from pydantic import ValidationError
from pydantic.generics import GenericModel

T = TypeVar('T')


class InnerT(GenericModel, Generic[T]):
    inner: T


class OuterT(GenericModel, Generic[T]):
    outer: T
    nested: InnerT[T]


nested = InnerT[int](inner=1)
print(OuterT[int](outer=1, nested=nested))
#> outer=1 nested=InnerT[int](inner=1)
try:
    nested = InnerT[str](inner='a')
    print(OuterT[int](outer='a', nested=nested))
except ValidationError as e:
    print(e)
    """
    2 validation errors for OuterT[int]
    outer
      value is not a valid integer (type=type_error.integer)
    nested -> inner
      value is not a valid integer (type=type_error.integer)
    """
```

与那些内置类型（如 `List` 和 `Dict`）类似，在没有被传参之前（如 `List[int]`），GenericModel 的行为会被以下规定所定义：

- 如果在实例化（instantiate） generic model 之前没有参数化（specify parameters）之，传参会被视为 `Any` 类型
- 你可以在参数化（parametrize）model 时传入绑定参数（*bounded* parameters）来添加子类检查（subclass checks）

类似于 `List` 和 `Dict`，任何使用 `TypeVar` 传入 model 的参数都能被更具体的类型替换

```py
from typing import Generic, TypeVar

from pydantic import ValidationError
from pydantic.generics import GenericModel

AT = TypeVar('AT')
BT = TypeVar('BT')


class Model(GenericModel, Generic[AT, BT]):
    a: AT
    b: BT


print(Model(a='a', b='a')) # 参数化之前，随便传，无所谓
#> a='a' b='a'

IntT = TypeVar('IntT', bound=int)
typevar_model = Model[int, IntT]
print(typevar_model(a=1, b=1))
#> a=1 b=1
try:
    typevar_model(a='a', b='a')
except ValidationError as exc:
    print(exc)
    """
    2 validation errors for Model[int, IntT]
    a
      value is not a valid integer (type=type_error.integer)
    b
      value is not a valid integer (type=type_error.integer)
    """

concrete_model = typevar_model[int] # 替换 IntT
print(concrete_model(a=1, b=1))
#> a=1 b=1
```

## model 的动态创建

有些时候，model 的定义直到程序运行时才会完整，pydantic 提供 `create_model` 方法，允许 model 在运行时被创建

```py
from pydantic import BaseModel, create_model

DynamicFoobarModel = create_model('DynamicFoobarModel', foo=(str, ...), bar=123)


class StaticFoobarModel(BaseModel):
    foo: str
    bar: int = 123
```

`StaticFoobarModel` 和  `DynamicFoobarModel` 在这里是完全一样的

动态 model 字段的定义，以下两种均可：

-  `(<type>, <default value>)` 的元组格式
- 一个默认值

 `__config__` 和 `__base__` 这两个特殊参数可以用来自定义 model，比如添加额外字段来扩展 base model 之类的

```py
from pydantic import BaseModel, create_model


class FooModel(BaseModel):
    foo: str
    bar: int = 123


BarModel = create_model(
    'BarModel',
    apple='russet',
    banana='yellow',
    __base__=FooModel,
)
print(BarModel)
#> <class 'pydantic.main.BarModel'>
print(BarModel.__fields__.keys())
#> dict_keys(['foo', 'bar', 'apple', 'banana'])
```

你甚至还能在  `__validators__` 参数中传入字典来实现 validator 的功能（震惊）

```py
from pydantic import create_model, ValidationError, validator


def username_alphanumeric(cls, v):
    assert v.isalnum(), 'must be alphanumeric'
    return v


validators = {
    'username_validator':
    validator('username')(username_alphanumeric)
}

UserModel = create_model(
    'UserModel',
    username=(str, ...),
    __validators__=validators
)

user = UserModel(username='scolvin')
print(user)
#> username='scolvin'

try:
    UserModel(username='scolvi%n')
except ValidationError as e:
    print(e)
    """
    1 validation error for UserModel
    username
      must be alphanumeric (type=assertion_error)
    """
```

## 从 `NamedTuple` 和 `TypedDict` 中创建 model

有时候，你的项目中已经用到了继承自 `NamedTuple` 或 `TypedDict` 的类，但是迁移至 pydantic `BaseModel` 的成本又太大

为了解决这一点，pydantic 提供了 `create_model_from_namedtuple` 和 `create_model_from_typeddict` 这两个方法，他们的使用方法与 `create_model` 相同

```py
from typing_extensions import TypedDict

from pydantic import ValidationError, create_model_from_typeddict


class User(TypedDict):
    name: str
    id: int


class Config:
    extra = 'forbid'


UserM = create_model_from_typeddict(User, __config__=Config)
print(repr(UserM(name=123, id='3')))
#> User(name='123', id=3)

try:
    UserM(name=123, id='3', other='no')
except ValidationError as e:
    print(e)
    """
    1 validation error for User
    other
      extra fields not permitted (type=value_error.extra)
    """
```

## Custom Root Types

通过声明一个 `__root__` 字段，Pydantic models 可以被一个自定义的根类型（custom root type）所定义

根类型可以是任何 pydantic 支持的类型，被 `__root__` 字段的类型标注所指定

除了直接在实例化 model 的时候传入 `__root__` 关键字参数，还能在 `parse_obj` 方法中传入唯一一个值来给 `__root__` 赋值

```py
import json
from pydantic import BaseModel
from pydantic.schema import schema


class Pets(BaseModel):
    __root__: list[str]


print(Pets(__root__=['dog', 'cat']))
#> __root__=['dog', 'cat']
print(Pets(__root__=['dog', 'cat']).json())
#> ["dog", "cat"]
print(Pets.parse_obj(['dog', 'cat']))
#> __root__=['dog', 'cat']
print(Pets.schema())
"""
{
    'title': 'Pets',
    'type': 'array',
    'items': {'type': 'string'},
}
"""
pets_schema = schema([Pets])
print(json.dumps(pets_schema, indent=2))
"""
{
  "definitions": {
    "Pets": {
      "title": "Pets",
      "type": "array",
      "items": {
        "type": "string"
      }
    }
  }
}
"""
```

如果 model 定义了根类型，并且在  `parse_obj` 中传入了一个字典参数，那具体的逻辑如下：

- 如果自定义根类型也恰好是一个映射类型（`Dict` 或 `Mapping`），那参数作为自定义根类型被校验
- 至于其他的自定义根类型
    - 如果字典参数重正好有一个`__root__` 键，那么其对应的值将作为自定义根类型被校验
    - 否则，字典参数本身将作为自定义根类型被校验（并报错）

 ```py
 from pydantic import BaseModel, ValidationError
 
 
 class Pets(BaseModel):
     __root__: list[str]
 
 
 print(Pets.parse_obj(['dog', 'cat']))
 #> __root__=['dog', 'cat']
 print(Pets.parse_obj({'__root__': ['dog', 'cat']}))  # not recommended
 #> __root__=['dog', 'cat']
 
 
 class PetsByName(BaseModel):
     __root__: dict[str, str]
 
 
 print(PetsByName.parse_obj({'Otis': 'dog', 'Milo': 'cat'}))
 #> __root__={'Otis': 'dog', 'Milo': 'cat'}
 try:
     PetsByName.parse_obj({'__root__': {'Otis': 'dog', 'Milo': 'cat'}})
 except ValidationError as e:
     print(e)
     """
     1 validation error for PetsByName
     __root__ -> __root__
       str type expected (type=type_error.str)
     """
 ```

> Calling the `parse_obj` method on a dict with the single key `"__root__"` for non-mapping custom root types is currently supported for backwards compatibility, but is not recommended and may be dropped in a future version.

如果你想要直接取到 `__root__` 字段中的值，或是想要迭代之，你可以实现对应的 `__iter__` 和 `__getitem__` 

```py
from pydantic import BaseModel


class Pets(BaseModel):
    __root__: list[str]

    def __iter__(self):
        return iter(self.__root__)

    def __getitem__(self, item):
        return self.__root__[item]


pets = Pets.parse_obj(['dog', 'cat'])
print(pets[0])
#> dog
print([pet for pet in pets])
#> ['dog', 'cat']
```

## “虚假” 的不可变性质

设置 `allow_mutation = False` 可以让 model 不可变，所有对其值的修改都会抛出错误

```py
from pydantic import BaseModel


class FooBarModel(BaseModel):
    a: str
    b: dict

    class Config:
        allow_mutation = False


foobar = FooBarModel(a='hello', b={'apple': 'pear'})

try:
    foobar.a = 'different'
except TypeError as e:
    print(e)
    #> "FooBarModel" is immutable and does not support item assignment

print(foobar.a)
#> hello
print(foobar.b)
#> {'apple': 'pear'}
foobar.b['apple'] = 'grape'
print(foobar.b)
#> {'apple': 'grape'}
```

> 都是假的，Python 里从来没有严格的不可变性
>
> Immutability in Python is never strict. If developers are determined/stupid they can always modify a so-called "immutable" object.

```py
from pydantic import BaseModel


class FooBarModel(BaseModel):
    a: str
    b: dict

    class Config:
        allow_mutation = False


foobar = FooBarModel(a='hello', b={'apple': 'pear'})

try:
    foobar.a = 'different'
except TypeError as e:
    print(e)
    #> "FooBarModel" is immutable and does not support item assignment

print(foobar.a)
#> hello
print(foobar.b)
#> {'apple': 'pear'}
foobar.b['apple'] = 'grape' # 避免不了修改
print(foobar.b)
#> {'apple': 'grape'}
```

试图修改 `a` 会抛出错误，但是字典字段 `b` 被避免不了被修改的命运

## Abstract Base Classes

model 能跟抽象基类（Abstract Base Classes，ABC）一起使用

```py
import abc
from pydantic import BaseModel


class FooBarModel(BaseModel, abc.ABC):
    a: str
    b: int

    @abc.abstractmethod
    def my_abstract_method(self):
        pass
```

## 字段顺序

字段顺序是非常重要的：

- 校验是按照字段顺序进行的
- 字段顺序在 model schema 中保留
- 字段顺序在校验错误中保留
- 字段顺序在 `.dict()` 和 `.json()` 中保留

从 v1.0 版开始，所有带注释的字段（无论是只带注释的还是带默认值的）都会排在没有注释的字段之前

```py
from pydantic import BaseModel, ValidationError


class Model(BaseModel):
    a: int
    b = 2
    c: int = 1
    d = 0
    e: float


print(Model.__fields__.keys())
#> dict_keys(['a', 'c', 'e', 'b', 'd'])
m = Model(e=2, a=1)
print(m.dict())
#> {'a': 1, 'c': 1, 'e': 2.0, 'b': 2, 'd': 0}
try:
    Model(a='x', b='x', c='x', d='x', e='x')
except ValidationError as e:
    error_locations = [e['loc'] for e in e.errors()]

print(error_locations)
#> [('a',), ('c',), ('e',), ('b',), ('d',)]
```

> 从上面的例子可以看出，把带注释和不带注释的字段混在一起，有时会造成意想不到的结果，这其实是 Python 的缺陷
>
> 即使默认值也能跟类型标注一样来保证顺序，我们还是建议给所有字段都带上类型标注

## 必要字段

给个类型标注就能让一个字段变成必要字段（required fields），或者加个 `...` 省略

```py
from pydantic import BaseModel, Field


class Model(BaseModel):
    a: int
    b: int = ...
    c: int = Field(...)
		# a, b and c are all required
```

但是用省略符号是不被推荐的，跟 mypy 也不是很契合

> 从 v1.2 版本开始，类型注解中只有 nullable（`Optional[...]`, `Union[None, ...]` 和 `Any`）字段和以省略号（...）作为默认值的 nullable 字段，不再是同一个意思了。
>
> 在某些情况下，这可能会导致 v1.2 版本同早期 v1.* 版本不完全向后兼容。

如果你想要一个可以为 `None` 的必要字段，使用 `Optional`（当然在 3.10 变成了 `|`）加 `...`

```py
from pydantic import BaseModel, Field, ValidationError


class Model(BaseModel):
    a: int | None
    b: int | None = ...
    c: int | None = Field(...)


print(Model(b=1, c=2))
#> a=None b=1 c=2
try:
    Model(a=1, b=2)
except ValidationError as e:
    print(e)
    """
    1 validation error for Model
    c
      field required (type=value_error.missing)
    """
```

上面的例子中，`a`, `b` 和 `c` 都能为 `None`，但是 `a` 是可选的，但是 `b` 和 `c` 都是必要的

## 拥有动态默认值的字段

使用 `default_factory` 来创建一个拥有动态默认值的字段

```py
from datetime import datetime
from uuid import UUID, uuid4
from pydantic import BaseModel, Field


class Model(BaseModel):
    uid: UUID = Field(default_factory=uuid4)
    updated: datetime = Field(default_factory=datetime.utcnow)


m1 = Model()
m2 = Model()
print(f'{m1.uid} != {m2.uid}')
#> 6d747bf7-8c49-4bb2-a8bf-85f56bf0ead5 != 998c81a8-450f-4fa5-835d-00a33892989e
print(f'{m1.updated} != {m2.updated}')
#> 2022-09-05 18:00:23.978959 != 2022-09-05 18:00:23.978973
```

## 自动排除的属性

以下划线开头的类变量和类型标注为 `typing.ClassVar` 的属性将被自动从 model 中排除

## model 的私有属性

如果你想要修改或操作 model 实例的内部属性，使用 `PrivateAttr` 来声明之

```py
from datetime import datetime
from random import randint

from pydantic import BaseModel, PrivateAttr


class TimeAwareModel(BaseModel):
    _processed_at: datetime = PrivateAttr(default_factory=datetime.now)
    _secret_value: str = PrivateAttr()

    def __init__(self, **data):
        super().__init__(**data)
        # this could also be done with default_factory
        self._secret_value = randint(1, 5)


m = TimeAwareModel()
print(m._processed_at)
#> 2022-09-05 18:00:24.562238
print(m._secret_value)
#> 5
```

私有属性必须以下划线开头，`_attr` 和 `__attr__` 这两种结构都行

如果 `Config.underscore_attrs_are_private` 为 `True`，任何 non-ClassVar 的下划线属性都会被视为私有

```py
from typing import ClassVar

from pydantic import BaseModel


class Model(BaseModel):
    _class_var: ClassVar[str] = 'class var value'
    _private_attr: str = 'private attr value'

    class Config:
        underscore_attrs_are_private = True


print(Model._class_var)
#> class var value
print(Model._private_attr)
#> <member '_private_attr' of 'Model' objects>
print(Model()._private_attr)
#> private attr value
```

在类创建时，pydantic 构造了充满私有属性的 `__slots__`

## 将数据解析为指定类型

pydantic 提供了一个独立的函数 `parse_obj_as`，它能以点对点的方式完成解析成 model 的操作。

这个函数的行为类似于 `BaseModel.parse_obj`，但是可以与任意的 pydantic 兼容类型一起工作。

当你需要将结果解析为一个非 BaseModel 子类的类型中时，这一点尤其有用

```py
from pydantic import BaseModel, parse_obj_as


class Item(BaseModel):
    id: int
    name: str


# `item_data` could come from an API call, eg., via something like:
# item_data = requests.get('https://my-api.com/items').json()
item_data = [{'id': 1, 'name': 'My Item'}]

items = parse_obj_as(list[Item], item_data)
print(items)
#> [Item(id=1, name='My Item')]
```

这个函数能够将数据解析为 pydantic 能做到的的任何类型。

pydantic 还包括两个类似的独立函数 `parse_file_as` 和 `parse_raw_as`，它们分别与 `BaseModel.parse_file` 和 `BaseModel.parse_raw` 类似

## 数据转换

pydantic 可能会改变 input data 以使其通过类型检查，但有时候，这种行为可能会导致信息的丢失

```py
from pydantic import BaseModel


class Model(BaseModel):
    a: int
    b: float
    c: str


print(Model(a=3.1415, b=' 2.72 ', c=123).dict())
#> {'a': 3, 'b': 2.72, 'c': '123'}
```

这种行为是 pydantic 经过深思熟虑之后的结果，而且一般来说，蛮有用的

不过，严格的类型检查也是部分支持的

## :heart: model 签名

所有的 model 都会根据其字段生成签名（signature）

```py
import inspect
from pydantic import BaseModel, Field


class FooModel(BaseModel):
    id: int
    name: str = None
    description: str = 'Foo'
    apple: int = Field(..., alias='pear')


print(inspect.signature(FooModel))
#> (*, id: int, name: str = None, description: str = 'Foo', pear: int) -> None
```

一个精确的签名对于像 `FastAPI` 和 `hypothesis` 这样经常进行对象**自省**的库是很有用的

生成的签名也将遵循自定义的 `__init__` 函数

```py
import inspect

from pydantic import BaseModel


class MyModel(BaseModel):
    id: int
    info: str = 'Foo'

    def __init__(self, id: int = 1, *, bar: str, **data) -> None:
        """My custom init!"""
        super().__init__(id=id, bar=bar, **data)


print(inspect.signature(MyModel))
#> (id: int = 1, *, bar: str, info: str = 'Foo') -> None
```

为了被签名收纳，字段的名字（name）或者别名（alias）必须是一个合法的 python 标识符，pydantic 会优先选择别名，当别名不合法时则会选择名字

如果一个字段的别名和名称都是无效的标识符，那将添加一个 `**data` 参数。此外，如果 `Config.extra` 为 `Extra.allow`，那么 `**data` 参数将总是出现在签名中。

## 结构化模式匹配

model 支持结构化模式匹配（structural pattern matching），这是 Python 3.10 的新特性

```py
from pydantic import BaseModel


class Pet(BaseModel):
    name: str
    species: str


a = Pet(name='Bones', species='dog')

match a:
    # match `species` to 'dog', declare and initialize `dog_name`
    case Pet(species='dog', name=dog_name):
        print(f'{dog_name} is a dog')
        #> Bones is a dog
    # default case
    case _:
        print('No dog matched')
```

> match-case 语句看起来像是创建了一个全新的 model，然而并没有
>
> 他只是一个用来获取属性、比较它、声明它、初始化它的语法糖
