# 认识

## 运行

```shell
uvicorn main:app --reload
```

- `main`：`main.py` 文件（一个 Python「模块」）。
- `app`：在 `main.py` 文件中通过 `app = FastAPI()` 创建的对象。
- `--reload`：让服务器在更新代码后重新启动。仅在开发时使用该选项

## 查看 API 文档

交互式文档：`url/docs`

可选的文档：`url/redoc`

# 特性

## 基本格式

```python
from fastapi import FastAPI

app = FastAPI()


@app.get("/") # 路径操作装饰器
async def root(): # 路径操作函数
    return {"message": "Hello World"}
```

## 路径参数

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

## 枚举

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

## 查询参数

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

### 可选参数

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

### 必需、不必需与可选

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

### 查询参数列表

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

## 请求体 request

**请求体**是客户端发送给 API 的数据。**响应体**是 API 发送给客户端的数据。

你的 API 几乎总是要发送**响应**体。但是客户端并不总是需要发送**请求**体。

### 模板

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

### 访问模型属性

```python
@app.post("/items/")
async def create_item(item: Item):
    item_dict = item.dict()
    if item.tax:
        price_with_tax = item.price + item.tax
        item_dict.update({"price_with_tax": price_with_tax})
    return item_dict
```

### 请求体加参数

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

### 多个请求体

#### 多个请求体

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

#### 添加额外请求体 `body`

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

#### 嵌入单个请求体参数

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

#### 总结

- 你可以添加多个请求体参数到路径操作函数中，**即使一个请求只能有一个请求体**。

- 但是 **FastAPI** 会处理它，在函数中为你提供正确的数据，并在路径操作中校验并记录正确的模式。

- 你还可以声明将作为请求体的一部分所接收的单一值。

- 你还可以指示 **FastAPI** 在仅声明了一个请求体参数的情况下，将原本的请求体嵌入到一个键中。

### 请求体字段

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

### 嵌套模型

使用 **FastAPI**，你可以定义、校验、记录文档并使用任意深度嵌套的模型（归功于 Pydantic）。

#### List

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

#### Set

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

#### 嵌套类型

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

#### 特殊的类型和校验

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

#### 带有一组子模型的属性

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

#### 深度嵌套模型

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

#### 纯列表请求体

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

#### 任意 `dict` 构成的请求体

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

> 请记住 **JSON 仅支持将 `str` 作为键**。
>
> 但是 Pydantic 具有自动转换数据的功能。
>
> 这意味着，即使你的 API 客户端只能将字符串作为键发送，只要这些字符串内容仅包含整数，Pydantic 就会对其进行转换并校验。
>
> 然后你接收的名为 `weights` 的 `dict` 实际上将具有 `int` 类型的键和 `float` 类型的值。

### 模型示例

#### `Config` 和 `schema_extra`

可以使用 `Config` 和 `schema_extra` 为 Pydantic 模型声明一个示例

```python
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None

    class Config:
        schema_extra = {
            "example": {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 35.4,
                "tax": 3.2,
            }
        }
```

> 传递的那些额外参数不会添加任何验证，只会添加注释，用于文档的目的。

#### `example` 

或者使用 `example` 为单个字段添加示例

```python
from pydantic import Field

class Item(BaseModel):
    name: str = Field(..., example="Foo")
    description: Optional[str] = Field(None, example="A very nice Item")
    price: float = Field(..., example=35.4)
    tax: Optional[float] = Field(None, example=3.2)

```

不过这样写感觉蛮麻烦的... 

#### `Body` 等的额外参数

可以通过传递额外信息给 `Field` 同样的方式操作`Path`, `Query`, `Body`等。

```python
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        ...,
        example={
            "name": "Foo",
            "description": "A very nice Item",
            "price": 35.4,
            "tax": 3.2,
        },
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

感觉也没必要

### 文件请求

To receive uploaded files, install python-multipart

```shell
pip install python-multipart
```

```python
from fastapi import File, UploadFile
```

```python
@app.post("/files/")
async def create_file(file: bytes = File(...)):
    return {"file_size": len(file)}

