# 一、 request API

## 1.1 模块

- *requests.request(method, url, **kwargs)*
- *requests.get(url, params=None, **kwargs)*
- *requests.options(url, **kwargs)*
- *requests.head(url, **kwargs)*
- *requests.post(url, data=None, json=None, **kwargs)*
- *requests.put(url, data=None, **kwargs)*
- *requests.patch(url, data=None, **kwargs)*
- *requests.delete(url, **kwargs)*

除了`requests.request()`外，其余7个方法与http协议中的请求方法一一对应。这7个方法其实都是在调用`requests.request()`方法

| method          | 简述                                                         |
| --------------- | ------------------------------------------------------------ |
| url             | 请求的url                                                    |
| params          | 请求携带的params                                             |
| data            | 请求body中的data                                             |
| json            | 请求body中的json格式的data                                   |
| headers         | 请求携带的headers                                            |
| cookies         | 请求携带的cookies                                            |
| files           | 上传文件时使用                                               |
| auth            | 身份认证时使用                                               |
| timeout         | 设置请求的超时时间，可以设置连接超时和读取超时               |
| allow_redirects | 是否允许重定向，默认True，即允许重定向                       |
| proxies         | 设置请求的代理，支持http代理以及socks代理（需要安装第三方库"pip install requests[socks]"） |
| verify          | 用于https请求时的ssl证书验证，默认是开启的，如果不需要则设置为False即可 |
| stream          | 是否立即下载响应内容，默认是False，即立即下载响应内容        |
| cert            | 用于指定本地文件用作客户端证书                               |

## 1.2 基本调用

```python
import requests
r = requests.request('get','https://api.github.com/events')
r = requests.get('https://api.github.com/events')
r = requests.post('http://httpbin.org/post', data = {'key':'value'})
r = requests.put('http://httpbin.org/put', data = {'key':'value'})
r = requests.delete('http://httpbin.org/delete')
r = requests.head('http://httpbin.org/get')
r = requests.options('http://httpbin.org/get')
```

返回`Response`对象

 ## 1.3 param

接受一个字典，用于传递URL参数

```python
payload = {'key1': 'value1', 'key2': 'value2'}
r = requests.get("http://httpbin.org/get", params=payload)
print(r.url)
```

输出

```
http://httpbin.org/get?key1=value1&key2=value2
```

## 1.4 headers

接受一个字典，用于传递header参数（请求头）

```python
url = 'https://tophub.today/n/mproPpoq6O'
headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36'
}
s = requests.get(url,headers=headers)
```

## 1.5 data

用于POST请求中，传递请求体中的data参数

## 1.6 json

用于POST请求中，传递请求体中json格式的的data参数

## 1.7 files

上传文件

## 1.8 cookies

用于传递cookies参数，不过将cookies写在headers中比较方便

## 1.9 verify

用于https请求时的ssl证书验证，默认是开启的，如果不需要则设置为False即可

## 1.10 proxies

设置请求的代理，支持http代理以及socks代理（需要安装第三方库"pip install requests[socks]"）

## 1.11 timeout

设置请求的超时时间，可以设置连接超时和读取超时

## 1.12 auth

身份认证时使用

## 1.13 allow_redirects

是否允许重定向，默认True，即允许重定向

# 二、response对象

response类故名思议，它包含了服务器对http请求的响应。每次调用requests去请求之后，均会返回一个response对象，通过调用该对象，可以查看具体的响应信息

## 2.1 r.url

请求的最终地址

## 2.2 r.request

PreparedRequest对象，可以用于查看发送请求时的信息，比如r.request.headers查看请求头

## 2.3 r.text

响应的内容，unicode类型

## 2.4 r.content

响应的内容，byte类型（二进制）

## 2.5 r.status_code

响应的http状态码

## 2.6 r.links

响应的解析头链接

## 2.7 r.history

请求的历史记录，可以用于查看重定向信息，以列表形式展示，排序方式是从最旧到最新的请求

## 2.8 r.reason

响应状态的描述，比如 "Not Found" or "OK"

## 2.9 r.cookies

服务器发回的cookies，RequestsCookieJar类型

## 2.10 r.json()

用于将响应解析成JSON格式，即将返回结果是JSON格式的字符串转化为字典

如果返回结果不是JSON格式，便会出现解析错误，抛出`json.decoder.JSONDecodeError`异常

# 三、session对象

## 3.1 会话维持

requests中的session对象能够让我们跨http请求保持某些参数，即让同一个session对象发送的请求头携带某个指定的参数。当然，最常见的应用是它可以让cookie保持在后续的一串请求中

即，利用Session对象，可以方便地维护一个会话

```python
import requests
# tips: http://httpbin.org能够用于测试http请求和响应
s = requests.Session() 											#第一步：发送一个请求，用于设置请求中的cookies
s.get('http://httpbin.org/cookies/set/sessioncookie/123456789') #第二步：再发送一个请求，用于查看当前请求中的cookies
r = s.get("http://httpbin.org/cookies")
print(r.text)
```

输出

```python
{
  "cookies": {
    "sessioncookie": "123456789"
  }
}
```

第二次请求已经携带上了第一次请求所设置的cookie，即通过session达到了保持cookie的目的

session让请求之间具有了连贯性

## 3.2 s.cookies.update()

用于设置请求中的cookies，方便实现跨参数请求，即能够在前后请求之间保持cookie

传入参数：字典

```python
import requests

s = requests.session()
s.cookies.update({'cookies_are': 'cookie'})
r = s.get(url='http://httpbin.org/cookies')
print(r.text)
```

输出

```python
{
  "cookies": {
    "cookies_are": "cookie"
  }
}
```

