# 一、认识

## 1.1 运行

```shell
uvicorn main:app --reload
```

- `main`：`main.py` 文件（一个 Python「模块」）。
- `app`：在 `main.py` 文件中通过 `app = FastAPI()` 创建的对象。
- `--reload`：让服务器在更新代码后重新启动。仅在开发时使用该选项

## 1.2 查看 API 文档

交互式文档：`url/docs`

可选的文档：`url/redoc`

# 二、特点

## 2.1 基本格式

```python
from fastapi import FastAPI

app = FastAPI()


@app.get("/") # 路径操作装饰器
async def root(): # 路径操作函数
    return {"message": "Hello World"}
```

## 2.2 路径参数

```python
@app.get("/items/{item_id}")
async def read_item(item_id): # 无类型
    return {"item_id": item_id}

@app.get("/items/{item_id}")
async def read_item(item_id: int): # 有类型
    return {"item_id": item_id}
```

关于路径顺序：

由于路径操作是按**顺序**依次运行的，你需要确保路径 `/users/me` 声明在路径 `/users/{user_id}`之前

## 2.3 枚举

```python
from enum import Enum
from fastapi import FastAPI	

class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"

app = FastAPI()

@app.get("/models/{model_name}")
async def get_model(model_name: ModelName):
    if model_name == ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}
    if model_name.value == "lenet":
        return {"model_name": model_name, "message": "LeCNN all the images"}
    return {"model_name": model_name, "message": "Have some residuals"}

```

## 2.4 查询参数

声明不属于路径参数的其他函数参数时，它们将被自动解释为"查询字符串"参数

```python
from fastapi import FastAPI

app = FastAPI()

fake_items_db = [{"item_name": "Foo"}, {"item_name": "Bar"}, {"item_name": "Baz"}]

@app.get("/items/")
async def read_item(skip: int = 0, limit: int = 10):
    return fake_items_db[skip : skip + limit]
```

查询字符串是键值对的集合，这些键值对位于 URL 的 `？` 之后，并以 `&` 符号分隔。

```bash
http://127.0.0.1:8000/items/?skip=0&limit=10
```

### 2.4.1 可选参数

通过同样的方式，你可以将它们的默认值设置为 `None` 来声明可选查询参数：

```python
from typing import Optional
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_item(item_id: str, q: Optional[str] = None):
    if q:
        return {"item_id": item_id, "q": q}
    return {"item_id": item_id}
```

在这个例子中，函数参数 `q` 将是可选的，并且默认值为 `None`。

### 2.4.2 必需、不必需与可选

当你想让一个查询参数成为必需的，不声明任何默认值就可以

如果你不想添加一个特定的值，而只是想使该参数成为可选的，则将默认值设置为 `None`

```python
@app.get("/items/{item_id}")
async def read_user_item(
    item_id: str, needy: str, skip: int = 0, limit: Optional[int] = None
):
    item = {"item_id": item_id, "needy": needy, "skip": skip, "limit": limit}
    return item
```

- `needy`，一个必需的 `str` 类型参数。意味着必须传入
- `skip`，一个默认值为 `0` 的 `int` 类型参数。意味着不必须传入，但是会存在
- `limit`，一个可选的 `int` 类型参数。意味着不传入就不存在

### 2.4.3 查询参数列表

当你使用 `Query` 显式地定义查询参数时，你还可以声明它去接收一组值，或换句话来说，接收多个值

```python
q: Optional[List[str]] = Query(None)
```

输入类似于 `http://localhost:8000/items/?q=foo&q=bar` 的 url 即可接收到多个查询值

你还可以定义在没有任何给定值时的默认 `list` 值

```python
q: List[str] = Query(["foo", "bar"])
```

你也可以直接使用 `list` 代替 `List [str]`

```python
q: list = Query([])
```

在这种情况下，将不会检查列表的内容。

例如，`List[int]` 将检查（并记录到文档）列表的内容必须是整数。但是单独的 `list` 不会。

## 2.5 请求体

**请求**体是客户端发送给 API 的数据。**响应**体是 API 发送给客户端的数据。

你的 API 几乎总是要发送**响应**体。但是客户端并不总是需要发送**请求**体。

### 2.5.1 模板

```python
from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None

app = FastAPI()

@app.post("/items/")
async def create_item(item: Item):
    return item
```

1. 导入 Pydantic 的 BaseModel
2. 创建数据模型
    - 将你的数据模型声明为继承自 `BaseModel` 的类。
    - 使用标准的 Python 类型来声明所有属性

3. 将模型声明为参数

### 2.5.2 访问模型属性