@app.post("/uploadfile/")
async def create_upload_file(file: UploadFile = File(...)):
    return {"filename": file.filename}
```

Uploadfile 的属性

- `filename`: A `str` with the original file name that was uploaded (e.g. `myimage.jpg`).
- `content_type`: A `str` with the content type (MIME type / media type) (e.g. `image/jpeg`).
- `file`: This is the actual Python file that you can pass directly to other functions or libraries that expect a "file-like" object.

方法

- `write(data)`: Writes `data` (`str` or `bytes`) to the file.
- `read(size)`: Reads `size` (`int`) bytes/characters of the file.
- `seek(offset)`: Goes to the byte position
- `offset`(`int`) in the file.
    - E.g., `await myfile.seek(0)` would go to the start of the file.
    - This is especially useful if you run `await myfile.read()` once and then need to read the contents again.
- `close()`: Closes the file

As all these methods are `async` methods, you need to "await" them.

For example, inside of an `async` *path operation function* you can get the contents with:

```
contents = await myfile.read()
```

If you are inside of a normal `def` *path operation function*, you can access the `UploadFile.file` directly, for example:

```
contents = myfile.file.read()
```

至于多文件上传

```python
@app.post("/files/")
async def create_files(files: List[bytes] = File(...)):
    return {"file_sizes": [len(file) for file in files]}


@app.post("/uploadfiles/")
async def create_upload_files(files: List[UploadFile] = File(...)):
    return {"filenames": [file.filename for file in files]}
```

## 校验

### 对查询参数的校验

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

**若要声明为必须参数，使用 `...`**

```python
q: str = Query(..., min_length=3)
```

### 声明更多元数据

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

### 别名参数

要添加含有 "`-`" 之类被 python 所禁止的变量名，可以用 `alias` 参数声明一个别名，该别名将用于在 URL 中查找查询参数值：

```python
item_query: Optional[str] = Query(None, alias="item-query")
```

可以传入类似 `http://127.0.0.1:8000/items/?item-query=foobaritems` 的参数了

### 弃用参数

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

### 对路径参数的校验

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

### 数值校验

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

## Cookie 参数

```python
from fastapi import Cookie
```

可以像定义 `Query` 参数和 `Path` 参数一样来定义 `Cookie` 参数

```python
@app.get("/items/")
async def read_items(ads_id: Optional[str] = Cookie(None)):
    return {"ads_id": ads_id}
```

> `Cookie` 、`Path` 、`Query` 是兄弟类，它们都继承自公共的 `Param` 类
>
> 但请记住，当你从 `fastapi` 导入的 `Query`、`Path`、`Cookie` 或其他参数声明函数，这些实际上是返回特殊类的函数。

## Header 参数

```python
from fastapi import Header
```

使用和 `Path`, `Query` and `Cookie` 一样的结构定义 header 参数

```python
@app.get("/items/")
async def read_items(user_agent: Optional[str] = Header(None)):
    return {"User-Agent": user_agent}
```

### 特性

默认情况下, `Header` 将把参数名称的字符从下划线 (`_`) 转换为连字符 (`-`) 来提取并记录 headers

同时，HTTP headers 是大小写不敏感的，因此，因此可以使用标准Python样式(也称为 "snake_case")声明它们

若需要禁用下划线到连字符的自动转换

```python
Header(None, convert_underscores=False)
```

### 接受重复值

相同的 header 具有多个值时，可以在类型声明中使用一个 list 来定义这些情况

比如，为了声明一个 `X-Token` header 可以出现多次，你可以这样写

```python
@app.get("/items/")
async def read_items(x_token: Optional[List[str]] = Header(None)):
    return {"X-Token values": x_token}
```

