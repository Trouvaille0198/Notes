#  request API

## 模块

- *requests.request(method, url, **kwargs)*
- *requests.get(url, params=None, **kwargs)*
- *requests.options(url, **kwargs)*
- *requests.head(url, **kwargs)*
- *requests.post(url, data=None, json=None, **kwargs)*
- *requests.put(url, data=None, **kwargs)*
- *requests.patch(url, data=None, **kwargs)*
- *requests.delete(url, **kwargs)*

除了`requests.request()`外，其余7个方法与http协议中的请求方法一一对应。这7个方法其实都是在调用`requests.request()`方法

| method          | 简述                                                                                       |
| --------------- | ------------------------------------------------------------------------------------------ |
| url             | 请求的url                                                                                  |
| params          | 请求携带的params                                                                           |
| data            | 请求body中的data                                                                           |
| json            | 请求body中的json格式的data                                                                 |
| headers         | 请求携带的headers                                                                          |
| cookies         | 请求携带的cookies                                                                          |
| files           | 上传文件时使用                                                                             |
| auth            | 身份认证时使用                                                                             |
| timeout         | 设置请求的超时时间，可以设置连接超时和读取超时                                             |
| allow_redirects | 是否允许重定向，默认True，即允许重定向                                                     |
| proxies         | 设置请求的代理，支持http代理以及socks代理（需要安装第三方库"pip install requests[socks]"） |
| verify          | 用于https请求时的ssl证书验证，默认是开启的，如果不需要则设置为False即可                    |
| stream          | 是否立即下载响应内容，默认是False，即立即下载响应内容                                      |
| cert            | 用于指定本地文件用作客户端证书                                                             |

## 基本调用

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

 ## param

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

## headers

接受一个字典，用于传递header参数（请求头）

```python
url = 'https://tophub.today/n/mproPpoq6O'
headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36'
}
s = requests.get(url,headers=headers)
```

## data

用于POST请求中，传递请求体中的data参数

该网站可以判断如果请求是POST方式，就把相关请求信息返回

```python
data = {'name': 'germey', 'age': '22'}
r = requests.post("http://httpbin.org/post", data=data)
print(r.text)
```

输出

```
{
  "args": {}, 
  "data": "", 
  "files": {}, 
  "form": {
    "age": "22", 
    "name": "germey"
  }, 
  "headers": {
    "Accept": "*/*", 
    "Accept-Encoding": "gzip, deflate", 
    "Content-Length": "18", 
    "Content-Type": "application/x-www-form-urlencoded", 
    "Host": "httpbin.org", 
    "User-Agent": "python-requests/2.25.0", 
    "X-Amzn-Trace-Id": "Root=1-5fe43f55-5d4750b76935f7515662c3b3"
  }, 
  "json": null, 
  "origin": "59.79.2.148", 
  "url": "http://httpbin.org/post"
}
```

## json

用于POST请求中，传递请求体中json格式的的data参数

## files

上传文件

```python
import requests
files = {'file': open('favicon.ico', 'rb')}
r = requests.post("http://httpbin.org/post", files=files)
print(r.text)
```

## cookies

用于传递cookies参数，不过将cookies写在headers中比较方便

```python
import requests
r = requests.get("https://www.baidu.com")
print(r.cookies)
for key, value in r.cookies.items():
    print(key + '=' + value)
```

输出

```html
<RequestsCookieJar[<Cookie BDORZ=27315 for .baidu.com/>]>
BDORZ=27315
```

步骤

1. 调用cookies属性，得到Cookies，可以发现它是RequestCookieJar类型
2. 用items()方法将其转化为元组组成的列表，遍历输出每一个Cookie的名称和值，实现Cookie的遍历解析

## verify

用于https请求时的ssl证书验证，默认是开启的，如果不需要则设置为False即可

例：请求一个HTTPS站点，但是证书验证错误的页面时，把verify参数设置为False

```python
import requests
response = requests.get('https://www.12306.cn', verify=False)
print(response.status_code)
```

输出

```html
D:\Application\Anaconda\lib\site-packages\urllib3\connectionpool.py:988: InsecureRequestWarning: Unverified HTTPS request is being made to host 'www.12306.cn'. Adding certificate verification is strongly advised. See: https://urllib3.readthedocs.io/en/latest/advanced-usage.html#ssl-warnings
  InsecureRequestWarning,
200
```

报了一个警告，它建议我们给它指定证书

- 可以通过设置忽略警告的方式来屏蔽这个警告

```python
from requests.packages import urllib3
urllib3.disable_warnings()
```

- 或者通过捕获警告到日志的方式忽略警告

