# 一、认识

ORM：Object Relational Mapping（对象关系映射）将数据库中的表与类构建映射

- 简洁易读：将数据表抽象为对象（数据模型），更直观易读
- 可移植：封装了多种数据库引擎，面对多个数据库，操作基本一致，代码易维护
- 更安全：有效避免 SQL 注入

数据库与 python 对象的映射

- 数据库表 (table）映射为 Python 的类 (class)，称为 model
- 表的字段 (field) 映射为 Column
- 表的记录 (record）以类的实例 (instance) 来表示

## 1.1 快速入门

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

 ### 1.1.1 创建引擎

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
### 1.1.2 建立对象   

```python
# database.py

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
```

### 1.1.3 声名映射

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

### 1.1.4 建立 Pydantic 模型

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

### 1.1.5 CRUD

**C**reate, **R**ead, **U**pdate, and **D**elete

#### 1）读

```python
from sqlalchemy.orm import Session
from . import models, schemas

def get_user(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.id == user_id).first()

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.User).offset(skip).limit(limit).all()

def create_user(db: Session, user: schemas.UserCreate):
    fake_hashed_password = user.password + "notreallyhashed"
    db_user = models.User(email=user.email, hashed_password=fake_hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_items(db: Session, skip: int = 0, limit: int = 100):

    return db.query(models.Item).offset(skip).limit(limit).all()

def create_user_item(db: Session, item: schemas.ItemCreate, user_id: int):
    db_item = models.Item(**item.dict(), owner_id=user_id)
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

```





## 1.2 概念

| 概念    | 对应               | 说明                 |
| ------- | ------------------ | -------------------- |
| engine  | 连接               | 驱动引擎             |
| session | 连接池、事务、会话 | 由此开始查询         |
| model   | 表                 | 类定义               |
| column  | 列                 |                      |
| query   | 若干行             | 可以链式添加多个文件 |

### 1.2.1 Engine

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

### 1.2.2 Session