如果你与*路径操作*通信时发送两个HTTP headers，就像：

```python
X-Token: foo
X-Token: bar
```

响应会是:

```python
{
    "X-Token values": [
        "bar",
        "foo"
    ]
}
```

## 响应 response

### 响应模型 response_model

使用 `response_model` 参数来声明用于响应的模型，也就是要向前端返回的数据类型

这样做的主要目的是**确保私有数据在返回时被过滤掉**

FastAPI 将使用此 `response_model` 来：

- 将输出数据转换为其声明的类型
- 校验数据。
- 在 OpenAPI 的*路径操作*中为响应添加一个 JSON Schema。
- 并在自动生成文档系统中使用

```python
class UserIn(BaseModel):
    username: str
    password: str
    email: EmailStr
    full_name: Optional[str] = None

class UserOut(BaseModel):
    username: str
    email: EmailStr
    full_name: Optional[str] = None

@app.post("/user/", response_model=UserOut)
async def create_user(user: UserIn):
    return user
```

**FastAPI** 将会负责过滤掉未在输出模型中声明的所有数据

####  过滤默认值

响应模型也可以拥有默认值

你可以设置路径操作装饰器的 `response_model_exclude_unset=True` 参数，以便在响应的返回数据中去除默认值

```python
@app.get("/items/{item_id}", response_model=Item, response_model_exclude_unset=True)
```

#### 指定返回的数据

使用路径操作装饰器的 `response_model_include` 和 `response_model_exclude` 参数

```python
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: float = 10.5


items = {
    "foo": {"name": "Foo", "price": 50.2},
    "bar": {"name": "Bar", "description": "The Bar fighters", "price": 62, "tax": 20.2},
    "baz": {
        "name": "Baz",
        "description": "There goes my baz",
        "price": 50.2,
        "tax": 10.5,
    },
}


@app.get(
    "/items/{item_id}/name",
    response_model=Item,
    response_model_include={"name", "description"},
)
async def read_item_name(item_id: str):
    return items[item_id]


@app.get("/items/{item_id}/public", response_model=Item, response_model_exclude={"tax"})
async def read_item_public_data(item_id: str):
    return items[item_id]
```

可以用 set，也可以用 list

#### 多个模型

拥有多个相关的模型是很常见的。

对用户模型来说尤其如此，因为：

- **输入模型**需要拥有密码属性。
- **输出模型**不应该包含密码。
- **数据库模型**很可能需要保存密码的哈希值

下面是应该如何根据它们的密码字段以及使用位置去定义模型的大概思路

```python
from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel, EmailStr

app = FastAPI()

class UserBase(BaseModel):
    username: str
    email: EmailStr
    full_name: Optional[str] = None

class UserIn(UserBase):
    password: str

class UserOut(UserBase):
    pass

class UserInDB(UserBase):
    hashed_password: str

def fake_password_hasher(raw_password: str):
    return "supersecret" + raw_password

def fake_save_user(user_in: UserIn):
    hashed_password = fake_password_hasher(user_in.password)
    user_in_db = UserInDB(**user_in.dict(), hashed_password=hashed_password)
    print("User saved! ..not really")
    return user_in_db

@app.post("/user/", response_model=UserOut)
async def create_user(user_in: UserIn):
    user_saved = fake_save_user(user_in)
    return user_saved
```

最终的结果如下

```python
UserInDB(
    username = user_dict["username"],
    password = user_dict["password"],
    email = user_dict["email"],
    full_name = user_dict["full_name"],
    hashed_password = hashed_password,
)
```

#### Union

你可以将一个响应声明为两种类型的 `Union`，这意味着该响应将是两种类型中的任何一种。

这将在 OpenAPI 中使用 `anyOf` 进行定义。

