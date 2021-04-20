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