```python
@app.post("/items/")
async def create_item(item: Item):
    item_dict = item.dict()
    if item.tax:
        price_with_tax = item.price + item.tax
        item_dict.update({"price_with_tax": price_with_tax})
    return item_dict
```

### 2.5.3 请求体加参数

你可以同时声明路径参数和请求体。

**FastAPI** 将识别出与路径参数匹配的函数参数应**从路径中获取**，而声明为 Pydantic 模型的函数参数应**从请求体中获取**。

```python
@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item): # Item是自己定义的模型
    return {"item_id": item_id, **item.dict()}
```

甚至可以做到**请求体 + 路径参数 + 查询参数**

```python
@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item, q: Optional[str] = None):
    result = {"item_id": item_id, **item.dict()}
    if q:
        result.update({"q": q})
    return result
```

函数参数将依次按如下规则进行识别：

- 如果在**路径**中也声明了该参数，它将被用作路径参数。
- 如果参数属于**单一类型**（比如 `int`、`float`、`str`、`bool` 等）它将被解释为**查询**参数。
- 如果参数的类型被声明为一个 **Pydantic 模型**，它将被解释为**请求体**。

### 2.5.4 多个请求体

#### 1）多个请求体

```python
from typing import Optional

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None


class User(BaseModel):
    username: str
    full_name: Optional[str] = None


@app.put("/items/{item_id}")
async def update_item(item_id: int, item: Item, user: User):
    results = {"item_id": item_id, "item": item, "user": user}
    return results
```

在这种情况下，**FastAPI** 将注意到该函数中有多个**请求体参数（两个 Pydantic 模型参数）**。

因此，它将使用参数名称作为请求体中的键（字段名称），并期望一个类似于以下内容的请求体：

```json
{
    "item": {
        "name": "Foo",
        "description": "The pretender",
        "price": 42.0,
        "tax": 3.2
    },
    "user": {
        "username": "dave",
        "full_name": "Dave Grohl"
    }
}
```

#### 2）添加额外请求体

为了扩展先前的模型，你可能决定除了 `item` 和 `user` 之外，还想在同一请求体中具有另一个键 `importance`。

你可以使用 `Body` 指示 **FastAPI** 将其作为请求体的另一个键进行处理

```python
from typing import Optional

from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None


class User(BaseModel):
    username: str
    full_name: Optional[str] = None



@app.put("/items/{item_id}")

async def update_item(
    item_id: int, item: Item, user: User, importance: int = Body(...)
):
    results = {"item_id": item_id, "item": item, "user": user, "importance": importance}
    return results
```

在这种情况下，**FastAPI** 将期望像这样的请求体：

```json
{
    "item": {
        "name": "Foo",
        "description": "The pretender",
        "price": 42.0,
        "tax": 3.2
    },
    "user": {
        "username": "dave",
        "full_name": "Dave Grohl"
    },
    "importance": 5
}
```

#### 3）嵌入单个请求体参数

假设你只有一个来自 Pydantic 模型 `Item` 的请求体参数 `item`。

默认情况下，**FastAPI** 将直接期望这样的请求体。

但是，如果你希望它期望一个拥有 `item` 键并在值中包含模型内容的 JSON，就像在声明额外的请求体参数时所做的那样，则可以使用一个特殊的 `Body` 参数 `embed`：

```python
item: Item = Body(..., embed=True)
```

比如：

```python
from typing import Optional

from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None


@app.put("/items/{item_id}")
async def update_item(item_id: int, item: Item = Body(..., embed=True)):
    results = {"item_id": item_id, "item": item}
    return results
```

在这种情况下，**FastAPI** 将期望像这样的请求体：

```json
{
    "item": {
        "name": "Foo",
        "description": "The pretender",
        "price": 42.0,
        "tax": 3.2
    }
}
```

而不是：

```json
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2
}
```

#### 4）总结

- 你可以添加多个请求体参数到路径操作函数中，**即使一个请求只能有一个请求体**。

- 但是 **FastAPI** 会处理它，在函数中为你提供正确的数据，并在路径操作中校验并记录正确的模式。

- 你还可以声明将作为请求体的一部分所接收的单一值。

- 你还可以指示 **FastAPI** 在仅声明了一个请求体参数的情况下，将原本的请求体嵌入到一个键中。

### 2.5.7 请求体字段

与使用 `Query`、`Path` 和 `Body` 在*路径操作函数*中声明额外的校验和元数据的方式相同，你可以使用 Pydantic 的 `Field` 在 Pydantic 模型内部声明校验和元数据。

```python
from pydantic import Field
```