```python
import logging
logging.captureWarnings(True)
```

- 可以指定一个本地证书用作客户端证书

```python
import requests
response = requests.get('https://www.12306.cn',
                        cert=('/path/server.crt', '/path/key'))
print(response.status_code)
```

我们需要有crt和key文件，并且指定它们的路径。注意，本地私有证书的key必须是解密状态，加密状态的key是不支持的

## proxies

设置请求的代理，支持http代理以及socks代理（需要安装第三方库"pip install requests[socks]"）

```python
import requests
proxies = {
	"http": "http://10.10.1.10:3128",
	"https": "http://10.10.1.10:1080",
}
requests.get("https://www.taobao.com", proxies=proxies)
```

- 若代理需要使用HTTP Basic Auth，可以使用类似[http://user](http://user/):password@host:port这样的语法来设置代理

```python
proxies = {
    "http": "http://user:password@10.10.1.10:3128/",
}
```

- 使用SOCKS协议代理

```python
proxies = {
	'http': 'socks5://user:password@host:port',
	'https': 'socks5://user:password@host:port'
}
```

## timeout

设置请求的超时时间，（发出请求到服务器返回响应的时间），可以设置连接超时和读取超时

```python
import requests
r = requests.get("https://www.taobao.com", timeout=1)
print(r.status_code)
```

- 请求分为两个阶段，即连接（connect）和读取（read）。上面设置的timeout将用作连接和读取这二者的timeout总和

- 如果想永久等待，可以直接将timeout设置为None，或者不设置直接留空，因为默认是None

## auth

身份认证时使用

```python
import requests
from requests.auth import HTTPBasicAuth
r = requests.get('http://localhost:5000',
                 auth=HTTPBasicAuth('username', 'password'))
print(r.status_code)
```

如果用户名和密码正确的话，请求时就会自动认证成功，会返回200状态码，如果认证失败，则返回401状态码

- 直接传一个元组

  它会默认使用HTTPBasicAuth这个类来认证

```python
r = requests.get('http://localhost:5000', auth=('username', 'password'))
```

- 使用OAuth1认证

```python
import requests
from requests_oauthlib import OAuth1
url = 'https://api.twitter.com/1.1/account/verify_credentials.json'
auth = OAuth1('YOUR_APP_KEY', 'YOUR_APP_SECRET',
              'USER_OAUTH_TOKEN', 'USER_OAUTH_TOKEN_SECRET')
requests.get(url, auth=auth)
```



## allow_redirects

是否允许重定向，默认True，即允许重定向

# response对象

response类故名思议，它包含了服务器对http请求的响应。每次调用requests去请求之后，均会返回一个response对象，通过调用该对象，可以查看具体的响应信息

以下是response对象的部分属性

## .url

请求的最终地址

```python
print(type(r.url), r.url)
>>> <class 'str'> https://static1.scrape.center/
```

## .request

PreparedRequest对象，可以用于查看发送请求时的信息，比如r.request.headers查看请求头

## .text

响应的内容，unicode类型

```python
print(type(r.text), r.text)
>>> <class 'str'> "HTML的内容"
```

## .content

响应的内容，byte类型（二进制）

一般在抓取图像时有用

## .status_code

响应的http状态码

```python
print(type(r.status_code), r.status_code)
>>> <class 'int'> 500
```

## .links

响应的解析头链接

## .history

请求的历史记录，可以用于查看重定向信息，以列表形式展示，排序方式是从最旧到最新的请求

```python
print(type(r.history), r.history)
>>> <class 'list'> []
```

## .reason

响应状态的描述，比如 "Not Found" or "OK"

## .cookies

服务器发回的cookies，RequestsCookieJar类型

```python
print(type(r.cookies), r.cookies)
>>> <class 'requests.cookies.RequestsCookieJar'> <RequestsCookieJar[]>
```

## .json()

用于将响应解析成JSON格式，即将返回结果是JSON格式的字符串转化为字典

如果返回结果不是JSON格式，便会出现解析错误，抛出`json.decoder.JSONDecodeError`异常

## .headers()

响应头，可单独取出某个字段的值，比如(r.headers)['content-type']

```python
print(type(r.headers), r.headers)
>>> <class 'requests.structures.CaseInsensitiveDict'> {'Server': 'nginx/1.17.8', 'Date': 'Tue, 27 Oct 2020 15:10:32 GMT', 'Content-Type': 'text/html', 'Content-Length': '145', 'Connection': 'keep-alive', 'X-Frame-Options': 'DENY', 'Vary': 'Cookie', 'X-Content-Type-Options': 'nosniff', 'Strict-Transport-Security': 'max-age=15724800; includeSubDomains'}
```

# session对象

## 会话维持

requests 中的 session 对象能够让我们跨http请求保持某些参数，即让同一个 session 对象发送的请求头携带某个指定的参数。当然，最常见的应用是它可以让 cookie 保持在后续的一串请求中

即，利用 Session 对象，可以方便地维护一个会话

```python
import requests
# tips: http://httpbin.org能够用于测试http请求和响应
s = requests.Session() 											
s.get('http://httpbin.org/cookies/set/sessioncookie/123456789') #第一步：发送一个请求，用于设置请求中的cookies
r = s.get("http://httpbin.org/cookies") 						#第二步：再发送一个请求，用于查看当前请求中的cookies
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

## s.cookies.update()

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

#  状态码查询对象 requests.codes

```python
exit() if not r.status_code == requests.codes.ok else print('Request Successfully!')
```

返回码和相应的查询条件

```python
# 信息性状态码
100: ('continue',),
101: ('switching_protocols',),
102: ('processing',),
103: ('checkpoint',),
122: ('uri_too_long', 'request_uri_too_long'),

# 成功状态码
200: ('ok', 'okay', 'all_ok', 'all_okay', 'all_good', '\\o/', '✓'),
201: ('created',),
202: ('accepted',),
203: ('non_authoritative_info', 'non_authoritative_information'),
204: ('no_content',),
205: ('reset_content', 'reset'),
206: ('partial_content', 'partial'),
207: ('multi_status', 'multiple_status', 'multi_stati', 'multiple_stati'),
208: ('already_reported',),
226: ('im_used',),

# 重定向状态码
300: ('multiple_choices',),
301: ('moved_permanently', 'moved', '\\o-'),
302: ('found',),
303: ('see_other', 'other'),
304: ('not_modified',),
305: ('use_proxy',),
306: ('switch_proxy',),
307: ('temporary_redirect', 'temporary_moved', 'temporary'),
308: ('permanent_redirect',
      'resume_incomplete', 'resume',), # These 2 to be removed in 3.0

# 客户端错误状态码
400: ('bad_request', 'bad'),
401: ('unauthorized',),
402: ('payment_required', 'payment'),
403: ('forbidden',),
404: ('not_found', '-o-'),
405: ('method_not_allowed', 'not_allowed'),
406: ('not_acceptable',),
407: ('proxy_authentication_required', 'proxy_auth', 'proxy_authentication'),
408: ('request_timeout', 'timeout'),
409: ('conflict',),
410: ('gone',),
411: ('length_required',),
412: ('precondition_failed', 'precondition'),
413: ('request_entity_too_large',),
414: ('request_uri_too_large',),
415: ('unsupported_media_type', 'unsupported_media', 'media_type'),
416: ('requested_range_not_satisfiable', 'requested_range', 'range_not_satisfiable'),
417: ('expectation_failed',),
418: ('im_a_teapot', 'teapot', 'i_am_a_teapot'),
421: ('misdirected_request',),
422: ('unprocessable_entity', 'unprocessable'),
423: ('locked',),
424: ('failed_dependency', 'dependency'),
425: ('unordered_collection', 'unordered'),
426: ('upgrade_required', 'upgrade'),
428: ('precondition_required', 'precondition'),
429: ('too_many_requests', 'too_many'),
431: ('header_fields_too_large', 'fields_too_large'),
444: ('no_response', 'none'),
449: ('retry_with', 'retry'),
450: ('blocked_by_windows_parental_controls', 'parental_controls'),
451: ('unavailable_for_legal_reasons', 'legal_reasons'),
499: ('client_closed_request',),

# 服务端错误状态码
500: ('internal_server_error', 'server_error', '/o\\', '✗'),
501: ('not_implemented',),
502: ('bad_gateway',),
503: ('service_unavailable', 'unavailable'),
504: ('gateway_timeout',),
505: ('http_version_not_supported', 'http_version'),
506: ('variant_also_negotiates',),
507: ('insufficient_storage',),
509: ('bandwidth_limit_exceeded', 'bandwidth'),
510: ('not_extended',),
511: ('network_authentication_required', 'network_auth', 'network_authentication')
```

# 异常处理

***requests.exceptions.ConnectionError***

1. http 的连接数超过最大限制，默认的情况下连接是 Keep-alive 的，所以这就导致了服务器保持了太多连接而不能再新建连接。
2. ip 被封
3. 程序请求速度过快。

```dart
try:
	response = requests.get(url)
except requests.exceptions.ConnectionError:
	print('error!')
    continue
```