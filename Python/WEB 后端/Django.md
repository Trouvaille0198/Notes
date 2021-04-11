# 一、认识

## 1.1 概念

![1](https://mdn.mozillademos.org/files/13931/basic-django.png)

![image-20210410215951265](http://image.trouvaille0198.top/image-20210410215951265.png)

- **URLs:** 虽然可以通过单个功能来处理来自每个URL的请求，但是编写单独的视图函数来处理每个资源是更加可维护的。URL映射器用于根据请求URL将HTTP请求重定向到相应的视图。URL映射器还可以匹配出现在URL中的字符串或数字的特定模式，并将其作为数据传递给视图功能。
     
- **View:** 视图 是一个请求处理函数，它接收HTTP请求并返回HTTP响应。视图通过模型访问满足请求所需的数据，并将响应的格式委托给 模板。
     
- **Models:** 模型 是定义应用程序数据结构的Python对象，并提供在数据库中管理（添加，修改，删除）和查询记录的机制。
     
- **Templates:** 模板 是定义文件（例如HTML页面）的结构或布局的文本文件，用于表示实际内容的占位符。一个视图可以使用HTML模板，从数据填充它动态地创建一个HTML页面模型。可以使用模板来定义任何类型的文件的结构; 它不一定是HTML！

## 1.2 开始

### 1.2.1 创建项目

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

### 1.2.2 创建 app

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

### 1.2.3 运行服务器

```shell
python manage.py runserver 0.0.0.0:8000
```

# 二、

# 三、ORM

SQL 语句映射，实现了代码与数据库操作的解耦合，在 Django 中体现在 Models.py 中

