# 一、认识

> Asynchronous HTTP Client/Server for asyncio and Python.

用于 asyncio 和 Python 的异步 HTTP 客户端/服务器。

## 1.1 同步与异步的比较

同步

```python
from datetime import datetime

import requests
from lxml import etree

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit"
                         "/537.36 (KHTML, like Gecko) "
                         "Chrome/72.0.3626.121 Safari/537.36"}


def get_movie_url():
    req_url = "https://movie.douban.com/chart"
    response = requests.get(url=req_url, headers=headers)
    html = etree.HTML(response.text)
    movies_url = html.xpath(
        "//*[@id='content']/div/div[1]/div/div/table/tr/td/a/@href")
    return movies_url


def get_movie_content(movie_url):
    response = requests.get(movie_url, headers=headers)
    result = etree.HTML(response.text)
    movie = dict()
    name = result.xpath('//*[@id="content"]/h1/span[1]//text()')
    author = result.xpath('//*[@id="info"]/span[1]/span[2]//text()')
    movie["name"] = name
    movie["author"] = author
    return movie


if __name__ == '__main__':
    start = datetime.now()
    movie_url_list = get_movie_url()
    movies = dict()
    for url in movie_url_list:
        movies[url] = get_movie_content(url)
    print(movies)
    print("同步用时为：{}".format(datetime.now() - start))
```

异步

```python
import asyncio
from datetime import datetime

import aiohttp
from lxml import etree
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit"
                         "/537.36 (KHTML, like Gecko) "
                         "Chrome/72.0.3626.121 Safari/537.36"}


async def get_movie_url():
    req_url = "https://movie.douban.com/chart"
    async with aiohttp.ClientSession(headers=headers) as session:
        async with session.get(url=req_url, headers=headers) as response:
            result = await response.text()
            result = etree.HTML(result)
        return result.xpath("//*[@id='content']/div/div[1]/div/div/table/tr/td/a/@href")


async def get_movie_content(movie_url):
    async with aiohttp.ClientSession(headers=headers) as session:
        async with session.get(url=movie_url, headers=headers) as response:
            result = await response.text()
            result = etree.HTML(result)
        movie = dict()
        name = result.xpath('//*[@id="content"]/h1/span[1]//text()')
        author = result.xpath('//*[@id="info"]/span[1]/span[2]//text()')
        movie["name"] = name
        movie["author"] = author
    return movie

if __name__ == '__main__':
    start = datetime.now()
    loop = asyncio.get_event_loop()
    movie_url_list = loop.run_until_complete(get_movie_url())
    tasks = [get_movie_content(url) for url in movie_url_list]
    movies = loop.run_until_complete(asyncio.gather(*tasks))
    print(movies)
    print("异步用时为：{}".format(datetime.now() - start))
```

# 二、客户端

```python
import aiohttp
import asyncio

async def main():
    async with aiohttp.ClientSession() as session:
        async with session.get('http://httpbin.org/get') as resp:
            print(resp.status)
            print(await resp.text())

asyncio.run(main())
```

通过`status`来获取响应状态码，`text()`来获取到响应内容

读取二进制内容使用 `read()` 方法

用法与 `requests` 类似

# 三、服务端

```python
from aiohttp import web


async def handle(request):
    name = request.match_info.get('name', "Anonymous")
    text = "Hello, " + name
    return web.Response(text=text)

app = web.Application()
app.add_routes([web.get('/', handle),
                web.get('/{name}', handle)])

if __name__ == '__main__':
    web.run_app(app)
```