```python
class Item(BaseModel):
    name: str
    description: Optional[str] = Field(
        None, title="The description of the item", max_length=300
    )
    price: float = Field(..., gt=0, description="The price must be greater than zero")
    tax: Optional[float] = None
```

`Field` 的工作方式和 `Query`、`Path` 和 `Body` 相同，包括它们的参数等等也完全相同

> 实际上，`Query`、`Path` 和其他你将在之后看到的类，创建的是由一个共同的 `Params` 类派生的子类的对象，该共同类本身又是 Pydantic 的 `FieldInfo` 类的子类。
>
> 请记住当你从 `fastapi` 导入 `Query`、`Path` 等对象时，他们实际上是返回特殊类的函数。

### 2.5.8 嵌套模型

使用 **FastAPI**，你可以定义、校验、记录文档并使用任意深度嵌套的模型（归功于Pydantic）。

#### 1）List

最普通的写法是

```python
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list = [] # Here!
```

这将使 `tags` 成为一个由元素组成的列表。不过它没有声明每个元素的类型

但是 Python 有一种特定的方法来声明具有**子类型**的 list

```python
from typing import List
```

```python
tags: List[str] = []
```

#### 2）Set

使用 `Set` 好处多多

```python
from typing import Set
```

```python
tags: Set[str] = set()
```

- 即使你收到带有重复数据的请求，这些数据也会被转换为一组唯一项。

- 而且，每当你输出该数据时，即使源数据有重复，它们也将作为一组唯一项输出。

- 并且还会被相应地标注 / 记录文档。

#### 3）嵌套类型

Pydantic 模型的每个属性都具有类型。

但是这个类型本身可以是另一个 Pydantic 模型。

因此，你可以声明拥有特定属性名称、类型和校验的深度嵌套的 JSON 对象。

上述这些都可以任意的嵌套

```python
class Image(BaseModel):
    url: str
    name: str


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: Set[str] = []
    image: Optional[Image] = None
```

这意味着 **FastAPI** 将期望类似于以下内容的请求体：

```json
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2,
    "tags": ["rock", "metal", "bar"],
    "image": {
        "url": "http://example.com/baz.jpg",
        "name": "The Foo live"
    }
}
```

#### 3）特殊的类型和校验

除了普通的单一值类型（如 `str`、`int`、`float` 等）外，你还可以使用从 `str` 继承的更复杂的单一值类型。

例如，在 `Image` 模型中我们有一个 `url` 字段，我们可以把它声明为 Pydantic 的 `HttpUrl`，而不是 `str`

```python
from pydantic import HttpUrl
```

```python
class Image(BaseModel):
    url: HttpUrl
    name: str
```

该字符串将被检查是否为有效的 URL，并在 JSON Schema / OpenAPI 文档中进行记录。

#### 4）带有一组子模型的属性

你还可以将 Pydantic 模型用作 `list`、`set` 等的子类型：

```python
from typing import List, Optional, Set

from fastapi import FastAPI
from pydantic import BaseModel, HttpUrl

app = FastAPI()


class Image(BaseModel):
    url: HttpUrl
    name: str


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: Set[str] = set()
    images: Optional[List[Image]] = None


@app.put("/items/{item_id}")
async def update_item(item_id: int, item: Item):
    results = {"item_id": item_id, "item": item}
    return results
```

这将期望（转换，校验，记录文档等）下面这样的 JSON 请求体：

```json
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2,
    "tags": [
        "rock",
        "metal",
        "bar"
    ],
    "images": [
        {
            "url": "http://example.com/baz.jpg",
            "name": "The Foo live"
        },
        {
            "url": "http://example.com/dave.jpg",
            "name": "The Baz"
        }
    ]
}
```

#### 5）深度嵌套模型

你可以定义任意深度的嵌套模型

```python
class Image(BaseModel):
    url: HttpUrl
    name: str


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: Set[str] = set()
    images: Optional[List[Image]] = None


class Offer(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    items: List[Item]
```

#### 6）纯列表请求体

如果你期望的 JSON 请求体的最外层是一个 JSON `array`（即 Python `list`），则可以在路径操作函数的参数中声明此类型，就像声明 Pydantic 模型一样：

```python
images: List[Image]
```

例如：

```python
from typing import List

from fastapi import FastAPI
from pydantic import BaseModel, HttpUrl

app = FastAPI()


class Image(BaseModel):
    url: HttpUrl
    name: str


@app.post("/images/multiple/")
async def create_multiple_images(images: List[Image]):
    return images
```

#### 7）任意 `dict` 构成的请求体

你也可以将请求体声明为使用某类型的键和其他类型值的 `dict`。