```python
from typing import Union
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class BaseItem(BaseModel):
    description: str
    type: str

class CarItem(BaseItem):
    type = "car"

class PlaneItem(BaseItem):
    type = "plane"
    size: int

items = {
    "item1": {"description": "All my friends drive a low rider", "type": "car"},
    "item2": {
        "description": "Music is my aeroplane, it's my aeroplane",
        "type": "plane",
        "size": 5,
    },
}

@app.get("/items/{item_id}", response_model=Union[PlaneItem, CarItem])
async def read_item(item_id: str):
    return items[item_id]
```

> 定义一个 Union 类型时，首先包括最详细的类型，然后是不太详细的类型。在上面的示例中，更详细的 PlaneItem 位于 Union[PlaneItem，CarItem] 中的 CarItem 之前

#### 列表形式的响应模型

可以用同样的方式声明由对象列表构成的响应

```python
from typing import List
from fastapi import FastAPI
from pydantic import BaseModel
app = FastAPI()

class Item(BaseModel):
    name: str
    description: str

items = [
    {"name": "Foo", "description": "There comes my hero"},
    {"name": "Red", "description": "It's my aeroplane"},
]

@app.get("/items/", response_model=List[Item])
async def read_items():
    return items
```

#### 任意 dict 构成的响应

你还可以使用一个任意的普通 `dict` 声明响应，仅声明键和值的类型，而不使用 Pydantic 模型。

如果你事先不知道有效的字段/属性名称（对于 Pydantic 模型是必需的），这将很有用。

在这种情况下，你可以使用 `typing.Dict`：

```python
from typing import Dict
from fastapi import FastAPI

app = FastAPI()

@app.get("/keyword-weights/", response_model=Dict[str, float])
async def read_keyword_weights():
    return {"foo": 2.3, "bar": 3.4}
```

### 响应状态码

可以在路径操作器中使用 `status_code` 参数来声明用于响应的 HTTP 状态码

```python
@app.post("/items/", status_code=201)
```

#### 简介

- `100` 及以上状态码用于「消息」响应。你很少直接使用它们。具有这些状态代码的响应不能带有响应体。
- `200` 及以上状态码用于「成功」响应。这些是你最常使用的。
    - `200` 是默认状态代码，它表示一切「正常」。
    - 另一个例子会是 `201`，「已创建」。它通常在数据库中创建了一条新记录后使用。
    - 一个特殊的例子是 `204`，「无内容」。此响应在没有内容返回给客户端时使用，因此该响应不能包含响应体。
- **`300`** 及以上状态码用于「重定向」。具有这些状态码的响应可能有或者可能没有响应体，但 `304`「未修改」是个例外，该响应不得含有响应体。
- `400` 及以上状态码用于「客户端错误」响应。这些可能是你第二常使用的类型。
    - 一个例子是 `404`，用于「未找到」响应。
    - 对于来自客户端的一般错误，你可以只使用 `400`。
- `500` 及以上状态码用于服务器端错误。你几乎永远不会直接使用它们。当你的应用程序代码或服务器中的某些部分出现问题时，它将自动返回这些状态代码之一

#### 便捷变量

可以使用来自 `fastapi.status` 的便捷变量

```python
from fastapi import status

@app.post("/items/", status_code=status.HTTP_201_CREATED)
```

仅仅是为了自动补全...

### 表单数据

When you need to receive form fields instead of JSON, you can use `Form`.

```python
from fastapi import FastAPI, Form

app = FastAPI()

@app.post("/login/")
async def login(username: str = Form(...), password: str = Form(...)):
    return {"username": username}
```

### 文件响应

```python
from fastapi import FastAPI, File, Form, UploadFile

app = FastAPI()

@app.post("/files/")
async def create_file(
    file: bytes = File(...), fileb:UploadFile = File(...), token: str = Form(...)
):
    return {
        "file_size": len(file),
        "token": token,
        "fileb_content_type": fileb.content_type,
    }
```

### 错误处理

使用 `HTTPException` 来向前端返回错误请求

```python
from fastapi import HTTPException
```

