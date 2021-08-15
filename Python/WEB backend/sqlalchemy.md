# 认识

ORM：Object Relational Mapping（对象关系映射）将数据库中的表与类构建映射

- 简洁易读：将数据表抽象为对象（数据模型），更直观易读
- 可移植：封装了多种数据库引擎，面对多个数据库，操作基本一致，代码易维护
- 更安全：有效避免 SQL 注入

数据库与 python 对象的映射

- 数据库表 (table）映射为 Python 的类 (class)，称为 model
- 表的字段 (field) 映射为 Column
- 表的记录 (record）以类的实例 (instance) 来表示

## 快速入门

FastAPI 的文件结构

```python
.
└── sql_app
    ├── __init__.py
    ├── crud.py # 增删查改
    ├── database.py # 创建引擎
    ├── main.py
    ├── models.py # 声明映射
    └── schemas.py # 建立 pydantic 模型
```

 ### 创建引擎

 ```python
 # database.py
 
 from sqlalchemy import create_engine
 # using MySQL
 engine = create_engine('mysql+pymysql://user:pwd@localhost/testdb', pool_recycle=3600)
 # using SQLite
 engine = create_engine("sqlite:///testdb.db")
 ```

或者将数据库链接分离

```python
# database.py

SQLALCHEMY_DATABASE_URL1 = "sqlite:///./sql_app.db"
SQLALCHEMY_DATABASE_URL2 = "postgresql://user:password@postgresserver/db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL1, connect_args={"check_same_thread": False}
) 	# needed only for SQLite
```
### 建立对象   

```python
# database.py

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
```

### 声名映射

声明 Base 实例（在 `database.py` 中）

```python
# database.py

from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()
```

新建表

```python
# models.py

from sqlalchemy import Boolean, Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from .database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)

    items = relationship("Item", back_populates="owner")


class Item(Base):
    __tablename__ = "items"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String, index=True)
    owner_id = Column(Integer, ForeignKey("users.id"))

    owner = relationship("User", back_populates="items")
```

SQLAlchemy 提供了 `backref` 让我们可以只需要定义一个关系：

```python
items = relationship("Item", backref="owner")
```

添加了这个就可以不用再在 `Item` 中定义 `relationship` 了！

### 建立 Pydantic 模型

```python
# schemas.py

from typing import List, Optional
from pydantic import BaseModel

class ItemBase(BaseModel):
    title: str
    description: Optional[str] = None

class ItemCreate(ItemBase): # 创建时的所用的对象
    pass

class Item(ItemBase): # API调用的对象
    id: int
    owner_id: int

    class Config:
        orm_mode = True # 将字典识别为ORM对象

        
class UserBase(BaseModel):
    email: str

class UserCreate(UserBase): # 创建时的所用的对象
    password: str

class User(UserBase): # API调用的对象
    id: int
    is_active: bool
    items: List[Item] = []

    class Config:
        orm_mode = True
```

### CRUD

**C**reate, **R**ead, **U**pdate, and **D**elete

#### 读

详细：https://www.cnblogs.com/jingqi/p/8059673.html

```python
from sqlalchemy.orm import Session
from . import models, schemas

def get_user(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.id == user_id).first()

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.User).offset(skip).limit(limit).all()

def get_items(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Item).offset(skip).limit(limit).all()
```

#### 建

```python
# 把描述的表创建出来
Base.metadata.create_all(engine) # Bas

# 把多个表数据添加到会话
session.add_all(Users)

# 把一个表数据添加到会话
session.add(dog)

# 提交会话
session.commit()
```

```python
def create_user(db: Session, user: schemas.UserCreate):
    fake_hashed_password = user.password + "notreallyhashed"
    db_user = models.User(email=user.email, hashed_password=fake_hashed_password)
    db.add(db_user) # 增加实例到数据库中
    db.commit() # 提交更改
    db.refresh(db_user) # 刷新实例
    return db_user

def create_user_item(db: Session, item: schemas.ItemCreate, user_id: int):
    db_item = models.Item(**item.dict(), owner_id=user_id) # 使用字典传入
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item
```

#### 改

直接改

#### 删

```python
db.delete(user1)
```

删除整个数据库

```pyhton
db.drop_all()
```

### 创建表

```python
from typing import List

from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session

from . import crud, models, schemas
from .database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine) # 正式新建数据库和表（如果原来没有的话）

app = FastAPI()

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email) # 检查用户是否被注册
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user) # 新建用户


@app.get("/users/", response_model=List[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users


@app.get("/users/{user_id}", response_model=schemas.User)
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


@app.post("/users/{user_id}/items/", response_model=schemas.Item)
def create_item_for_user(
    user_id: int, item: schemas.ItemCreate, db: Session = Depends(get_db)
):
    return crud.create_user_item(db=db, item=item, user_id=user_id)


@app.get("/items/", response_model=List[schemas.Item])
def read_items(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    items = crud.get_items(db, skip=skip, limit=limit)
    return items
```

## 概念

| 概念    | 对应               | 说明                 |
| ------- | ------------------ | -------------------- |
| engine  | 连接               | 驱动引擎             |
| session | 连接池、事务、会话 | 由此开始查询         |
| model   | 表                 | 类定义               |
| column  | 列                 |                      |
| query   | 若干行             | 可以链式添加多个文件 |

### Engine

- 位于数据库驱动之上的一个抽象概念，它适配了各种数据库驱动，提供了连接池等功能
- 用法：`engine = create_engine(<数据库连接串>)`
    - 数据库连接串的格式是

        ```python
        dialect+driver://username:password@host:port/database?param
        ```

    - dialect 可以是 `mysql`, `postgresql`, `oracle`, `mssql`, `sqlite`

    - driver：驱动，比如 MySQL 的驱动 pymysql， 如果不填写，就使用默认驱动                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             

    - 再往后就是用户名、密码、地址、端口、数据库、连接参数

    - 例

        ```python
        # MySQL 
        engine = create_engine('mysql+pymysql://scott:tiger@localhost/foo?charset=utf8mb4')
        # PostgreSQL
        engine = create_engine('postgresql+psycopg2://scott:tiger@localhost/mydatabase')
        # Oracle 
        engine = create_engine('oracle+cx_oracle://scott:tiger@tnsname')
        # MS SQL
        engine = create_engine('mssql+pymssql://scott:tiger@hostname:port/dbname')
        # SQLite
        engine = create_engine('sqlite:////absolute/path/to/foo.db')
        ```

### Session

## Column 参数

- ***type***：字段的数据类型	

| Object Name                                                                                               | Description                                                         |
| --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| [**BigInteger**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.BigInteger)     | A type for bigger `int` integers.                                   |
| [**Boolean**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Boolean)           | A bool datatype.                                                    |
| [**Date**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Date)                 | A type for `datetime.date()` objects.                               |
| [**DateTime**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.DateTime)         | A type for `datetime.datetime()` objects.                           |
| [**Enum**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Enum)                 | Generic Enum Type.                                                  |
| [**Float**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Float)               | Type representing floating point types, such as `FLOAT` or `REAL`.  |
| [**Integer**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Integer)           | A type for `int` integers.                                          |
| [**Interval**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Interval)         | A type for `datetime.timedelta()` objects.                          |
| [**LargeBinary**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.LargeBinary)   | A type for large binary byte data.                                  |
| [**MatchType**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.MatchType)       | Refers to the return type of the MATCH operator.                    |
| [**Numeric**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Numeric)           | A type for fixed precision numbers, such as `NUMERIC` or `DECIMAL`. |
| [**PickleType**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.PickleType)     | Holds Python objects, which are serialized using pickle.            |
| [**SchemaType**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.SchemaType)     | Mark a type as possibly requiring schema-level DDL for usage.       |
| [**SmallInteger**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.SmallInteger) | A type for smaller `int` integers.                                  |
| [**String**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.String)             | The base for all string and character types.                        |
| [**Text**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Text)                 | A variably sized string type.                                       |
| [**Time**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Time)                 | A type for `datetime.time()` objects.                               |
| [**Unicode**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.Unicode)           | A variable length Unicode string type.                              |
| [**UnicodeText**](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.UnicodeText)   | An unbounded-length Unicode string type.                            |

| 类型名       | 说明                         |
| ------------ | ---------------------------- |
| Integer      | 普通整数，一般是32位         |
| SmallInteger | 取值范围小的整数，一般是16位 |
| Float        | 浮点数                       |
| Numeric      | 定点数                       |
| String       | 字符串                       |
| Text         | 文本字符串                   |
| Boolean      | 布尔值                       |
| Date         | 日期                         |
| Time         | 时间                         |
| DateTime     | 日期和时间                   |

- ***primary_key***：设置字段是否为主键
- ***unique***：设置字段是否唯一
- ***index***：设置字段是否为索引参数
- ***default***：设置字段默认值
- ***nullable***：设置字段是否可空，默认为 `True`（可空）
- ***autoincrement***：设置字段是否自动递增
- ***comment***：设置字段注释

## query

`Session `的 `query` 函数会返回一个 `Query` 对象

```python
db.query(User).filter(User.id == user_id).first()
```

### get

根据指定主键查询

```python
query.get(id)
```

### filter

- `equals`:

```bash
query.filter(User.name == 'ed')
```

- `not equals`:

```bash
query.filter(User.name != 'ed')
```

- `LIKE`:

```bash
query.filter(User.name.like('%ed%'))
```

- `IN`:

```bash
query.filter(User.name.in_(['ed', 'wendy', 'jack']))

# works with query objects too:
query.filter(User.name.in_(
        session.query(User.name).filter(User.name.like('%ed%'))
))
```

- `NOT IN`:

```bash
query.filter(~User.name.in_(['ed', 'wendy', 'jack']))
```

- `IS NULL`:

```bash
query.filter(User.name == None)

# alternatively, if pep8/linters are a concern
query.filter(User.name.is_(None))
```

- `IS NOT NULL`:

```bash
query.filter(User.name != None)

# alternatively, if pep8/linters are a concern
query.filter(User.name.isnot(None))
```

- `AND`:

```bash
# use and_()
from sqlalchemy import and_
query.filter(and_(User.name == 'ed', User.fullname == 'Ed Jones'))

# or send multiple expressions to .filter()
query.filter(User.name == 'ed', User.fullname == 'Ed Jones')

# or chain multiple filter()/filter_by() calls
query.filter(User.name == 'ed').filter(User.fullname == 'Ed Jones')
```

- `OR`:

```bash
from sqlalchemy import or_
query.filter(or_(User.name == 'ed', User.name == 'wendy'))
```

- `MATCH`:

```bash
query.filter(User.name.match('wendy'))
```

### filter_by

查询指定字段值的结果

```python
query.filter_by(User.name='wang_wu').all() # 查询所有名字为wang_wu的实例
```

### 返回列表(List)和单项(Scalar)

- `all()` 返回一个列表:

```bash
>>> query = session.query(User).filter(User.name.like('%ed')).order_by(User.id)
SQL>>> query.all()
[<User(name='ed', fullname='Ed Jones', password='f8s7ccs')>,
      <User(name='fred', fullname='Fred Flinstone', password='blah')>]
```

- `first()` 返回至多一个结果，而且以单项形式，而不是只有一个元素的tuple形式返回这个结果.

```bash
>>> query.first()
<User(name='ed', fullname='Ed Jones', password='f8s7ccs')>
```

- `one()` 返回且仅返回一个查询结果。当结果的数量不足一个或者多于一个时会报错。

```bash
>>> user = query.one()
Traceback (most recent call last):
...
MultipleResultsFound: Multiple rows were found for one()
```

没有查找到结果时：

```ruby
>>> user = query.filter(User.id == 99).one()
Traceback (most recent call last):
...
NoResultFound: No row was found for one()
```

- `one_or_none()`：从名称可以看出，当结果数量为 0 时返回 `None`， 多于1个时报错
- `scalar()`和`one()` 类似，但是返回单项而不是 tuple

### 嵌入使用SQL

你可以在`Query`中通过`text()`使用SQL语句。例如：

```bash
>>> from sqlalchemy import text
>>> for user in session.query(User).\
...             filter(text("id<224")).\
...             order_by(text("id")).all():
...     print(user.name)
ed
wendy
mary
fred
```

除了上面这种直接将参数写进字符串的方式外，你还可以通过`params()`方法来传递参数

```bash
>>> session.query(User).filter(text("id<:value and name=:name")).\
...     params(value=224, name='fred').order_by(User.id).one()
<User(name='fred', fullname='Fred Flinstone', password='blah')>
```

并且，你可以直接使用完整的SQL语句，但是要注意将表名和列明写正确。

```bash
>>> session.query(User).from_statement(
...                     text("SELECT * FROM users where name=:name")).\
...                     params(name='ed').all()
[<User(name='ed', fullname='Ed Jones', password='f8s7ccs')>]
```

## 关系

外键 (ForeignKey) 始终定义在多的一方

### 一对多

`Child` 为多

```python
class Parent(Base):
    __tablename__ = 'parent'
    id = Column(Integer,primary_key = True)
    children = relationship("Child",backref='parent')

class Child(Base):
    __tablename__ = 'child'
    id = Column(Integer,primary_key = True)
    parent_id = Column(Integer,ForeignKey('parent.id'))
```

### 多对一

`Parent` 为多

```python
class Parent(Base):
    __tablename__ = 'parent'
    id = Column(Integer, primary_key=True)
    child_id = Column(Integer, ForeignKey('child.id'))
    child = relationship("Child", backref="parents")

class Child(Base):
    __tablename__ = 'child'
    id = Column(Integer, primary_key=True)
```

为了建立双向关系,可以在 `relationship()` 中设置 backref，Child 对象就有 parents 属性. 设置 `cascade= ‘all’`，可以级联删除

```python
children = relationship("Child",cascade='all',backref='parent')
```

### 一对一

“一对一“就是“多对一”和“一对多”的一个特例，只需在 `relationship` 加上一个参数 `uselist=False` 替换多的一端即可

从一对多转换到一对一

```python
class Parent(Base):
    __tablename__ = 'parent'
    id = Column(Integer, primary_key=True)
    child = relationship("Child", uselist=False, backref="parent")

class Child(Base):
    __tablename__ = 'child'
    id = Column(Integer, primary_key=True)
	parent_id = Column(Integer, ForeignKey('parent.id'))
```

从多对一转换到一对一

```python
class Parent(Base):
    __tablename__ = 'parent'
    id = Column(Integer, primary_key=True)
    child_id = Column(Integer, ForeignKey('child.id'))
    child = relationship("Child", backref=backref("parent", uselist=False))

class Child(Base):
    __tablename__ = 'child'
    id = Column(Integer, primary_key=True)
```

### 多对多

多对多关系需要一个中间关联表,通过参数 `secondary` 来指定

```python
from sqlalchemy import Table,Text
post_keywords = Table('post_keywords',Base.metadata,
        Column('post_id',Integer,ForeignKey('posts.id')),
        Column('keyword_id',Integer,ForeignKey('keywords.id'))
)

class BlogPost(Base):
    __tablename__ = 'posts'
    id = Column(Integer,primary_key=True)
    body = Column(Text)
    keywords = relationship('Keyword',secondary=post_keywords,backref='posts')

class Keyword(Base):
    __tablename__ = 'keywords'
    id = Column(Integer,primary_key = True)
    keyword = Column(String(50),nullable=False,unique=True)
```

