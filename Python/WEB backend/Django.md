# 认识

## 概念

![1](https://mdn.mozillademos.org/files/13931/basic-django.png)

![image-20210410215951265](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210410215951265.png)

- **URLs:** 虽然可以通过单个功能来处理来自每个URL的请求，但是编写单独的视图函数来处理每个资源是更加可维护的。URL映射器用于根据请求URL将HTTP请求重定向到相应的视图。URL映射器还可以匹配出现在URL中的字符串或数字的特定模式，并将其作为数据传递给视图功能。
  
- **View:** 视图 是一个请求处理函数，它接收HTTP请求并返回HTTP响应。视图通过模型访问满足请求所需的数据，并将响应的格式委托给 模板。
  
- **Models:** 模型 是定义应用程序数据结构的Python对象，并提供在数据库中管理（添加，修改，删除）和查询记录的机制。
  
- **Templates:** 模板 是定义文件（例如HTML页面）的结构或布局的文本文件，用于表示实际内容的占位符。一个视图可以使用HTML模板，从数据填充它动态地创建一个HTML页面模型。可以使用模板来定义任何类型的文件的结构; 它不一定是HTML！

## 开始

### 创建项目

```shell
django-admin startproject mysite
```

这行代码将会在当前目录下创建一个 `mysite` 目录。

```
mysite/
    manage.py
    mysite/
        __init__.py
        settings.py
        urls.py
        asgi.py
        wsgi.py
```

### 创建 app

```shell
py manage.py startapp app_name
```

这将会创建一个 app 目录

```
app_name/
    __init__.py
    admin.py  # 数据库后台
    apps.py  # django把项目和app关联起来的文件
    migrations/  # 数据库相关
        __init__.py
    models.py
    tests.py  # 单元测试
    views.py  # 业务逻辑代码
```

### 运行服务器

```shell
python manage.py runserver 0.0.0.0:8000
```

### 生成迁移文件

```python
python manage.py makemigrations
```

为模型的改变生成迁移文件

### 创建模型对应的数据表

```python
python manage.py migrate
```

该命令选中未执行过的迁移，将对模型的更改同步到数据库结构上

### 创建管理账号

```python
python manage.py createsuperuser
```



# urls

`urls.py`：URLconf 文件

```python
from django.contrib import admin
from django.urls import path, include
from app01 import views
urlpatterns = [
    path('admin/', admin.site.urls),
    path('app01/', views.test_view),
    path('app02/', include('app02.urls'))
]
```



# Models

## 认识

- **ORM**

    对象关系映射(Object Relational Mapping)，它的实质就是将关系数据（库）中的业务数据用对象的形式表示出来，并通过面向对象（Object-Oriented）的方式将这些对象组织起来，实现系统业务逻辑的过程

    - 映射(Mapping) —— 把表结构映射成类
    - 对象 —— 像操作类对象一样，操作数据库里的数据

    SQL 语句映射，实现了代码与数据库操作的解耦合，在 Django 中体现在 Models.py 中

- **Model**

    模型是真实数据的简单明确的描述。它包含了储存的数据所必要的字段和行为

# views

每个视图必须要做的只有两件事：返回一个包含被请求页面内容的 [`HttpResponse`](https://docs.djangoproject.com/zh-hans/3.2/ref/request-response/#django.http.HttpResponse) 对象，或者抛出一个异常，比如 [`Http404`](https://docs.djangoproject.com/zh-hans/3.2/topics/http/views/#django.http.Http404) 。至于你还想干些什么，随便你。

你的视图可以从数据库里读取记录，可以使用一个模板引擎（比如 Django 自带的，或者其他第三方的），可以生成一个 PDF 文件，可以输出一个 XML，创建一个 ZIP 文件，你可以做任何你想做的事，使用任何你想用的 Python 库。

Django 只要求返回的是一个 [`HttpResponse`](https://docs.djangoproject.com/zh-hans/3.2/ref/request-response/#django.http.HttpResponse) ，或者抛出一个异常