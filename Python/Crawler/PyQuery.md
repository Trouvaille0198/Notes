# 一、初始化

```python
from pyquery import PyQuery as pq
```

## 1.1 字符初始化

```python
html = '''
<div>
    <ul>
         <li class="item-0">first item</li>
         <li class="item-1"><a href="link2.html">second item</a></li>
         <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
         <li class="item-1 active"><a href="link4.html">fourth item</a></li>
         <li class="item-0"><a href="link5.html">fifth item</a></li>
     </ul>
 </div>
'''

doc = pq(html)
```

## 1.2 URL初始化

```python
doc = pq(url="http://www.baidu.com",encoding='utf-8')
# 或
doc = pq(requests.get('http://cuiqingcai.com').text)
```

## 1.3 文件初始化

```python
doc = pq(filename='demo.html')
```



pyquery 的选择结果可能是多个节点，也可能是单个节点，类型都是 PyQuery 类型，并没有返回像 Beautiful Soup 那样的列表。