无需事先知道有效的字段/属性（在使用 Pydantic 模型的场景）名称是什么。

如果你想接收一些尚且未知的键，这将很有用。

---

其他有用的场景是当你想要接收其他类型的键时，例如 `int`。

这也是我们在接下来将看到的。

在下面的例子中，你将接受任意键为 `int` 类型并且值为 `float` 类型的 `dict`：

```python
from typing import Dict
from fastapi import FastAPI

app = FastAPI()

@app.post("/index-weights/")
async def create_index_weights(weights: Dict[int, float]):
    return weights
```

Tip

> 请记住 JSON 仅支持将 `str` 作为键。
>
> 但是 Pydantic 具有自动转换数据的功能。
>
> 这意味着，即使你的 API 客户端只能将字符串作为键发送，只要这些字符串内容仅包含整数，Pydantic 就会对其进行转换并校验。
>
> 然后你接收的名为 `weights` 的 `dict` 实际上将具有 `int` 类型的键和 `float` 类型的值。

## 2.6 校验

### 2.6.1 对查询参数的校验

除了可以设置参数是否可选，还能对参数设置其他的约束条件

```python
from fastapi import Query

async def read_items(q: Optional[str] = Query(None, min_length=3, max_length=50)):
    # ...
```

其中

```python
q: str = Query(None)
```

使得参数可选，等同于：

```python
q: str = None
```

甚至还能用正则。。。

```python
q: Optional[str] = Query(None, min_length=3, max_length=50, regex="^fixedquery$")
```

默认值可以更换

```python
q: str = Query("fixedquery", min_length=3)
```

若要声明为必须参数，使用 `...`

```python
q: str = Query(..., min_length=3)
```

### 2.6.2 声明更多元数据

你可以添加更多有关该参数的信息。

这些信息将包含在生成的 OpenAPI 模式中，并由文档用户界面和外部工具所使用

**添加 title 与 description**

```python
q: Optional[str] = Query(
        None,
        title="Query string",
        description="Query string for the items to search in the database that have a good match",
        min_length=3,
    )
```

### 2.6.3 别名参数

要添加含有 "`-`" 之类被 python 所禁止的变量名，可以用 `alias` 参数声明一个别名，该别名将用于在 URL 中查找查询参数值：

```python
item_query: Optional[str] = Query(None, alias="item-query")
```

可以传入类似 `http://127.0.0.1:8000/items/?item-query=foobaritems` 的参数了

### 2.6.4 弃用参数

现在假设你不再喜欢此参数。

你不得不将其保留一段时间，因为有些客户端正在使用它，但你希望文档清楚地将其展示为已弃用。

那么将参数 `deprecated=True` 传入 `Query`

```python
q: Optional[str] = Query(
        None,
        alias="item-query",
        title="Query string",
        description="Query string for the items to search in the database that have a good match",
        min_length=3,
        max_length=50,
        regex="^fixedquery$",
        deprecated=True,
    )
```

### 2.6.5 对路径参数的校验

首先，从 `fastapi` 导入 `Path`

```python
from fastapi import FastAPI, Path, Query
```

> 路径参数总是必需的，因为它必须是路径的一部分。
>
> 所以，你应该在声明时使用 `...` 将其标记为必需参数。
>
> 然而，即使你使用 `None` 声明路径参数或设置一个其他默认值也不会有任何影响，它依然会是必需参数

模板如下

```python
@app.get("/items/{item_id}")
async def read_items(
    item_id: int = Path(..., title="The ID of the item to get"),
):
    # ...
```

为了解决 “带有「默认值」的参数放在没有「默认值」的参数之前，Python 将会报错” 的问题，API 中的参数可以自由排布

```python
@app.get("/items/{item_id}")
async def read_items(
    q: str, item_id: int = Path(..., title="The ID of the item to get")
):
    # ...
```

如果不想这样，传递 `*` 作为函数的第一个参数

> Python 不会对该 `*` 做任何事情，但是它将知道之后的所有参数都应作为关键字参数（键值对），也被称为 `kwargs`，来调用。即使它们没有默认值

```python
async def read_items(
    *, item_id: int = Path(..., title="The ID of the item to get"), q: str
):
    # ...
```

### 2.6.6 数值校验

- `gt`：大于（`g`reater `t`han）
- `ge`：大于等于（`g`reater than or `e`qual）
- `lt`：小于（`l`ess `t`han）
- `le`：小于等于（`l`ess than or `e`qual）

```python
async def read_items(
    *,
    item_id: int = Path(..., title="The ID of the item to get", gt=0, le=1000),
    q: str,
):
    # ...
```