```python
items = {"foo": "The Foo Wrestlers"}


@app.get("/items/{item_id}")
async def read_item(item_id: str):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"item": items[item_id]}
```

## 路径修饰器的其他参数

### tags

传递 list 或 str 参数

Tags will be added to the OpenAPI schema and used by the automatic documentation interfaces

```python
@app.post("/items/", response_model=Item, tags=["items"])
async def create_item(item: Item):
    return item


@app.get("/items/", tags=["items"])
async def read_items():
    return [{"name": "Foo", "price": 42}]


@app.get("/users/", tags=["users"])
async def read_users():
    return [{"username": "johndoe"}]
```

### Summary and description

```python
@app.post(
    "/items/",
    response_model=Item,
    summary="Create an item",
    description="Create an item with all the information, name, description, price, tax and a set of unique tags",
)
async def create_item(item: Item):
    return item
```

### Description from docstring

You can write Markdown in the docstring, it will be interpreted and displayed correctly

```python
@app.post("/items/", response_model=Item, summary="Create an item")
async def create_item(item: Item):
    """
    Create an item with all the information:

    - **name**: each item must have a name
    - **description**: a long description
    - **price**: required
    - **tax**: if the item doesn't have tax, you can omit this
    - **tags**: a set of unique tag strings for this item
    """
    return item
```

### Response description

```python
@app.post(
    "/items/",
    response_model=Item,
    summary="Create an item",
    response_description="The created item",
)
```

> Notice that `response_description` refers specifically to the response, the `description` refers to the *path operation* in general.

### deprecated

标记已废弃的 API

```python
@app.get("/elements/", tags=["items"], deprecated=True)
async def read_elements():
    return [{"item_id": "Foo"}]
```

# ORM

使用 sqlalchemy

## 目录格式

数据库操作 Demo：https://www.jianshu.com/p/ca0d29b6e127

```shell
.
└── sql_app
    ├── __init__.py # 声明模块
    ├── crud.py # 增删查改函数
    ├── database.py 
    ├── main.py
    ├── models.py # 数据库表格模板
    └── schemas.py 
```

# 跨域资源共享

跨域资源共享指浏览器中运行的前端拥有与后端通信的 JavaScript 代码，而后端处于与前端不同的「源」的情况。

## 源

源是协议（`http`，`https`）、域（`myapp.com`，`localhost`，`localhost.tiangolo.com`）以及端口（`80`、`443`、`8080`）的组合。

因此，这些都是不同的源：

- `http://localhost`
- `https://localhost`
- `http://localhost:8080`

即使它们都在 `localhost` 中，但是它们使用不同的协议或者端口，所以它们都是不同的「源」。

后端必须有一个「允许的源」列表，才能接收来自前端的请求

可以使用 `"*"`（一个「通配符」）声明这个列表，表示全部都是允许的，但为了一切都能正常工作，最好显式地指定允许的源

## CORSMiddleware

你可以在 **FastAPI** 应用中使用 `CORSMiddleware` 来配置它。

- 导入 `CORSMiddleware`。
- 创建一个允许的源列表（由字符串组成）。
- 将其作为「中间件」添加到你的 **FastAPI** 应用中。

你也可以指定后端是否允许：

