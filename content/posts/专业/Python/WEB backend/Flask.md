---
title: "Flask"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [Python,后端]
categories: [Python]
---

# Flask

## 例子

### 初始化

```python
from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello, World!'


app.run(debug=True) # 自动以调试方式运行
```

若想要在命令行中控制运行

```shell
$ set FLASK_APP=hello.py
$ flask run
```

若想要其他机器访问

```python
app.run(host=0.0.0.0)
```

### 路由

```python
@app.route('/')
def hello_world():
    return 'Hello, World!'


@app.route('/hello/<anything>')
def hello_anything(anything):
    return 'Hello %s' % anything


@app.route('/plus/<int:number>')
def wow_number(number):
    return '%s plus %s is %s' % (number, number, (number+number))


@app.route('/json/<string:data>')
def json(data):
    return {'data': data}
```

| `string` | （缺省值） 接受任何不包含斜杠的文本 |
| -------- | ----------------------------------- |
| `int`    | 接受正整数                          |
| `float`  | 接受正浮点数                        |
| `path`   | 类似 `string` ，但可以包含斜杠      |
| `uuid`   | 接受 UUID 字符串                    |

#### 唯一的 URL 与重定向

以下两条规则的不同之处在于是否使用尾部的斜杠。:

```python
@app.route('/projects/')
def projects():
    return 'The project page'

@app.route('/about')
def about():
    return 'The about page'
```

- `projects` 的 URL 是中规中矩的，尾部有一个斜杠，看起来就如同**一个文件夹**。 访问一个没有斜杠结尾的 URL 时 Flask 会自动进行重定向，帮你在尾部加上一个斜杠。

- `about` 的 URL 没有尾部斜杠，因此其行为表现与**一个文件**类似。如果访问这个 URL 时添加了尾部斜杠就会得到一个 404 错误。这样可以**保持 URL 唯一**，并帮助搜索引擎避免重复索引同一页面。

#### Flask HTTP方法

```python
from flask import request

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        return do_the_login()
    else:
        return show_the_login_form()
```

| 方法 | 名称   | 描述                                                                                                                                     |
| ---- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | GET    | 请求指定的页面信息，并返回实体主体。                                                                                                     |
| 2    | POST   | 向指定资源提交数据进行处理请求（例如提交表单或者上传文件）。数据被包含在请求体中。POST 请求可能会导致新的资源的建立和/或已有资源的修改。 |
| 3    | PUT    | 从客户端向服务器传送的数据取代指定的文档的内容。                                                                                         |
| 4    | DELETE | 请求服务器删除指定的页面。                                                                                                               |

#### 重定向

网页跳转

```python
from flask import abort, redirect

@app.route('/bilibili')
def index():
    return redirect("https://www.bilibili.com")
```

#### POST

```python
@app.route('/test/post', methods=['POST'])
def post():
    print('gooooooood')
    my_json = request.get_json()
    print(my_json)
    name = my_json.get('name')+u'大帅哥'
    age = my_json.get('age')
    if all([name, age]):
        # return my_json.get('name') + ' is ' + str(my_json.get('age')) + ' years old.'
        return jsonify(name=name, age=age)
    else:
        return "Request failed!"
```

### Cookies

要访问 cookies ，可以使用 `cookies` 属性。可以使用响应 对象 的 `set_cookie` 方法来设置 cookies 。

请求对象的 `cookies` 属性是一个包含了客户端传输的所有 cookies 的字典。

在 Flask 中，如果使用会话（Session），那么就不要直接使用 cookies ，因为会话比较安全一些。

读取 cookies:

```python
from flask import request

@app.route('/')
def index():
    username = request.cookies.get('username')
    # use cookies.get(key) instead of cookies[key] to not get a
    # KeyError if the cookie is missing.
```

储存 cookies:

```python
from flask import make_response

@app.route('/')
def index():
    resp = make_response(render_template(...))
    resp.set_cookie('username', 'the username')
    return resp
```

### Sessions

```python
from . import admin
from app import db
from flask import request, jsonify, current_app, session
from app.models import Admin, AdminLoginLog
from app.utils.tool import admin_login_required


# 登录
@admin.route("/login", methods=["POST"])
def login():
    """用户的登录"""
    # 获取参数
    req_dict = request.get_json()
    username = req_dict.get("username")
    password = req_dict.get("password")

    # 校验参数
    # 参数完整的校验
    if not all([username, password]):
        return jsonify(re_code=400, msg="参数不完整")

    try:
        admin_info = Admin.query.filter_by(username=username).first()
    except Exception as e:
        current_app.logger.error(e)
        return jsonify(re_code=400, msg="获取用户信息失败")

    # 用数据库的密码与用户填写的密码进行对比验证
    if admin_info is None or admin_info.password != password:
        return jsonify(re_code=400, msg="用户名或密码错误")

    # 添加管理员登录日志
    ip_addr = request.remote_addr  # 获取管理员登录的ip
    admin_login_log = AdminLoginLog(admin_id=admin_info.id, ip=ip_addr)
    try:
        db.session.add(admin_login_log)
        db.session.commit()
    except:
        db.session.rollback()

    # 如果验证相同成功，保存登录状态， 在session中
    session["username"] = admin_info.username
    session["admin_id"] = admin_info.id
    session["avatar"] = admin_info.avatar

    return jsonify(re_code=200, msg="登录成功")


# 检查登陆状态
@admin.route("/session", methods=["GET"])
def check_login():
    """检查登陆状态"""
    # 尝试从session中获取用户的名字
    username = session.get("username")
    admin_id = session.get('admin_id')
    avatar = session.get("avatar")
    # 如果session中数据username名字存在，则表示用户已登录，否则未登录
    if username is not None:
        return jsonify(re_code=200, msg="true",
                       data={"username": username, "admin_id": admin_id, "avatar": avatar})
    else:
        return jsonify(re_code=400, msg="管理员未登录")


# 登出
@admin.route("/session", methods=["DELETE"])
@admin_login_required
def logout():
    """登出"""
    # 清除session数据
    session.clear()
    return jsonify(re_code=200, msg="成功退出登录!")
```

