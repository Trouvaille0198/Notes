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

 ## 1.3 param

用于传递URL参数

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

用于传递header参数（请求头）

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