- 凭证（授权 headers，Cookies 等）。
- 特定的 HTTP 方法（`POST`，`PUT`）或者使用通配符 `"*"` 允许所有方法。
- 特定的 HTTP headers 或者使用通配符 `"*"` 允许所有 headers。

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = [
    "http://localhost.tiangolo.com",
    "https://localhost.tiangolo.com",
    "http://localhost",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def main():
    return {"message": "Hello World"}
```

**参数**

- `allow_origins` - 一个允许跨域请求的源列表。例如 `['https://example.org', 'https://www.example.org']`。你可以使用 `['*']` 允许任何源。
- `allow_origin_regex` - 一个正则表达式字符串，匹配的源允许跨域请求。例如 `'https://.*\.example\.org'`。
- `allow_methods` - 一个允许跨域请求的 HTTP 方法列表。默认为 `['GET']`。你可以使用 `['*']` 来允许所有标准方法。
- `allow_headers` - 一个允许跨域请求的 HTTP 请求头列表。默认为 `[]`。你可以使用 `['*']` 允许所有的请求头。`Accept`、`Accept-Language`、`Content-Language` 以及 `Content-Type` 请求头总是允许 CORS 请求。
- `allow_credentials` - 指示跨域请求支持 cookies。默认是 `False`。另外，允许凭证时 `allow_origins` 不能设定为 `['*']`，必须指定源。
- `expose_headers` - 指示可以被浏览器访问的响应头。默认为 `[]`。
- `max_age` - 设定浏览器缓存 CORS 响应的最长时间，单位是秒。默认为 `600`。

# 文件结构

```shell
.
├── app
│   ├── __init__.py
│   ├── main.py
│   ├── dependencies.py
│   └── routers
│   │   ├── __init__.py
│   │   ├── items.py
│   │   └── users.py
│   └── internal
│       ├── __init__.py
│       └── admin.py
```

## 路径分离 APIRouter

可以将 `APIRouter` 视为一个「迷你 `FastAPI`」类

```python
from fastapi import APIRouter

router = APIRouter()

@router.get("/users/", tags=["users"])
async def read_users():
    return [{"username": "Rick"}, {"username": "Morty"}]
```

可以在 `APIRouter` 中增添配置，免去将配置项添加到每一个路径操作中的烦恼

-  `prefix`：父级路径
- `tags`：标签
-  `responses`
- `dependencies`：注入的依赖项

> 仍然可以添加*更多*将会应用于特定的*路径操作*的 `tags`，以及一些特定于该*路径操作*的额外 `responses`

```python
router = APIRouter(
    prefix="/items",
    tags=["items"],
    dependencies=[Depends(get_token_header)],
    responses={404: {"description": "Not found"}},
)

fake_items_db = {"plumbus": {"name": "Plumbus"}, "gun": {"name": "Portal Gun"}}

@router.get("/")
async def read_items():
    return fake_items_db

@router.get("/{item_id}")
async def read_item(item_id: str):
    if item_id not in fake_items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"name": fake_items_db[item_id]["name"], "item_id": item_id}
```

## 主体

主题通常位于项目根目录，名字为 `main.py`

```python
from fastapi import Depends, FastAPI
from .dependencies import get_query_token, get_token_header
from .internal import admin
from .routers import items, users

app = FastAPI(dependencies=[Depends(get_query_token)])

app.include_router(users.router)
app.include_router(items.router)
app.include_router(
    admin.router,
    prefix="/admin",
    tags=["admin"],
    dependencies=[Depends(get_token_header)],
    responses={418: {"description": "I'm a teapot"}},
)

# 没必要
@app.get("/")
async def root():
    return {"message": "Hello Bigger Applications!"}
```

>「相对导入」：
>
>```python
>from .routers import items, users
>```
>
>「绝对导入」：
>
>```python
>from app.routers import items, users
>```



## 依赖项

### 声明依赖项

#### 函数式

```python
from typing import Optional
from fastapi import Depends, FastAPI
app = FastAPI()

async def common_parameters(q: Optional[str] = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}

@app.get("/items/")
async def read_items(commons: dict = Depends(common_parameters)):
    return commons

@app.get("/users/")
async def read_users(commons: dict = Depends(common_parameters)):
    return commons
```

只能传给 Depends 一个参数。

且该参数必须是可调用对象，比如函数。

该函数接收的参数和*路径操作函数*的参数一样

#### 对象式

```python
from typing import Optional

from fastapi import Depends, FastAPI

app = FastAPI()


fake_items_db = [{"item_name": "Foo"}, {"item_name": "Bar"}, {"item_name": "Baz"}]


class CommonQueryParams:
    def __init__(self, q: Optional[str] = None, skip: int = 0, limit: int = 100):
        self.q = q
        self.skip = skip
        self.limit = limit


@app.get("/items/")
async def read_items(commons: CommonQueryParams = Depends(CommonQueryParams)):
    response = {}
    if commons.q:
        response.update({"q": commons.q})
    items = fake_items_db[commons.skip : commons.skip + commons.limit]
    response.update({"items": items})
    return response
```

Instead of writing:

```
commons: CommonQueryParams = Depends(CommonQueryParams)
```

... you can also write:

```
commons: CommonQueryParams = Depends()
```

### 子依赖项

```python
from typing import Optional

from fastapi import Cookie, Depends, FastAPI

app = FastAPI()


def query_extractor(q: Optional[str] = None):
    return q


def query_or_cookie_extractor(
    q: str = Depends(query_extractor), last_query: Optional[str] = Cookie(None)
):
    if not q:
        return last_query
    return q


@app.get("/items/")
async def read_query(query_or_default: str = Depends(query_or_cookie_extractor)):
    return {"q_or_cookie": query_or_default}
```

`query_or_cookie_extractor` 的参数：

- 尽管该函数自身是依赖项，但还声明了另一个依赖项（它「依赖」于其他对象）
    - 该函数依赖 `query_extractor`, 并把 `query_extractor` 的返回值赋给参数 `q`
- 同时，该函数还声明了类型是 `str` 的可选 cookie（`last_query`）
    - 用户未提供查询参数 `q` 时，则使用上次使用后保存在 cookie 中的查询

>如果在同一个*路径操作* 多次声明了同一个依赖项，例如，多个依赖项共用一个子依赖项，**FastAPI** 在处理同一请求时，只调用一次该子依赖项。

### 路径操作装饰器依赖项

有时，我们并不需要在*路径操作函数*中使用依赖项的返回值。或者说，有些依赖项不返回值，但仍要执行或解析该依赖项。

对于这种情况，不必在声明*路径操作函数*的参数时使用 `Depends`，而是可以在*路径操作装饰器*中添加一个由 `dependencies` 组成的 `list`。

```python
from fastapi import Depends, FastAPI, Header, HTTPException

app = FastAPI()


async def verify_token(x_token: str = Header(...)):
    if x_token != "fake-super-secret-token":
        raise HTTPException(status_code=400, detail="X-Token header invalid")


async def verify_key(x_key: str = Header(...)):
    if x_key != "fake-super-secret-key":
        raise HTTPException(status_code=400, detail="X-Key header invalid")
    return x_key


@app.get("/items/", dependencies=[Depends(verify_token), Depends(verify_key)])
async def read_items():
    return [{"item": "Foo"}, {"item": "Bar"}]
```

路径操作装饰器依赖项（以下简称为**“路径装饰器依赖项”**）的执行或解析方式和普通依赖项一样，但就算这些依赖项会返回值，它们的值也不会传递给*路径操作函数*。

### 全局依赖项

有时，我们要为整个应用添加依赖项

```python
app = FastAPI(dependencies=[Depends(verify_token), Depends(verify_key)])
```

一些在应用程序的好几个地方所使用的依赖项，可以放在它们自己的 `dependencies` 模块（`app/dependencies.py`）中

## 测试

```python
from fastapi.testclient import TestClient
```

Import `TestClient`.

Create a `TestClient` passing to it your **FastAPI** application.

Create functions with a name that starts with `test_` (this is standard `pytest` conventions).

Use the `TestClient` object the same way as you do with `requests`.

Write simple `assert` statements with the standard Python expressions that you need to check (again, standard `pytest`).

```python
from fastapi import FastAPI
from fastapi.testclient import TestClient

app = FastAPI()


@app.get("/")
async def read_main():
    return {"msg": "Hello World"}


client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```

